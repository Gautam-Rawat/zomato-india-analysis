-- 03_hidden_gems
-- Q: Per city, find top "hidden gems" - high rated but low-voted restaurants

WITH ranked_gems AS(
    SELECT 
        name,
        city,
        locality,
        aggregate_rating,
        votes,
        average_cost_for_two,
        establishment,
        ROW_NUMBER() OVER(
            PARTITION BY city
            ORDER BY aggregate_rating DESC, votes ASC
        ) AS gem_rank
    FROM restaurants
    WHERE aggregate_rating >= 4.5
      AND votes BETWEEN 50 AND 300  -- enough votes to be credible, few enough to be hidden
      AND average_cost_for_two > 0

)
SELECT name, city, locality, aggregate_rating, votes, average_cost_for_two, establishment
FROM ranked_gems
WHERE gem_rank <= 3
ORDER BY city, gem_rank;