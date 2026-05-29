-- 01_zero_rated_by_city.sql
-- Q: What % of restaurants are zero-rated in each major city?

SELECT
    city,
    COUNT(*) AS total_restaurants,
    COUNT(*) FILTER (WHERE aggregate_rating = 0) AS zero_rated,
    ROUND(
        (COUNT(*) FILTER (WHERE aggregate_rating = 0) * 100.0 / COUNT(*))::numeric,
        1
    ) AS zero_rated_pct
FROM restaurants
GROUP BY city
HAVING COUNT(*) >= 100 -- exclude cities with too few restaurants to be meaningful
ORDER BY zero_rated_pct DESC
LIMIT 15;