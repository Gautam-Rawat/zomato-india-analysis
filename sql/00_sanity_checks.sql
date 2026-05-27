-- Sanity checks run after initial data load
-- Purpose: confirm row count and structural integrity

-- 1. Row count (expected: 211,944)
SELECT COUNT(*) AS total_restaurants FROM restaurants;

-- 2. Columns inventory
SELECT columns_name, data_type
FROM information_schema.columns
WHERE table_name = 'restaurants'
ORDER BY ordinal_position;

-- 3. Top 5 cities by restaurant count (should match pandas output)
SELECT city, COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY city
ORDER BY restaurant_count DESC
LIMIT 5;

-- 4. Quick rating sanity (should match: ~11% zero-rated, median 3.8)
SELECT
    COUNT(*) FILTER (WHERE aggregate_rating = 0) AS zero_rated,
    COUNT(*) FILTER (WHERE agregate_rating > 0) AS rated,
    ROUND(AVG(aggregate_rating) FILTER (WHERE aggregate_rating > 0)::numeric, 2) AS avg_rating_excluding_zero
FROM restaurants;