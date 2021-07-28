ALTER TABLE users ADD job2 VARCHAR(32) NOT NULL DEFAULT 'unemployed2';
ALTER TABLE users ADD job2_grade VARCHAR(32) NOT NULL DEFAULT '0';
INSERT INTO `jobs` (name, label) VALUES
	('unemployed2','Citizen')
;
INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('unemployed2',0,'unemployed2','Unemployed',20,'{}','{}')
;
