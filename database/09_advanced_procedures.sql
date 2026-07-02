DELIMITER //
CREATE PROCEDURE sp_deadlock_retry_pedido(
    IN p_id_1 INT,
    IN p_id_2 INT,
    IN p_monto_a_sumar DECIMAL(10,2),
    OUT p_resultado VARCHAR(150)
)
BEGIN
    -- [1. DECLARACIÓN DE VARIABLES]
    DECLARE v_intentos INT DEFAULT 0;
    DECLARE v_max_intentos INT DEFAULT 3;
    DECLARE v_exito BOOLEAN DEFAULT FALSE;
    DECLARE v_deadlock_error BOOLEAN DEFAULT FALSE;
    -- [2. DECLARACIÓN DE HANDLERS]
    -- HANDLER para DEADLOCK (Mantiene el control para reintentar)
    DECLARE CONTINUE HANDLER FOR 1213, SQLSTATE '40001'
    BEGIN
        SET v_deadlock_error = TRUE;
        SET p_resultado = CONCAT('LOG: Deadlock detectado en intento #', v_intentos);
        ROLLBACK;
    END;
    -- HANDLER para ERRORES FATALES (Elimina el problemático 'LEAVE')
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Simplemente establece el estado de fallo final y hace ROLLBACK
        SET v_exito = FALSE; 
        SET p_resultado = CONCAT('FALLO FATAL: Error inesperado en intento #', v_intentos);
        ROLLBACK;
        -- ELIMINAMOS el LEAVE para evitar el Error 1300
    END;
    -- [3. LÓGICA EJECUTABLE]
    SET p_resultado = 'FALLO: Maximo de reintentos agotado.'; 
    -- Bucle de reintento. Ya no necesita etiqueta
    WHILE v_intentos < v_max_intentos AND v_exito = FALSE DO
        SET v_intentos = v_intentos + 1;
        SET v_deadlock_error = FALSE; 
        SELECT CONCAT('INICIO: Transacción en curso. Intento #', v_intentos) AS Log_Message;
        START TRANSACTION;
        -- --- OPERACIONES CRÍTICAS ---
        UPDATE pedido SET total = total + p_monto_a_sumar WHERE pedido_id = p_id_1;
        UPDATE pedido SET total = total + p_monto_a_sumar WHERE pedido_id = p_id_2;
        -- --- FIN OPERACIONES CRÍTICAS ---
        IF v_deadlock_error = FALSE AND v_exito = FALSE THEN 
            -- No hubo deadlock ni otro error: COMMIT y éxito.
            COMMIT;
            SET v_exito = TRUE;
            SET p_resultado = CONCAT('EXITO: Transacción confirmada en intento #', v_intentos);
        ELSEIF v_deadlock_error = TRUE THEN
            -- Hubo Deadlock: Pasamos a la lógica de reintento
            IF v_intentos < v_max_intentos THEN
                -- Aplicar backoff breve
                DO SLEEP(0.5); 
                SELECT 'LOG: Aplicando backoff de 0.5s antes de reintentar...' AS Log_Message;
            ELSE
                 -- Se agotaron los intentos
                 SET p_resultado = CONCAT('FALLO DEFINITIVO: Máximo de reintentos (', v_max_intentos - 1, ') agotado por Deadlock.');
            END IF;
        -- Si v_exito = FALSE por el HANDLER fatal, el WHILE simplemente no se repetirá.
        END IF;
    END WHILE; 
    -- La etiqueta ya no es necesaria ni en el WHILE ni en el END WHILE.
END //
DELIMITER ;

-- Ejecucion
-- 1. Declarar la variable de salida
SET @resultado_sp = NULL;

-- 2. Totales ANTES de ejecutar el SP 
SELECT pedido_id, total FROM pedido WHERE pedido_id IN (1, 2);

-- 3. Llamar al procedimiento con IDs y el monto a sumar 
CALL sp_deadlock_retry_pedido(1, 2, 10.00, @resultado_sp); 

-- 4. Resultado final del SP
SELECT @resultado_sp AS Resultado_Final_SP;

-- 5.totales DESPUÉS de ejecutar el SP (deben haber aumentado en 10.00)
SELECT pedido_id, total FROM pedido WHERE pedido_id IN (1, 2);