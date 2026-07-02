USE tpi;

-- === Prueba 1: violación de clave foránea ===
-- Pedido 99999 no existe → debe fallar
INSERT INTO detalle (detalle_id, pedido_id, producto_id, cantidad, precio_unitario, subtotal)
VALUES (99999, 99999, 1, 2, 100.00, 200.00);

-- === Prueba 2: total negativo (violación CHECK o dominio) ===
-- Si no hay constraint, agregarla:
-- ALTER TABLE pedido ADD CONSTRAINT chk_total_no_neg CHECK (total >= 0);
INSERT INTO pedido (pedido_id, cliente_id, vendedor_id, numero, fecha, total, estado)
VALUES (99998, 1, 1, 'TEST_NEG', '2025-10-20', -50.00, 'NUEVO');

-- === Prueba 3: duplicado de valor UNIQUE ===
-- Si la columna numero tiene UNIQUE, esto debe fallar
INSERT INTO pedido (pedido_id, cliente_id, vendedor_id, numero, fecha, total, estado)
VALUES (99997, 1, 1, 'DUP001', '2025-10-20', 100.00, 'NUEVO');

INSERT INTO pedido (pedido_id, cliente_id, vendedor_id, numero, fecha, total, estado)
VALUES (99996, 1, 1, 'DUP001', '2025-10-20', 120.00, 'NUEVO');
