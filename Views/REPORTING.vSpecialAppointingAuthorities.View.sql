USE [HRDW]
GO
/****** Object:  View [REPORTING].[vSpecialAppointingAuthorities]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--Created by Raph Silvestro 3-14-2017

--For Accessions/Conversions

--VRA = Veterans Readjustment Appointment LAC's = J8M (PL 107-288), LYM (Reg. 315.705)
--Schedule A Disability LAC's = WUM (Reg. 213.3102(u)), LIM (Reg. 315.709)
--30% Disabled Veteran  LAC = LZM (Reg. 314.707)
--Military Spouse LAC = LAM (Reg. 315.612)
--Peace Corp LAC's = LEM (Reg. 315.605) or LJM (Reg. 315.607)
--For Accession Transactions Conversions AND Pay Rate Determinent:
--5 Special and Superior Qualifications Rates. For use when PRD codes 6 and 7 below are both applicable. Note: Code 5 is used only on the action that appointed the employee at a superior qualifications rate within a special rate range; code 6 is used on subsequent actions while the employee continues to receive a special rate of pay. 06/01/1972  Present  
--6 Special Rate. Employee is paid a special rate or a special pay supplement, established under appropriate authority to recruit or retain well qualified individuals in selected agencies, occupations, work levels, and locations. (If employee is also entitled to a retained grade, use code E or F, as appropriate.) References: 5 U.S.C. 5305, 5 U.S.C. 5343(a)(1)(A)(ii), 5 U.S.C. 5343(a)(1)(B)(ii), and similar authorities under law and regulation. 06/01/1972  Present  
--7 Superior Qualifications Rate. Employee is hired at a pay rate above the minimum rate of the grade. Note: Code 7 is used only on the action that appointed the employee at a superior qualifications rate; code 0 or another appropriate code is used on actions subsequent to the appointment action. References: 5 U.S.C. 5333 and 5 CFR 531.212. 

CREATE VIEW [REPORTING].[vSpecialAppointingAuthorities]

AS 
SELECT DISTINCT 
dbo.Transactions.PersonID 
,'HRDW PRODUCTION' AS 'DATABASE'
,dbo.Person.LastName
, dbo.Person.FirstName
, dbo.Person.MiddleName
,dbo.Person.LastName + ', ' + dbo.Person.FirstName + ' ' + IsNull(dbo.Person.MiddleName, '') as FullName
--,[RunDate]
,[EffectiveDate]
,[FYDESIGNATION]
,[NOAC_AND_DESCRIPTION]
,[NOAC_AND_DESCRIPTION_2]
,[TenureDesc]
,[AppointmentTypeDesc]
,[FirstActionLACode1]
,[FirstActionLADesc1]
, CASE WHEN [FirstActionLACode1] IN ('J8M','LYM') THEN 'VRA-Veterans Readjustment Appt'
       WHEN [FirstActionLACode1] IN ('WUM','LIM') THEN 'Schedule A Disability'
	   WHEN [FirstActionLACode1] ='LZM' THEN '30% Disabled Veteran'
	   WHEN [FirstActionLACode1] = 'LAM' THEN 'Military Spouse'
	   WHEN [FirstActionLACode1]  IN ('LEM','LJM') THEN 'Peace Corp/Vista'
	   WHEN [PayRateDeterminant] IN ('5','6','7') THEN 'Superior Qualifications'
	   ELSE 'Other Accession' END AS 'Special Appointment Authorities'
,CASE WHEN [FirstActionLADesc1] LIKE 'Sch A%' THEN 'SCHEDULE A'
      WHEN [FirstActionLADesc1] LIKE 'Sch B%' THEN 'SCHEDULE B'
	  WHEN [FirstActionLADesc1] LIKE 'Sch C%' THEN 'SCHEDULE C'
	  WHEN [FirstActionLADesc1] LIKE 'Sch D%' THEN 'SCHEDULE D'
	  WHEN [FirstActionLADesc1] LIKE 'OPM%DE%' THEN 'OPM Delegated Agreement'
	  WHEN [FirstActionLADesc1] LIKE 'Direct%Hire%' THEN 'Direct Hire Authority'
	  ELSE 'Non Schedule Appt' END  AS 'General Appt Desc'
,[ToPositionAgencyCodeSubelementDescription]
,[ToOfficeSymbol]
,[ToPPSeriesGrade]
,[PayRateDeterminant]
,[PayRateDeterminantDesc]
,[ToRegion]
,[ToServicingRegion]
,[ToPOI]
,[DutyStationNameandStateCountry]

FROM     dbo.Transactions LEFT OUTER JOIN
                  dbo.Person ON dbo.Transactions.PersonID = dbo.Person.PersonID
WHERE 
LEFT([NOAC_AND_DESCRIPTION],1) LIKE '1%' OR LEFT([NOAC_AND_DESCRIPTION],1) LIKE '5%'
AND [RunDate] =(SELECT MAX([RunDate]) AS MaxRunDate FROM [dbo].[Transactions])
AND [FYDESIGNATION] >= 'FY2000'

UNION
SELECT DISTINCT
dbo.TransactionsHistory.PersonID
,'HRDW PRODUCTION' AS 'DATABASE'
,dbo.Person.LastName
, dbo.Person.FirstName
, dbo.Person.MiddleName
,dbo.Person.LastName + ', ' + dbo.Person.FirstName + ' ' + IsNull(dbo.Person.MiddleName, '') as FullName
--,[RunDate]
,[EffectiveDate]
,[FYDESIGNATION]
,[NOAC_AND_DESCRIPTION]
,[NOAC_AND_DESCRIPTION_2]
,[TenureDesc]
,[AppointmentTypeDesc]
,[FirstActionLACode1]
,[FirstActionLADesc1]
, CASE WHEN [FirstActionLACode1] IN ('J8M','LYM') THEN 'VRA-Veterans Readjustment Appt'
       WHEN [FirstActionLACode1] IN ('WUM','LIM') THEN 'Schedule A Disability'
	   WHEN [FirstActionLACode1] ='LZM' THEN '30% Disabled Veteran'
	   WHEN [FirstActionLACode1] = 'LAM' THEN 'Military Spouse'
	   WHEN [FirstActionLACode1]  IN ('LEM','LJM') THEN 'Peace Corp/Vista'
	   WHEN [PayRateDeterminant] IN ('5','6','7') THEN 'Superior Qualifications'
	   ELSE 'Other Accession' END AS 'Special Appointment Authorities'
,CASE WHEN [FirstActionLADesc1] LIKE 'Sch A%' THEN 'SCHEDULE A'
      WHEN [FirstActionLADesc1] LIKE 'Sch B%' THEN 'SCHEDULE B'
	  WHEN [FirstActionLADesc1] LIKE 'Sch C%' THEN 'SCHEDULE C'
	  WHEN [FirstActionLADesc1] LIKE 'Sch D%' THEN 'SCHEDULE D'
	  WHEN [FirstActionLADesc1] LIKE 'OPM%DE%' THEN 'OPM Delegated Agreement'
	  WHEN [FirstActionLADesc1] LIKE 'Direct%Hire%' THEN 'Direct Hire Authority'
	  ELSE 'Non Schedule Appt' END  AS 'General Appt Desc'
,[ToPositionAgencyCodeSubelementDescription]
,[ToOfficeSymbol]
,[ToPPSeriesGrade]
,[PayRateDeterminant]
,[PayRateDeterminantDesc]
,[ToRegion]
,[ToServicingRegion]
,[ToPOI]
,[DutyStationNameandStateCountry]
FROM     dbo.TransactionsHistory LEFT OUTER JOIN
                  dbo.Person ON dbo.TransactionsHistory.PersonID = dbo.Person.PersonID
WHERE 
LEFT([NOAC_AND_DESCRIPTION],1) LIKE '1%' OR LEFT([NOAC_AND_DESCRIPTION],1) LIKE '5%'
AND [FYDESIGNATION] >= 'FY2000'

--ORDER BY [FYDESIGNATION] DESC,  [EffectiveDate] DESC
 

GO
