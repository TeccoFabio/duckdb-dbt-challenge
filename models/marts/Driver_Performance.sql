SELECT
    vendor_id,
    ROUND( SUM(tip_amount) / SUM(total_amount) * 100, 2) AS average_tip_percentage
FROM
    {{ref('stg_yellow_tripdata__trips')}}
GROUP BY
    vendor_id

