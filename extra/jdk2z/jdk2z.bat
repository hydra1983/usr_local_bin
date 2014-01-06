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

		If [%2]==[] (Set target_archive_path=%cd%\%jdk_installer_name%.zip) Else (Set target_archive_path=%2)
		For /f "delims=" %%i In ("%target_archive_path%") Do Set target_archive_path=%%~i
		For /f "delims=" %%i In ("%target_archive_path%") Do Set target_archive_ext=%%~xi
		If "%target_archive_ext%"=="" (
			Set target_archive_ext=zip
			Set target_archive_path=!target_archive_path!\%jdk_installer_name%.%target_archive_ext%
		) Else (
			Set target_archive_ext=!target_archive_ext:~1!
		)

		For /f "delims=" %%i In ("%target_archive_path%") Do Set target_archive_full_path=%%~fi

		Echo [INFO] Source:%jdk_installer_full_path%
		Echo [INFO] Target:%target_archive_full_path%

		Set 7z="%~dp07z\7z.exe"
		For /f "usebackq tokens=*" %%i In (`Cscript "%~dp0uuidgen.vbs"`) Do Set uuid=%%i
		For /f "tokens=1* delims=;" %%i In ("%TEMP%") Do Set tmpdir=%%i
		Set outputdir=%tmpdir%\%uuid%

		Echo [INFO] Extract to "%outputdir%"
		!7z! x -y -o"%outputdir%" "%jdk_installer_full_path%" > NUL

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

		Echo [INFO] Build "%target_archive_full_path%"
		If Exist "%target_archive_full_path%" Del "%target_archive_full_path%"
		!7z! a -t%target_archive_ext% "%target_archive_full_path%" * -r > NUL
	popd	
Goto eof

:empty_source
Goto usage

:unexisting_source
	Echo File "%jdk_installer_full_path%" not exists
Goto error

:usage
	Echo Build archive files from executable installer of oracle jdk 
	Echo.
	Echo Usage: %~n0 jdk_installer_path [target_archive_path]
	Echo. 
	Echo     Example 1:
	Echo.
	Echo         jdk2z C:\Users\{User}\Desktop\jdk-6u45-windows-i586.exe
	Echo         D:\usr\local\lib\oraclejdk-1.6.0_45-x32
	Echo.
	Echo     You will find "jdk-6u45-windows-i586.zip" in directory
	Echo     "D:\usr\local\lib\oraclejdk-1.6.0_45-x32"
	Echo. 
	Echo     Example 2:
	Echo.
	Echo         jdk2z C:\Users\{User}\Desktop\jdk-6u45-windows-i586.exe
	Echo         D:\usr\local\lib\oraclejdk-1.6.0_45-x32.7z
	Echo.
	Echo     You will find "oraclejdk-1.6.0_45-x32.7z" in directory
	Echo     "D:\usr\local\lib"
	Echo. 
	Echo     Example 3:
	Echo.
	Echo         jdk2z jdk-6u45-windows-i586.exe oraclejdk-1.6.0_45-x32.7z
	Echo.
	Echo     You will find "oraclejdk-1.6.0_45-x32.7z" in current directory
Goto eof

REM ########################################
REM # Script End
REM ########################################
:error
	Exit /b 1

:eof
 	Exit /b 0