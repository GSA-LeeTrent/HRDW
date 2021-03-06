USE [HRDW]
GO
/****** Object:  View [dbo].[vMcoLkup]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
 
CREATE VIEW [dbo].[vMcoLkup] WITH SCHEMABINDING     -- 2298
-- 2016-03-08 Rob Cornelsen added 'WITH SCHEMABINDING'
    AS
    SELECT [McoLkupID]
      ,[OccupationalSeriesCode]
      ,[McoAbbreviated]
      ,[McoGrouped]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate] 
    FROM [dbo].[McoLkup]   

GO
