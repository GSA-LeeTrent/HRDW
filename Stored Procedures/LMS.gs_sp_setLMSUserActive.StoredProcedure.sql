USE [HRDW]
GO
/****** Object:  StoredProcedure [LMS].[gs_sp_setLMSUserActive]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-05-18  
-- Description: Stored proc to all LMS team to reset a user to Active
-- =============================================================================
CREATE procedure [LMS].[gs_sp_setLMSUserActive] (
					  @UPN		NVARCHAR(255) = NULL
					, @Email	NVARCHAR(255) = NULL)
WITH EXECUTE AS OWNER		
AS

UPDATE [dbo].[ActiveDirectoryUsers]
SET 
 InactiveTimestamp = NULL
,LastUpdateTimestamp = GETDATE()
  WHERE EmailAddress = RTRIM(@Email)
		AND
		UserPrincipalName = (RTRIM(@UPN) + '@gsa.gov')



GO
