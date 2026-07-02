-- Sesion B.
-- Deadlock
USE tpi;
SHOW TABLE STATUS WHERE Name = 'pedido';
SET autocommit=0;
START TRANSACTION;

-- Bloqueo de la fila 2
UPDATE pedido SET total = total + 1 WHERE pedido_id = 2;
   -- En Session B: intentar bloquear la fila 1 (ya bloqueada por A)
UPDATE pedido SET total = total + 2 WHERE pedido_id = 1;
-- Aquí aparece el error.
-- Ver el detalle de error
SHOW ENGINE INNOBD STATUS;

-- Read commited
SET autocommit = 0;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
SELECT @@transaction_isolation;
-- Sesion B
SET autocommit=0;
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
-- Cambio
UPDATE pedido SET total = 600 WHERE pedido_id = 1;
COMMIT;

-- Repetable read
SET SESSION TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SET autocommit = 0;
START TRANSACTION;
-- Cambio
UPDATE pedido SET total = 850 WHERE pedido_id = 1;
COMMIT;
