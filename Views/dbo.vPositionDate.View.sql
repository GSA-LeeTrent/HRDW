USE [HRDW]
GO
/****** Object:  View [dbo].[vPositionDate]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vPositionDate] WITH SCHEMABINDING 
-- 2016-03-08 Rob Cornelsen updated to match table structure
    AS 
    SELECT [PositionDateID]
      ,[LatestHireDate]
      ,[DateLastPromotion]
      ,[DateProbTrialPeriodBegins]
      ,[DateProbTrialPeriodEnds]
      ,[DateSpvrMgrProbEnds]
      ,[DateConversionCareerDue]
      ,[DateConversionCareerBegins]
      ,[WGIDateDue]
      ,[DateVRAConversionDue]
      ,[DetailNTEStartDate]
      ,[DetailNTEdate]
      ,[DateofSESAppointment]
      ,[DateSESProbExpires]
      ,[WGILastEquivalentIncreaseDate]
      ,[SCDCivilian]
      ,[SCDLeave]
      ,[ComputeEarlyRetirment]
      ,[ComputeOptionalRetirement]
      ,[ArrivedPersonnelOffice]
      ,[ArrivedPresentGrade]
      ,[ArrivedPresentPosition]
      ,[PayPeriodEndDate]
      ,[Serv05Date]
      ,[Serv10Date]
      ,[Serv15Date]
      ,[Serv20Date]
      ,[Serv25Date]
      ,[Serv30Date]
      ,[Serv35Date]
      ,[Serv40Date]
      ,[Serv45Date]
      ,[Serv50Date]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
    FROM [dbo].[PositionDate]

GO
