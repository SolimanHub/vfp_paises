FUNCTION ConectarBD
	cn = SQLSTRINGCONNECT("Driver={PostgreSQL Unicode};Server=localhost;Port=5432;Database=postgres;Uid=postgres;Pwd=rx;")
	IF NOT cn > 0 THEN 
		MESSAGEBOX("Error en conexion")
	ENDIF 
	RETURN cn
ENDFUNC