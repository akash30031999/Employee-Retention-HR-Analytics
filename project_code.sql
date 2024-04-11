use project;
select * from hr_1;
select * from hr_2;

-- KPI 1. Average Attrition rate for all Departments

SELECT
      Department,
      round((sum(CASE Attrition WHEN "yes" THEN 1 ELSE 0 END )/COUNT(*)) * 100,2) AS Avg_Attrition_Rate
FROM hr_1
GROUP BY Department
ORDER BY Department ;

-- KPI 2. Average Hourly rate of Male Research Scientist

SELECT 
      Gender,
      JobRole, 
      AVG(HourlyRate) AS Avg_hourly_rate 
FROM hr_1 
where gender='male'and jobrole="research scientist";

-- KPI 3. Attrition rate Vs Monthly income stats

SELECT 
      floor( monthlyincome/10000 )*10000 AS income_bin ,
	  sum( CASE attrition WHEN 'yes' THEN 1 ELSE 0 END ) /count(*)*100 AS Atr_rate 
FROM  hr_1
INNER JOIN hr_2 ON hr_1.EmployeeNumber = hr_2.`Employee ID`
GROUP BY income_bin
ORDER BY income_bin ;

-- KPI 4. Average working years for each Department

SELECT
	  hr_1.Department ,
      AVG(hr_2.YearsAtCompany) AS Avg_working_years
FROM  hr_1
INNER JOIN hr_2
ON hr_1.EmployeeNumber = hr_2.`Employee ID`
GROUP BY hr_1.Department;

-- KPI 5. Job Role Vs Work life balance

SELECT 
    JobRole,
    COUNT(*) AS TotalEmployees,
    SUM(CASE 
            WHEN WorkLifeBalance = 1 THEN 1
            ELSE 0
        END) AS Bad_WorkLifeBalance_Count,
    SUM(CASE 
            WHEN WorkLifeBalance = 2 THEN 1
            ELSE 0
        END) AS Poor_WorkLifeBalance_Count,
    SUM(CASE 
            WHEN WorkLifeBalance = 3 THEN 1
            ELSE 0
        END) AS Good_WorkLifeBalance_Count,
    SUM(CASE 
            WHEN WorkLifeBalance = 4 THEN 1
            ELSE 0
        END) AS Excellent_WorkLifeBalance_Count
FROM hr_1
INNER JOIN hr_2 ON hr_1.EmployeeNumber = hr_2.`Employee ID`
GROUP BY JobRole
ORDER BY JobRole;

-- KPI 6. Attrition rate Vs Year since last promotion relation

SELECT 
    YearsSinceLastPromotion,
    SUM(CASE 
            WHEN attrition = 'yes' THEN 1 
            ELSE 0 
        END) / COUNT(*) * 100 AS atr_rate 
FROM 
    hr_1
JOIN 
    hr_2 ON hr_1.EmployeeNumber = hr_2.`Employee ID`
GROUP BY 
    YearsSinceLastPromotion
ORDER BY 
    YearsSinceLastPromotion;


SELECT 
    CASE 
        WHEN YearsSinceLastPromotion BETWEEN 0 AND 10 THEN '0-10'
        WHEN YearsSinceLastPromotion BETWEEN 11 AND 20 THEN '11-20'
        WHEN YearsSinceLastPromotion BETWEEN 21 AND 30 THEN '21-30'
        WHEN YearsSinceLastPromotion BETWEEN 31 AND 40 THEN '31-40'
        ELSE 'More than 40'
    END AS PromotionInterval,
    SUM(CASE 
            WHEN Attrition = 'Yes' THEN 1
            ELSE 0
        END) AS AttritionCount,
    COUNT(*) AS TotalEmployees,
    ROUND(SUM(CASE 
                WHEN Attrition = 'Yes' THEN 1
                ELSE 0
            END) / COUNT(*) * 100, 2) AS AttritionRate
FROM 
    hr_1 join hr_2 on  hr_1.EmployeeNumber= hr_2.`Employee ID`
GROUP BY 
    PromotionInterval
ORDER BY 
    PromotionInterval;
