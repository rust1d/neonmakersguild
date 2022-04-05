forfiles /p db\sprocs /m *.sql /c "cmd /c C:\Progra~1\MySQL\MYSQLS~1.7\bin\mysql -v -uroot -p%1 neonmakersguild < @path

forfiles /p db\functions /m *.sql /c "cmd /c C:\PROGRA~1\MySQL\MYSQLS~1.7\bin\mysql -v -uroot -p%1 neonmakersguild < @path
