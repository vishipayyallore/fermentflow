<#
.SYNOPSIS
    Exports a tree-style folder (and optionally file) structure to a text file.

.DESCRIPTION
    Walks a directory tree and writes an indented tree listing to a text file.
    Hidden items are included. Common noise directories (.git, node_modules, etc.)
    are excluded by default via -ExcludedDirs.

.PARAMETER Path
    Root directory to scan. Defaults to the current directory.

.PARAMETER OutputFile
    Destination file for the tree output.
    Relative paths are resolved from -Path. Defaults to .archive\folderstructure.txt.

.PARAMETER ExcludedDirs
    Directory names to skip entirely (not recursed into).
    Defaults to a standard set: .git, .claude, .copilot, .cursor, .github,
    .vscode, .venv, node_modules, bin, obj, dist, coverage, .terraform.

.PARAMETER FoldersOnly
    When specified, only directories are listed — files are omitted.

.EXAMPLE
    # Export full tree from current directory
    .\Export-FolderStructure.ps1

.EXAMPLE
    # Export full tree from a specific path
    .\Export-FolderStructure.ps1 -Path "C:\Projects\MyRepo"

.EXAMPLE
    # Export folders only, custom output location
    .\Export-FolderStructure.ps1 -Path "C:\Projects\MyRepo" -FoldersOnly -OutputFile "C:\Temp\dirs.txt"

.EXAMPLE
    # Exclude additional directories
    .\Export-FolderStructure.ps1 -ExcludedDirs @('.git', 'node_modules', '__pycache__')

.NOTES
    Output format mirrors the Windows `tree /F` style using +--- and \--- connectors.
#>
param(
    [string]$Path = ".",
    [string]$OutputFile = ".archive\folderstructure.txt",
    [string[]]$ExcludedDirs = @(
        '.git',
        '.claude',
        '.copilot',
        '.cursor',
        '.github',
        '.vscode',
        '.venv',
        '.vs',
        'node_modules',
        'bin',
        'obj',
        'dist',
        'coverage',
        '.terraform'
    ),
    [switch]$FoldersOnly
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$resolvedPath = (Resolve-Path -LiteralPath $Path).Path
$outputPath = if ([System.IO.Path]::IsPathRooted($OutputFile)) {
    $OutputFile
} else {
    Join-Path -Path $resolvedPath -ChildPath $OutputFile
}

$outputDirectory = Split-Path -Path $outputPath -Parent
if ($outputDirectory -and -not (Test-Path -LiteralPath $outputDirectory)) {
    New-Item -ItemType Directory -Path $outputDirectory -Force | Out-Null
}

function Write-Tree {
    param(
        [string]$CurrentPath,
        [string]$Indent = ''
    )

    $items = @(
        Get-ChildItem -LiteralPath $CurrentPath -Force |
            Where-Object { $ExcludedDirs -notcontains $_.Name } |
            Where-Object { -not $FoldersOnly -or $_.PSIsContainer } |
            Sort-Object -Property @{ Expression = 'PSIsContainer'; Descending = $true },
                                  @{ Expression = 'Name'; Descending = $false }
    )

    for ($i = 0; $i -lt $items.Count; $i++) {
        $item = $items[$i]
        $isLast = $i -eq ($items.Count - 1)
        $connector = if ($isLast) { '\---' } else { '+---' }

        Write-Output ("{0}{1}{2}" -f $Indent, $connector, $item.Name)

        if ($item.PSIsContainer) {
            $nextIndent = if ($isLast) {
                $Indent + '    '
            } else {
                $Indent + '|   '
            }

            Write-Tree -CurrentPath $item.FullName -Indent $nextIndent
        }
    }
}

$drivePrefix = '{0}:.' -f ([System.IO.Path]::GetPathRoot($resolvedPath).TrimEnd('\').TrimEnd(':'))

@(
    'Folder PATH listing'
    $drivePrefix
    Write-Tree -CurrentPath $resolvedPath
) | Set-Content -LiteralPath $outputPath