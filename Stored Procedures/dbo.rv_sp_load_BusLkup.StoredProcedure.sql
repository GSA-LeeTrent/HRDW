USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_BusLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rv_sp_load_BusLkup]
with execute as owner		
as

INSERT INTO dbo.BusLkup
           ([BargainingUnitStatusCode]
           ,[BargainingUnitOrg]
           ,[BargainingUnitStatusCodeGroup]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
SELECT distinct [BargainingUnitStatusCode]
      ,[BargainingUnitOrg]
      ,[BargainingUnitStatusCodeGroup]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
  FROM [dbo].[xxBusLkup]

GO
