{{ config({"materialized": "view"}) }}

SELECT
    VendorID,
    date_diff('minute', tpep_pickup_datetime, tpep_dropoff_datetime) AS trip_duration,
    passenger_count,
    trip_distance,
    RatecodeID,
    fare_amount,
    tip_amount,
    total_amount
FROM 'data/raw/yellow_tripdata_2024-01.parquet'