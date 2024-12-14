SELECT 
    pu_location_id,
    COUNT(*) AS total_trips,
    SUM(total_amount) AS total_revenue,
    RANK() OVER (
        ORDER BY COUNT(*) DESC, SUM(total_amount) DESC
    ) AS rank
FROM
    {{ref('stg_yellow_tripdata__trips')}}
GROUP BY
    pu_location_id
QUALIFY
    rank <= 5

/*
WITH
top_trips_top_revenue AS (
    SELECT
        pu_location_id,
        RANK() OVER (
            ORDER BY COUNT(*) DESC
        ) AS trip_rank,
        RANK() OVER (
            ORDER BY SUM(total_amount) DESC
        ) AS revenue_rank
    FROM
        {{ref('stg_yellow_tripdata__trips')}}
    GROUP BY
        pu_location_id
    QUALIFY
        trip_rank <= 5 OR revenue_rank <= 5
),

top_trips AS (
    SELECT
        pu_location_id AS trips_zone,
        trip_rank
    FROM
        top_trips_top_revenue
    WHERE
        trip_rank <= 5
    
),

top_revenue AS (
    SELECT
        pu_location_id AS revenue_zone,
        revenue_rank
    FROM
        top_trips_top_revenue
    WHERE
        revenue_rank <= 5
)

SELECT
    trips_zone,
    revenue_zone
FROM
    top_trips
JOIN
    top_revenue ON (trip_rank = revenue_rank)
*/