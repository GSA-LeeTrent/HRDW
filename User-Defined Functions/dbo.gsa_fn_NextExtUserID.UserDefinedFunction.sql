USE [HRDW]
GO
/****** Object:  UserDefinedFunction [dbo].[gsa_fn_NextExtUserID]    Script Date: 5/1/2018 1:42:03 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-09-20  
-- Description: Function Created
-- =============================================================================
CREATE FUNCTION [dbo].[gsa_fn_NextExtUserID](
	 @Agency	varchar(20)
) RETURNS INT
AS

BEGIN
DECLARE @NextUserID INTEGER = (SELECT ISNULL(MAX(NextUserID),0) + 1 FROM LMS.AGENCY WHERE AgencyName = @Agency)

RETURN @NextUserID
END





GO
