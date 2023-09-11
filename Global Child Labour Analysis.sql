--DISPLAY ALL INFORMATION FROM THE COMPLETE TABLE
SELECT * 
FROM cl_complete;


--DISPLAY RATIO OF MALE TO FEMALE PERCENTAGE OF ALL COUNTRIES WHILE ADDING RATIO AS A COLUMN
ALTER TABLE cl_complete 
ADD ratio AS
ROUND(cl_complete.percentage_of_males/cl_complete.percentage_of_females,2)
WHERE cl_complete.country_or_area != 'Iran';
SELECT cl_complete.country_or_area, ROUND(ratio,2) 
FROM cl_complete;


--REMOVE RATIO COLUMN FROM THE TABLE
ALTER TABLE cl_complete 
DROP COLUMN ratio;


--DISPLAY RATIO OF MALE TO FEMALE POPULATION AND GROUP IN ASCENDING ORDER
SELECT clm.country_or_area,
       clm.male,
       clf.female,
       CASE
       WHEN clf.female=0 THEN NULL
       ELSE ROUND(clm.male/clf.female,2) 
       END AS ratio
FROM cl_male clm
JOIN cl_female clf
ON clm.country_or_area=clf.country_or_area
ORDER BY ratio ASC;


--IDENTIFY COUNTRIES WITH WITHER VALUE AS 0
SELECT clm.country_or_area,
       clm.male, 
       clf.female
FROM cl_male clm
JOIN  cl_female clf
ON clm.country_or_area = clf.country_or_area 
WHERE clm.male = 0 OR clf.female = 0;


--DISPLAY BY INCREASING ORDER OF TOTAL PERCENTAGE
SELECT * 
FROM cl_complete 
ORDER BY 4 ASC;


--CALCULATE WORLD AVERAGE WHERE ITS ABOVE 10%
SELECT clm.country_or_area, 
       clm.male, 
       clf.female,
       ROUND((clm.male+clf.female)/2) AS average
FROM cl_male clm
JOIN cl_female clf
ON clm.country_or_area=clf.country_or_area
WHERE ROUND((clm.male+clf.female)/2) >= 10
ORDER BY 1;


--GET CUMULATIVE OUTPUT OF THE TOP 10 COUNTRIES

WITH ranked AS (
       SELECT clm.country_or_area, 
              clm.male, 
              clf.female,
              ROUND((clm.male+clf.female)/2) AS average,
              ROW_NUMBER() OVER(ORDER BY ROUND((clm.male + clf.female) / 2) DESC) AS row_no
      FROM cl_male clm
      JOIN cl_female clf
      ON clm.country_or_area=clf.country_or_area
      )
       
SELECT country_or_area,
       male,
       female,
       average,
       SUM(average) OVER (ORDER BY row_no) AS cumulative_avg 
FROM ranked
WHERE row_no <= 10 
ORDER BY
    row_no ASC;

--CALCULATE FOR INDIA
SELECT clm.country_or_area, 
       clm.male, 
       clf.female,
       ROUND((clm.male+clf.female)/2) AS average
FROM cl_male clm
JOIN cl_female clf
ON clm.country_or_area=clf.country_or_area
WHERE clm.country_or_area = 'India';


--CLASSIFY INTO CATEGORIES LIKE 0-10, 10-20, 20-30 ETC
--Create table for males
CREATE TABLE Maleclass(
    m0_10 VARCHAR(255),
    m11_20 VARCHAR(255),
    m21_30 VARCHAR(255),
    m31_40 VARCHAR(255),
    m41_50 VARCHAR(255),
    m51_60 VARCHAR(255)
);

DROP TABLE Maleclass;
--Create table for females
CREATE TABLE Femaleclass(
    f0_10 VARCHAR(30),
    f11_20 VARCHAR(30),
    f21_30 VARCHAR(30),
    f31_40 VARCHAR(30),
    f41_50 VARCHAR(30),
    f51_60 VARCHAR(30)
);

SELECT * FROM Maleclass;

--INSERT INTO MALECLASS TABLE

-- Insert countries into specific ranges based on their percentage
INSERT INTO Maleclass (m0-10, m11-20, m21-30, m31-40, m41-50, m51-60)
SELECT
    CASE
        WHEN clm.male BETWEEN 0 AND 10 THEN clm.country_or_area
        ELSE ''
    END AS "m0-10",
    CASE
        WHEN clm.male BETWEEN 11 AND 20 THEN clm.country_or_area
        ELSE ''
    END AS "m11-20",
    CASE
        WHEN clm.male BETWEEN 21 AND 30 THEN clm.country_or_area
        ELSE ''
    END AS "m21-30",
    CASE
        WHEN clm.male BETWEEN 31 AND 40 THEN clm.country_or_area
        ELSE ''
    END AS "m31-40",
    CASE
        WHEN clm.male BETWEEN 41 AND 50 THEN clm.country_or_area
        ELSE ''
    END AS "m41-50",
    CASE
        WHEN clm.male BETWEEN 51 AND 60 THEN clm.country_or_area
        ELSE ''
    END AS "m51-60"
FROM cl_male clm;


