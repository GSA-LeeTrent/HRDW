USE [HRDW]
GO
/****** Object:  View [REPORTING].[vPeaceCorp_Vista_Trans]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [REPORTING].[vPeaceCorp_Vista_Trans] AS

SELECT DISTINCT 
dbo.transactions.[PersonID]
, [EffectiveDate] AS 'Eff Dte'
,CASE WHEN MONTH([EffectiveDate]) IN ('10','11','12') THEN YEAR([EffectiveDate])+1
ELSE YEAR([EffectiveDate]) END AS 'FYDESIGNATION'
, GETDATE() AS [Record Date DB ]
, [HireDate]   AS 'Hire Dte'
, [NOAC_AND_DESCRIPTION] AS 'NOA and Desc'
, [FirstActionLACode1] AS 'First Action LAC1'
, [FirstActionLADesc1] AS 'First Action LAC1 Desc'
, [ToOfficeSymbol] AS 'Ofc Sym'
, dbo.OfficeLkup.OfficeSymbol2Char AS '2 Letter Ofc Sym'
, [ToPositionAgencyCodeSubelementDescription] AS 'HSSO'
, [ToPositionControlNumber] AS 'PCN'
, [ToPositionControlNumberIndicatorDescription] AS 'PCN Desc'
, [ToPositionTitle] AS 'Posn Title'
, [ToPPSeriesGrade] AS 'PP-Series-Gr'
, dbo.PoiLkup.PersonnelOfficeIDDescription AS 'POID Desc'
, [ToRegion] AS 'Region'
, dbo.Transactions.DutyStationNameandStateCountry AS 'DS Desc'
,dbo.Person.LastName + ', ' + dbo.Person.FirstName + ', ' + ISNULL(dbo.Person.MiddleName, 
                  N'') AS [Empl Full Name]
FROM   dbo.Transactions 
       INNER JOIN
       dbo.Person ON dbo.Transactions.PersonID = dbo.Person.PersonID 
	   INNER JOIN
       dbo.OfficeLkup ON dbo.Transactions.ToOfficeSymbol = dbo.OfficeLkup.OfficeSymbol 
	   INNER JOIN
       dbo.PoiLkup ON dbo.Transactions.ToPOI = dbo.PoiLkup.PersonnelOfficeID
WHERE ([FirstActionLACode1] IN ('LJM','LEM') AND LEFT([NOAC_AND_DESCRIPTION], 3) LIKE '1%')
OR ([FirstActionLACode1] IN ('LJM','LEM') AND LEFT([NOAC_AND_DESCRIPTION], 3) LIKE '5%')
UNION 
SELECT DISTINCT 
dbo.TransactionsHistory.[PersonID]
 ,[EffectiveDate]  AS 'Eff Dte'
 ,CASE WHEN MONTH([EffectiveDate]) IN ('10','11','12') THEN YEAR([EffectiveDate])+1
ELSE YEAR([EffectiveDate]) END AS 'FYDESIGNATION'
 , GETDATE() AS [Record Date DB ]
, [HireDate]   AS 'Hire Dte'
, [NOAC_AND_DESCRIPTION] AS 'NOA and Desc'
, [FirstActionLACode1] AS 'First Action LAC1'
, [FirstActionLADesc1] AS 'First Action LAC1 Desc'
, [ToOfficeSymbol] AS 'Ofc Sym'
, dbo.OfficeLkup.OfficeSymbol2Char AS '2 Letter Ofc Sym'
, [ToPositionAgencyCodeSubelementDescription] AS 'HSSO'
, [ToPositionControlNumber] AS 'PCN'
, [ToPositionControlNumberIndicatorDescription] AS 'PCN Desc'
, [ToPositionTitle] AS 'Posn Title'
, [ToPPSeriesGrade] AS 'PP-Series-Gr'
, dbo.PoiLkup.PersonnelOfficeIDDescription AS 'POID Desc'
, [ToRegion] AS 'Region'
, dbo.TransactionsHistory.DutyStationNameandStateCountry AS 'DS Desc'
,dbo.Person.LastName + ', ' + dbo.Person.FirstName + ', ' + ISNULL(dbo.Person.MiddleName, 
                  N'') AS [Empl Full Name]
FROM   dbo.TransactionsHistory 
       INNER JOIN
       dbo.Person ON dbo.TransactionsHistory.PersonID = dbo.Person.PersonID 
	   INNER JOIN
       dbo.OfficeLkup ON dbo.TransactionsHistory.ToOfficeSymbol = dbo.OfficeLkup.OfficeSymbol 
	   INNER JOIN
       dbo.PoiLkup ON dbo.TransactionsHistory.ToPOI = dbo.PoiLkup.PersonnelOfficeID
WHERE ([FirstActionLACode1] IN ('LJM','LEM') AND LEFT([NOAC_AND_DESCRIPTION], 3) LIKE '1%')
OR ([FirstActionLACode1] IN ('LJM','LEM') AND LEFT([NOAC_AND_DESCRIPTION], 3) LIKE '5%')










GO
