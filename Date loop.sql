-- Robert Valladares 06/01/2018
-- Useful recursion date list creation with custom start and end date
/* Set the first day of the week to Monday, USA Standard */
/* If this is used a a Text String SQL, a dynamic start and end date can be set up based on needs */
SET DATEFIRST 1;

WITH DateRange
AS (
	/* SET THE START DATE AS JAN 01 (Year - 3) */
	SELECT DATEADD(YY, DATEDIFF(YY, 0, GETDATE()) - 3, 0) AS DDate -- anchor member
	
	UNION ALL
	
	SELECT DDate + 1 -- recursive member, increase date by one
	FROM DateRange
	/* SET THE END DATE AS JAN 01 (Year + 2) */
	WHERE DDate < DATEADD(YY, DATEDIFF(YY, 0, GETDATE()) + 2, 0) -- terminator
	)
	,DateSrc
AS (
	/* Calulate Week number and Year for each date value generated */
	SELECT CAST(DDate AS DATE) DDATE
		,DATEPART(wk, DDate) DWeekNum
		,DATEPART(YYYY, DDate) DYear
	FROM DateRange
	)
	,WeekSrc
AS (
	/* Calulate Week Start date and Week End Date for each week number, for each year */
	SELECT DWeekNum
		,DYear
		,CONVERT(DATE, MIN(DDATE)) WeekStartDate
		,CONVERT(DATE, Max(DDATE)) WeekEndDate
	FROM DateSrc
	GROUP BY DWeekNum
		,DYear
	)
/* Combine Results into a complete Data Set */
SELECT A.DDATE
	,A.DWeekNum
	,A.DYear
	,B.WeekStartDate
	,B.WeekEndDate
FROM DateSrc A
INNER JOIN WeekSrc B ON A.DWeekNum = B.DWeekNum
	AND A.DYear = B.DYear
OPTION (MAXRECURSION 0);/* 0 for unlimited, or set 365 * 5 years */


--SELECT  DATEADD(YY, DATEDIFF(YY, 0, GETDATE())-3, 0)
--SELECT  DATEADD(YY, DATEDIFF(YY, 0, GETDATE())+2, 0)


