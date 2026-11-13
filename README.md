# curso-sql
# Curso SQL – Coderhouse

Repositorio con las entregas del curso de SQL de Coderhouse. El proyecto trabaja sobre una base de datos de ventas de una tienda de tecnología (**ventas_tech_db**) en SQL Server, desde la creación del modelo hasta consultas de análisis de negocio.

## Estructura del repositorio

| Archivo | Contenido |
|---|---|
| `Entrega/ventas_tech_db.sql` | Script de creación de la base: borrado de tablas, creación de tablas con claves primarias y foráneas, y carga de datos de prueba. |
| `m4_consultas_negocio.sql` | Consultas de negocio: resumen ejecutivo mensual, ranking de productos, clientes recurrentes y meses por encima o por debajo del promedio. |
| `m5_consultas_joins.sql` | Pre-entrega 5: consultas con JOIN y UNION ALL para integrar las tablas y sacar hallazgos. |

## Modelo de datos

- **Categorias**: categorías de producto (Computación, Accesorios, Audio, Almacenamiento).
- **Clientes**: datos de cada cliente (nombre, email, ciudad, fecha de registro).
- **Productos**: catálogo con precio, stock y categoría.
- **Ventas**: tabla de hechos con cliente, producto, cantidad, precio unitario y fecha.

Relaciones: `Ventas` se une con `Clientes` y con `Productos`, y `Productos` se une con `Categorias`.

## Pre-entrega 5: consultas con JOIN

1. **Vista base del proyecto (INNER JOIN):** une Ventas, Clientes y Productos y calcula el total de cada venta.
   *Hallazgo:* 10 transacciones por $6.724 en marzo de 2024. El producto con mayor facturación es "Laptop Pro 15" y Buenos Aires es la ciudad que más factura.
2. **Clientes sin ventas (LEFT JOIN):** busca clientes registrados que nunca compraron.
   *Hallazgo:* 0 filas. Todos los clientes realizaron al menos una compra.
3. **Productos sin ventas (LEFT JOIN):** busca productos del catálogo que no se vendieron.
   *Hallazgo:* 0 filas. Todos los productos tienen al menos una venta.
4. **Consolidado por canal (UNION ALL):** compara las ventas de los canales Online y Presencial.
   *Hallazgo:* el canal Presencial concentra el 70,8% de la facturación y el Online el 29,2%, lo que muestra una oportunidad de crecimiento en la tienda digital.
