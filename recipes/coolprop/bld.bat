cd wrappers\Python
"%PYTHON%" setup.py install cmake=vc%VS_MAJOR%,%ARCH%
IF %ERRORLEVEL% NEQ 0 EXIT /B %ERRORLEVEL%
