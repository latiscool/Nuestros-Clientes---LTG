
-- -- --- - 0.- CREAR BASE DE DATOS jobs
-- -- --- - ***********************************
    CREATE DATABASE jobs

-- -- -- -- 1.- Cargar el respaldo de la base de datos unidad2.sql
-- -- -- -- En el Terminal (CMD) se escribe la sgte sentencia
-- -- -- --  ***********************************************
 psql -U postgres jobs < unidad2.sql

-- -- -- 2. El cliente usuario01 ha realizado la siguiente compra:
-- --  -- -- ******************************************************
-- -- -- ● producto: producto9
-- -- -- ● cantidad: 5
-- -- -- ● fecha: fecha del sistema
-- -- -- Mediante el uso de transacciones, realiza las consultas correspondientes para este
-- -- -- requerimiento y luego consulta la tabla producto para validar si fue efectivamente descontado en el stock

-- -- -- ***** recordar tener desactivado el autocommit en tu base de datos
\set AUTOCOMMIT off
\echo :AUTOCOMMIT
off    

BEGIN TRANSACTION;
INSERT INTO compra (id,cliente_id,fecha)
VALUES (33,1,'07-03-2022');
INSERT INTO detalle_compra (id,producto_id,compra_id,cantidad)
VALUES (43,9,33,5);
UPDATE producto
SET stock = stock - 5
WHERE id=9;

SELECT*FROM producto
WHERE id=9;

COMMIT;


-- -- ************************************************
-- 3. El cliente usuario02 ha realizado la siguiente compra:
-- -- ************************************************

---- ● producto: producto1, producto 2, producto 8
---- ● cantidad: 3 de cada producto
---- ● fecha: fecha del sistema
---- Mediante el uso de transacciones, realiza las consultas correspondientes para este
---- requerimiento y luego consulta la tabla producto para validar que si alguno de ellos
---- se queda sin stock, no se realice la compra

BEGIN TRANSACTION;

INSERT INTO compra (id,cliente_id,fecha)
VALUES(34,2,'07-03-2022');
INSERT INTO detalle_compra(id,producto_id,compra_id,cantidad)
VALUES(44,1,34,3);

UPDATE producto
SET stock = stock - 3 WHERE id=1;
SAVEPOINT a;

SELECT*FROM producto
WHERE id=1;

INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad)
VALUES (45,2,34,3);

UPDATE producto
SET stock = stock -3 WHERE id=2;
SAVEPOINT b;

SELECT*FROM producto
WHERE id=2;

INSERT INTO detalle_compra(id, producto_id, compra_id, cantidad)
VALUES (46,8,34,3);

UPDATE producto
SET stock = stock -3 WHERE id=8;

SELECT*FROM producto
WHERE id=8;

ROLLBACK TO SAVEPOINT b;


-- -- --- - ***********************************
-- -- 4. Realizar las siguientes consultas:
-- -- --- - ***********************************
-- -- a. Deshabilitar el AUTOCOMMIT
-- -- b. Insertar un nuevo cliente
-- -- c. Confirmar que fue agregado en la tabla cliente
-- -- d. Realizar un ROLLBACK
-- -- e. Confirmar que se restauró la información, sin considerar la inserción del punto b
-- -- f. Habilitar de nuevo el AUTOCOMMIT



-- -- -- a.-

\set AUTOCOMMIT off
\echo :AUTOCOMMIT
off    


-- -- -- -- b.-
BEGIN TRANSACTION;
SAVEPOINT new_client;
---- b. Insertar un nuevo cliente
INSERT INTO cliente (id,nombre,email)
VALUES (11,'usuario011','usuario011@hotmail.com');
-- ----  Confirmar que fue agregado en la tabla cliente
SELECT*FROM cliente
ORDER BY id ASC;

-- ----  d. Realizar un ROLLBACK
ROLLBACK to new_client;

-- ---- e. Confirmar que se restauró la información, sin considerar la inserción del punto b

SELECT*FROM cliente
ORDER BY id ASC;

COMMIT;

-- ---- f. Habilitar de nuevo el AUTOCOMMIT

\set AUTOCOMMIT on 
 \echo :AUTOCOMMIT
on




