-- Question 1 difficulty : hard
SELECT FLOOR(weight / 10) * 10 AS weight_group,
       COUNT(*) AS total_patients
       from patients
 group by weight_group
 order by weight_group desc
 
-- Question 2 difficulty : hard
select patient_id , weight , height , 
		case
        -- BMI is calculated as weight / (height / 100) ^ 2.
		WHEN weight / (POWER(height / 100.0, 2)) >= 30 THEN 1 else 0
        end as isObese
from patients

-- Question 3 difficulty : hard
select p.patient_id AS patient_id,
    p.first_name AS patient_first_name,
    p.last_name AS patient_last_name,
    d.specialty AS doctor_specialty
    
FROM
    patients p
JOIN
    admissions a ON p.patient_id = a.patient_id
JOIN
    doctors d ON a.attending_doctor_id = d.doctor_id
where a.diagnosis = "Epilepsy" and d.first_name = "Lisa" 

-- Question 4 difficulty : hard 
select distinct p.patient_id ,concat(p.patient_id,len(p.last_name),year(p.birth_date)) as temp_password
from patients P
join 
admissions a
ON
p.patient_id = a.patient_id

-- Question 5 difficulty : hard 
SELECT
    CASE 
        WHEN patient_id % 2 = 0 THEN 'Yes' 
        ELSE 'No' 
    END AS has_insurance,
    SUM(
        CASE 
            WHEN patient_id % 2 = 0 THEN 10 
            ELSE 50 
        END
    ) AS admission_total
FROM
    admissions 
GROUP BY
    has_insurance;
    
-- Question 6 difficulty : hard 
SELECT
    pn.province_name
FROM
    patients p
JOIN
    province_names pn ON pn.province_id = p.province_id
GROUP BY
    pn.province_name
HAVING
    COUNT(CASE WHEN p.gender = 'M' THEN 1 ELSE NULL END) > COUNT(CASE WHEN p.gender = 'F' THEN 1 ELSE NULL END);
    
-- Question 7 difficulty : hard 
SELECT *
FROM patients
WHERE
    first_name LIKE '__r%' AND
    gender = 'F' AND
    (MONTH(birth_date) = 2 OR MONTH(birth_date) = 5 OR MONTH(birth_date) = 12) AND
    weight BETWEEN 60 AND 80 AND
    patient_id % 2 <> 0 AND
    city = 'Kingston';

--  Question 8 difficulty : hard 
select
    --COUNT(CASE WHEN gender = 'M' THEN 1 ELSE NULL END) AS male_count,
    --COUNT(CASE WHEN gender = 'F' THEN 1 ELSE NULL END) AS female_count,
    --count(*) as total_count,
    CASE
        WHEN COUNT(CASE WHEN gender = 'F' THEN 1 ELSE NULL END) = 0 THEN NULL
        ELSE concat(round(
            COUNT(CASE WHEN gender = 'M' THEN 1 ELSE NULL END) * 100.0 /
            COUNT(*),2),"%")
    END AS percentage
FROM
    patients;
    
-- Question 9 difficulty : hard
-- First CTE: daily_admissions
WITH daily_admissions AS (
    -- Select the date of admission and count the number of admissions for each date
    SELECT
        admission_date,                   -- The date of admission
        COUNT(*) AS total_admissions      -- Total number of admissions on that date
    FROM
        admissions                        -- From the admissions table
    GROUP BY
        admission_date                    -- Group the results by admission_date to get daily counts
),

-- Second CTE: admissions_with_change
admissions_with_change AS (
    SELECT
        admission_date,                   -- The date of admission
        total_admissions,                 -- Total number of admissions on that date
        LAG(total_admissions, 1, 0) OVER (ORDER BY admission_date) AS previous_day_admissions,
        -- Compute the number of admissions from the previous day
        -- LAG function looks back 1 row (previous day) and uses 0 if there is no previous day

        CASE
            WHEN LAG(total_admissions, 1, NULL) OVER (ORDER BY admission_date) IS NULL
            THEN NULL
            -- If there is no previous day (i.e., it's the first date), set change to NULL
            ELSE total_admissions - LAG(total_admissions, 1, 0) OVER (ORDER BY admission_date)
            -- Otherwise, calculate the change in admissions compared to the previous day
        END AS change_from_previous_day
        -- Resulting column showing the change in admissions from the previous day
    FROM
        daily_admissions                   -- Use the results from the daily_admissions CTE
)
SELECT
    admission_date,                      
    total_admissions,                     
    change_from_previous_day              
FROM
    admissions_with_change                
ORDER BY
    admission_date;                      

-- Question 10 difficulty : hard
select province_name
from province_names
order by
case when province_name = "Ontario" THEN 0 
ELSE 1 
END





    
    



    
    
    
    
    




    



       