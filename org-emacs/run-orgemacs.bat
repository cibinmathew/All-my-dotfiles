set HOME=%~dp0
REM creates its own .emacs.d folder in cwd; 
REM this Emacs has its own package directory in its own .emacs.d directory. That may or may not be what you want. 
REM If you want to share the package directory, you can change package-user-dir or create a symbolic link 
REM to the to-be-shared package directory using Link Shell Extension.

C:\cbn_gits\emacs\emacs-w64-25.2-O2-with-modules\emacs\bin\runemacs.exe --xrm "emacs.Background: light gray" --load %HOME%/../org-emacs/init.el



REM "C:\cbn_gits\emacs\emacs-w64-25.2-O2-with-modules\emacs\bin\runemacs.exe" -q 
REM --load ~/org-emacs/init.el