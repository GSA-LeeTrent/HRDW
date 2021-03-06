USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_RegionPoiLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rv_sp_load_RegionPoiLkup]
with execute as owner		
as
INSERT INTO [dbo].[RegionPoiLkup]
           ([PersonnelOfficeId]
           ,[Region]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
    select distinct [PersonnelOfficeId]
           ,[Region]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate]
    FROM [dbo].[xxRegionPoiLkup]

GO
