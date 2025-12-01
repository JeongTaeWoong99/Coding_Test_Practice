import re

# vcxproj에 등록된 파일 목록 추출
vcxproj_files = set()

with open(r'C:\Users\ASUS\Desktop\Code\CoTe\Coding-Test-Practice\Complete\Complete.vcxproj', 'r', encoding='utf-8') as f:
    content = f.read()
    
    # <None Include="경로" /> 패턴 찾기
    pattern = r'<None Include="([^"]+)"'
    matches = re.findall(pattern, content)
    
    for match in matches:
        # 백슬래시를 슬래시로 통일
        normalized = match.replace('\', '/')
        vcxproj_files.add(normalized)

print(f"vcxproj에 등록된 파일 수: {len(vcxproj_files)}")
print("\n등록된 파일 목록 (샘플 10개):")
for i, f in enumerate(sorted(vcxproj_files)[:10]):
    print(f"  {f}")
print(f"  ... ({len(vcxproj_files) - 10}개 더 있음)")

# 결과를 파일로 저장
with open('vcxproj_files.txt', 'w', encoding='utf-8') as f:
    for file in sorted(vcxproj_files):
        f.write(file + '\n')

print("\n✅ vcxproj_files.txt 파일에 저장 완료")
