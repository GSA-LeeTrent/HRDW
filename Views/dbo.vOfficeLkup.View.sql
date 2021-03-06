USE [HRDW]
GO
/****** Object:  View [dbo].[vOfficeLkup]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vOfficeLkup] WITH SCHEMABINDING -- 2316
-- 2016-03-08 Rob Cornelsen added [OfficeLkupID]
    AS 
    SELECT [OfficeLkupID]
      ,[OfficeSymbol]
      ,[OfficeSymbol2Char]
      ,[OfficeDescription]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate] 
    FROM [dbo].[OfficeLkup]

GO
