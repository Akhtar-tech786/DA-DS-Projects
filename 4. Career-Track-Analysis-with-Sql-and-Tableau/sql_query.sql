Select * from career_track_info;

Select * from career_track_student_enrollments;

SELECT student_id,track_name,date_enrolled,date_completed,
ROW_NUMBER() OVER( ORDER BY student_id,track_name desc) AS student_track_id,
IF (date_completed is Null ,0,1) AS track_completed,
DATEDIFF(date_completed,date_enrolled) AS days_for_completion
FROM career_track_student_enrollments
JOIN  career_track_info
ON
career_track_info.track_id = career_track_student_enrollments.track_id
ORDER BY days_for_completion DESC;

SELECT student_id,track_name,date_enrolled,date_completed,
ROW_NUMBER() OVER( ORDER BY student_id,track_name desc) AS student_track_id,
IF (date_completed is Null ,0,1) AS track_completed,
DATEDIFF(date_completed,date_enrolled) AS days_for_completion,
    # Select all columns from the subquery,
    CASE
        WHEN days_for_completion = 0 THEN 'Same day'
        WHEN  days_for_completion>=1 and days_for_completion<=7 THEN '1 to 7 days'
        WHEN  days_for_completion>=8 and days_for_completion<=30 THEN '8 to 30 days'
        WHEN  days_for_completion>=31 and days_for_completion<=60 THEN '31 to 60 days'
	    WHEN  days_for_completion>=61 and days_for_completion<=90 THEN '61 to 90 days' 
		WHEN days_for_completion>=91 and days_for_completion<=365 THEN '91 to 365 days'
		WHEN days_for_completion> 366 THEN '366+ days'
        
    END AS completion_bucket
FROM
(
SELECT student_id,track_name,date_enrolled,date_completed,
ROW_NUMBER() OVER( ORDER BY student_id,track_name desc) AS student_track_id,
IF (date_completed is Null ,0,1) AS track_completed,
DATEDIFF(date_completed,date_enrolled) AS days_for_completion
FROM career_track_student_enrollments
JOIN  career_track_info
ON
career_track_info.track_id = career_track_student_enrollments.track_id
ORDER BY days_for_completion DESC) a;