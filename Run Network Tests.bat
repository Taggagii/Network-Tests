@echo off

@REM thanks to https://www.dostips.com/forum/viewtopic.php?t=8033
@REM get the currently set WindowPosition so we can restore it when we're done
@REM https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/reg-query
@REM note: we redirect stderr to nul because we're already checking if this command doesn't work so the user doesn't need to know 
set "oldpos="
for /f "tokens=3" %%a in ('2^>nul reg query HKCU\Console /v WindowPosition') do (
    set "oldpos=%%a"
)
@REM we set the new position before each new open
@REM set /a "newpos=(0<<16)+0"
set /a "newpos=0"
>nul reg add HKCU\Console /v WindowPosition /t REG_DWORD /d %newpos% /f
for /f "delims=" %%a in ('netsh wlan show interfaces ^| grep "State" ^| sed "s/^.*State.*: // ; s/ *//"') do (
    if "%%a"=="connected" (
        start cmd /k "mode con: cols=22 lines=2 && @echo off && for /L %%i in (1, 0, 1) do (cls && netsh wlan show interfaces | grep "Signal" | sed "s/.*Signal.*\: /Signal to router: /" && sleep 0.25)" && sleep 0
    ) else (
        start cmd /k "mode con: cols=22 lines=2 && @echo off && echo You're not on WIFI" && sleep 0
    )
)

set /a "newpos=285"   
>nul reg add HKCU\Console /v WindowPosition /t REG_DWORD /d %newpos% /f
start cmd /k "mode con: cols=32 lines=5 && ping 1.1.1.1 -t | sed "s/^Pinging.*$// ; s/^.*time=/ping to cloudflare DNS\: / ; s/TTL.*//"" && sleep 0

set /a "newpos=700"   
>nul reg add HKCU\Console /v WindowPosition /t REG_DWORD /d %newpos% /f
start cmd /k "mode con: cols=32 lines=5 && ping 8.8.8.8 -t | sed "s/^Pinging.*$// ; s/^.*time=/ping to google DNS\: / ; s/TTL.*//"" && sleep 0

set /a "newpos=1115"   
>nul reg add HKCU\Console /v WindowPosition /t REG_DWORD /d %newpos% /f
start cmd /k "mode con: cols=28 lines=5 && ping google.com -t | sed "s/^Pinging.*$// ; s/^.*time=/ping to google.com\: / ; s/TTL.*//"" && sleep 0

@REM restore the old position
if defined oldpos ( @REM if the WindowPosition was previously set before we changed it
    reg add HKCU\Console /v WindowPosition /t REG_DWORD /d %oldpos% /f 
) else (
    @REM remove the WindowPosition key if it wasn't set before to leave system in same state as before  
    >nul reg delete HKCU\Console /v WindowPosition /f
)

exit