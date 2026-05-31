SELECT v.maker, v.model
FROM Vehicle AS v
INNER JOIN Motorcycle AS m ON v.model = m.model
WHERE m.horsepower > 150
  AND m.price < 20000
  AND m.type = 'Sport'
ORDER BY m.horsepower DESC;
