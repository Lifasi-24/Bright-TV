-- Databricks notebook source
--Running all to see what I have
SELECT *
FROM sql_fundamentals.brighttv.user_profiles;

-- checking for duplicates in my data 
SELECT UserID,  
COUNT(*) AS duplicate_count 
FROM sql_fundamentals.brighttv.user_profiles
GROUP BY UserID 
HAVING COUNT(*) > 1; 

-- Are the any rows where userID is NULL  
SELECT COUNT(*) AS cnt 
FROM sql_fundamentals.brighttv.user_profiles 
WHERE UserID IS NULL; 

SELECT DISTINCT UserID 
FROM user_profiles; 

----Gender checks---
SELECT DISTINCT Gender
FROM sql_fundamentals.brighttv.user_profiles;

--cleaning up gender
SELECT COUNT(DISTINCT userid) AS subs,  
    CASE 
        WHEN Gender = ' ' THEN 'unknown' --replaces empty space with unknown
        WHEN Gender = 'None' THEN 'unknown' --replaces none with unknown
    ELSE Gender --returns the gender as it is on the data
    END AS gender_clean --my new gender column name 
FROM sql_fundamentals.brighttv.user_profiles
GROUP BY Gender;

-------------------Race Checks -------------------------- 
SELECT DISTINCT Race 
FROM user_profiles; 

SELECT COUNT(*) AS num_rows 
FROM sql_fundamentals.brighttv.user_profiles 
WHERE Race IS NULL; 
 
SELECT DISTINCT 
    CASE 
        WHEN Race='other' THEN 'None' 
        WHEN Race=' ' THEN 'None' 
    ELSE Race 
    END AS Race 
FROM sql_fundamentals.brighttv.user_profiles; 

--------------Province Checks-------------------------- 
SELECT DISTINCT Province 
FROM sql_fundamentals.brighttv.user_profiles; 

SELECT DISTINCT 
    CASE  
        WHEN Province=' ' THEN 'Uncategorized' 
        WHEN Province='None' THEN 'Uncategorized' 
    ELSE Province 
    END AS Location 
FROM sql_fundamentals.brighttv.user_profiles; 

---------------------Age Checks------------------------- 
 SELECT MIN(Age) AS min_age,
        MAX(Age) AS max_age
 FROM sql_fundamentals.brighttv.user_profiles; 

 SELECT COUNT(*) AS cnt 
 FROM sql_fundamentals.brighttv.user_profiles 
 WHERE age IS NULL; 

WITH user_profiles AS (---user_profiles is a CTE
SELECT UserID, 
 
    CASE  
        WHEN Province=' ' THEN 'Uncategorized' 
        WHEN Province='None' THEN 'Uncategorized' 
    ELSE Province 
    END AS Location,

   age, 
    CASE 
        WHEN age = 0 THEN 'Infants' 
        WHEN age BETWEEN 1 AND 12 THEN 'Kids' 
        WHEN age BETWEEN 13 AND 19 THEN 'Teenager' 
        WHEN age BETWEEN 20 AND 35 THEN 'Youth' 
        WHEN age BETWEEN 36 AND 50 THEN 'Adult' 
        WHEN age BETWEEN 51 AND 65 THEN 'Elder' 
        WHEN age >65 THEN 'Pensioner' 
    END AS age_groups, 

    CASE 
        WHEN (email IS NOT NULL ) OR (email=' ') OR (email NOT IN ('None'))THEN 1 
    ELSE 0 
    END AS email_flag, 

    CASE 
        WHEN `Social Media Handle` IS NOT NULL OR `Social Media Handle`=' ' OR  `Social Media Handle` NOT IN ('None') THEN 1 
    ELSE 0 
    END AS sm_flag, 

    CASE 
        WHEN Race='other' THEN 'None' 
        WHEN Race=' ' THEN 'None' 
    ELSE Race 
    END AS Race, 
 
    CASE 
        WHEN gender =' ' THEN 'None' 
        ELSE gender 
    END AS Gender

FROM sql_fundamentals.brighttv.user_profiles 
), 

viewership AS ( ---viewership as a CTE
SELECT 
    COALESCE(UserID0,userid4) AS userid, 
    TO_CHAR(RecordDate2, 'yyyyMM') AS month_id, 
    TO_DATE(RecordDate2) AS watch_date, 
    --TIME(RecordDate2) AS watch_time, 
    TO_CHAR(RecordDate2, 'DD') AS day_of_week, 
    DAYNAME(RecordDate2) AS day_name, 
 
    CASE 
        WHEN day_name IN ('Sat', 'Sun') THEN 'weekend' 
        ELSE 'weekday' 
    END AS day_classification, 
 
    MONTHNAME(RecordDate2) AS month_name, 
 
    CASE  
        WHEN Channel2 IN ('SawSee','Sawsee') THEN 'SawSee' 
        WHEN Channel2 IN ('SuperSport Live Events','Live on SuperSport', 'Supersport Live Events', 
'DStv Events 1') THEN 'Live Events' 
    ELSE Channel2 
    END AS Tv_channel, 
 
    date_format(RecordDate2, 'HH:mm:ss') AS watch_time, 
    CASE 
        WHEN watch_time BETWEEN '00:00:00' AND '05:59:59' THEN '01. Midnight' 
        WHEN watch_time BETWEEN '06:00:00' AND '11:59:59' THEN '02. Morning' 
        WHEN watch_time BETWEEN '12:00:00' AND '16:59:59' THEN '03. Afternoon' 
        WHEN watch_time BETWEEN '17:00:00' AND '23:59:59' THEN '04. Evening' 
    END AS time_of_day, 
 
    DATE_FORMAT(`Duration 2`, 'HH:mm:ss') AS duration, 
    CASE  
        WHEN duration BETWEEN '00:05:00' AND '00:30:00' THEN '01. Low Usage: <30 min' 
        WHEN duration BETWEEN '00:30:01' AND '00:59:59' THEN '02. Med Usage: <60 min' 
        WHEN duration > '00:59:59' THEN '03. High Usage: >60 min' 
        ELSE '04. No Usage' 
    END AS screen_time_bucket, 
 
    HOUR(RecordDate2) AS hour_of_day 
 
FROM sql_fundamentals.brighttv.viewership 
)
