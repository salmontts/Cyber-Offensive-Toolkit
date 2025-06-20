# 🕵️ SnitchHunter.ps1

**SnitchHunter** is a lightweight PowerShell script that monitors newly spawned processes in real-time.  
It logs the process name, PID, parent PID, and full executable path to help identify suspicious or stealthy activity on Windows systems.

---

## 🔧 Features

- Detects every **new process** launched in the system
- Logs the following:
  - 🔹 Process Name  
  - 🔹 PID  
  - 🔹 Parent PID  
  - 🔹 Full Executable Path
- Outputs to a log file:  
  `C:\Users\YourUsername\Desktop\snitchhunter_log.txt`
- Runs in a simple loop, refreshing every 5 seconds
- Prints logs in terminal and appends to file

---

## ⚙️ Usage

1. Run PowerShell as administrator  
2. Execute the script:

```powershell
.\SnitchHunter.ps1
