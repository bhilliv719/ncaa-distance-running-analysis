-- NCAA Distance Running Performance Trends Analysis (2016-2025)
-- Author: William Hill
-- Description: SQL queries used to analyze top 100 NCAA D1 performances
--              in the Men's and Women's 800m and 1500m from 2016-2025

-- =============================================
-- 1. Average top-100 time per event per year
-- =============================================
SELECT 
    Year,
    Event,
    ROUND(AVG(Time_sec), 2) AS avg_time_seconds,
    ROUND(MIN(Time_sec), 2) AS fastest_time,
    ROUND(MAX(Time_sec), 2) AS slowest_top_100
FROM ncaa_performances
GROUP BY Year, Event
ORDER BY Event, Year;

-- =============================================
-- 2. Year-over-year improvement by event
-- =============================================
SELECT 
    a.Event,
    a.Year,
    ROUND(AVG(a.Time_sec), 2) AS avg_time,
    ROUND(AVG(a.Time_sec) - LAG(ROUND(AVG(a.Time_sec), 2)) 
        OVER (PARTITION BY a.Event ORDER BY a.Year), 2) AS change_from_prev_year
FROM ncaa_performances a
GROUP BY a.Event, a.Year
ORDER BY a.Event, a.Year;

-- =============================================
-- 3. Top 10 fastest Men's 1500m performances across all years
-- =============================================
SELECT 
    Place,
    Athlete,
    Team,
    Time,
    Year,
    Meet
FROM ncaa_performances
WHERE Event = '1500m' AND Gender = 'M'
ORDER BY Time_sec ASC
LIMIT 10;

-- =============================================
-- 4. Top 10 fastest Women's 1500m performances across all years
-- =============================================
SELECT 
    Place,
    Athlete,
    Team,
    Time,
    Year,
    Meet
FROM ncaa_performances
WHERE Event = '1500m' AND Gender = 'F'
ORDER BY Time_sec ASC
LIMIT 10;

-- =============================================
-- 5. Count of sub-3:40 Men's 1500m performances per year
--    (tracks how depth of fast performances has grown)
-- =============================================
SELECT 
    Year,
    COUNT(*) AS sub_3_40_count
FROM ncaa_performances
WHERE Event = '1500m' 
    AND Gender = 'M' 
    AND Time_sec < 220
GROUP BY Year
ORDER BY Year;

-- =============================================
-- 6. Count of sub-2:06 Women's 800m performances per year
-- =============================================
SELECT 
    Year,
    COUNT(*) AS sub_2_06_count
FROM ncaa_performances
WHERE Event = '800m' 
    AND Gender = 'F' 
    AND Time_sec < 126
GROUP BY Year
ORDER BY Year;

-- =============================================
-- 7. Compare pre-super shoe era (2016-2019) vs post (2021-2025)
--    average times by event
-- =============================================
SELECT 
    Event,
    CASE 
        WHEN Year <= 2019 THEN '2016-2019 (Pre Super Shoe)'
        ELSE '2021-2025 (Post Super Shoe)'
    END AS era,
    ROUND(AVG(Time_sec), 2) AS avg_time_seconds,
    COUNT(*) AS total_performances
FROM ncaa_performances
WHERE Year != 2020
GROUP BY Event, era
ORDER BY Event, era;

-- =============================================
-- 8. Schools producing the most top-100 performances (2016-2025)
-- =============================================
SELECT 
    Team,
    Event,
    COUNT(*) AS top_100_appearances
FROM ncaa_performances
GROUP BY Team, Event
ORDER BY top_100_appearances DESC
LIMIT 20;

-- =============================================
-- 9. Median time per event per year
--    (less sensitive to outliers than average)
-- =============================================
SELECT 
    Year,
    Event,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Time_sec) AS median_time_seconds
FROM ncaa_performances
GROUP BY Year, Event
ORDER BY Event, Year;

-- =============================================
-- 10. Best times by athlete class year (FR/SO/JR/SR)
--     to identify when athletes peak
-- =============================================
SELECT 
    Grade,
    Event,
    ROUND(AVG(Time_sec), 2) AS avg_time,
    ROUND(MIN(Time_sec), 2) AS best_time,
    COUNT(*) AS appearances
FROM ncaa_performances
GROUP BY Grade, Event
ORDER BY Event, avg_time ASC;
