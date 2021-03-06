USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_RequiredTrainingClassPatternSearch]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rv_sp_load_RequiredTrainingClassPatternSearch]
with execute as owner		
as

INSERT INTO [dbo].[RequiredTrainingClassPatternSearch]
           ([RequiredEmployeeGroupingPerOlu]
           ,[DueDate]
           ,[HowToIdentify]
           ,[OluTitle]
           ,[PatternSearch]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
    
SELECT [Required Employee Grouping per OLU]
      ,[FY16 Due Date]
      ,[How to Identify]
      ,[OLU Title]
      ,[Pattern Search]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
  FROM [dbo].[xxRequiredTrainingClassPatternSearch]

GO
