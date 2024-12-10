WITH
final AS (
    SELECT
        time_slot AS 'Time Slot', 
        COUNT(*) AS 'Total Trip',
        --Usare macro
        ROUND(SUM(total_amount), 2) AS 'Total Revenue'
    FROM
        {{ref('stg_yellow_tripdata__trips')}}
    GROUP BY
        time_slot
)

SELECT * FROM final