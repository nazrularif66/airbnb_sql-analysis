--================================================
-- CLEANING DATA
--================================================
-- CHECK NULL AND CLEANING COLUMN
-- NAME - 0.24% NULL

SELECT
	COUNT(*),
	SUM(CASE WHEN name IS NULL OR name = '' THEN 1 ELSE 0 END) as null_count,
	ROUND(SUM(CASE WHEN name IS NULL OR name = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_null
	FROM airbnb;

-- set 'unknown' column name

UPDATE airbnb
SET name = 'unknown'
WHERE name IS NULL or name = '';

-- host_identity_verified = 0.28%
SELECT
	COUNT(*),
	SUM(CASE WHEN host_identity_verified IS NULL OR host_identity_verified = '' THEN 1 ELSE 0 END) as null_count,
	ROUND(SUM(CASE WHEN host_identity_verified IS NULL OR host_identity_verified = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_null
	FROM airbnb;
-- set 'unknown' 
UPDATE airbnb
SET host_identity_verified = 'unknown'
WHERE host_identity_verified IS NULL or host_identity_verified = '';


-- instant_bookable = 50.27%
-- 50% of instant_bookable data is missing, analysis on this column may not be representative.
SELECT
	COUNT(*),
	SUM(CASE WHEN instant_bookable IS NULL OR instant_bookable = '' THEN 1 ELSE 0 END) as null_count,
	ROUND(SUM(CASE WHEN instant_bookable IS NULL OR instant_bookable = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_null
	FROM airbnb;

-- Change NULL to 'US' in country_code
SELECT DISTINCT country_code FROM airbnb;

UPDATE airbnb
SET country_code = 'US'
WHERE country_code IS NULL;

-- neighbourhood_group = 0.03 %
-- SET to 'unknown'
SELECT
	COUNT(*),
	SUM(CASE WHEN neighbourhood_group IS NULL OR neighbourhood_group = '' THEN 1 ELSE 0 END) as null_count,
	ROUND(SUM(CASE WHEN neighbourhood_group IS NULL OR neighbourhood_group = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_null
	FROM airbnb;

UPDATE airbnb
SET neighbourhood_group = 'unknown'
WHERE neighbourhood_group IS NULL;

-- host_name = 0.4%
-- SET to 'unknown'
SELECT
	COUNT(*),
	SUM(CASE WHEN host_name IS NULL OR host_name = '' THEN 1 ELSE 0 END) as null_count,
	ROUND(SUM(CASE WHEN host_name IS NULL OR host_name = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_null
	FROM airbnb;

UPDATE airbnb
SET host_name = 'unkown'
WHERE host_name IS NULL;


-- service_fee = 0.27 %
-- SET to AVG value
SELECT
	COUNT(*),
	SUM(CASE WHEN service_fee IS NULL OR service_fee = '' THEN 1 ELSE 0 END) as null_count,
	ROUND(SUM(CASE WHEN service_fee IS NULL OR service_fee = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_null
	FROM airbnb;

UPDATE airbnb
SET service_fee = (SELECT AVG(CAST(service_fee AS FLOAT)) FROM airbnb WHERE service_fee IS NOT NULL AND service_fee != '')
WHERE service_fee IS NULL OR service_fee = '';

--
SELECT * FROM airbnb

-- minimum_nights = 0.4%
-- SET to AVG value
SELECT
	COUNT(*),
	SUM(CASE WHEN minimum_nights IS NULL OR minimum_nights = '' THEN 1 ELSE 0 END) as null_count,
	ROUND(SUM(CASE WHEN minimum_nights IS NULL OR minimum_nights = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_null
	FROM airbnb;

UPDATE airbnb
SET minimum_nights = ( 
	SELECT AVG(minimum_nights) FROM airbnb WHERE minimum_nights IS NOT NULL )
WHERE minimum_nights IS NULL;

-- reviews_per_month = 15.4%
-- SET to 0
SELECT
	COUNT(*),
	SUM(CASE WHEN reviews_per_month IS NULL OR reviews_per_month = '' THEN 1 ELSE 0 END) as null_count,
	ROUND(SUM(CASE WHEN reviews_per_month IS NULL OR reviews_per_month = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_null
	FROM airbnb;

UPDATE airbnb
SET reviews_per_month = 0
WHERE reviews_per_month IS NULL;



-- availability_365 = 23.38%
-- SET to AVG
SELECT
	COUNT(*),
	SUM(CASE WHEN availability_365 IS NULL OR availability_365 = '' THEN 1 ELSE 0 END) as null_count,
	ROUND(SUM(CASE WHEN availability_365 IS NULL OR availability_365 = '' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_null
	FROM airbnb;

UPDATE airbnb
SET availability_365 = (
	SELECT AVG(availability_365) FROM airbnb WHERE availability_365 IS NOT NULL )
WHERE availability_365 IS NULL 


-- neighbourhood
	-- Change Value = Brookly to Brooklyn
				--	=  manhatan to Manhattan
UPDATE airbnb
SET neighbourhood = 
	CASE WHEN neighbourhood_group = 'Brookln' THEN  'Brooklyn'
	WHEN neighbourhood_group = 'manhatan' THEN 'Manhattan' 
	ELSE neighbourhood_group
	END
FROM airbnb;


-- neighbourhood_group
	-- Change Value = Brookly to Brooklyn
				--	=  manhatan to Manhattan

UPDATE airbnb
SET neighbourhood_group = 
	CASE WHEN neighbourhood_group = 'Brookln' THEN  'Brooklyn'
	WHEN neighbourhood_group = 'manhatan' THEN 'Manhattan' 
	ELSE neighbourhood_group
	END
FROM airbnb;

--================================================
-- EXPLORATORY DATA ANALYSIS (EDA)
--================================================

-- 1. TOP LISTING BY NEIGHBOURHOOD
-- ANSWER
	-- Bedford_Stuyvesant = 7937
	-- Williamsburg = 7775
	-- Harlem = 5466

SELECT neighbourhood, COUNT(*) as Total_Listing
FROM airbnb 
GROUP BY neighbourhood 
ORDER BY COUNT(*) DESC;

-- 2. AVERAGE PRICE BY ROOM TYPE
-- ANSWER
	-- Hotel room = 668.47
	-- Shared room = 634.13
	-- Entire home/apt = 625.08
	-- Private room = 625.01

SELECT room_type, ROUND(AVG(price),2) AS Avg_price
FROM airbnb
WHERE price IS NOT NULL AND price != ''
GROUP BY room_type
ORDER BY Avg_price DESC;

SELECT * FROM airbnb
-- 3. TOP 10 HOSTS LISITNGS 
--ANSWER 
	-- Michael = 881
	-- David = 764
	-- John = 581

SELECT TOP 3 host_name, COUNT(*) as total_listing
FROM airbnb
GROUP BY host_name
ORDER BY COUNT(*) DESC;

-- 4. AVERAGE PRICE BY NEIGHBOURHOOD GROUP
--ANSWER -- 1. Queens = 630.21
		 -- 2. Bronx = 627.77
		 -- 3. Brooklyn = 626.56
		 -- 4. Staten Island = 624.49
		 -- 5. Manhattan = 622.44

SELECT (neighbourhood_group), ROUND(AVG(price),2) AS average_price
FROM airbnb
WHERE price IS NOT NULL AND price != ''
AND neighbourhood_group != 'unknown'
GROUP BY neighbourhood_group
ORDER BY average_price DESC

-- 5. AVG cost Verified vs Unconfirmed
-- ANSWER = Unconfirmed > Verified

SELECT host_identity_verified, AVG(price) AS average_price
FROM airbnb
WHERE host_identity_verified != 'unknown'
GROUP BY host_identity_verified
ORDER BY AVG(price) DESC


-- 6. Cancellation policy distribution
-- ANSWER -- 1. Moderate = 34343
		  -- 2. strict = 34106
		  -- 3. flexible = 34074

SELECT cancellation_policy, COUNT(*) AS total
FROM airbnb
WHERE cancellation_policy IS NOT NULL
GROUP BY cancellation_policy
ORDER BY COUNT(*) DESC;


-- 7. Top 10 most reviewed listings 
-- ANSWER -- 1. Cozy Room Family Home LGA Airport NO CLEANING FEE = 2040
		  -- 2. THE PRIVACY DEN ~ 5 MINUTES TO JFK = 2000
		  -- 3. 5 minutes from JFK,one single cozy bedroom for one = 1812
		  -- 4. Sun Room Family Home LGA Airport NO CLEANING FEE = 1668
		  -- 5. Private room near LGA Airport with queen bed = 1610
		  -- 6. Peaches Paradise. = 1585
		  -- 7. Cozy Room Close to JFK!! = 1568
		  -- 8. Private Bedroom in Manhattan = 1564
		  -- 9. Queen bed-Close to Columbia U & Central Park = 1519
		  -- 10. Queen bed-Close to Columbia U & Central Park = 1498

SELECT TOP 10 name, SUM(number_of_reviews)
FROM airbnb
WHERE name != 'unknown' AND name != '#NAME?'
GROUP BY name
ORDER BY SUM(number_of_reviews) DESC

-- 8. Top 3 Average availability by neighbourhood ( Most Demand )
-- ANSWER  -- 1. Brooklyn = 129
-- ANSWER  -- 2. Manhattan = 142
-- ANSWER  -- 3. Queens = 161

SELECT neighbourhood, AVG(availability_365) as Avg_availability
FROM airbnb
WHERE availability_365 IS NOT NULL 
GROUP BY neighbourhood
ORDER BY Avg_availability ASC;
