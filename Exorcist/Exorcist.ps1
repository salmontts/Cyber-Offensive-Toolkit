# Exorcist.ps1
# Detects and eliminates malware hidden in dllhost.exe and more

# === SETTINGS ===
$log = "$env:USERPROFILE\Desktop\exorcist_log.txt"
function Log($msg) {
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $msg" | Out-File -FilePath $log -Append
}

Log "=== EXORCIST START ==="

# === STEP 1: Detect suspicious dllhost.exe ===
$targets = Get-CimInstance Win32_Process -Filter "Name='dllhost.exe'" | Where-Object {
    $_.ParentProcessId -eq 0 -or $_.ExecutablePath -eq $null -or $_.CommandLine -eq $null
}

foreach ($proc in $targets) {
    $id = $proc.ProcessId
    Log "Suspicious dllhost.exe PID: $id"
    try {
        Stop-Process -Id $id -Force
        Log "KILLED PID: $id"
    } catch {
        Log "Error killing PID $(id): $_"
    }
}

# === STEP 2: Clean WMI Backdoor ===
try {
    Get-WmiObject -Namespace root\subscription -Class __EventFilter | Remove-WmiObject -ErrorAction SilentlyContinue
    Get-WmiObject -Namespace root\subscription -Class __EventConsumer | Remove-WmiObject -ErrorAction SilentlyContinue
    Get-WmiObject -Namespace root\subscription -Class __FilterToConsumerBinding | Remove-WmiObject -ErrorAction SilentlyContinue
    Log "WMI Backdoor removed."
} catch {
    Log "Error cleaning WMI: $_"
}

# === STEP 3: Clean suspicious Scheduled Tasks ===
$tasks = Get-ScheduledTask | Where-Object {
    $_.TaskPath -notlike "\Microsoft*" -and $_.Actions.ToString() -match "powershell|dllhost|wscript|cmd"
}
foreach ($task in $tasks) {
    try {
        Unregister-ScheduledTask -TaskName $task.TaskName -Confirm:$false
        Log "Removed Scheduled Task: $($task.TaskName)"
    } catch {
        Log "Error removing Scheduled Task: $($task.TaskName)"
    }
}

# === STEP 4: Clean registry Run / RunOnce entries ===
$runPaths = @(
    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run",
    "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run"
)

foreach ($path in $runPaths) {
    try {
        Get-Item $path | Get-ItemProperty | ForEach-Object {
            foreach ($name in $_.PSObject.Properties.Name | Where-Object { $_ -notmatch '^PS' }) {
                $val = $_.$name
                if ($val -match "dllhost|powershell|cmd|wscript|AppData|Temp") {
                    Remove-ItemProperty -Path $path -Name $name -Force
                    Log "Removed registry entry: $name ($val)"
                }
            }
        }
    } catch {
        Log "Error cleaning registry: $path"
    }
}

Log "=== CLEANUP COMPLETE ==="