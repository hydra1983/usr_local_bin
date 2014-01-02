@ECHO off
SET SONAR_OPTS=
SET SONAR_OPTS=%SONAR_OPTS% -DlocalRepository=D:\.cygwin\home\edison\.m2\repository
SET SONAR_OPTS=%SONAR_OPTS% -Dsonar.host.url=http://192.168.56.2:9000
SET SONAR_OPTS=%SONAR_OPTS% -Dsonar.jdbc.url=jdbc:h2:tcp://192.168.56.2:9092/sonar
SET SONAR_OPTS=%SONAR_OPTS% -Dsonar.jdbc.password=sonar
SET SONAR_OPTS=%SONAR_OPTS% -Dsonar.jdbc.username=sonar
SET SONAR_OPTS=%SONAR_OPTS% -Dsonar.sourceEncoding=UTF-8
SET SONAR_OPTS=%SONAR_OPTS% -Dsonar.language=%*

%M2_HOME%/bin/mvn.bat sonar:sonar %SONAR_OPTS% 