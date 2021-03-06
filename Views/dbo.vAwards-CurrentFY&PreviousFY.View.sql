USE [HRDW]
GO
/****** Object:  View [dbo].[vAwards-CurrentFY&PreviousFY]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vAwards-CurrentFY&PreviousFY]
AS
SELECT
	  DB_NAME() AS [Database]
	, FORMAT(GETDATE(), 'M/dd/yyyy', 'en-US') AS 'Run Date'
	, dbo.[Transactions].FYDESIGNATION
	, LastName + ', ' + FirstName + ' ' + IsNull(MiddleName, '') as FullName	 
	, LEFT(dbo.[Transactions].FromPPSeriesGrade, 2) AS [From PP]
	, LEFT(dbo.[Transactions].ToPPSeriesGrade, 2) AS [To PP]
	, RIGHT(dbo.[Transactions].FromPPSeriesGrade, 2) AS [From Grade]
	, RIGHT(dbo.[Transactions].ToPPSeriesGrade, 2) AS [To Grade]
	, dbo.PositionInfo.PositionEncumberedType AS [Posn Employee Type]
	, FORMAT(dbo.[Transactions].HireDate, 'M/dd/yyyy', 'en-US') AS [Latest Hire Dte]
	, CASE 
		WHEN dbo.[PositionDate].LatestSeparationDate IS NULL 
		THEN ' ' 
		ELSE FORMAT(dbo.[PositionDate].LatestSeparationDate, 'M/dd/yyyy', 'en-US') 
      END AS [Latest Separation Date]
	, dbo.[Transactions].ToOfficeSymbol AS [Ofc Symbol]
	, Offlkup.OfficeSymbol2Char AS [2 Letter]
	, dbo.[Transactions].AwardAppropriationCode AS [Awd Approp Code]
	, SUBSTRING(RIGHT(dbo.[Transactions].ToPositionAgencyCodeSubelementDescription, 5), 1, 4) AS [HSSO Code]
	, dbo.[Transactions].ToPositionAgencyCodeSubelementDescription AS HSSO
	, dbo.[Transactions].ToPOI AS POID
	, dbo.PoiLkup.PersonnelOfficeIDDescription AS [POID Desc]
	, dbo.[Transactions].AwardType AS [Awd Type]
	, dbo.[Transactions].AwardTypeDesc AS [Awd Type Desc]
	, dbo.[Transactions].AwardUOM AS [Awd UOM]
	, dbo.[Transactions].AwardAmount AS [Awd Amt]
	, FORMAT(dbo.[Transactions].EffectiveDate, 'M/dd/yyyy', 'en-US') AS [Action Eff Dte]
	, FORMAT(dbo.[Transactions].ProcessedDate, 'M/dd/yyyy', 'en-US') AS [Processed Dte]
	, LEFT(dbo.[Transactions].NOAC_AND_DESCRIPTION, 3) AS [First NOA Code]
	, SUBSTRING(dbo.[Transactions].NOAC_AND_DESCRIPTION, 7, 50) AS [First NOA Desc]
	, dbo.[Transactions].FirstActionLACode1
	, dbo.[Transactions].FirstActionLADesc1
	, dbo.[Transactions].ToSupervisoryStatusDesc
	, dbo.[Transactions].ToBargainingUnitStatusDesc
	, dbo.Person.EmailAddress 
FROM
	dbo.Person 
		INNER JOIN dbo.Position					ON dbo.Person.PersonID = dbo.Position.PersonID 
		INNER JOIN dbo.PositionInfo				ON dbo.Position.ChrisPositionID = dbo.PositionInfo.PositionInfoID 
		LEFT OUTER JOIN dbo.PositionDate		ON dbo.Position.PositionDateID = dbo.PositionDate.PositionDateID 
		LEFT OUTER JOIN dbo.[Transactions]	ON dbo.Person.PersonID = dbo.[Transactions].PersonID
		LEFT OUTER JOIN dbo.OfficeLkup offlkup	ON offlkup.OfficeSymbol = dbo.[Transactions].ToOfficeSymbol 
		LEFT OUTER JOIN dbo.PoiLkup			ON dbo.PoiLkup.PersonnelOfficeID = dbo.[Transactions].ToPOI
		--INNER JOIN Person p ON p.PersonID = t.PersonID 
 WHERE 
	(dbo.Position.RecordDate = (SELECT MAX(p1.RecordDate) FROM dbo.Position p1)) 
	AND [RunDate]=(SELECT MAX([RunDate]) AS MAXRECDDTE FROM [dbo].[Transactions])
	AND 
	(dbo.[Transactions].FAMILY_NOACS = 'NOAC 800 Family Transactions') 
	AND 
	(
	FYDESIGNATION = 'FY'+ dbo.Riv_fn_ComputeFiscalYear(GETDATE()) 
	OR 
	FYDESIGNATION = 'FY'+ cast( dbo.Riv_fn_ComputeFiscalYear(GETDATE())-1 as varchar(4) ) 
	)
	AND 
	(LEFT(dbo.[Transactions].NOAC_AND_DESCRIPTION, 3) IN ('840', '841', '846', '847', '849', '878', '879')) 
	AND 
	(NOT (dbo.PositionInfo.PayPlan IN ('EX', 'ES', 'SL', 'IG', 'CA', 'AD'))) 
	AND 
    (dbo.Position.PosOrgAgySubelementCode <> 'GS15')

GO
