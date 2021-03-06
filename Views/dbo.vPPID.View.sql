USE [HRDW]
GO
/****** Object:  View [dbo].[vPPID]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vPPID] WITH SCHEMABINDING 
    AS 
    SELECT [PPIDID]
      ,[PersonID]
      ,[RunDate]
      ,[PerformancePlanIssueDate]
      ,[RatingPeriodStartDate]
      ,[RatingPeriodEndDate]
      ,[HasPP]
      ,[AgencySubElement]
      ,[HSSO]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
  FROM [dbo].[PPID]

GO
