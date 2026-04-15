-- sesion1.sql: Script para la Sesión 1

-- Detener la ejecución si ocurre un error
WHENEVER SQLERROR EXIT SQL.SQLCODE;

-- Cambiar al PDB XEPDB1
ALTER SESSION SET CONTAINER = XEPDB1;

-- Crear un nuevo usuario (esquema) para el curso en el PDB
CREATE USER curso_topicos IDENTIFIED BY curso2025;

-- Otorgar privilegios necesarios al usuario
GRANT CONNECT, RESOURCE, CREATE SESSION TO curso_topicos;
GRANT CREATE TABLE, CREATE TYPE, CREATE PROCEDURE TO curso_topicos;
GRANT UNLIMITED TABLESPACE TO curso_topicos;

-- Confirmar creación
SELECT username FROM dba_users WHERE username = 'CURSO_TOPICOS';

-- Cambiar al esquema curso_topicos
ALTER SESSION SET CURRENT_SCHEMA = curso_topicos;

-- Habilitar salida de mensajes para PL/SQL
SET SERVEROUTPUT ON;

-- Crear tabla Clientes
BEGIN
    DBMS_OUTPUT.PUT_LINE('Creando tabla Clientes...');
    EXECUTE IMMEDIATE 'CREATE TABLE Clientes (
        ClienteID NUMBER PRIMARY KEY,
        Nombre VARCHAR2(50),
        Ciudad VARCHAR2(50),
        FechaNacimiento DATE
    )';
    DBMS_OUTPUT.PUT_LINE('Tabla Clientes creada.');
END;
/

-- Crear tabla Pedidos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Creando tabla Pedidos...');
    EXECUTE IMMEDIATE 'CREATE TABLE Pedidos (
        PedidoID NUMBER PRIMARY KEY,
        ClienteID NUMBER,
        Total NUMBER,
        FechaPedido DATE,
        CONSTRAINT fk_pedido_cliente FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
    )';
    DBMS_OUTPUT.PUT_LINE('Tabla Pedidos creada.');
END;
/

-- Crear tabla Productos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Creando tabla Productos...');
    EXECUTE IMMEDIATE 'CREATE TABLE Productos (
        ProductoID NUMBER PRIMARY KEY,
        Nombre VARCHAR2(50),
        Precio NUMBER
    )';
    DBMS_OUTPUT.PUT_LINE('Tabla Productos creada.');
END;
/

-- Insertar datos en Clientes
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertando datos en Clientes...');
    INSERT INTO Clientes VALUES (1, 'Juan Perez', 'Santiago', TO_DATE('1990-05-15', 'YYYY-MM-DD'));
    INSERT INTO Clientes VALUES (2, 'María Gomez', 'Valparaiso', TO_DATE('1985-10-20', 'YYYY-MM-DD'));
    INSERT INTO Clientes VALUES (3, 'Ana Lopez', 'Santiago', TO_DATE('1995-03-10', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Datos insertados en Clientes.');
END;
/

-- Insertar datos en Pedidos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertando datos en Pedidos...');
    INSERT INTO Pedidos VALUES (101, 1, 600, TO_DATE('2025-03-01', 'YYYY-MM-DD'));
    INSERT INTO Pedidos VALUES (102, 1, 300, TO_DATE('2025-03-02', 'YYYY-MM-DD'));
    INSERT INTO Pedidos VALUES (103, 2, 800, TO_DATE('2025-03-03', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Datos insertados en Pedidos.');
END;
/

-- Insertar datos en Productos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertando datos en Productos...');
    INSERT INTO Productos VALUES (1, 'Laptop', 1200);
    INSERT INTO Productos VALUES (2, 'Mouse', 25);
    DBMS_OUTPUT.PUT_LINE('Datos insertados en Productos.');
END;
/

-- Confirmar los datos insertados antes de continuar
COMMIT;

-- Confirmar creación e inserción de datos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Tablas creadas y datos insertados correctamente.');
END;
/

-- Verificar datos
SELECT * FROM Clientes;
SELECT * FROM Pedidos;
SELECT * FROM Productos;

-- Crear tabla DetallesPedidos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Creando tabla DetallesPedidos...');
    EXECUTE IMMEDIATE 'CREATE TABLE DetallesPedidos (
        DetalleID NUMBER PRIMARY KEY,
        PedidoID NUMBER,
        ProductoID NUMBER,
        Cantidad NUMBER,
        CONSTRAINT fk_detalle_pedido FOREIGN KEY (PedidoID) REFERENCES Pedidos(PedidoID),
        CONSTRAINT fk_detalle_producto FOREIGN KEY (ProductoID) REFERENCES Productos(ProductoID)
    )';
    DBMS_OUTPUT.PUT_LINE('Tabla DetallesPedidos creada.');
END;
/

-- Insertar datos en DetallesPedidos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertando datos en DetallesPedidos...');
    INSERT INTO DetallesPedidos VALUES (1, 101, 1, 2); -- Pedido 101: 2 Laptops
    INSERT INTO DetallesPedidos VALUES (2, 101, 2, 5); -- Pedido 101: 5 Mouse
    DBMS_OUTPUT.PUT_LINE('Datos insertados en DetallesPedidos.');
END;
/

-- Verificar datos
SELECT * FROM DetallesPedidos;

-- Práctica Sesión 2
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ejercicio Sesión 2');
END;
/
-- 2 sentencias SELECT simples
SELECT * FROM Clientes;
SELECT * FROM Pedidos;

-- 2 sentencias SELECT utilizando funciones agregadas sobre su base de datos
SELECT COUNT(*) FROM Productos;
SELECT AVG(Precio) FROM Productos;

-- 2 sentencias SELECT con expresiones regulares
SELECT * FROM Clientes WHERE Ciudad='Santiago';
SELECT * FROM Productos WHERE Precio>=1000;

-- 2 vistas
CREATE VIEW ClientesRegiones AS
SELECT * FROM Clientes WHERE Ciudad!='Santiago';
CREATE VIEW Pedidos3oMas AS
SELECT * FROM DetallesPedidos WHERE Cantidad>=3;


-- Práctica Sesión 3
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ejercicio Sesión 3');
END;
/

DECLARE
    v_producto_id NUMBER := 1;
    v_precio NUMBER;
BEGIN
    SELECT Precio
    INTO v_precio
    FROM Productos
    WHERE ProductoID = v_producto_id;

    -- Si no hay productos, se asigna 0
    IF v_precio IS NULL THEN
        v_precio := 0;
    END IF;

    /*
    Criterios de clasificación:
    - Muy caro: precio > 1000
    - Balanceado: 500 <= precio <= 1000
    - Muy barato: precio < 500
    */

    IF v_precio > 1000 THEN
        DBMS_OUTPUT.PUT_LINE('Producto muy caro. Valor: $' || v_precio);
    ELSIF v_precio >= 500 THEN
        DBMS_OUTPUT.PUT_LINE('Producto de precio balanceado. Valor: $' || v_precio);
    ELSE
        DBMS_OUTPUT.PUT_LINE('Producto muy barato. Valor: $' || v_precio);
    END IF;
END;
/

-- Práctica Sesión 4.1
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ejercicio 1 Sesión 4');
END;
/
DECLARE
	v_total NUMBER;
	total_invalido EXCEPTION;
BEGIN
	SELECT Total INTO v_total
	FROM Pedidos
	WHERE PedidoID = 1;

	IF v_total < 0 THEN
	RAISE total_invalido;
	END IF;

	DBMS_OUTPUT.PUT_LINE('Total del pedido: ' || v_total);
EXCEPTION
	WHEN total_invalido THEN
	DBMS_OUTPUT.PUT_LINE('Error: El total no puede ser negativo.');
	WHEN NO_DATA_FOUND THEN
	DBMS_OUTPUT.PUT_LINE('Error: Pedido no encontrado.');
END;
/

-- Práctica sesión 4.2
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ejercicio 2 Sesión 4');
END;
/

DECLARE
    e_duplicado EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_duplicado, -8001); -- Código TT8001
BEGIN
    INSERT INTO Clientes (ClienteID, Nombre, Ciudad)
    VALUES (1, 'Jose Luis Caceres', 'Coquimbo'); -- ID duplicado
    DBMS_OUTPUT.PUT_LINE('Inserción exitosa!');
EXCEPTION
    WHEN e_duplicado THEN
        DBMS_OUTPUT.PUT_LINE('Error TimesTen TT8001: ID Duplicada!');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;
/

-- Práctica sesión 5.1
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ejercicio 1 Sesión 5');
END;
/
DECLARE
	CURSOR producto_cursor IS
	SELECT Nombre, Precio
	FROM Productos
	ORDER BY Precio;
	v_nombre VARCHAR2(50);
	v_precio NUMBER;
BEGIN
	OPEN producto_cursor;
	LOOP
	FETCH producto_cursor INTO v_nombre, v_precio;
	EXIT WHEN producto_cursor%NOTFOUND;
	DBMS_OUTPUT.PUT_LINE('Nombre producto: ' || v_nombre || ', Precio: $' || v_precio);
	END LOOP;
	CLOSE producto_cursor;
END;
/

-- Práctica sesión 5.2
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ejercicio 2 Sesión 5');
END;
/
DECLARE
	CURSOR producto_cursor(producto_id NUMBER) IS
        SELECT Nombre, Precio
        FROM Productos
        WHERE ProductoID = producto_id
        FOR UPDATE;
	v_nombre VARCHAR2(50);
	v_precio NUMBER;
BEGIN
	OPEN producto_cursor(1);
	LOOP
        FETCH producto_cursor INTO v_nombre, v_precio;
        EXIT WHEN producto_cursor%NOTFOUND;

        UPDATE Productos
        SET Precio = v_precio * 1.1
        WHERE CURRENT OF producto_cursor;

        DBMS_OUTPUT.PUT_LINE('Nombre producto: ' || v_nombre || ', Precio original: $' || v_precio || ', Nuevo precio: $' || (v_precio * 1.1));
	END LOOP;
	CLOSE producto_cursor;
EXCEPTION
	WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF producto_cursor%ISOPEN THEN
            CLOSE producto_cursor;
        END IF;
END;
/

-- Ejercicio 1 Sesión 6
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ejercicio 1 Sesion 6');
END;
/
CREATE OR REPLACE TYPE producto_obj AS OBJECT ( -- Creación del objeto
    producto_id NUMBER,
    nombre VARCHAR2(50),
    precio NUMBER,
    MEMBER FUNCTION get_info RETURN VARCHAR2
);
/

CREATE OR REPLACE TYPE BODY producto_obj AS  -- Creación del Body
    MEMBER FUNCTION get_info RETURN VARCHAR2 IS
    BEGIN
        RETURN 'ID: ' || producto_id || ', Nombre: ' || nombre || ', Precio: $' || precio;
    END;
END;
/

CREATE TABLE productos_obj OF producto_obj ( -- Creación tabla del objeto
    producto_id PRIMARY KEY
);

-- Inserción de datos
INSERT INTO productos_obj VALUES (1, 'Laptop', 1200);
INSERT INTO productos_obj VALUES (2, 'Mouse', 25);

-- Get info
SELECT p.get_info() FROM productos_obj p;

-- Cursor
DECLARE
    CURSOR productos_cursor IS
        SELECT VALUE(p) FROM productos_obj p
        ORDER BY precio;
    v_producto_obj producto_obj;
BEGIN
    OPEN productos_cursor;
    LOOP
        FETCH productos_cursor INTO v_producto_obj;
        EXIT WHEN productos_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_producto_obj.get_info());
    END LOOP;
    CLOSE productos_cursor;
END;
/

-- Ejercicio 2 Sesion 6
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ejercicio 2 Sesion 6');
END;
/
DECLARE
    CURSOR producto_cursor_2(p_id NUMBER) IS
        SELECT VALUE(p) FROM productos_obj p
        WHERE p.producto_id = p_id
        FOR UPDATE;
    
    v_producto producto_obj;
    v_precio_original NUMBER;
    v_precio_actualizado NUMBER;

BEGIN
    OPEN producto_cursor_2(1);
    LOOP
        FETCH producto_cursor_2 INTO v_producto;
        EXIT WHEN producto_cursor_2%NOTFOUND;

        v_precio_original := v_producto.precio;
        v_precio_actualizado := v_producto.precio * 1.1;

        UPDATE productos_obj
        SET precio = v_precio_actualizado
        WHERE CURRENT OF producto_cursor_2;

        DBMS_OUTPUT.PUT_LINE('Nombre del producto: ' || v_producto.nombre);
        DBMS_OUTPUT.PUT_LINE('Antes: ' || v_precio_original);
        DBMS_OUTPUT.PUT_LINE('Ahora: ' || v_precio_actualizado);
    END LOOP;

    CLOSE producto_cursor_2;
END;
/
-- Commit final
COMMIT;
