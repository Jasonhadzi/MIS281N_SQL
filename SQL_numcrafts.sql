SELECT r.firstname
	,r.ravelname
	,p.enddate-p.startdate AS time
	,p.name
	,p.craft
FROM project p
LEFT JOIN raveler r ON
	p.raveler = r.id
LIMIT 10
;

# What are the most favored types of yarn craft?
# How many projects are listed per type of craft?
SELECT craft,
	count(*) AS numcraft
FROM project
GROUP BY craft
ORDER by numcraft DESC
LIMIT 10;

# How many projects are listed per type of craft per person?
SELECT r.firstname
	,r.ravelname
	,p.craft
	,count(*) AS numcraft
FROM project p
LEFT JOIN raveler r ON
	p.raveler = r.id
WHERE p.enddate IS NOT NULL
GROUP BY r.firstname,p.craft
ORDER BY r.firstname,numcraft DESC
LIMIT 30
;

# Only counts if projects are finished.


WITH CraftCounts AS (
    SELECT 
        p.raveler,
        r.firstname AS raveler_name,
        p.craft,
        COUNT(p.id) AS craft_count
    FROM 
        project p
    JOIN 
        raveler r
    ON 
        p.raveler = r.id
    GROUP BY 
        p.raveler, p.craft
),
RankedCrafts AS (
    SELECT 
        raveler,
        raveler_name,
        craft,
        craft_count,
        ROW_NUMBER() OVER (PARTITION BY raveler ORDER BY craft_count DESC, craft ASC) AS rank
    FROM 
        CraftCounts
)
SELECT 
    raveler,
    raveler_name,
    craft,
    craft_count
FROM 
    RankedCrafts
WHERE 
    rank = 1;


SELECT TRIM(SUBSTR(p.enddate,1,2),'/') AS endmonth
from project p
;


  'id' INTEGER PRIMARY KEY AUTOINCREMENT,
  'raveler' INTEGER NULL DEFAULT NULL,
  'name' VARCHAR(200) NULL DEFAULT NULL,
  'craft' INTEGER NULL DEFAULT NULL,
  'startdate' DATE NULL DEFAULT NULL,
  'enddate' DATE NULL DEFAULT NULL,
  'pattern' INTEGER NULL DEFAULT NULL,
  'yarn' INTEGER NULL DEFAULT NULL,
  'colorway' INTEGER NULL DEFAULT NULL,
  'needles' INTEGER NULL DEFAULT NULL,
  'desc' INTEGER NULL DEFAULT NULL,