-- 6. ¿Hay alguna relación con la estacionalidad?¿Qué meses son más seguros?

SELECT
month,
COUNT(month) cantidad
FROM incident
GROUP BY month
ORDER BY cantidad DESC;

SELECT
  CASE
    WHEN month IN ('December', 'January', 'February') THEN 'Winter'
    WHEN month IN ('March', 'April', 'May') THEN 'Spring'
    WHEN month IN ('June', 'July', 'August') THEN 'Summer'
    WHEN month IN ('September', 'October', 'November') THEN 'Autumn'
    ELSE 'Unknown'
  END AS season,
  COUNT(*) AS total
FROM incident
GROUP BY season
ORDER BY total DESC;

SELECT
  i.state,
  COUNT(*) AS total_asesinatos_invierno
FROM incident i
WHERE i.month IN ('December', 'January', 'February') AND i.state IS NOT NULL
GROUP BY i.state
ORDER BY total_asesinatos_invierno DESC;

SELECT
  i.state,
  COUNT(*) AS total_asesinatos_primavera
FROM incident i
WHERE i.month IN ('March', 'April', 'May') AND i.state IS NOT NULL
GROUP BY i.state
ORDER BY total_asesinatos_primavera DESC;

SELECT
  i.state,
  COUNT(*) AS total_asesinatos_verano
FROM incident i
WHERE i.month IN ('June', 'July', 'August') AND i.state IS NOT NULL
GROUP BY i.state
ORDER BY total_asesinatos_verano DESC;

SELECT
  i.state,
  COUNT(*) AS total_asesinatos_otono
FROM incident i
WHERE i.month IN ('September', 'October', 'November') AND i.state IS NOT NULL
GROUP BY i.state
ORDER BY total_asesinatos_otono DESC;

