USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_McoLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rv_sp_load_McoLkup]
with execute as owner		
as
INSERT INTO [dbo].[McoLkup]
           ([OccupationalSeriesCode]
           ,[McoAbbreviated]
           ,[McoGrouped]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
    select distinct [OccupationalSeriesCode]
           ,[McoAbbreviated]
           ,[McoGrouped]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate]
    FROM [dbo].[xxMcoLkup]

GO
