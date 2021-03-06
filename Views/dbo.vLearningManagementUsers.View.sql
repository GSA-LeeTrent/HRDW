USE [HRDW]
GO
/****** Object:  View [dbo].[vLearningManagementUsers]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-09-21  
-- Description: Created View
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-02-01  
-- Description: Updated view to set CUSTOM03 and LOGIN_METHOD to 'SSO' when 
--              last 7 of EmailAddress = 'gsa.gov' and to 'PWD' otherwise.
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-02-08  
-- Description: Updated view to set CUSTOM03 and LOGIN_METHOD to 'PWD' when 
--              last 9 of EmailAddress = 'gsaig.gov' OR EmailAddress contains 
--             '%gsaig.alias%' and to 'SSO' otherwise.
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-02-09  
-- Description: Updated view to use CHRIS email before AD email in the
--              COALESCE statement. This is needed so that OIG employees
--              that are being sent in the ENT file will pick up their 
--              firstname.lastname@gsaig.gov as their USERNAME instead of
--              gsaig.alias.firstname.lastname@gsa.gov that is coming in on
--              the ENT AD file.
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-02-16  
-- Description: Added the following to CASE statements for CUSTOM03 and 
--				LOGIN_METHOD as some OIG user emails were only in CHRIS:
--				WHEN RIGHT(chris.[Email], 9) = 'gsaig.gov'
--				THEN 'PWD'
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-04-27  
-- Description: Uncommented sql on WHERE clause so that LMS users inactivated
--              in the last 5 days will be sent over on the LMS interface. 
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-05-17  
-- Description: Uncommented CASE statement sql to pass 'NO_MANAGER' when 
--              manager is inactive. 
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-05-17  
-- Description: Replace vNewSupervisors with vNewSupervisorsLast2Years. The new
--              view excludes employees on temporary detail ('NTE' in
--              NOAC_AND_DESCRIPTION) so they do not get a NewSupEffDate (column
--              CUSTOM13 in export) assigned. This will eliminate issues where
--              HR is contacting supervisors to complete traing (when they are 
--              not required to as "temporary" supervisor assignments). 
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-11-09  
-- Description: Set Manager to NO_MANAGER for Inactive Supervisors 
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-10-18  
-- Description: ESC TASK 84516
--              Replace AgencySubElementCode in DIVISION with the SSO Abbreviation
--              corresponding to the AgencySubElementCode.
--
--              Add statement to strip '-C' off of the end of contractor 
--              Office Symbols. This enables matching to AgyOfcLkup / SSOLkup
--              to populate SSO Abbreviation for contractors. 
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-12-07  
-- Description: ESCTASK 84520
--              Use only the AD InactiveTimestamp to Identify Active Users
--              AND test for Inactive CHRIS and Active ENT to set ACTIVE status. 
-- =============================================================================
CREATE VIEW [dbo].[vLearningManagementUsers]
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
, CASE
  WHEN chrismgr.InactiveTimestamp IS NOT NULL OR admgr.InactiveTimestamp IS NOT NULL 
  THEN 'NO_MANAGER' 
  WHEN admgr.UserPrincipalName IS NULL
  THEN 'NO_MANAGER'
  WHEN RIGHT(admgr.UserPrincipalName, 7) = 'gsa.gov'
  THEN LEFT(admgr.UserPrincipalName, charindex('@', admgr.UserPrincipalName) - 1)
  WHEN RIGHT(admgr.UserPrincipalName, 7) <> 'gsa.gov'
  THEN admgr.UserPrincipalName
  WHEN chrismgr.InactiveTimestamp IS NULL AND admgr.InactiveTimestamp IS NULL 
  THEN ISNULL(LEFT(admgr.UserPrincipalName, charindex('@', admgr.UserPrincipalName) - 1),'NO_MANAGER') 
  ELSE
     'NO_MANAGER'
  END AS MANAGER
, LMSUsers.HR
--, LMSUsers.DIVISION
, ISNULL(sso.SSOAbbreviation,'N/A') AS DIVISION
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
--  JJM 2017-12-15 Add CASE to allow for Active ENT and Inactive CHRIS
	WHEN chris.InactiveTimestamp IS NOT NULL AND ad.InactiveTimestamp IS NULL
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
   ,CASE
	WHEN chris.OfficeSymbol IS NOT NULL
	THEN chris.OfficeSymbol
	-- JJM 2017-10-18 TASK 84516 Strip -C from end of Contractor Office Symbols for matching
	WHEN RIGHT(ad.OfficeSymbol, 2) = '-C'
	THEN LEFT(ad.OfficeSymbol, charindex('-', ad.OfficeSymbol) - 1)
	WHEN ad.OfficeSymbol IS NOT NULL
	THEN ad.OfficeSymbol
	ELSE 'NO_DEPARTMENT'
	END AS DEPARTMENT
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
 	 dbo.[vNewSupervisorsLast2Years] sup ON sup.PersonID = per.PersonID
  WHERE 
	(
	(DATEDIFF(DAY,chris.[InactiveTimestamp],CONVERT(date, GETDATE()))) <= '5'
	OR
	(DATEDIFF(DAY,ad.[InactiveTimestamp],CONVERT(date, GETDATE()))) <= '5'	
	OR
	--JJM 2017-12-07 TASK 84520 Use only the AD InactiveTimestamp to Identify Active Users
	--(chris.[InactiveTimestamp] IS NULL AND ad.[InactiveTimestamp] IS NULL)
	ad.[InactiveTimestamp] IS NULL
	)
) AS LMSUsers
	 LEFT OUTER JOIN
	 dbo.[CHRIS_LMS_Users] chrismgr ON chrismgr.CHRISEmployeeID = LMSUsers.MANAGER_EMPID
	 LEFT OUTER JOIN
	 dbo.[ActiveDirectoryUsers] admgr ON admgr.CHRISEmployeeID = chrismgr.EmployeeNumber
	 -- JJM 2017-10-18 TASK 84516 Added AgyOfcLkup / SSOLkup to identify AgencySubElement / SSO Abbr
	 --                based on Office Symbol.
	 LEFT OUTER JOIN
	 LMS.AgyOfcLkup agy ON agy.OfficeSymbol = LMSUsers.DEPARTMENT
	 LEFT OUTER JOIN
	 dbo.SsoLkup sso ON sso.PosOrgAgySubelementCode = agy.AgencySubElementCode
--WHERE
--	LMSUSERS.STATUS = 'Inactive'
--	LMSUSERS.EMAIL IN ('aminata.diagne@gsa.gov','josea.roman@gsa.gov','joseph.mock@gsa.gov') --,'aaron.vandenberg@gsa.gov')



GO
