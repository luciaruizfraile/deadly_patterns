-- 2. ¿A qué grupo sociales más vulnerables pertenecían las víctimas? ¿Cuál es su historia? 
USE deadly_patterns;


WITH sexo_mas_comun_por_raza AS (
  SELECT
    victim_race,
    victim_sex,
    COUNT(*) AS total
  FROM victims
  WHERE victim_sex IS NOT NULL
  GROUP BY victim_race, victim_sex
),
sexo_ranking AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY victim_race ORDER BY total DESC) AS rk
  FROM sexo_mas_comun_por_raza
)

SELECT
  v.victim_race,
  COUNT(*) AS total_race,
  ROUND(AVG(v.victim_age), 1) AS edad_media,
  s.victim_sex AS sexo_mas_comun
FROM victims v
LEFT JOIN sexo_ranking s
  ON v.victim_race = s.victim_race AND s.rk = 1
WHERE v.victim_race IS NOT NULL
GROUP BY v.victim_race, s.victim_sex
ORDER BY total_race DESC
LIMIT 10;

SELECT
victim_sex,
COUNT(victim_sex) cantidad
FROM victims
GROUP BY victim_sex;

WITH rangos_cruzados AS (
  SELECT
    FLOOR(v.victim_age / 10) * 10 AS rango_victima,
    FLOOR(p.perpetrator_age / 10) * 10 AS rango_perpetrador,
    COUNT(*) AS total
  FROM incident i
  JOIN victims v ON i.victim_id = v.victim_id
  JOIN perpetrators p ON i.record_id = p.record_id
  WHERE v.victim_age IS NOT NULL AND v.victim_age BETWEEN 0 AND 100
    AND p.perpetrator_age IS NOT NULL AND p.perpetrator_age BETWEEN 10 AND 100
  GROUP BY rango_victima, rango_perpetrador
),
ranking AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY rango_victima ORDER BY total DESC) AS rk
  FROM rangos_cruzados
)
SELECT
  CONCAT(r.rango_victima, '-', r.rango_victima + 9) AS edad_victima,
  CONCAT(r.rango_perpetrador, '-', r.rango_perpetrador + 9) AS edad_perpetrador_mas_frecuente,
  r.total AS homicidios
FROM ranking r
WHERE rk = 1
ORDER BY r.rango_victima;