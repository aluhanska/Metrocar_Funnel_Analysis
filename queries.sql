-- 1. Users funnel segmented by platform and age group
SELECT
    funnel_step,
	funnel_name,
	platform,
	age_range,
	SUM(number_of_users) AS users
FROM funnel_analysis
GROUP BY funnel_step, funnel_name, platform, age_range
ORDER BY funnel_step;


-- 2. Users funnel — overall conversion calculations
SELECT
    funnel_step,
	funnel_name,	
	SUM(number_of_users) AS users
FROM funnel_analysis
GROUP BY funnel_step, funnel_name
ORDER BY funnel_step;


-- 3. Rides funnel segmented by platform and age group
SELECT
    funnel_step,
	funnel_name,
	platform,
	age_range,
	SUM(number_of_rides) AS rides
FROM funnel_analysis
WHERE number_of_rides != 0
GROUP BY funnel_step, funnel_name, platform, age_range
ORDER BY funnel_step;


-- 4. Rides funnel — overall conversion calculations
SELECT
    funnel_step,
	funnel_name,	
	SUM(number_of_rides) AS rides
FROM funnel_analysis
WHERE number_of_rides != 0
GROUP BY funnel_step, funnel_name
ORDER BY funnel_step;


-- 5. Average waiting time and demand patterns by day and hour
SELECT
    EXTRACT(DOW FROM request_ts) AS weekday_number, -- 0-6
    TO_CHAR(request_ts, 'Day') AS weekday_name,
    EXTRACT(HOUR FROM request_ts) AS hour_of_day, -- 0-23
    COUNT(*) AS rides,
    ROUND(AVG(EXTRACT(EPOCH FROM (accept_ts - request_ts))), 0) AS avg_waiting_time_sec
FROM ride_requests
WHERE accept_ts IS NOT NULL
GROUP BY 1, 2, 3
ORDER BY 1, 3;


-- 6. App downloads by platform
SELECT
    platform,
    COUNT(app_download_key) AS downloads
FROM app_downloads
GROUP BY platform
ORDER BY downloads DESC;


-- 7. Download data for Tableau visualization
SELECT
    funnel_step,
	funnel_name,
	platform,
	age_range,
	number_of_users AS users
FROM funnel_analysis
WHERE funnel_step = 1;


-- 8. Active users — rides per user by age group
SELECT
    funnel_step,
    funnel_name,
    platform,
    age_range,
    SUM(number_of_users) AS users,
	SUM(number_of_rides) AS rides,
	ROUND((SUM(number_of_rides)/SUM(number_of_users)), 2) AS rides_per_user
FROM funnel_analysis
WHERE funnel_step = '3'
GROUP BY funnel_step, funnel_name, platform, age_range
ORDER BY rides DESC;


-- 9. Completed rides segmented by age group
SELECT
    funnel_step,
    funnel_name,
    age_range,
	SUM(number_of_rides) AS rides
FROM funnel_analysis
WHERE funnel_step = '5'
GROUP BY funnel_step, funnel_name, age_range
ORDER BY funnel_step, rides DESC;

