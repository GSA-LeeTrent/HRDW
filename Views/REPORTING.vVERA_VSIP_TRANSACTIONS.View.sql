USE [HRDW]
GO
/****** Object:  View [REPORTING].[vVERA_VSIP_TRANSACTIONS]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [REPORTING].[vVERA_VSIP_TRANSACTIONS] AS 
SELECT 
'PII' as 'Safeguard'
, Person.LastName + ', ' + Person.FirstName + ' ' + IsNull(Person.MiddleName, '') as FullName
--,[dbo].[gsa_fn_ComputeOptionalRetirement_Emps and _ExEmps](dbo.Transactions.PersonID) AS 'ComputeOptionalRetirement'--AS IT EXISTS NOW
--,CASE  WHEN DATEPART(MM,[dbo].[gsa_fn_ComputeOptionalRetirement_Emps and _ExEmps](dbo.Transactions.PersonID)) IN('01','02','03','04','05','06','07','08','09') THEN YEAR([dbo].[gsa_fn_ComputeOptionalRetirement_Emps and _ExEmps](dbo.Transactions.PersonID))
 ----      WHEN DATEPART(MM,[dbo].[gsa_fn_ComputeOptionalRetirement_Emps and _ExEmps](dbo.Transactions.PersonID)) IN('10','11','12') THEN YEAR([dbo].[gsa_fn_ComputeOptionalRetirement_Emps and _ExEmps](dbo.Transactions.PersonID)) + 1  END AS 'FY(COR)'
--,[dbo].[gsa_fn_ComputeEarlyRetirement](dbo.Transactions.PersonID) AS 'ComputeEarlyRetirement'--AS IT EXISTS NOW
--, CASE WHEN DATEPART(MM,[dbo].[gsa_fn_ComputeEarlyRetirement](dbo.Transactions.PersonID)) IN('01','02','03','04','05','06','07','08','09') THEN YEAR([dbo].[gsa_fn_ComputeEarlyRetirement](dbo.Transactions.PersonID))
--	   WHEN DATEPART(MM,[dbo].[gsa_fn_ComputeEarlyRetirement](dbo.Transactions.PersonID)) IN('10','11','12') THEN YEAR([dbo].[gsa_fn_ComputeEarlyRetirement](dbo.Transactions.PersonID)) + 1  END AS 'FY(CER)'
, dbo.PositionDate.ComputeEarlyRetirment

,CASE WHEN DATEPART(MM,dbo.PositionDate.ComputeEarlyRetirment) IN('01','02','03','04','05','06','07','08','09') THEN YEAR(dbo.PositionDate.ComputeEarlyRetirment)
	   WHEN DATEPART(MM,dbo.PositionDate.ComputeEarlyRetirment) IN('10','11','12') THEN YEAR(dbo.PositionDate.ComputeEarlyRetirment) + 1  END AS 'FY(CER)'
, dbo.PositionDate.ComputeOptionalRetirement
,CASE WHEN DATEPART(MM,dbo.PositionDate.ComputeOptionalRetirement) IN('01','02','03','04','05','06','07','08','09') THEN YEAR(dbo.PositionDate.ComputeOptionalRetirement)
	   WHEN DATEPART(MM,dbo.PositionDate.ComputeOptionalRetirement) IN('10','11','12') THEN YEAR(dbo.PositionDate.ComputeOptionalRetirement) + 1  END AS 'FY(COR)'
,[AnnuitantIndicator]
,[AnnuitantIndicatorDesc]
,[PayRateDeterminant]
,[PayRateDeterminantDesc]
,[HireDate]
,[VeteransStatusDescription]
,[VeteransPreferenceDescription]
,[GenderDescription]
,[HandicapCode]
,[HandicapCodeDescription]
,[RNOCode]
,[RNODescription]
,[EffectiveDate]
,DATEDIFF(YEAR,[BirthDate],[EffectiveDate]) AS 'Age on Eff Dte Trans'
,CASE WHEN DATEDIFF(YEAR,[BirthDate],[EffectiveDate])<= 29 THEN '29 and Under'
      WHEN DATEDIFF(YEAR,[BirthDate],[EffectiveDate]) BETWEEN 30 AND 39 THEN '30-39'
	  WHEN DATEDIFF(YEAR,[BirthDate],[EffectiveDate]) BETWEEN 40 AND 49 THEN '40-49'
	  WHEN DATEDIFF(YEAR,[BirthDate],[EffectiveDate]) BETWEEN 50 AND 54 THEN '50-54'
	  WHEN DATEDIFF(YEAR,[BirthDate],[EffectiveDate]) BETWEEN 55 AND 64 THEN '55-64'
	  WHEN DATEDIFF(YEAR,[BirthDate],[EffectiveDate])>= 65 THEN '65 and Over'
	  ELSE ' ' END AS 'Age Groupings at eff dte'
,CASE WHEN Year([BirthDate]) BETWEEN '1883' AND '1900' THEN 'Lost Generation 1883-1900'
	  WHEN Year([BirthDate]) BETWEEN '1901' AND '1924' THEN 'Greatest Generation 1901-1924'
	  WHEN Year([BirthDate]) BETWEEN '1925'  AND '1945' THEN 'Silent Generation 1925-1945'
	  WHEN Year([BirthDate]) BETWEEN '1946' AND '1961' THEN 'Baby Boomer Generation 1946-1961'
	  WHEN Year([BirthDate]) BETWEEN '1962' AND '1981' THEN 'Generation X 1962-1981'
	  WHEN Year([BirthDate]) BETWEEN '1982' AND '1994' THEN 'Generation Y aka Millenials 1982-1994'
	  WHEN Year([BirthDate]) >= '1995' THEN 'Internet Generation >= 1995' 
	  ELSE '' END AS 'Generation Designation'
,[ProcessedDate]
,[FYDESIGNATION]
,[FAMILY_NOACS]
,[NOAC_AND_DESCRIPTION]
,[NOAC_AND_DESCRIPTION_2]
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
,[FirstActionLACode2]
,[FirstActionLADesc2]
,[SecondNOACode]
,[SecondNOADesc]
,[TenureDesc]
,[AppointmentTypeDesc]
,[TypeOfEmploymentDesc]
,[VeteransPreferenceDesc]
,[VeteransStatusDesc]
,[WorkScheduleDesc]
,[ReasonForSeparation]
,[ReasonForSeparationDesc]
,[SupvMgrProbCompletion]
,[SupvMgrProbBeginDate]
,[DateConvCareerBegins]
,[DateConvCareerDue]
,[ToAppropriationCode1]
,[Pathways]
,[SCEP_STEP_PMF]
,[Flex2]
,[PathwaysProgramStartDate]
,[PathwaysProgramEndDate]
,[PathwaysProgramExtnEndDate]
,[FromOfficeSymbol]
,[FromPositionAgencyCodeSubelement]
,[FromPositionAgencyCodeSubelementDescription]
,[ToOfficeSymbol]
,[ToPositionAgencyCodeSubelement]
,[ToPositionAgencyCodeSubelementDescription]
,[FromLongName]
,[ToLongName]
,[WhatKindofMovement]
,[FromPositionControlNumberIndicatorDescription]
,[FromPositionControlNumberIndicator]
,[FromPDNumber]
,[FromPositionSequenceNumber]
,[FromPositionTitle]
,[FromPPSeriesGrade]
,CASE WHEN SUBSTRING([FromPPSeriesGrade],4,4) ='1102' THEN 'From Acquisition'
      WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('0501','0511','0560') THEN 'From Finanical Management'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '0201' THEN 'From Human Resources'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('0391','2210') THEN 'From Information Technology'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '0340' THEN 'From Program Management'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '1176' THEN 'From Property Management'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('1170','1171') THEN 'From Realty'
	  ELSE 'FROM MSO-Mission Support Occupations' END AS 'From MCO-Mission Critical Occupations'
,CASE WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('1101','1104') THEN 'From Acquisition'
      WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('0080','0089') THEN 'From Emergency & Security'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('0801','0802','0808','0809') THEN 'From Engineering'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('0260','0360') THEN 'From Equal Opportunity' 
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN  ('0505','0510') THEN 'From Financial Management'   
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '0905' THEN 'From General Attorney'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '0306' THEN 'From Government Information' 
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '0132'  THEN 'From Intelligence'  
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '0301' THEN 'From Misc. Admin & Program'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '2150'  THEN 'From Transportation' 
	  ELSE 'From MSO-Mission Support Occupations' END  AS 'From OCO-Organizational Critical Occupations'        
,[FromStepOrRate]
,[FromPositionTargetGradeorLevel]
,[ToPositionControlNumberIndicatorDescription]
,[ToPositionControlNumberIndicator]
,[ToPositionControlNumber]
,[ToPDNumber]
,[ToPositionSequenceNumber]
,[ToPositionTitle]
,[ToPPSeriesGrade]
,CASE WHEN SUBSTRING([ToPPSeriesGrade],4,4) ='1102' THEN 'To Acquisition'
      WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('0501','0511','0560') THEN 'To Finanical Management'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '0201' THEN 'To Human Resources'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('0391','2210') THEN 'To Information Technology'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '0340' THEN 'To Program Management'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '1176' THEN 'To Property Management'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('1170','1171') THEN 'To Realty'
	  ELSE 'To MSO-Mission Support Occupations' END AS 'To MCO-Mission Critical Occupations'
,CASE WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('1101','1104') THEN 'To Acquisition'
      WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('0080','0089') THEN 'To Emergency & Security'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('0801','0802','0808','0809') THEN 'To Engineering'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('0260','0360') THEN 'To Equal Opportunity' 
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN  ('0505','0510') THEN 'To Financial Management'   
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '0905' THEN 'To General Attorney'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '0306' THEN 'To Government Information' 
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '0132'  THEN 'To Intelligence'  
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '0301' THEN 'To Misc. Admin & Program'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '2150'  THEN 'To Transportation' 
	  ELSE 'To MSO-Mission Support Occupations' END  AS 'To OCO-Organizational Critical Occupations' 
,[ToStepOrRate]
,[ToPositionTargetGradeorLevel]
,[FromPayBasis]
,[ToPayBasis]
,[FPL]
,[ToFLSACateGOry]
,[DutyStationNameandStateCountry]
,[FromRegion]
,[ToRegion]
,[FromServicingRegion]
,[ToServicingRegion]
,[ToPOI]
,[ToBargainingUnitStatusDesc]
,[FromPosSupervisorySatusDesc]
,[ToSupervisoryStatusDesc]
,[NewSupervisor]
,[NOAFamilyCode]
,[RetirementPlan]
,[RetirementPlanDesc]
,[MandatoryRetirementDate]
,[Tenure]
,[TypeOfEmployment]
,[AppointmentType]
,[AgencyCodeTransferFrom]
,[AgencyCodeTransferFromDesc]
,[AgencyCodeTransferTo]
,[AgencyCodeTransferToDesc]
,[ToDutyStationCode]
, [FromBasicPay]
, [ToBasicPay]
,[FromAdjustedBasicPay]
,[ToAdjustedBasicPay]
, [FromTotalPay]
, [ToTotalPay]
FROM     dbo.Person INNER JOIN
                  dbo.Position ON dbo.Person.PersonID = dbo.Position.PersonID INNER JOIN
                  dbo.PositionDate ON dbo.Position.PositionDateID = dbo.PositionDate.PositionDateID RIGHT OUTER JOIN
                  dbo.Transactions ON dbo.Person.PersonID = dbo.Transactions.PersonID


WHERE  (dbo.Transactions.RunDate =(SELECT MAX(RunDate) AS MaxRunDate
                       FROM      dbo.Transactions AS Transactions_1)) 
AND dbo.Position.RecordDate =(SELECT MAX([RecordDate]) AS MAXRECORDDATE FROM dbo.Position)

					   
					   AND (LEFT(dbo.Transactions.NOAC_AND_DESCRIPTION, 1) LIKE '1%' OR
                  LEFT(dbo.Transactions.NOAC_AND_DESCRIPTION, 1) LIKE '3%')
UNION







SELECT 
'PII' as 'Safeguard'
, Person.LastName + ', ' + Person.FirstName + ' ' + IsNull(Person.MiddleName, '') as FullName
--,[dbo].[gsa_fn_ComputeOptionalRetirement_Emps and _ExEmps](dbo.TransactionsHistory.PersonID) AS 'ComputeOptionalRetirement'--AS IT EXISTS NOW
--,CASE  WHEN DATEPART(MM,[dbo].[gsa_fn_ComputeOptionalRetirement_Emps and _ExEmps](dbo.TransactionsHistory.PersonID)) IN('01','02','03','04','05','06','07','08','09') THEN YEAR([dbo].[gsa_fn_ComputeOptionalRetirement_Emps and _ExEmps](dbo.TransactionsHistory.PersonID))
 ----      WHEN DATEPART(MM,[dbo].[gsa_fn_ComputeOptionalRetirement_Emps and _ExEmps](dbo.TransactionsHistory.PersonID)) IN('10','11','12') THEN YEAR([dbo].[gsa_fn_ComputeOptionalRetirement_Emps and _ExEmps](dbo.TransactionsHistory.PersonID)) + 1  END AS 'FY(COR)'
--,[dbo].[gsa_fn_ComputeEarlyRetirement](dbo.TransactionsHistory.PersonID) AS 'ComputeEarlyRetirement'--AS IT EXISTS NOW
--, CASE WHEN DATEPART(MM,[dbo].[gsa_fn_ComputeEarlyRetirement](dbo.TransactionsHistory.PersonID)) IN('01','02','03','04','05','06','07','08','09') THEN YEAR([dbo].[gsa_fn_ComputeEarlyRetirement](dbo.TransactionsHistory.PersonID))
--	   WHEN DATEPART(MM,[dbo].[gsa_fn_ComputeEarlyRetirement](dbo.TransactionsHistory.PersonID)) IN('10','11','12') THEN YEAR([dbo].[gsa_fn_ComputeEarlyRetirement](dbo.TransactionsHistory.PersonID)) + 1  END AS 'FY(CER)'
, dbo.PositionDate.ComputeEarlyRetirment
,CASE WHEN DATEPART(MM,dbo.PositionDate.ComputeEarlyRetirment) IN('01','02','03','04','05','06','07','08','09') THEN YEAR(dbo.PositionDate.ComputeEarlyRetirment)
	   WHEN DATEPART(MM,dbo.PositionDate.ComputeEarlyRetirment) IN('10','11','12') THEN YEAR(dbo.PositionDate.ComputeEarlyRetirment) + 1  END AS 'FY(CER)'
, dbo.PositionDate.ComputeOptionalRetirement
,CASE WHEN DATEPART(MM,dbo.PositionDate.ComputeOptionalRetirement) IN('01','02','03','04','05','06','07','08','09') THEN YEAR(dbo.PositionDate.ComputeOptionalRetirement)
	   WHEN DATEPART(MM,dbo.PositionDate.ComputeOptionalRetirement) IN('10','11','12') THEN YEAR(dbo.PositionDate.ComputeOptionalRetirement) + 1  END AS 'FY(COR)'
,[AnnuitantIndicator]
,[AnnuitantIndicatorDesc]
,[PayRateDeterminant]
,[PayRateDeterminantDesc]
,[HireDate]
,[VeteransStatusDescription]
,[VeteransPreferenceDescription]
,[GenderDescription]
,[HandicapCode]
,[HandicapCodeDescription]
,[RNOCode]
,[RNODescription]
,[EffectiveDate]
,DATEDIFF(YEAR,[BirthDate],[EffectiveDate]) AS 'Age on Eff Dte Trans'
,CASE WHEN DATEDIFF(YEAR,[BirthDate],[EffectiveDate])<= 29 THEN '29 and Under'
      WHEN DATEDIFF(YEAR,[BirthDate],[EffectiveDate]) BETWEEN 30 AND 39 THEN '30-39'
	  WHEN DATEDIFF(YEAR,[BirthDate],[EffectiveDate]) BETWEEN 40 AND 49 THEN '40-49'
	  WHEN DATEDIFF(YEAR,[BirthDate],[EffectiveDate]) BETWEEN 50 AND 54 THEN '50-54'
	  WHEN DATEDIFF(YEAR,[BirthDate],[EffectiveDate]) BETWEEN 55 AND 64 THEN '55-64'
	  WHEN DATEDIFF(YEAR,[BirthDate],[EffectiveDate])>= 65 THEN '65 and Over'
	  ELSE ' ' END AS 'Age Groupings at eff dte'
,CASE WHEN Year([BirthDate]) BETWEEN '1883' AND '1900' THEN 'Lost Generation 1883-1900'
	  WHEN Year([BirthDate]) BETWEEN '1901' AND '1924' THEN 'Greatest Generation 1901-1924'
	  WHEN Year([BirthDate]) BETWEEN '1925'  AND '1945' THEN 'Silent Generation 1925-1945'
	  WHEN Year([BirthDate]) BETWEEN '1946' AND '1961' THEN 'Baby Boomer Generation 1946-1961'
	  WHEN Year([BirthDate]) BETWEEN '1962' AND '1981' THEN 'Generation X 1962-1981'
	  WHEN Year([BirthDate]) BETWEEN '1982' AND '1994' THEN 'Generation Y aka Millenials 1982-1994'
	  WHEN Year([BirthDate]) >= '1995' THEN 'Internet Generation >= 1995' 
	  ELSE '' END AS 'Generation Designation'
,[ProcessedDate]
,[FYDESIGNATION]
,[FAMILY_NOACS]
,[NOAC_AND_DESCRIPTION]
,[NOAC_AND_DESCRIPTION_2]
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
,[FirstActionLACode2]
,[FirstActionLADesc2]
,[SecondNOACode]
,[SecondNOADesc]
,[TenureDesc]
,[AppointmentTypeDesc]
,[TypeOfEmploymentDesc]
,[VeteransPreferenceDesc]
,[VeteransStatusDesc]
,[WorkScheduleDesc]
,[ReasonForSeparation]
,[ReasonForSeparationDesc]
,[SupvMgrProbCompletion]
,[SupvMgrProbBeginDate]
,[DateConvCareerBegins]
,[DateConvCareerDue]
,[ToAppropriationCode1]
,[Pathways]
,[SCEP_STEP_PMF]
,[Flex2]
,[PathwaysProgramStartDate]
,[PathwaysProgramEndDate]
,[PathwaysProgramExtnEndDate]
,[FromOfficeSymbol]
,[FromPositionAgencyCodeSubelement]
,[FromPositionAgencyCodeSubelementDescription]
,[ToOfficeSymbol]
,[ToPositionAgencyCodeSubelement]
,[ToPositionAgencyCodeSubelementDescription]
,[FromLongName]
,[ToLongName]
,[WhatKindofMovement]
,[FromPositionControlNumberIndicatorDescription]
,[FromPositionControlNumberIndicator]
,[FromPDNumber]
,[FromPositionSequenceNumber]
,[FromPositionTitle]
,[FromPPSeriesGrade]
,CASE WHEN SUBSTRING([FromPPSeriesGrade],4,4) ='1102' THEN 'From Acquisition'
      WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('0501','0511','0560') THEN 'From Finanical Management'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '0201' THEN 'From Human Resources'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('0391','2210') THEN 'From Information Technology'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '0340' THEN 'From Program Management'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '1176' THEN 'From Property Management'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('1170','1171') THEN 'From Realty'
	  ELSE 'FROM MSO-Mission Support Occupations' END AS 'From MCO-Mission Critical Occupations'
,CASE WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('1101','1104') THEN 'From Acquisition'
      WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('0080','0089') THEN 'From Emergency & Security'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('0801','0802','0808','0809') THEN 'From Engineering'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN ('0260','0360') THEN 'From Equal Opportunity' 
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) IN  ('0505','0510') THEN 'From Financial Management'   
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '0905' THEN 'From General Attorney'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '0306' THEN 'From Government Information' 
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '0132'  THEN 'From Intelligence'  
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '0301' THEN 'From Misc. Admin & Program'
	  WHEN SUBSTRING([FromPPSeriesGrade],4,4) = '2150'  THEN 'From Transportation' 
	  ELSE 'From MSO-Mission Support Occupations' END  AS 'From OCO-Organizational Critical Occupations'        
,[FromStepOrRate]
,[FromPositionTargetGradeorLevel]
,[ToPositionControlNumberIndicatorDescription]
,[ToPositionControlNumberIndicator]
,[ToPositionControlNumber]
,[ToPDNumber]
,[ToPositionSequenceNumber]
,[ToPositionTitle]
,[ToPPSeriesGrade]
,CASE WHEN SUBSTRING([ToPPSeriesGrade],4,4) ='1102' THEN 'To Acquisition'
      WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('0501','0511','0560') THEN 'To Finanical Management'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '0201' THEN 'To Human Resources'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('0391','2210') THEN 'To Information Technology'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '0340' THEN 'To Program Management'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '1176' THEN 'To Property Management'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('1170','1171') THEN 'To Realty'
	  ELSE 'To MSO-Mission Support Occupations' END AS 'To MCO-Mission Critical Occupations'
,CASE WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('1101','1104') THEN 'To Acquisition'
      WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('0080','0089') THEN 'To Emergency & Security'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('0801','0802','0808','0809') THEN 'To Engineering'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN ('0260','0360') THEN 'To Equal Opportunity' 
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) IN  ('0505','0510') THEN 'To Financial Management'   
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '0905' THEN 'To General Attorney'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '0306' THEN 'To Government Information' 
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '0132'  THEN 'To Intelligence'  
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '0301' THEN 'To Misc. Admin & Program'
	  WHEN SUBSTRING([ToPPSeriesGrade],4,4) = '2150'  THEN 'To Transportation' 
	  ELSE 'To MSO-Mission Support Occupations' END  AS 'To OCO-Organizational Critical Occupations' 
,[ToStepOrRate]
,[ToPositionTargetGradeorLevel]
,[FromPayBasis]
,[ToPayBasis]
,[FPL]
,[ToFLSACateGOry]
,[DutyStationNameandStateCountry]
,[FromRegion]
,[ToRegion]
,[FromServicingRegion]
,[ToServicingRegion]
,[ToPOI]
,[ToBargainingUnitStatusDesc]
,[FromPosSupervisorySatusDesc]
,[ToSupervisoryStatusDesc]
,[NewSupervisor]
,[NOAFamilyCode]
,[RetirementPlan]
,[RetirementPlanDesc]
,[MandatoryRetirementDate]
,[Tenure]
,[TypeOfEmployment]
,[AppointmentType]
,[AgencyCodeTransferFrom]
,[AgencyCodeTransferFromDesc]
,[AgencyCodeTransferTo]
,[AgencyCodeTransferToDesc]
,[ToDutyStationCode]
, [FromBasicPay]
, [ToBasicPay]
,[FromAdjustedBasicPay]
,[ToAdjustedBasicPay]
, [FromTotalPay]
, [ToTotalPay]
FROM     dbo.Person INNER JOIN
                  dbo.Position ON dbo.Person.PersonID = dbo.Position.PersonID INNER JOIN
                  dbo.PositionDate ON dbo.Position.PositionDateID = dbo.PositionDate.PositionDateID RIGHT OUTER JOIN
                  dbo.TransactionsHistory ON dbo.Person.PersonID = dbo.TransactionsHistory.PersonID


WHERE  --(dbo.TransactionsHistory.RunDate =(SELECT MAX(RunDate) AS MaxRunDate
                   --    FROM      dbo.TransactionsHistory AS TransactionsHistory_1)) 
dbo.Position.RecordDate =(SELECT MAX([RecordDate]) AS MAXRECORDDATE FROM dbo.Position)

					   
					   AND (LEFT(dbo.TransactionsHistory.NOAC_AND_DESCRIPTION, 1) LIKE '1%' OR
                  LEFT(dbo.TransactionsHistory.NOAC_AND_DESCRIPTION, 1) LIKE '3%')
GO
