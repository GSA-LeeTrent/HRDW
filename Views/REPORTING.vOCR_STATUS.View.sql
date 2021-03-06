USE [HRDW]
GO
/****** Object:  View [REPORTING].[vOCR_STATUS]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [REPORTING].[vOCR_STATUS] AS 
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-03-06  
-- Description: View Updated to get RNODecription from RNOLkup instead of Person
-- =============================================================================

SELECT        
   'PII' AS Safeguard
   , DB_NAME() AS [Database]
   , FORMAT(GETDATE(), 'M/dd/yyyy', 'en-US') AS [Record Date DB ]
   ,dbo.Person.[PersonID] AS [Person ID]
   --, dbo.[vAlphaOrgRoster-PII].FullName AS 'Emp Full Name'
   --, dbo.[vAlphaOrgRoster-PII].Employee_LN AS 'Emp Last Name'
  -- , dbo.[vAlphaOrgRoster-PII].Employee_FN AS 'Emp First Name'
  -- , dbo.[vAlphaOrgRoster-PII].Employee_MN AS 'Emp Middle Name'
   , dbo.Person.RNOCode  AS 'RNO Code'
   , dbo.RNOLkup.RNODescription AS 'RNO Desc'
   , dbo.[vAlphaOrgRoster-PII].GenderDescription AS 'Gender'
   , dbo.[vAlphaOrgRoster-PII].HandicapCode AS 'Disability Code'
   , dbo.[vAlphaOrgRoster-PII].HandicapCodeDescription AS 'Disability Desc'
   , dbo.[vAlphaOrgRoster-PII].VeteransPreferenceDescription
   ,CASE WHEN [vAlphaOrgRoster-PII].VeteransStatusDescription ='Not a Vietnam-era veteran' THEN 'N'
         WHEN [vAlphaOrgRoster-PII].VeteransStatusDescription ='Vietnam-era veteran' THEN 'V'
         WHEN [vAlphaOrgRoster-PII].VeteransStatusDescription ='Pre-Vietnam-era veteran' THEN 'B'
         WHEN [vAlphaOrgRoster-PII].VeteransStatusDescription ='Post-Vietnam-era veteran' THEN 'P'
         ELSE 'X' END AS 'Vet Status Cd'--Note X value means Not A Veteran
   , dbo.[vAlphaOrgRoster-PII].VeteransStatusDescription AS 'Vet Status Desc'
   ,CASE WHEN dbo.[vAlphaOrgRoster-PII].VeteransPreferenceDescription ='NONE' THEN '1'
         WHEN dbo.[vAlphaOrgRoster-PII].VeteransPreferenceDescription = '5 point' THEN '2'
		 WHEN dbo.[vAlphaOrgRoster-PII].VeteransPreferenceDescription = '10 point/disability' THEN '3'
		 WHEN dbo.[vAlphaOrgRoster-PII].VeteransPreferenceDescription = '10 point/compensable' THEN '4'
		 WHEN dbo.[vAlphaOrgRoster-PII].VeteransPreferenceDescription = '10 point/other' THEN '5'
		 WHEN dbo.[vAlphaOrgRoster-PII].VeteransPreferenceDescription = '10 point/compensable/30 percent' THEN '6'
		 ELSE '7' END AS 'Vet Pref Cd'--Code 7 = Sole Survivorship Pref eligible
   , dbo.[vAlphaOrgRoster-PII].VeteransPreferenceDescription AS 'Vet Pref Desc'
   --, dbo.Person.RNOCode AS 'RNO Desc'
   , FORMAT(dbo.Person.BirthDate,'M/dd/yyyy', 'en-US')  AS 'DOB' 
   , dbo.[vAlphaOrgRoster-PII].EducationLevelCode AS 'Educ Lvl Code'
   , dbo.[vAlphaOrgRoster-PII].EducationLevelDesc AS 'Educ Lvl Desc'
   , dbo.[vAlphaOrgRoster-PII].PositionTitle AS 'Posn Title'
   , dbo.[vAlphaOrgRoster-PII].PPSeriesGrade AS 'PP-Series-Gr'
   ,CASE WHEN dbo.Position.TenureDescription LIKE '%No Tenure Group%' THEN '0'
         WHEN dbo.Position.TenureDescription LIKE '%Tenure Group 1%' THEN '1'
		 WHEN dbo.Position.TenureDescription LIKE '%Tenure Group 2%' THEN '2'
		 ELSE '3' END AS 'Tenure Cd'--Value 3 = Tenure group 3
   , dbo.Position.TenureDescription AS 'Ten Desc'
   , dbo.[vAlphaOrgRoster-PII].SupervisoryStatusCode AS 'Supv Status Cd'
   , dbo.[vAlphaOrgRoster-PII].SupervisoryStatusDesc AS 'Supv Status Desc'
   , dbo.[vAlphaOrgRoster-PII].HSSO, dbo.[vAlphaOrgRoster-PII].OfficeSymbol AS 'Ofc Sym'
   , CASE WHEN dbo.[vAlphaOrgRoster-PII].PosAddressOrgInfoLine1 IS NULL THEN '' ELSE dbo.[vAlphaOrgRoster-PII].PosAddressOrgInfoLine1 END  AS 'Pos Info L1'
   , CASE WHEN dbo.[vAlphaOrgRoster-PII].PosAddressOrgInfoLine2 IS NULL THEN '' ELSE [vAlphaOrgRoster-PII].PosAddressOrgInfoLine2 END AS 'Pos Info L2'
   , CASE WHEN dbo.[vAlphaOrgRoster-PII].PosAddressOrgInfoLine3 IS NULL THEN ' ' ELSE dbo.[vAlphaOrgRoster-PII].PosAddressOrgInfoLine3 END AS 'Pos Info L3'
   , CASE WHEN dbo.[vAlphaOrgRoster-PII].PosAddressOrgInfoLine4 IS NULL THEN ' ' ELSE dbo.[vAlphaOrgRoster-PII].PosAddressOrgInfoLine4 END  AS 'Pos Info L4'
   , CASE WHEN dbo.[vAlphaOrgRoster-PII].PosAddressOrgInfoLine5 IS NULL THEN ' ' ELSE dbo.[vAlphaOrgRoster-PII].PosAddressOrgInfoLine5 END AS 'Pos Info L5'
   , CASE WHEN dbo.[vAlphaOrgRoster-PII].PosAddressOrgInfoLine6 IS NULL THEN ' ' ELSE dbo.[vAlphaOrgRoster-PII].PosAddressOrgInfoLine6 END AS 'Pos Info L6'
   , dbo.[vAlphaOrgRoster-PII].AppointmentAuthCode AS 'OPM Appt Auth Cd'
   , dbo.[vAlphaOrgRoster-PII].AppointmentAuthDesc AS 'OPM Appt Auth Desc'
   ,CASE WHEN dbo.[vAlphaOrgRoster-PII].AppointmentAuthCode IN ('J8M','LYM') THEN 'Veterans Readjustment Appointment'
         WHEN dbo.[vAlphaOrgRoster-PII].AppointmentAuthDesc LIKE 'CS Cert%' THEN 'Civil Service Certificate'
	     WHEN dbo.[vAlphaOrgRoster-PII].AppointmentAuthDesc LIKE 'Direct Hire%' THEN 'Direct Hire'
	     WHEN dbo.[vAlphaOrgRoster-PII].AppointmentAuthDesc LIKE 'OPM DE%' THEN 'OPM Delegated Examining Agreement'
	     WHEN dbo.[vAlphaOrgRoster-PII].AppointmentAuthDesc LIKE 'Sch A%' THEN 'Schedule A Appointment'
	     WHEN dbo.[vAlphaOrgRoster-PII].AppointmentAuthDesc LIKE 'Sch B%' THEN 'Schedule B Appointment'
	     WHEN dbo.[vAlphaOrgRoster-PII].AppointmentAuthDesc LIKE 'Sch C%' THEN 'Schedule C Appointment'
	     WHEN dbo.[vAlphaOrgRoster-PII].AppointmentAuthDesc LIKE 'Sch D%' THEN 'Schedule D Appointment'
	     ELSE 'Other Appointment Types' END AS 'Generic OPM Authorities'
	     , dbo.Financials.AppointmentType AS 'Appt Type GSA Desc'
   ,CASE WHEN dbo.Financials.AppointmentType ='Competitive -- Career' THEN 'GSA-1A'
         WHEN dbo.Financials.AppointmentType ='Competitive -- Career-Conditional' THEN 'GSA-2A'
	     WHEN dbo.Financials.AppointmentType ='Excepted -- Career' THEN 'GSA-1C'
	     WHEN dbo.Financials.AppointmentType ='Excepted Appointment -- NTE' THEN 'GSA-3C'
	     WHEN dbo.Financials.AppointmentType ='Excepted Indefinite' THEN 'GSA-4C'
	     WHEN dbo.Financials.AppointmentType ='Excepted-Conditional' THEN 'GSA-2C'
	     WHEN dbo.Financials.AppointmentType ='Provisional Appointment -- NTE' THEN 'GSA-4M'
	     WHEN dbo.Financials.AppointmentType ='SES -- Career' THEN 'GSA-5A'
	     WHEN dbo.Financials.AppointmentType ='SES -- Limited Term Appointment -- NTE' THEN 'GSA-5C'
	     WHEN dbo.Financials.AppointmentType ='SES -- Noncareer -- Indefinite' THEN 'GSA-5E'
	     WHEN dbo.Financials.AppointmentType ='SES -- Noncareer -- Permanent' THEN 'GSA-5B'
         WHEN dbo.Financials.AppointmentType ='Special Tenure' THEN 'GSA-4F'
	     WHEN dbo.Financials.AppointmentType ='Temporary Appointment -- NTE' THEN 'GSA-3A'
	     WHEN dbo.Financials.AppointmentType ='Term Appointment -- NTE' THEN 'GSA-3F'
	     WHEN dbo.Financials.AppointmentType ='Overseas Limited Appointment' THEN 'GSA-4H'
		 WHEN dbo.Financials.AppointmentType ='Emergency -- Indefinite' THEN 'GSA-4J'
	     ELSE 'Unknown' END AS 'Appt Type GSA Code'
	--ELSE '0' END  AS 'TEST'
   , dbo.[vAlphaOrgRoster-PII].DutyStationCode AS 'Duty Station Cd'
   , dbo.[vAlphaOrgRoster-PII].DutyStationName AS 'DS Name'
   , dbo.[vAlphaOrgRoster-PII].DutyStationCounty AS 'DS County'
   , dbo.[vAlphaOrgRoster-PII].DutyStationState AS 'DS State/Country'
   , dbo.[vAlphaOrgRoster-PII].[CombinedStatArea]	AS 'CSA'-- Combined statistical area 
   , dbo.[vAlphaOrgRoster-PII].[CoreBasedStatArea]  AS 'CBSA'-- Core-based statistical area  
   
FROM
	dbo.Position 
	INNER JOIN dbo.Person 
		ON dbo.Position.PersonID = dbo.Person.PersonID 
	INNER JOIN dbo.Financials 
		ON dbo.Position.FinancialsID = dbo.Financials.FinancialsID 
	RIGHT OUTER JOIN dbo.[vAlphaOrgRoster-PII] 
		ON dbo.Person.PersonID = dbo.[vAlphaOrgRoster-PII].PersonID 
		   AND 
		   dbo.Position.RecordDate =
               (
			   SELECT MAX(RecordDate) AS MaxRecDate
               FROM dbo.Position AS Position_1
			   )  --This is the code to obtain the most current record date of the data pull available in HRDW          
	LEFT OUTER JOIN dbo.RNOLkup
		ON dbo.RNOLkup.RNOCode = dbo.Person.RNOCode 


GO
