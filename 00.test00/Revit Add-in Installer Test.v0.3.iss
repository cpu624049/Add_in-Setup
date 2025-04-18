[Setup]
AppName=Revit Add-in Installer Test
AppVersion=0.3
DefaultDirName={userappdata}\RevitAddinInstallerTest
DisableDirPage=yes
OutputDir=.
OutputBaseFilename=Revit Add-in Installer Test.v0.3
Compression=lzma
SolidCompression=yes

[Tasks]
Name: r21; Description: "Revit 2021 Add-in 설치"; GroupDescription: "설치할 Revit 버전을 선택하세요:"
Name: r22; Description: "Revit 2022 Add-in 설치"; GroupDescription: "설치할 Revit 버전을 선택하세요:"
Name: r23; Description: "Revit 2023 Add-in 설치"; GroupDescription: "설치할 Revit 버전을 선택하세요:"
Name: r24; Description: "Revit 2024 Add-in 설치"; GroupDescription: "설치할 Revit 버전을 선택하세요:"
Name: r25; Description: "Revit 2025 Add-in 설치"; GroupDescription: "설치할 Revit 버전을 선택하세요:"

[Files]
Source: "Addins\R21\*"; DestDir: "{userappdata}\Autodesk\Revit\Addins\2021"; Flags: ignoreversion; Check: IsR21Installed
Source: "Addins\R22\*"; DestDir: "{userappdata}\Autodesk\Revit\Addins\2022"; Flags: ignoreversion; Check: IsR22Installed
Source: "Addins\R23\*"; DestDir: "{userappdata}\Autodesk\Revit\Addins\2023"; Flags: ignoreversion; Check: IsR23Installed
Source: "Addins\R24\*"; DestDir: "{userappdata}\Autodesk\Revit\Addins\2024"; Flags: ignoreversion; Check: IsR24Installed
Source: "Addins\R25\*"; DestDir: "{userappdata}\Autodesk\Revit\Addins\2025"; Flags: ignoreversion; Check: IsR25Installed

[Code]
// ✅ Addins 폴더 존재 여부로 Revit 설치 여부 판단
function IsAddinsFolderExists(version: string): Boolean;
var
  path: string;
begin
  path := ExpandConstant('{userappdata}') + '\Autodesk\Revit\Addins\' + version;
  Result := DirExists(path);
end;

// ✅ 파일 설치 조건
function IsR21Installed(): Boolean;
begin
  Result := IsTaskSelected('r21') and IsAddinsFolderExists('2021');
end;

function IsR22Installed(): Boolean;
begin
  Result := IsTaskSelected('r22') and IsAddinsFolderExists('2022');
end;

function IsR23Installed(): Boolean;
begin
  Result := IsTaskSelected('r23') and IsAddinsFolderExists('2023');
end;

function IsR24Installed(): Boolean;
begin
  Result := IsTaskSelected('r24') and IsAddinsFolderExists('2024');
end;

function IsR25Installed(): Boolean;
begin
  Result := IsTaskSelected('r25') and IsAddinsFolderExists('2025');
end;

// ✅ Task 페이지 이후 넘어갈 때 설치 대상 존재 여부 확인
function NextButtonClick(CurPageID: Integer): Boolean;
var
  missing: string;
begin
  Result := True;
  
  if CurPageID = wpSelectTasks then
  begin
    missing := '';
  
    if IsTaskSelected('r21') and not IsAddinsFolderExists('2021') then
      missing := missing + '- Revit 2021' + #13#10;
    if IsTaskSelected('r22') and not IsAddinsFolderExists('2022') then
      missing := missing + '- Revit 2022' + #13#10;
    if IsTaskSelected('r23') and not IsAddinsFolderExists('2023') then
      missing := missing + '- Revit 2023' + #13#10;
    if IsTaskSelected('r24') and not IsAddinsFolderExists('2024') then
      missing := missing + '- Revit 2024' + #13#10;
    if IsTaskSelected('r25') and not IsAddinsFolderExists('2025') then
      missing := missing + '- Revit 2025' + #13#10;
    
    if missing <> '' then
    begin
      MsgBox('다음 Revit 버전이 설치되어 있지 않아 설치를 중단합니다:' + #13#10 + #13#10 + missing, mbError, MB_OK);
      Result := False;
    end;
  end;
end;

// ✅ 설치 완료 후 로그 저장
procedure CurStepChanged(CurStep: TSetupStep);
var
  AppVer, AppName, LogPath, TimeStamp, LogText: string;
begin
  if CurStep = ssPostInstall then
  begin
    AppVer := '0.3';
    AppName := 'Revit Add-in Installer Test';
    LogPath := ExpandConstant('{userappdata}') + '\Autodesk\Revit\Addins\' + AppName + 'install_log.txt';
    TimeStamp := GetDateTimeString('yyyy-mm-dd hh:nn:ss','-',':');
    LogText := '--- 설치완료: ' + TimeStamp + ' ---' #13#10;
    
    if IsTaskSelected('r21') then
      LogText := LogText + 'Revit 2021 ' + AppName + ' (' + AppVer + ') 설치됨' + #13#10;
    if IsTaskSelected('r22') then
      LogText := LogText + 'Revit 2022 ' + AppName + ' (' + AppVer + ') 설치됨' + #13#10;
    if IsTaskSelected('r23') then
      LogText := LogText + 'Revit 2023 ' + AppName + ' (' + AppVer + ') 설치됨' + #13#10;
    if IsTaskSelected('r24') then
      LogText := LogText + 'Revit 2024 ' + AppName + ' (' + AppVer + ') 설치됨' + #13#10;
    if IsTaskSelected('r25') then
      LogText := LogText + 'Revit 2025 ' + AppName + ' (' + AppVer + ') 설치됨' + #13#10;
      
    ForceDirectories(ExtractFilePath(LogPath));
    SaveStringToFile(LogPath, LogText, True);
  end;
end;