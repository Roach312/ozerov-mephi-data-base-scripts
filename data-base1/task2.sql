SELECT v.maker, v.model, c.horsepower, c.engine_capacity, 'Car' AS vehicle_type
FROM Vehicle AS v
INNER JOIN Car AS c ON v.model = c.model
WHERE c.horsepower > 150
  AND c.engine_capacity < 3
  AND c.price < 35000

UNION ALL

SELECT v.maker, v.model, m.horsepower, m.engine_capacity, 'Motorcycle' AS vehicle_type
FROM Vehicle AS v
INNER JOIN Motorcycle AS m ON v.model = m.model
WHERE m.horsepower > 150
  AND m.engine_capacity < 1.5
  AND m.price < 20000

UNION ALL

SELECT v.maker, v.model, NULL::INTEGER, NULL::DECIMAL(4, 2), 'Bicycle' AS vehicle_type
FROM Vehicle AS v
INNER JOIN Bicycle AS b ON v.model = b.model
WHERE b.gear_count > 18
  AND b.price < 4000

ORDER BY horsepower DESC NULLS LAST;
