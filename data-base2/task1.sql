WITH car_stats AS (
	SELECT
		c.name AS car_name,
		c.class AS car_class,
		AVG(r.position::numeric) AS average_position,
		COUNT(r.race) AS race_count
	FROM Cars AS c
	INNER JOIN Results AS r ON r.car = c.name
	GROUP BY c.name, c.class
),
class_min AS (
	SELECT car_class, MIN(average_position) AS min_avg
	FROM car_stats
	GROUP BY car_class
)
SELECT
	cs.car_name,
	cs.car_class,
	ROUND(cs.average_position, 4) AS average_position,
	cs.race_count
FROM car_stats AS cs
INNER JOIN class_min AS cm
	ON cm.car_class = cs.car_class
	AND cs.average_position = cm.min_avg
ORDER BY average_position;
