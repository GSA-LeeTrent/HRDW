USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[gsa_fn_ComputeOptionalRetirement_for_Ex_EMPLOYEESs Only]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--This is used to test prior retirements for EX-Employee Permanent
--Created by Ralph Silvestro 4-26-2017

CREATE FUNCTION [dbo].[gsa_fn_ComputeOptionalRetirement_for_Ex_EMPLOYEESs Only] 
(
	 @PersonID					int
) RETURNS DATE
AS

BEGIN
	DECLARE
		@COR					DATE
		;

SELECT 
@COR =
CASE 
  WHEN posI.PositionSeries = '1811' 
  -- =============================== 1811 =============================================
  THEN --'1811'
	(
	SELECT MIN(Date) 
	FROM (VALUES

		-- 1811MaxOfAge50AndSCDplus20 - Select MAX of Age 50 and SCD_Retirement + 20 
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (DATEADD(YEAR,55,p.BirthDate))
				 ,(DATEADD(YEAR,30, posD.Retirement_SCD))) AS D(Date)
		)) --AS [1811MaxOfAge50AndSCDplus20]
		,
		(DATEADD(YEAR,20, posD.Retirement_SCD))
	) AS D(Date)
	)
  WHEN p.RetirementPlanCode IN ('1','6','C','E') 
  THEN --'CSRS'
  -- =============================== CSRS =============================================
	(
	SELECT MIN(Date) 
	FROM (VALUES

		-- CSRSMaxOfAge62AndSCDplus5 - Select MAX of Age 62 and SCD_Retirement + 5 
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (DATEADD(YEAR,62,p.BirthDate))
				 ,(DATEADD(YEAR,5, posD.Retirement_SCD))) AS D(Date)
		)) --AS CSRSMaxOfAge62AndSCDplus5
		-- CSRSMaxOfAge60AndSCDplus20 - Select MAX of Age 60 and SCD_Retirement + 20
		, 
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (DATEADD(YEAR,60,p.BirthDate))
				 ,(DATEADD(YEAR,20, posD.Retirement_SCD))) AS D(Date)
		)) --AS CSRSMaxOfAge60AndSCDplus20
		-- CSRSMaxOfAge55AndSCDplus30 - Select MAX of Age 55 and SCD_Retirement + 30
		, 
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (DATEADD(YEAR,55,p.BirthDate))
				 ,(DATEADD(YEAR,30, posD.Retirement_SCD))) AS D(Date)
		)) --AS CSRSMaxOfAge55AndSCDplus30
	) AS D(Date)
	)

  WHEN p.RetirementPlanCode IN ('K','KF','KR','L','M','MF','N') 
  THEN --'FERS'
  -- =============================== FERS =============================================
	(
	SELECT MIN(Date) 
	FROM (VALUES
		-- FERSMaxOfAge62AndSCDplus5 - Select MAX of Age 62 and SCD_Retirement + 5 
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (DATEADD(YEAR,62,p.BirthDate))
				 ,(DATEADD(YEAR,5, posD.Retirement_SCD))) AS D(Date)
		)) --AS FERSMaxOfAge62AndSCDplus5
		-- FERSMaxOfAge60AndSCDplus20 - Select MAX of Age 60 and SCD_Retirement + 20
		, 
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (DATEADD(YEAR,60,p.BirthDate))
				 ,(DATEADD(YEAR,20, posD.Retirement_SCD))) AS D(Date)
		)) --AS FERSMaxOfAge60AndSCDplus20
		-- FERSMaxOfMRAAndSCDplus30 - Select MAX of Age 55 and SCD_Retirement + 30
		,
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (dbo.gsa_fn_ComputeMinimumRetirementAge(p.PersonID))
				 ,(DATEADD(YEAR,10, posD.Retirement_SCD))) AS D(Date)
		)) --AS FERSMaxOfMRAAndSCDplus10
		-- FERSMaxOfMRAAndSCDplus10 - Select MAX of Age 55 and SCD_Retirement + 30
		,
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (dbo.gsa_fn_ComputeMinimumRetirementAge(p.PersonID))
				 ,(DATEADD(YEAR,10, posD.Retirement_SCD))) AS D(Date)
		)) --AS FERSMaxOfMRAAndSCDplus30
	) AS D(Date)
	)
  WHEN p.RetirementPlanCode IN ('2','4','5') -- 2=FICA, 4=Other, 5=None 
  THEN NULL
  ELSE NULL  -- FICA, Other, or None 
END

FROM dbo.Person p
	 INNER JOIN 
	 dbo.Position pos		ON	pos.PersonID = p.PersonID
								AND 
								pos.RecordDate =
								(
								SELECT MAX(posx.RecordDate) 
								FROM dbo.Position posx
								WHERE posx.PersonID = p.PersonID
								)
	INNER JOIN 
	dbo.PositionInfo posI	ON posI.PositionInfoId = pos.ChrisPositionId
							   AND
							   posI.PositionEncumberedType IN (
															   'EX-Employee Permanent'
															  
															  )
	INNER JOIN 
	dbo.PositionDate posD	ON posD.PositionDateId = pos.PositionDateId
							   AND
							   posD.Retirement_SCD IS NOT NULL
WHERE
p.PersonID = @PersonID 

RETURN @COR

END 






GO
