USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[gsa_fn_get_SCD_RIFAdjYears]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
;

CREATE FUNCTION [dbo].[gsa_fn_get_SCD_RIFAdjYears] (@persID INT)
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-05-15  
-- Description: Function to calculate the # of years to adjust an employees SCD.
--              The average of the last 3 performance ratings (or the average of 
--              the most recent ratings if less than 3) using the following 
--              formula for each performance rating:
--				* Performance Rating = 5 ==> 20 years
--				* Performance Rating = 4 ==> 16 years
--				* Performance Rating = 3 ==> 12 years
--				* Performance Rating = 2 ==> 0 years
--				* Performance Rating = 1 ==> 0 years
--              
--              If an employee has no Performance Rating, their SCD is adjusted
--              by 12 years.
-- =============================================================================
RETURNS INT
AS
BEGIN
  DECLARE
   @SCDAdjYears			INT
  ,@HoldSCDAdj			DECIMAL(5,2)
  ,@PerfFY				INT
  ,@NumRatings			INT
  ,@ModalRatingYears	INT
  ,@Rating_5_AdjYears	INT
  ,@Rating_4_AdjYears	INT
  ,@Rating_3_AdjYears	INT
  ,@Rating_2_AdjYears	INT
  ,@Rating_1_AdjYears	INT
  ,@AvgSCDAdj			DECIMAL(5,2)
  ;

  SET @SCDAdjYears			= 0;
  SET @HoldSCDAdj			= 0;
  SET @PerfFY				= 0;
  SET @NumRatings			= 3;
  SET @AvgSCDAdj			= 0;
  SET @ModalRatingYears		= 12;
  SET @Rating_5_AdjYears	= 20;
  SET @Rating_4_AdjYears	= 16;
  SET @Rating_3_AdjYears	= 12;
  SET @Rating_2_AdjYears	= 0;
  SET @Rating_1_AdjYears	= 0;


-- =============================================================================
-- Get The MAX FY of Completed Annual Reviews for an employee
-- =============================================================================
  SELECT 
	@PerfFY = CAST(MAX(RIGHT(FiscalYearRating,4)) AS INT)
  FROM 
	PerformanceRating
  WHERE
	[AppraisalTypeDescription] ='Annual'
	AND 
	[AppraisalStatus] ='Completed'
	AND
	PersonID = @persID
  ;

-- =============================================================================
-- Get Number of Completed Annual Reviews. This is used to determine what 
-- denominator to use in the Average calculation. 
-- =============================================================================
  SELECT 
	@NumRatings = COUNT(*)
  FROM
  (
  -- Get most recent (@PerfFY) completed annual performance review for count
  SELECT 
  *	
  FROM 
	PerformanceRating
  WHERE
	[AppraisalTypeDescription] ='Annual'
	AND 
	[AppraisalStatus] ='Completed'
	AND
	PersonID = @persID
	AND FiscalYearRating IN ('FY'+CAST((@PerfFY) AS CHAR(4)))
	AND RunDate =
		(
		SELECT MAX(RunDate)
		FROM PerformanceRating p2
		WHERE
		p2.[AppraisalTypeDescription] ='Annual'
		AND 
		p2.[AppraisalStatus] ='Completed'
		AND
		p2.PersonID = @persID
		AND 
		p2.FiscalYearRating IN ('FY'+CAST((@PerfFY) AS CHAR(4)))
		)
  UNION
  -- Get NEXT most recent (@PerfFY - 1) completed annual performance review for count
  SELECT 
  *	
  FROM 
	PerformanceRating
  WHERE
	[AppraisalTypeDescription] ='Annual'
	AND 
	[AppraisalStatus] ='Completed'
	AND
	PersonID = @persID
	AND FiscalYearRating IN ('FY'+CAST((@PerfFY - 1) AS CHAR(4)))
	AND RunDate =
		(
		SELECT MAX(RunDate)
		FROM PerformanceRating p2
		WHERE
		p2.[AppraisalTypeDescription] ='Annual'
		AND 
		p2.[AppraisalStatus] ='Completed'
		AND
		p2.PersonID = @persID
		AND 
		p2.FiscalYearRating IN ('FY'+CAST((@PerfFY - 1) AS CHAR(4)))
		)
  UNION
  -- Get NEXT most recent (@PerfFY - 2) completed annual performance review for count
  SELECT 
  *	
  FROM 
	PerformanceRating
  WHERE
	[AppraisalTypeDescription] ='Annual'
	AND 
	[AppraisalStatus] ='Completed'
	AND
	PersonID = @persID
	AND FiscalYearRating IN ('FY'+CAST((@PerfFY - 2) AS CHAR(4)))
	AND RunDate =
		(
		SELECT MAX(RunDate)
		FROM PerformanceRating p2
		WHERE
		p2.[AppraisalTypeDescription] ='Annual'
		AND 
		p2.[AppraisalStatus] ='Completed'
		AND
		p2.PersonID = @persID
		AND 
		p2.FiscalYearRating IN ('FY'+CAST((@PerfFY - 2) AS CHAR(4)))
		)
  ) AS PerfRatings
;

  -- If no ratings for employee set @NumRatings = 1 as this will be used
  -- as denominator for average calculation (where numerator is 12 when
  -- no ratings found for an employee.
  IF @NumRatings = 0
	SET @NumRatings = 1
	SET @SCDAdjYears = @ModalRatingYears;

-- =============================================================================
-- Get 1st (most recent) Performance Rating data.
-- =============================================================================
  SELECT 
	 @SCDAdjYears =
	 CASE
	 WHEN perf.OverallRating = 5
	 THEN @Rating_5_AdjYears
	 WHEN perf.OverallRating = 4
	 THEN @Rating_4_AdjYears
	 WHEN perf.OverallRating = 3
	 THEN @Rating_3_AdjYears
	 WHEN perf.OverallRating = 2
	 THEN @Rating_2_AdjYears
	 WHEN perf.OverallRating = 1
	 THEN @Rating_1_AdjYears
	 END
  FROM
	 [dbo].[PerformanceRating] perf 
  WHERE
	[AppraisalTypeDescription] ='Annual'
	AND 
	[AppraisalStatus] ='Completed'
	AND
	perf.PersonID = @persID
	AND
	CAST(RIGHT(perf.FiscalYearRating,4) AS INT) = @PerfFY
  ;

  -- Add SDCADJYears from 1st rating to Hold field and re-initialize SCDADJYears
  SELECT @HoldSCDAdj = @HoldSCDAdj + @SCDAdjYears
  SELECT @SCDAdjYears = 0
  ;
  -- Decrement @PerfFY by 1 to get rating for previous FY
  SELECT @PerfFY = @PerfFY - 1
  ;

-- =============================================================================
-- Get 2nd (@PerfFY - 1) Performance Rating data.
-- =============================================================================
  SELECT 
	 @SCDAdjYears =
	 CASE
	 WHEN perf.OverallRating = 5
	 THEN @Rating_5_AdjYears
	 WHEN perf.OverallRating = 4
	 THEN @Rating_4_AdjYears
	 WHEN perf.OverallRating = 3
	 THEN @Rating_3_AdjYears
	 WHEN perf.OverallRating = 2
	 THEN @Rating_2_AdjYears
	 WHEN perf.OverallRating = 1
	 THEN @Rating_1_AdjYears
	 END
  FROM
	 [HRDW].[dbo].[PerformanceRating] perf 
  WHERE
	[AppraisalTypeDescription] ='Annual'
	AND 
	[AppraisalStatus] ='Completed'
	AND
	perf.PersonID = @persID
	AND
	CAST(RIGHT(perf.FiscalYearRating,4) AS INT) = @PerfFY
  ;

  -- Add SDCADJYears from 2nd rating to Hold field and re-initialize SCDADJYears
  SELECT @HoldSCDAdj = @HoldSCDAdj + @SCDAdjYears
  SELECT @SCDAdjYears = 0
  ;
  -- Decrement @PerfFY by 1 to get rating for previous FY
  SELECT @PerfFY = @PerfFY - 1
  ;

-- =============================================================================
-- Get 3rd (@PerfFY - 2) Performance Rating data.
-- =============================================================================
  SELECT 
	 @SCDAdjYears =
	 CASE
	 WHEN perf.OverallRating = 5
	 THEN @Rating_5_AdjYears
	 WHEN perf.OverallRating = 4
	 THEN @Rating_4_AdjYears
	 WHEN perf.OverallRating = 3
	 THEN @Rating_3_AdjYears
	 WHEN perf.OverallRating = 2
	 THEN @Rating_2_AdjYears
	 WHEN perf.OverallRating = 1
	 THEN @Rating_1_AdjYears
	 END
  FROM
	 [HRDW].[dbo].[PerformanceRating] perf 
  WHERE
	[AppraisalTypeDescription] ='Annual'
	AND 
	[AppraisalStatus] ='Completed'
	AND
	perf.PersonID = @persID
	AND
	CAST(RIGHT(perf.FiscalYearRating,4) AS INT) = @PerfFY
  ;

  -- Add SDCADJYears from 3rd rating to Hold field
  SELECT @HoldSCDAdj = @HoldSCDAdj + @SCDAdjYears

  -- Get Average SCD Adjustment Years
  SELECT @AvgSCDAdj =
	CASE
    -- 3 ratings found for employee
	WHEN @NumRatings = 3
	THEN @HoldSCDAdj / 3
    -- Only 2 ratings found for employee
	WHEN @NumRatings = 2
	THEN @HoldSCDAdj / 2
    -- Only 1 ratings found for employee
	-- Note that @NumRatings is also set to 1 when no ratings are found
	WHEN @NumRatings = 1
	THEN @HoldSCDAdj / 1
  END

  -- Add 0.49 to @AvgSCDAdj and Round to next higher integer
  SELECT @SCDAdjYears = ROUND((@AvgSCDAdj + 0.49),0,0)
  ;

  RETURN @SCDAdjYears;
  END;


GO
