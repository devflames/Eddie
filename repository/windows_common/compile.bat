@echo off
SETLOCAL

if "%~1"=="" (
	echo "Project missing"
	goto :error
)

if "%~2"=="" (
	echo "Arch missing"
	goto :error
)

set VARSCRIPTDIR=%~dp0

set VARPROJECT=%1
set VARARCH=%2
set VARCONFIG=Release

set VARMSBUILD="c:\Program Files (x86)\Microsoft Visual Studio\2017\Community\MSBuild\15.0\Bin\msbuild.exe"
set VARTARGETFRAMEWORK="v4.5"
set VARARCHCOMPILE=%VARARCH%
set VARRULESETPATH="%VARSCRIPTDIR%\..\..\tools\ruleset\norules.ruleset"

echo Compilation

IF "%VARPROJECT%"=="cli" (
	set VARSOLUTIONPATH="%VARSCRIPTDIR%\..\..\src\eddie2.windows.sln"
) ELSE IF "%VARPROJECT%"=="ui" (
	set VARSOLUTIONPATH="%VARSCRIPTDIR%\..\..\src\eddie2.windows.sln"
) ELSE IF "%VARPROJECT%"=="ui3" (
	set VARSOLUTIONPATH="%VARSCRIPTDIR%\..\..\src\eddie3.windows.sln"
)

%VARMSBUILD% /verbosity:minimal /property:CodeAnalysisRuleSet=%VARRULESETPATH% /p:Configuration=%VARCONFIG% /p:Platform=%VARARCHCOMPILE% /p:TargetFrameworkVersion=%VARTARGETFRAMEWORK% /t:Rebuild %VARSOLUTIONPATH% /p:DefineConstants="EDDIENET4" || goto :error

IF "%VARPROJECT%"=="cli" (
	CALL %VARSCRIPTDIR%\..\..\src\eddie.windows.postbuild.bat %VARSCRIPTDIR%\..\..\src\App.CLI.Windows\bin\%VARARCHCOMPILE%\%VARCONFIG%/ %VARPROJECT% %VARARCH% %VARCONFIG% || goto :error
) ELSE IF "%VARPROJECT%"=="ui" (
	CALL %VARSCRIPTDIR%\..\..\src\eddie.windows.postbuild.bat %VARSCRIPTDIR%\..\..\src\App.Forms.Windows\bin\%VARARCHCOMPILE%\%VARCONFIG%/ %VARPROJECT% %VARARCH% %VARCONFIG% || goto :error
) ELSE IF "%VARPROJECT%"=="ui3" (
	CALL %VARSCRIPTDIR%\..\..\src\eddie.windows.postbuild.bat %VARSCRIPTDIR%\..\..\src\UI.WPF.Windows\bin\%VARARCHCOMPILE%\%VARCONFIG%/ %VARPROJECT% %VARARCH% %VARCONFIG% || goto :error
)

:done
exit /b 0

:error
echo Failed with error #%errorlevel%.
pause
exit /b %errorlevel%