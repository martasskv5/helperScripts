# Install-Module DisplayConfig -Scope CurrentUser -Force
Import-Module DisplayConfig

$monitors = Get-DisplayInfo

$primaryMonitor = $monitors | Where-Object { $_.Primary -eq $true }

if ($primaryMonitor) {
    Write-Host "Cloning display settings from primary monitor: $($primaryMonitor.DeviceName)"

    foreach ($monitor in $monitors) {
        if ($monitor.DisplayId -ne $primaryMonitor.DisplayId) {
            Write-Host "Applying settings to monitor: $($monitor.DisplayId)"
            Copy-DisplaySource -DisplayId $primaryMonitor.DisplayId -DestinationDisplayId $monitor.DisplayId -DontSave
        }
    }

    Write-Host "Display settings cloned successfully."
} else {
    Write-Host "No primary monitor found. Cannot clone display settings."
}