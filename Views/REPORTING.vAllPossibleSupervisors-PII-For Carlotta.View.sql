USE [HRDW]
GO
/****** Object:  View [REPORTING].[vAllPossibleSupervisors-PII-For Carlotta]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [REPORTING].[vAllPossibleSupervisors-PII-For Carlotta]
AS
SELECT        TOP (100) PERCENT dbo.Person.PersonID, dbo.Person.SSN, dbo.Position.RecordDate AS [Record Date], dbo.Person.LastName AS [Supv Last], 
                         dbo.Person.FirstName AS [Supv First], dbo.Person.MiddleName AS [Supv Middle], 
                         dbo.Person.LastName + ', ' + dbo.Person.FirstName + ', ' + ISNULL(dbo.Person.MiddleName, N'') AS [Empl Full Name], 
                         dbo.PositionInfo.SupervisoryStatusDesc AS [Supv  Supv Desc], dbo.PositionInfo.PositionTitle AS [Supv Title], dbo.PositionInfo.PayPlan AS [Supv PP], 
                         dbo.PositionInfo.PositionSeries AS [Supv Series], dbo.PositionInfo.Grade AS [Supv Grade], dbo.Position.PosOrgAgySubelementDesc AS [Supv HSSO], 
                         dbo.PositionInfo.OfficeSymbol AS [Supv Ofc Sym], dbo.OfficeLkup.OfficeSymbol2Char AS [Supv 2 Letter], '$' + FORMAT(dbo.Pay.BasicSalary, 'N', 'en-us') 
                         AS [Supv  Basic Salary], '$' + FORMAT(dbo.Pay.AdjustedBasic, 'N', 'en-us') AS [Supv Adj Salary], '$' + FORMAT(dbo.Pay.TotalPay, 'N', 'en-us') AS [Supv Total Pay], 
                         dbo.Person.EmailAddress AS [Supv email]
						 ,dbo.PositionInfo.PositionControlNumber as 'Supv CPCN'
FROM            dbo.Position LEFT OUTER JOIN
                         dbo.Pay ON dbo.Position.PayID = dbo.Pay.PayID LEFT OUTER JOIN
                         dbo.Person ON dbo.Position.PersonID = dbo.Person.PersonID LEFT OUTER JOIN
                         dbo.PositionDate ON dbo.Position.PositionDateID = dbo.PositionDate.PositionDateID LEFT OUTER JOIN
                         dbo.PositionInfo ON dbo.Position.ChrisPositionID = dbo.PositionInfo.PositionInfoID LEFT OUTER JOIN
                         dbo.OfficeLkup ON dbo.PositionInfo.OfficeSymbol = dbo.OfficeLkup.OfficeSymbol
WHERE        (dbo.PositionInfo.PositionEncumberedType = 'Employee Permanent' OR
                         dbo.PositionInfo.PositionEncumberedType = 'Employee Temporary') AND (dbo.Position.RecordDate =
                             (SELECT        MAX(RecordDate) AS MaxRecDate
                               FROM            dbo.Position AS Position_1))
ORDER BY CASE WHEN dbo.PositionInfo.PayPlan = 'EX' THEN '1' WHEN dbo.PositionInfo.PayPlan = 'IG' THEN '2' WHEN dbo.PositionInfo.PayPlan = 'ES' THEN '3' WHEN dbo.PositionInfo.PayPlan
                          = 'ED' THEN '4' WHEN dbo.PositionInfo.PayPlan = 'SL' THEN '5' WHEN dbo.PositionInfo.PayPlan = 'CA' THEN '6' WHEN dbo.PositionInfo.PayPlan = 'GS' THEN '7' WHEN
                          dbo.PositionInfo.PayPlan = 'GM' THEN '8' ELSE '9' END, [Supv Grade] DESC


GO
