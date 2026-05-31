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
class_races AS (
	SELECT c.class AS car_class, COUNT(DISTINCT r.race) AS total_races
	FROM Cars AS c
	INNER JOIN Results AS r ON r.car = c.name
	GROUP BY c.class
),
class_metrics AS (
	SELECT
		car_class,
		COUNT(*) FILTER (WHERE average_position >= 3.0) AS low_position_count
	FROM car_stats
	GROUP BY car_class
)
SELECT
	cs.car_name,
	cs.car_class,
	ROUND(cs.average_position, 4) AS average_position,
	cs.race_count,
	cs.car_country,
	cr.total_races,
	cm.low_position_count
FROM car_stats AS cs
INNER JOIN class_races AS cr ON cr.car_class = cs.car_class
INNER JOIN class_metrics AS cm ON cm.car_class = cs.car_class
WHERE cs.average_position > 3.0
ORDER BY cm.low_position_count DESC, cs.car_class, cs.car_name;
