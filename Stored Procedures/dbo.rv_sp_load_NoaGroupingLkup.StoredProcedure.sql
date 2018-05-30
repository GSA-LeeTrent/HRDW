USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_NoaGroupingLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rv_sp_load_NoaGroupingLkup]
with execute as owner		
as
INSERT INTO [dbo].[NoaGroupingLkup]
           ([NoaGrouping]
           ,[NoacCode]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
    select distinct [NoaGrouping]
           ,[NoacCode]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate]
    FROM [dbo].[xxNoaGroupingLkup]

GO
