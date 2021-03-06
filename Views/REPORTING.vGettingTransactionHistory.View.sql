USE [HRDW]
GO
/****** Object:  View [REPORTING].[vGettingTransactionHistory]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CREATED BY RALPH SILVESTRO 8-25-2016

CREATE VIEW [REPORTING].[vGettingTransactionHistory]
 AS 

SELECT DB_NAME() AS [Database]
, FORMAT(GETDATE()
, 'M/dd/yyyy', 'en-US') AS [Record Date DB ]
, [PersonID]
, LEFT(FromPPSeriesGrade, 2) AS [From PP]
, LEFT(ToPPSeriesGrade, 2) AS [To PP]
, RIGHT(FromPPSeriesGrade, 2) AS [From Grade]
, RIGHT(ToPPSeriesGrade, 2) AS [To Grade]
-- dbo.PositionInfo.PositionEncumberedType AS [Posn Employee Type]
--, FORMAT(dbo.[vChrisTrans-All ].HireDate, 'M/dd/yyyy', 'en-US') AS [Latest Hire Dte]
--, CASE WHEN dbo.[PositionDate].LatestSeparationDate IS NULL 
--  THEN ' ' ELSE FORMAT(dbo.[PositionDate].LatestSeparationDate, 'M/dd/yyyy', 'en-US') END AS [Latest Separation Date]
--,dbo.[vChrisTrans-All ].ToOfficeSymbol AS [Ofc Symbol]
--, OfficeLkup_1.OfficeSymbol2Char AS [2 Letter]
, [AwardAppropriationCode]

, SUBSTRING(RIGHT(ToPositionAgencyCodeSubelementDescription, 5), 1, 4)  AS [HSSO Code]
, ToPositionAgencyCodeSubelementDescription AS HSSO
, ToPOI AS POID
, [FromRegion]
, [ToRegion]
--, PersonnelOfficeIDDescription AS [POID Desc]
, AwardType AS [Awd Type]
, AwardTypeDesc AS [Awd Type Desc]
, AwardUOM AS [Awd UOM]
, AwardAmount AS [Awd Amt]

, FORMAT(EffectiveDate, 'M/dd/yyyy', 'en-US') AS [Action Eff Dte]
, FORMAT(ProcessedDate, 'M/dd/yyyy', 'en-US') AS [Processed Dte]
, LEFT(NOAC_AND_DESCRIPTION, 3) AS [First NOA Code]
, SUBSTRING(NOAC_AND_DESCRIPTION, 7, 50) AS [First NOA Desc]
, FirstActionLACode1
, FirstActionLADesc1
, ToSupervisoryStatusDesc
, ToBargainingUnitStatusDesc
--, dbo.Person.EmailAddress
,[DutyStationNameandStateCountry]


FROM [dbo].[TransactionsHistory]
WHERE [dbo].[TransactionsHistory].FAMILY_NOACS = 'NOAC 800 Family Transactions'
 AND  LEFT([dbo].[TransactionsHistory].NOAC_AND_DESCRIPTION, 3) IN ('840', '841','846', '847', '849', '878', '879')
 AND NOT (LEFT([dbo].[TransactionsHistory]. [ToPPSeriesGrade],2) IN ('EX', 'ES', 'SL', 'IG', 'CA', 'AD'))
 AND ([dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelementDescription] <> 'Office of Inspector General (GS15)')


UNION

SELECT DB_NAME() AS [Database]
, FORMAT(GETDATE()
, 'M/dd/yyyy', 'en-US') AS [Record Date DB ]
, [PersonID]
, LEFT(FromPPSeriesGrade, 2) AS [From PP]
, LEFT(ToPPSeriesGrade, 2) AS [To PP]
, RIGHT(FromPPSeriesGrade, 2) AS [From Grade]
, RIGHT(ToPPSeriesGrade, 2) AS [To Grade]
-- dbo.PositionInfo.PositionEncumberedType AS [Posn Employee Type]
--, FORMAT(dbo.[vChrisTrans-All ].HireDate, 'M/dd/yyyy', 'en-US') AS [Latest Hire Dte]
--, CASE WHEN dbo.[PositionDate].LatestSeparationDate IS NULL 
--  THEN ' ' ELSE FORMAT(dbo.[PositionDate].LatestSeparationDate, 'M/dd/yyyy', 'en-US') END AS [Latest Separation Date]
--,dbo.[vChrisTrans-All ].ToOfficeSymbol AS [Ofc Symbol]
--, OfficeLkup_1.OfficeSymbol2Char AS [2 Letter]
, [AwardAppropriationCode]

, SUBSTRING(RIGHT(ToPositionAgencyCodeSubelementDescription, 5), 1, 4)  AS [HSSO Code]
, ToPositionAgencyCodeSubelementDescription AS HSSO
, ToPOI AS POID
, [FromRegion]
, [ToRegion]
--, PersonnelOfficeIDDescription AS [POID Desc]
, AwardType AS [Awd Type]
, AwardTypeDesc AS [Awd Type Desc]
, AwardUOM AS [Awd UOM]
, AwardAmount AS [Awd Amt]

, FORMAT(EffectiveDate, 'M/dd/yyyy', 'en-US') AS [Action Eff Dte]
, FORMAT(ProcessedDate, 'M/dd/yyyy', 'en-US') AS [Processed Dte]
, LEFT(NOAC_AND_DESCRIPTION, 3) AS [First NOA Code]
, SUBSTRING(NOAC_AND_DESCRIPTION, 7, 50) AS [First NOA Desc]
, FirstActionLACode1
, FirstActionLADesc1
, ToSupervisoryStatusDesc
, ToBargainingUnitStatusDesc
--, dbo.Person.EmailAddress
,[DutyStationNameandStateCountry]

FROM [dbo].[Transactions]
WHERE [dbo].[Transactions].FAMILY_NOACS = 'NOAC 800 Family Transactions'
 AND  LEFT([dbo].[Transactions].NOAC_AND_DESCRIPTION, 3) IN ('840', '841','846', '847', '849', '878', '879')
 AND NOT (LEFT([dbo].[Transactions]. [ToPPSeriesGrade],2) IN ('EX', 'ES', 'SL', 'IG', 'CA', 'AD'))
 AND ([dbo].[Transactions].[ToPositionAgencyCodeSubelementDescription] <> 'Office of Inspector General (GS15)')
 
  
	 
GO
