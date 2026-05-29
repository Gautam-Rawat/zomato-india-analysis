-- 02-top_cities_weighted
-- Q: Highest-rated cities, weighted by votes (popular restaurants count more)

SELECT
    city,
    COUNT(*) AS rated_restaurants,
    SUM(votes) AS total_votes,
    ROUND(AVG(aggregate_rating)::numeric, 2) AS simple_avg_rating,
    ROUND(
        (SUM(aggregate_rating * votes) / NULLIF(SUM(votes), 0))::numeric,
        2
    )AS weighted_avg_rating
FROM restaurants
WHERE aggregate_rating > 0
GROUP BY city
HAVING COUNT(*) >= 100 AND SUM(votes) > 0
ORDER BY weighted_avg_rating DESC
LIMIT 15;
