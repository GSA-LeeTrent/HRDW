USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_SsoLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rv_sp_load_SsoLkup]
with execute as owner		
as
INSERT INTO [dbo].[SsoLkup]
           ([PosOrgAgySubelementCode]
           ,[PosOrgAgySubelementDescription]
           ,[SsoAbbreviation]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
    select distinct [PosOrgAgySubelementCode]
           ,[PosOrgAgySubelementDescription]
           ,[SsoAbbreviation]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate]
    FROM [dbo].[xxSsoLkup]

GO
