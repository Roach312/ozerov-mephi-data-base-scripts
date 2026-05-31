WITH booking_details AS (
	SELECT
		c.name,
		c.email,
		c.phone,
		b.ID_booking,
		h.name AS hotel_name,
		(b.check_out_date - b.check_in_date) AS stay_days
	FROM Customer AS c
	INNER JOIN Booking AS b ON b.ID_customer = c.ID_customer
	INNER JOIN Room AS r ON r.ID_room = b.ID_room
	INNER JOIN Hotel AS h ON h.ID_hotel = r.ID_hotel
)
SELECT
	name,
	email,
	phone,
	COUNT(*) AS total_bookings,
	STRING_AGG(DISTINCT hotel_name, ', ' ORDER BY hotel_name) AS hotels,
	ROUND(AVG(stay_days::numeric), 4) AS average_stay_days
FROM booking_details
GROUP BY name, email, phone
HAVING COUNT(*) > 2 AND COUNT(DISTINCT hotel_name) > 1
ORDER BY total_bookings DESC;
