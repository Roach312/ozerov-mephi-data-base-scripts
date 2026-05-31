WITH customer_stats AS (
	SELECT
		c.ID_customer,
		c.name,
		COUNT(b.ID_booking) AS total_bookings,
		COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
		SUM(r.price) AS total_spent
	FROM Customer AS c
	INNER JOIN Booking AS b ON b.ID_customer = c.ID_customer
	INNER JOIN Room AS r ON r.ID_room = b.ID_room
	INNER JOIN Hotel AS h ON h.ID_hotel = r.ID_hotel
	GROUP BY c.ID_customer, c.name
),
multi_hotel AS (
	SELECT *
	FROM customer_stats
	WHERE total_bookings > 2 AND unique_hotels > 1
),
high_spenders AS (
	SELECT *
	FROM customer_stats
	WHERE total_spent > 500
)
SELECT
	m.ID_customer,
	m.name,
	m.total_bookings,
	m.total_spent,
	m.unique_hotels
FROM multi_hotel AS m
INNER JOIN high_spenders AS h ON h.ID_customer = m.ID_customer
ORDER BY m.total_spent ASC;
