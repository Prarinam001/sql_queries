-- https://www.sql-practice.com/
-- =============================================

select * from patients;

select * from province_names;

select first_name, last_name from patients where allergies IS NULL;

SELECT first_name from patients where first_name like 'C%';

select first_name, last_name from patients where weight between 100 and 120;

update patients set allergies='NKA' where allergies is NULL;

SELECT CONCAT(first_name, ' ', last_name) AS full_name FROM patients;

select p.first_name, p.last_name, pn.province_name
FROM patients as p
JOIN province_names as pn
on p.province_id = pn.province_id;

select count('*') as total_patients FRom patients where year(birth_date)=2010;

-- Show the first_name, last_name, and height of the patient with the greatest height.
select first_name, last_name, height from patients order by height desc limit 1; 
-- or
SELECT first_name, last_name, height
FROM patients
WHERE height = (
    SELECT max(height)
    FROM patients
);

-- Show all columns for patients who have one of the following patient_ids:
-- 1,45,534,879,1000
select * from patients where patient_id in (1, 45, 534, 879, 1000);

-- Show unique birth years from patients and order them by ascending.
select distinct year(birth_date) as birth_year from patients order by year(birth_date) ASC;

-- Show unique first names from the patients table which only occurs once in the list.

-- For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output.
select first_name from patients group by first_name having count(first_name)=1;

-- Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
SELECT
  patient_id,
  first_name
FROM patients
WHERE first_name LIKE 's____%s';

-- Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'.
-- Primary diagnosis is stored in the admissions table.
select p.patient_id, p.first_name, p.last_name
FROM patients as p
JOIN admissions as a
on p.patient_id = a.patient_id where a.diagnosis='Dementia';

-- Display every patient's first_name.
-- Order the list by the length of each name and then by alphabetically.
select first_name from patients order by len(first_name), first_name ASC;


-- Show the total amount of male patients and the total amount of female patients in the patients table.
-- Display the two results in the same row.
SELECT 
(SELECT count(*) FROM patients WHERE gender='M') AS male_count, 
(SELECT count(*) FROM patients WHERE gender='F') AS female_count;