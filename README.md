# lockshell

Secure and compact windows explorer shell replacement for embedded systems with Windows 2000 and XP.

## Install
1. Copy cadgina.dll and Lockshell.exe to System32 directory
2. Register dll with command (in System32 directory):
```regsvr32 cadgina.dll```
3. Execute Lockshell.exe and setup parameters, then reboot.


## Uninstall
1. Execute Lockshell.exe and setup default shell - explorer.exe.
2. Unregister dll with command (in System32 directory):
```regsvr32 /u cadgina.dll```
3. Reboot.
4. Remove Lockshell.exe and cadgina.dll from System32.
