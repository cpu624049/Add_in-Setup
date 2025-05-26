import os
import subprocess

# ------------ 설정 영역 ------------
TEMPLATE_PATH = "Release Source File.iss"
VERSION_FILE = "version.txt"
ISCC_PATH = os.path.abspath(".\\Inno Setup 6\\ISCC.exe")
RELEASE_DIR = os.path.join(os.getcwd(), "Release Files")
# ----------------------------------

# 1) ISCC 경로 확인
if not os.path.exists(ISCC_PATH):
    print("❌ ISCC.exe 경로가 잘못되었습니다.")
else:
    print("✅ ISCC.exe 확인 완료:", ISCC_PATH)

# 2) version 파일 내 숫자 읽고 0.1 → 0.2 처럼 minor 버전 증가 (default=0.1)
def read_and_increment_version():
  if not os.path.exists(VERSION_FILE):
    version = "0.1"
  else:
    with open(VERSION_FILE, 'r') as f:
      version = f.read().strip()
  
  # 버전 증가: 마지막 소수점 +1 (ex. 0.3 → 0.4)
  major, minor = map(int, version.split('.'))
  minor += 1
  new_version = f"{major}.{minor}"

  with open(VERSION_FILE, 'w') as f:
    f.write(new_version)

    return new_version

# 3) iss 파일 템플릿에서 버전 치환 후 생성
def generate_iss_file(version, output_path):
  with open(TEMPLATE_PATH, 'r', encoding='utf-8') as f:
    template = f.read()

  output = template.replace("{{VERSION}}", version)

  with open(output_path, 'w', encoding='utf-8') as f:
    f.write(output)
  
  print(f"✅ .iss 파일 생성 완료 → {output_path}")

# 4) iss 파일을 ISCC.exe로 컴파일
def compile_with_iscc(iss_path):
  try:
    result = subprocess.run(
      [ISCC_PATH, iss_path],
      check=True,
      capture_output=True,
      text=True,
      encoding="utf-8"
    )
    print("✅ Inno Setup 컴파일 성공")
    print(result.stdout)
  except subprocess.CalledProcessError as e:
    print("❌ 컴파일 실패")
    print(e.stderr)

# MAIN 함수
def main():
  # Release Files 폴더가 없으면 생성
  os.makedirs(RELEASE_DIR, exist_ok=True)

  # 버전 처리
  new_version = read_and_increment_version()
  print(f"🔁 새로운 버전: {new_version}")
  
  # .iss 파일 출력 경로를 Release Files로 지정
  output_iss_path = os.path.join(
    RELEASE_DIR,
    f"Linetek Revit Add-In.v{new_version}.iss"
  )
  generate_iss_file(new_version, output_iss_path)
  compile_with_iscc(output_iss_path)

if __name__ == "__main__":
  main()