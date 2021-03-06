USE [HRDW]
GO
/****** Object:  View [dbo].[vPerformanceRating]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--CREATE VIEW [dbo].[vPerformance] WITH SCHEMABINDING 
---- 2016-03-08 Rob Cornelsen updated table based views to match latest table structure
--    AS 
--    SELECT [PerformanceID]
--      ,[PositionID]
--      ,[GT45Days]
--      ,[DateArrivedPosition]
--      ,[DaysBetween]
--      ,[LT45Days]
--      ,[DataSource]
--      ,[SystemSource]
--      ,[AsOfDate]
--    FROM [dbo].[Performance]
--GO 

--CREATE VIEW [dbo].[vPerformancePlan] WITH SCHEMABINDING 
---- 2016-03-08 Rob Cornelsen updated table based views to match latest table structure
--    AS 
--    SELECT [PerformancePlanID]
--      ,[PersonID]
--      ,[AppraisalTypeDescription]
--      ,[AppraisalType]
--      ,[RatingPeriodStartDate]
--      ,[RatingPeriodEndDate]
--      ,[NormalPattern]
--      ,[PerformancePlanIssueDate]
--      ,[IsPPIDBlank]
--      ,[DataSource]
--      ,[SystemSource]
--      ,[AsOfDate]
--    FROM [dbo].[PerformancePlan]
--GO 

CREATE VIEW [dbo].[vPerformanceRating] WITH SCHEMABINDING 
-- 2016-03-08 Rob Cornelsen updated table based views to match latest table structure
    AS 
SELECT [PerformanceRatingID]
      ,[RunDate]
      ,[FiscalYearRating]
      ,[EmployeeFullName]
      ,[RatingPeriodStartDate]
      ,[RatingPeriodEndDate]
      ,[OverallRating]
      ,[Unratable]
      ,[PayPlan]
      ,[PersonID]
      ,[HSSO]
      ,[AppraisalTypeDescription]
      ,[AppraisalStatus]
      ,[CurrentManagerID]
      ,[FAPManagerID]
      ,[MidYearManagerID]
      ,[Organization]
      ,[AgencySubElement]
      ,[OwningRegion]
      ,[ServicingRegion]
      ,[PersonnelOfficeIdentifier]
      ,[UnratableReason]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
  FROM [dbo].[PerformanceRating]

GO
