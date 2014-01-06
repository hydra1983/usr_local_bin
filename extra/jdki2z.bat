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