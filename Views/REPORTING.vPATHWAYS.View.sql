USE [HRDW]
GO
/****** Object:  View [REPORTING].[vPATHWAYS]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--Created by Ralph Silvestro 2018-01-17
--PATHWAYS

CREATE VIEW [REPORTING].[vPATHWAYS]

AS
SELECT [PersonID],[EffectiveDate],[FYDESIGNATION], [NOAC_AND_DESCRIPTION],[NOAC_AND_DESCRIPTION_2], [FirstActionLACode1],[FirstActionLADesc1]
[AppointmentTypeDesc],[ToPositionTitle],[ToPPSeriesGrade],[PathwaysProgramStartDate], [PathwaysProgramEndDate]
,[PathwaysProgramExtnEndDate], [SCEP_STEP_PMF]
,CASE --WHEN [FirstActionLADesc1] LIKE '%Sch D%' 
--AND LEFT ([NOAC_AND_DESCRIPTION],3) IN ('170','171','570','571')THEN 'PATHWAYS'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) BETWEEN '100' AND '199' AND [FirstActionLACode1] IN ('Y1M','Y2M','Y3M','YBM','YGM') THEN 'SCEP-Student Career Experience Program'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) BETWEEN '100' AND '199' AND [FirstActionLACode1] IN ('Y1K','Y2K','Y3K','Y4K','Y5K') THEN 'STEP-Student Temporary Employment Program'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) BETWEEN '100' AND '199' AND [FirstActionLACode1] ='YCM' THEN 'FCIP-Federal Career Intern Program'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) BETWEEN '100' AND '199' AND [FirstActionLACode1] ='X9M' THEN 'PMF-Presidential Management Fellows'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) IN ('170','171','570','571') AND [FirstActionLACode1] ='YEA' THEN 'Internship Program of the Pathways Program'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) IN ('170','570') AND [FirstActionLACode1] IN ('YEB','YEP') THEN 'Recent Graduate of the Pathways Program'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) IN ('170','570') AND [FirstActionLACode1] IN ('YEC','YER','YES','YEH') THEN 'Presidential Management Fellows Program of the Pathways Program'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) ='570' AND [FirstActionLACode1] ='YEF' THEN 'Is currently serving on a SCEP appt which is being converted to an appt under the Internship Program of the Pathways Programs under Sch D'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) ='571' AND [FirstActionLACode1] ='YEG' THEN 'Is currently serving on a STEP appt which is being converted to an appt under the Internship Program of the Pathways Programs under Sch D'
ELSE'Other' END AS 'PATHWAYS'
,LEFT([ToPPSeriesGrade],2) AS 'JustPP'
,[ToPositionAgencyCodeSubelement]
,[ToPositionAgencyCodeSubelementDescription]
from [dbo].[TransactionsHistory]
where [FYDESIGNATION] between 'FY2000' and 'FY2016'
AND ([FirstActionLADesc1] LIKE '%Sch D%' AND LEFT ([NOAC_AND_DESCRIPTION],3) IN ('170','171','570','571')
OR 
(LEFT ([NOAC_AND_DESCRIPTION],3) BETWEEN '100' AND '199' AND [FirstActionLACode1] IN  ('Y1M','Y2M','Y3M','YBM','YGM','Y1K','Y2K','Y3K','Y4K','Y5K','YCM','X9M'))
OR (LEFT ([NOAC_AND_DESCRIPTION],3) IN ('170','171','570','571') AND [FirstActionLACode1] IN ('YEA','YEB','YEC','YEP','YER','YES','YEF','YEG','YEH')))

UNION

SELECT [PersonID],[EffectiveDate],[FYDESIGNATION], [NOAC_AND_DESCRIPTION],[NOAC_AND_DESCRIPTION_2], [FirstActionLACode1],[FirstActionLADesc1]
[AppointmentTypeDesc],[ToPositionTitle],[ToPPSeriesGrade],[PathwaysProgramStartDate], [PathwaysProgramEndDate]
,[PathwaysProgramExtnEndDate], [SCEP_STEP_PMF]
,CASE --WHEN [FirstActionLADesc1] LIKE '%Sch D%' 
--AND LEFT ([NOAC_AND_DESCRIPTION],3) IN ('170','171','570','571')THEN 'PATHWAYS'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) BETWEEN '100' AND '199' AND [FirstActionLACode1] IN ('Y1M','Y2M','Y3M','YBM','YGM') THEN 'SCEP-Student Career Experience Program'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) BETWEEN '100' AND '199' AND [FirstActionLACode1] IN ('Y1K','Y2K','Y3K','Y4K','Y5K') THEN 'STEP-Student Temporary Employment Program'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) BETWEEN '100' AND '199' AND [FirstActionLACode1] ='YCM' THEN 'FCIP-Federal Career Intern Program'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) BETWEEN '100' AND '199' AND [FirstActionLACode1] ='X9M' THEN 'PMF-Presidential Management Fellows'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) IN ('170','171','570','571') AND [FirstActionLACode1] ='YEA' THEN 'Internship Program of the Pathways Program'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) IN ('170','570') AND [FirstActionLACode1] IN ('YEB','YEP') THEN 'Recent Graduate of the Pathways Program'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) IN ('170','570') AND [FirstActionLACode1] IN ('YEC','YER','YES','YEH') THEN 'Presidential Management Fellows Program of the Pathways Program'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) ='570' AND [FirstActionLACode1] ='YEF' THEN 'Is currently serving on a SCEP appt which is being converted to an appt under the Internship Program of the Pathways Programs under Sch D'
WHEN LEFT ([NOAC_AND_DESCRIPTION],3) ='571' AND [FirstActionLACode1] ='YEG' THEN 'Is currently serving on a STEP appt which is being converted to an appt under the Internship Program of the Pathways Programs under Sch D'
ELSE'Other' END AS 'PATHWAYS'
,LEFT([ToPPSeriesGrade],2) AS 'JustPP'
,[ToPositionAgencyCodeSubelement]
,[ToPositionAgencyCodeSubelementDescription]
FROM [dbo].[Transactions]
where 
 ([FirstActionLADesc1] LIKE '%Sch D%' AND LEFT ([NOAC_AND_DESCRIPTION],3) IN ('170','171','570','571')
OR 
(LEFT ([NOAC_AND_DESCRIPTION],3) BETWEEN '100' AND '199' AND [FirstActionLACode1] IN ('Y1M','Y2M','Y3M','YBM','YGM','Y1K','Y2K','Y3K','Y4K','Y5K','YCM','X9M'))
OR (LEFT ([NOAC_AND_DESCRIPTION],3) IN ('170','171','570','571') AND [FirstActionLACode1] IN ('YEA','YEB','YEC','YEP','YER','YES','YEF','YEG','YEH')))
AND  [RunDate]=(SELECT MAX([RunDate]) FROM [dbo].[Transactions] )





GO
