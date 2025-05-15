-- 3. ¿Qué arma es la más utilizada en estos homicidios?
USE deadly_patterns;

SELECT
weapon,
COUNT(weapon) cantidad
FROM incident
GROUP BY weapon
ORDER BY cantidad DESC;

WITH sexo_mas_comun_por_raza AS (
  SELECT
    perpetrator_race,
    perpetrator_sex,
    COUNT(*) AS total
  FROM perpetrators
  WHERE perpetrator_sex IS NOT NULL
  GROUP BY perpetrator_race, perpetrator_sex
),
sexo_ranking AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY perpetrator_race ORDER BY total DESC) AS rk
  FROM sexo_mas_comun_por_raza
),
arma_mas_comun_por_raza AS (
  SELECT
    p.perpetrator_race,
    i.weapon,
    COUNT(*) AS total_weapon
  FROM perpetrators p
  JOIN incident i ON p.record_id = i.record_id
  WHERE i.weapon IS NOT NULL
  GROUP BY p.perpetrator_race, i.weapon
),
arma_ranking AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY perpetrator_race ORDER BY total_weapon DESC) AS rk
  FROM arma_mas_comun_por_raza
)
SELECT
  p.perpetrator_race,
  COUNT(*) AS total_race,
  ROUND(AVG(p.perpetrator_age), 1) AS edad_media,
  s.perpetrator_sex AS sexo_mas_comun,
  w.weapon AS arma_mas_comun
FROM perpetrators p
LEFT JOIN sexo_ranking s
  ON p.perpetrator_race = s.perpetrator_race AND s.rk = 1
LEFT JOIN arma_ranking w
  ON p.perpetrator_race = w.perpetrator_race AND w.rk = 1
WHERE p.perpetrator_race IS NOT NULL
GROUP BY
  p.perpetrator_race,
  s.perpetrator_sex,
  w.weapon
ORDER BY total_race DESC
LIMIT 10;