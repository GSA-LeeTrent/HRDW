USE [HRDW]
GO
/****** Object:  View [dbo].[vRnoLkup]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vRnoLkup] WITH SCHEMABINDING 
-- 2016-03-08 Rob Cornelsen updated to match table structure and added WITH SCHEMABINDING 
    AS 
    SELECT [RnoLkupID]
      ,[RnoCode]
      ,[RaceNationalOrigin]
      ,[RnoCategory]
      ,[MinorityStatus]
      ,[RnoDescription]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
    FROM [dbo].[RnoLkup]


GO
