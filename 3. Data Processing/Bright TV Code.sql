-- Databricks notebook source
--Telling databricks to use sql_fundamentals catalog and brighttv schema to shorten the table path
USE sql_fundamentals.brighttv;

--Running full tables to see what I have
SELECT *
FROM user_profiles;

SELECT *
FROM viewership;