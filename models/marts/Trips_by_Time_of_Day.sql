WITH
final AS (
    SELECT
        time_slot AS 'Time Slot', 
        COUNT(*) AS 'Total Trip',
        {{round_sum('total_amount')}} AS 'Total Revenue'
        --ROUND(SUM(total_amount), 2) AS 'Total Revenue'
    FROM
        {{ref('stg_yellow_tripdata__trips')}}
    GROUP BY
        time_slot
)

SELECT * FROM final