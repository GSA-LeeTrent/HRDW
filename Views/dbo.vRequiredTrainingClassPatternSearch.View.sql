USE [HRDW]
GO
/****** Object:  View [dbo].[vRequiredTrainingClassPatternSearch]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vRequiredTrainingClassPatternSearch] WITH SCHEMABINDING  -- 02/29/2016 as per 2326
-- 2016-03-08 Rob Cornelsen updated to match table structure and added WITH SCHEMABINDING 
    AS 
    SELECT [RequiredTrainingClassPatternSearchID]
      ,[RequiredEmployeeGroupingPerOlu]
      ,[DueDate]
      ,[HowToIdentify]
      ,[OluTitle]
      ,[PatternSearch]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate] 
    FROM [dbo].[RequiredTrainingClassPatternSearch]

GO
