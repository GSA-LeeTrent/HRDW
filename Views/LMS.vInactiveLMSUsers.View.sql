USE [HRDW]
GO
/****** Object:  View [LMS].[vInactiveLMSUsers]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [LMS].[vInactiveLMSUsers]
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-04-20  
-- Description: Created View of Inactive LMS Users
-- =============================================================================
AS

SELECT
  LMSUsers.STATUS
, LMSUsers.USERID
, LMSUsers.USERNAME
, LMSUsers.FIRSTNAME
, LMSUsers.LASTNAME
, LMSUsers.MI
, LMSUsers.GENDER
, LMSUsers.EMAIL
,CASE
 WHEN admgr.UserPrincipalName IS NULL
	THEN 'NO_MANAGER'
 WHEN RIGHT(admgr.UserPrincipalName, 7) = 'gsa.gov'
	THEN LEFT(admgr.UserPrincipalName, charindex('@', admgr.UserPrincipalName) - 1)
 WHEN RIGHT(admgr.UserPrincipalName, 7) <> 'gsa.gov'
 	THEN admgr.UserPrincipalName
 END AS MANAGER
--, CASE
--  WHEN chrismgr.InactiveTimestamp IS NULL AND admgr.InactiveTimestamp IS NULL 
--	  THEN ISNULL(LEFT(admgr.UserPrincipalName, charindex('@', admgr.UserPrincipalName) - 1),'NO_MANAGER') 
--  ELSE
--      'NO_MANAGER'
--  END AS MANAGER
, LMSUsers.HR
, LMSUsers.DIVISION
, LMSUsers.DEPARTMENT
, LMSUsers.LOCATION
, LMSUsers.JOBCODE
, LMSUsers.TIMEZONE
, LMSUsers.HIREDATE
, LMSUsers.EMPID
, LMSUsers.TITLE
, LMSUsers.BIZ_PHONE
, LMSUsers.FAX
, LMSUsers.ADDR1
, LMSUsers.ADDR2
, LMSUsers.CITY
, LMSUsers.STATE
, LMSUsers.ZIP
, LMSUsers.COUNTRY
, LMSUsers.REVIEW_FREQ
, LMSUsers.LAST_REVIEW_DATE
, LMSUsers.CUSTOM01
, LMSUsers.CUSTOM02
, LMSUsers.CUSTOM03
, LMSUsers.CUSTOM04
, LMSUsers.CUSTOM05
, LMSUsers.CUSTOM06
, LMSUsers.CUSTOM07
, LMSUsers.CUSTOM08
, LMSUsers.CUSTOM09
, LMSUsers.CUSTOM10
, LMSUsers.CUSTOM11
, LMSUsers.CUSTOM12
, LMSUsers.CUSTOM13
, LMSUsers.CUSTOM14
, LMSUsers.CUSTOM15
, LMSUsers.DEFAULT_LOCALE
, LMSUsers.LOGIN_METHOD
FROM
(
SELECT 
	CASE
	WHEN COALESCE(chris.InactiveTimestamp, ad.InactiveTimestamp) IS NULL
		THEN 'Active'
	WHEN COALESCE(chris.InactiveTimestamp, ad.InactiveTimestamp) IS NOT NULL
		THEN 'Inactive'
	END AS STATUS
   ,CASE
	WHEN RIGHT(ad.UserPrincipalName, 7) = 'gsa.gov'
		THEN LEFT(ad.UserPrincipalName, charindex('@', ad.UserPrincipalName) - 1)
	WHEN RIGHT(ad.UserPrincipalName, 7) <> 'gsa.gov'
		THEN ad.UserPrincipalName
	END AS USERID
   ,LOWER(COALESCE(chris.[Email], ad.EmailAddress)) AS USERNAME
   ,COALESCE(chris.FirstName, ad.FirstName) AS FIRSTNAME
   ,COALESCE(chris.LastName, ad.LastName) AS LASTNAME
   ,COALESCE(chris.MiddleInitial, ad.MiddleInitial) AS MI
   ,NULL AS GENDER
   ,LOWER(COALESCE(chris.[Email],ad.EmailAddress)) AS EMAIL
   ,ISNULL(chris.[ManagerCHRISEmployeeID],'NO_MANAGER') AS MANAGER_EMPID
   ,'NO_HR' AS HR
   ,ISNULL(chris.AgencySubElementCode,'N/A') AS DIVISION
   ,ISNULL(COALESCE(chris.OfficeSymbol, ad.OfficeSymbol),'NO_DEPARTMEMT') AS DEPARTMENT
   ,chris.DutyStationCode AS LOCATION
   ,chris.OccupationalSeries AS JOBCODE
   ,'US/Eastern' AS TIMEZONE
   ,chris.LatestHireDate AS HIREDATE
   ,chris.CHRISEmployeeID AS EMPID
   ,COALESCE(chris.PositionTitle, ad.PositionTitle) AS TITLE
   ,chris.WorkPhoneNumber AS BIZ_PHONE
   ,NULL AS FAX
   ,chris.WorkAddressLine1 AS ADDR1
   ,chris.WorkAddressLine2 AS ADDR2
   ,chris.WorkAddressCity AS CITY
   ,chris.WorkAddressState AS STATE
   ,chris.WorkAddressZip AS ZIP
   ,NULL AS COUNTRY
   ,NULL AS REVIEW_FREQ
   ,NULL AS LAST_REVIEW_DATE
   ,chris.OccupationalSeriesDescription AS CUSTOM01
   ,chris.EducationLevel AS CUSTOM02
   ,CASE
	WHEN RIGHT(chris.[Email], 9) = 'gsaig.gov'
	THEN 'PWD'
	WHEN RIGHT(ad.EmailAddress, 9) = 'gsaig.gov'
	THEN 'PWD'
	WHEN LEFT(ad.EmailAddress, 11) = 'gsaig.alias'
	THEN 'PWD'
	ELSE 'SSO'
	END AS CUSTOM03
   ,CASE
    WHEN chris.SupervisorCode = '2'
		THEN 'Supervisory'
    WHEN chris.SupervisorCode = '4'
		THEN 'Supervisory'
    WHEN chris.SupervisorCode = '5'
		THEN 'Employee'
    WHEN chris.SupervisorCode = '6'
		THEN 'Employee'
    WHEN chris.SupervisorCode = '7'
		THEN 'Employee'
    WHEN ad.Affiliation = 'Government'
		THEN 'Employee'
	ELSE
		'Contractor'
	END AS CUSTOM04
   ,chris.Grade AS CUSTOM05
   ,chris.PayPlan AS CUSTOM06
   ,chris.StepOrRate AS CUSTOM07
   ,ad.Region AS CUSTOM08
   ,CAST(CONVERT(CHAR(10),GETDATE() + 7,126) AS DATE) AS CUSTOM09
   ,CAST(chris.EntryOnPosition AS DATE) AS CUSTOM10
   ,chris.CHRISEmployeeID AS CUSTOM11
   ,'GSA' AS CUSTOM12
   ,CAST(CONVERT(CHAR(10),sup.NewSupEffDate,126) AS DATE) AS CUSTOM13
   ,NULL AS CUSTOM14
   ,NULL AS CUSTOM15
   ,'en_US' AS DEFAULT_LOCALE
   ,CASE
	WHEN RIGHT(chris.[Email], 9) = 'gsaig.gov'
	THEN 'PWD'
	WHEN RIGHT(ad.EmailAddress, 9) = 'gsaig.gov'
	THEN 'PWD'
	WHEN LEFT(ad.EmailAddress, 11) = 'gsaig.alias'
	THEN 'PWD'
	ELSE 'SSO'
	END AS LOGIN_METHOD
  FROM 
	 dbo.[ActiveDirectoryUsers] ad
	 LEFT OUTER JOIN
	 dbo.[CHRIS_LMS_Users] chris ON ad.CHRISEmployeeID = chris.EmployeeNumber
	 LEFT OUTER JOIN
	 dbo.[Person] per ON (per.EmailAddress = ad.EmailAddress OR per.EmailAddress = chris.Email)
	 LEFT OUTER JOIN
 	 dbo.[vNewSupervisors] sup ON sup.PersonID = per.PersonID
  WHERE 
	(
--	(DATEDIFF(DAY,chris.[InactiveTimestamp],CONVERT(date, GETDATE()))) <= '5'
--	OR
--	(DATEDIFF(DAY,ad.[InactiveTimestamp],CONVERT(date, GETDATE()))) <= '5'	
--	OR
	(chris.[InactiveTimestamp] IS NOT NULL OR ad.[InactiveTimestamp] IS NOT NULL)
	)
) AS LMSUsers
	 LEFT OUTER JOIN
	 [CHRIS_LMS_Users] chrismgr ON chrismgr.CHRISEmployeeID = LMSUsers.MANAGER_EMPID
	 LEFT OUTER JOIN
	 [ActiveDirectoryUsers] admgr ON admgr.CHRISEmployeeID = chrismgr.EmployeeNumber





GO
