#!/bin/bash -

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now installing WorkBuddy."

dpkg -i /tmp/WorkBuddy.deb

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Enabling the Chrome Sandbox used by WorkBuddy (1)."
chown root:root /opt/WorkBuddy/chrome-sandbox

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Enabling the Chrome Sandbox used by WorkBuddy (2)."
chmod 4755 /opt/WorkBuddy/chrome-sandbox

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Enabling the Chrome Sandbox used by WorkBuddy (3)."
echo "kernel.unprivileged_userns_clone=1" | tee /etc/sysctl.d/99-userns.conf

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now patching WorkBuddy binary to not use sandbox-cli, because otherwise some tools cannot be used."
python3 /tmp/workbuddy_cli_sandbox_patch.py

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done installing WorkBuddy."
