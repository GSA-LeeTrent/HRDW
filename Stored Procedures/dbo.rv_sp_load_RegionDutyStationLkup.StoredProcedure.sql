USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_RegionDutyStationLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rv_sp_load_RegionDutyStationLkup]
with execute as owner		
as
INSERT INTO [dbo].[RegionDutyStationLkup]
           ([DutyStationStateOrCountry]
           ,[RegionBasedOnDutyStation]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
    select distinct [DutyStationStateOrCountry]
           ,[RegionBasedOnDutyStation]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate]
    FROM [dbo].[xxRegionDutyStationLkup]

GO
