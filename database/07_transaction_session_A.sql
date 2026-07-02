-- Sesion A.
-- Deadlock
USE tpi;
SHOW TABLE STATUS WHERE Name = 'pedido';
SET autocommit=0;
START TRANSACTION;

-- Bloqueo de la fila 1
UPDATE pedido SET total = total + 1 WHERE pedido_id = 1;
/* Mantener esta transacción abierta (NO hacer COMMIT ni ROLLBACK aún).
   Ahora pasa a la Session B y ejecuta los pasos indicados allí. */
   -- En Session A: intentar bloquear la fila 2 (ya bloqueada por B)
UPDATE pedido SET total = total + 2 WHERE pedido_id = 2;
-- Aquí la sentencia quedará bloqueada esperando el lock de Session B.

-- Read commited
SET autocommit = 0;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT @@transaction_isolation;
-- Sesion A
SET autocommit=0;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
-- Primera lectura (antes del cambio)
SELECT total FROM pedido WHERE pedido_id = 1;
-- Segunda lectura (después del commit de B)
SELECT total FROM pedido WHERE pedido_id = 1;

-- Repeteable Read
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SET autocommit = 0;
START TRANSACTION;
-- Sesion A
-- Lectura antes de la transaccion B
SELECT total FROM pedido WHERE pedido_id = 1; 
-- Lectura luego de la transaccion B
SELECT total FROM pedido WHERE pedido_id = 1; 

