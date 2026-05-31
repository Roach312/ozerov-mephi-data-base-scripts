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
)
SELECT
	car_name,
	car_class,
	ROUND(average_position, 4) AS average_position,
	race_count,
	car_country
FROM car_stats
ORDER BY average_position ASC, car_name ASC
LIMIT 1;
