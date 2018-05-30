USE [HRDW]
GO
/****** Object:  View [dbo].[vNoaGroupingLkup]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vNoaGroupingLkup] WITH SCHEMABINDING
-- 2016-03-08 Rob Cornelsen added 'WITH SCHEMABINDING'
    AS 
    SELECT [NoaGroupingLkupID]
      ,[NoaGrouping]
      ,[NoacCode]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
    FROM [dbo].[NoaGroupingLkup]   -- 2298

GO
