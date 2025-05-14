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



