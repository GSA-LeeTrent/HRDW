USE [HRDW]
GO
/****** Object:  View [dbo].[vPosition]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vPosition] WITH SCHEMABINDING 
-- 2016-03-08 Rob Cornelsen updated to match table structure
    AS 
    SELECT [PositionID]
      ,[RecordDate]
      ,[WorkTelephone]
      ,[LeaveCateGOry]
      ,[TenureDescription]
      ,[CompetativeArea]
      ,[CompetativeLevel]
      ,[WorkScheduleDescription]
      ,[BargainingUnitStatusCode]
      ,[BargainingUnitStatusDescription]
      ,[YOSGSA]
      ,[YOS_FEDERAL]
      ,[MCO]
      ,[FlsaCateGOryCode]
      ,[FlsaCateGOryDescription]
      ,[DrugTestCode]
      ,[DrugTestDescription]
      ,[KeyEmergencyEssentialCode]
      ,[KeyEmergencyEssentialDescription]
      ,[AssignmentUSErStatus]
      ,[WorkCellPhoneNumber]
      ,[VorS]
      ,[FurloughIndicator]
      ,[FurloughIndicatorDesc]
      ,[WorkAddressLine1]
      ,[WorkAddressLine2]
      ,[WorkAddressLine3]
      ,[WorkBuilding]
      ,[WorkCity]
      ,[WorkCounty]
      ,[WorkState]
      ,[WorkZip]
      ,[PosOrgAgySubelementCode]
      ,[PosOrgAgySubelementDesc]
      ,[PosAddressOrgInfoLine1]
      ,[PosAddressOrgInfoLine2]
      ,[PosAddressOrgInfoLine3]
      ,[PosAddressOrgInfoLine4]
      ,[PosAddressOrgInfoLine5]
      ,[PosAddressOrgInfoLine6]
      ,[AvailableForHiring]
      ,[CybersecurityCode]
      ,[CybersecurityCodeDesc]
      ,[FY]
      ,PublicTrustIndicatorDesc
      ,PublicTrustIndicatorCode
      ,TeleworkIndicator
      ,TeleworkIndicatorDescription
      ,TeleworkIneligibilityReason
      ,TeleworkIneligibReasonDescription
      ,[PersonID]
      ,[DutyStationID]
      ,[FinancialsID]
      ,[PersonnelOfficeID]
      ,[ChrisPositionID]
      ,[DetailedPositionID]
      ,[ObligatedPositionID]
      ,[PositionDateID]
      ,[PayID]
      ,[IsHistoric]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
    FROM [dbo].[Position]

GO
