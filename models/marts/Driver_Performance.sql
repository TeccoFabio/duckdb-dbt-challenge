WITH
final AS (
    SELECT
        vendor_id AS 'Driver',
        ROUND(SUM(tip_amount)/SUM(total_amount)*100, 2) AS 'Average Tip Percentage'
    FROM
        {{ref('stg_yellow_tripdata__trips')}}
    GROUP BY
        vendor_id
)

SELECT * FROM final

