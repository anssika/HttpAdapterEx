Zn "HTTP"
Do ##class(%SYSTEM.OBJ).ImportDir("/opt/irisbuild/src/Http", "*.cls", "c" , .errlog, 1, .imported)
Do ##class(%SYSTEM.OBJ).ImportDir("/opt/irisbuild/src/HTTPKG", "*.cls", "c" , .errlog, 1, .imported)
Halt
