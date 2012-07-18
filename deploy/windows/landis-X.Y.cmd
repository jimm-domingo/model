@echo off
rem For log4net initialization
set WORKING_DIR=%CD%

set ScriptDir=%~dp0
rem Trim off trailing "\bin\"
set LandisRootDir=%ScriptDir:~0,-5%

set FileName=%~n0
set Version=%FileName:landis-=%
for /f "delims=." %%X in ("%Version%") do set MajorVer=%%X

"%LandisRootDir%\v%MajorVer%\bin\Landis.Console-%Version%.exe" %*
