USE [HRDW]
GO
/****** Object:  View [dbo].[vGhrNatureOfActionsLkup]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vGhrNatureOfActionsLkup] WITH SCHEMABINDING 
-- 2016-03-08 Rob Cornelsen updated table based views to match latest table structure
    AS 
    SELECT [GhrNatureOfActionsLkupID]
      ,[NoacCode]
      ,[FamilyNoacs]
      ,[NoacDescription]
      ,[NoaGrouping]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
     FROM [dbo].[GhrNatureOfActionsLkup]  

GO
