@ECHO off
SET PATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;D:\usr\local\bin;
"%JAVA_HOME%\bin\java.exe" -cp "D:\usr\share\clojure-1.5.1\clojure-1.5.1.jar" clojure.main