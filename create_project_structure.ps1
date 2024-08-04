# Set the project root directory
$projectRoot = "C:\path\to\your\project\my_streamlit_app"

# Create the project directories
New-Item -ItemType Directory -Path $projectRoot
New-Item -ItemType Directory -Path "$projectRoot\backend"
New-Item -ItemType Directory -Path "$projectRoot\frontend"
New-Item -ItemType Directory -Path "$projectRoot\config"
New-Item -ItemType Directory -Path "$projectRoot\scripts"

# Create the project files
New-Item -ItemType File -Path "$projectRoot\.gitignore"
New-Item -ItemType File -Path "$projectRoot\README.md"
New-Item -ItemType File -Path "$projectRoot\requirements.txt"
New-Item -ItemType File -Path "$projectRoot\paths.txt"
New-Item -ItemType File -Path "$projectRoot\webapp.sh"

# Add content to the files
Set-Content -Path "$projectRoot\requirements.txt" -Value @"
streamlit
boto3
pandas
"@

Set-Content -Path "$projectRoot\paths.txt" -Value @"
backend_path=backend/
frontend_path=frontend/
config_path=config/
scripts_path=scripts/
"@

Set-Content -Path "$projectRoot\.gitignore" -Value @"
__pycache__/
*.pyc
*.pyo
*.pyd
*.db
*.sqlite3
.env
*.env
config/
"@

Set-Content -Path "$projectRoot\webapp.sh" -Value @"
#!/bin/bash
echo "Starting Streamlit application..."
# Hier wird später der Befehl zum Starten der Anwendung eingefügt
"@

# Make the webapp.sh file executable (only necessary if you're on a Unix-like system)
# For Windows, this step can be skipped or modified accordingly
if ($IsUnix -or $IsLinux -or $IsMacOS) {
    chmod +x "$projectRoot\webapp.sh"
}

Write-Host "Project structure created successfully at $projectRoot"
