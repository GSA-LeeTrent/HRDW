USE [HRDW]
GO
/****** Object:  View [LMS].[vLearningManagementExport]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [LMS].[vLearningManagementExport]
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-09-21  
-- Description: Created View
-- =============================================================================
AS
SELECT [STATUS]
      ,[USERID]
      ,[USERNAME]
      ,[FIRSTNAME]
      ,[LASTNAME]
      ,[MI]
      ,[GENDER]
      ,[EMAIL]
      ,[MANAGER]
      ,[HR]
      ,[DIVISION]
      ,[DEPARTMENT]
      ,[LOCATION]
      ,[JOBCODE]
      ,[TIMEZONE]
      ,[HIREDATE]
      ,[EMPID]
      ,[TITLE]
      ,[BIZ_PHONE]
      ,[FAX]
      ,[ADDR1]
      ,[ADDR2]
      ,[CITY]
      ,[STATE]
      ,[ZIP]
      ,[COUNTRY]
      ,[REVIEW_FREQ]
      ,[LAST_REVIEW_DATE]
      ,[CUSTOM01]
      ,[CUSTOM02]
      ,[CUSTOM03]
      ,[CUSTOM04]
      ,[CUSTOM05]
      ,[CUSTOM06]
      ,[CUSTOM07]
      ,[CUSTOM08]
      ,[CUSTOM09]
      ,[CUSTOM10]
      ,[CUSTOM11]
      ,[CUSTOM12]
      ,[CUSTOM13]
      ,[CUSTOM14]
      ,[CUSTOM15]
      ,[DEFAULT_LOCALE]
      ,[LOGIN_METHOD]
  FROM [dbo].[vLearningManagementUsers]


GO
