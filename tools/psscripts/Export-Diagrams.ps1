# Export-Diagrams.ps1
# Exports all Mermaid .mmd files to PNG format with consistent configuration

param(
    [string]$DiagramsPath = "docs\diagrams",
    [int]$Width = 1920,
    [string]$BackgroundColor = "white",
    [int]$Scale = 2,
    [switch]$StageForGit = $false
)

Write-Host "🔄 Exporting Mermaid diagrams to PNG..." -ForegroundColor Cyan

# Check if mmdc is available
$mmdc = Get-Command mmdc -ErrorAction SilentlyContinue
if (-not $mmdc) {
    Write-Host "❌ Mermaid CLI (mmdc) not found!" -ForegroundColor Red
    Write-Host "   Install with: npm install -g @mermaid-js/mermaid-cli" -ForegroundColor Yellow
    exit 1
}

# Check for config file
$configFile = Join-Path $DiagramsPath "mermaid-config.json"
$useConfig = Test-Path $configFile

if ($useConfig) {
    Write-Host "✅ Using configuration file: $configFile" -ForegroundColor Green
} else {
    Write-Host "⚠️  Configuration file not found, using defaults" -ForegroundColor Yellow
}

# Get all .mmd files
$mmdFiles = Get-ChildItem -Path $DiagramsPath -Filter "*.mmd"

if ($mmdFiles.Count -eq 0) {
    Write-Host "⚠️  No .mmd files found in $DiagramsPath" -ForegroundColor Yellow
    exit 0
}

Write-Host "📁 Found $($mmdFiles.Count) diagram(s) to export" -ForegroundColor Green
Write-Host ""

$totalSize = 0
$successCount = 0

# Export each file
foreach ($file in $mmdFiles) {
    $pngPath = Join-Path $file.DirectoryName ($file.BaseName + ".png")
    
    Write-Host "  📊 Exporting: $($file.Name)" -ForegroundColor Gray
    Write-Host "     → $($file.BaseName).png" -ForegroundColor DarkGray
    
    try {
        # Build command arguments - note: -f is not a valid mmdc parameter
        if ($useConfig) {
            & mmdc -i $file.FullName -o $pngPath -w $Width -b $BackgroundColor -s $Scale -c $configFile
        } else {
            & mmdc -i $file.FullName -o $pngPath -w $Width -b $BackgroundColor -s $Scale
        }
        
        if (Test-Path $pngPath) {
            $size = (Get-Item $pngPath).Length / 1KB
            $totalSize += (Get-Item $pngPath).Length
            $successCount++
            Write-Host "     ✅ Success ($([math]::Round($size, 2)) KB)" -ForegroundColor Green
            
            # Stage for git if requested
            if ($StageForGit) {
                git add $pngPath
                Write-Host "     📝 Staged for git" -ForegroundColor DarkGreen
            }
        } else {
            Write-Host "     ❌ Failed: PNG file not created" -ForegroundColor Red
        }
    } catch {
        Write-Host "     ❌ Error: $_" -ForegroundColor Red
    }
    Write-Host ""
}

Write-Host "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━" -ForegroundColor Cyan
Write-Host "✅ Export complete!" -ForegroundColor Green
Write-Host "   Successfully exported: $successCount/$($mmdFiles.Count)" -ForegroundColor Green
Write-Host "   Total size: $([math]::Round($totalSize/1KB, 2)) KB" -ForegroundColor Green

if ($successCount -lt $mmdFiles.Count) {
    Write-Host "   ⚠️  Some exports failed. Check errors above." -ForegroundColor Yellow
    exit 1
}
