import pandas as pd
from sqlalchemy import create_engine

# PostgreSQL connection
engine = create_engine(
    "postgresql+psycopg2://postgres:isha4@localhost:5432/customer_analytics"
)

file_path = r"C:\Users\Isha\OneDrive\Desktop\Customer Analytics & Segmentation using SQL\online_retail_II.xlsx"

sheets = ["Year 2009-2010", "Year 2010-2011"]

for i, sheet in enumerate(sheets):

    print(f"Loading: {sheet}")

    df = pd.read_excel(file_path, sheet_name=sheet)

    # Clean column names
    df.columns = (
        df.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )

    # Convert data types
    df["invoice"] = df["invoice"].astype(str)
    df["stockcode"] = df["stockcode"].astype(str)
    df["description"] = df["description"].astype("string")
    df["quantity"] = pd.to_numeric(df["quantity"], errors="coerce")
    df["invoicedate"] = pd.to_datetime(df["invoicedate"], errors="coerce")
    df["price"] = pd.to_numeric(df["price"], errors="coerce")
    df["customer_id"] = pd.to_numeric(
        df["customer_id"], errors="coerce"
    )
    df["country"] = df["country"].astype("string")

    # First sheet creates the table
    if i == 0:
        df.to_sql(
            "online_retail",
            engine,
            if_exists="replace",
            index=False,
            chunksize=10000
        )
    else:
        # Second sheet is added to the same table
        df.to_sql(
            "online_retail",
            engine,
            if_exists="append",
            index=False,
            chunksize=10000
        )

    print(f"{sheet} loaded: {len(df):,} rows")

print("DONE! Both sheets loaded into PostgreSQL.")