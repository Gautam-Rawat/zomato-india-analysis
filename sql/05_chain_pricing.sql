--02_chain_pricing
-- Q: For chain in %+ citites, how variable is their pricing?

WITH chain_candidates AS (
    SELECT
        name,
        COUNT(DISTINCT city) AS cities_present,
        COUNT(*) AS total_outlets,
        ROUND(AVG(average_cost_for_two)::numeric, 0) AS avg_cost,
        MIN(average_cost_for_two) AS min_cost,
        MAX(average_cost_for_two) AS max_cost,
        ROUND(STDDEV(average_cost_for_two)::numeric, 0) AS cost_stddev
    FROM restaurants
    WHERE average_cost_for_two > 0
    GROUP BY name
    HAVING COUNT(DISTINCT city) >= 5
)
SELECT
    name,
    cities_present,
    total_outlets,
    avg_cost,
    min_cost,
    max_cost,
    cost_stddev,
    ROUND((cost_stddev * 100.0 / NULLIF(avg_cost, 0))::numeric, 1) AS coeff_of_variation_pct
FROM chain_candidates
ORDER BY total_outlets DESC
LIMIT 20;