
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

   `git clone https://github.com/Sillver101/postfix-monitor.git`
   `cd postfix-monitor`

2. Make the Installer Executable

   `chmod +x install.sh`

3. Run the Installer

   `sudo ./install.sh`

4. Enter your Microsoft Teams Webhook URL when prompted.
   - During the installation, you will be asked to provide your Microsoft Teams Webhook URL. This URL will be used to send alerts when the Postfix mail queue exceeds the defined threshold.
   - You will also be asked for the `QUEUE_THRESHOLD` (default: 5) and `ALERT_DELAY` (default: 10 seconds), which are the configuration parameters for the script.

## Configuration

The configuration for the script is stored in a separate file located at `/etc/postfix_monitor_config.ini`. This allows you to modify key parameters without editing the script directly.

### Configuration Options:
1. **TEAMS_WEBHOOK_URL**:  
   The Microsoft Teams webhook URL used to send alerts when the mail queue exceeds the threshold.

2. **QUEUE_THRESHOLD**:  
   The number of emails in the queue that will trigger an alert if exceeded. Default is 5.

3. **ALERT_DELAY**:  
   The number of seconds the queue must stay above the threshold before sending an alert. Default is 10 seconds.

### Example Configuration File (`postfix_monitor_config.ini`):

```
# Postfix Mail Queue Monitor Configuration File

# Microsoft Teams Webhook URL
# This URL is used to send alerts when the mail queue exceeds the threshold.
TEAMS_WEBHOOK_URL = "https://outlook.office.com/webhook/..."

# Queue Threshold
# This is the number of emails in the queue that will trigger an alert if exceeded.
# Default value: 5
QUEUE_THRESHOLD = 5

# Alert Delay
# This is the number of seconds the queue must stay above the threshold before sending an alert.
# Default value: 10 seconds
ALERT_DELAY = 10
```

To modify these parameters, simply edit the configuration file using any text editor, for example:

`sudo nano /etc/postfix_monitor_config.ini`

## Usage

The script runs automatically as a systemd service.

To check the mail queue, open a browser and go to:

   `http://your-server-ip:5000/queue`

To check the service status:

   `sudo systemctl status postfix_monitor`

To view logs:

   `journalctl -u postfix_monitor -f`

## Managing the Service

Stop the service:

   `sudo systemctl stop postfix_monitor`

Restart the service:

   `sudo systemctl restart postfix_monitor`

Disable autostart:

   `sudo systemctl disable postfix_monitor`

## Uninstallation

To remove the service and script:

```
sudo systemctl stop postfix_monitor
sudo systemctl disable postfix_monitor
sudo rm /usr/local/bin/postfix_monitor.py
sudo rm /etc/systemd/system/postfix_monitor.service
sudo systemctl daemon-reload
```

## Notes

- Ensure Postfix is installed and running on your server.
- Modify the configuration in `/etc/postfix_monitor_config.ini` for `QUEUE_THRESHOLD`, `ALERT_DELAY`, or `TEAMS_WEBHOOK_URL` as needed. No need to edit the script directly.

## License

MIT License
