-- Databricks notebook source
--Telling databricks to use sql_fundamentals catalog and brighttv schema to shorten the table path
USE sql_fundamentals.brighttv;

--Running full tables to see what I have
SELECT *
FROM user_profiles;

SELECT *
FROM viewership;

-- checking for duplicates in my data 
SELECT UserID,  
COUNT(*) AS duplicate_count 
FROM user_profiles 
GROUP BY UserID 
HAVING COUNT(*) > 1; 

-- Are the any rows where userID is NULL  
SELECT COUNT(*) AS cnt 
FROM user_profiles 
WHERE UserID IS NULL; 

SELECT DISTINCT UserID 
FROM user_profiles; 

----Gender checks---
SELECT DISTINCT Gender
FROM user_profiles;

--cleaning up gender
SELECT COUNT(DISTINCT userid) AS subs,  
    CASE 
        WHEN Gender = ' ' THEN 'unknown' --replaces empty space with unknown
        WHEN Gender = 'None' THEN 'unknown' --replaces none with unknown
    ELSE Gender --returns the gender as it is on the data
    END AS gender_clean --my new gender column name 
FROM user_profiles
GROUP BY Gender;

-------------------Race Checks -------------------------- 
SELECT DISTINCT Race 
FROM user_profiles; 

SELECT COUNT(*) AS num_rows 
FROM user_profiles 
WHERE Race IS NULL; 
 
SELECT DISTINCT 
    CASE 
        WHEN Race='other' THEN 'None' 
        WHEN Race=' ' THEN 'None' 
    ELSE Race 
    END AS Race 
FROM user_profiles; 

--------------Province Checks-------------------------- 
SELECT DISTINCT Province 
FROM user_profiles; 

SELECT DISTINCT 
    CASE  
        WHEN Province=' ' THEN 'Uncategorized' 
        WHEN Province='None' THEN 'Uncategorized' 
    ELSE Province 
    END AS Location 
FROM user_profiles; 

---------------------Age Checks------------------------- 
 SELECT MIN(Age) AS min_age,
        MAX(Age) AS max_age
 FROM user_profiles; 

 SELECT COUNT(*) AS cnt 
 FROM user_profileS 
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

FROM user_profiles 
), 
