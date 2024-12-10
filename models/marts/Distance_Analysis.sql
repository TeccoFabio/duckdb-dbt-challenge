WITH
final AS (
    SELECT
        trip_segment AS 'Trip Segment',
        ROUND(AVG(trip_duration), 2) AS 'Average Trip Duration',
        --Usare macro
        ROUND(SUM(total_amount), 2) AS 'Total Revenue'
    FROM 
        {{ref('stg_yellow_tripdata__trips')}}
    GROUP BY 
        trip_segment
)

SELECT * FROM final