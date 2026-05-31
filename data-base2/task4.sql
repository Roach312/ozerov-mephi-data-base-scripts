WITH car_stats AS (
	SELECT
		c.name AS car_name,
		c.class AS car_class,
		AVG(r.position::numeric) AS average_position,
		COUNT(r.race) AS race_count,
		cl.country AS car_country
	FROM Cars AS c
	INNER JOIN Results AS r ON r.car = c.name
	INNER JOIN Classes AS cl ON cl.class = c.class
	GROUP BY c.name, c.class, cl.country
),
class_stats AS (
	SELECT
		car_class,
		AVG(average_position) AS class_avg_position,
		COUNT(*) AS cars_in_class
	FROM car_stats
	GROUP BY car_class
	HAVING COUNT(*) >= 2
)
SELECT
	cs.car_name,
	cs.car_class,
	ROUND(cs.average_position, 4) AS average_position,
	cs.race_count,
	cs.car_country
FROM car_stats AS cs
INNER JOIN class_stats AS cls ON cls.car_class = cs.car_class
WHERE cs.average_position < cls.class_avg_position
ORDER BY cs.car_class, cs.average_position;
