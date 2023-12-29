# mis_funciones

```
FUNCTION ConectarBD
	cn = SQLSTRINGCONNECT("Driver={PostgreSQL Unicode};Server=localhost;Port=5432;Database=postgres;Uid=postgres;Pwd=rx;")
	IF NOT cn > 0 THEN 
		MESSAGEBOX("Error en conexion")
	ENDIF 
	RETURN cn
ENDFUNC
```

# form1

## init
```
PUBLIC cn, lcSQL

SET PROCEDURE TO C:\Users\rx\Documents\vfp\paises\mis_funciones.prg
&&SET STEP ON

cn = ConectarBD()
THIS.MTD_CARGAR_CBX_PAISES() && ESTE METODO ES GENERADO POR MI
```

## MTD_CARGAR_CBX_PAISES
```
LCSQL = "SELECT pais FROM tbl_paises ORDER BY pais;"

SQLEXEC(CN, LCSQL, "CURSOR_PAISES")

THISFORM.CBX_LISTA_PAISES.Clear()
THISFORM.CBX_LISTA_PAISES.AddItem("Seleccione un país")
SCAN FOR NOT EOF('CURSOR_PAISES')
    lcPais = CURSOR_PAISES.pais
    THISFORM.CBX_LISTA_PAISES.AddItem(lcPais)
ENDSCAN
THISFORM.CBX_LISTA_PAISES.ListIndex = 1
```

##QUERYUNLOAD
```
IF MESSAGEBOX("Confirma que desea abandonar esta pantalla?", 36,"Salir") = 6 THEN
	THIS.Release
ELSE
	NODEFAULT
ENDIF
```

# btn_salir

```
THISFORM.QUERYUNLOAD()
```

# BTN_GUARDAR_PAIS

## CLICK
```
LOCAL lcPAIS, nRespuestaFuncion
lcPAIS = ALLTRIM(THISFORM.TBX_NV_PAIS.Value)
IF EMPTY(lcPAIS)
    MESSAGEBOX("Ingrese el nombre de un país en el campo de texto.", 48, "Advertencia")
    RETURN
ENDIF
IF MESSAGEBOX("¿Confirma que los datos son correctos?",4+32,"Confirmar") = 6 THEN
	lcPAIS = UPPER(lcPAIS)
	lcSQL = "SELECT insertar_en_tbl_paises('" + lcPAIS + "')"
    nResultado = SQLEXEC(cn, lcSQL, "curResultado")
    IF nResultado > 0    
    	SELECT curResultado
        GO TOP    
        nRespuestaFuncion = curResultado.Insertar_en_tbl_paises
        IF nRespuestaFuncion = 0
            MESSAGEBOX("País guardado con éxito.", 64, "Éxito")
            THISFORM.TBX_NV_PAIS.Value = ""
            THISFORM.MTD_CARGAR_CBX_PAISES()
        ELSE
            MESSAGEBOX("Este país ya está registrado.", 16, "Error")
        ENDIF
    ELSE
        MESSAGEBOX("No se pudo ejecutar la consulta.", 16, "Error")
    ENDIF
    USE IN curResultado	
ENDIF
```

# CBXLISTA_PAISES

## InteractiveChange
```
IF THIS.Value = "Seleccione un país"
    MESSAGEBOX("Por favor, selecciona un país de la lista.", 48, "Aviso")
ELSE
	THISFORM.LBL_PAIS.Caption = THIS.VALUE
    &&MESSAGEBOX(THIS.LISTINDEX)    
ENDIF
```