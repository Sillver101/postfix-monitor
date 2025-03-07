# Postfix Mail Queue Monitor

This script monitors the Postfix mail queue, displays it on a web page, and sends an alert to Microsoft Teams if the queue exceeds 5 emails for more than 10 seconds.

## Features
- Monitors the Postfix mail queue in real-time.
- Provides a web interface to view the queue.
- Sends an alert to Microsoft Teams when the queue exceeds the defined threshold.
- Runs as a systemd service for automatic startup and recovery.

## Installation

### 1. Clone the Repository
```bash
git clone https://github.com/Sillver101/postfix-monitor.git
cd postfix-monitor
```

### 2. Make the Installer Executable
```bash
chmod +x install.sh
```

### 3. Run the Installer
```bash
sudo ./install.sh
```

### 4. Enter your Microsoft Teams Webhook URL when prompted.

## Usage
- The script runs automatically as a systemd service.
- To check the mail queue, open a browser and go to:
  ```
  http://your-server-ip:5000/queue
  ```
- To check the service status:
  ```bash
  sudo systemctl status postfix_monitor
  ```
- To view logs:
  ```bash
  journalctl -u postfix_monitor -f
  ```

## Managing the Service
- Stop the service:
  ```bash
  sudo systemctl stop postfix_monitor
  ```
- Restart the service:
  ```bash
  sudo systemctl restart postfix_monitor
  ```
- Disable autostart:
  ```bash
  sudo systemctl disable postfix_monitor
  ```

## Uninstallation
To remove the service and script:
```bash
sudo systemctl stop postfix_monitor
sudo systemctl disable postfix_monitor
sudo rm /usr/local/bin/postfix_monitor.py
sudo rm /etc/systemd/system/postfix_monitor.service
sudo systemctl daemon-reload
```

## Notes
- Ensure Postfix is installed and running on your server.
- Modify `QUEUE_THRESHOLD` and `ALERT_DELAY` in `postfix_monitor.py` if needed.

## License
MIT License

