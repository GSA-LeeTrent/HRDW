USE [HRDW]
GO
/****** Object:  View [REPORTING].[vGettingEXandEMPLOYEES]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--CREATED BY RALPH SILVESTRO 8-25-2016
CREATE VIEW [REPORTING].[vGettingEXandEMPLOYEES]
AS 
SELECT [PersonID]
 , [FullName]
 , [EmailAddress]
 , PositionEncumberedType AS [Posn Employee Type]
 , FORMAT([LatestHireDate], 'M/dd/yyyy', 'en-US') AS [Latest Hire Dte]
 , CASE WHEN [LatestSeparationDate] IS NULL 
   THEN ' ' ELSE FORMAT([LatestSeparationDate], 'M/dd/yyyy', 'en-US') END AS [Latest Separation Date]
, [OfficeSymbol] AS [Ofc Symbol]
, [OfficeSymbol2Char] AS [2 Letter]

FROM [dbo].[vAlphaOrgRoster-with-ExEmployees]
WHERE [PositionEncumberedType] <> 'Vacant'
GO
