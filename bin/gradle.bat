@ECHO off
SET GRADLE_HOME=D:\usr\share\gradle-1.8
SET PATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;%GRADLE_HOME%\bin;
gradle %*