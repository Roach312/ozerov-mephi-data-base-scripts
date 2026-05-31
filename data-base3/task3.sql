WITH hotel_category AS (
	SELECT
		h.ID_hotel,
		h.name,
		CASE
			WHEN AVG(r.price) < 175 THEN 'Дешевый'
			WHEN AVG(r.price) <= 300 THEN 'Средний'
			ELSE 'Дорогой'
		END AS category
	FROM Hotel AS h
	INNER JOIN Room AS r ON r.ID_hotel = h.ID_hotel
	GROUP BY h.ID_hotel, h.name
),
customer_hotels AS (
	SELECT DISTINCT
		c.ID_customer,
		c.name,
		hc.category,
		hc.name AS hotel_name
	FROM Customer AS c
	INNER JOIN Booking AS b ON b.ID_customer = c.ID_customer
	INNER JOIN Room AS r ON r.ID_room = b.ID_room
	INNER JOIN hotel_category AS hc ON hc.ID_hotel = r.ID_hotel
)
SELECT
	ID_customer,
	name,
	CASE
		WHEN BOOL_OR(category = 'Дорогой') THEN 'Дорогой'
		WHEN BOOL_OR(category = 'Средний') THEN 'Средний'
		ELSE 'Дешевый'
	END AS preferred_hotel_type,
	STRING_AGG(DISTINCT hotel_name, ',' ORDER BY hotel_name) AS visited_hotels
FROM customer_hotels
GROUP BY ID_customer, name
ORDER BY
	CASE
		WHEN BOOL_OR(category = 'Дорогой') THEN 3
		WHEN BOOL_OR(category = 'Средний') THEN 2
		ELSE 1
	END,
	ID_customer;
