use tpi;

-- 1
SELECT estado, COUNT(*) AS cantidad_pedidos
FROM pedido
GROUP BY estado;
-- 2
SELECT tipo_envio, COUNT(*) AS cantidad_envios
FROM envio
GROUP BY tipo_envio;

SELECT empresa, estado, COUNT(*) AS cantidad_envios
FROM envio
GROUP BY empresa, estado;


-- 3
SELECT pedido.pedido_id, cliente.cliente_nombre,
       cliente.cliente_apellido, producto.nombre,
       detalle.cantidad, detalle.precio_unitario,
       detalle.subtotal
FROM pedido
INNER JOIN cliente ON pedido.cliente_id = cliente.cliente_id
INNER JOIN detalle ON pedido.pedido_id = detalle.pedido_id
INNER JOIN producto ON detalle.producto_id = producto.producto_id
ORDER BY pedido.pedido_id, producto.nombre;

-- 4
SELECT cliente.cliente_id,
       cliente.cliente_nombre,
       cliente.cliente_apellido,
       AVG(envio.costo) AS promedio_costo_cliente
FROM cliente
INNER JOIN pedido ON cliente.cliente_id = pedido.cliente_id
INNER JOIN envio ON pedido.pedido_id = envio.pedido_id
GROUP BY cliente.cliente_id, cliente.cliente_nombre, cliente.cliente_apellido
HAVING AVG(envio.costo) > (SELECT AVG(costo) FROM envio)
ORDER BY promedio_costo_cliente DESC;
-- 5
CREATE INDEX idx_pedido_vendedor_id ON pedido(vendedor_id);

-- Consulta con índice
EXPLAIN SELECT v.vendedor_nombre, v.vendedor_apellido, COUNT(*) AS total_pedidos
FROM pedido p
INNER JOIN vendedor v ON p.vendedor_id = v.vendedor_id
GROUP BY v.vendedor_id, v.vendedor_nombre, v.vendedor_apellido
HAVING COUNT(*) > 10
ORDER BY total_pedidos DESC;

-- consulta sin índice

EXPLAIN SELECT v.vendedor_nombre, v.vendedor_apellido, COUNT(*) AS total_pedidos
FROM pedido p IGNORE INDEX ( idx_pedido_vendedor_id)
INNER JOIN vendedor v ON p.vendedor_id = v.vendedor_id
GROUP BY v.vendedor_id, v.vendedor_nombre, v.vendedor_apellido
HAVING COUNT(*) > 10
ORDER BY total_pedidos DESC;


-- 6
CREATE INDEX idx_detalle_producto_cantidad ON detalle(producto_id, cantidad);

-- Consulta con índice

EXPLAIN SELECT pedido.pedido_id, pedido.fecha, producto.nombre, detalle.cantidad
FROM pedido 
INNER JOIN detalle ON pedido.pedido_id = detalle.pedido_id
INNER JOIN producto ON detalle.producto_id = producto.producto_id
WHERE producto.producto_id IN (
    SELECT producto_id
    FROM detalle
    GROUP BY producto_id
    HAVING SUM(cantidad) > 5
)
ORDER BY producto.nombre;

-- consulta sin índice

EXPLAIN SELECT pedido.pedido_id, pedido.fecha, producto.nombre, detalle.cantidad
FROM pedido
INNER JOIN detalle IGNORE INDEX (idx_detalle_producto_cantidad)  ON pedido.pedido_id = detalle.pedido_id
INNER JOIN producto ON detalle.producto_id = producto.producto_id
WHERE producto.producto_id IN (
    SELECT producto_id
    FROM detalle
    GROUP BY producto_id
    HAVING SUM(cantidad) > 5
)
ORDER BY producto.nombre;


-- 7
CREATE INDEX idx_envio_tipo_fecha ON envio(tipo_envio, fecha_estimada);
-- Consulta con índice
EXPLAIN SELECT envio_id, pedido_id, empresa, tipo_envio, fecha_estimada
FROM envio
WHERE tipo_envio = 'EXPRES'
ORDER BY fecha_estimada;

-- Consulta sin índice
EXPLAIN SELECT envio_id, pedido_id, empresa, tipo_envio, fecha_estimada
FROM envio IGNORE INDEX ( idx_envio_tipo_fecha)
WHERE tipo_envio = 'EXPRES'
ORDER BY fecha_estimada;

-- 8
-- Creamos índice sobre fecha en pedido
CREATE INDEX idx_pedido_fecha ON pedido(fecha);

-- Consulta con índice
EXPLAIN SELECT pedido_id, cliente_id, fecha, total
FROM pedido
WHERE fecha BETWEEN '2025-01-01' AND '2025-06-30'
ORDER BY fecha;


-- Consulta sin índice
EXPLAIN SELECT pedido_id, cliente_id, fecha, total
FROM pedido IGNORE INDEX (idx_pedido_fecha)
WHERE fecha BETWEEN '2025-01-01' AND '2025-06-30'
ORDER BY fecha;

-- 9 
CREATE VIEW v_pedidos_cliente_vendedor AS
SELECT p.pedido_id, c.cliente_nombre, c.cliente_apellido, v.vendedor_nombre, v.vendedor_apellido, p.total
FROM pedido p
INNER JOIN cliente c ON p.cliente_id = c.cliente_id
INNER JOIN vendedor v ON p.vendedor_id = v.vendedor_id;

SHOW FULL TABLES WHERE Table_type = 'VIEW';

SELECT * FROM v_pedidos_cliente_vendedor;
