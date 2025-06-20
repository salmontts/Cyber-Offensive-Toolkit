# SnitchHunter.ps1 – idle mode process watcher, extended with path, PID and parent PID
$log = "$env:USERPROFILE\Desktop\snitchhunter_log.txt"
$prevProcs = @{}

function Log($msg) {
    "$((Get-Date).ToString("yyyy-MM-dd HH:mm:ss")) - $msg" | Out-File -FilePath $log -Append
}

while ($true) {
    $currentProcs = @{}
    foreach ($proc in Get-Process | Where-Object { $_.Path -ne $null }) {
        $key = "$($proc.ProcessName)-$($proc.Id)"
        $currentProcs[$key] = $true

        if (-not $prevProcs.ContainsKey($key)) {
            $parent = try { (Get-CimInstance Win32_Process -Filter "ProcessId=$($proc.Id)").ParentProcessId } catch { "?" }
            $msg = "New process: $($proc.ProcessName) | PID: $($proc.Id) | Parent PID: $parent | Path: $($proc.Path)"
            Log $msg
            Write-Host $msg
        }
    }
    $prevProcs = $currentProcs
    Start-Sleep -Seconds 5
}