WITH
final AS (
    SELECT
        vendor_id,
        SUM(tip_amount) AS total_tips,
        SUM(total_amount) AS total_revenue
        --ROUND(SUM(tip_amount)/SUM(total_amount)*100, 2) AS 'Average Tip Percentage'
    FROM
        {{ref('stg_yellow_tripdata__trips')}}
    GROUP BY
        vendor_id
)

SELECT
    vendor_id AS 'Driver',
    ROUND(total_tips / total_revenue * 100, 2) AS 'Average Tip Percentage'
FROM
    final

