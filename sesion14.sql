-- Creamos el objeto Vehiculo
CREATE OR REPLACE TYPE Vehiculo AS OBJECT (
    Marca VARCHAR2(50),
    Anio NUMBER,
    MEMBER FUNCTION obtener_antiguedad RETURN NUMBER
) NOT FINAL;
/

CREATE OR REPLACE TYPE BODY Vehiculo AS 
    MEMBER FUNCTION obtener_antiguedad RETURN NUMBER IS
    BEGIN
        RETURN FLOOR(MONTHS_BETWEEN(SYSDATE, Anio) / 12);
    END;
END;
/

-- Creamos el subtipo Automovil
CREATE OR REPLACE TYPE Automovil UNDER Vehiculo (
    NumeroPuertas NUMBER,
    MEMBER FUNCTION descripcion RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY Automovil AS
    MEMBER FUNCTION descripcion RETURN VARCHAR2 IS
    BEGIN
        RETURN 'Marca: ' || Marca || ' - Año: ' || Anio || ' - Numero de Puertas: ' || NumeroPuertas;
    END;
END;
/

-- Creamos el subtipo Camion
CREATE OR REPLACE TYPE Camion UNDER Vehiculo (
    CapacidadCarga NUMBER,
    OVERRIDING MEMBER FUNCTION obtener_antiguedad RETURN NUMBER
);
/

CREATE OR REPLACE TYPE BODY Camion AS
    OVERRIDING MEMBER FUNCTION obtener_antiguedad RETURN NUMBER IS
    BEGIN
        RETURN FLOOR(MONTHS_BETWEEN(SYSDATE, Anio) / 12) + 2;
    END;
END;
/

-- Insercion de datos
CREATE TABLE Vehiculos OF Vehiculo; -- Creacion de tabla

INSERT INTO Vehiculos VALUES (Camion('Scania', 2008, 24));

SELECT v.Marca, v.obtener_antiguedad() AS Antiguedad FROM Vehiculos v
WHERE VALUE(v) IS OF (Camion)