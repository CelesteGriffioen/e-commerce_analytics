-- 01. ¿Qué proporción de usuarios que interactúan con un producto termina realizando una compra?

SELECT event_type, COUNT(events) AS total_interacciones
FROM events
GROUP BY event_type
ORDER BY total_interacciones DESC;

SELECT COUNT(DISTINCT CASE WHEN event_type IN ('view', 'click', 'add_to_cart') THEN customer_id END) AS usuarios_interactuaron,
    COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN customer_id END) AS usuarios_compraron,
    ROUND(COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN customer_id END) * 100.0 / NULLIF(COUNT(DISTINCT CASE WHEN event_type IN ('view', 'click', 'add_to_cart') THEN customer_id END), 0), 2) AS proporcion_conversion_pct
FROM events
WHERE product_id IS NOT NULL;

-- “View” es el evento predominante con 1.043.573, seguido por “Click” con 379.008, “Add to Cart” 
-- con 284.370, “Bounce” de 189.922 y ultimo “Purchase” con 103.127. El paso de click a agregar al carrito 
-- tiene una eficiencia del 75,0% mientras que la conversión a purchase cae al 36,3%. 
-- Hay que investigar las causas del abandono entre “Add to Cart” y “Purchase”.

-- De 100.000 usuarios únicos que interactúan en la plataforma 60.091 realizaron al menos una compra, lo que 
-- representa un 60,09% de conversión por usuario. Implica que el usuario promedio realiza múltiples visitas 
-- o interacciones antes de concretar la compra.


-- 02. ¿Qué device type convierte mejor?

SELECT device_type, COUNT(*) AS total_interacciones, 
	COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS totatl_compras,
	ROUND(COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS tasa_conversion_pct 
FROM events
GROUP BY device_type
ORDER BY tasa_conversion_pct DESC;

-- “Mobile” domina el tráfico de las interacciones y las compras, seguido por “Desktop”  y “Tablet”. La tasa
-- de conversión entre dispositivos es homogénea, aproximadamente de 5,15% a 5,17%.


-- 03. ¿Las sesiones más largas terminan en más compras o al revés?

SELECT MAX(session_duration_sec) AS duracion_max, MIN(session_duration_sec) AS duracion_min
FROM events;

SELECT 
	CASE
		WHEN session_duration_sec < 2511.26 THEN 'sesion_corta'
		WHEN session_duration_sec >= 2511.26 AND session_duration_sec < 5022.53 THEN 'sesion_moderada'
		ELSE 'sesion_larga'
	END AS rango_sesiones,
	COUNT(*) AS total_eventos,
	COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) AS total_compras,
	ROUND(COUNT(CASE WHEN event_type = 'purchase' THEN 1 END) * 100.0 / NULLIF(COUNT(*), 0), 2) AS tasa_conversion
FROM events
GROUP BY rango_sesiones
ORDER BY tasa_conversion DESC;

-- La sesión más larga es de 2,1 horas. La categoría “sesion_corta” concentra el 99,93% de los eventos, con
-- una conversión del 5,16%. Las sesiones largas solo tienen 34 registros y generaron 0 ventas.
-- Las decisiones de compra ocurren de forma inmediata en sesiones cortas.


-- 04. ¿Existe una diferencia estadísticamente significativa en la conversión entre Control y Experiment? (A/B test)

SELECT experiment_group, COUNT(DISTINCT session_id) AS total_sesiones, COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN session_id END) AS sesiones_con_conversion,
    ROUND(COUNT(DISTINCT CASE WHEN event_type = 'purchase' THEN session_id END) * 100.0 / COUNT(DISTINCT session_id), 2) AS tasa_conversion_pct
FROM events
GROUP BY experiment_group
ORDER BY experiment_group;

-- Son 1.158.485 sesiones divididas entre “Control”, “Variant_A” y “Variant_B”. “Control” tiene 
-- la tasa de conversión más alta de 9,80%.

-- Chi2: 2210.0831
-- p-valor: 0.0000
-- Hay diferencia estadísticamente significativa entre los grupos
-- Control vs Variant_A - z: 45.8260, p-valor: 0.0000000000
-- Control vs Variant_B - z: 23.8165, p-valor: 0.0000000000
-- Variant_A vs Variant_B - z: -20.0996, p-valor: 0.0000000000
-- (El script con estos calculos se encuentra en la carpeta de analisis bajo el nombre A_B_test.py)

-- Los tests Chi-Cuadrado y los valores Z confirman diferencias estadísticamente significativas en 
-- todas las comparaciones de pares.
-- Ambas variantes puestas a prueba tuvieron un impacto negativo. Hay que apagar las variantes y mantener
-- el tráfico en Control para evitar pérdida de ingresos.

