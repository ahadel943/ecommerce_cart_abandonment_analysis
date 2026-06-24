-- USING PSQL cli tool
-- create the project databse
create database cart_abandonment;

-- switch to cart_abandonment database
\c cart_abandonment;

-- create a schema for the raw data processing layer
create schema raw_data;

-- create an analytics schema for the cleaned, ready to use daa
create schema analytics_data;