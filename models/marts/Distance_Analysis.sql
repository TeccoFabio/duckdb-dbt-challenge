SELECT
    trip_segment,
    ROUND(AVG(trip_duration), 2) AS average_trip_duration,
    {{round_sum('total_amount')}} AS total_revenue
FROM 
    {{ref('stg_yellow_tripdata__trips')}}
GROUP BY 
    trip_segment

