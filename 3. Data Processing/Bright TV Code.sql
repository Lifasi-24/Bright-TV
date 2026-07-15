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
