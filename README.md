# 🛡️ Adrian Jedrocha – Cyber Offensive Toolkit

A collection of personal cybersecurity tools and scripts built for offensive operations – from real-time process monitoring to memory analysis and recon automation.

This toolkit is built with a hands-on mindset: **minimal, fast, and functional.** It’s meant for analysts, red teamers, and threat hunters who prefer code that just works.

---

## 📂 Projects

### 🔸 [SnitchHunter](./SnitchHunter)
A PowerShell script that monitors all new processes in real time. Logs process name, PID, parent PID, and full executable path. Ideal for detecting suspicious or stealthy process activity in Windows.

➡️ [Go to SnitchHunter](./SnitchHunter)

---

### 🔸 [Exorcist](./Exorcist)
A PowerShell script to detect and remove malware hidden in `dllhost.exe` and related persistence mechanisms.

➡️ [Go to Exorcist](./Exorcist)

---

### 🔸 [dllhost_watchdog](./dllhost_watchdog)
A PowerShell tool to monitor and alert on suspicious `dllhost.exe` activity, helping with early detection of malicious persistence or process injection.

➡️ [Go to dllhost_watchdog](./dllhost_watchdog)

---

## 📌 Coming soon:
- **FULLTRAP** – advanced PowerShell trap for root-processes with no parent PID, auto-dumping and suspending malicious behavior
- **ReconX** – automated recon tool for footprinting and target profiling
- **Malware-Analysis** – examples of memory dumps and script-based forensic analysis

---

## 📜 License

MIT

---

## ✍️ Author

**Adrian Jedrocha**  
Offensive Security Practitioner  
