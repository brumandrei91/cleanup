# PowerShell Script

# Prompt the user for the application name
$app_name = Read-Host "Enter the name of the application"

if ($app_name -eq "anydesk") {
    Write-Host "Searching for AnyDesk executable..."
    # Search for AnyDesk executable
    $anydesk_installer = Get-ChildItem -Path C:\ -Recurse -Include "AnyDesk.exe" -ErrorAction SilentlyContinue | Select-Object -First 1

    if ($anydesk_installer) {
        Write-Host "Found AnyDesk executable: $($anydesk_installer.FullName)"
        Write-Host "Executing AnyDesk uninstaller..."
        Start-Process -FilePath $anydesk_installer.FullName -ArgumentList "--silent --remove" -NoNewWindow -Wait
        Write-Host "AnyDesk uninstallation completed."
    } else {
        Write-Host "AnyDesk executable not found."
    }
} elseif ($app_name -eq "teamviewer") {
    Write-Host "Searching for TeamViewer uninstaller..."
    # Search for TeamViewer uninstaller
    $teamviewer_uninstaller = Get-ChildItem -Path "C:\Program Files", "C:\Program Files (x86)" -Recurse -Include "uninstall.exe" -ErrorAction SilentlyContinue | Where-Object { $_.FullName -match "TeamViewer" } | Select-Object -First 1

    if ($teamviewer_uninstaller) {
        Write-Host "Found TeamViewer uninstaller: $($teamviewer_uninstaller.FullName)"
        Write-Host "Executing TeamViewer uninstaller..."
        Start-Process -FilePath $teamviewer_uninstaller.FullName -ArgumentList "/s" -NoNewWindow -Wait
        Write-Host "TeamViewer uninstallation completed."
    } else {
        Write-Host "TeamViewer uninstaller not found."
    }
} else {
    Write-Host "No specific uninstaller logic for '$app_name'. Proceeding to search for files and folders..."
}

# Search for remaining files and folders containing the app name
Write-Host "Searching for files and folders containing '$app_name'..."
$matches = Get-ChildItem -Path C:\ -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.Name -match $app_name }

if ($matches) {
    Write-Host "Files and folders found:"
    $matches | ForEach-Object { Write-Host $_.FullName }

    # Prompt to delete each file or folder
    foreach ($match in $matches) {
        $response = Read-Host "Do you want to delete this item? $($match.FullName) (yes/no)"
        if ($response -eq "yes") {
            if (Test-Path $match.FullName -PathType Container) {
                Remove-Item -Recurse -Force $match.FullName -ErrorAction SilentlyContinue
                Write-Host "Deleted folder: $($match.FullName)"
            } elseif (Test-Path $match.FullName -PathType Leaf) {
                Remove-Item -Force $match.FullName -ErrorAction SilentlyContinue
                Write-Host "Deleted file: $($match.FullName)"
            }
        } else {
            Write-Host "Skipped: $($match.FullName)"
        }
    }
} else {
    Write-Host "No files or folders found containing '$app_name'."
}
