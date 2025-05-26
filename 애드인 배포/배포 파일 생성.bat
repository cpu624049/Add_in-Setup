@echo off

chcp 65001 >nul

echo ▶ 배포 파일 생성 시작...

rem 1) .bat 파일이 위치한 UNC 경로(공유폴더)를 드라이브 문자로 매핑하고 거기로 이동
pushd "%~dp0"

rem 2) '배포시 필요 파일' 폴더로 이동
cd /d "배포시 필요 파일"

rem 3) Python 스크립트 실행
echo ▶ Python 스크립트 실행 중...
"c:\Users\Linetek\AppData\Local\Programs\Python\Python313\python.exe" "Release Source File.py"

rem 4) 매핑 해제하고 원래 드라이브로 복귀
popd

echo ✔ 완료!
pause