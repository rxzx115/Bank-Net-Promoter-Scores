-- To test the data that is loaded into the database and table
SELECT *
FROM molten-thought-441320-u6.Example.netpromoterscores
LIMIT 10


-- To confirm if there are any missing data in the id
SELECT id
FROM molten-thought-441320-u6.Example.netpromoterscores
WHERE id IS NULL


-- To confirm if there are any missing data in the market
SELECT market
FROM molten-thought-441320-u6.Example.netpromoterscores
WHERE market IS NULL


-- To confirm if there are any missing data in the rating
SELECT rating
FROM molten-thought-441320-u6.Example.netpromoterscores
WHERE rating IS NULL


-- To find the distinct market to clean up any incomplete data
SELECT DISTINCT market
FROM molten-thought-441320-u6.Example.netpromoterscores


-- To find the distinct nps to clean up any incomplete data
SELECT DISTINCT rating
FROM molten-thought-441320-u6.Example.netpromoterscores
ORDER BY rating ASC


--To find the number of distinct id
SELECT
    COUNT(DISTINCT id) AS unique_id_count,
    COUNT(*) AS total_id_count
FROM molten-thought-441320-u6.Example.netpromoterscores


-- To identify the number of status_id that show up more than once in the data
SELECT id, COUNT(id) AS id_count
FROM molten-thought-441320-u6.Example.netpromoterscores
GROUP BY id
HAVING COUNT(id) > 1


-- To identify the number of customer_name that show up more than once in the data
SELECT customer_name, COUNT(customer_name) AS customer_name_count
FROM molten-thought-441320-u6.Example.netpromoterscores
GROUP BY customer_name
HAVING COUNT(customer_name) > 1


-- To review customer name further for Michael White
SELECT *
FROM molten-thought-441320-u6.Example.netpromoterscores
WHERE customer_name = 'Michael White'


-- To review customer name further for Ricky Armstrong
SELECT *
FROM molten-thought-441320-u6.Example.netpromoterscores
WHERE customer_name = 'Ricky Armstrong'


-- To standardize the survey_date field since there are a mix of data formats for further analysis and create a table
-- To create a clean table with the calculations to finish the data cleaning process and to use for data visualization process
CREATE TABLE molten-thought-441320-u6.Example.netpromoterscoresupdated AS 
WITH datesparsed AS (
    SELECT
        *,
        SUBSTR(survey_date, 1, INSTR(survey_date, '/') - 1) AS part1,
        SUBSTR(survey_date, INSTR(survey_date, '/') + 1, INSTR(survey_date, '/', 1, 2) - INSTR(survey_date, '/') - 1) AS part2,
        CASE
            WHEN LENGTH(SUBSTR(survey_date, INSTR(survey_date, '/', 1, 2) + 1)) = 2
            THEN CONCAT('20', SUBSTR(survey_date, INSTR(survey_date, '/', 1, 2) + 1))
            ELSE SUBSTR(survey_date, INSTR(survey_date, '/', 1, 2) + 1)
        END AS part3
    FROM
        molten-thought-441320-u6.Example.netpromoterscores
)
SELECT
    *,
    DATE(CAST(part3 AS INT), CAST(part2 AS INT), CAST(part1 AS INT)) as survey_date_updated,
    CASE
        WHEN rating >= 9 THEN 'promoter'
        WHEN rating BETWEEN 7 AND 8 THEN 'passive'
        WHEN rating <= 6 THEN 'detractor'
        ELSE 'unknown'
    END AS rating_type
FROM datesparsed


-- To drop table if needed
DROP TABLE molten-thought-441320-u6.Example.netpromoterscoresupdated


-- To find the count, nps, min date, and max date of surveys overall
SELECT 
    COUNT(id) AS id_count, 
    ROUND((COUNTIF(rating_type = 'promoter') / COUNT(*) - COUNTIF(rating_type = 'detractor') / COUNT(*)) * 100 , 1) AS nps,  
    DATE(MIN(survey_date_updated)) AS date_min,
    DATE(MAX(survey_date_updated)) AS date_max, 
FROM
    molten-thought-441320-u6.Example.netpromoterscoresupdated


-- To find the count, nps, min date, and max date of surveys by market
SELECT
    market,
    COUNT(id) AS id_count, 
    ROUND((COUNTIF(rating_type = 'promoter') / COUNT(*) - COUNTIF(rating_type = 'detractor') / COUNT(*)) * 100 , 1) AS nps,  
    DATE(MIN(survey_date_updated)) AS date_min,
    DATE(MAX(survey_date_updated)) AS date_max, 
FROM
    molten-thought-441320-u6.Example.netpromoterscoresupdated
GROUP BY
    market
ORDER BY
    market ASC


-- To create a report of the NPS monthly overall
SELECT
    EXTRACT(MONTH FROM survey_date_updated) AS month,
    ROUND((COUNTIF(rating_type = 'promoter') / COUNT(*) - COUNTIF(rating_type = 'detractor') / COUNT(*)) * 100 , 1) AS nps,  
FROM
    molten-thought-441320-u6.Example.netpromoterscoresupdated
GROUP BY month
ORDER BY
    EXTRACT(MONTH FROM survey_date_updated) ASC


-- To create a report of the NPS monthly for US market
SELECT
    EXTRACT(MONTH FROM survey_date_updated) AS month,
    ROUND((COUNTIF(rating_type = 'promoter') / COUNT(*) - COUNTIF(rating_type = 'detractor') / COUNT(*)) * 100 , 1) AS nps,  
FROM
    molten-thought-441320-u6.Example.netpromoterscoresupdated
WHERE market = 'US'
GROUP BY month
ORDER BY
    EXTRACT(MONTH FROM survey_date_updated) ASC


-- To create a report of the average NPS monthly for MEX market
SELECT
    EXTRACT(MONTH FROM survey_date_updated) AS month,
    ROUND((COUNTIF(rating_type = 'promoter') / COUNT(*) - COUNTIF(rating_type = 'detractor') / COUNT(*)) * 100 , 1) AS nps,  
FROM
    molten-thought-441320-u6.Example.netpromoterscoresupdated
WHERE market = 'MEX'
GROUP BY month
ORDER BY
    EXTRACT(MONTH FROM survey_date_updated) ASC


-- To create a report of the average NPS monthly for UK market
SELECT
    EXTRACT(MONTH FROM survey_date_updated) AS month,
    ROUND((COUNTIF(rating_type = 'promoter') / COUNT(*) - COUNTIF(rating_type = 'detractor') / COUNT(*)) * 100 , 1) AS nps,  
FROM
    molten-thought-441320-u6.Example.netpromoterscoresupdated
WHERE market = 'UK'
GROUP BY month
ORDER BY
    EXTRACT(MONTH FROM survey_date_updated) ASC


-- To create a report on the differences in the distribution of NPS responses (e.g., promoters, passives, detractors) across different market segments
WITH calcuatedcte AS (
    SELECT
        market,
        COUNTIF(rating >= 9) AS promoters,
        COUNTIF(rating BETWEEN 7 AND 8) AS passives,
        COUNTIF(rating <= 6) AS detractors,
        COUNT(*) AS total_responses,
        ROUND(COUNTIF(rating >= 9) / COUNT(*) * 100.0, 2) AS promoter_percentage,
        ROUND(COUNTIF(rating BETWEEN 7 AND 8) / COUNT(*) * 100.0, 2) AS passive_percentage,
        ROUND(COUNTIF(rating <= 6) / COUNT(*) * 100.0, 2) AS detractor_percentage
    FROM
        molten-thought-441320-u6.Example.netpromoterscoresupdated
    GROUP BY
        market
    ORDER BY
        market ASC
)
SELECT
    *,
    ROUND(promoter_percentage - detractor_percentage, 2) AS nps
FROM calcuatedcte


-- To create a report on the distributions in rating to understand the customers' overall sentiments
SELECT
    rating,
    COUNT(*) AS frequency
FROM
    molten-thought-441320-u6.Example.netpromoterscoresupdated
GROUP BY
    rating
ORDER BY
    rating ASC