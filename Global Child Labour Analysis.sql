--DISPLAY ALL INFORMATION FROM THE COMPLETE TABLE
SELECT * 
FROM cl_complete;


--DISPLAY RATIO OF MALE TO FEMALE PERCENTAGE OF ALL COUNTRIES WHILE ADDING RATIO AS A COLUMN
ALTER TABLE cl_complete 
ADD ratio
AS (percentage_of_males/percentage_of_females);
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


--IDENTIFY COUNTRIES WITH EITHER VALUE AS 0
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

--CALCULATE WORLD AVERAGE WHERE ITS ABOVE 10%
SELECT clm.country_or_area, 
       clm.male, 
       clf.female,
       ROUND((clm.male+clf.female)/2) AS average
FROM cl_male clm
JOIN cl_female clf
ON clm.country_or_area=clf.country_or_area
WHERE clm.country_or_area = 'India';

