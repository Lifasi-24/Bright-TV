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