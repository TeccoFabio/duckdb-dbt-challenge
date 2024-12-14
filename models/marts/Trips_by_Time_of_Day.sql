SELECT
    time_slot,
    COUNT(*) AS total_trip,
    {{round_sum('total_amount')}} AS total_revenue
FROM
    {{ref('stg_yellow_tripdata__trips')}}
GROUP BY
    time_slot