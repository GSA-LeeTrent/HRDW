USE [HRDW]
GO
/****** Object:  View [LMS].[vActiveDirectoryUsers]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-03-09  
-- Description: Created View
-- =============================================================================
CREATE VIEW [LMS].[vActiveDirectoryUsers] WITH SCHEMABINDING
AS

SELECT [UserPrincipalName]
      ,[ADDomain]
      ,[FirstName]
      ,[LastName]
      ,[MiddleInitial]
      ,[UserID]
      ,[UserType]
      ,[EmailAddress]
      ,[EmployeeNumber]
      ,[Emp_Status]
      ,[Emp_Service]
      ,[OfficeSymbol]
      ,[Agency]
      ,[Region]
      ,[LibraryAccess]
      ,[PositionTitle]
      ,[SupervisorName]
      ,[SupervisorEmail]
      ,[SupervisorEmployeeNumber]
      ,[PayPlan]
      ,[JobSeries]
      ,[Grade]
      ,[PositionLevel]
      ,[EntryOnDuty]
      ,[EntryOnPosition]
      ,[SupervisoryStatus]
      ,[CHRISEmployeeID]
      ,[Affiliation]
      ,[LastLoginTimestamp]
      ,[InactiveTimestamp]
      ,[LastUpdateTimestamp]
  FROM [dbo].[ActiveDirectoryUsers]




GO
