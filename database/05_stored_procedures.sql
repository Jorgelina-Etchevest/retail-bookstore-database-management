USE tpi;

-- Procedimiento seguro (sin SQL dinámico)
DELIMITER //
CREATE PROCEDURE sp_get_pedidos_por_cliente(IN p_cliente_id INT)
BEGIN
    SELECT pedido_id, numero, fecha, total, estado
    FROM pedido
    WHERE cliente_id = p_cliente_id
    ORDER BY fecha DESC;
END //
DELIMITER ;

-- Prueba normal
CALL sp_get_pedidos_por_cliente(1);

-- Intento de inyección (no funciona, se trata como texto)
CALL sp_get_pedidos_por_cliente('1 OR 1=1');

-- Mostrar permisos de cada usuario
SHOW GRANTS FOR 'tpi_read'@'localhost';
SHOW GRANTS FOR 'tpi_app'@'localhost';
