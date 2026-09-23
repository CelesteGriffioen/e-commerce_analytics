## Insights principales
 
### 👥 Clientes
 
- Estados Unidos concentra el 34,93% de la base de clientes, más de un tercio del total;
  Indonesia es el segundo país con 20,09%. El resto se reparte entre Gran Bretaña, Brasil
  (único país latinoamericano), Canadá, Alemania y Australia.
- Distribución de género muy equilibrada: 48,05% mujeres, 48,01% hombres, 3,94% "Otro".
- Búsqueda orgánica (30,20%) y pagada (29,95%) concentran la mayor adquisición de
  clientes, con una paridad que sugiere dependencia de la publicidad paga. Email destaca
  con un 14,90%, un canal no pago con rendimiento inusualmente alto.
- La categoría "Bronze" agrupa el 56,52% de los clientes, pero la brecha de revenue
  promedio contra "Gold" es de apenas $22,30, y los clientes "Gold" superan en revenue
  promedio a los "Platinum", el sistema de tiers actual no está incentivando mayor gasto
  en los niveles más altos.
- Entre los 10 clientes de mayor revenue individual, el 50% son categoría "Bronze" y
  ninguno es "Platinum": el tier de loyalty no predice quiénes son los mejores clientes.
- El canal de adquisición del cliente no condiciona su disposición a pagar: la brecha de
  revenue promedio entre el canal más alto (Email, $147,66) y el más bajo (Social,
  $144,04) es de solo $3,62. Sin embargo, Email lidera en calidad de cliente adquirido
  además de en volumen.
### 📦 Productos
 
- Electronics lidera en revenue y unidades, pero por precio más que por volumen: su
  volumen es cercano al de Fashion, aunque genera bastante más revenue. Grocery es el
  caso opuesto, buen volumen, ticket promedio bajo.
- Ninguna marca del top 5 en revenue coincide con el top 5 en unidades vendidas — hay
  marcas que ganan por precio, no por volumen (ej. Brand_70 lidera revenue con solo 1.435
  unidades).
- Los productos premium y no premium venden prácticamente el mismo volumen (62.005 vs.
  62.283 unidades), pero el revenue premium ($6,65M) más que triplica al no premium
  ($1,98M), la demanda no distingue por "premium", el pricing sí genera el diferencial.
- La tasa de devolución promedio es 2,94%, pero el top 10 de productos con más
  devoluciones va de 11,90% a 15,22%. Brand_52 aparece dos veces en ese ranking, señal de
  un posible problema a nivel marca, no producto aislado.
- El revenue dentro de cada categoría está fuertemente concentrado en el producto líder:
  en Electronics, el top 1 genera un 34% más que el segundo puesto; en Home, el primero
  duplica casi al segundo. El crecimiento del catálogo podría beneficiarse de identificar
  qué comparten esos productos líderes para replicarlo.
### 📣 Marketing y campañas
 
- Email lidera la eficiencia de conversión (8,89%), seguido por Paid Search (8,41%) y
  Social (7,29%). Organic concentra el mayor volumen de interacciones pero con apenas
  2,09% de conversión, mucho tráfico, poca eficiencia.
- Las 50 campañas reciben un volumen de eventos parejo (~20.000 c/u), pero el desempeño
  varía fuerte: las campañas 5, 44, 29 y 18 superan 11,2% de conversión, mientras que las
  campañas 50, 1, 46, 12 y 10 no llegan a 5,2%. El `expected_uplift` proyectado se
  corresponde efectivamente con la conversión real obtenida.
- De 2 millones de eventos totales, la mitad está asociada a campañas y la mitad es
  tráfico orgánico, pero ese tráfico con campaña genera el 79,7% de los pagos totales
  (82.172 de 103.127), evidenciando que el tráfico pago convierte muchísimo mejor que el
  orgánico pese a tener el mismo volumen.
### 🔀 Funnel y comportamiento
 
- El funnel completo: 1.043.573 Views → 379.008 Clicks → 284.370 Add to Cart → 103.127
  Purchase. El paso de Click a Add to Cart tiene 75% de eficiencia, pero la conversión de
  Add to Cart a Purchase cae a 36,3%, el mayor punto de abandono del funnel.
- De 100.000 usuarios únicos, 60.091 realizaron al menos una compra (60,09% de conversión
  por usuario), lo que sugiere múltiples visitas antes de concretar.
- Mobile domina tráfico y compras por sobre Desktop y Tablet, aunque la tasa de
  conversión es homogénea entre dispositivos (~5,15%–5,17%).
- El 99,93% de las sesiones son cortas y con 5,16% de conversión; las sesiones largas
  (34 registros, máximo 2,1 horas) no generaron ninguna venta, las decisiones de compra
  ocurren de forma inmediata, no tras exploración prolongada.
### 🧪 A/B Test — Control vs Variant_A vs Variant_B
 
Sobre 1.158.485 sesiones, se evaluó si existe diferencia significativa en conversión
entre los tres grupos del experimento:
 
| Grupo | Sesiones | Conversión |
|---|---|---|
| Control | 556.138 | 9,80% |
| Variant_A | 301.706 | 6,87% |
| Variant_B | 300.641 | 8,24% |
 
Chi-cuadrado global (p < 0,0001) y tests z de proporciones por pares (p < 0,0001 en las
tres comparaciones) confirman diferencias estadísticamente significativas entre los tres
grupos. **Ambas variantes tuvieron un impacto negativo respecto a Control.**
 
**Recomendación:** desactivar ambas variantes y mantener el tráfico en Control para
evitar pérdida de ingresos.
 
### 💰 Revenue y cohortes
 
- La facturación se mantiene prácticamente plana a lo largo de tres años ($2,85M–$2,90M
  anuales), con picos recurrentes en noviembre y diciembre (la conversión mensual salta
  del promedio de 7,8% a 9,9%–10,5%) y caídas marcadas en enero y febrero.
- Ingreso bruto acumulado de $8,37M en 36 meses. Los descuentos tienen impacto marginal
  (~$100–150/mes); los reembolsos promedian -3,06% mensual sobre ingresos, con pico de
  -4,35% en marzo de 2022.
- El tamaño de las cohortes de nuevos usuarios se redujo a la mitad en tres años: de
  ~2.300 usuarios/mes en 2021 a ~1.700 en 2022 y ~1.200 en 2023.
- La retención al mes 1 es muy baja y se estabiliza (sin recuperarse) para el mes 3, el
  negocio opera casi enteramente sobre compra única, con una base de clientes recurrentes
  mínima.
