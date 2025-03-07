# Postfix Mail Queue Monitor

This script monitors the Postfix mail queue, displays it on a web page, and sends an alert to Microsoft Teams if the queue exceeds 5 emails for more than 10 seconds.

## Features

- Monitors the Postfix mail queue in real-time.
- Provides a web interface to view the queue.
- Sends an alert to Microsoft Teams when the queue exceeds the defined threshold.
- Runs as a systemd service for automatic startup and recovery.

## Dependencies

The following dependencies are required for this script to run:

- Python 3
- pip3
- Flask (Python library)
- Requests (Python library)

The installation script will automatically install or update these dependencies if they are missing.

## Installation

1. Clone the Repository

   git clone https://github.com/yourusername/postfix-monitor.git
   cd postfix-monitor

2. Make the Installer Executable

   chmod +x install.sh

3. Run the Installer

   sudo ./install.sh

4. Enter your Microsoft Teams Webhook URL when prompted.

## Usage

The script runs automatically as a systemd service.

To check the mail queue, open a browser and go to:

   http://your-server-ip:5000/queue

To check the service status:

   sudo systemctl status postfix_monitor

To view logs:

   journalctl -u postfix_monitor -f

## Managing the Service

Stop the service:

   sudo systemctl stop postfix_monitor

Restart the service:

   sudo systemctl restart postfix_monitor

Disable autostart:

   sudo systemctl disable postfix_monitor

## Uninstallation

To remove the service and script:

   sudo systemctl stop postfix_monitor
   sudo systemctl disable postfix_monitor
   sudo rm /usr/local/bin/postfix_monitor.py
   sudo rm /etc/systemd/system/postfix_monitor.service
   sudo systemctl daemon-reload

## Notes

- Ensure Postfix is installed and running on your server.
- Modify QUEUE_THRESHOLD and ALERT_DELAY in postfix_monitor.py if needed.

## License

MIT License
