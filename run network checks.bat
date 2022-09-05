@echo off

:: netsh wlan show interfaces | grep "State" | sed "s/^.*State.*: // ; s/ *//"



for /f "delims=" %%a in ('netsh wlan show interfaces ^| grep "State" ^| sed "s/^.*State.*: // ; s/ *//"') do (
	if "%%a"=="connected" (
		goto RUNNETWORKCHECKS
	) else (
		goto NOTCONNECTED
	)
)

:NOTCONNECTED
	echo You are not connected to a network
	pause
	goto END

:RUNNETWORKCHECKS
	start cmd /k "mode con: cols=22 lines=2 && @echo off && for /L %%i in (1, 0, 1) do (cls && netsh wlan show interfaces | grep "Signal" | sed "s/.*Signal.*\: /Signal to router: /" && sleep 0.25)"
	@REM start cmd /k "mode con: cols=50 lines=10 && ping 1.1.1.1 -t | sed "s/^Pinging.*$// ; s/^.*time=/ping to cloudflare DNS\: / ; s/TTL.*//""
	@REM start cmd /k "mode con: cols=50 lines=10 && ping 8.8.8.8 -t | sed "s/^Pinging.*$// ; s/^.*time=/ping to google DNS\: / ; s/TTL.*//""
	@REM start cmd /k "mode con: cols=50 lines=10 && ping google.com -t | sed "s/^Pinging.*$// ; s/^.*time=/ping to google.com\: / ; s/TTL.*//""
	goto END

:END
	exit
