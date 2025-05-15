-- 5. ¿Qué lugares son los más inseguros, con mayor probabilidad de homicidio?

-- PERPETRATOR 

WITH raza_mas_comun AS (
  SELECT
    i.state,
    p.perpetrator_race,
    COUNT(*) AS total
  FROM perpetrators p
  JOIN incident i ON p.record_id = i.record_id
  WHERE p.perpetrator_race IS NOT NULL AND i.state IS NOT NULL
  GROUP BY i.state, p.perpetrator_race
),
raza_ranking AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY state ORDER BY total DESC) AS rk
  FROM raza_mas_comun
),

sexo_mas_comun AS (
  SELECT
    i.state,
    p.perpetrator_sex,
    COUNT(*) AS total
  FROM perpetrators p
  JOIN incident i ON p.record_id = i.record_id
  WHERE p.perpetrator_sex IS NOT NULL AND i.state IS NOT NULL
  GROUP BY i.state, p.perpetrator_sex
),
sexo_ranking AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY state ORDER BY total DESC) AS rk
  FROM sexo_mas_comun
),

arma_mas_comun AS (
  SELECT
    i.state,
    i.weapon,
    COUNT(*) AS total_weapon
  FROM incident i
  WHERE i.weapon IS NOT NULL AND i.state IS NOT NULL
  GROUP BY i.state, i.weapon
),
arma_ranking AS (
  SELECT *,
         ROW_NUMBER() OVER (PARTITION BY state ORDER BY total_weapon DESC) AS rk
  FROM arma_mas_comun
)

SELECT
  i.state,
  COUNT(*) AS total_incidents,
  ROUND(AVG(CASE WHEN p.perpetrator_age > 0 THEN p.perpetrator_age END), 1) AS edad_media,
  r.perpetrator_race AS raza_mas_comun,
  s.perpetrator_sex AS sexo_mas_comun,
  a.weapon AS arma_mas_comun
FROM perpetrators p
JOIN incident i ON p.record_id = i.record_id
LEFT JOIN raza_ranking r ON i.state = r.state AND r.rk = 1
LEFT JOIN sexo_ranking s ON i.state = s.state AND s.rk = 1
LEFT JOIN arma_ranking a ON i.state = a.state AND a.rk = 1
WHERE i.state IS NOT NULL
GROUP BY
  i.state,
  r.perpetrator_race,
  s.perpetrator_sex,
  a.weapon
ORDER BY total_incidents DESC
LIMIT 20;

-- VICTIM

WITH raza_mas_comun_por_estado AS (
  SELECT
    i.state,
    v.victim_race,
    COUNT(*) AS total
  FROM victims v
  JOIN incident i ON v.record_id = i.record_id
  WHERE v.victim_race IS NOT NULL AND i.state IS NOT NULL
  GROUP BY i.state, v.victim_race
),
raza_ranking AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY state ORDER BY total DESC) AS rk
  FROM raza_mas_comun_por_estado
),

sexo_mas_comun_por_raza_estado AS (
  SELECT
    i.state,
    v.victim_race,
    v.victim_sex,
    COUNT(*) AS total
  FROM victims v
  JOIN incident i ON v.record_id = i.record_id
  WHERE v.victim_sex IS NOT NULL AND i.state IS NOT NULL AND v.victim_race IS NOT NULL
  GROUP BY i.state, v.victim_race, v.victim_sex
),
sexo_ranking AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY state, victim_race ORDER BY total DESC) AS rk
  FROM sexo_mas_comun_por_raza_estado
)

SELECT
  i.state,
  rr.victim_race AS raza_mas_comun,
  COUNT(*) AS total_por_estado,
  ROUND(AVG(CASE WHEN v.victim_age > 0 THEN v.victim_age END), 1) AS edad_media,
  sr.victim_sex AS sexo_mas_comun_por_raza
FROM victims v
JOIN incident i ON v.record_id = i.record_id
LEFT JOIN raza_ranking rr ON i.state = rr.state AND rr.rk = 1
LEFT JOIN sexo_ranking sr ON i.state = sr.state AND v.victim_race = sr.victim_race AND sr.rk = 1
WHERE i.state IS NOT NULL
GROUP BY i.state, rr.victim_race, sr.victim_sex
ORDER BY total_por_estado DESC;



