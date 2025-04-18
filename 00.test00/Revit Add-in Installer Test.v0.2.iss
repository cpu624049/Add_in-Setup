[Setup]
AppName=Revit Add-in Installer Test
AppVersion=0.2
DefaultDirName={autopf}\Revit Add-in Installer Test
OutputDir=.
OutputBaseFilename=Revit Add-in Installer Test.v0.2
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
// Revit 설치 여부를 Addins 폴더 존재 여부로 판단
function IsAddinsFolderExists(version: string): Boolean;
var
  path: string;
begin
  path := ExpandConstant('{userappdata}') + '\Autodesk\Revit\Addins\' + version;
  Result := DirExists(path);
end;

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