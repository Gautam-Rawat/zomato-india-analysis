"""
Load cleaned Zomato data from CSV into PostgrSQL.
Run once after initial setup. Re-running will replace existing data.
"""

import os
import pandas as pd
from sqlalchemy import create_engine, text
from dotenv import load_dotenv

# Loads env vars from .env
load_dotenv()

DB_USER = os.getenv('DB_USER')
DB_PASSWORD = os.getenv('DB_PASSWORD')
DB_HOST = os.getenv('DB_HOST')
DB_PORT = os.getenv('DB_PORT')
DB_NAME = os.getenv('DB_NAME')

# Build connection string

DATABASE_URL = f"postgresql://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
engine = create_engine(DATABASE_URL)

# Testing connection
with engine.connect() as conn:
    version = conn.execute(text("SELECT version();")).scalar()
    print(f'Connected to: {version}\n')
    
# Loading cleaned data
print("Reading CSV...")
df = pd.read_csv('data/processed/zomato_clean.csv')
print(f"Loaded {len(df):,} rows from CSV\n")

# WRiting to PostgreSQL
print("Writing to PostgreSQL (this may take 1-2 minutes for 211k rows)...")
df.to_sql('restaurants', engine, if_exists= 'replace', index=False, chunksize=10000)
print("Data loaded into table: restaurants\n")

# Verifing

with engine.connect() as conn:
    count = conn.execute(text("SELECT COUNT(*) FROM restaurants;")).scalar()
    sample = conn.execute(text("SELECT name, city, aggregate_rating FROM restaurants LIMIT 5;")).fetchall()

print(f"Rows in database: {count:,}")
print("\nSample rows:")
for row in sample:
    print(f"  {row}")
