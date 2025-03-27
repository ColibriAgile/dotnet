#ifndef AppVersion
  #define AppVersion "9.0.3"
  #define FileVersion "9.0.3"
  #define Year "2025"
#endif

#define DisableLanguageSupport
#include "log_msg_instalacao.iss"
#include "instalar_dotnet.iss"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppCopyright=Copyright {#Year}
AppId=28E7B317-06D2-4248-A42B-0C6A9517DFF9
AppName=Microsoft .NET
AppPublisher=Colibri
AppVersion={#AppVersion}
CloseApplications=force
Compression=none
DefaultDirName={tmp}                                                  
DisableDirPage=yes
DisableProgramGroupPage=yes
OutputBaseFilename=dotnetcore
OutputDir=.\pacote
SetupLogging=yes
SolidCompression=yes
Uninstallable=no
VersionInfoVersion={#FileVersion}

[Files]
;.net 8
Source: "aspnetcore-runtime-8.0.14-win-x86.exe"; DestDir: "{tmp}"; DestName: "asp-runtime-8-x86.exe"; Flags: deleteafterinstall 
Source: "aspnetcore-runtime-8.0.14-win-x64.exe"; DestDir: "{tmp}"; DestName: "asp-runtime-8-x64.exe"; Flags: deleteafterinstall 
Source: "windowsdesktop-runtime-8.0.14-win-x86.exe"; DestDir: "{tmp}"; DestName: "windesk-runtime-8-x86.exe"; Flags: deleteafterinstall
Source: "windowsdesktop-runtime-8.0.14-win-x64.exe"; DestDir: "{tmp}"; DestName: "windesk-runtime-8-x64.exe"; Flags: deleteafterinstall
;.net 9
Source: "aspnetcore-runtime-9.0.3-win-x86.exe"; DestDir: "{tmp}"; DestName: "asp-runtime-9-x86.exe"; Flags: deleteafterinstall 
Source: "aspnetcore-runtime-9.0.3-win-x64.exe"; DestDir: "{tmp}"; DestName: "asp-runtime-9-x64.exe"; Flags: deleteafterinstall 
Source: "windowsdesktop-runtime-9.0.3-win-x86.exe"; DestDir: "{tmp}"; DestName: "windesk-runtime-9-x86.exe"; Flags: deleteafterinstall
Source: "windowsdesktop-runtime-9.0.3-win-x64.exe"; DestDir: "{tmp}"; DestName: "windesk-runtime-9-x64.exe"; Flags: deleteafterinstall

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if (CurStep = ssPostInstall) then
  begin
  { Sempre instala a versao 32 bits }
    InstalarDotnet('asp-runtime-8-x86.exe')
    InstalarDotnet('windesk-runtime-8-x86.exe')
    InstalarDotnet('asp-runtime-9-x86.exe')
    InstalarDotnet('windesk-runtime-9-x86.exe')

  { Em Windows 64 instala tb a versao 64 bits }
    if (isWin64) then
    begin
      InstalarDotnet('asp-runtime-8-x64.exe')
      InstalarDotnet('windesk-runtime-8-x64.exe')
      InstalarDotnet('asp-runtime-9-x64.exe')
      InstalarDotnet('windesk-runtime-9-x64.exe')
    end;    
  end;
end;
