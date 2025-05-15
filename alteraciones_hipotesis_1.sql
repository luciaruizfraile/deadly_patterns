USE deadly_patterns;

-- ALTER TABLE perpetrators
-- ADD PRIMARY KEY (perpetrator_id);
-- ALTER TABLE victims
-- MODIFY COLUMN victim_id VARCHAR(200);

ALTER TABLE incident
MODIFY COLUMN relationship_id VARCHAR(200);


ALTER TABLE incident
ADD CONSTRAINT fk_incident_relationship_id
FOREIGN KEY (relationship_id)
REFERENCES  relationship(relationship_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Execute SQL queries for insights using commands (JOIN, GROUP BY, ORDER BY, CASE).
-- Utilize SQL functions for data summarization (mean, max, min, std).

-- HIPÓTESIS
-- 1. ¿Qué características y rasgos presentan la mayoría de los delincuentes? ¿Cuál es el contexto? Debemos leer los datos con un prisma histórico y social. 
-- CTE que calcula sexo más común por raza
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
)
SELECT
  p.perpetrator_race,
  COUNT(*) AS total_race,
  ROUND(AVG(p.perpetrator_age), 1) AS edad_media,
  s.perpetrator_sex AS sexo_mas_comun
FROM perpetrators p
LEFT JOIN sexo_ranking s
  ON p.perpetrator_race = s.perpetrator_race AND s.rk = 1
WHERE p.perpetrator_race IS NOT NULL
GROUP BY p.perpetrator_race, s.perpetrator_sex
ORDER BY total_race DESC
LIMIT 10;

SELECT
perpetrator_ethnicity, 
COUNT(perpetrator_id) AS total_criminales
FROM perpetrators
GROUP BY perpetrator_ethnicity
ORDER BY total_criminales DESC;

SELECT
p.perpetrator_race,
AVG(v.victim_count)AS media_victimas
FROM perpetratorS p 
INNER JOIN incident i
ON p.record_id=i.record_id
INNER JOIN victims v 
ON i.victim_id = v.victim_id
WHERE v.victim_count>0
GROUP BY p.perpetrator_race 
ORDER BY media_victimas DESC; 
 

-- 2. ¿A qué grupo sociales más vulnerables pertenecían las víctimas? ¿Cuál es su historia? 

-- 3. ¿Qué arma es la más utilizada en estos homicidios?

-- 4. ¿Qué relación mantenían víctima y agresor?

-- 5. ¿Qué lugares son los más inseguros, con mayor probabilidad de homicidio?



