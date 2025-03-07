#!/bin/bash

# Install or update dependencies
echo "Installing dependencies..."
sudo apt update && sudo apt install -y python3 python3-pip
pip3 install --upgrade flask requests

# Ask for Teams webhook URL
echo "Enter your Microsoft Teams webhook URL: "
read TEAMS_WEBHOOK_URL

# Create the monitoring script
cat << EOF | sudo tee /usr/local/bin/postfix_monitor.py > /dev/null
import time
import subprocess
import threading
import requests
from flask import Flask, jsonify

TEAMS_WEBHOOK_URL = "$TEAMS_WEBHOOK_URL"
QUEUE_THRESHOLD = 5
ALERT_DELAY = 10
CHECK_INTERVAL = 5

app = Flask(__name__)
mail_queue = []
alert_triggered = False

def get_mail_queue():
    result = subprocess.run(['postqueue', '-p'], capture_output=True, text=True)
    lines = result.stdout.split("\n")
    queue_count = sum(1 for line in lines if line and line[0].isdigit())
    return queue_count, lines

def send_teams_alert(count):
    message = {"text": f"Alert: Postfix mail queue has {count} emails!"}
    requests.post(TEAMS_WEBHOOK_URL, json=message)

def monitor_queue():
    global alert_triggered
    start_time = None
    
    while True:
        queue_count, lines = get_mail_queue()
        mail_queue.clear()
        mail_queue.extend(lines)

        if queue_count > QUEUE_THRESHOLD:
            if start_time is None:
                start_time = time.time()
            elif time.time() - start_time >= ALERT_DELAY and not alert_triggered:
                send_teams_alert(queue_count)
                alert_triggered = True
        else:
            start_time = None
            alert_triggered = False
        
        time.sleep(CHECK_INTERVAL)

@app.route("/queue")
def queue_status():
    return jsonify({"queue": mail_queue})

if __name__ == "__main__":
    threading.Thread(target=monitor_queue, daemon=True).start()
    app.run(host="0.0.0.0", port=5000)
EOF

# Make script executable
sudo chmod +x /usr/local/bin/postfix_monitor.py

# Create systemd service
cat << EOF | sudo tee /etc/systemd/system/postfix_monitor.service > /dev/null
[Unit]
Description=Postfix Mail Queue Monitor
After=network.target

[Service]
ExecStart=/usr/bin/python3 /usr/local/bin/postfix_monitor.py
Restart=always
User=root
WorkingDirectory=/usr/local/bin

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd, enable and start the service
echo "Enabling and starting the service..."
sudo systemctl daemon-reload
sudo systemctl enable postfix_monitor
sudo systemctl start postfix_monitor

# Confirm installation
echo "Installation complete!"
echo "You can check the queue at: http://your-server-ip:5000/queue"
echo "To check service status: sudo systemctl status postfix_monitor"
