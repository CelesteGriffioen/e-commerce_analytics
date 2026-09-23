-- 01. Distribución por país

SELECT country, COUNT(*) AS cantidad_clientes, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS porcentaje
FROM customers
GROUP BY country
ORDER BY cantidad_clientes DESC;

-- El 34, 93% de los clientes son de Estados Unidos, más de un tercio del total. El segundo país
-- con más clientes es Indonesia, con un 20,09%. El resto de los clientes está distribuido de forma
-- similar entre los demás países, cada uno con 7 a 10 puntos porcentuales aproximadamente. 
-- Los países son Gran Bretaña, Brasil (siendo el único país latinoamericano), Canadá, Alemania, y Australia. 


-- 02. Distribución por rango etario

SELECT 
    MAX(age) AS edad_max,
    MIN(age) AS edad_min
FROM customers;

SELECT
	CASE
		WHEN age < 25 THEN 'Joven'
		WHEN age >= 25 AND age < 35 THEN 'Joven Adulto'
		WHEN age >= 35 AND age < 45 THEN 'Adulto'
		ELSE 'Adulto Mayor'
	END AS rango_etario,
	COUNT(*) AS cantidad_clientes,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS porcentaje
FROM customers
GROUP BY rango_etario
ORDER BY cantidad_clientes DESC;

-- El rango etario de los clientes tiene mayor proporción para los Adultos y Jóvenes Adultos. 
-- El máximo de edad es 70 y el mínimo 18 años.


-- 03. Distribución por género

SELECT gender, COUNT(*) AS cantidad_clientes, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS porcentaje
FROM customers
GROUP BY gender
ORDER BY cantidad_clientes DESC;

-- El 48,05% de los clientes son mujeres, y los hombres conforman el 48,01%, haciendo una 
-- distribución muy equilibrada. El 3,94% restante corresponde a “Otro”.


-- 04. Distribución por canal de adquisición

SELECT acquisition_channel, COUNT(*) AS cantidad_clientes, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS porcentaje
FROM customers
GROUP BY acquisition_channel
ORDER BY cantidad_clientes DESC;

--La búsqueda orgánica y pagada concentran el mayor porcentaje de adquisición de clientes (30,20% y 29,95% respectivamente),
-- que sea tan parejo los porcentajes puede indicar una dependencia de la publicidad pagada.
-- Como segundo nivel, Social con 14,98% y Email 14,90% aportan  el mismo nivel. Que Email representa tal 
-- proporción en adquisición de clientes es un rendimiento poco común, pero eficiente. 
-- “Referral” se ubica al final con menos del 10%. Esto evidencia la ausencia de incentivos de referenciación.


-- 05. Qué tier de loyalty genera mayor revenue promedio por cliente? 

WITH revenue_por_cliente AS (
	SELECT c.customer_id, c.loyalty_tier, c.acquisition_channel, SUM(t.gross_revenue) AS revenue_total
	FROM customers c
	JOIN transactions t ON c.customer_id = t.customer_id
	WHERE t.refund_flag = FALSE
	GROUP BY c.customer_id, c.loyalty_tier, c.acquisition_channel
	)
SELECT loyalty_tier, COUNT(*) AS cantidad_clientes, ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS porcentaje, ROUND(AVG(revenue_total), 2) AS revenue_promedio_cliente
FROM revenue_por_cliente
GROUP BY loyalty_tier
ORDER BY revenue_promedio_cliente DESC;

-- La categoría “Bronze” representa el 56,52% de la base de clientes. 
-- La brecha de gasto promedio entre un usuario “Bronze” ($139,07) y uno “Gold” 
-- ($161,37) es de solo $22,30.
-- Los clientes “Gold” generan un revenue promedio mayor que los clientes “Platinum”. Los 
-- requisitos de la categoría más alta no incentivan más compras. 



-- 06. Cuáles son los top 10 clientes por gasto total?

SELECT c.customer_id, c.loyalty_tier, c.country, c.gender, SUM(t.gross_revenue) AS revenue_total
FROM customers c
JOIN transactions t ON c.customer_id = t.customer_id
WHERE t.refund_flag = FALSE AND t.gross_revenue IS NOT NULL
GROUP BY c.customer_id, c.loyalty_tier, c.country, c.gender
ORDER BY revenue_total DESC
LIMIT 10;

-- Entre los 10 clientes con mayor revenue individual el 50% son categoría “Bronze” y ninguno 
-- es “Platinum”. 4 de los 10, son de Estados Unidos. Sin embargo, el Top 3 contiene clientes de 
-- Brasil, Indonesia, y Australia.


-- 07. Qué canales de adquisición generan clientes de mayor valor?

WITH revenue_por_cliente AS (
    SELECT
        c.customer_id,
        c.acquisition_channel,
        SUM(t.gross_revenue) AS revenue_total
    FROM customers c
    JOIN transactions t ON c.customer_id = t.customer_id
    WHERE t.refund_flag = FALSE
    GROUP BY c.customer_id, c.acquisition_channel
)
SELECT
    acquisition_channel,
    COUNT(*) AS cantidad_clientes,
    ROUND(AVG(revenue_total), 2) AS revenue_promedio_por_cliente,
    ROUND(SUM(revenue_total), 2) AS revenue_total_del_canal
FROM revenue_por_cliente
GROUP BY acquisition_channel
ORDER BY revenue_promedio_por_cliente DESC;

-- El revenue promedio por cliente entre el canal más alto (Email con $147,66) y el más bajo 
-- (Social con $144,04) es de solo $3,62. El canal de adquisición del cliente no condiciona la 
-- disposición a pagar.
-- El total ganado es de $8,63 millones. Organic y Paid Search concentran el 60,5%. Email lidera 
-- literalmente el promedio por cliente, atrae usuarios y también usuarios con mejor perfil de compra.

