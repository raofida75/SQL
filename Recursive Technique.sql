---------------------------------------
Using Recursive Techniques with SQL. 
---------------------------------------

-- Drop the family_members table if it already exists.
DROP TABLE IF EXISTS family_members;


-- Create the table
CREATE TABLE family_members (
	person_id	    VARCHAR(20),
	relative_id1	VARCHAR(20),
	relative_id2	VARCHAR(20)
);

------------------------------------------------------------
-- Insert data
INSERT INTO family_members VALUES('ATR-1', NULL, NULL);
INSERT INTO family_members VALUES('ATR-2', 'ATR-1', NULL);
INSERT INTO family_members VALUES('ATR-3', 'ATR-2', NULL);
INSERT INTO family_members VALUES('ATR-4', 'ATR-3', NULL);
INSERT INTO family_members VALUES('ATR-5', 'ATR-4', NULL);

INSERT INTO family_members VALUES('BTR-1', NULL, NULL);
INSERT INTO family_members VALUES('BTR-2', NULL, 'BTR-1');
INSERT INTO family_members VALUES('BTR-3', NULL, 'BTR-2');
INSERT INTO family_members VALUES('BTR-4', NULL, 'BTR-3');
INSERT INTO family_members VALUES('BTR-5', NULL, 'BTR-4');

INSERT INTO family_members VALUES('CTR-1', NULL, 'CTR-3');
INSERT INTO family_members VALUES('CTR-2', 'CTR-1', NULL);
INSERT INTO family_members VALUES('CTR-3', NULL, NULL);

INSERT INTO family_members VALUES('DTR-1', 'DTR-3', 'ETR-2');
INSERT INTO family_members VALUES('DTR-2', NULL, NULL);
INSERT INTO family_members VALUES('DTR-3', NULL, NULL);

INSERT INTO family_members VALUES('ETR-1', NULL, 'DTR-2');
INSERT INTO family_members VALUES('ETR-2', NULL, NULL);

INSERT INTO family_members VALUES('FTR-1', NULL, NULL);
INSERT INTO family_members VALUES('FTR-2', NULL, NULL);
INSERT INTO family_members VALUES('FTR-3', NULL, NULL);

INSERT INTO family_members VALUES('GTR-1', 'GTR-1', NULL);
INSERT INTO family_members VALUES('GTR-2', 'GTR-1', NULL);
INSERT INTO family_members VALUES('GTR-3', 'GTR-1', NULL);

INSERT INTO family_members VALUES('HTR-1', 'GTR-1', NULL);
INSERT INTO family_members VALUES('HTR-2', 'GTR-1', NULL);
INSERT INTO family_members VALUES('HTR-3', 'GTR-1', NULL);

INSERT INTO family_members VALUES('ITR-1', NULL, NULL);
INSERT INTO family_members VALUES('ITR-2', 'ITR-3', 'ITR-1');
INSERT INTO family_members VALUES('ITR-3', NULL, NULL);
------------------------------------------------------------


-- View the table
---------------------------------------
SELECT * FROM family_members
---------------------------------------

-- Filter out the records where the person_id is ATR-2
SELECT person_id, relative_id1
FROM family_members 
WHERE person_id = 'ATR-1'


-- Get all the relatives of ATR-1, for example if the relative of ATR-1 is ATR-2 and the relative of ATR-2 is ATR-3, then ATR-3 is the relative of ATR-1
WITH RECURSIVE relatives_atr1 AS
				(SELECT person_id, relative_id1, 1 AS lvl
				 FROM family_members 
				 WHERE person_id = 'ATR-1'
				 
				 UNION
				 
				 SELECT F.person_id, F.relative_id1, lvl+1  
				 FROM relatives_atr1 R
				 JOIN family_members F
				 ON R.person_id = F.relative_id1 )
				 
SELECT person_id, lvl AS LEVEL
FROM relatives_atr1


-- Now that we've gotten all of the ATR-1 family members, let's get all of the family groups. 
WITH RECURSIVE related_family_members AS 
				(SELECT * FROM base_query
				
				UNION
				
				SELECT F.person_id, grp 
				FROM related_family_members R 
				JOIN family_members F
				ON R.relatives = F.relative_id1 OR R.relatives = F.relative_id2
				),
				
				base_query AS
				(SELECT relative_id1 AS relatives, substring(person_id,1,3) AS grp
				FROM family_members 
				WHERE relative_id1 IS NOT NULL
				
				UNION
				
				SELECT relative_id2 AS relatives, substring(person_id,1,3) AS grp
				FROM family_members 
				WHERE relative_id2 IS NOT NULL
				
				ORDER BY 1
				),
				
				no_relatives AS
				(SELECT person_id 
				FROM family_members
				WHERE relative_id1 IS NULL AND relative_id2 IS NULL AND substring(person_id,1,3) NOT IN (
				SELECT grp
				FROM base_query
				)
				) 
				

-- Let's view the results now.		
SELECT CONCAT('F_', ROW_NUMBER() OVER(ORDER BY relatives)) AS family_id, *
FROM 
(SELECT DISTINCT STRING_AGG(relatives, ',' ORDER BY relatives) AS relatives
FROM related_family_members 
GROUP BY grp

UNION

SELECT * 
FROM no_relatives
ORDER BY 1
) T;

