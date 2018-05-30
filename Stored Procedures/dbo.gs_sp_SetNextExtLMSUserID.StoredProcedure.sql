USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[gs_sp_SetNextExtLMSUserID]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[gs_sp_SetNextExtLMSUserID] 
 @Agency NVARCHAR(20)
,@NextUserID INTEGER OUTPUT
AS
UPDATE [LMS].[AGENCY]
SET NextUserID = (SELECT [dbo].[gsa_fn_NextExtUserID](@Agency))
WHERE AgencyName = @Agency

SELECT @NextUserID = [dbo].[gsa_fn_NextExtUserID](@Agency)

RETURN



GO
