USE [HRDW]
GO
/****** Object:  View [REPORTING].[vDetailTransactions]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [REPORTING].[vDetailTransactions] 
AS 
SELECT DISTINCT 
 GETDATE() AS 'Recd Dte DB'
, [HireDate] AS 'Hire Dte'
, [NOAC_AND_DESCRIPTION] AS 'NOA and Desc'
, CASE WHEN [NOAC_AND_DESCRIPTION_2] IS NULL THEN ' ' ELSE [NOAC_AND_DESCRIPTION_2] END  AS 'NOA and Desc Specific'
,[EffectiveDate] AS 'Eff Dte'
,CASE WHEN [NOAC_AND_DESCRIPTION_2] LIKE ('730%') OR [NOAC_AND_DESCRIPTION_2] LIKE ('731%')  OR [NOAC_AND_DESCRIPTION_2] LIKE ('930%') OR [NOAC_AND_DESCRIPTION_2] LIKE ('931%')  THEN CONVERT(VARCHAR,RIGHT([NOAC_AND_DESCRIPTION_2],11),111) ELSE ' ' END AS 'Detail NTE Dte'--Breaks out Text Dte
,CASE WHEN [NOAC_AND_DESCRIPTION_2] LIKE ('730%') OR [NOAC_AND_DESCRIPTION_2] LIKE ('731%')  OR [NOAC_AND_DESCRIPTION_2] LIKE ('930%') OR [NOAC_AND_DESCRIPTION_2] LIKE ('931%')  THEN DATEDIFF(DD,[EffectiveDate],CONVERT(VARCHAR,RIGHT([NOAC_AND_DESCRIPTION_2],11),111))  ELSE ' ' END AS 'Detail Days Length'--Calculates Days
, [FirstActionLACode1] AS 'First Action LAC1'
, [FirstActionLADesc1] AS 'First Action LAC1 Desc'
, [FromOfficeSymbol] AS 'From Ofc Sym'
, [ToOfficeSymbol] AS 'To Ofc Sym'
, dbo.OfficeLkup.OfficeSymbol2Char AS 'To2LetterOfcSym'
, [FromPositionAgencyCodeSubelementDescription] AS 'From HSSO'
, [ToPositionAgencyCodeSubelementDescription] AS 'TO HSSO'
, [FromPositionControlNumber] AS 'From PCN'
, [ToPositionControlNumber] AS 'TO PCN'
, [FromPositionControlNumberIndicatorDescription] AS 'From PCN Desc'
, [ToPositionControlNumberIndicatorDescription] AS 'To PCN Desc'
, [FromPositionTitle] AS 'From Posn Title'
, [ToPositionTitle] AS 'To Posn Title'
, [FromPPSeriesGrade] AS 'From PP-Series-Gr'
, [ToPPSeriesGrade] AS 'To PP-Series-Gr'
, dbo.PoiLkup.PersonnelOfficeIDDescription AS 'POID Desc'
, [FromRegion] AS 'From Region'
, [ToRegion] AS 'To Region'
, dbo.Transactions.DutyStationNameandStateCountry AS 'DS Desc'
,dbo.Person.LastName + ', ' + dbo.Person.FirstName + ', ' + ISNULL(dbo.Person.MiddleName, 
                  N'') AS [Empl Full Name]
, FORMAT([FromBasicPay],'c') AS 'From Basic Pay'
, FORMAT([ToBasicPay],'c') AS 'To Basic Pay'
, FORMAT([FromAdjustedBasicPay],'c') AS 'From Adj Basic Pay'
, FORMAT([ToAdjustedBasicPay],'c') AS 'To Adj Basic Pay'
, FORMAT([FromTotalPay],'c') AS 'From Total Pay'
, FORMAT([ToTotalPay],'c') AS 'To Total Pay'
FROM   dbo.Transactions 
       INNER JOIN
       dbo.Person ON dbo.Transactions.PersonID = dbo.Person.PersonID 
	   INNER JOIN
       dbo.OfficeLkup ON dbo.Transactions.ToOfficeSymbol = dbo.OfficeLkup.OfficeSymbol 
	   INNER JOIN
       dbo.PoiLkup ON dbo.Transactions.ToPOI = dbo.PoiLkup.PersonnelOfficeID
WHERE LEFT([NOAC_AND_DESCRIPTION], 3) IN ('730','731','732','930','931','932')--Tehes eare the NOACs overtime for details.
UNION 
SELECT DISTINCT 
  GETDATE() AS 'Recd Dte DB'
, [HireDate] AS 'Hire Dte'
, [NOAC_AND_DESCRIPTION] AS 'NOA and Desc'
, CASE WHEN [NOAC_AND_DESCRIPTION_2] IS NULL THEN ' ' ELSE [NOAC_AND_DESCRIPTION_2] END  AS 'NOA and Desc Specific'
, [EffectiveDate] AS 'Eff Dte'
,CASE WHEN [NOAC_AND_DESCRIPTION_2] LIKE ('730%') OR [NOAC_AND_DESCRIPTION_2] LIKE ('731%')  OR [NOAC_AND_DESCRIPTION_2] LIKE ('930%') OR [NOAC_AND_DESCRIPTION_2] LIKE ('931%')  THEN CONVERT(VARCHAR,RIGHT([NOAC_AND_DESCRIPTION_2],11),111) ELSE ' ' END AS 'Detail NTE Dte'--Breaks out Text Dte
,CASE WHEN [NOAC_AND_DESCRIPTION_2] LIKE ('730%') OR [NOAC_AND_DESCRIPTION_2] LIKE ('731%')  OR [NOAC_AND_DESCRIPTION_2] LIKE ('930%') OR [NOAC_AND_DESCRIPTION_2] LIKE ('931%')  THEN DATEDIFF(DD,[EffectiveDate],CONVERT(VARCHAR,RIGHT([NOAC_AND_DESCRIPTION_2],11),111))  ELSE ' ' END AS 'Detail Days Length'--Calculates Days
, [FirstActionLACode1] AS 'First Action LAC1'
, [FirstActionLADesc1] AS 'First Action LAC1 Desc'
, [FromOfficeSymbol] AS 'From Ofc Sym'
, [ToOfficeSymbol] AS 'To Ofc Sym'
, dbo.OfficeLkup.OfficeSymbol2Char AS 'To Letter Ofc Sym'
--,need From 2 letter ofc symbol
, [FromPositionAgencyCodeSubelementDescription] AS 'From HSSO'
, [ToPositionAgencyCodeSubelementDescription] AS 'TO HSSO'
, [FromPositionControlNumber] AS 'From PCN'
, [ToPositionControlNumber] AS 'TO PCN'
, [FromPositionControlNumberIndicatorDescription] AS 'From PCN Desc'
, [ToPositionControlNumberIndicatorDescription] AS 'To PCN Desc'
, [FromPositionTitle] AS 'From Posn Title'
, [ToPositionTitle] AS 'To Posn Title'
, [FromPPSeriesGrade] AS 'From PP-Series-Gr'
, [ToPPSeriesGrade] AS 'To PP-Series-Gr'
, dbo.PoiLkup.PersonnelOfficeIDDescription AS 'POID Desc'
, [FromRegion] AS 'From Region'
, [ToRegion] AS 'To Region'
, dbo.TransactionsHistory.DutyStationNameandStateCountry AS 'DS Desc'
,dbo.Person.LastName + ', ' + dbo.Person.FirstName + ', ' + ISNULL(dbo.Person.MiddleName, 
                  N'') AS [Empl Full Name]
, FORMAT([FromBasicPay],'c') AS 'From Basic Pay'
, FORMAT([ToBasicPay],'c') AS 'To Basic Pay'
, FORMAT([FromAdjustedBasicPay],'c') AS 'From Adj Basic Pay'
, FORMAT([ToAdjustedBasicPay],'c') AS 'To Adj Basic Pay'
, FORMAT([FromTotalPay],'c') AS 'From Total Pay'
, FORMAT([ToTotalPay],'c') AS 'To Total Pay'
FROM   dbo.TransactionsHistory 
       INNER JOIN
       dbo.Person ON dbo.TransactionsHistory.PersonID = dbo.Person.PersonID 
	   INNER JOIN
       dbo.OfficeLkup ON dbo.TransactionsHistory.ToOfficeSymbol = dbo.OfficeLkup.OfficeSymbol 
	   INNER JOIN
       dbo.PoiLkup ON dbo.TransactionsHistory.ToPOI = dbo.PoiLkup.PersonnelOfficeID
WHERE LEFT([NOAC_AND_DESCRIPTION], 3) IN ('730','731','732','930','931','932')--Theese are the NOACs overtime for details.

;




GO
