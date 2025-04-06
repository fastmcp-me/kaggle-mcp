# Kaggle-MCP Installation Script for Windows
# https://github.com/username/kaggle-mcp
# Usage: Invoke-WebRequest -Uri https://raw.githubusercontent.com/username/kaggle-mcp/main/install.ps1 | Invoke-Expression

function Write-Info {
    Write-Host "INFO: $args" -ForegroundColor Blue
}

function Write-Warning {
    Write-Host "WARNING: $args" -ForegroundColor Yellow
}

function Write-Error {
    Write-Host "ERROR: $args" -ForegroundColor Red
    exit 1
}

function Write-Success {
    Write-Host "SUCCESS: $args" -ForegroundColor Green
}

function Test-Command {
    param (
        [string]$Command
    )
    return $null -ne (Get-Command $Command -ErrorAction SilentlyContinue)
}

# Display banner
Write-Host ""
Write-Host "     ██╗  ██╗ █████╗  ██████╗  ██████╗ ██╗     ███████╗       ███╗   ███╗ ██████╗██████╗ " -ForegroundColor Cyan
Write-Host "     ██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝ ██║     ██╔════╝       ████╗ ████║██╔════╝██╔══██╗" -ForegroundColor Cyan
Write-Host "     █████╔╝ ███████║██║  ███╗██║  ███╗██║     █████╗         ██╔████╔██║██║     ██████╔╝" -ForegroundColor Cyan
Write-Host "     ██╔═██╗ ██╔══██║██║   ██║██║   ██║██║     ██╔══╝  ████─  ██║╚██╔╝██║██║     ██╔═══╝ " -ForegroundColor Cyan
Write-Host "     ██║  ██╗██║  ██║╚██████╔╝╚██████╔╝███████╗███████╗       ██║ ╚═╝ ██║╚██████╗██║     " -ForegroundColor Cyan
Write-Host "     ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝       ╚═╝     ╚═╝ ╚═════╝╚═╝     " -ForegroundColor Cyan
Write-Host ""
Write-Host "Kaggle-MCP Installation Script" -ForegroundColor Cyan
Write-Host "========================================"
Write-Host "Kaggle API Integration for Claude AI"
Write-Host ""

# Check for Python
Write-Info "Checking for Python..."
if (Test-Command python) {
    # Check if it's actually Python 3
    $version = python --version 2>&1
    if ($version -match "Python 3") {
        $PYTHON = "python"
    }
    else {
        Write-Error "Python 3 is required (Python 2 detected)"
    }
}
else {
    Write-Error "Python 3 not found. Please install Python 3.8 or newer."
}

# Ensure Python version is at least 3.8
$pythonVersionStr = & $PYTHON -c "import sys; print(f'{sys.version_info.major}.{sys.version_info.minor}')"
$pythonVersion = [version]$pythonVersionStr
if ($pythonVersion -lt [version]"3.8") {
    Write-Error "Python 3.8 or newer is required (found $pythonVersionStr)"
}

Write-Success "Python $pythonVersionStr detected"

# Check for and install uv if needed
if (-not (Test-Command uv)) {
    Write-Warning "uv package manager not found"
    $installUv = Read-Host "Would you like to install uv for better dependency management? (y/N)"
    if ($installUv -match "^[Yy]") {
        Write-Info "Installing uv package manager..."
        Invoke-RestMethod -Uri https://astral.sh/uv/install.ps1 | Invoke-Expression
        
        # Verify uv installation
        if (Test-Command uv) {
            Write-Success "uv installed successfully!"
        }
        else {
            Write-Warning "uv installation complete but command not found in PATH"
            Write-Warning "You may need to restart your PowerShell session to use uv"
            
            # Try to add to PATH for current session
            $uvPath = "$env:USERPROFILE\.astral\uv\bin"
            if (Test-Path $uvPath) {
                $env:PATH = "$uvPath;$env:PATH"
                Write-Info "Added uv to PATH for current session"
            }
        }
    }
    else {
        Write-Warning "Skipping uv installation, will use pip if available"
    }
}

# Install kaggle-mcp
Write-Info "Installing kaggle-mcp..."

if (Test-Command uv) {
    Write-Info "Using uv package manager"
    uv pip install git+https://github.com/username/kaggle-mcp.git
}
elseif (Test-Command pip) {
    Write-Warning "Using pip instead of uv"
    pip install git+https://github.com/username/kaggle-mcp.git
}
else {
    Write-Error "Neither uv nor pip found. Please install pip or uv and try again."
}

# Check for Kaggle credentials
Write-Info "Checking for Kaggle credentials..."
$kaggleJsonPath = "$env:USERPROFILE\.kaggle\kaggle.json"

if (Test-Path $kaggleJsonPath) {
    Write-Success "Kaggle API credentials found at $kaggleJsonPath"
    # We can't easily check permissions on Windows like in Linux/macOS
    Write-Info "Make sure this file has proper permissions to protect your API key."
}
else {
    Write-Warning "Kaggle API credentials not found at $kaggleJsonPath"
    Write-Host ""
    Write-Host "You will need to set up your Kaggle API credentials before using this tool:"
    Write-Host "1. Visit https://www.kaggle.com/settings/account and click 'Create New API Token'"
    Write-Host "2. Save the downloaded kaggle.json file to: $kaggleJsonPath"
    Write-Host "3. Make sure the file has appropriate permissions"
    Write-Host ""
    Write-Host "Alternatively, you can authenticate directly using Claude with the authenticate() tool."
    Write-Host ""
}

# Configure Claude Desktop
Write-Info "Configuring Claude Desktop..."

if (Test-Command kaggle-mcp-setup) {
    kaggle-mcp-setup
}
else {
    Write-Warning "Could not find kaggle-mcp-setup command."
    Write-Warning "You may need to manually configure Claude Desktop:"
    Write-Host ""
    Write-Host "1. Edit your Claude Desktop config file at: $env:APPDATA\Claude\claude_desktop_config.json"
    Write-Host '2. Add this configuration:'
    Write-Host '{
  "mcpServers": {
    "kaggle": {
      "command": "kaggle-mcp"
    }
  }
}'
    Write-Host ""
    Write-Host "3. Restart Claude Desktop"
}

# Verify installation
if (Test-Command kaggle-mcp) {
    $version = (kaggle-mcp --version 2>&1) -replace ".*?(\d+\.\d+\.\d+).*", '$1'
    Write-Success "Installation successful! Kaggle-MCP version $version"
    
    Write-Host ""
    Write-Host "=== Getting Started ===" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "To use Kaggle-MCP with Claude Desktop:"
    Write-Host ""
    Write-Host "1. Start Claude Desktop"
    Write-Host "2. Claude will have access to Kaggle API commands"
    Write-Host "3. First authenticate with your credentials by asking Claude:"
    Write-Host "   \"Please authenticate with Kaggle using my username 'yourusername' and key 'yourapikey'\""
    Write-Host ""
    Write-Host "4. Then try commands like:"
    Write-Host "   - \"List active Kaggle competitions\""
    Write-Host "   - \"Find datasets about climate change\""
    Write-Host "   - \"Search for kernels about sentiment analysis\""
}
else {
    Write-Error "Installation failed. Try installing manually: pip install git+https://github.com/username/kaggle-mcp.git"
}

Write-Host ""
Write-Success "Installation complete!"
