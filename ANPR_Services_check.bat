:INITIALISE
	Y:
	CD \
	CD Scripts\ASDA\UpdateScripts\"Patch Check"
	SET dd=%date:~0,2%
	SET mm=%date:~3,2%
	SET yy=%date:~8,2%
	SET TODAY=%DD%%MM%%YY%
	SET PATH=%PATH%;C:\Scripts\ASDA\utils;C:\Scripts\ASDA\utils\PSToolsNew
	SETLOCAL ENABLEDELAYEDEXPANSION
	FOR /f "tokens=1 delims=," %%z IN (ANPRSites.txt) DO CALL :BEGIN %%z
	
	sendemail -f hsowemimo@htec.co.uk -t hsowemimo@htec.co.uk MStrauss@htec.co.uk RKawa@htec.co.uk NUIHuda@htec.co.uk -u "ANPR Services Status" -m "Attached List of Sites with Failures " -a "ANPR Service Failures%TODAY%".csv -s 127.0.0.1
	rem sendemail -f hsowemimo@htec.co.uk -t hsowemimo@htec.co.uk -u "ANPR Services Status" -m "Attached List of Sites with Failures " -a "ANPR Service Failures%TODAY%".csv -s 127.0.0.1
	
:BEGIN
    SET ID=%1
	FOR /f "tokens=1-9 delims=," %%a IN (C:\Scripts\ASDA\sitelist.csv) DO CALL :ASSIGN %%a %%b %%c %%d %%e %%f %%g %%h %%i
	
	GOTO END

	
:ASSIGN

	IF NOT "%ID%"=="%1" GOTO END
	SET SITE=%2
	SET MU=%3
	SET TILL1=%4
	SET TILL2=%5
	SET TILL3=%6
	SET TILL4=%7
	SET OFFICE=%8
	SET ANPR=%9
	REM IF "%MU%"=="MANNED" GOTO END
	SET TERMNUM=0
	ECHO Updating %ID% %SITE%...
	FOR %%x IN (%ANPR%) DO CALL :UPDATE %%x 
	
	
	GOTO END

:UPDATE
	IF "%ANPR%"=="111.111.111.111" GOTO END
	NET USE \\%ANPR%\c$ /user:htec htec
	
	
	IF NOT EXIST \\%ANPR%\C$\Datasender5 (
	
	ECHO %ID%, %SITE%, Datasender5 DOES NOT EXIST ON SITE  >> "ANPR Service Failures%TODAY%".csv
	GOTO ZABBIX
	)
	
	
	sc \\%ANPR% query DataSender5 | FINDSTR /i "RUNNING"
	IF NOT %ERRORLEVEL%==0 (
	
	ECHO %ID%, %SITE%, Datasender5 NOT running on ANPR  >> "ANPR Service Failures%TODAY%".csv
	)
	
	
:ZABBIX

	sc \\%ANPR% query "Zabbix Agent" | FINDSTR /i "RUNNING"
	IF NOT %ERRORLEVEL%==0 (
	
	ECHO %ID%, %SITE%, Zabbix NOT running on ANPR  >> "ANPR Service Failures%TODAY%".csv
	)
	
	sc \\%ANPR% query Htec.ANPR.ForecourtProtect.API | FINDSTR /i "RUNNING"
	IF NOT %ERRORLEVEL%==0 (
	
	ECHO %ID%, %SITE%, API NOT running >> "ANPR Service Failures%TODAY%".csv
	)
	
	sc \\%ANPR% query Htec.ANPR.ForecourtProtect.UI.Service | FINDSTR /i "RUNNING"
	IF NOT %ERRORLEVEL%==0 (
	
	ECHO %ID%, %SITE%, UI NOT running >> "ANPR Service Failures%TODAY%".csv
	)
	
	sc \\%ANPR% query HydraFileSendService | FINDSTR /i "RUNNING"
	IF NOT %ERRORLEVEL%==0 (
	
	ECHO %ID%, %SITE%, HydraFileSendService NOT running >> "ANPR Service Failures%TODAY%".csv
	)	
	
	
	
	
		
		
:END


	