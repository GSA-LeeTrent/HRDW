USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[gsa_fn_ComputeEarlyRetirement]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      Ralph Silvestro
-- Date:        2017-04-20  
-- Description: Function Created
-- Must use Retirement SCD because it has all civilian + prior military.  
-- Retirement SCD flows on EHRI
-- Created index on aaPMU table to speed performance-Specifically [Record Date]
-- CER -This occurs when Your agency must be undergoing a major reorganization,
-- reduction-in-force (RIF), or transfer of function determined by the Office 
-- of Personnel Management.
-- CER needed as a function when CHRISBI goes away and replaced by People-Soft 
-- HR System.
-- =============================================================================
CREATE FUNCTION [dbo].[gsa_fn_ComputeEarlyRetirement] (
	 @Retirement_SCD	DATE
	,@SCD_Civilian		DATE	
	,@BirthDate			DATE

) RETURNS DATE
AS

BEGIN
	DECLARE
		@CER		DATE
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
-- If @RetSCD is NULL then return @CER as NULL; otherwise, use @RetSCD to 
-- compute @CER.
-- =============================================================================
SELECT 
@CER =
CASE
  WHEN 
	@RetSCD = NULL
  THEN
    NULL
  WHEN DATEADD(YEAR,25, @RetSCD) < 
	(
	(
	SELECT MAX(Date) 
	FROM 
	  (
	  VALUES 
		  (DATEADD(YEAR,50, @BirthDate))
		 ,(DATEADD(YEAR,20, @RetSCD))
	  ) AS D(Date)
	  )
	  )
  THEN DATEADD(YEAR,25, @RetSCD)  
  ELSE (
	   (
	   SELECT MAX(Date) 
	   FROM (
		  VALUES 
			  (DATEADD(YEAR,50, @BirthDate))
			 ,(DATEADD(YEAR,20, @RetSCD))
		  ) AS D(Date)
	   )
	   )
  END

RETURN @CER

END 




GO
