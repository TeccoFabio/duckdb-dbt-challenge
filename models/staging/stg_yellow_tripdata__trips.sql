SELECT
    --Nice to have
    --CURRENT_TIMESTAMP()::TIMESTAMPTZ AS ingested_at

    --timestamps
    tpep_pickup_datetime::TIMESTAMP AS pickup_at,
    tpep_dropoff_datetime::TIMESTAMP AS dropoff_at,

    --ids
    VendorID AS vendor_id,
    CAST(RatecodeID AS INTEGER) AS rate_code_id,
    PULocationID AS pu_location_id,

    --strings
    CASE
        WHEN trip_distance BETWEEN 0 AND 2 THEN 'Short'
        WHEN trip_distance BETWEEN 2 AND 5 THEN 'Medium'
        WHEN trip_distance > 5 THEN 'Long'
        ELSE NULL
    END AS trip_segment,
    CASE
        WHEN date_part('hour', pickup_at) BETWEEN 5 AND 11 THEN 'Morning'
        WHEN date_part('hour', pickup_at) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN date_part('hour', pickup_at) BETWEEN 17 AND 21 THEN 'Evening'
        WHEN date_part('hour', pickup_at) IN (22,23,0,1,2,3,4) THEN 'Night'
        ELSE NULL
    END AS time_slot,

    --numerics
    CAST(passenger_count AS TINYINT) AS passenger_count,
    ROUND(CAST(date_diff('second', pickup_at, dropoff_at) AS FLOAT)/60, 2) AS trip_duration,
    CAST(trip_distance AS FLOAT) AS trip_distance,    
    CAST(fare_amount AS FLOAT) AS fare_amount,
    CAST(tip_amount AS FLOAT) AS tip_amount,
    CAST(total_amount AS FLOAT) AS total_amount,

    --booleans
    CASE
        WHEN payment_type = 2 THEN true 
        ELSE false
    END AS is_prepaid
FROM 
    {{ source( "yellow_tripdata", "raw_yellow_tripdata__trips") }}            
WHERE
    (passenger_count BETWEEN 1 AND 4) AND
    trip_duration > 0.0 AND
    trip_distance > 0.0 AND
    fare_amount >= 0.0 AND
    tip_amount >= 0.0 AND
    total_amount > 0.0
