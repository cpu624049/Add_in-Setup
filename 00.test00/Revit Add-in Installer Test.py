import os
import subprocess

# 파일 경로 설정
TEMPLATE_PATH = "Revit Add-in Installer Test.iss"
VERSION_FILE = "version.txt"
ISCC_PATH = os.path.abspath(".\\Inno Setup 6\\ISCC.exe")

if not os.path.exists(ISCC_PATH):
    print("❌ ISCC.exe 경로가 잘못되었습니다.")
else:
    print("✅ ISCC.exe 확인 완료:", ISCC_PATH)

# version 파일 내 숫자 읽기 (default=0.1)
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

# iss 파일 생성
def generate_iss_file(version, output_path):
  with open(TEMPLATE_PATH, 'r', encoding='utf-8') as f:
    template = f.read()

  output = template.replace("{{VERSION}}", version)

  with open(output_path, 'w', encoding='utf-8') as f:
    f.write(output)
  
  print(f"✅ .iss 파일 생성 완료 → {output_path}")

# iss 파일 컴파일
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
  new_version = read_and_increment_version()
  print(f"🔁 새로운 버전: {new_version}")

  output_iss_path = f"Revit Add-in Installer Test.v{new_version}.iss"
  generate_iss_file(new_version, output_iss_path)
  compile_with_iscc(output_iss_path)

if __name__ == "__main__":
  main()