@echo off
SETLOCAL ENABLEEXTENSIONS
SETLOCAL ENABLEDELAYEDEXPANSION
TITLE MSYS4OF : MSYS2 Installer for openFrameworks
MODE CON: COLS=120 LINES=50
CLS
COLOR 02

set DRIVE=%~d0
set SRC_DIR=%~dp0
set UNZIP="%~dp0bin\7za.exe"
rem set OF_ROOT=%~dp0\..\..\..



ECHO.************************************************
ECHO.* MSYS4OF : MSYS2 installer for openFrameworks *
ECHO.************************************************
ECHO.


:: Default install directory is x:\msys4of where x is the drive where this script is located
:: To install to another location, set the MSYS4OF_DIR environment variable before running the script
IF NOT DEFINED MSYS4OF_DIR (
	SET MSYS4OF_DIR=%DRIVE%\Msys4Of
)
SET OF_ZIP=%~dpnx1
IF NOT EXIST "%OF_ZIP%" (
	SET OF_ZIP=
)

SET msys2=msys64
SET RUNSH="%MSYS4OF_DIR%\%msys2%\usr\bin\mintty.exe" -i /msys2.ico /usr/bin/bash --login
SET SH="%MSYS4OF_DIR%\%msys2%\usr\bin\sh" --login -i



:ask_for_msys4of_install
ECHO.Installing MSYS4OF
ECHO.------------------
ECHO.
ECHO.MSYS4OF will be installed in %MSYS4OF_DIR%.
ECHO.To install to a different directory, set MSYS4OF_DIR environment variable and run the script again

IF NOT DEFINED OF_ZIP (
	SET /P OF_ZIP=Please input openFrameworks zip file (full path^) ?
) 
SET /P ANSWER=Proceed with installation (Y/N) ?
IF "%ANSWER%"=="Y" (
	GOTO  install_msys2 
)
IF "%ANSWER%"=="N" (
	GOTO  :EOF
)
GOTO ask_for_msys4of_install







set msyspackages=mingw-w64-i686-gcc mingw-w64-i686-glew mingw-w64-i686-freeglut mingw-w64-i686-FreeImage mingw-w64-i686-opencv mingw-w64-i686-assimp mingw-w64-i686-boost mingw-w64-i686-cairo mingw-w64-i686-clang mingw-w64-i686-gdb mingw-w64-i686-zlib  mingw-w64-i686-tools mingw-w64-i686-pkg-config
set ofpackages=git cmake make mingw-w64-i686-gcc mingw-w64-i686-glew mingw-w64-i686-freeglut mingw-w64-i686-FreeImage mingw-w64-i686-opencv mingw-w64-i686-assimp mingw-w64-i686-boost mingw-w64-i686-cairo mingw-w64-i686-clang mingw-w64-i686-gdb mingw-w64-i686-zlib mingw-w64-i686-tools mingw-w64-i686-pkg-config 

set ofpackages_64=mingw-w64-x86_64-clang mingw-w64-x86_64-gcc mingw-w64-x86_64-gdb mingw-w64-x86_64-zlib mingw-w64-x86_64-tools mingw-w64-x86_64-ninja mingw-w64-x86_64-boost mingw-w64-x86_64-cairo mingw-w64-x86_64-mpg123 mingw-w64-x86_64-openal mingw-w64-x86_64-assimp mingw-w64-x86_64-opencv mingw-w64-x86_64-libusb mingw-w64-x86_64-openssl mingw-w64-x86_64-libiconv mingw-w64-x86_64-freetype mingw-w64-x86_64-libsndfile mingw-w64-x86_64-fontconfig mingw-w64-x86_64-pkg-config 
set ofpackages_32=mingw-w64-i686-clang mingw-w64-i686-gcc mingw-w64-i686-gdb mingw-w64-i686-zlib mingw-w64-i686-tools mingw-w64-i686-ninja mingw-w64-i686-boost mingw-w64-i686-cairo mingw-w64-i686-mpg123 mingw-w64-i686-openal mingw-w64-i686-assimp mingw-w64-i686-opencv mingw-w64-i686-libusb mingw-w64-i686-openssl mingw-w64-i686-libiconv mingw-w64-i686-freetype mingw-w64-i686-libsndfile mingw-w64-i686-fontconfig mingw-w64-i686-pkg-config 

rem mingw-w64-i686-jsoncpp





IF EXIST %MSYS4OF_DIR%\%msys2%\usr\bin\msys-2.0.dll GOTO update_msys2

:install_msys2
set msysbase=msys2-base-x86_64-20150512.tar.xz
IF NOT EXIST %MSYS4OF_DIR%\%msys2%\usr\bin\msys-2.0.dll (
	ECHO.Installing MSYS2...
	IF EXIST "%SRC_DIR%bin\%msysbase%" (
		"%SRC_DIR%bin\7za.exe" x "%SRC_DIR%bin\%msysbase%" -so | "%SRC_DIR%\bin\7za.exe" x -aoa -si -ttar -o%MSYS4OF_DIR%
	)
	(
		ECHO.echo -ne "\033]0;Msys2 first run\007"
		ECHO.sleep ^3
		ECHO.exit
	)>%MSYS4OF_DIR%\script.sh
	
	%SH% %MSYS4OF_DIR%\script.sh
	DEL %MSYS4OF_DIR%\script.sh
	ECHO.
)

:update_msys2
ECHO.Updating MSYS2...
(
	ECHO.echo -ne "\033]0;Msys2 update\007"
	ECHO.pacman --noconfirm -Suy 
	ECHO.pacman --noconfirm --needed -S bash pacman pacman-mirrors msys2-runtime
	ECHO.kill -9 -1
)>%MSYS4OF_DIR%\script.sh
%SH% %MSYS4OF_DIR%\script.sh
DEL %MSYS4OF_DIR%\script.sh
ECHO.

:unzip_of
ECHO.Unzipping OF...

IF EXIST "%OF_ZIP%" (
	CALL :getDir "%OF_ZIP%" ofZipDir
	CALL :getFile %OF_ZIP% ofZipName
	ECHO.openFramworks will be unzipped in !WHERE! and OFDIR is !OF_DIR!
 	%UNZIP% x %OF_ZIP% -aoa -o!ofZipDir!
	SET OF_HOME=!ofZipDir!!ofZipName!
	rem Replace the trailing 'nightly' by 'release'
	SET OF_HOME=!OF_HOME:nightly=release!
	SET ofZipName=
	SET ofZipDir=
) ELSE (
	SET OF_HOME=D:\of-git
	CALL :toMsysPath "%OF_HOME%/" MSYS_OF_ROOT
	(
		ECHO.git clone "https://github.com/openframeworks/openFrameworks.git" %MSYS_OF_ROOT%
	)>%MSYS4OF_DIR%\script.sh
	%SH% %MSYS4OF_DIR%\script.sh
	DEL %MSYS4OF_DIR%\script.sh
	ECHO.
	
	GOTO :EOF
)

ECHO.openFramworks unzipped in %OF_HOME%
CALL :toMsysPath "%OF_HOME%/" MSYS_OF_ROOT
ECHO.openFramworks unzipped in %MSYS_OF_ROOT%
ECHO.


:install_of_dependencies
ECHO.Instaling OF Dependencies...
(
	ECHO.echo -ne "\033]0;OF dependencies install\007"
	ECHO.cd %MSYS_OF_ROOT%
	ECHO.scripts/win_cb/msys2/install_dependencies.sh
	rem ECHO.pacman --noconfirm -S ca-certificates
	rem ECHO.pacman --noconfirm -Suy --needed make mingw-w64-i686-gcc mingw-w64-i686-glew mingw-w64-i686-freeglut mingw-w64-i686-FreeImage mingw-w64-i686-opencv mingw-w64-i686-assimp mingw-w64-i686-boost mingw-w64-i686-cairo mingw-w64-i686-clang mingw-w64-i686-gdb mingw-w64-i686-zlib  mingw-w64-i686-tools mingw-w64-i686-pkg-config 
	rem ECHO.pacman --noconfirm -Suy --needed tar git
)>%MSYS4OF_DIR%\script.sh
%SH% %MSYS4OF_DIR%\script.sh
DEL %MSYS4OF_DIR%\script.sh
ECHO.



:compile_of_lib
SET MSYSTEM=MINGW32
ECHO.Compiling OF Library...

(
	ECHO.echo -ne "\033]0;Compiling OF\007"
	echo.cd %MSYS_OF_ROOT%libs/openFrameworksCompiled/project
	echo.export ^>expo.txt
	echo.sleep ^1
	echo.make -j%NUMBER_OF_PROCESSORS% 2>compile.log
	echo.sleep ^15
)>%MSYS4OF_DIR%\script.sh


%SH% %MSYS4OF_DIR%\script.sh
DEL %MSYS4OF_DIR%\script.sh
ECHO.

GOTO:EOF


:getFile fullfilename  var 	-- return the filename only in var
::                 			-- [in] fullfilename: argument description here
::							-- [out] return variable
SETLOCAL
REM.--function body here
set filename=%~n1
(ENDLOCAL & REM -- RETURN VALUES
    IF "%~2" NEQ "" SET %~2=%filename%
)
GOTO:EOF

:getDir fullfilename  var  	-- return the directory only in var
::                 			-- [in] fullfilename: argument description here
::							-- [out] return variable
SETLOCAL
REM.--function body here
set p=%~dp1
(ENDLOCAL & REM -- RETURN VALUES
    IF "%~2" NEQ "" SET %~2=%p%
)
GOTO:EOF

:toMsysPath winPath msysPath	-- return the msys path that correspond to winpath (C:\Windows gives /c/Windows)
::								-- [in] winpath : The windows style path
::								-- [out] return variable
SETLOCAL
REM.--function body here
set drive=%~d1
set drive=%drive:~0,1%
set p=%~p1
set p=%p:\=/%
echo %d%
(ENDLOCAL & REM -- RETURN VALUES
    IF "%~2" NEQ "" SET %~2=/%drive%%p%
)
GOTO:EOF

:tmpScript var	-- return the msys path that correspond to winpath (C:\Windows gives /c/Windows)
::								-- [in] winpath : The windows style path
::								-- [out] return variable
SETLOCAL
REM.--function body here
set shscript=%TIME::=%
set shscript=%shscript:,=%
set shscript=%shscript: =%
set shscript=tmp%shscript%.sh
(ENDLOCAL & REM -- RETURN VALUES
    IF "%~1" NEQ "" SET %~1=%shscript%
)
GOTO:EOF
