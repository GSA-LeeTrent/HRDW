USE [HRDW]
GO
/****** Object:  View [REPORTING].[v3R's_SLR815-816-817-827]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [REPORTING].[v3R's_SLR815-816-817-827]
AS 

--3R's_SLR815-816-817-827
--Original creation by Raph Silvestro 3-13-2017
--Reason Created Due to HR Staffing Specialists repeatedly asking for overtime.
--Covers Multiple Time Periods from 10/01/2000 forward.
--Good to Go Checked against CHRISBI Extract 3-15-2017
--AND SIFTING THROUGH all transactions to find the specific ones of interest..
--with concentration on the information provided below
--NOAC 827	= Retention Incentive
--NOAC 817	= Student Loan Repayment
--NOAC 816	= Relocation Incentive
--NOAC 815	= Recruitment Incentive

SELECT 
'HRDW PRODUCTION' AS 'DATABASE'
,dbo.Person.LastName
, dbo.Person.FirstName
, dbo.Person.MiddleName
,dbo.Person.LastName + ', ' + dbo.Person.FirstName + ' ' + IsNull(dbo.Person.MiddleName, '') as FullName
,[EffectiveDate]
,[FYDESIGNATION]
,[ToPositionAgencyCodeSubelementDescription]
,[ToOfficeSymbol]
,[ToPPSeriesGrade]
,[NOAC_AND_DESCRIPTION]
,[NOAC_AND_DESCRIPTION_2]
,[AwardAmount]
,[IncentivePaymentOptionCode]
,[IncentivePaymentOptionDesc]
,[TotalIncentiveAmountPercent]
,[PayRateDeterminant]
,[PayRateDeterminantDesc]
,[ToRegion]
,[ToServicingRegion]
,[ToPOI]
,[DutyStationNameandStateCountry]
FROM     dbo.Transactions LEFT OUTER JOIN
                  dbo.Person ON dbo.Transactions.PersonID = dbo.Person.PersonID
WHERE 
LEFT([NOAC_AND_DESCRIPTION],3) IN ('815','816','817','827')
AND [RunDate] =(SELECT MAX([RunDate]) AS MaxRunDate FROM [dbo].[Transactions])

UNION
SELECT 
'HRDW PRODUCTION' AS 'DATABASE'
,dbo.Person.LastName
, dbo.Person.FirstName
, dbo.Person.MiddleName
,dbo.Person.LastName + ', ' + dbo.Person.FirstName + ' ' + IsNull(dbo.Person.MiddleName, '') as FullName
,[EffectiveDate]
,[FYDESIGNATION]
,[ToPositionAgencyCodeSubelementDescription]
,[ToOfficeSymbol]
,[ToPPSeriesGrade]
,[NOAC_AND_DESCRIPTION]
,[NOAC_AND_DESCRIPTION_2]
,[AwardAmount]
,[IncentivePaymentOptionCode]
,[IncentivePaymentOptionDesc]
,[TotalIncentiveAmountPercent]
,[PayRateDeterminant]
,[PayRateDeterminantDesc]
,[ToRegion]
,[ToServicingRegion]
,[ToPOI]
,[DutyStationNameandStateCountry]
FROM     dbo.TransactionsHistory LEFT OUTER JOIN
                  dbo.Person ON dbo.TransactionsHistory.PersonID = dbo.Person.PersonID
WHERE 
LEFT([NOAC_AND_DESCRIPTION],3) IN ('815','816','817','827')

 --ORDER BY [FYDESIGNATION] DESC, [EffectiveDate] DESC  
GO
