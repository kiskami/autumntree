set PATH=c:\mingw\bin;%PATH%
@REM ..\..\..\raylib-5.5_win64_mingw-w64\lib\libraylibdll.a
c:\mingw\bin\gcc -shared -O3 -o libraylib-adapter.dll -I..\..\..\raylib-5.5\src ..\claw-raylib\lib\libraylib-adapter.x86_64-pc-windows-gnu.c ..\..\..\raylib-5.5_win64_mingw-w64\lib\raylib.dll
@REM -L..\..\..\raylib-5.5_win64_mingw-w64\lib -lraylibdll

c:\mingw\bin\gcc -shared -O3 -o librlgl-adapter.dll -I..\..\..\raylib-5.5\src ..\claw-raylib\lib\librlgl-adapter.x86_64-pc-windows-gnu.c ..\..\..\raylib-5.5_win64_mingw-w64\lib\raylib.dll
