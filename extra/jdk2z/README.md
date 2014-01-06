```batch
Build archive files from executable installer of oracle jdk

Usage: jdk2z jdk_installer_path [target_archive_path]

    Example 1:

        jdk2z C:\Users\{User}\Desktop\jdk-6u45-windows-i586.exe
        D:\usr\local\lib\oraclejdk-1.6.0_45-x32

    You will find "jdk-6u45-windows-i586.zip" in directory
    "D:\usr\local\lib\oraclejdk-1.6.0_45-x32"

    Example 2:

        jdk2z C:\Users\{User}\Desktop\jdk-6u45-windows-i586.exe
        D:\usr\local\lib\oraclejdk-1.6.0_45-x32.7z

    You will find "oraclejdk-1.6.0_45-x32.7z" in directory
    "D:\usr\local\lib"

    Example 3:

        jdk2z jdk-6u45-windows-i586.exe oraclejdk-1.6.0_45-x32.7z

    You will find "oraclejdk-1.6.0_45-x32.7z" in current directory
```
