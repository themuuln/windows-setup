
# Check if running as administrator, if not, restart script as administrator
if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator"))
{
  Write-Host "This script requires administrator privileges. Restarting with elevated permissions..."
  Start-Sleep -Seconds 3
  Start-Process powershell.exe -Verb RunAs -ArgumentList ($MyInvocation.MyCommand.Definition)
  Exit
}

# Install Scoop if not already installed
if (-not (Get-Command scoop -ErrorAction SilentlyContinue))
{
  Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
}

# Install Neovim, Node.js, Python, Git, PSReadLine, Fzf, Yarn, Z via Scoop
$packages = @('neovim', 'nodejs', 'python', 'git', 'psreadline', 'fzf', 'yarn', 'z')
$packages | ForEach-Object {
  scoop install $_
}

# Add scoop's bin directory to the system PATH and reload the environment variables
$binPath = Join-Path $env:USERPROFILE 'scoop\shims'
$env:Path = "$binPath;$env:Path"
[Environment]::SetEnvironmentVariable('PATH', $env:Path, 'Machine')

# Display installed versions
Write-Host "Installed versions:"
Get-Command -Type Application neovim, node, python, git, fzf, yarn, z

Write-Host "Installation completed!"
