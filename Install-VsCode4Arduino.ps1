# Install Visual Studio Code and Python if not already installed
# Setup PlatformIO for Arduino development

function Install-VsCode4Arduino {
    param(
        [bool]$CodeInstalled = $false,
        [bool]$PythonInstalled = $false
    )

    # Install Visual Studio Code if not installed
    if (-not $CodeInstalled) {
        $codeUrl = "https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user"
        $codeInstaller = "$env:TEMP\VSCodeSetup.exe"

        Write-Host "Downloading Visual Studio Code..."
        Invoke-WebRequest -Uri $codeUrl -OutFile $codeInstaller
        Write-Host "Installing Visual Studio Code..."

        try {
            Start-Process -FilePath $codeInstaller -ArgumentList "/VERYSILENT /MERGETASKS=!runcode" -Wait
            Write-Host "Visual Studio Code installed successfully!" -ForegroundColor Green
            Remove-Item $codeInstaller -ErrorAction SilentlyContinue

            $codePath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code"
            if (Test-Path $codePath) {
                $userEnvPath = [Environment]::GetEnvironmentVariable("Path", "User")
                $newPath = "$codePath;" + $userEnvPath
                [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
                write-Host "Visual Studio Code path added to user PATH." -ForegroundColor Green
            }
        }
        catch {
            Write-Host "Failed to install Visual Studio Code." -ForegroundColor Red
            return
        }
    }

    # Install Python if not installed
    if (-not $PythonInstalled) {
        $pythonUrl = "https://www.python.org/ftp/python/3.14.0/python-3.14.0-amd64.exe"
        $pythonInstaller = "$env:TEMP\PythonSetup.exe"

        Write-Host "Downloading Python..."
        Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonInstaller
        Write-Host "Installing Python..."

        try {
            Start-Process -FilePath $pythonInstaller -ArgumentList "/quiet InstallAllUsers=0 PrependPath=1 Include_test=0" -Wait
            Write-Host "Python installed successfully!" -ForegroundColor Green
            Remove-Item $pythonInstaller -ErrorAction SilentlyContinue

            $pythonPath = "$env:LOCALAPPDATA\Programs\Python\Python314;$env:LOCALAPPDATA\Programs\Python\Python314\Scripts"
            if (Test-Path $pythonPath) {
                $userEnvPath = [Environment]::GetEnvironmentVariable("Path", "User")
                $newPath = "$pythonPath;" + $userEnvPath
                [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
            }
            write-Host "Python path added to user PATH." -ForegroundColor Green
        }
        catch {
            Write-Host "Failed to install Python." -ForegroundColor Red
            return
        }
    }

    # Reload environment variables
    $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

    # Install PlatformIO Core
    Write-Host "Installing PlatformIO Core..."
    try {
        $plalformIOUrl = "https://raw.githubusercontent.com/platformio/platformio-core-installer/master/get-platformio.py"
        $getPioScript = "$env:TEMP\get-platformio.py"
        
        Invoke-WebRequest -Uri $plalformIOUrl -OutFile $getPioScript

        python $getPioScript
        Write-Host "PlatformIO Core installed successfully!" -ForegroundColor Green
        Remove-Item $getPioScript -ErrorAction SilentlyContinue
    }
    catch {
        Write-Host "Failed to download PlatformIO installer script." -ForegroundColor Red
        return
    }

    # Install PlatformIO extension for VS Code
    Write-Host "Installing PlatformIO extension for Visual Studio Code..."
    try {
        code --install-extension platformio.platformio-ide
        Write-Host "PlatformIO extension installed successfully!" -ForegroundColor Green
    }
    catch {
        Write-Host "Failed to install PlatformIO extension." -ForegroundColor Red
        return
    }
}