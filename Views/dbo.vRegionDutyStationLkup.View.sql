USE [HRDW]
GO
/****** Object:  View [dbo].[vRegionDutyStationLkup]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
    

CREATE VIEW [dbo].[vRegionDutyStationLkup] WITH SCHEMABINDING
-- 2016-03-08 Rob Cornelsen updated to addWITH SCHEMABINDING 
    AS 
    SELECT [DutyStationStateOrCountry]
      ,[RegionBasedOnDutyStation]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate] 
    FROM [dbo].[RegionDutyStationLkup]

GO
