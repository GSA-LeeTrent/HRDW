USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[gsa_fn_CalculateYearsOfService]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-06-24  
-- Description: Function Created
-- =============================================================================
CREATE FUNCTION [dbo].[gsa_fn_CalculateYearsOfService](
	 @EoD	datetime
	,@AsOf	datetime
) RETURNS Numeric(5,2)
AS

BEGIN
DECLARE @YoS Numeric(5,2) 
--SET @YoS = DATEDIFF(year, @EoD, @AsOf) -
--			CASE WHEN DATEPART(dayofyear, @EoD) > DATEPART(dayofyear, @AsOf) THEN 1 ELSE 0 END
SET @YoS = DATEDIFF(DD, @EoD, @AsOf) / 365.242199
RETURN @YoS
END


GO
