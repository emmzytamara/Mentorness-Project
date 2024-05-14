create table corona_analysis(
	Province VARCHAR(60),
	Country_Region VARCHAR(60),
	Latitude FLOAT,
	Longitude FLOAT,
	Date_s DATE,
	Confirmed INT,
	Deaths INT,
	Recovered INT);
   

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\Corona Virus Dataset.csv'
INTO TABLE corona_analysis 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n' 
IGNORE 1 LINES 
(Province, `Country_Region`, Latitude, Longitude, @Date_s, Confirmed, Deaths, Recovered) 
SET Date_s = 
    CASE
        WHEN @Date_s REGEXP '^[0-9]{2}-[0-9]{2}-[0-9]{4}$' THEN STR_TO_DATE(@Date_s, '%d-%m-%Y')
        ELSE STR_TO_DATE(@Date_s, '%m/%d/%Y')
    END;

SELECT * FROM corona_analysis;

SELECT `corona_analysis`.`Province`,
    `corona_analysis`.`Country_Region`,
    `corona_analysis`.`Latitude`,
    `corona_analysis`.`Longitude`,
    `corona_analysis`.`Date_s`,
    `corona_analysis`.`Confirmed`,
    `corona_analysis`.`Deaths`,
    `corona_analysis`.`Recovered`
FROM `corona_analysis`.`corona_analysis`;


-- To avoid any errors, check missing value / null value 
-- Q1. Write a code to check NULL values

SELECT * FROM corona_analysis
WHERE Province IS NULL OR
      Country_Region IS NULL OR
      Latitude IS NULL OR
      Longitude IS NULL OR
      Date_s IS NULL OR
      Confirmed IS NULL OR
      Deaths IS NULL OR
      Recovered IS NULL;
      
-- Q2. If NULL values are present, update them with zeros for all columns. 
-- No Null/missing Values are present in the given dataset.
-- Since there are no NULL values present in the dataset, we don't need to perform any updates.

-- Q3. check total number of rows
select count(*) as total_rows
from corona_analysis;

-- Q4. Check what is start_date and end_date

SELECT MIN(Date_s) as start_date, MAX(Date_s) as end_date
FROM corona_analysis;

-- Q5. Number of month present in dataset

SELECT COUNT(DISTINCT EXTRACT(YEAR_MONTH FROM Date_s)) AS num_months
FROM corona_analysis;

-- Q6. Find monthly average for confirmed, deaths, recovered

SELECT 
    DATE_FORMAT(Date_s, '%Y') AS year_num,
    DATE_FORMAT(Date_s, '%m') AS month_num,
    ROUND(AVG(Confirmed), 2) AS confirmed_avg,
    ROUND(AVG(Deaths), 2) AS deaths_avg,
    ROUND(AVG(Recovered), 2) AS recovered_avg
FROM 
    corona_analysis
GROUP BY 
    year_num, month_num
ORDER BY 
    year_num, month_num ASC;


-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

SELECT 
    month,
    (SELECT Confirmed 
     FROM corona_analysis 
     WHERE MONTH(Date_s) = month 
     GROUP BY Confirmed 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS most_freq_confirmed,
    (SELECT Deaths 
     FROM corona_analysis 
     WHERE MONTH(Date_s) = month 
     GROUP BY Deaths 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS most_freq_deaths,
    (SELECT Recovered 
     FROM corona_analysis 
     WHERE MONTH(Date_s) = month 
     GROUP BY Recovered 
     ORDER BY COUNT(*) DESC 
     LIMIT 1) AS most_freq_recovered
FROM
    (SELECT DISTINCT EXTRACT(MONTH FROM Date_s) AS month FROM corona_analysis) AS months
ORDER BY month;

-- Q8. Find minimum values for confirmed, deaths, recovered per year
SELECT 
    EXTRACT(YEAR FROM Date_s) AS year,
    MIN(Confirmed) AS min_confirmed,
    MIN(Deaths) AS min_deaths,
    MIN(Recovered) AS min_recovered
FROM 
    corona_analysis
GROUP BY 
    year
ORDER BY 
    year;
    
-- Q9. Find maximum values of confirmed, deaths, recovered per year

SELECT 
    EXTRACT(YEAR FROM Date_s) AS year,
    MAX(Confirmed) AS max_confirmed,
    MAX(Deaths) AS max_deaths,
    MAX(Recovered) AS max_recovered
FROM 
    corona_analysis
GROUP BY 
    year
ORDER BY 
    year;


-- Q10. The total number of case of confirmed, deaths, recovered each month

SELECT 
    EXTRACT(MONTH FROM Date_s) AS month,
    SUM(Confirmed) AS total_confirmed,
    SUM(Deaths) AS total_deaths,
    SUM(Recovered) AS total_recovered
FROM 
    corona_analysis
GROUP BY 
    month
ORDER BY 
    month;


-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    EXTRACT(YEAR FROM Date_s) AS year_num,
    EXTRACT(MONTH FROM Date_s) AS month_num,
    SUM(Confirmed) AS total_confirmed,
    ROUND(AVG(Confirmed), 2) AS avg_confirmed,
    ROUND(VARIANCE(Confirmed), 2) AS variance_confirmed,
    ROUND(STDDEV(Confirmed), 2) AS standard_dev_confirmed
FROM 
    corona_analysis
GROUP BY 
    year_num, month_num
ORDER BY 
    year_num, month_num ASC;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    EXTRACT(YEAR FROM Date_s) AS year_num,
    EXTRACT(MONTH FROM Date_s) AS month_num,
    SUM(Deaths) AS total_deaths,
    ROUND(AVG(Deaths), 2) AS avg_deaths,
    ROUND(VARIANCE(Deaths), 2) AS variance_deaths,
    ROUND(STDDEV(Deaths), 2) AS standard_dev_deaths
FROM 
    corona_analysis
GROUP BY 
    year_num, month_num
ORDER BY 
    year_num, month_num ASC;


-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
    EXTRACT(YEAR FROM Date_s) AS year_num,
    EXTRACT(MONTH FROM Date_s) AS month_num,
    SUM(Recovered) AS total_recovered,
    ROUND(AVG(Recovered), 2) AS avg_recovered,
    ROUND(VARIANCE(Recovered), 2) AS variance_recovered,
    ROUND(STDDEV(Recovered), 2) AS standard_dev_recovered
FROM 
    corona_analysis
GROUP BY 
    year_num, month_num
ORDER BY 
    year_num, month_num ASC;


-- Q14. Find Country having highest number of the Confirmed case

SELECT 
    `Country_Region` AS country,
    MAX(Confirmed) AS highest_confirmed_cases
FROM 
    corona_analysis
GROUP BY 
    country
ORDER BY 
    highest_confirmed_cases DESC
LIMIT 1;


-- Q15. Find Country having lowest number of the death case

SELECT 
    Country_Region,
    SUM(Deaths) AS total_deaths
FROM 
    corona_analysis
GROUP BY 
    Country_Region
ORDER BY 
    total_deaths ASC
LIMIT 4;

-- Q16. Find top 5 countries having highest recovered case

SELECT 
    Country_Region,
    SUM(Recovered) AS total_recovered
FROM 
    corona_analysis
GROUP BY 
    Country_Region
ORDER BY 
    total_recovered DESC
LIMIT 5;

    
    
    
    
    
    
    
