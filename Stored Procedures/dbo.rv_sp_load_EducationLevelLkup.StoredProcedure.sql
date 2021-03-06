USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_EducationLevelLkup]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rv_sp_load_EducationLevelLkup]
with execute as owner		
as
INSERT INTO [dbo].[EducationLevelLkup]
           ([EducationLevelCode]
           ,[ShortDescription]
           ,[LongDescription]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate])
    SELECT Distinct [EducationLevelCode]
           ,[ShortDescription]
           ,[LongDescription]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate]
    FROM [dbo].[xxEducationLevelLkup]

GO
