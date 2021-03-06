USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_RnoLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[rv_sp_load_RnoLkup]
with execute as owner		
as
INSERT INTO [dbo].[RnoLkup]
           ([RnoCode]
           ,[RaceNationalOrigin]
           ,[RnoCategory]
           ,[MinorityStatus]
           ,[RnoDescription]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
    select distinct [RnoCode]
           ,[RaceNationalOrigin]
           ,[RnoCategory]
           ,[MinorityStatus]
           ,[RnoDescription]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate]
    FROM [dbo].[xxRnoLkup]


GO
