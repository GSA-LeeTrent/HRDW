USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[gsa_fn_ComputeMinimumRetirementAge]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      Ralph Silvestro
-- Date:        2016-04-25  
-- Description: Get Date of Minimum Retirment Age for a Person
-- =============================================================================
CREATE FUNCTION [dbo].[gsa_fn_ComputeMinimumRetirementAge] 
(
	 @PersonID	int
) RETURNS DATE
AS

BEGIN
	DECLARE
		@MRADate		DATE
		;

SELECT 
  @MRADate =
  CASE 
	WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) < '1947' 
	THEN DATEADD(YEAR,55,p.BirthDate) 
    WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) ='1948' 
	THEN DATEADD(MONTH,2, p.BirthDate)
	WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) ='1949' 
	THEN DATEADD(MONTH,4, p.BirthDate)
	WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) ='1950' 
	THEN DATEADD(MONTH,6, p.BirthDate)
	WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) ='1951' 
	THEN DATEADD(MONTH,8, p.BirthDate)
	WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) ='1952' 
	THEN DATEADD(MONTH,10, p.BirthDate)
	WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) BETWEEN '1953' AND '1964' 
	THEN DATEADD(YEAR,56,p.BirthDate)
	WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) ='1965' 
	THEN DATEADD(MONTH,2,p.BirthDate)
	WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) ='1966' 
	THEN DATEADD(MONTH,4,p.BirthDate) 
	WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) ='1967' 
	THEN DATEADD(MONTH,6,p.BirthDate)   
	WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) ='1968' 
	THEN DATEADD(MONTH,8,p.BirthDate)
	WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) ='1969' 
	THEN DATEADD(MONTH,10,p.BirthDate)  
	WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') AND YEAR(p.BirthDate) >='1970' 
	THEN DATEADD(YEAR,57,p.BirthDate) 
	ELSE '' 
  END
FROM dbo.Person p
WHERE p.PersonID = @PersonID 

RETURN @MRADate

END 


GO
