USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_PoiLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[rv_sp_load_PoiLkup]
with execute as owner		
as
INSERT INTO [dbo].[PoiLkup]
           ([PersonnelOfficeID]
           ,[PersonnelOfficeIDDescription]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
    select distinct [PersonnelOfficeID]
           ,[PersonnelOfficeIDDescription]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate]
    FROM [dbo].[xxPoiLkup]


GO
