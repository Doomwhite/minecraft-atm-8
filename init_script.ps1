# Define the path to the lock file
$LockFilePath = "C:\Users\adinelson.bruhmuller.MOVTECH\Documents\Projects\Git\minecraft-atm-8\lockfile.lock"

# Check if the lock file exists
if (Test-Path $LockFilePath) {
    Write-Host "Lock file exists. Exiting..."
    Exit
}

# Create the lock file
try {
    New-Item -Path $LockFilePath -ItemType File -ErrorAction Stop | Out-Null
}
catch {
    Write-Host "Failed to create the lock file. Exiting..."
    Exit
}

# Launch the executable with elevated priority
$Process = Start-Process -FilePath "C:\WINDOWS\system32\cmd.exe" -ArgumentList "/c `"C:\Users\adinelson.bruhmuller.MOVTECH\Documents\Projects\Git\minecraft-atm-8\startserver.bat`"" -Verb RunAs -PassThru

# Wait for the process to complete
$Process.WaitForExit()

# Check if the cmd.exe process is still running with the specific command line
while ($true) {
    # Check if a cmd.exe process is running with the specific command line
    $cmdProcess = Get-Process | Where-Object { $_.ProcessName -eq "cmd" -and $_.CommandLine -like "*C:\Users\adinelson.bruhmuller.MOVTECH\Documents\Projects\Git\minecraft-atm-8\startserver.bat*" }

    if (-not $cmdProcess) {
        Write-Host "cmd.exe process has terminated. Deleting the lock file..."
        Remove-Item -Path $LockFilePath -Force
        break
    }

    # Sleep for a moment before checking again (adjust as needed)
    Start-Sleep -Seconds 5
}
