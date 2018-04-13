library CadGINA;
uses
  Windows;

{  Copy this DLL to System32 and register with
      
      regsvr32 CadGINA.dll
   
   Now, if you want to block CAD just call in your code

      CreateMutex(nil,True,'Global\D458BE91-F342-4743-938F-B6AD9D392952');

   and system CAD turns off.
   After process termination system CAD automatically restores. }
   
const
  MSGina='MSGina.dll';
  MutexName='Global\D458BE91-F342-4743-938F-B6AD9D392952';

{$D *.RES}

procedure WlxActivateUserShell;external MSGina;
procedure WlxDisplayLockedNotice;external MSGina;
procedure WlxDisplaySASNotice;external MSGina;
procedure WlxDisplayStatusMessage;external MSGina;
procedure WlxGetStatusMessage;external MSGina;
procedure WlxInitialize;external MSGina;
procedure WlxIsLockOk;external MSGina;
procedure WlxIsLogoffOk;external MSGina;
function WlxLoggedOnSAS(pWlxContext:Pointer;dwSasType:DWORD;pReserved:Pointer):Integer; stdcall;external MSGina;
procedure WlxLoggedOutSAS;external MSGina;
procedure WlxLogoff;external MSGina;
procedure WlxNegotiate;external MSGina;
procedure WlxNetworkProviderLoad;external MSGina;
procedure WlxRemoveStatusMessage;external MSGina;
procedure WlxScreenSaverNotify;external MSGina;
procedure WlxShutdown;external MSGina;
procedure WlxStartApplication;external MSGina;
procedure WlxWkstaLockedSAS;external MSGina;

type
  TWlxDisconnectNotify=procedure(pWlxContext:pointer); stdcall;
  TWlxReconnectNotify=procedure(pWlxContext:pointer); stdcall;
  TWlxGetConsoleSwitchCredentials=function(pWlxContext,pInfo:pointer):BOOL; stdcall;
const
  WlxDisconnectNotify:TWlxDisconnectNotify=nil;
  WlxReconnectNotify:TWlxReconnectNotify=nil;
  WlxGetConsoleSwitchCredentials:TWlxGetConsoleSwitchCredentials=nil;

function MyWlxGetConsoleSwitchCredentials(pWlxContext,pInfo:pointer):BOOL; stdcall;
begin
  if pointer(@WlxGetConsoleSwitchCredentials)<>nil then
    Result:=WlxGetConsoleSwitchCredentials(pWlxContext,pInfo)
  else
    Result:=false;
end;

procedure MyWlxDisconnectNotify(pWlxContext:pointer); stdcall;
begin
  if pointer(@WlxDisconnectNotify)<>nil then WlxDisconnectNotify(pWlxContext);
end;

procedure MyWlxReconnectNotify(pWlxContext:pointer); stdcall;
begin
  if pointer(@WlxReconnectNotify)<>nil then WlxReconnectNotify(pWlxContext);
end;

function MyWlxLoggedOnSAS(pWlxContext:Pointer;dwSasType:DWORD;pReserved:Pointer):Integer; stdcall;
var
  Mutex:THandle;
begin
  if dwSasType=1 then begin
    Mutex:=OpenMutex(MUTEX_ALL_ACCESS,False,MutexName);
    if Mutex<>0 then begin
      CloseHandle(Mutex);
      Result:=2;
      Exit;
    end;
  end;
  Result:=WlxLoggedOnSAS(pWlxContext,dwSasType,pReserved);
end;

function UpdateRegistry(Delete:Boolean):HRESULT;
var
  Key:HKEY;
  DLLName:array[0..MAX_PATH] of Char;
const
  KeyName='SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon';
begin
  Result:=S_OK;
  if Delete then
  begin
    if RegOpenKeyEx(HKEY_LOCAL_MACHINE,KeyName,0,KEY_ALL_ACCESS,Key)=ERROR_SUCCESS then
      RegDeleteValue(Key,'GinaDLL');
  end
  else begin
    if (GetModuleFileName(hInstance,DLLName,SizeOf(DLLName))=0)
      or(RegOpenKeyEx(HKEY_LOCAL_MACHINE,KeyName,0,KEY_ALL_ACCESS,Key)<>ERROR_SUCCESS)
      or(RegSetValueEx(Key,'GinaDLL',0,REG_SZ,@DLLName,lStrLen(DLLName)+1)<>ERROR_SUCCESS) then
      Result:=E_UNEXPECTED;
  end;
end;

function DllRegisterServer:HRESULT;
begin
  Result:=UpdateRegistry(False);
end;

function DllUnregisterServer:HRESULT;
begin
  Result:=UpdateRegistry(True);
end;

exports
  DllRegisterServer,
  DllUnregisterServer,
  WlxActivateUserShell,
  MyWlxDisconnectNotify Name 'WlxDisconnectNotify',
  WlxDisplayLockedNotice,
  WlxDisplaySASNotice,
  WlxDisplayStatusMessage,
  MyWlxGetConsoleSwitchCredentials Name 'WlxGetConsoleSwitchCredentials',
  WlxGetStatusMessage,
  WlxInitialize,
  WlxIsLockOk,
  WlxIsLogoffOk,
  MyWlxLoggedOnSAS Name 'WlxLoggedOnSAS',
  WlxLoggedOutSAS,
  WlxLogoff,
  WlxNegotiate,
  WlxNetworkProviderLoad,
  MyWlxReconnectNotify Name 'WlxReconnectNotify',
  WlxRemoveStatusMessage,
  WlxScreenSaverNotify,
  WlxShutdown,
  WlxStartApplication,
  WlxWkstaLockedSAS;

const
  hGINA:THandle=0;

procedure MyDLLProc(Reason:integer);
begin
  case Reason of
    DLL_PROCESS_ATTACH: begin
      if hGINA=0 then hGINA:=LoadLibrary('msgina.dll');
      if hGINA<>0 then
      begin
        @WlxDisconnectNotify:=GetProcAddress(hGINA,'WlxDisconnectNotify');
        @WlxReconnectNotify:=GetProcAddress(hGINA,'WlxReconnectNotify');
        @WlxGetConsoleSwitchCredentials:=GetProcAddress(hGINA,'WlxGetConsoleSwitchCredentials');
      end;
    end;
    DLL_PROCESS_DETACH: begin
        @WlxDisconnectNotify:=nil;
        @WlxReconnectNotify:=nil;
        @WlxGetConsoleSwitchCredentials:=nil;
        if hGINA<>0 then
        begin
          FreeLibrary(hGINA);
          hGINA:=0;
        end;
    end;
  end;
end;

begin
  @DLLProc:=@MyDLLProc;
end.
