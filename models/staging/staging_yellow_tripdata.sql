{{ config({"materialized": "table"}) }}

SELECT * FROM 'data/raw/yellow_tripdata_2024-01.parquet'
