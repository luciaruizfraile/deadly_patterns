-- 4. ¿Qué relación mantenían víctima y agresor?
SELECT
relationship,
COUNT(relationship) cantidad
FROM relationship
GROUP BY relationship
ORDER BY cantidad DESC;

SELECT
CASE
	WHEN relationship = 'Unknown' THEN 'Unknown'
    WHEN relationship = 'Stranger' OR 'Acquaintance' THEN 'Not passional'
    ELSE 'Passional'
    END AS tipe_of_relationship,
	COUNT(*) AS total
FROM relationship
GROUP BY tipe_of_relationship
ORDER BY total DESC;

