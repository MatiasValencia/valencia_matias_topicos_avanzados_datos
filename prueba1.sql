-- PRUEBA 1 TÓPICOS AVANZADOS DE DATOS
-- NOMBRE: Matías Valencia Espinoza
-- FECHA: 22 de abril de 2026
-- DOCENTE: Félix Nilo Bustios

-- Pregunta 1:
-- Explica qué es una relación muchos a muchos y cómo se implementa en una base de datos
-- relacional. Usa un ejemplo en las tablas del esquema creado para la prueba.

-- R: Una relación muchos a muchos permite relacionar un dato de una tabla específica con
-- una serie dato de otra tabla, y viceversa. Estos datos enlazados son conocidos como llaves foráneas,
-- o "Foreign Keys". Un ejemplo, un pedido pueden tener muchos productos, y esos productos
-- pueden estar asociados a muchos pedidos.

-- Pregunta 2: Describe qué es una vista, y cómo la usarías para mostrar el total de
-- horas dedicadas por incidente, incluyendo la descripción del incidente y su severidad.
-- Escribe la consulta SQL para crear la vista (no es necesario ejecutarla).

-- R: Una vista es una tabla creada sólo para mostrar ciertos elementos de una o más
-- tablas, para agilizar más las consultas. Por ejemplo, para hacer la vista, sería más
-- o menos así:

-- CREATE OR REPLACE VIEW total_horas AS
-- (SELECT i.IncidenteID, SUM(as.horas), i.Descripcion, i.Severidad FROM Incidentes i
-- INNER JOIN Asignaciones as ON i.IncidenteID = as.IncidenteID
-- INNER JOIN Agentes ag ON ag.AgenteID = as.AsignacionID AND ag.AgenteID = i.IncidenteID
-- GROUP BY i.incidenteID
-- );

-- Pregunta 3: ¿Qué es una excepción predefinida en PL/SQL y cómo se maneja? Da un ejemplo
-- de cómo manejarías la excepción NO_DATA_FOUND en un bloque PL/SQL.

-- R: Una excepción es una manera de mostrar errores en pantalla si se produce uno
-- inesperado a la hora de ejecutar un procedimiento. Para manejar una excepción en un
-- bloque PL/SQL, sería así:

-- EXCEPTION
--     WHEN NO_DATA_FOUND THEN
--         DBMS_OUTPUT.PUT_LINE("No se han encontrado datos en la base");

-- Pregunta 4: Explica qué es un cursor explícito y cómo se usa en PL/SQL. Menciona al menos
-- dos atributos de cursos y su propósito.

-- R: Un cursor es un procedimiento que recoge una serie específica de datos, y los
-- ejecuta en un bucle. El atributo "%NOTFOUND" se usa cuando ese cursor no ha sido encontrado
-- y comúnmente se usa para decirle a la base que cierre el procedimiento si no lo encuentra.
-- Otro atributo es "%ISOPEN", que es cuando se detecta que el cursor sigue abierto; en una
-- excepción, se puede usar para cerrar ese cursor.

-- Ejercicio 1
DECLARE
    CURSOR agentes_cursor IS
        SELECT ag.Especialidad, AVG(asig.horas) FROM Agentes ag
        INNER JOIN Asignaciones asig ON ag.AgenteID = asig.AgenteID
        GROUP BY ag.Especialidad
        WHERE AVG(asig.horas) > 30;
    v_especialidad VARCHAR2(50);
    v_promedio_horas NUMBER;
BEGIN
    OPEN agentes_cursor;
    LOOP
        FETCH agentes_cursor ON v_especialidad, v_promedio_horas;
        EXIT WHEN agentes_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE('Especialidad: ' || v_especialidad || ' - Promedio de horas dedicadas a incidentes: ' || v_promedio_horas);
    END LOOP;
    CLOSE agentes_cursor;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos');
END;
/

-- Ejercicio 2
DECLARE
    CURSOR incidentes_cursor IS
        SELECT asig.Horas FROM Asignaciones asig
        INNER JOIN Incidentes i on asig.IncidenteID = i.IncidenteID
        WHERE i.Severidad = "Critical"
        FOR UPDATE ON asig.Horas;
    v_horas NUMBER;
    v_nuevas_horas NUMBER;
BEGIN
    OPEN incidentes_cursor;
    LOOP
        FETCH incidentes_cursor ON v_horas;
        EXIT WHEN agentes_cursor%NOTFOUND;
        -- Actualizamos horas
        UPDATE Asignaciones asig
        SET asig.Horas = v_horas + 10
        FOR CURRENT OF incidentes_cursor;
    END LOOP;
    CLOSE incidentes_cursor;
    COMMIT;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No se encontraron datos');
END;
/

-- Ejercicio 3
CREATE OR REPLACE TYPE incidente_obj AS OBJECT (
    incidente_id NUMBER;
    descripcion VARCHAR2(50);
    METHOD FUNCTION get_reporte BODY;
)

CREATE OR REPLACE TYPE BODY get_reporte AS (
    BEGIN
        RETURN "ID del Incidente: " || incidente_id || " - Descripción: " || descripcion;
    END;
    /
)

CREATE TABLE incidentes_obj AS (
    incidente_obj;
)

INSERT INTO incidentes_obj VALUES (201, "Ransomware Lockbit en servidor de archivos");
INSERT INTO incidentes_obj VALUES (202, "Campaña de Phishing dirigida a RRHH");
INSERT INTO incidentes_obj VALUES (203, "DDoS en portal web institucional");
INSERT INTO incidentes_obj VALUES (204, "SQL Injection en API de pagos");

DECLARE
    CURSOR incidentes_obj_cursor IS
        SELECT incidente_id, descripcion FROM incidentes_obj;
    v_incidentes incidente_obj
BEGIN
    OPEN incidentes_objcursor;
    LOOP
        FETCH incidentes_objcursor ON v_incidentes;
        EXIT WHEN incidentes_obj_cursor%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_incidentes.get_reporte())
    END LOOP;
    CLOSE incidentes_objcursor;
END;
/