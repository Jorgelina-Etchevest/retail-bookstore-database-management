INSERT INTO vendedor (vendedor_nombre, vendedor_apellido, email) VALUES
('Juan', 'Perez', 'juan.perez@email.com'),
('Maria', 'Gomez', 'maria.gomez@email.com'),
('Carlos', 'Lopez', 'carlos.lopez@email.com'),
('Ana', 'Diaz', 'ana.diaz@email.com'),
('Pedro', 'Ruiz', 'pedro.ruiz@email.com'),
('Laura', 'Fernandez', 'laura.fernandez@email.com'),
('Martin', 'Gonzalez', 'martin.gonzalez@email.com'),
('Sofia', 'Rodriguez', 'sofia.rodriguez@email.com'),
('Diego', 'Martinez', 'diego.martinez@email.com'),
('Valeria', 'Garcia', 'valeria.garcia@email.com');

INSERT INTO cliente (cliente_nombre, cliente_apellido, DNI, email, direccion) VALUES
('Ana', 'Diaz', '11111111', 'ana.diaz@cliente.com', 'Avenida Principal 123'),
('Pedro', 'Ruiz', '22222222', 'pedro.ruiz@cliente.com', 'Calle Secundaria 456'),
('Luis', 'Sanchez', '33333333', 'luis.sanchez@cliente.com', 'Boulevard del Sol 789'),
('Elena', 'Torres', '44444444', 'elena.torres@cliente.com', 'Calle de las Rosas 101'),
('Jorge', 'Morales', '55555555', 'jorge.morales@cliente.com', 'Plaza Central 202'),
('Sofia', 'Castro', '66666666', 'sofia.castro@cliente.com', 'Calle de la Luna 303'),
('Javier', 'Ramirez', '77777777', 'javier.ramirez@cliente.com', 'Avenida de los Lagos 404'),
('Carolina', 'Vargas', '88888888', 'carolina.vargas@cliente.com', 'Paseo de las Flores 505'),
('Gabriel', 'Mendoza', '99999999', 'gabriel.mendoza@cliente.com', 'Calle del Prado 606'),
('Marina', 'Navarro', '12345678', 'marina.navarro@cliente.com', 'Callejon del Gato 707'),
('Pablo', 'Herrera', '87654321', 'pablo.herrera@cliente.com', 'Avenida Siempre Viva 808'),
('Lucia', 'Silva', '10101010', 'lucia.silva@cliente.com', 'Calle del Bosque 909'),
('Emiliano', 'Ortiz', '20202020', 'emiliano.ortiz@cliente.com', 'Rio de la Plata 111'),
('Agustina', 'Peralta', '30303030', 'agustina.peralta@cliente.com', 'Gran Avenida 222'),
('Matias', 'Gimenez', '40404040', 'matias.gimenez@cliente.com', 'Avenida del Libertador 333');

INSERT INTO producto (SKU, nombre, descripcion, precio, stock) VALUES
('SKU001', 'Smartphone X', 'Último modelo de teléfono inteligente', 500.00, 150),
('SKU002', 'Laptop Gaming', 'Laptop para videojuegos de alto rendimiento', 1200.00, 75),
('SKU003', 'Auriculares Inalambricos', 'Auriculares con cancelación de ruido', 80.00, 300),
('SKU004', 'Monitor 4K', 'Monitor de 27 pulgadas con resolución 4K', 350.50, 50),
('SKU005', 'Teclado Mecanico', 'Teclado para gaming con retroiluminación RGB', 95.00, 200),
('SKU006', 'Mouse Inalambrico', 'Mouse ergonómico y recargable', 45.00, 450),
('SKU007', 'Parlante Bluetooth', 'Parlante portátil con gran calidad de sonido', 60.00, 180),
('SKU008', 'Cámara Web Full HD', 'Cámara de alta definición para videollamadas', 75.00, 90),
('SKU009', 'Disco Duro Externo 1TB', 'Almacenamiento portátil de alta capacidad', 55.00, 250),
('SKU010', 'Router WiFi 6', 'Router de última generación para conexiones rápidas', 110.00, 100),
('SKU011', 'Tablet 10 pulgadas', 'Tablet con pantalla de 10 pulgadas y 64GB', 250.00, 60),
('SKU012', 'Smartwatch Deportivo', 'Reloj inteligente con monitor de actividad física', 150.00, 120),
('SKU013', 'Drone con Cámara 4K', 'Drone plegable con cámara de alta resolución', 450.00, 30),
('SKU014', 'Impresora Multifuncion', 'Impresora con funciones de escáner y copia', 130.00, 85),
('SKU015', 'Consola de Videojuegos', 'Consola de última generación para juegos', 499.00, 40),
('SKU016', 'Laptop Ultrabook', 'Laptop delgada y ligera para portabilidad', 850.00, 55),
('SKU017', 'Tarjeta Gráfica RTX', 'Tarjeta gráfica de alto rendimiento para PC', 650.00, 25),
('SKU018', 'Auriculares con Cable', 'Auriculares básicos para uso diario', 25.00, 500),
('SKU019', 'Lector de Libros Electronico', 'Dispositivo con tinta electrónica para lectura', 120.00, 70),
('SKU020', 'Proyector Portatil', 'Proyector compacto para cine en casa', 200.00, 95);

INSERT INTO PEDIDO (eliminado, fecha, cliente_id, vendedor_id, total, estado)
SELECT
    FALSE,
    CURDATE() - INTERVAL FLOOR(RAND() * 365) DAY,
    (SELECT cliente_id FROM CLIENTE ORDER BY RAND() LIMIT 1),
    (SELECT vendedor_id FROM VENDEDOR ORDER BY RAND() LIMIT 1),
    FLOOR(RAND() * 5000) + 100,
    CASE FLOOR(RAND() * 3)
        WHEN 0 THEN 'NUEVO'
        WHEN 1 THEN 'FACTURADO'
        WHEN 2 THEN 'ENVIADO'
    END
FROM
    (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) t1,
    (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) t2,
    (SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9 UNION ALL SELECT 10) t3
LIMIT 502000;

UPDATE PEDIDO
SET numero = CONCAT('PED-', LPAD(pedido_id, 6, '0'))
WHERE numero IS NULL;

INSERT INTO DETALLE (pedido_id, producto_id, cantidad, precio_unitario, subtotal)
SELECT
    p.pedido_id,
    -- Selecciona UN producto_id al azar para esta línea de detalle
    (SELECT prod_sub.producto_id FROM PRODUCTO prod_sub ORDER BY RAND() LIMIT 1) AS producto_id,
    FLOOR(1 + (RAND() * 10)) AS cantidad,
    -- Utiliza el precio del producto seleccionado al azar en esta subconsulta
    (SELECT prod_sub.precio FROM PRODUCTO prod_sub ORDER BY RAND() LIMIT 1) AS precio_unitario, 
    (FLOOR(1 + (RAND() * 10)) * (SELECT prod_sub.precio FROM PRODUCTO prod_sub ORDER BY RAND() LIMIT 1)) AS subtotal
FROM
    PEDIDO p
WHERE
    -- Selecciona solo pedidos que aún NO tienen un registro en DETALLE
    p.pedido_id NOT IN (SELECT pedido_id FROM DETALLE)
ORDER BY
    p.pedido_id
LIMIT 502000;

INSERT INTO ENVIO (pedido_id, eliminado, tracking, empresa, tipo_envio, costo, fecha_despacho, fecha_estimada, estado)
SELECT
    p.pedido_id,
    FALSE,
    CONCAT('TRK-', LPAD(p.pedido_id, 10, '0')),
    CASE FLOOR(RAND() * 3)
        WHEN 0 THEN 'ANDREANI'
        WHEN 1 THEN 'OCA'
        WHEN 2 THEN 'CORREO_ARG'
    END,
    CASE FLOOR(RAND() * 2)
        WHEN 0 THEN 'ESTANDAR'
        WHEN 1 THEN 'EXPRES'
    END,
    FLOOR(RAND() * 100) + 10,
    p.fecha AS fecha_despacho,
    p.fecha + INTERVAL FLOOR(RAND() * 10) DAY AS fecha_estimada,
    
    CASE p.estado
        WHEN 'NUEVO' THEN 'EN_PREPARACION'
        WHEN 'FACTURADO' THEN 'EN_PREPARACION'
        WHEN 'ENVIADO' THEN
            CASE FLOOR(RAND() * 2)
                WHEN 0 THEN 'EN_TRANSITO'
                WHEN 1 THEN 'ENTREGADO'
            END
    END AS estado
FROM
    PEDIDO p
WHERE
    -- Filtra los pedidos que necesitan un envío
    p.estado IN ('NUEVO', 'FACTURADO', 'ENVIADO')
    -- Mantiene la relación 1:1 (solo inserta si no existe)
    AND p.pedido_id NOT IN (SELECT pedido_id FROM ENVIO)
ORDER BY
    p.pedido_id
LIMIT 502000;

SELECT COUNT(*) FROM pedido;
SELECT COUNT(*) FROM detalle;
SELECT COUNT(*) FROM envio;

SELECT SQL_NO_CACHE COUNT(*) FROM pedido WHERE numero = 'PED-500356';
CREATE INDEX idx_numero ON pedido(numero);
SELECT SQL_NO_CACHE COUNT(*) FROM pedido WHERE numero = 'PED-500356';

SELECT COUNT(*) FROM detalle WHERE pedido_id NOT IN (SELECT pedido_id FROM pedido);
SELECT COUNT(*) FROM envio WHERE pedido_id NOT IN (SELECT pedido_id FROM pedido);

SELECT COUNT(*) FROM (
SELECT numero, COUNT () FROM pedido GROUP BY numero HAVING COUNT () > 1
) As duplicados_numero;