-- 04_price_bands
-- Q: How do ratings (mean and variance) change across price bands

SELECT
    CASE
        WHEN average_cost_for_two < 200 THEN '1. Under Rs.200'
        WHEN average_cost_for_two < 500 THEN '2. Rs.200-Rs.499'
        WHEN average_cost_for_two < 1000 THEN '3. Rs.500-Rs.999'
        WHEN average_cost_for_two < 2000 THEN '4. Rs.1000-Rs.1999'
        ELSE '5. Rs.2000+'
    END AS price_band,
    COUNT(*) AS restaurants,
    ROUND(AVG(aggregate_rating)::numeric, 2) AS avg_rating,
    ROUND(STDDEV(aggregate_rating)::numeric, 2) AS rating_stddev,
    ROUND(MIN(aggregate_rating)::numeric, 1) AS min_rating,
    ROUND(MAX(aggregate_rating)::numeric, 1) AS max_rating
FROM restaurants
WHERE aggregate_rating > 0
GROUP BY price_band
ORDER BY price_band;