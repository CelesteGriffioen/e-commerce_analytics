import pandas as pd

FILES = [
    {
        "input": r"C:\Users\USer\OneDrive\Documentos\Proyectos Data\SQL\E-Commerce Analysis\Data\events.csv",
        "output": r"C:\Users\USer\OneDrive\Documentos\Proyectos Data\SQL\E-Commerce Analysis\Data\events_fixed.csv",
        "zero_to_null": ["campaign_id", "product_id"],
        "int_cols": ["product_id"],
    },
    {
        "input": r"C:\Users\USer\OneDrive\Documentos\Proyectos Data\SQL\E-Commerce Analysis\Data\transactions.csv",
        "output": r"C:\Users\USer\OneDrive\Documentos\Proyectos Data\SQL\E-Commerce Analysis\Data\transactions_fixed.csv",
        "zero_to_null": ["campaign_id"],
        "int_cols": ["product_id"],
    },
]

for item in FILES:
    print(f"Procesando: {item['input']}")
    df = pd.read_csv(item["input"])

    # Reemplazar ceros
    for col in item["zero_to_null"]:
        if col in df.columns:
            df[col] = df[col].replace(0, pd.NA)

    # Entero nullable sin perder nulos
    for col in item["int_cols"]:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce").astype("Int64")

    # Guardar el archivos limpios
    df.to_csv(item["output"], index=False, na_rep="")