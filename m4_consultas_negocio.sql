
 
/*****************************************************************
*  CONSULTA 1 — Resumen ejecutivo mensual
*  Total facturado, cantidad de pedidos y ticket promedio por mes
*****************************************************************/
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
 
 
/*****************************************************************
*  CONSULTA 2 — Ranking de productos
*  Top 5 de productos por total facturado
*****************************************************************/
SELECT TOP 5
    id_producto,
    SUM(cantidad)                         AS unidades_vendidas,
    SUM(cantidad * precio_unitario)       AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
 
 
/*****************************************************************
*  CONSULTA 3 — Clientes recurrentes
*  Clientes con más de un pedido
*****************************************************************/
SELECT
    id_cliente,
    COUNT(*)                              AS cantidad_pedidos,
    SUM(cantidad * precio_unitario)       AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;
 
 
/*****************************************************************
*  CONSULTA 4 — Meses por encima / por debajo del promedio
*  Primero se calcula el total por mes (CTE) y después se
*  compara cada mes contra el promedio mensual general
*****************************************************************/
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
 
 
/*****************************************************************
*  HALLAZGOS
*
*  1. El ticket promedio ($644,40) está inflado por pocas compras
*     grandes: solo 3 de los 10 pedidos lo superan (ventas 1, 7
*     y 10) y entre los 3 suman $4.500, el 69,8% de lo facturado.
*     El pedido típico es bastante más chico que el promedio.
*
*  2. Los productos 1 y 3 generan juntos $4.950, el 76,8% del
*     total, mientras que el producto 4 queda fuera del top 5
*     con solo $360. Conviene priorizar el stock de esos dos.
*
*  3. La cantidad de pedidos no diferencia a los clientes (los 5
*     compraron 2 veces); lo que los diferencia es el monto: el
*     cliente 1 por sí solo aporta $2.640, el 41% del total.
*     Como todas las ventas son de marzo de 2024, la consulta 4
*     tiene un único mes y hacen falta más períodos para comparar.
