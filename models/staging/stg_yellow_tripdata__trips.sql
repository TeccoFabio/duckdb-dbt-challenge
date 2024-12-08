--TODO: Delete in production!
{{ config({"materialized": "table"}) }}

WITH
source AS (
    SELECT * FROM 'data/raw/yellow_tripdata_2024-01.parquet'
),

renamed AS (
    SELECT
        --ids
        VendorID AS vendor_id,
        CAST(RatecodeID AS INTEGER) AS rate_code_id,
        PULocationID AS pu_location_id,

        --strings
        CASE
            WHEN trip_distance BETWEEN 0 AND 2 THEN 'short'
            WHEN trip_distance BETWEEN 2 AND 5 THEN 'medium'
            WHEN trip_distance > 5 THEN 'long'
            ELSE NULL
        END AS trip_segment,

        --numerics
        CAST(passenger_count AS TINYINT) AS passenger_count,
        CAST(date_diff('second', tpep_pickup_datetime, tpep_dropoff_datetime) AS FLOAT)/60 AS trip_duration,
        CAST(trip_distance AS FLOAT) AS trip_distance,    
        CAST(fare_amount AS FLOAT) AS fare_amount,
        CAST(tip_amount AS FLOAT) AS tip_amount,
        CAST(total_amount AS FLOAT) AS total_amount,

        --booleans
        CASE
            WHEN payment_type = 2 THEN true 
            ELSE false
        END AS is_prepaid,

        --timestamps
        tpep_pickup_datetime::TIMESTAMP AS tpep_pickup_datetime,
        tpep_dropoff_datetime::TIMESTAMP AS tpep_dropoff_datetime
    FROM 
        source            
    WHERE
        trip_duration > 0.0 AND trip_distance > 0.0 AND total_amount > 0.0 AND passenger_count <= 4
)

SELECT * FROM renamed
