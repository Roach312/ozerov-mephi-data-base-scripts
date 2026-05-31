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
class_avg AS (
	SELECT car_class, AVG(average_position) AS class_avg_position
	FROM car_stats
	GROUP BY car_class
),
class_races AS (
	SELECT c.class AS car_class, COUNT(DISTINCT r.race) AS total_races
	FROM Cars AS c
	INNER JOIN Results AS r ON r.car = c.name
	GROUP BY c.class
),
min_class AS (
	SELECT MIN(class_avg_position) AS min_avg
	FROM class_avg
)
SELECT
	cs.car_name,
	cs.car_class,
	ROUND(cs.average_position, 4) AS average_position,
	cs.race_count,
	cs.car_country,
	cr.total_races
FROM car_stats AS cs
INNER JOIN class_avg AS ca ON ca.car_class = cs.car_class
INNER JOIN class_races AS cr ON cr.car_class = cs.car_class
INNER JOIN min_class AS m ON ca.class_avg_position = m.min_avg
ORDER BY cs.car_class, cs.car_name;
