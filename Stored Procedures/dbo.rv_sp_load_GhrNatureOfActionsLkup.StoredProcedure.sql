USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_GhrNatureOfActionsLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rv_sp_load_GhrNatureOfActionsLkup]
with execute as owner		
as
INSERT INTO [dbo].[GhrNatureOfActionsLkup]
           ([NoacCode]
           ,[FamilyNoacs]
           ,[NoacDescription]
           ,[NoaGrouping]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
    select Distinct [NoacCode]
           ,[FamilyNoacs]
           ,[NoacDescription]
           ,[NoaGrouping]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate]
    FROM [dbo].[xxGhrNatureOfActionsLkup]

GO
