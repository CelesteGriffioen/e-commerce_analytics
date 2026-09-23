-- 01. Revenue mensual y su tendencia.

WITH revenue_mensual AS (
    SELECT DATE_TRUNC('month', timestamp) AS mes, SUM(gross_revenue) AS revenue_bruto, COUNT(*) AS total_transacciones
    FROM transactions
    WHERE refund_flag = FALSE
    GROUP BY DATE_TRUNC('month', timestamp)
)
SELECT 
    mes,
    revenue_bruto AS revenue_mes_actual,
    LAG(revenue_bruto) OVER (ORDER BY mes ASC) AS revenue_mes_anterior,
    ROUND((revenue_bruto - LAG(revenue_bruto) OVER (ORDER BY mes ASC)) * 100.0 / NULLIF(LAG(revenue_bruto) OVER (ORDER BY mes ASC), 0), 2) AS tendencia_crecimiento_pct
FROM revenue_mensual
ORDER BY mes ASC;

-- La facturación total se mantiene prácticamente plana a lo largo de los tres años, entre $2,85M y $2,90M, 
-- Destacan picos de ingresos recurrentes en noviembre y diciembre. Enero y febrero sufren las mayores caídas
-- intermensuales.


-- 02. ¿Cuál es el revenue después de los descuentos y cómo impactan los reembolsos?

SELECT 
    DATE_TRUNC('month', timestamp) AS mes,
    SUM(gross_revenue) AS revenue_bruto,
    SUM(COALESCE(discount_applied, 0)) AS total_descuentos,
    SUM(gross_revenue - COALESCE(discount_applied, 0)) AS revenue_post_descuento,
    SUM(CASE WHEN refund_flag = TRUE THEN gross_revenue ELSE 0 END) AS revenue_reembolsado,
    ROUND(SUM(CASE WHEN refund_flag = TRUE THEN gross_revenue ELSE 0 END) * 100.0 / NULLIF(SUM(gross_revenue), 0), 2) AS impacto_reembolso_pct,
    SUM(CASE WHEN refund_flag = FALSE THEN (gross_revenue - COALESCE(discount_applied, 0)) ELSE 0 END) AS revenue_neto_final
FROM transactions
GROUP BY DATE_TRUNC('month', timestamp)
ORDER BY mes ASC;

-- El ingreso bruto total acumula $8,37M en los 36 meses registrados. Los descuentos presentan un impacto 
-- insignificante, de aproximadamente $100 a $150 por mes. Los reembolsos tienen un impacto mensual promedio 
-- de -3,06% sobre los ingresos, alcanzando su punto máximo en marzo de 2022 con -4,35%.


-- 03. Retención: De los clientes que se sumaron en un mes dado, ¿cuántos siguen comprando 1, 2, 3 meses después?

WITH primera_compra_cliente AS (
    SELECT customer_id, DATE_TRUNC('month', MIN(timestamp)) AS mes_cohorte
    FROM transactions
    WHERE refund_flag = FALSE
    GROUP BY customer_id
),
actividad_clientes AS (
    SELECT p.customer_id, p.mes_cohorte, DATE_TRUNC('month', t.timestamp) AS mes_transaccion,
        (EXTRACT(YEAR FROM AGE(DATE_TRUNC('month', t.timestamp), p.mes_cohorte)) * 12 + EXTRACT(MONTH FROM AGE(DATE_TRUNC('month', t.timestamp), p.mes_cohorte))) AS meses_transcurridos
    FROM primera_compra_cliente p
    JOIN transactions t ON p.customer_id = t.customer_id
    WHERE t.refund_flag = FALSE
)
SELECT 
    mes_cohorte,
    COUNT(DISTINCT CASE WHEN meses_transcurridos = 0 THEN customer_id END) AS m0_inicial,
    COUNT(DISTINCT CASE WHEN meses_transcurridos = 1 THEN customer_id END) AS m1_retencion,
    COUNT(DISTINCT CASE WHEN meses_transcurridos = 2 THEN customer_id END) AS m2_retencion,
    COUNT(DISTINCT CASE WHEN meses_transcurridos = 3 THEN customer_id END) AS m3_retencion
FROM actividad_clientes
GROUP BY mes_cohorte
ORDER BY mes_cohorte ASC;

-- El tamaño de las cohortes iniciales se ha reducido a la mitad en tres años. Se pasó de un promedio de 2300 
-- nuevos usuarios mensuales en 2021 a 1700 nuevos usuarios en 2022 y a solo 1200 en 2023. La retención al mes
-- 1 es muy baja. Para el mes 3, la retención se mantiene plana.
-- Una gran proporción de los usuarios adquiridos no vuelve a comprar en el mes siguiente. El negocio opera casi
-- en su totalidad sobre “compra única”.

