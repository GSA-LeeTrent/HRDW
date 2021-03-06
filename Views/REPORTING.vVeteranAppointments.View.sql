USE [HRDW]
GO
/****** Object:  View [REPORTING].[vVeteranAppointments]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




--Created by Ralph Silvestro 2018-01-16
--This checks for VRA, Appts, etc.
--OTher Appointment Types for VRA added

CREATE VIEW [REPORTING].[vVeteranAppointments]
AS
SELECT 'PII SAFGUARD' AS 'PII', [PersonID], [EffectiveDate],[FYDESIGNATION], [AppointmentTypeDesc], [NOAC_AND_DESCRIPTION], [NOAC_AND_DESCRIPTION_2], [FirstActionLACode1],[FirstActionLADesc1]
,[VeteransPreferenceDesc],[VeteransStatusDesc]
,CASE WHEN [FirstActionLADesc1] LIKE '%Sch A%' THEN 'Sch A'
when [FirstActionLADesc1] LIKE '%Sch B%' THEN 'Sch B'
WHEN [FirstActionLADesc1] LIKE '%Sch C%' THEN 'Sch C'
WHEN [FirstActionLADesc1] LIKE '%Sch D%' THEN 'Sch D'
ELSE'Not Sch A,B,C or D' END AS 'Schedule Type'
,CASE WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('115%') AND [FirstActionLACode1] = 'NCM' THEN 'VRA-Based on eligibility for a Veterans Recruitment Appointment (VRA)'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('515%') AND [FirstActionLACode1] = 'NCM' THEN 'VRA-Based on eligibility for a Veterans Recruitment Appointment (VRA)'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('115%') AND [FirstActionLACode1] = 'NEM' THEN 'Of a disabled veteran who has a service-connected disability of 30% or more'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('515%') 
AND [FirstActionLACode1] = 'NEM' THEN 'Of a disabled veteran who has a service-connected disability of 30% or more'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('108%') AND [FirstActionLACode1] = 'MGM' THEN 'VRA-Based on person’s eligibility for a Veterans Recruitment Appointment (VRA)'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('508%') AND [FirstActionLACode1] = 'MGM' THEN 'VRA-Based on person’s eligibility for a Veterans Recruitment Appointment (VRA)'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('130%') AND [FirstActionLACode1] = 'J8M' THEN 'VRA-Is already employed under the Veterans Recruitment Appointment (VRA) in a different agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('170%') AND [FirstActionLACode1] = 'J8M' THEN 'VRA-Is being employed under the Veterans Recruitment Appointment (VRA) on an appointment without time limitation'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('171%') AND [FirstActionLACode1] = 'J8M' THEN 'VRA-Is being employed under the Veterans Recruitment Appointment (VRA) on a temporary appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('570%') AND [FirstActionLACode1] = 'J8M' THEN 'VRA-Is being employed under the Veterans Recruitment Appointment (VRA) on an appointment without time limitation'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('571%') AND [FirstActionLACode1] = 'J8M' THEN 'VRA-Is being employed under the Veterans Recruitment Appointment (VRA) on a temporary appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('500%') AND [FirstActionLACode1] = 'LYM' THEN 'VRA-Service on a Veterans Recruitment Appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('501%') AND [FirstActionLACode1] = 'LYM' THEN 'VRA-Service on a Veterans Recruitment Appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('100%') AND [FirstActionLACode1] = 'ZBA' THEN 'Veterans Employment Opportunity Act of 1998 as amended by P.L. 106-117'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('101%') AND [FirstActionLACode1] = 'ZBA' THEN 'Veterans Employment Opportunity Act of 1998 as amended by P.L. 106-117'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('500%') AND [FirstActionLACode1] = 'ZBA' THEN 'Veterans Employment Opportunity Act of 1998 as amended by P.L. 106-117'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('501%') AND [FirstActionLACode1] = 'ZBA' THEN 'Veterans Employment Opportunity Act of 1998 as amended by P.L. 106-117'
ELSE ' '  END AS 'Veteran Appt Type'
,LEFT([ToPPSeriesGrade],2) AS 'JustPP'
,[ToPPSeriesGrade]
,[ToPositionAgencyCodeSubelement]
,[ToPositionAgencyCodeSubelementDescription]
from [dbo].[TransactionsHistory]
where [FYDESIGNATION] between 'FY2000' and 'FY2016'
AND 
(LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('115%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('108%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('508%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('515%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('130%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('170%') 
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('171%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('570%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('571%') 
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('500%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('501%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('100%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('500%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('101%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('501%'))
AND [FirstActionLACode1] IN ('NCM','NEM','J8M','LYM','MGM','ZBA')


UNION

SELECT 'PII SAFGUARD' AS 'PII', [PersonID],[EffectiveDate],[FYDESIGNATION], [AppointmentTypeDesc], [NOAC_AND_DESCRIPTION],[NOAC_AND_DESCRIPTION_2], [FirstActionLACode1],[FirstActionLADesc1]
,[VeteransPreferenceDesc],[VeteransStatusDesc]
,CASE WHEN [FirstActionLADesc1] LIKE '%Sch A%' THEN 'Sch A'
when [FirstActionLADesc1] LIKE '%Sch B%' THEN 'Sch B'
WHEN [FirstActionLADesc1] LIKE '%Sch C%' THEN 'Sch C'
WHEN [FirstActionLADesc1] LIKE '%Sch D%' THEN 'Sch D'
ELSE'Not Sch A,B,C or D' END AS 'Schedule Type'
,CASE WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('115%') AND [FirstActionLACode1] = 'NCM' THEN 'VRA-Based on eligibility for a Veterans Recruitment Appointment (VRA)'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('515%') AND [FirstActionLACode1] = 'NCM' THEN 'VRA-Based on eligibility for a Veterans Recruitment Appointment (VRA)'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('115%') AND [FirstActionLACode1] = 'NEM' THEN 'Of a disabled veteran who has a service-connected disability of 30% or more'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('515%') 
AND [FirstActionLACode1] = 'NEM' THEN 'Of a disabled veteran who has a service-connected disability of 30% or more'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('108%') AND [FirstActionLACode1] = 'MGM' THEN 'VRA-Based on person’s eligibility for a Veterans Recruitment Appointment (VRA)'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('508%') AND [FirstActionLACode1] = 'MGM' THEN 'VRA-Based on person’s eligibility for a Veterans Recruitment Appointment (VRA)'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('130%') AND [FirstActionLACode1] = 'J8M' THEN 'VRA-Is already employed under the Veterans Recruitment Appointment (VRA) in a different agency'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('170%') AND [FirstActionLACode1] = 'J8M' THEN 'VRA-Is being employed under the Veterans Recruitment Appointment (VRA) on an appointment without time limitation'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('171%') AND [FirstActionLACode1] = 'J8M' THEN 'VRA-Is being employed under the Veterans Recruitment Appointment (VRA) on a temporary appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('570%') AND [FirstActionLACode1] = 'J8M' THEN 'VRA-Is being employed under the Veterans Recruitment Appointment (VRA) on an appointment without time limitation'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('571%') AND [FirstActionLACode1] = 'J8M' THEN 'VRA-Is being employed under the Veterans Recruitment Appointment (VRA) on a temporary appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('500%') AND [FirstActionLACode1] = 'LYM' THEN 'VRA-Service on a Veterans Recruitment Appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('501%') AND [FirstActionLACode1] = 'LYM' THEN 'VRA-Service on a Veterans Recruitment Appointment'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('100%') AND [FirstActionLACode1] = 'ZBA' THEN 'Veterans Employment Opportunity Act of 1998 as amended by P.L. 106-117'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('101%') AND [FirstActionLACode1] = 'ZBA' THEN 'Veterans Employment Opportunity Act of 1998 as amended by P.L. 106-117'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('500%') AND [FirstActionLACode1] = 'ZBA' THEN 'Veterans Employment Opportunity Act of 1998 as amended by P.L. 106-117'
WHEN LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('501%') AND [FirstActionLACode1] = 'ZBA' THEN 'Veterans Employment Opportunity Act of 1998 as amended by P.L. 106-117'
ELSE ' '  END AS 'Veteran Appt Type'
,LEFT([ToPPSeriesGrade],2) AS 'JustPP'
,[ToPPSeriesGrade]
,[ToPositionAgencyCodeSubelement]
,[ToPositionAgencyCodeSubelementDescription]
from [dbo].[Transactions]
where 
(LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('115%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('108%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('508%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('515%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('130%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('170%') 
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('171%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('570%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('571%') 
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('500%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('501%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('100%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('500%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('101%')
OR LEFT([NOAC_AND_DESCRIPTION],3) LIKE ('501%'))
AND [FirstActionLACode1] IN ('NCM','NEM','J8M','LYM','MGM','ZBA')
AND [RunDate] =(SELECT MAX([RunDate]) FROM [dbo].[Transactions])







GO
