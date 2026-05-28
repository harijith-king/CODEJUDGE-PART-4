
-- ============================================================
-- SCENARIO 1 — Student submits a solution and test results are recorded together
--
-- Expected final state:
--   submissions  → SUB990001 exists with status Accepted
--   test_results → RES990001 and RES990002 linked to SUB990001
-- ============================================================

BEGIN TRANSACTION;

-- inserting the student's submission record
INSERT INTO submissions (
    submission_id, student_id, problem_id, contest_id,
    language, submitted_at, status, score, runtime_ms
)
VALUES (
    'SUB990001', 'S0010', 'P0003', NULL,
    'Python', '2025-08-20 10:30:00', 'Accepted', 70, 145
);

-- inserting the first test case result for that submission
INSERT INTO test_results (
    result_id, submission_id, test_case_id,
    result_status, runtime_ms, memory_kb, awarded_points
)
VALUES (
    'RES990001', 'SUB990001', 'TC00301',
    'Pass', 145, 512, 35
);

-- inserting the second test case result
INSERT INTO test_results (
    result_id, submission_id, test_case_id,
    result_status, runtime_ms, memory_kb, awarded_points
)
VALUES (
    'RES990002', 'SUB990001', 'TC00302',
    'Pass', 140, 512, 35
);

-- all three inserts completed without issues
COMMIT;

-- verifying the submission was saved
SELECT submission_id, student_id, problem_id, status, score
FROM submissions
WHERE submission_id = 'SUB990001';

-- verifying the test results are linked correctly
SELECT result_id, submission_id, test_case_id, result_status, awarded_points
FROM test_results
WHERE submission_id = 'SUB990001';


-- ============================================================
-- SCENARIO 2 — Enrollment rolled back because the course does not exist
-- Expected final state:
--   enrollments → E99901 does NOT exist
--   database is unchanged from before this transaction
-- ============================================================

BEGIN TRANSACTION;
-- attempting to enroll the student into a non-existent course
INSERT INTO enrollments (
    enrollment_id, student_id, course_id,
    enrolled_on, enrollment_status, final_grade
)
VALUES (
    'E99901', 'S0025', 'C999',
    '2025-08-20', 'Enrolled', NULL
);

-- C999 does not exist in the courses table
-- this would leave a broken reference in the database
-- rolling back the entire transaction
ROLLBACK;
-- confirming nothing was inserted
SELECT COUNT(*) AS should_be_zero
FROM enrollments
WHERE enrollment_id = 'E99901';


-- ============================================================
-- SCENARIO 3 — Regrade request approved and submission score
--              updated safely using SAVEPOINT
--
-- Two regrade requests are being processed in one session.
-- RG0031 is confirmed approved → update status and fix score
-- RG0032 is attempted but the new score seems wrong → undo only that
--
-- SAVEPOINT lets us roll back just the second update
-- while keeping the first one intact.
--
-- Expected final state:
--   regrade_requests → RG0031 status = Approved
--   submissions      → SUB000410 score updated to 85
--   regrade_requests → RG0032 unchanged (rolled back to savepoint)
--   submissions      → SUB000512 score unchanged (rolled back)
-- ============================================================

BEGIN TRANSACTION;
-- procesing RG0031 — instructor confirmed this should be approved
SAVEPOINT process_rg0031;
UPDATE regrade_requests
SET request_status = 'Approved'
WHERE request_id = 'RG0031'
  AND request_status = 'Pending';
UPDATE submissions
SET score = 85
WHERE submission_id = 'SUB000410';
SELECT request_id, request_status
FROM regrade_requests
WHERE request_id = 'RG0031';

SELECT submission_id, score
FROM submissions
WHERE submission_id = 'SUB000410';
SAVEPOINT process_rg0032;

UPDATE regrade_requests
SET request_status = 'Approved'
WHERE request_id = 'RG0032'
  AND request_status = 'Pending';

-- updating the score for the submission linked to RG0032
UPDATE submissions
SET score = 95
WHERE submission_id = 'SUB000512';

-- on checking, SUB000512 max score is 80 so 95 is not valid
-- rolling back only the second savepoint
-- RG0031 and SUB000410 changes are still intact
SELECT submission_id, score
FROM submissions
WHERE submission_id = 'SUB000512';

ROLLBACK TO SAVEPOINT process_rg0032;

-- RG0031 is still approved, RG0032 is back to Pending
-- committing only what is correct
COMMIT;

-- final verification
SELECT request_id, request_status
FROM regrade_requests
WHERE request_id IN ('RG0031', 'RG0032');

SELECT submission_id, score
FROM submissions
WHERE submission_id IN ('SUB000410', 'SUB000512');
