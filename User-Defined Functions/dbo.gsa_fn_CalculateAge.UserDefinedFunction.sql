USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[gsa_fn_CalculateAge]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-06-24  
-- Description: Function Created
-- =============================================================================
CREATE FUNCTION [dbo].[gsa_fn_CalculateAge](
	 @DoB	datetime
	,@AsOf	datetime
) RETURNS Numeric(5,2)
AS

BEGIN
DECLARE @Age Numeric(5,2) 
--SET @Age = DATEDIFF(year, @DoB, @AsOf) -
--			CASE WHEN DATEPART(dayofyear, @DoB) > DATEPART(dayofyear, @AsOf) THEN 1 ELSE 0 END
SET @Age = DATEDIFF(DD, @DoB, @AsOf) / 365.242199

RETURN @Age
END


GO
