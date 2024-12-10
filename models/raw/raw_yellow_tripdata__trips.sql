SELECT
    tpep_pickup_datetime,
    tpep_dropoff_datetime,
    VendorID,
    RatecodeID,
    PULocationID,
    trip_distance,
    passenger_count,
    trip_distance,
    fare_amount,
    tip_amount,
    total_amount,
    payment_type
FROM
    "data/raw/yellow_tripdata_2024-01.parquet"