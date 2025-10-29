# Download and extract Node.js standalone binary
$downloadUrl = "https://nodejs.org/dist/v22.19.0/node-v22.19.0-win-x64.zip"
$targetPath = "$env:USERPROFILE\nodejs"

# Create target directory
New-Item -ItemType Directory -Force -Path $targetPath | Out-Null

# Download Node.js
Invoke-WebRequest -Uri $downloadUrl -OutFile "$targetPath\nodejs.zip"

# Extract contents
Expand-Archive -Path "$targetPath\nodejs.zip" -DestinationPath $targetPath -Force

# Remove zip file
Remove-Item "$targetPath\nodejs.zip"

# Add to PATH
$userEnvPath = [Environment]::GetEnvironmentVariable("Path", "User")
$newPath = "$targetPath;" + $userEnvPath
[Environment]::SetEnvironmentVariable("Path", $newPath, "User")

# Verify installation
Write-Host "Node.js installed successfully!"
    
# Open a new PowerShell session to use the updated PATH
Start-Process powershell -ArgumentList "-NoExit", "-Command", "node --version" 