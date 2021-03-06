USE [HRDW]
GO
/****** Object:  View [REPORTING].[vEmployeeCounts1985FYForward]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [REPORTING].[vEmployeeCounts1985FYForward]
as
SELECT [RecordDate], COUNT(*) AS 'Employee Count'
FROM [LegacyCHRISBUSINTEL].[CHRISBI_930FY2004_2016]
WHERE [EncumberedType] IN ('Employee Permanent','Employee Temporary')
GROUP BY [RecordDate] 
UNION
SELECT [RecordDate], COUNT(*) AS 'Employee Count'--Remember PIRS CA only current employees
FROM [LegacyPirsChrisbo].[PIRS_CA_9-30-Year (85, 89, 90-2000)]
--Note Encumbered Type didn;t exist yet in PIRS(Personnel Information Resources System)
GROUP BY [RecordDate]
UNION--NOTICE THE RESERVE WORD UNION TO COMBINE MULTIPLE DATA SETS
SELECT [RecordDate], COUNT(*) AS 'Employee Count'--Remember there is only active employees
FROM [LegacyPirsChrisbo].[CHRISBO_9302000_2001_2002_2003]
--Note Encumbered Type didn;t exist yet in CHRISBO
GROUP BY [RecordDate]
--ORDER BY [RecordDate] DESC


GO
