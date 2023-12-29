CREATE TABLE TBL_PAISES (ID integer PRIMARY KEY, PAIS varchar(50));

CREATE TABLE TBL_DEPTOS (ID integer PRIMARY KEY, PAIS integer REFERENCES TBL_PAISES(ID), DEPTO varchar(50));

# Secuencias para manejar los IDs

CREATE SEQUENCE seq_tbl_paises_id;
CREATE SEQUENCE seq_tbl_deptos_id;

# funcion para insertar en tbl_paises

CREATE OR REPLACE FUNCTION insertar_en_tbl_paises(p_pais VARCHAR)
RETURNS INTEGER AS $$
DECLARE
    v_existe INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_existe
    FROM tbl_paises
    WHERE pais = p_pais;

    IF v_existe = 0 THEN
        INSERT INTO tbl_paises(id, pais) 
        VALUES (NEXTVAL('seq_tbl_paises_id'), p_pais);
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

# Funcion para insertar en tbl_deptos

CREATE OR REPLACE FUNCTION insertar_en_tbl_deptos(p_pais_id INTEGER, p_depto VARCHAR)
RETURNS INTEGER AS $$
DECLARE
    v_existe INTEGER;
BEGIN
    SELECT COUNT(*)
    INTO v_existe
    FROM tbl_deptos
    WHERE pais = p_pais_id AND depto = p_depto;

    IF v_existe = 0 THEN
        INSERT INTO tbl_deptos(id, pais, depto) 
        VALUES (NEXTVAL('seq_tbl_deptos_id'), p_pais_id, p_depto);
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
END;
$$ LANGUAGE plpgsql;

# Uso de las Funciones

SELECT insertar_en_tbl_paises('Nombre del País');

SELECT insertar_en_tbl_deptos(1, 'Nombre del Departamento');


