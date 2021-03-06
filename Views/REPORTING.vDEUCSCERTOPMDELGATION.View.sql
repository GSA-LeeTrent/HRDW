USE [HRDW]
GO
/****** Object:  View [REPORTING].[vDEUCSCERTOPMDELGATION]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





--Created by Ralph Silvestro 2018-01-17
--Looks at DEU, CS Certificate, Direct Hire, OPM Delegation Agreement
--Delegated examining authority is an authority OPM grants to agencies to fill competitive civil
--service jobs with:
--• Applicants applying from outside the Federal workforce,
--• Federal employees who do not have competitive service status, or
--• Federal employees with competitive service status. 

CREATE VIEW [REPORTING].[vDEUCSCERTOPMDELGATION]
AS 

SELECT [PersonID],[EffectiveDate],[FYDESIGNATION], [NOAC_AND_DESCRIPTION], [FirstActionLACode1],[FirstActionLADesc1],[FirstActionLACode2],[FirstActionLADesc2]
,[AppointmentTypeDesc],[ToPositionTitle],[ToPPSeriesGrade]
,CASE WHEN [FirstActionLADesc1] LIKE '%DEU%' THEN 'Competitive Examining-Delegated Examing Authority'
when [FirstActionLADesc1] LIKE '%Delegated%' THEN 'Competitive Examining-Delegated Examing Authority'
WHEN [FirstActionLADesc1] LIKE '%CS%Certificate%' THEN 'Competitive Examining-OPM Civil Cervice Certificate'
WHEN [FirstActionLADesc1] LIKE '%Direct Hire%' THEN 'DHA-Direct Hire Recruiting Authority'
WHEN [FirstActionLADesc1] LIKE '%Direct%' THEN 'DHA-Direct Hire Recruiting Authority'
WHEN [FirstActionLADesc1] LIKE '%ACWA%' THEN 'Administrative Careers With America'
WHEN [FirstActionLADesc1] LIKE '%MPP%' THEN 'Merit Promotion Plan'
WHEN [FirstActionLADesc1] LIKE '%Merit%' THEN 'Merit Promotion Plan'
ELSE'Other' END AS 'DEU-CS Certificate or DHA'
,LEFT([ToPPSeriesGrade],2) AS 'JustPP'
,[ToPositionAgencyCodeSubelement]
,[ToPositionAgencyCodeSubelementDescription]
from [dbo].[TransactionsHistory]
where [FYDESIGNATION] between 'FY2000' and 'FY2016'
AND (LEFT([NOAC_AND_DESCRIPTION],1) LIKE '1%'
OR LEFT([NOAC_AND_DESCRIPTION],1) LIKE '5%')
AND (
[FirstActionLADesc1] LIKE '%DEU%'
OR [FirstActionLADesc1] LIKE '%Delegated%' 
OR [FirstActionLADesc1] LIKE '%CS%Certificate%'
OR [FirstActionLADesc1] LIKE '%Direct Hire%'
OR [FirstActionLADesc1] LIKE '%Direct%'
OR [FirstActionLADesc1] LIKE '%ACWA%'
OR [FirstActionLADesc1] LIKE '%MPP%'
OR [FirstActionLADesc1] LIKE '%Merit%')




UNION

SELECT [PersonID],[EffectiveDate],[FYDESIGNATION], [NOAC_AND_DESCRIPTION], [FirstActionLACode1],[FirstActionLADesc1],[FirstActionLACode2],[FirstActionLADesc2]
,[AppointmentTypeDesc],[ToPositionTitle],[ToPPSeriesGrade]
,CASE WHEN [FirstActionLADesc1] LIKE '%DEU%' THEN 'Competitive Examining-Delegated Examing Authority'
when [FirstActionLADesc1] LIKE '%Delegated%' THEN 'Competitive Examining-Delegated Examing Authority'
WHEN [FirstActionLADesc1] LIKE '%CS%Certificate%' THEN 'Competitive Examining-OPM Civil Cervice Certificate'
WHEN [FirstActionLADesc1] LIKE '%Direct Hire%' THEN 'DHA-Direct Hire Recruiting Authority'
WHEN [FirstActionLADesc1] LIKE '%Direct%' THEN 'DHA-Direct Hire Recruiting Authority'
WHEN [FirstActionLADesc1] LIKE '%ACWA%' THEN 'Administrative Careers With America'
WHEN [FirstActionLADesc1] LIKE '%MPP%' THEN 'Merit Promotion Plan'
WHEN [FirstActionLADesc1] LIKE '%Merit%' THEN 'Merit Promotion Plan'
ELSE'Other' END AS 'DEU-CS Certificate or DHA'
,LEFT([ToPPSeriesGrade],2) AS 'JustPP'
,[ToPositionAgencyCodeSubelement]
,[ToPositionAgencyCodeSubelementDescription]
FROM [dbo].[Transactions]
WHERE(
[FirstActionLADesc1] LIKE '%DEU%'
OR [FirstActionLADesc1] LIKE '%Delegated%' 
OR [FirstActionLADesc1] LIKE '%CS%Certificate%'
OR [FirstActionLADesc1] LIKE '%Direct Hire%'
OR [FirstActionLADesc1] LIKE '%Direct%'
OR [FirstActionLADesc1] LIKE '%ACWA%'
OR [FirstActionLADesc1] LIKE '%MPP%'
OR [FirstActionLADesc1] LIKE '%Merit%')
AND  [RunDate]=(SELECT MAX([RunDate]) FROM [dbo].[Transactions] )
AND (LEFT([NOAC_AND_DESCRIPTION],1) LIKE '1%'
OR LEFT([NOAC_AND_DESCRIPTION],1) LIKE '5%')






GO
