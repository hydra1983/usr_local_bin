@ECHO off
SET PATH=%SystemRoot%\system32;%SystemRoot%;%SystemRoot%\System32\Wbem;D:\usr\local\bin;
"D:\usr\local\lib\phantomjs-1.9.2-windows\phantomjs" --output-encoding=GBK D:\usr\local\lib\phantomjs-1.9.2-windows\examples\rasterize.js %*