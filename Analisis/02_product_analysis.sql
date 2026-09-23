-- 01. ¿Qué categorías y marcas generan más revenue?, ¿y más unidades vendidas?

SELECT p.category, SUM(t.gross_revenue) AS revenue_total, SUM(t.quantity) AS unidades
FROM products p
JOIN transactions t ON p.product_id = t.product_id
WHERE t.refund_flag = FALSE AND t.gross_revenue IS NOT NULL
GROUP BY p.category
ORDER BY revenue_total DESC;

SELECT p.category, SUM(t.gross_revenue) AS revenue_total, SUM(t.quantity) AS unidades
FROM products p
JOIN transactions t ON p.product_id = t.product_id
WHERE t.refund_flag = FALSE AND t.gross_revenue IS NOT NULL
GROUP BY p.category
ORDER BY unidades DESC;

SELECT p.brand, SUM(t.quantity) AS unidades, SUM(t.gross_revenue) AS revenue_total
FROM products p
JOIN transactions t ON p.product_id = t.product_id
WHERE t.refund_flag = FALSE AND t.gross_revenue IS NOT NULL
GROUP BY p.brand
ORDER BY revenue_total DESC;

SELECT p.brand, SUM(t.quantity) AS unidades, SUM(t.gross_revenue) AS revenue_total
FROM products p
JOIN transactions t ON p.product_id = t.product_id
WHERE t.refund_flag = FALSE AND t.gross_revenue IS NOT NULL
GROUP BY p.brand
ORDER BY revenue_total DESC
LIMIT 10;

-- Los productos electrónicos lideran ambas métricas, aunque el volumen es cercano a “Fashion”, 
-- genera más revenue. “Grocery” es el caso opuesto, tiene un buen volumen de unidades vendidas 
-- pero un ticket promedio bajo en comparación al resto de categorías de productos.
-- Si el objetivo es generar más ganancias, tienen más impacto potenciar “Electronics” que “Grocery”.
-- Ninguna de las marcas en el top 5 de revenue coincide con la de más unidades vendidas. “Brand_70” 
-- genera el revenue más alto con solo 1435 unidades. Hay marcas que ganan por precio y no por volumen.


-- 02. ¿Los productos premium generan mayor revenue y/o volumen de ventas que los productos no premium?

SELECT p.is_premium, SUM(t.quantity) AS unidades, SUM(t.gross_revenue) AS revenue_total
FROM products p
JOIN transactions t ON p.product_id = t.product_id
WHERE refund_flag = FALSE AND t.gross_revenue IS NOT NULL
GROUP BY p.is_premium;

-- Los productos premium y no premium venden prácticamente el mismo volumen (62005 vs. 62283) pero 
-- el revenue de premium es mayor: $6,65M contra $1,98M de los productos no premium.


-- 03. ¿Qué productos tienen alta tasa de refund?

SELECT COUNT(CASE WHEN refund_flag = TRUE THEN 1 END) AS total_devoluciones, COUNT(*) AS total_transacciones, ROUND(COUNT(CASE WHEN refund_flag = TRUE THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0),2) AS tasa_refund_promedio
FROM transactions;

SELECT p.product_id, p.brand, COUNT(*) AS total_transacciones, COUNT(CASE WHEN t.refund_flag = TRUE THEN 1 END) AS devoluciones, ROUND(COUNT(CASE WHEN t.refund_flag = TRUE THEN 1 END) * 100.0 / COUNT(*), 2) AS tasa_refund
FROM transactions t
JOIN products p ON t.product_id = p.product_id
GROUP BY p.product_id, p.brand
ORDER BY tasa_refund DESC;

--El rango de tasa de devolución va desde 15,22% a 11,90% en el top 10. “Brand_52” aparece dos veces en 
-- el ranking, podría ser que la marca presenta problemas en sus productos. La tasa promedio de refund 
-- es de 2,94%, muy por encima de lo esperado.


-- 04. Ranking de productos por revenue dentro de cada categoría.

WITH revenue_por_producto AS (
    SELECT p.category, p.product_id, p.brand, SUM(COALESCE(t.gross_revenue, 0)) AS revenue_total
    FROM products p
    JOIN transactions t ON p.product_id = t.product_id
    WHERE t.refund_flag = FALSE
    GROUP BY p.category, p.product_id
),
ranking_productos AS (
SELECT category, revenue_total, product_id, brand,
    DENSE_RANK() OVER(
        PARTITION BY category 
        ORDER BY revenue_total DESC
    ) AS ranking_categoria
FROM revenue_por_producto
)
SELECT product_id, category, ranking_categoria, revenue_total, brand
FROM ranking_productos
WHERE ranking_categoria <=5
ORDER BY category, ranking_categoria;

-- Hay concentración en el top 1 de casi todas las categorías. En “Electronics”, el producto 
-- líder genera un 34% más que el segundo. Siempre un producto domina. En “Home” el primer producto 
-- tiene una ganancia de $24.946,31, mientras que el segundo tiene $17.057,87. El revenue de cada 
-- categoría no está distribuido de una forma equilibrada entre los productos. Identificar qué tienen 
-- en común esos productos con mejor revenue para replicarlo en el resto del catálogo seria un buen 
-- seguimiento de crecimiento económico.