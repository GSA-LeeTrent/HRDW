USE [HRDW]
GO
/****** Object:  View [REPORTING].[v.CheckingHiringIPA-IntergovernmentalPersonnelAct]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--Created 2018-01-16 by RALPH SILVESTRO
--This checks provides how many did we hire as an IPA 
--if we have any

Create view [REPORTING].[v.CheckingHiringIPA-IntergovernmentalPersonnelAct]
AS

SELECT 'PII SAFGUARD' AS 'PII', [PersonID], [EffectiveDate],[FYDESIGNATION], [AppointmentTypeDesc], [NOAC_AND_DESCRIPTION], [NOAC_AND_DESCRIPTION_2], [FirstActionLACode1],[FirstActionLADesc1]
,CASE WHEN [FirstActionLADesc1] LIKE '%Sch A%' THEN 'Sch A'
when [FirstActionLADesc1] LIKE '%Sch B%' THEN 'Sch B'
WHEN [FirstActionLADesc1] LIKE '%Sch C%' THEN 'Sch C'
WHEN [FirstActionLADesc1] LIKE '%Sch D%' THEN 'Sch D'
ELSE'Not Sch A,B,C or D' END AS 'Schedule Type'
,LEFT([ToPPSeriesGrade],2) AS 'JustPP'
,[ToPositionAgencyCodeSubelement]
,[ToPositionAgencyCodeSubelementDescription]
from [dbo].[TransactionsHistory]
where [FYDESIGNATION] between 'FY2000' and 'FY2016'
AND LEFT([NOAC_AND_DESCRIPTION],3) ='171' 
AND [FirstActionLACode1] ='VPE'



UNION

SELECT 'PII SAFGUARD' AS 'PII', [PersonID],[EffectiveDate],[FYDESIGNATION], [AppointmentTypeDesc], [NOAC_AND_DESCRIPTION],[NOAC_AND_DESCRIPTION_2], [FirstActionLACode1],[FirstActionLADesc1]
,CASE WHEN [FirstActionLADesc1] LIKE '%Sch A%' THEN 'Sch A'
when [FirstActionLADesc1] LIKE '%Sch B%' THEN 'Sch B'
WHEN [FirstActionLADesc1] LIKE '%Sch C%' THEN 'Sch C'
WHEN [FirstActionLADesc1] LIKE '%Sch D%' THEN 'Sch D'
ELSE'Not Sch A,B,C or D' END AS 'Schedule Type'

,LEFT([ToPPSeriesGrade],2) AS 'JustPP'
,[ToPositionAgencyCodeSubelement]
,[ToPositionAgencyCodeSubelementDescription]
from [dbo].[Transactions]
where 
[RunDate] =(SELECT MAX([RunDate]) FROM [dbo].[Transactions])
AND LEFT([NOAC_AND_DESCRIPTION],3) ='171' 
AND [FirstActionLACode1] ='VPE'






GO
