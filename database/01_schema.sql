create database TPI;

use TPI;

CREATE TABLE vendedor(
vendedor_id INT PRIMARY KEY,
vendedor_nombre VARCHAR(50) NOT NULL,
vendedor_apellido VARCHAR(50) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE cliente(
cliente_id INT PRIMARY KEY,
cliente_nombre VARCHAR(50) NOT NULL,
cliente_apellido VARCHAR(50) NOT NULL,
DNI VARCHAR(50) NOT NULL,
email VARCHAR(100) NOT NULL UNIQUE,
direccion VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE producto(
producto_id INT PRIMARY KEY,
SKU VARCHAR(30) NOT NULL UNIQUE,
nombre_producto VARCHAR(50) NOT NULL,
descripción VARCHAR(50) NOT NULL,
precio INT NOT NULL CHECK (precio >= 0),
stock INT NOT NULL CHECK (stock >= 0)
);

CREATE TABLE pedido(
pedido_id INT PRIMARY KEY,
cliente_id INT NOT NULL,
vendedor_id INT NOT NULL,
eliminado BOOLEAN DEFAULT FALSE,
numero VARCHAR(20) NOT NULL UNIQUE,
fecha  DATE NOT NULL,
montoTotal DECIMAL(12,2) NOT NULL CHECK  (montoTotal >= 0),
estado VARCHAR(15) NOT NULL CHECK (estado IN ('NUEVO', 'FACTURADO', 'ENVIADO')),
CONSTRAINT fk_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(cliente_id),
CONSTRAINT fk_vendedor FOREIGN KEY (vendedor_id) REFERENCES vendedor(vendedor_id)
);
 
CREATE TABLE detalle(
detalle_id INT PRIMARY KEY,
pedido_id INT NOT NULL,
producto_id INT NOT NULL,
precio_unitario DECIMAL(12,2) NOT NULL CHECK (precio_unitario >= 0),
cantidad INT NOT NULL CHECK (cantidad >= 0),
subtotal DECIMAL(12,2) NOT NULL CHECK (subtotal >= 0),
CONSTRAINT fk_pedido FOREIGN KEY (pedido_id) REFERENCES pedido(pedido_id),
CONSTRAINT fk_producto FOREIGN KEY (producto_id) REFERENCES producto(producto_id)
);

CREATE TABLE envio(
envio_id INT PRIMARY KEY,
pedido_id INT NOT NULL UNIQUE,
eliminado BOOLEAN DEFAULT FALSE, 
tracking VARCHAR(40) UNIQUE, 
empresa VARCHAR(15) NOT NULL CHECK (empresa IN ('ANDREANI', 'OCA', 'CORREO_ARG')), 
tipo_envio VARCHAR(15) NOT NULL CHECK (tipo_envio IN ('ESTANDAR', 'EXPRES')), 
costo  DECIMAL(10,2) NOT NULL CHECK (costo >= 0), 
fecha_despacho DATE NOT NULL, 
fecha_estimada DATE NOT NULL, 
estado VARCHAR(15) NOT NULL CHECK (estado IN ('EN_PREPARACION', 'EN_TRANSITO', 'ENTREGADO')),
 CONSTRAINT fk_pedido_envio FOREIGN KEY (pedido_id) REFERENCES pedido(pedido_id)
);

-- 2 inserciones correctas

-- vendedor
INSERT INTO vendedor (vendedor_id, vendedor_nombre, vendedor_apellido, email)
VALUES (30000, 'María', 'Gómez', 'mgomez@example.com');

-- Cliente
INSERT INTO cliente (cliente_id, cliente_nombre, cliente_apellido, DNI, email, direccion)
VALUES (30000, 'Juan', 'Pérez', '32165498', 'jperez@example.com', 'Av. San Martín 1200');


-- 2 inserciones erróneas

-- No existe pedido_id = 999 en la tabla pedido
INSERT INTO envio (envio_id, pedido_id, eliminado, tracking, empresa, tipo_envio, costo, fecha_despacho, fecha_estimada, estado)
VALUES (1, 999, FALSE, 'TRK123', 'ANDREANI', 'ESTANDAR', 500.00, '2025-10-01', '2025-10-05', 'EN_PREPARACION');

-- 'PENDIENTE' no está en ('NUEVO','FACTURADO','ENVIADO')
INSERT INTO pedido (pedido_id, cliente_id, vendedor_id, numero, fecha, total, estado)
VALUES (1, 1, 1, 'P-0001', '2025-10-01', 1000.00, 'PENDIENTE'); 