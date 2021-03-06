USE [HRDW]
GO
/****** Object:  View [Performance].[vAnnualPerformance]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [Performance].[vAnnualPerformance] AS
SELECT * FROM
(
SELECT DISTINCT 
 [PersonID]
,[AppraisalTypeDescription]
,[AppraisalStatus]
,[FiscalYearRating]
,(
	CASE 
	WHEN [High3Flag] = 'No'
	THEN FORMAT(CAST([OverallRating]       AS DECIMAL(2,1)), 'g15')--the g15 suppresses zeros.
	WHEN [High3Flag] = 'Yes' AND [OverallRating] = '3'
	--ORIGINAL WAS WHEN [High3Flag] = 'Yes' 
	THEN FORMAT(CAST([OverallRating] + 0.5 AS DECIMAL(2,1)), 'g15')--the g15 suppresses zeros.
	ELSE NULL 
	END
	) [Rating] 

FROM  dbo.PerformanceRating 
WHERE [AppraisalTypeDescription] ='Annual' and [AppraisalStatus] ='COMPLETED'

) src
PIVOT
(
MAX(Rating)
FOR FiscalYearRating IN (FY2005,FY2006,FY2007,FY2008,FY2009,FY2010,FY2011,FY2012,FY2013,FY2014,FY2015,FY2016,FY2017,FY2018)
) piv
--ORDER BY [PersonID] ASC








GO
