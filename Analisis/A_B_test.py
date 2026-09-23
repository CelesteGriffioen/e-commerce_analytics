from scipy.stats import chi2_contingency
import numpy as np

control    = [54489, 501649]
variant_a  = [20719, 280987]
variant_b  = [24760, 275881]

tabla = np.array([control, variant_a, variant_b])

chi2, p_valor, gl, esperado = chi2_contingency(tabla)

print(f"Chi2: {chi2:.4f}")
print(f"p-valor: {p_valor:.4f}")

if p_valor < 0.05:
    print("Hay diferencia estadísticamente significativa entre los grupos")
else:
    print("No hay evidencia suficiente de diferencia entre los grupos")

from statsmodels.stats.proportion import proportions_ztest

# Control vs Variant_A
count = [54489, 20719]
nobs  = [556138, 301706]
z_stat, p_valor = proportions_ztest(count, nobs)
print(f"Control vs Variant_A - z: {z_stat:.4f}, p-valor: {p_valor:.10f}")

# Control vs Variant_B
count = [54489, 24760]
nobs  = [556138, 300641]
z_stat, p_valor = proportions_ztest(count, nobs)
print(f"Control vs Variant_B - z: {z_stat:.4f}, p-valor: {p_valor:.10f}")

# Variant_A vs Variant_B
count = [20719, 24760]
nobs  = [301706, 300641]
z_stat, p_valor = proportions_ztest(count, nobs)
print(f"Variant_A vs Variant_B - z: {z_stat:.4f}, p-valor: {p_valor:.10f}")