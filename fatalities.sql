--1. What is the number of reported incidents?
SELECT COUNT(*) 
FROM `fatalities_cleaned`;

--2. What is the year to year change for the number of fatal incidents?
SELECT
    t1.incident_year AS Year, t1.total_fatalities, LAG(t1.total_fatalities) OVER (ORDER BY t1.incident_year) AS previous_year,
    ROUND(100 *(t1.total_fatalities - t2.total_fatalities) / t2.total_fatalities) AS PercentageChange
FROM
    (
        SELECT
            YEAR(incident_date) AS incident_year,
            COUNT(*) AS total_fatalities
        FROM
            `fatalities_cleaned`
        WHERE
            incident_date <> 2022 
        GROUP BY
            incident_year
    ) t1
LEFT JOIN
    (
        SELECT
            YEAR(incident_date) AS incident_year,
            COUNT(*) AS total_fatalities
        FROM
            `fatalities_cleaned`
        WHERE
            incident_date <> 2022
            
        GROUP BY
            incident_year
    ) t2 ON t1.incident_year = t2.incident_year + 1
WHERE t1.incident_year IS NOT NULL
ORDER BY
    t1.incident_year;

--3. What is the number of fatalities that received a citation?
SELECT citation, COUNT(*)
FROM `fatalities_cleaned` 
GROUP BY citation;

--4. What day of the week has the most fatalities and what is the overall percentage?
WITH t1 AS ( 
    SELECT day_of_week AS day, COUNT(*) AS n_fatalities 
    FROM `fatalities_cleaned` 
    GROUP BY day_of_week), 
t2 AS ( 
    SELECT COUNT(*) as n_fatalities 
    FROM `fatalities_cleaned`) 
SELECT t1.day,t1.n_fatalities, ROUND((t1.n_fatalities/t2.n_fatalities)*100,2) AS total 
FROM t1, t2 
ORDER BY t1.n_fatalities DESC;

--5. What is the number of fatalities involving welding?
SELECT COUNT(description) AS welding_fatalities
FROM `fatalities_cleaned` 
WHERE description LIKE '%weld%';

--6. Select the last 5 from the previous query
SELECT id, incident_date, day_of_week, city,  state, description, plan, citation
FROM `fatalities_cleaned` 
WHERE description LIKE '%weld%' 
ORDER BY incident_date DESC 
LIMIT 5;

--7. Select the top 5 states with the most fatal incidents.
SELECT state, COUNT(*) AS incidents 
FROM `fatalities_cleaned` 
GROUP BY state 
ORDER BY incidents DESC 
LIMIT 5 ;

--8. What are the top 5 states that had the most workplace fatalities from stabbings?
SELECT state, COUNT(*) AS incidents 
FROM `fatalities_cleaned` 
WHERE description LIKE '%stabb%' 
GROUP BY state 
ORDER BY incidents DESC 
LIMIT 5;

--9. What are the top 10 states that had the most workplace fatalities from shootings?
SELECT state, COUNT(*) AS incidents
FROM `fatalities_cleaned`
WHERE description LIKE '%shot%'
GROUP BY state
ORDER BY incidents DESC 
LIMIT 10;

--10. What is the total number of shooting deaths per year?
SELECT EXTRACT(year FROM incident_date) AS year,COUNT(*) AS incidents
FROM `fatalities_cleaned`
WHERE description LIKE '%shot%'
GROUP BY year
ORDER BY year DESC;