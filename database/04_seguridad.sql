
-- Bloque 1: creación de usuarios y asignación de permisos iniciales
use tpi;

-- 1) Usuario sólo lectura para "ver" datos no sensibles

CREATE USER 'tpi_read'@'localhost' IDENTIFIED BY 'UsuarioLectura';

-- 2) Usuario app con permisos más limitados (por ejemplo para insertar pedidos y detalles)

CREATE USER IF NOT EXISTS 'tpi_app'@'localhost' IDENTIFIED BY 'UsuarioApp';
GRANT SELECT, INSERT, UPDATE ON TPI.* TO 'tpi_app'@'localhost';

-- si necesita UPDATE extra en pedido
GRANT UPDATE ON TPI.pedido TO 'tpi_app'@'localhost';

FLUSH PRIVILEGES;

-- Contraseñas
-- Password tpi_read: UsuarioLectura
-- Password tpi_app: UsuarioApp

ALTER USER 'tpi_read'@'localhost' IDENTIFIED WITH mysql_native_password BY 'UsuarioLectura';
ALTER USER 'tpi_app'@'localhost' IDENTIFIED WITH mysql_native_password BY 'UsuarioApp';


-- Bloque 2: creación de vistas y asignación de permisos de lectura solo para tpi_read
CREATE VIEW vista_clientes_publica AS
SELECT
  cliente_id,
  cliente_nombre,
  cliente_apellido,
  -- mostramos sólo los 6 primeros caracteres de la dirección y agregamos '...'
  CONCAT(LEFT(direccion, 6), '...') AS direccion_parcial
FROM cliente;

CREATE VIEW vista_productos_sin_precios AS
SELECT
  producto_id,
  SKU,
  nombre,
  LEFT(descripcion, 20) AS descripcion_corta,  -- sólo una porción
  stock
FROM producto;

GRANT SELECT ON TPI.vista_clientes_publica TO 'tpi_read'@'localhost';
GRANT SELECT ON TPI.vista_productos_sin_precios TO 'tpi_read'@'localhost';
FLUSH PRIVILEGES;
