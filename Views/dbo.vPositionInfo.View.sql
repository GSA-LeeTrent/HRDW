USE [HRDW]
GO
/****** Object:  View [dbo].[vPositionInfo]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vPositionInfo] WITH SCHEMABINDING 
-- 2016-03-08 Rob Cornelsen updated to adde WITH SCHEMABINDING
    AS 
    SELECT [PositionInfoID]
      ,[PositionControlNumber]
      ,[PositionInformationPD]
      ,[PositionTitle]
      ,[PositionSeries]
      ,[PositionSeriesDesc]
      ,[PositionControlIndicator]
      ,[PositionSequenceNumber]
      ,[PositionEncumberedType]
      ,[PayPlan]
      ,[Grade]
      ,[Step]
      ,[HssoCode]
      ,[SupervisoryStatusCode]
      ,[SupervisoryStatusDesc]
      ,[PositionSensitivity]
      ,[FundingStatus]
      ,[FundingStatusDescription]
      ,[OccupationalCateGOryCode]
      ,[OccupationalCateGOryDescription]
      ,[OfficeSymbol]
      ,[SupvMgrProbationRequirementCode]
      ,[SupvMgrProbationRequirementDesc]
      ,[SupervisorID]
      ,[TeamLeaderID]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
    FROM [dbo].[PositionInfo]

GO
