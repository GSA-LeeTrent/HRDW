USE [HRDW]
GO
/****** Object:  View [LMS].[vCHRIS_LMS_Users]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-03-09  
-- Description: Created View
-- =============================================================================
CREATE VIEW [LMS].[vCHRIS_LMS_Users] WITH SCHEMABINDING
AS

SELECT [CHRIS_LMS_UserID]
      ,[FirstName]
      ,[LastName]
      ,[MiddleInitial]
      ,[Email]
      ,[AgencySubElementCode]
      ,[OfficeSymbol]
      ,[DutyStationCode]
      ,[OccupationalSeries]
      ,[LatestHireDate]
      ,[EmployeeNumber]
      ,[PositionTitle]
      ,[WorkPhoneNumber]
      ,[WorkAddressLine1]
      ,[WorkAddressLine2]
      ,[WorkAddressCity]
      ,[WorkAddressState]
      ,[WorkAddressZip]
      ,[OccupationalSeriesDescription]
      ,[EducationLevel]
      ,[SupervisorCode]
      ,[Grade]
      ,[PayPlan]
      ,[StepOrRate]
      ,[PositionPOI]
      ,[EntryOnPosition]
      ,[CHRISEmployeeID]
      ,[ManagerCHRISEmployeeID]
      ,[InactiveTimestamp]
      ,[LastUpdateTimestamp]
  FROM [dbo].[CHRIS_LMS_Users]



GO
