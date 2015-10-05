@echo 
@color 02
@title openFrameworks MSYS2 Installer

set SRC_DIR=%~dp0
set OF_ROOT=%~dp0\..\..\..
set instdir=%OF_ROOT%
set msys2=msys64
set msysbase=msys2-base-x86_64-20150512.tar.xz

set msyspackages=mingw-w64-i686-gcc mingw-w64-i686-glew mingw-w64-i686-freeglut mingw-w64-i686-FreeImage mingw-w64-i686-opencv mingw-w64-i686-assimp mingw-w64-i686-boost mingw-w64-i686-cairo mingw-w64-i686-clang mingw-w64-i686-gdb mingw-w64-i686-zlib  mingw-w64-i686-tools mingw-w64-i686-pkg-config
set ofpackages=git cmake make mingw-w64-i686-gcc mingw-w64-i686-glew mingw-w64-i686-freeglut mingw-w64-i686-FreeImage mingw-w64-i686-opencv mingw-w64-i686-assimp mingw-w64-i686-boost mingw-w64-i686-cairo mingw-w64-i686-clang mingw-w64-i686-gdb mingw-w64-i686-zlib mingw-w64-i686-tools mingw-w64-i686-pkg-config 

set ofpackages_64=mingw-w64-x86_64-clang mingw-w64-x86_64-gcc mingw-w64-x86_64-gdb mingw-w64-x86_64-zlib mingw-w64-x86_64-tools mingw-w64-x86_64-ninja mingw-w64-x86_64-boost mingw-w64-x86_64-cairo mingw-w64-x86_64-mpg123 mingw-w64-x86_64-openal mingw-w64-x86_64-assimp mingw-w64-x86_64-opencv mingw-w64-x86_64-libusb mingw-w64-x86_64-openssl mingw-w64-x86_64-libiconv mingw-w64-x86_64-freetype mingw-w64-x86_64-libsndfile mingw-w64-x86_64-fontconfig mingw-w64-x86_64-pkg-config 
set ofpackages_32=mingw-w64-i686-clang mingw-w64-i686-gcc mingw-w64-i686-gdb mingw-w64-i686-zlib mingw-w64-i686-tools mingw-w64-i686-ninja mingw-w64-i686-boost mingw-w64-i686-cairo mingw-w64-i686-mpg123 mingw-w64-i686-openal mingw-w64-i686-assimp mingw-w64-i686-opencv mingw-w64-i686-libusb mingw-w64-i686-openssl mingw-w64-i686-libiconv mingw-w64-i686-freetype mingw-w64-i686-libsndfile mingw-w64-i686-fontconfig mingw-w64-i686-pkg-config 

rem mingw-w64-i686-jsoncpp


IF EXIST %instdir%\%msys2%\usr\bin\msys-2.0.dll GOTO update_msys2

:install_msys2
IF NOT EXIST %instdir%\%msys2%\usr\bin\msys-2.0.dll (
ECHO.Installing MSYS2...
	IF EXIST "%SRC_DIR%\bin\%msysbase%" (
		%SRC_DIR%\bin\7za.exe x %SRC_DIR%\bin\%msysbase% -so | %SRC_DIR%\bin\7za.exe x -aoa -si -ttar -o%instdir%
	)
	(
		echo.sleep ^5
		echo.exit
	)>%instdir%\script.sh
	
	%instdir%\%msys2%\usr\bin\mintty.exe -i /msys2.ico /usr/bin/bash --login %instdir%\script.sh
	

    
	del %instdir%\script.sh
)

:update_msys2
ECHO.Updating MSYS2...
(
	echo.echo -ne "\033]0;Msys2 update\007"
	echo.pacman --noconfirm -Sy 
	echo.pacman --noconfirm --needed -S bash pacman pacman-mirrors msys2-runtime
	echo.kill -9 -1
)>%instdir%\script.sh
%instdir%\%msys2%\usr\bin\mintty.exe -i /msys2.ico /usr/bin/bash --login %instdir%\script.sh

del %instdir%\script.sh



:compile_ofnode
ECHO.Instaling OF Dependencies
(
	echo.pacman --noconfirm -S ca-certificates
	echo.pacman --noconfirm -Sy --needed make mingw-w64-i686-gcc mingw-w64-i686-glew mingw-w64-i686-freeglut mingw-w64-i686-FreeImage mingw-w64-i686-opencv mingw-w64-i686-assimp mingw-w64-i686-boost mingw-w64-i686-cairo mingw-w64-i686-clang mingw-w64-i686-gdb mingw-w64-i686-zlib  mingw-w64-i686-tools mingw-w64-i686-pkg-config 
	echo.pacman --noconfirm -Sy --needed tar
)>%instdir%\script.sh
%instdir%\%msys2%\usr\bin\mintty.exe -i /msys2.ico /usr/bin/bash --login %instdir%\script.sh


ECHO.Compiling OF
(
	echo.cd /d/of_installer2/of_v20150923_win_cb_release/libs/openFrameworksCompiled/project
	echo.make -j8 
)>%instdir%\script.sh
%instdir%\%msys2%\usr\bin\mintty.exe -i /msys2.ico /usr/bin/bash --login %instdir%\script.sh

del %instdir%\script.sh






goto :EOF

::Download the necessary packages from Internet

setlocal EnableDelayedExpansion
IF NOT EXIST %instdir%\packages\wget-1.16.3-1-x86_64.pkg.tar.xz (
	PUSHD %instdir%\packages
	@FOR /F %%p IN (%instdir%\bin\ofpackages.downloads) DO (
		ECHO ====
		set url=%%p
		FOR /f %%q IN ("!url!") DO (
			set filename=%%~nxq
		)
		ECHO.Checking !filename!
		IF NOT EXIST !filename! (
			@ECHO.  * Downloading !filename!
			%instdir%\bin\wget -nv !URL!
		)
		IF EXIST !filename! (
			@ECHO.OK
		) ELSE (
			@ECHO.KO
		)
	)
	POPD
)

:askToInstall
ECHO.Do you want to proceed with the installation ?
SET /P answer="(Y/N) : "
IF /I "%answer:~0,1%" EQU "Y" GOTO unpack
IF /I "%answer:~0,1%" EQU "N" GOTO :EOF
GOTO askToInstall


:unpack
IF EXIST "%instdir%\bin\%msysbase%" (
	%instdir%\bin\7za.exe x %instdir%\bin\%msysbase% -so | %instdir%\bin\7za.exe x -aoa -si -ttar
)
set PACKAGES_TMP=packages-tmp
MKDIR %instdir%\%msys2%\%PACKAGES_TMP%
COPY %instdir%\packages\*.tar.xz %instdir%\%msys2%\%PACKAGES_TMP%




:getMintty
set PACMANCONF=%instdir%\%msys2%\etc\pacman.conf
if not exist %instdir%\mintty.lnk (
    echo -------------------------------------------------------------------------------
    echo.
    echo.- make a first run
    echo.
    echo -------------------------------------------------------------------------------

    echo.sleep ^4>>firstrun.sh
    echo.exit>>firstrun.sh
    %instdir%\%msys2%\usr\bin\mintty.exe -i /msys2.ico /usr/bin/bash --login %instdir%\firstrun.sh
    del firstrun.sh
	
	

    echo.-------------------------------------------------------------------------------
    echo.first update
    echo.------------------------------------------------------------------------------- 
	MOVE %PACMANCONF% %PACMANCONF%.save
	(
	ECHO.[options]
	ECHO.HoldPkg
	ECHO.Architecture = auto
	ECHO.CheckSpace
	ECHO.SigLevel    = Required DatabaseOptional
	ECHO.LocalFileSigLevel = Optional
	ECHO.[custom]
	ECHO.SigLevel = Optional TrustAll
	ECHO.Server = file:///%PACKAGES_TMP%
	)>> %PACMANCONF%
    if exist %instdir%\firstUpdate.sh del %instdir%\firstUpdate.sh
    (
        echo.echo -ne "\033]0;first msys2 update\007"
		echo.repo-add /%PACKAGES_TMP%/custom.db.tar.gz /%PACKAGES_TMP%/*
		
        echo.pacman --noconfirm --force -Sy %ofpackages%
        echo.sleep ^4
        echo.exit
        )>>%instdir%\firstUpdate.sh
    %instdir%\%msys2%\usr\bin\mintty.exe -i /msys2.ico /usr/bin/bash --login %instdir%\firstUpdate.sh
	
	
    cls
	
	DEL %PACMANCONF%
	MOVE %PACMANCONF%.save %PACMANCONF%
	
    del %instdir%\firstUpdate.sh
	
    (
        echo.Set Shell = CreateObject^("WScript.Shell"^)
        echo.Set link = Shell.CreateShortcut^("%instdir%\mintty.lnk"^)
        echo.link.Arguments = "-i /msys2.ico /usr/bin/bash --login"
        echo.link.Description = "msys2 shell console"
        echo.link.TargetPath = "%instdir%\%msys2%\usr\bin\mintty.exe"
        echo.link.WindowStyle = ^1
        echo.link.IconLocation = "%instdir%\%msys2%\msys2.ico"
        echo.link.WorkingDirectory = "%instdir%\%msys2%\usr\bin"
        echo.link.Save
        )>>%instdir%\setlink.vbs
    cscript /nologo %instdir%\setlink.vbs
    del %instdir%\setlink.vbs
)


if not exist %instdir%\%msys2%\home\%USERNAME% mkdir %instdir%\%msys2%\home\%USERNAME%
(
	echo.BoldAsFont=no
	echo.BackgroundColour=57,57,57
	echo.ForegroundColour=221,221,221
	echo.Transparency=medium
	echo.FontHeight=^9
	echo.FontSmoothing=full
	echo.AllowBlinking=yes
	echo.Font=DejaVu Sans Mono
	echo.Columns=120
	echo.Rows=30
	echo.Term=xterm-256color
	echo.CursorType=block
	echo.ClicksPlaceCursor=yes
	echo.Black=38,39,41
	echo.Red=249,38,113
	echo.Green=166,226,46
	echo.Yellow=253,151,31
	echo.Blue=102,217,239
	echo.Magenta=158,111,254
	echo.Cyan=94,113,117
	echo.White=248,248,242
	echo.BoldBlack=85,68,68
	echo.BoldRed=249,38,113
	echo.BoldGreen=166,226,46
	echo.BoldYellow=253,151,31
	echo.BoldBlue=102,217,239
	echo.BoldMagenta=158,111,254
	echo.BoldCyan=163,186,191
	echo.BoldWhite=248,248,242
	)>>%instdir%\%msys2%\home\%USERNAME%\.minttyrc

GOTO :EOF
	
:getmingw32
if %build32%==yes (
if exist "%instdir%\%msys2%\etc\pac-mingw32-old.pk" del "%instdir%\%msys2%\etc\pac-mingw32-old.pk"
if exist "%instdir%\%msys2%\etc\pac-mingw32-new.pk" ren "%instdir%\%msys2%\etc\pac-mingw32-new.pk" pac-mingw32-old.pk

for %%i in (%mingwpackages%) do echo.mingw-w64-i686-%%i>>%instdir%\%msys2%\etc\pac-mingw32-new.pk

if exist %instdir%\%msys2%\mingw32\bin\gcc.exe GOTO getmingw64
    echo.-------------------------------------------------------------------------------
    echo.install 32 bit compiler
    echo.-------------------------------------------------------------------------------
    if exist %instdir%\mingw32.sh del %instdir%\mingw32.sh
    (
        echo.echo -ne "\033]0;install 32 bit compiler\007"
        echo.pacman --noconfirm -S $(cat /etc/pac-mingw32-new.pk ^| sed -e 's#\\##'^)
        echo.sleep ^3
        echo.exit
        )>>%instdir%\mingw32.sh
    %instdir%\%msys2%\usr\bin\mintty.exe -i /msys2.ico /usr/bin/bash --login %instdir%\mingw32.sh
    del %instdir%\mingw32.sh
    )

:getmingw64
if %build64%==yes (
if exist "%instdir%\%msys2%\etc\pac-mingw64-old.pk" del "%instdir%\%msys2%\etc\pac-mingw64-old.pk"
if exist "%instdir%\%msys2%\etc\pac-mingw64-new.pk" ren "%instdir%\%msys2%\etc\pac-mingw64-new.pk" pac-mingw64-old.pk

for %%i in (%mingwpackages%) do echo.mingw-w64-x86_64-%%i>>%instdir%\%msys2%\etc\pac-mingw64-new.pk

if exist %instdir%\%msys2%\mingw64\bin\gcc.exe GOTO updatebase
    echo.-------------------------------------------------------------------------------
    echo.install 64 bit compiler
    echo.-------------------------------------------------------------------------------
    if exist %instdir%\mingw64.sh del %instdir%\mingw64.sh
        (
        echo.echo -ne "\033]0;install 64 bit compiler\007"
        echo.pacman --noconfirm -S $(cat /etc/pac-mingw64-new.pk ^| sed -e 's#\\##'^)
        echo.sleep ^3
        echo.exit
        )>>%instdir%\mingw64.sh
    %instdir%\%msys2%\usr\bin\mintty.exe -i /msys2.ico /usr/bin/bash --login %instdir%\mingw64.sh
    del %instdir%\mingw64.sh
    )


	
	
	
::to compile openFrameworks
:: make in of_v20150829_win_cb_release/libs/openFrameworksCompiled/project

:: Building list of installed packages
:: pacman -Qenq > pkg.list

:: Downloading packages from list
:: cat pkg.list | pacman -Sw -
:: pacman -S $(< pkglist.txt)

:: Build download list
:: pacman -Sp --noconfirm $(<pkg.list) >download.list
:: wget -nv -i ../pkglist

 ::copy to /var/cache/pacman/pkg and finally run
 :: pacman -S packname
 
 ::pacman -U *.tar.gz



