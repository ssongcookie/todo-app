$sessionDir = "D:\Dev\Projects\personal\todo\docs\sessions"
$latest = Get-ChildItem -Path $sessionDir -File | Sort-Object Name | Select-Object -Last 1

if ($latest) {
    $content = [System.IO.File]::ReadAllText($latest.FullName, [System.Text.Encoding]::UTF8)
    $result = @{
        hookSpecificOutput = @{
            hookEventName     = "SessionStart"
            additionalContext = $content
        }
    } | ConvertTo-Json -Compress -Depth 5
    Write-Output $result
}
