[Setup]
PrivilegesRequired=admin
AppName=Linetek Revit Add-In
AppVersion=0.9
DisableDirPage=yes
DefaultDirName={commonappdata}\Autodesk\Revit\Addins\
OutputDir=\\idea\전사공유자료\R&D\애드인 배포\생성된 배포 파일
OutputBaseFilename=Linetek Revit Add-In.v0.9
Compression=lzma
SolidCompression=yes

[Tasks]
Name: r21; Description: "Revit 2021 Add-in 설치"; GroupDescription: "설치할 Revit 버전을 선택하세요:"
Name: r22; Description: "Revit 2022 Add-in 설치"; GroupDescription: "설치할 Revit 버전을 선택하세요:"
Name: r23; Description: "Revit 2023 Add-in 설치"; GroupDescription: "설치할 Revit 버전을 선택하세요:"
Name: r24; Description: "Revit 2024 Add-in 설치"; GroupDescription: "설치할 Revit 버전을 선택하세요:"
Name: r25; Description: "Revit 2025 Add-in 설치"; GroupDescription: "설치할 Revit 버전을 선택하세요:"
Name: r26; Description: "Revit 2026 Add-in 설치"; GroupDescription: "설치할 Revit 버전을 선택하세요:"

[Files]
Source: "..\Addins\Revit 2021 Debug R21 addin\*"; DestDir: "{commonappdata}\Autodesk\Revit\Addins\2021"; Flags: ignoreversion; Check: IsR21Installed
Source: "..\Addins\Revit 2022 Debug R22 addin\*"; DestDir: "{commonappdata}\Autodesk\Revit\Addins\2022"; Flags: ignoreversion; Check: IsR22Installed
Source: "..\Addins\Revit 2023 Debug R23 addin\*"; DestDir: "{commonappdata}\Autodesk\Revit\Addins\2023"; Flags: ignoreversion; Check: IsR23Installed
Source: "..\Addins\Revit 2024 Debug R24 addin\*"; DestDir: "{commonappdata}\Autodesk\Revit\Addins\2024"; Flags: ignoreversion; Check: IsR24Installed
Source: "..\Addins\Revit 2025 Debug R25 addin\*"; DestDir: "{commonappdata}\Autodesk\Revit\Addins\2025"; Flags: ignoreversion; Check: IsR25Installed
Source: "..\Addins\Revit 2026 Debug R26 addin\*"; DestDir: "{commonappdata}\Autodesk\Revit\Addins\2026"; Flags: ignoreversion; Check: IsR25Installed

[Languages]
Name: "korean"; MessagesFile: "compiler:Languages\Korean.isl"

[Code]
// ✅ Addins 폴더 존재 여부로 Revit 설치 여부 판단
function IsAddinsFolderExists(version: string): Boolean;
var
  path: string;
begin
  path := ExpandConstant('{commonappdata}') + '\Autodesk\Revit\Addins\' + version;
  Result := DirExists(path);
end;

// ✅ 파일 설치 조건
function IsR21Installed(): Boolean;
begin
  Result := WizardIsTaskSelected('r21') and IsAddinsFolderExists('2021');
end;

function IsR22Installed(): Boolean;
begin
  Result := WizardIsTaskSelected('r22') and IsAddinsFolderExists('2022');
end;

function IsR23Installed(): Boolean;
begin
  Result := WizardIsTaskSelected('r23') and IsAddinsFolderExists('2023');
end;

function IsR24Installed(): Boolean;
begin
  Result := WizardIsTaskSelected('r24') and IsAddinsFolderExists('2024');
end;

function IsR25Installed(): Boolean;
begin
  Result := WizardIsTaskSelected('r25') and IsAddinsFolderExists('2025');
end;

function IsR26Installed(): Boolean;
begin
  Result := WizardIsTaskSelected('r26') and IsAddinsFolderExists('2026');
end;

// ✅ Task 이름으로 인덱스 찾는 함수
function GetTaskIndexByName(const TaskName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to WizardForm.TasksList.Items.Count - 1 do
  begin
    if WizardForm.TasksList.Items[I] = TaskName then
    begin
      Result := I;
      Exit;
    end;
  end;
end;

// ✅ Task 페이지 이후 넘어갈 때 설치 대상 존재 여부 확인 + 체크 해제
function NextButtonClick(CurPageID: Integer): Boolean;
var
  hasSelected: Boolean;       // 선택 여부
  hasSelectedIndex: Integer;  // 선택 여부 인덱스
  missing: string;            // 설치 여부
  missingIndex: Integer;      // 설치 여부 인덱스
begin
  Result := True;
  
  if CurPageID = wpSelectTasks then
  begin
    // 1. 설치할 버전이 하나도 선택되지 않은 경우
    hasSelected := False;
    for hasSelectedIndex := 0 to WizardForm.TasksList.Items.Count - 1 do
    begin
      if WizardForm.TasksList.Checked[hasSelectedIndex] then
      begin
        hasSelected := True;
        Break;
      end;
    end;
    if not hasSelected then
    begin
      MsgBox('하나 이상의 Revit 버전을 선택하세요.', mbError, MB_OK);
      Result := False;
      Exit;
    end;
    
    // 2. 선택한 Revit 버전 중 실제로 설치되어 있지 않은 버전은 체크 해제하고 사용자에게 안내
    missing := '';
  
    if WizardIsTaskSelected('r21') and not IsAddinsFolderExists('2021') then
    begin
      missingIndex := GetTaskIndexByName('Revit 2021 Add-in 설치');
      if missingIndex <> -1 then WizardForm.TasksList.Checked[missingIndex] := False;
      missing := missing + '- Revit 2021' + #13#10;
    end;
    
    if WizardIsTaskSelected('r22') and not IsAddinsFolderExists('2022') then
    begin
      missingIndex := GetTaskIndexByName('Revit 2022 Add-in 설치');
      if missingIndex <> -1 then WizardForm.TasksList.Checked[missingIndex] := False;
      missing := missing + '- Revit 2022' + #13#10;
    end;
    
    if WizardIsTaskSelected('r23') and not IsAddinsFolderExists('2023') then
    begin
      missingIndex := GetTaskIndexByName('Revit 2023 Add-in 설치');
      if missingIndex <> -1 then WizardForm.TasksList.Checked[missingIndex] := False;
      missing := missing + '- Revit 2023' + #13#10;
    end;
    
    if WizardIsTaskSelected('r24') and not IsAddinsFolderExists('2024') then
    begin
      missingIndex := GetTaskIndexByName('Revit 2024 Add-in 설치');
      if missingIndex <> -1 then WizardForm.TasksList.Checked[missingIndex] := False;
      missing := missing + '- Revit 2024' + #13#10;
    end;
    
    if WizardIsTaskSelected('r25') and not IsAddinsFolderExists('2025') then
    begin
      missingIndex := GetTaskIndexByName('Revit 2025 Add-in 설치');
      if missingIndex <> -1 then WizardForm.TasksList.Checked[missingIndex] := False;
      missing := missing + '- Revit 2025' + #13#10;
    end;
    
    if WizardIsTaskSelected('r26') and not IsAddinsFolderExists('2026') then
    begin
      missingIndex := GetTaskIndexByName('Revit 2026 Add-in 설치');
      if missingIndex <> -1 then WizardForm.TasksList.Checked[missingIndex] := False;
      missing := missing + '- Revit 2026' + #13#10;
    end;
    
    if missing <> '' then
    begin
      MsgBox('다음 Revit 버전이 설치되어 있지 않아 체크 해제되었습니다:' + #13#10 + #13#10 + missing, mbError, MB_OK);
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
    AppVer := '0.9';
    AppName := 'Linetek Revit Add-In';
    LogPath := ExpandConstant('{commonappdata}') + '\Autodesk\Revit\Addins\' + AppName + 'install_log.txt';
    TimeStamp := GetDateTimeString('yyyy-mm-dd hh:nn:ss','-',':');
    LogText := '--- 설치완료: ' + TimeStamp + ' ---' #13#10;
    
    if WizardIsTaskSelected('r21') then
      LogText := LogText + 'Revit 2021 ' + AppName + ' (' + AppVer + ') 설치됨' + #13#10;
    if WizardIsTaskSelected('r22') then
      LogText := LogText + 'Revit 2022 ' + AppName + ' (' + AppVer + ') 설치됨' + #13#10;
    if WizardIsTaskSelected('r23') then
      LogText := LogText + 'Revit 2023 ' + AppName + ' (' + AppVer + ') 설치됨' + #13#10;
    if WizardIsTaskSelected('r24') then
      LogText := LogText + 'Revit 2024 ' + AppName + ' (' + AppVer + ') 설치됨' + #13#10;
    if WizardIsTaskSelected('r25') then
      LogText := LogText + 'Revit 2025 ' + AppName + ' (' + AppVer + ') 설치됨' + #13#10;
    if WizardIsTaskSelected('r26') then
      LogText := LogText + 'Revit 2026 ' + AppName + ' (' + AppVer + ') 설치됨' + #13#10;
      
    ForceDirectories(ExtractFilePath(LogPath));
    SaveStringToFile(LogPath, LogText, True);
  end;
end;