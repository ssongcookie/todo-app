$projectDir = "D:\Dev\Projects\personal\todo"
$sessionsDir = "$projectDir\docs\sessions"

if (-not (Test-Path $sessionsDir)) {
    New-Item -ItemType Directory -Force $sessionsDir | Out-Null
}

$date = Get-Date -Format "yyyy-MM-dd"

$todayFile = Get-ChildItem $sessionsDir -Filter "*_${date}_session-handoff.md" -ErrorAction SilentlyContinue | Sort-Object Name | Select-Object -Last 1

if ($todayFile) {
    $filePath = $todayFile.FullName
    $fileName = $todayFile.Name
} else {
    $existing = Get-ChildItem $sessionsDir -Filter "*.md" -ErrorAction SilentlyContinue | Sort-Object Name
    $nextNum = ($existing.Count + 1).ToString("000")
    $fileName = "${nextNum}_${date}_session-handoff.md"
    $filePath = Join-Path $sessionsDir $fileName
}

$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
$OutputEncoding = [Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Set-Location $projectDir

$branch = git branch --show-current 2>$null
$gitLog = git log --oneline -5 2>$null | Out-String
$gitStatus = git status --short 2>$null | Out-String

$rawJson = gh issue list --repo ssongcookie/todo-app --state open --limit 20 --json number,title,labels 2>$null
$openIssues = $rawJson | ConvertFrom-Json
$issueTable = $openIssues | ForEach-Object {
    $label = if ($_.labels.Count -gt 0) { $_.labels[0].name } else { "" }
    "| #$($_.number) | $($_.title) | $label |"
}

$sessionNum = ($fileName -split "_")[0]

# 변경 감지용 해시 계산
$contentKey = "$branch|$gitLog|$gitStatus|$($issueTable -join ',')"
$newHash = [Convert]::ToBase64String(
    [System.Security.Cryptography.SHA256]::Create().ComputeHash(
        [System.Text.Encoding]::UTF8.GetBytes($contentKey)
    )
)

# 기존 파일의 해시와 비교
if (Test-Path $filePath) {
    $existingContent = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
    if ($existingContent -match '<!-- content-hash: (.+) -->') {
        if ($matches[1] -eq $newHash) {
            exit 0
        }
    }
}

$lines = @()
$lines += "# 세션 인수인계서 #$sessionNum"
$lines += "**프로젝트:** todo-app"
$lines += "**GitHub:** https://github.com/ssongcookie/todo-app"
$lines += ""
$lines += "---"
$lines += ""
$lines += "## 1. 환경 세팅 체크리스트"
$lines += ""
$lines += "### GitHub CLI 로그인 확인"
$lines += '```bash'
$lines += "gh auth status"
$lines += '```'
$lines += "- ``Logged in as ssongcookie`` 뜨면 → 바로 작업 가능"
$lines += "- ``not logged in`` 뜨면 → ``gh auth login`` 실행"
$lines += ""
$lines += "### Git 브랜치 확인"
$lines += '```bash'
$lines += "git branch"
$lines += "git status"
$lines += '```'
$lines += ""
$lines += "---"
$lines += ""
$lines += "## 2. 현재 Git 상태"
$lines += ""
$lines += "**현재 브랜치:** $branch"
$lines += ""
$lines += "### 최근 커밋"
$lines += '```'
$lines += $gitLog.TrimEnd()
$lines += '```'
$lines += ""
$lines += "### 변경사항"
$lines += '```'
$lines += $gitStatus.TrimEnd()
$lines += '```'
$lines += ""
$lines += "---"
$lines += ""
$lines += "## 3. 열린 이슈 목록"
$lines += ""
$lines += "| 이슈 | 제목 | 라벨 |"
$lines += "|------|------|------|"
$lines += $issueTable
$lines += ""
$lines += "---"
$lines += ""
$lines += "## 4. 다음 세션 추천 작업"
$lines += ""
$lines += "GitHub Issues 확인 후 우선순위 높은 이슈부터 진행:"
$lines += ""
$lines += '```bash'
$lines += "git checkout main"
$lines += "git pull origin main"
$lines += "git checkout -b [타입]/[작업명]"
$lines += '```'
$lines += ""
$lines += "---"
$lines += ""
$lines += "## 5. Git 작업 플로우"
$lines += ""
$lines += '```'
$lines += "1. 이슈 → In Progress (GitHub Projects)"
$lines += "2. git checkout -b [타입]/[작업명]"
$lines += "3. 작업"
$lines += "4. git add ."
$lines += '5. git commit -m "[타입]: [내용] #이슈번호"'
$lines += "6. git push origin [브랜치명]"
$lines += "7. PR 생성 (closes #이슈번호)"
$lines += "8. Merge 후 git checkout main && git pull origin main"
$lines += '```'
$lines += ""
$lines += "---"
$lines += ""
$lines += "## 6. 새 세션 시작 시 Claude에게"
$lines += ""
$lines += '```'
$lines += "todo-app Spring Boot 프로젝트 작업 중이야."
$lines += "docs/sessions/$fileName 파일을 읽고"
$lines += "이전 진행사항 파악한 다음 이어서 작업 도와줘."
$lines += '```'
$lines += ""
$lines += "---"
$lines += ""
$lines += "## 7. 학습 방식 및 협업 규칙"
$lines += ""
$lines += "- **목적:** Claude와 개인 todo 프로젝트 진행 중"
$lines += "- **학습 방식:** 개념 설명 → 힌트 제공 → 직접 구현 → 막히면 도움"
$lines += "- **주의:** 코드 전체를 생성해주지 말고 스스로 생각하게 유도 (프론트엔드 제외)"
$lines += "- **커밋 규칙:** 커밋 메시지에 Claude/Anthropic 정보 절대 포함하지 않음"
$lines += ""
$lines += "### Git 커밋 가이드"
$lines += ""
$lines += "| 타입 | 의미 |"
$lines += "|------|------|"
$lines += "| feat | 새 기능 |"
$lines += "| fix | 버그 수정 |"
$lines += "| refactor | 리팩토링 |"
$lines += "| docs | 문서 수정 |"
$lines += "| chore | 기타 설정 변경 |"
$lines += ""
$lines += '```'
$lines += "[타입]: [작업 내용 요약] #이슈번호"
$lines += "예) feat: 할 일 수정 기능 추가 #10"
$lines += '```'

$lines += ""
$lines += "<!-- content-hash: $newHash -->"

$utf8bom = New-Object System.Text.UTF8Encoding $true
[System.IO.File]::WriteAllLines($filePath, $lines, $utf8bom)

Write-Host "핸드오프 문서 업데이트됨: $fileName"