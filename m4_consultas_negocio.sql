 -- =====================================================
-- CONSULTA 1 — Resumen ejecutivo mensual
-- Total facturado, cantidad de pedidos y ticket promedio por mes
-- ===================================================== 
  USE RetailPro;
   GO
   SELECT
    MONTH(fecha_venta)                    AS mes,
    SUM(cantidad * precio_unitario)       AS total_facturado,
    COUNT(*)                              AS cantidad_pedidos,
    AVG(cantidad * precio_unitario)       AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;

-- =====================================================
-- CONSULTA 2 — Ranking de productos
-- Top 5 de productos por total facturado
-- =====================================================
SELECT TOP 5
    id_producto,
    SUM(cantidad)                         AS unidades_vendidas,
    SUM(cantidad * precio_unitario)       AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

-- =====================================================
-- CONSULTA 3 — Clientes recurrentes
-- Clientes con más de un pedido
-- =====================================================
SELECT
    id_cliente,
    COUNT(*)                              AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)       AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- =====================================================
-- CONSULTA 4 — Meses por encima / por debajo del promedio
-- Se calcula primero el total por mes (CTE) y después
-- se compara cada mes contra el promedio mensual general
-- =====================================================
WITH ventas_por_mes AS (
    SELECT
        MONTH(fecha_venta)                AS mes,
        SUM(cantidad * precio_unitario)   AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado >= (SELECT AVG(total_facturado) FROM ventas_por_mes)
            THEN 'Por encima'
        ELSE 'Por debajo'
    END                                   AS comparacion_promedio
FROM ventas_por_mes
ORDER BY mes;

-- =====================================================
-- HALLAZGOS
-- =====================================================
-- 1. El producto 1 (id_producto = 1) concentra $3.600 de los $6.444
--    facturados, es decir el 55,9% del total. La facturación depende
--    fuertemente de un solo producto.
-- 2. El producto 2 es el que más unidades vende (13), pero queda quinto
--    en facturación ($364): mucho volumen con bajo precio unitario.
--    Más unidades no implica más ingresos.
-- 3. Los 5 clientes son recurrentes (2 pedidos cada uno), pero los
--    clientes 1 y 5 explican $4.740, el 73,6% de la facturación.
--    Además, todas las ventas cargadas son de marzo, por lo que la
--    comparación mensual (consulta 4) tiene un único mes, que coincide
--    con el promedio: hacen falta más meses de datos para comparar.
