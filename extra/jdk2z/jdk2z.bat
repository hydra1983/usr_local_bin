@Echo off
Goto main

REM ########################################
REM # Script Begin
REM ########################################
:main
	SetLocal enabledelayedexpansion
		REM # Check Arguments
		If [%1]==[] Goto empty_source
		Set jdk_installer_path=%1
		For /f "delims=" %%i In ("%jdk_installer_path%") Do Set jdk_installer_path=%%~i
		For /f "delims=" %%i In ("%jdk_installer_path%") Do Set jdk_installer_full_path=%%~fi
		If Not Exist "%jdk_installer_full_path%" Goto unexisting_source
		For /f "delims=" %%i In ("%jdk_installer_path%") Do Set jdk_installer_name=%%~ni

		If [%2]==[] (Set target_zip_path=%cd%\%jdk_installer_name%.zip) Else (Set target_zip_path=%2)
		For /f "delims=" %%i In ("%target_zip_path%") Do Set target_zip_path=%%~i
		For /f "delims=" %%i In ("%target_zip_path%") Do Set target_zip_ext=%%~xi
		If "%target_zip_ext%"=="" (
			Set target_zip_path=!target_zip_path!\%jdk_installer_name%.zip
		)

		Echo [INFO] Source:%jdk_installer_path%
		Echo [INFO] Target:%target_zip_path%

		Set 7z="%~dp07z\7z.exe"
		For /f "usebackq tokens=*" %%i In (`Cscript "%~dp0uuidgen.vbs"`) Do Set uuid=%%i
		For /f "tokens=1* delims=;" %%i In ("%TEMP%") Do Set tmpdir=%%i
		Set outputdir=%tmpdir%\%uuid%

		Echo [INFO] Extract to "%outputdir%"
		!7z! x -y -o"%outputdir%" "%jdk_installer_path%" > NUL

		If Exist "%outputdir%\.rsrc" call :process_jdk6
		If Exist "%outputdir%\tools" call :process_jdk7

		Echo [INFO] Remove %outputdir%
		Rmdir /s /q %outputdir%
	EndLocal
Goto eof

REM ########################################
REM # Functions
REM ########################################
:process_jdk6
	pushd "%outputdir%\.rsrc\JAVA_CAB10"
		extrac32 111 > NUL
		Call :build_archive
	popd
Goto eof

:process_jdk7
	pushd "%outputdir%"
		Call :build_archive
	popd
Goto eof

:build_archive
	Echo [INFO] Extract to "%CD%\tools"
	!7z! x -y -otools tools.zip > NUL

	pushd tools
		Echo [INFO] Unpack jars in "%cd%"
		For /r %%i In (*.pack) Do .\bin\unpack200 -r "%%i" "%%~di%%~pi%%~ni.jar" > NUL

		Echo [INFO] Build "%target_zip_path%"
		If Exist "%target_zip_path%" Del "%target_zip_path%"
		!7z! a -tzip "%target_zip_path%" * -r > NUL
	popd	
Goto eof

:empty_source
Goto usage

:unexisting_source
	Echo File "%jdk_installer_path%" not exists
Goto error

:usage
	Echo Usage:
	Echo %~n0 jdk_installer_path [target_zip_path]
Goto eof

REM ########################################
REM # Script End
REM ########################################
:error
	Exit /b 1

:eof
 	Exit /b 0
==================================================
JDK is not available as a portable zip unfortunately. However, you can:

Create working JDK directory ("C:\JDK" in this case)
Download latest version of JDK from oracle (for example "jdk-7u7-windows-i586.exe")
Download and install 7-zip or download 7-zip portable version if you are not administrator
With 7-zip extract all the files from "jdk-7u7-windows-i586.exe" in directory "C:\JDK"
In command shell (cmd.exe) do the following:

--> change directory to directory C:\JDK.rsrc\JAVA_CAB10

--> execute command: extrac32 111

Unpack C:\JDK.rsrc\JAVA_CAB10\tools.zip with 7-zip

In command shell (cmd.exe) do the following:

--> change directory to C:\JDK.rsrc\JAVA_CAB10\tools\

--> execute command: for /r %x in (*.pack) do .\bin\unpack200 -r "%x" "%~dx%~px%~nx.jar" (this will convert all pack files into jar)

Copy whole directory and all subdir of c:\JDK.rsrc\JAVA_CAB10\tools" where you want your JDK to be and setup manually JAVA_HOME and PATH to point to your JDK dir and its BIN subdir.

Thats all. After this you'll be able at least to use javac.exe
========================================