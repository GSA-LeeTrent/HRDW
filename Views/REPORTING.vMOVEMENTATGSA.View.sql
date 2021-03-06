USE [HRDW]
GO
/****** Object:  View [REPORTING].[vMOVEMENTATGSA]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







--Created by Ralph Silvestro 10-24-2016
--Movement at GSA

CREATE VIEW [REPORTING].[vMOVEMENTATGSA] AS
(SELECT DISTINCT DB_NAME() AS [Database]
, FORMAT(GETDATE()
, 'M/dd/yyyy', 'en-US') AS [Record Date DB ]
, [PersonID]
, LEFT(FromPPSeriesGrade, 2) AS [From PP]
, LEFT(ToPPSeriesGrade, 2) AS [To PP]
,SUBSTRING(FromPPSeriesGrade,4,4) AS 'From Series'
,SUBSTRING(ToPPSeriesGrade,4,4) AS 'To Series'
, RIGHT(FromPPSeriesGrade, 2) AS [From Grade]
, RIGHT(ToPPSeriesGrade, 2) AS [To Grade]
, SUBSTRING(RIGHT(FromPositionAgencyCodeSubelementDescription, 5), 1, 4)  AS 'From HSSO CD'
, SUBSTRING(RIGHT(ToPositionAgencyCodeSubelementDescription, 5), 1, 4)  AS 'To HSSO CD'
, FromPositionAgencyCodeSubelementDescription as 'From HSSO'
, ToPositionAgencyCodeSubelementDescription AS 'To HSSO'
, ToPOI AS POID
, [FromRegion]
, [ToRegion]
,[FromOfficeSymbol]
, [ToOfficeSymbol]
, FORMAT(EffectiveDate, 'M/dd/yyyy', 'en-US') AS [Action Eff Dte]
, FORMAT(ProcessedDate, 'M/dd/yyyy', 'en-US') AS [Processed Dte]
,CASE WHEN [EffectiveDate] BETWEEN '2000-10-01' AND '2001-09-30' THEN 'FY2001'
WHEN [EffectiveDate] BETWEEN '2001-10-01' AND '2002-09-30' THEN 'FY2002'
WHEN [EffectiveDate] BETWEEN '2002-10-01' AND '2003-09-30' THEN 'FY2003'
WHEN [EffectiveDate] BETWEEN '2003-10-01' AND '2004-09-30' THEN 'FY2004'
WHEN [EffectiveDate] BETWEEN '2004-10-01' AND '2005-09-30' THEN 'FY2005'
WHEN [EffectiveDate] BETWEEN '2005-10-01' AND '2006-09-30' THEN 'FY2006'
WHEN [EffectiveDate] BETWEEN '2006-10-01' AND '2007-09-30' THEN 'FY2007'
WHEN [EffectiveDate] BETWEEN '2007-10-01' AND '2008-09-30' THEN 'FY2008'
WHEN [EffectiveDate] BETWEEN '2008-10-01' AND '2009-09-30' THEN 'FY2009'
WHEN [EffectiveDate] BETWEEN '2009-10-01' AND '2010-09-30' THEN 'FY2010'
WHEN [EffectiveDate] BETWEEN '2010-10-01' AND '2011-09-30' THEN 'FY2011'
WHEN [EffectiveDate] BETWEEN '2011-10-01' AND '2012-09-30' THEN 'FY2012'
WHEN [EffectiveDate] BETWEEN '2012-10-01' AND '2013-09-30' THEN 'FY2013'
WHEN [EffectiveDate] BETWEEN '2013-10-01' AND '2014-09-30' THEN 'FY2014'
WHEN [EffectiveDate] BETWEEN '2014-10-01' AND '2015-09-30' THEN 'FY2015'
WHEN [EffectiveDate] BETWEEN '2015-10-01' AND '2016-09-30' THEN 'FY2016'
WHEN [EffectiveDate] BETWEEN '2016-10-01' AND '2017-09-30' THEN 'FY2017'
ELSE 'NPF Yet' END AS 'FYDESIGNATION'
, LEFT(NOAC_AND_DESCRIPTION, 3) AS [First NOA Code]
, SUBSTRING(NOAC_AND_DESCRIPTION, 7, 50) AS [First NOA Desc]
, FirstActionLACode1
, FirstActionLADesc1
, ToSupervisoryStatusDesc
, ToBargainingUnitStatusDesc
,[DutyStationNameandStateCountry]
,[WhatKindofMovement]

FROM [dbo].[TransactionsHistory]
WHERE (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '1%') --Permanent
      OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '2%') --Permanent
	  OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '3%')--Permanent
	  OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '4%') --Permanent
      OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '5%')--Permanent
	  OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '6%') --Permanent
      OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '7%') --Permanent
      OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '9%') --Permanent
	  
UNION

SELECT DISTINCT DB_NAME() AS [Database]
, FORMAT(GETDATE()
, 'M/dd/yyyy', 'en-US') AS [Record Date DB ]
, [PersonID]
, LEFT(FromPPSeriesGrade, 2) AS [From PP]
, LEFT(ToPPSeriesGrade, 2) AS [To PP]
,SUBSTRING(FromPPSeriesGrade,4,4) AS 'From Series'
,SUBSTRING(ToPPSeriesGrade,4,4) AS 'To Series'
, RIGHT(FromPPSeriesGrade, 2) AS [From Grade]
, RIGHT(ToPPSeriesGrade, 2) AS [To Grade]
, SUBSTRING(RIGHT(FromPositionAgencyCodeSubelementDescription, 5), 1, 4)  AS 'From HSSO CD'
, SUBSTRING(RIGHT(ToPositionAgencyCodeSubelementDescription, 5), 1, 4)  AS 'To HSSO CD'
, FromPositionAgencyCodeSubelementDescription as 'From HSSO'
, ToPositionAgencyCodeSubelementDescription AS 'To HSSO'
, ToPOI AS POID
, [FromRegion]
, [ToRegion]
,[FromOfficeSymbol]
, [ToOfficeSymbol]
, FORMAT(EffectiveDate, 'M/dd/yyyy', 'en-US') AS [Action Eff Dte]
, FORMAT(ProcessedDate, 'M/dd/yyyy', 'en-US') AS [Processed Dte]
,CASE WHEN [EffectiveDate] BETWEEN '2000-10-01' AND '2001-09-30' THEN 'FY2001'
WHEN [EffectiveDate] BETWEEN '2001-10-01' AND '2002-09-30' THEN 'FY2002'
WHEN [EffectiveDate] BETWEEN '2002-10-01' AND '2003-09-30' THEN 'FY2003'
WHEN [EffectiveDate] BETWEEN '2003-10-01' AND '2004-09-30' THEN 'FY2004'
WHEN [EffectiveDate] BETWEEN '2004-10-01' AND '2005-09-30' THEN 'FY2005'
WHEN [EffectiveDate] BETWEEN '2005-10-01' AND '2006-09-30' THEN 'FY2006'
WHEN [EffectiveDate] BETWEEN '2006-10-01' AND '2007-09-30' THEN 'FY2007'
WHEN [EffectiveDate] BETWEEN '2007-10-01' AND '2008-09-30' THEN 'FY2008'
WHEN [EffectiveDate] BETWEEN '2008-10-01' AND '2009-09-30' THEN 'FY2009'
WHEN [EffectiveDate] BETWEEN '2009-10-01' AND '2010-09-30' THEN 'FY2010'
WHEN [EffectiveDate] BETWEEN '2010-10-01' AND '2011-09-30' THEN 'FY2011'
WHEN [EffectiveDate] BETWEEN '2011-10-01' AND '2012-09-30' THEN 'FY2012'
WHEN [EffectiveDate] BETWEEN '2012-10-01' AND '2013-09-30' THEN 'FY2013'
WHEN [EffectiveDate] BETWEEN '2013-10-01' AND '2014-09-30' THEN 'FY2014'
WHEN [EffectiveDate] BETWEEN '2014-10-01' AND '2015-09-30' THEN 'FY2015'
WHEN [EffectiveDate] BETWEEN '2015-10-01' AND '2016-09-30' THEN 'FY2016'
WHEN [EffectiveDate] BETWEEN '2016-10-01' AND '2017-09-30' THEN 'FY2017'
ELSE 'NPF Yet' END AS 'FYDESIGNATION'
, LEFT(NOAC_AND_DESCRIPTION, 3) AS [First NOA Code]
, SUBSTRING(NOAC_AND_DESCRIPTION, 7, 50) AS [First NOA Desc]
, FirstActionLACode1
, FirstActionLADesc1
, ToSupervisoryStatusDesc
, ToBargainingUnitStatusDesc
,[DutyStationNameandStateCountry]
,[WhatKindofMovement]
FROM [dbo].[Transactions]
WHERE (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '1%') --Permanent
      OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '2%') --Permanent
	  OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '3%')--Permanent
	  OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '4%') --Permanent
      OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '5%')--Permanent
	  OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '6%') --Permanent
      OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '7%') --Permanent
      OR (LEFT(NOAC_AND_DESCRIPTION, 1) LIKE '9%') --Permanent
	 )






GO
