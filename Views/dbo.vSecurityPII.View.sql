USE [HRDW]
GO
/****** Object:  View [dbo].[vSecurityPII]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

----CREATE VIEW [dbo].[vSecondaryMidYear] WITH SCHEMABINDING 
------ 2016-03-08 Rob Cornelsen updated to match table structure
----    AS 
----    SELECT [SecondaryMidYearID]
----      ,[PersonID]
----      ,[StandardPattern]
----      ,[RatingPeriodStart]
----      ,[RatingPeriodEnd]
----      ,[High3]
----      ,[OverallRating]
----      ,[FinalPerformancePlanIssue]
----      ,[AP_STATUS]
----      ,[AppraisalTypeDescription]
----      ,[AP_TYPE_DESC]
----      ,[AppraisalStatus]
----      ,[CurrentManagerID]
----      ,[FAPManagerID]
----      ,[MidYearManagerID]
----      ,[DataSource]
----      ,[SystemSource]
----      ,[AsOfDate]
----    FROM [dbo].[SecondaryMidYear]
----GO 

CREATE VIEW [dbo].[vSecurityPII] WITH SCHEMABINDING 
-- 2016-03-08 Rob Cornelsen updated table based views to match latest table structure
    AS 
    SELECT [SecurityID]
      ,[PersonID]
      ,[RecordDate]
      ,[ClearanceCurrent]
      ,[ClearanceDate]
      ,[InvestigationType]
      ,[ClearanceDescription]
      ,[SecurityClearanceNumber]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
    FROM [dbo].[Security]

GO
