USE [HRDW]
GO
/****** Object:  View [dbo].[vIDP]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vIDP] WITH SCHEMABINDING 
-- 2015/12/29 Rob Cornelsen updated as per 2294
-- 2016-03-08 Rob Cornelsen updated table based views to match latest table structure
    AS 
    SELECT [IDPID]
      ,[PersonID]
      ,[FiscalYearValidation]
      ,[IDPStatus]
      ,[IDPRecordNumber]
      ,[SharedIDPsRecordType]
      ,[SharedIDPsLastModifiedDate]
      ,[ShortTermCareerGoalsUnder4Years]
      ,[LongTermCareerGoalsOver3Years]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
  FROM [dbo].[IDP]

GO
