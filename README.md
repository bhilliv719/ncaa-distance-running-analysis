# NCAA Distance Running Performance Trends Analysis (2016–2025)

## Overview
This project analyzes the top 100 NCAA Division I performances in the Men's and Women's 800m and 1500m from 2016 to 2025. The goal was to identify long-term performance trends and investigate what factors are driving times faster across collegiate distance running.

**Key Finding:** Average top-100 times improved by roughly 10–15% across all four events over the decade, with the most notable acceleration occurring after 2019 — coinciding with the widespread adoption of carbon-plated racing shoes and the expansion of digital coaching resources.

---

## Tools Used
- **SQL** — Data querying, filtering, aggregation, and year-over-year comparisons
- **Excel** — Data cleaning, pivot tables, and statistical summaries
- **Tableau** — Trend visualizations and dashboards

---

## Dataset
- **Source:** NCAA Division I outdoor track & field performance lists
- **Events:** Men's 1500m, Women's 1500m, Men's 800m, Women's 800m
- **Years:** 2016–2025 (2020 excluded — season cancelled due to COVID-19)
- **Scope:** Top 100 performances per event per year
- **Fields:** Place, Athlete, Grade, Team, Time, Meet, Meet Date, Time (seconds), Year, Event

---

## SQL Queries

### Average top-100 time per event per year
```sql
SELECT 
    Year,
    Event,
    ROUND(AVG(Time_sec), 2) AS avg_time_seconds,
    ROUND(MIN(Time_sec), 2) AS fastest_time,
    ROUND(MAX(Time_sec), 2) AS slowest_top_100
FROM ncaa_performances
GROUP BY Year, Event
ORDER BY Event, Year;
```

### Year-over-year improvement by event
```sql
SELECT 
    a.Event,
    a.Year,
    ROUND(AVG(a.Time_sec), 2) AS avg_time,
    ROUND(AVG(a.Time_sec) - LAG(ROUND(AVG(a.Time_sec), 2)) 
        OVER (PARTITION BY a.Event ORDER BY a.Year), 2) AS change_from_prev_year
FROM ncaa_performances a
GROUP BY a.Event, a.Year
ORDER BY a.Event, a.Year;
```

### Top 10 fastest performances across all years (Men's 1500m)
```sql
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
```

### Count of sub-3:40 men's 1500m performances per year
```sql
SELECT 
    Year,
    COUNT(*) AS sub_3_40_count
FROM ncaa_performances
WHERE Event = '1500m' 
    AND Gender = 'M' 
    AND Time_sec < 220
GROUP BY Year
ORDER BY Year;
```

### Compare first half (2016–2020) vs second half (2021–2025) average times
```sql
SELECT 
    Event,
    CASE 
        WHEN Year <= 2020 THEN '2016-2020'
        ELSE '2021-2025'
    END AS period,
    ROUND(AVG(Time_sec), 2) AS avg_time_seconds
FROM ncaa_performances
WHERE Year != 2020
GROUP BY Event, period
ORDER BY Event, period;
```

---

## Key Findings

| Event | 2016 Avg Top-100 | 2025 Avg Top-100 | Improvement |
|---|---|---|---|
| Men's 1500m | 3:43.00 | 3:38.63 | ~4.4 seconds |
| Women's 1500m | 4:19.31 | 4:12.29 | ~7.0 seconds |
| Men's 800m | 1:48.19 | 1:47.15 | ~1.0 second |
| Women's 800m | 2:06.37 | 2:03.71 | ~2.7 seconds |

- The sharpest performance jumps occurred **post-2019**, aligning with the mainstream adoption of carbon-plated racing shoes
- **Women's events showed larger absolute improvements**, suggesting greater room for advancement as training resources and scholarship opportunities expanded
- The availability of **online coaching platforms, video analysis tools, and training data** has likely contributed to more consistent and optimized athlete development across all programs

---

## Files
- `NCAA_top_100_2016-2025.xlsx` — Full dataset with raw data sheets and pivot table summaries
- `queries.sql` — All SQL queries used in the analysis

---

## Author
**William Hill**  
Sports Performance Data Analyst | NCAA DI Athlete  
[LinkedIn](https://www.linkedin.com/in/williamm-hill-iv) 
