"""
We want to patch out WorkBuddy's CLI sandbox.

Otherwise a 4GB address space limit will prevent some tools from working.
"""
import re
from pathlib import Path

print("Welcome to the WorkBuddy sandbox.cli Patching Script.")

ASAR = Path("/opt/WorkBuddy/resources/app.asar")
print(f"We are working on path {ASAR!r}.")

# WorkBuddy forces `env[WORKBUDDY_ENABLE_LINUX_SANDBOX_CLI] = "1"` on Linux.
# Match both bare and quoted key forms, and both quote styles for the value.
PATTERN = (rb'((?:process\.)?env\s*\[\s*[^]\n]*WORKBUDDY_ENABLE_'
           rb'LINUX_SANDBOX_CLI[^]\n]*\]\s*=\s*)(["\'])1\2')

data = ASAR.read_bytes()
patched, count = re.subn(
    PATTERN, lambda m: m.group(1) + m.group(2) + b"0" + m.group(2), data)
if count == 0:
    print("ERROR: no forced sandbox assignment found; This WorkBuddy build"
          "controls the flag differently.")
else:
    ASAR.write_bytes(patched)
    print(f'Patched {count} forced sandbox assignment(s) to "0".')

print("WorkBuddy sandbox.cli Patching Script completed.")
