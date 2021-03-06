USE [HRDW]
GO
/****** Object:  View [dbo].[vPoiLkup]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vPoiLkup] WITH SCHEMABINDING 
-- 2016-03-08 Rob Cornelsen updated to match table structure and added WITH SCHEMABINDING 
    AS 
    SELECT [PoiLkupID]
      ,[PersonnelOfficeID]
      ,[PersonnelOfficeIDDescription]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
    FROM [dbo].[PoiLkup]


GO
