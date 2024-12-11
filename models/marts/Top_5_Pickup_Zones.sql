WITH
final AS (
    SELECT 
        pu_location_id,
        RANK() OVER (
            ORDER BY COUNT(*) DESC, SUM(total_amount) DESC
        ) AS rank
    FROM
        {{ref('stg_yellow_tripdata__trips')}}
    GROUP BY
        pu_location_id
)

SELECT 
    pu_location_id AS 'Top 5 Pickup Zone'
FROM
    final
WHERE
    rank <= 5