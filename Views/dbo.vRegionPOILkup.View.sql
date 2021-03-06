USE [HRDW]
GO
/****** Object:  View [dbo].[vRegionPOILkup]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vRegionPOILkup] WITH SCHEMABINDING 
-- 2016-03-08 Rob Cornelsen updated to match table structure and added WITH SCHEMABINDING 
    AS 
    SELECT [PersonnelOfficeId]
      ,[Region]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate] 
    FROM [dbo].[RegionPOILkup]

GO
