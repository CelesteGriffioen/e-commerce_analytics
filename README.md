# E-Commerce Analytics - Análisis de Negocio con SQL
 
Análisis exploratorio y de negocio sobre un dataset de e-commerce y marketing digital, utilizando PostgreSQL. El objetivo del proyecto es responder preguntas reales de negocio combinando SQL (CTEs, window functions, análisis de cohortes) con estadística inferencial, para transformar datos crudos en conclusiones accionables.

## Sobre el dataset
 
Dataset de [Kaggle: Marketing and E-Commerce Analytics Dataset](https://www.kaggle.com/datasets/geethasagarbonthu/marketing-and-e-commerce-analytics-dataset),
compuesto por 5 tablas relacionadas:
 
- **customers**: datos demográficos y de adquisición de clientes
- **products**: catálogo de productos, categoría, marca y precio base
- **campaigns**: campañas de marketing por canal y objetivo
- **events**: eventos de comportamiento (views, clicks, add to cart, purchase) a nivel sesión
- **transactions**: transacciones concretadas, con revenue, descuentos y devoluciones

## Stack técnico
 
PostgreSQL · SQL (CTEs, Window Functions, JOINs, agregaciones) · Python (pandas, scipy,
statsmodels) para limpieza de datos y tests estadísticos · VS Code

## Proceso de limpieza de datos
 
El dataset crudo presentaba varias inconsistencias típicas de exports reales, resueltas
antes del análisis:
- Columnas numéricas enteras exportadas como decimales (`1004.0` en vez de `1004`)
- Valores `DECIMAL` con precisión insuficiente para los montos reales
- Uso de `0` como valor "sentinel" en columnas de Foreign Key para indicar ausencia de
  relación (ej. eventos sin campaña asociada), corregido a `NULL`
- Valores vacíos en columnas de FK, tratados de la misma forma

## Conclusiones generales
 
El negocio muestra señales claras de un modelo dependiente de adquisición constante más
que de retención: cohortes en caída, retención baja y sostenida, y un sistema de loyalty
tiers que no logra diferenciar ni incentivar mayor gasto. En paralelo, el tráfico pago
(especialmente Email) demuestra ser significativamente más eficiente que el orgánico, y
el catálogo de producto se beneficia más de estrategias de mix hacia premium y foco en
categorías de ticket alto que de aumentar volumen general. El experimento A/B evaluado
no logró mejorar la experiencia actual, y la recomendación es no implementarlo.

## Autora
 
Celeste Griffioen - Junior Data Analyst
