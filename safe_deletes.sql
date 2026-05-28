-- DELETE OPERATION 1
-- Delete duplicate enrollment record
-- query to identify the duplicate record.
SELECT
    rowid,
    student_id,
    course_id
FROM enrollments
WHERE student_id = 'S0001'
AND course_id = 'C006';
-- DELETE QUERY
DELETE FROM enrollments
WHERE rowid = 15;
-- AFTER the DELETE
SELECT
    student_id,
    course_id,
    COUNT(*) AS total_records
FROM enrollments
WHERE student_id = 'S0001'
AND course_id = 'C006';
--The DELETE operation removes only one duplicate row using the unique rowid. 
--This prevents accidental deletion of all enrollment records for the student.

-- DELETE OPERATION 2
-- query to identify the duplicate submissions.
SELECT
    rowid,
    submission_id,
    student_id,
    problem_id
FROM submissions
WHERE submission_id = 'SUB000208';
-- DELETE QUERY
DELETE FROM submissions
WHERE rowid = 45;
-- AFTER the DELETE
SELECT
    submission_id,
    COUNT(*) AS total_records
FROM submissions
WHERE submission_id = 'SUB000208';

-- The DELETE operation removes only one duplicate row using the unique rowid.
-- This prevents accidental deletion of all submission records with the same submission_id.
