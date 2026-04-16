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
    INSERT INTO Clientes VALUES (4, 'Carlos Gonzalez', 'Santiago', TO_DATE('1978-04-23', 'YYYY-MM-DD'));
    INSERT INTO Clientes VALUES (5, 'Jose Maria Carrasco', 'Antofagasta', TO_DATE('1992-01-11', 'YYYY-MM-DD'));
    INSERT INTO Clientes VALUES (6, 'Guillermo Ferraz', 'La Serena', TO_DATE('1989-11-06', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Datos insertados en Clientes.');
END;
/

-- Insertar datos en Pedidos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertando datos en Pedidos...');
    INSERT INTO Pedidos VALUES (101, 1, 2800, TO_DATE('2025-03-01', 'YYYY-MM-DD'));
    INSERT INTO Pedidos VALUES (102, 1, 250, TO_DATE('2025-03-02', 'YYYY-MM-DD'));
    INSERT INTO Pedidos VALUES (103, 2, 150, TO_DATE('2025-03-03', 'YYYY-MM-DD'));
    INSERT INTO Pedidos VALUES (104, 5, 160, TO_DATE('2023-01-08', 'YYYY-MM-DD'));
    INSERT INTO Pedidos VALUES (105, 1, 75, TO_DATE('2025-07-28', 'YYYY-MM-DD'));
    INSERT INTO Pedidos VALUES (106, 3, 230, TO_DATE('2023-12-18', 'YYYY-MM-DD'));
    INSERT INTO Pedidos VALUES (107, 4, 1280, TO_DATE('2024-09-15', 'YYYY-MM-DD'));
    DBMS_OUTPUT.PUT_LINE('Datos insertados en Pedidos.');
END;
/

-- Insertar datos en Productos
BEGIN
    DBMS_OUTPUT.PUT_LINE('Insertando datos en Productos...');
    INSERT INTO Productos VALUES (1, 'Laptop', 1200);
    INSERT INTO Productos VALUES (2, 'Mouse', 80);
    INSERT INTO Productos VALUES (3, 'Audifonos Inalambricos', 250);
    INSERT INTO Productos VALUES (4, 'Teclado', 75);
    INSERT INTO Productos VALUES (5, 'Pendrive USB 64 GB', 50);
    INSERT INTO Productos VALUES (6, 'Disco Duro Externo 2 TB', 80);
    INSERT INTO Productos VALUES (7, 'PC Gamer Escritorio', 2300);
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
    INSERT INTO DetallesPedidos VALUES (3, 102, 4, 1); -- Pedido 102: 1 Audífono Inalámbrico
    INSERT INTO DetallesPedidos VALUES (4, 103, 5, 3); -- Pedido 103: 3 Pendrives USB
    INSERT INTO DetallesPedidos VALUES (5, 104, 6, 2); -- Pedido 104: 2 Discos Duros Externos
    INSERT INTO DetallesPedidos VALUES (6, 105, 4, 1); -- Pedido 105: 1 Teclado
    INSERT INTO DetallesPedidos VALUES (7, 106, 2, 1); -- Pedido 106: 1 Mouse
    INSERT INTO DetallesPedidos VALUES (8, 106, 4, 2); -- Pedido 106: 2 Teclados
    INSERT INTO DetallesPedidos VALUES (9, 107, 1, 1); -- Pedido 107: 1 Laptop
    INSERT INTO DetallesPedidos VALUES (10, 107, 6, 1); -- Pedido 107: 1 Disco Duro Externo
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
INSERT INTO productos_obj VALUES (2, 'Mouse', 80);
INSERT INTO productos_obj VALUES (3, 'Audifonos Inalambricos', 250);
INSERT INTO productos_obj VALUES (4, 'Teclado', 75);
INSERT INTO productos_obj VALUES (5, 'Pendrive USB 64 GB', 50);
INSERT INTO productos_obj VALUES (6, 'Disco Duro Externo 2 TB', 80);
INSERT INTO productos_obj VALUES (7, 'PC Gamer Escritorio', 2300);

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

-- Ejercicio 1 Sesion 7
BEGIN
    DBMS_OUTPUT.PUT_LINE('Ejercicio 1 Sesion 7');
END;
/
CREATE OR REPLACE PROCEDURE aumentar_precio_producto(p_producto_id IN NUMBER, p_porcentaje IN NUMBER) AS
BEGIN
    UPDATE Productos
    SET Precio = Precio + ((Precio * p_porcentaje) / 100)
    WHERE ProductoID = p_producto_id;
    IF SQL%ROWCOUNT = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Producto con ID ' || p_producto_id || ' no encontrado.');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Precio del producto ' || p_producto_id || ' aumentado en un ' || p_porcentaje || '%.');
    COMMIT;
EXCEPTION
    WHEN VALUE_ERROR THEN
        DBMS_OUTPUT.PUT_LINE('Error: El precio debe ser un valor válido.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error inesperado: ' || SQLERRM);
END;
/

-- Ejecución de procedimiento
EXEC aumentar_precio_producto(1, 20);

-- Ejercicio 1 - Preparación para la Prueba
DECLARE
	CURSOR pedido_cursor IS
		SELECT p.PedidoID, p.Total, c.Nombre FROM Pedidos p
		INNER JOIN Clientes c ON p.ClienteID = c.ClienteID
		WHERE p.Total >= 500;
	-- Variables
	v_pedido_id NUMBER;
	v_total NUMBER;
	v_nombre_cliente VARCHAR2(50);
BEGIN
	OPEN pedido_cursor;
	LOOP
		FETCH pedido_cursor INTO v_pedido_id, v_total, v_nombre_cliente;
		EXIT WHEN pedido_cursor%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Numero de pedido: ' || v_pedido_id || ' - Total: $' || v_total || ' - Cliente: ' || v_nombre_cliente);
	END LOOP;
	CLOSE pedido_cursor;
END;
/

-- Ejercicio 2 - Preparación para la prueba
DECLARE
	CURSOR producto_cursor IS
		SELECT p.Nombre, p.Precio FROM Productos p
		WHERE p.Precio < 1000;
	-- Variables
	v_nombre_producto VARCHAR2(50);
	v_precio NUMBER;
BEGIN
	OPEN producto_cursor;
	LOOP
		FETCH producto_cursor INTO v_nombre_producto, v_precio;
		EXIT WHEN producto_cursor%NOTFOUND;
		UPDATE Productos
		SET Precio = v_precio * 1.15
		WHERE CURRENT OF producto_cursor;
		DBMS_OUTPUT.PUT_LINE('Nombre del producto: ' || v_nombre_producto || ' - Nuevo precio: $' || (v_precio * 1.15));
	END LOOP;
EXCEPTION
	WHEN OTHERS THEN
        	DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF producto_cursor%ISOPEN THEN
        	CLOSE producto_cursor;
        END IF;
END;
/

-- Ejercicio 3 - Preparación para la prueba
DECLARE
	CURSOR clientes_cursor IS
		SELECT c.Nombre, SUM(p.Total) FROM Clientes c
		INNER JOIN Pedidos p ON c.ClienteID = p.ClienteID
		WHERE SUM(p.Total) > 1000
		GROUP BY c.Nombre;
	-- Variables
	v_nombre_cliente VARCHAR2(50);
	v_suma_total NUMBER;
BEGIN
	OPEN clientes_cursor;
	LOOP
		FETCH clientes_cursor INTO v_nombre_cliente, v_suma_total;
		EXIT WHEN clientes_cursor%NOTFOUND;
		DBMS_OUTPUT.PUT_LINE('Nombre del cliente: ' || v_nombre_cliente || ' - Total acumulado en pedidos: $' || v_suma_total);
	END LOOP;
EXCEPTION
	WHEN OTHERS THEN
        	DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        IF clientes_cursor%ISOPEN THEN
        	CLOSE clientes_cursor;
        END IF;
END;
/
-- Commit final
COMMIT;
