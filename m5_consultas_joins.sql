/* CONSULTA 1: VISTA BASE DEL PROYECTO (INNER JOIN) */
SELECT
      V.FECHA_VENTA,
      V.ID_CLIENTE,
      C.NOMBRE,
      C.CIUDAD,
      P.NOMBRE_PRODUCTO,
      P.PRECIO,
      V.CANTIDAD,
      V.PRECIO_UNITARIO,
      (V.CANTIDAD * V.PRECIO_UNITARIO) AS TOTAL_VENTA
FROM Ventas AS V 
 INNER JOIN Clientes AS C 
  ON V.ID_CLIENTE = C.ID_CLIENTE
INNER JOIN Productos AS P
 ON V.ID_PRODUCTO = P.ID_PRODUCTO;

 -- Hallazgo: Se consolidaron 10 transacciones por un total de $6.724 en marzo de 2024. 
 -- El producto con mayor facturación es "Laptop Pro 15" ($3.600 en 2 ventas), mientras que la ciudad de Buenos Aires lidera en monto generado ($2.640),
 -- dejando la vista lista para analizar rendimiento por zona y categoría en Power BI.

 /* CONSULTA 2: CLIENTES SIN VENTAS (LEFT JOIN) */
 SELECT 
      C.NOMBRE,
      C.EMAIL,
      C.FECHA_REGISTRO
 FROM Clientes AS C 
  LEFT JOIN Ventas V 
   ON C.ID_CLIENTE = V.ID_CLIENTE
WHERE V.ID_CLIENTE IS NULL;

-- Hallazgo: La consulta devolvió 0 filas. Esto indica que el 100% de los clientes registrados en la base de datos 
-- ya han realizado al menos una compra, por lo que no se requieren acciones inmediatas de activación por parte de CRM.


/* CONSULTA 3: PRODUCTOS SIN VENTAS (LEFT JOIN) */

SELECT 
     P.NOMBRE_PRODUCTO,
     P.ID_CATEGORIA,
     P.PRECIO
FROM Productos AS P
 LEFT JOIN Ventas AS V 
  ON P.ID_PRODUCTO = V.ID_PRODUCTO
WHERE V.ID_PRODUCTO IS NULL;

-- Hallazgo: La consulta devolvió 0 filas. Todo el catálogo cargado en el sistema cuenta 
-- con al menos un movimiento de venta registrado, lo que indica una buena rotación inicial del inventario.

/* CONSULTA 4: CONSOLIDADO POR CANAL (UNION ALL) */

SELECT 
     CANAL,
     SUM(TOTAL) AS TOTAL_CANAL
FROM (
      SELECT 
           FECHA_VENTA,
           (CANTIDAD * PRECIO_UNITARIO) AS TOTAL,
           'ONLINE' AS CANAL
      FROM Ventas
      WHERE ID_VENTA % 2 = 0 

    UNION ALL 

       SELECT 
            FECHA_VENTA,
            (CANTIDAD * PRECIO_UNITARIO) AS TOTAL,
            'PRESENCIAL' AS CANAL 
       FROM Ventas 
       WHERE ID_VENTA % 2 <> 0 
     ) AS CONSOLIDADO
     GROUP BY CANAL;

     -- Hallazgo: El canal PRESENCIAL lidera ampliamente las ventas acumulando $4.560,00 (70,8% de la facturación), 
     -- mientras que el canal ONLINE genera $1.884,00 (29,2%), lo que señala una fuerte oportunidad de crecimiento y promoción en la tienda digital

