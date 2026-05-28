-- UPDATE OPERATION 1(Correct invalid enrollment status in students table)
-- Before update
SELECT
    student_id,
    full_name,
    enrollment_status
FROM students
WHERE student_id = 'S0089';
-- UPDATE
UPDATE students
SET enrollment_status = 'active'
WHERE student_id = 'S0089'
AND enrollment_status = 'actve';
-- After update
SELECT
    student_id,
    full_name,
    enrollment_status
FROM students
WHERE student_id = 'S0089';

-- the where clause only targests the particular student which has invaild status
----------------------------------------------------------------------------------

-- UPDATE OPERATION 2 (Correct invalid problem difficulty)
-- Before UPDATE
SELECT
    problem_id,
    title,
    difficulty
FROM problems
WHERE problem_id = 'P0010';
-- UPDATE
UPDATE problems
SET difficulty = 'Hard'
WHERE problem_id = 'P0010'
AND difficulty = 'Very Hard';
-- After UPDATE
SELECT
    problem_id,
    title,
    difficulty
FROM problems
WHERE problem_id = 'P0010';

-- The query updates only problem P0010 and only if the invalid difficulty value exists.
----------------------------------------------------------------------------------------

-- UPDATE OPERATION 3(Correct invalid submission status)
-- Before UPDATE
SELECT
    submission_id,
    status
FROM submissions
WHERE submission_id = 'SUB000208';

-- UPDATE
UPDATE submissions
SET status = 'Accepted'
WHERE submission_id = 'SUB000208'
AND status = 'OK';

-- After UPDATE
SELECT
    submission_id,
    status
FROM submissions
WHERE submission_id = 'SUB000208';

-- The update affects only one specific submission and avoids changing any already valid status values.
--------------------------------------------------------------------------------------------------------

-- UPDATE OPERATION 4(Correct invalid attendance status)
-- Before UPDATE
SELECT
    attendance_id,
    attendance_status
FROM attendance
WHERE attendance_id = 'A000046';
-- UPDATE
UPDATE attendance
SET attendance_status = 'Present'
WHERE attendance_id = 'A000046'
AND attendance_status = 'joined';
-- After UPDATE
SELECT
    attendance_id,
    attendance_status
FROM attendance
WHERE attendance_id = 'A000046';

-- The WHERE clause updates only the incorrect value for a single attendance record.
-------------------------------------------------------------------------------------

-- UPDATE OPERATION 5(Correct invalid enrollment status in enrollments table)
-- BEFORE UPDATE
SELECT
    enrollment_id,
    enrollment_status
FROM enrollments
WHERE enrollment_id = 'E00042';
-- UPDATE QUERY
UPDATE enrollments
SET enrollment_status = 'active'
WHERE enrollment_id = 'E00042'
AND enrollment_status = 'ongoing';
-- AFTER UPDATE
SELECT
    enrollment_id,
    enrollment_status
FROM enrollments
WHERE enrollment_id = 'E00042';

--  The update is limited to one enrollment record and only modifies the invalid status value.