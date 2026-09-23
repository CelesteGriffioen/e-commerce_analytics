-- 01. ¿Qué canal tiene mejor ratio de conversión?

SELECT UPPER(traffic_source) AS canal, COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_compras, COUNT(*) AS total_eventos, ROUND(COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS tasa_conversion
FROM events
GROUP BY UPPER(traffic_source)
ORDER BY tasa_conversion DESC;

-- “Email” lidera la eficiencia de conversión con 8,89%, seguido de cerca por “Paid Search” (8,41%)
-- y “Social” (7,29%). “Organic” concentra el mayor número de interacciones, pero con una tasa de 
-- conversión de apenas 2,09%. “Direct” presenta una conversión similar.


-- 02. ¿Las campañas con mayor uplift esperado presentan también mejores resultados de conversión que las campañas con menor uplift esperado?

SELECT c.campaign_id, c.expected_uplift,
    COUNT(CASE WHEN e.event_type = 'purchase' THEN 1 END) AS compras,
    COUNT(e.event_id) AS total_eventos,
    ROUND(COUNT(CASE WHEN e.event_type = 'purchase' THEN 1 END) * 100.0 / NULLIF(COUNT(e.event_id), 0), 2) AS ratio_conversion_real_pct
FROM campaigns c
JOIN events e ON c.campaign_id = e.campaign_id
GROUP BY c.campaign_id, c.expected_uplift
ORDER BY c.expected_uplift DESC;

-- Las 50 campañas reciben un volumen bastante igual de eventos, aprox. 20.000 eventos por campaña. 
-- Las campañas 5, 44, 29, 18 logran ratios de conversión superiores al 11,2% y un expected uplift 
-- superior a 0,139. Mientras que las campañas 50, 1, 46, 12, 10 tienen un ratio de conversión menor 
-- al 5,2%. El expected uplift de las campañas está efectivamente relacionado con la tasa de conversión
-- real obtenida.
-- Mantener una asignacion uniforme de eventos/presupuesto es ineficiente.


-- 03. ¿Cuántos eventos y transacciones ocurren fuera de cualquier campaña?

SELECT COUNT(events) AS total_eventos, COUNT(CASE WHEN campaign_id IS NULL THEN 1 END) AS total_sin_campaign
FROM events;

SELECT COUNT(transactions) AS total_pagos, COUNT(CASE WHEN campaign_id IS NULL THEN 1 END) AS total_sin_campaign
FROM transactions;

-- 2 millones de eventos totales, divididos casi exactamente 50/50 entre eventos atribuidos a campañas
-- y tráfico orgánico sin campaña.
-- Hubo 103.127 pagos totales, de los cuales 82.172 provienen de campañas.
-- Aunque el tráfico se divide en partes iguales, el tráfico expuesto a campaña genera 79,7% de los 
-- pagos totales.


-- 04. ¿Cómo evolucionó el desempeño de las campañas a lo largo del tiempo?

SELECT
    DATE_TRUNC('month', t.timestamp) AS mes,
    COUNT(DISTINCT t.transaction_id) AS transacciones,
    ROUND(SUM(t.gross_revenue), 2) AS revenue_total
FROM transactions t
WHERE t.campaign_id IS NOT NULL AND t.refund_flag = FALSE
GROUP BY DATE_TRUNC('month', t.timestamp)
ORDER BY mes;

SELECT 
    DATE_TRUNC('month', e.timestamp) AS mes,
    COUNT(CASE WHEN e.event_type = 'purchase' THEN 1 END) AS compras,
    COUNT(e.event_id) AS total_eventos,
    ROUND(COUNT(CASE WHEN e.event_type = 'purchase' THEN 1 END) * 100.0 / NULLIF(COUNT(e.event_id), 0), 2) AS ratio_conversion_pct
FROM events e
WHERE e.campaign_id IS NOT NULL
GROUP BY DATE_TRUNC('month', e.timestamp)
ORDER BY mes ASC;

SELECT 
    DATE_TRUNC('month', e.timestamp) AS mes,
    c.campaign_id,
    COUNT(CASE WHEN e.event_type = 'purchase' THEN 1 END) AS compras,
    COUNT(e.event_id) AS total_eventos,
    ROUND(COUNT(CASE WHEN e.event_type = 'purchase' THEN 1 END) * 100.0 / NULLIF(COUNT(e.event_id), 0), 2) AS ratio_conversion_pct
FROM events e
JOIN campaigns c ON e.campaign_id = c.campaign_id
GROUP BY DATE_TRUNC('month', e.timestamp), c.campaign_id
ORDER BY mes ASC, ratio_conversion_pct DESC;

-- Hay una estabilidad de aprox. 2.000 transacciones e ingresos mensuales de $180.000 a $190.000. 
-- Noviembre y diciembre de cada año registran picos sistemáticos de rendimiento. Llevan la tasa de 
-- conversión mensual del promedio de 7,8% hasta un 9,9% - 10,5%.
-- El comportamiento del consumidor no varía mucho entre los años, pero sí responde de forma agresiva
-- en los últimos 2 meses del año, con una elevación del 25-30% en ventas totales.


-- 05. ¿Cuántas campañas hay por tipo de canal?

SELECT channel, COUNT(campaigns)
FROM campaigns
GROUP BY channel
ORDER BY COUNT(campaigns) DESC;

-- Hay una distribución equilibrada entre los principales canales pagados y propios: 
-- “Paid Search”, “Email”, y “Affiliate” con 11.