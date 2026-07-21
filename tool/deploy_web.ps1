# SotongElec 웹 배포 스크립트 (Windows PowerShell)
# 비밀번호/토큰을 넣지 마세요.

$ErrorActionPreference = "Stop"
$ProjectId = "sotong-elec"

Write-Host "==> flutter pub get"
flutter pub get
if ($LASTEXITCODE -ne 0) { throw "pub get failed" }

Write-Host "==> dart format ."
dart format .
if ($LASTEXITCODE -ne 0) { throw "format failed" }

Write-Host "==> flutter analyze"
flutter analyze --no-fatal-infos
if ($LASTEXITCODE -ne 0) { throw "analyze failed" }

Write-Host "==> flutter test"
flutter test
if ($LASTEXITCODE -ne 0) { throw "test failed" }

Write-Host "==> flutter build web --release"
flutter build web --release
if ($LASTEXITCODE -ne 0) { throw "build failed" }

Write-Host "==> firebase deploy --only hosting --project $ProjectId"
firebase deploy --only hosting --project $ProjectId
if ($LASTEXITCODE -ne 0) { throw "deploy failed" }

Write-Host "배포 완료. 콘솔에 표시된 Hosting URL을 확인하세요."
