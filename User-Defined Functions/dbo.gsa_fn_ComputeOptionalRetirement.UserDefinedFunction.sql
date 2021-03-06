USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[gsa_fn_ComputeOptionalRetirement]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      Ralph Silvestro
-- Date:        2017-04-15  
-- Description: Function Created
-- ----------------------------------------
--Initial Creation by Ralph Silvestro
--4-20-2017 Start COR (Compute Optional Retirement) Build
--
-- =============================================================================
CREATE FUNCTION [dbo].[gsa_fn_ComputeOptionalRetirement] 
(
	 @Retirement_SCD	DATE
	,@SCD_Civilian		DATE
	,@BirthDate			DATE
	,@PositionSeries	CHAR(4)
	,@RetirementPlan	CHAR(4)
) RETURNS DATE
AS

BEGIN
	DECLARE
		@COR		DATE
	   ,@RetSCD		DATE	
		;

-- =============================================================================
-- Set @RetSCD to be the minimum Non-NULL values of @Retirement_SCD
-- and @SCD_Civilian. @RetSCD will then be used in the calculation.
-- =============================================================================
SELECT 
@RetSCD =
CASE
  -- @Retirement_SCD and @SCD_Civilian are BOTH NULL, so return NULL
  WHEN
	  @Retirement_SCD IS NULL
	  AND
	  @SCD_Civilian IS NULL
  THEN
	  NULL
  -- @Retirement_SCD NOT NULL and @SCD_Civilian is NULL, so use @Retirement_SCD
  WHEN 
	  @Retirement_SCD IS NOT NULL
	  AND
	  @SCD_Civilian IS NULL
  THEN
	  @Retirement_SCD
  -- @Retirement_SCD IS NULL and @SCD_Civilian NOT NULL, so use @SCD_Civilian
  WHEN 
	  @Retirement_SCD IS NULL
	  AND
	  @SCD_Civilian IS NOT NULL
  THEN
	  @SCD_Civilian
  -- Both NOT NULL with @Retirement_SCD <= @SCD_Civilian, so use @Retirement_SCD
  WHEN 
	  @Retirement_SCD <= @SCD_Civilian
  THEN
	  @Retirement_SCD
  -- Both NOT NULL with @SCD_Civilian < @Retirement_SCD, so use @SCD_Civilian
  ELSE 
	  @SCD_Civilian
END

-- =============================================================================
-- If @RetSCD is NULL then -OR- @RetirementPlan is '2','4', or '5', then
-- return @COR as NULL; otherwise, use @RetSCD to compute @COR.
-- =============================================================================
SELECT 
@COR =
CASE 
  -- If the local variable @RetSCD has been set to NULL, the return @COR as NULL
  WHEN 
	  @RetSCD = NULL
  THEN
	  NULL
  -- @RetirementPlan is '2','4', or '5', the return @COR as NULL
  WHEN 
	  @RetirementPlan IN ('2','4','5','', NULL)
  THEN
	  NULL
  WHEN 
	  @PositionSeries = '1811' 
  -- =============================== 1811 =============================================
  --
  -- ==================================================================================
  THEN --'1811'
	(
	SELECT MIN(Date) 
	FROM (VALUES

		-- 1811MaxOfAge50AndSCDplus20 - Select MAX of Age 50 and SCD_Retirement + 20 
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (DATEADD(YEAR,50,@BirthDate))
				 ,(DATEADD(YEAR,20, @RetSCD))) AS D(Date)
		)) --AS [1811MaxOfAge50AndSCDplus20]
		,
		(DATEADD(YEAR,25, @RetSCD))
	) AS D(Date)
	)
  -- =============================== CSRS =============================================
  --
  -- ==================================================================================
  WHEN @RetirementPlan IN ('1','6','C','E') 
  THEN --'CSRS'
	(
	SELECT MIN(Date) 
	FROM (VALUES

		-- CSRSMaxOfAge62AndSCDplus5 - Select MAX of Age 62 and SCD_Retirement + 5 
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (DATEADD(YEAR,62,@BirthDate))
				 ,(DATEADD(YEAR,5, @RetSCD))) AS D(Date)
		)) --AS CSRSMaxOfAge62AndSCDplus5
		-- CSRSMaxOfAge60AndSCDplus20 - Select MAX of Age 60 and SCD_Retirement + 20
		, 
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (DATEADD(YEAR,60,@BirthDate))
				 ,(DATEADD(YEAR,20, @RetSCD))) AS D(Date)
		)) --AS CSRSMaxOfAge60AndSCDplus20
		-- CSRSMaxOfAge55AndSCDplus30 - Select MAX of Age 55 and SCD_Retirement + 30
		, 
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (DATEADD(YEAR,55,@BirthDate))
				 ,(DATEADD(YEAR,30, @RetSCD))) AS D(Date)
		)) --AS CSRSMaxOfAge55AndSCDplus30
	) AS D(Date)
	)
  -- =============================== FERS =============================================
  --
  -- ==================================================================================
  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
  THEN --'FERS'
	(
	SELECT MIN(Date) 
	FROM (VALUES
		-- FERSMaxOfAge62AndSCDplus5 - Select MAX of Age 62 and SCD_Retirement + 5 
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (DATEADD(YEAR,62,@BirthDate))
				 ,(DATEADD(YEAR,5, @RetSCD))) AS D(Date)
		)) --AS FERSMaxOfAge62AndSCDplus5
		-- FERSMaxOfAge60AndSCDplus20 - Select MAX of Age 60 and SCD_Retirement + 20
		, 
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  (DATEADD(YEAR,60,@BirthDate))
				 ,(DATEADD(YEAR,20, @RetSCD))) AS D(Date)
		)) --AS FERSMaxOfAge60AndSCDplus20
		-- FERSMaxOfMRAAndSCDplus30 - Select MAX of Age 55 and SCD_Retirement + 30
		,
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  --(dbo.gsa_fn_ComputeMinimumRetirementAge(p.PersonID))
				  (
				  CASE
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) < '1947' 
				  THEN DATEADD(YEAR,55,@BirthDate) 
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1948' 
				  THEN DATEADD(MONTH,2, @BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1949' 
				  THEN DATEADD(MONTH,4, @BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1950' 
				  THEN DATEADD(MONTH,6, @BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1951' 
				  THEN DATEADD(MONTH,8, @BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1952' 
				  THEN DATEADD(MONTH,10, @BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) BETWEEN '1953' AND '1964' 
				  THEN DATEADD(YEAR,56,@BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1965' 
				  THEN DATEADD(MONTH,2,@BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1966' 
				  THEN DATEADD(MONTH,4,@BirthDate) 
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1967' 
				  THEN DATEADD(MONTH,6,@BirthDate)   
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1968' 
				  THEN DATEADD(MONTH,8,@BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1969' 
				  THEN DATEADD(MONTH,10,@BirthDate)  
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) >='1970' 
				  THEN DATEADD(YEAR,57,@BirthDate) 
				  ELSE '' 
				  END
				  )
				 ,(DATEADD(YEAR,10, @RetSCD))) AS D(Date)
		)) --AS FERSMaxOfMRAAndSCDplus10
		-- FERSMaxOfMRAAndSCDplus10 - Select MAX of Age 55 and SCD_Retirement + 30
		,
		((
		SELECT MAX(Date) 
		FROM (VALUES
				  --(dbo.gsa_fn_ComputeMinimumRetirementAge(p.PersonID))
				  (
				  CASE
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) < '1947' 
				  THEN DATEADD(YEAR,55,@BirthDate) 
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1948' 
				  THEN DATEADD(MONTH,2, @BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1949' 
				  THEN DATEADD(MONTH,4, @BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1950' 
				  THEN DATEADD(MONTH,6, @BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1951' 
				  THEN DATEADD(MONTH,8, @BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1952' 
				  THEN DATEADD(MONTH,10, @BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) BETWEEN '1953' AND '1964' 
				  THEN DATEADD(YEAR,56,@BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1965' 
				  THEN DATEADD(MONTH,2,@BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1966' 
				  THEN DATEADD(MONTH,4,@BirthDate) 
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1967' 
				  THEN DATEADD(MONTH,6,@BirthDate)   
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1968' 
				  THEN DATEADD(MONTH,8,@BirthDate)
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) ='1969' 
				  THEN DATEADD(MONTH,10,@BirthDate)  
				  WHEN @RetirementPlan IN ('K','KF','KR','L','M','MF','N') 
				       AND YEAR(@BirthDate) >='1970' 
				  THEN DATEADD(YEAR,57,@BirthDate) 
				  ELSE '' 
				  END
				  )
				 ,(DATEADD(YEAR,10, @RetSCD))) AS D(Date)
		)) --AS FERSMaxOfMRAAndSCDplus30
	) AS D(Date)
	)
  WHEN @RetirementPlan IN ('2','4','5') -- 2=FICA, 4=Other, 5=None 
  THEN NULL
  ELSE NULL  -- FICA, Other, or None 
END


RETURN @COR

END 




GO
