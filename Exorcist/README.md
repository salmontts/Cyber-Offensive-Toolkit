# Exorcist.ps1

A PowerShell script to detect and remove malware hidden in `dllhost.exe` and related persistence mechanisms.

## Features

- Detects suspicious `dllhost.exe` processes and terminates them.
- Cleans WMI backdoors.
- Removes suspicious scheduled tasks.
- Cleans suspicious entries from Windows Registry `Run` keys.

## Usage

1. **Run as Administrator!**
2. Open PowerShell, navigate to the script directory, and execute:

   ```powershell
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\Exorcist.ps1
   ```

3. The script logs its actions to `exorcist_log.txt` on your Desktop.

## Requirements

- Windows 10/11 (should work on Windows 7+)
- PowerShell 5.1 or newer

## Notes

- The script may need to be adapted for non-English Windows installations (log path, registry paths).
- Use at your own risk.

## License

MIT