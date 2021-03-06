USE [HRDW]
GO
/****** Object:  View [REPORTING].[vSeriesBeforeSES]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--What Series Employee was before SES Appointment
--CREATED by Ralph Silvestro 9-30-2016
--Using OPM Guide to Processing Personnel Transactions
--Future Enhancement-If Eopf exists from losing to gaining agency then may be able to pull data from that via CPC


CREATE VIEW [REPORTING].[vSeriesBeforeSES] AS 
SELECT 
 [PersonID]
 ,[EffectiveDate]
 ,[HireDate]
 --,[RunDate]
 ,[NOAC_AND_DESCRIPTION]
 ,[FromPositionAgencyCodeSubelementDescription]
,[ToPositionAgencyCodeSubelementDescription]
,[FromPositionTitle]
,[FromPPSeriesGrade]
,[ToPositionTitle]
,[ToPPSeriesGrade]
,LEFT([FromPPSeriesGrade],7) AS 'FROM PP-SERIES'
,LEFT([ToPPSeriesGrade],7) AS 'TO PP-SERIES'
,CASE WHEN RIGHT(LEFT([FromPPSeriesGrade],7),4) = RIGHT(LEFT([ToPPSeriesGrade],7),4)
 THEN 'No Series Chg' ELSE 'Series Chg' END AS 'Did Series Chg?'
,[WhatKindofMovement]
,'Remember HRDW starts FY2001 Forward for Transactions' as 'Note'
FROM [dbo].[TransactionsHistory]
WHERE (LEFT([FromPPSeriesGrade],2) <> 'ES' AND LEFT([ToPPSeriesGrade],2) ='ES'
AND ([NOAC_AND_DESCRIPTION] LIKE '5%') OR 
(LEFT([NOAC_AND_DESCRIPTION],3) IN ('142','143','145','146','147','148','149','190','762') AND LEFT([ToPPSeriesGrade],2)='ES'))
UNION
SELECT
  [PersonID]
  ,[EffectiveDate]
  ,[HireDate]
 -- ,CASE IF [HireDate] >= '2000-08-13' AND LEFT([NOAC_AND_DESCRIPTION],1) LIKE '5' THEN 'Precursor Series CHRIS starts from 8-13-2000 Forward 100 Transaction'
 --ELSE 'Internal GSA Action After 8-13-2000 500 Family or 762' END
-- ,[RunDate]
 ,[NOAC_AND_DESCRIPTION]
 ,[FromPositionAgencyCodeSubelementDescription]
,[ToPositionAgencyCodeSubelementDescription]
,[FromPositionTitle]
,[FromPPSeriesGrade]
,[ToPositionTitle]
,[ToPPSeriesGrade]
,LEFT([FromPPSeriesGrade],7) AS 'FROM PP-SERIES'
,LEFT([ToPPSeriesGrade],7) AS 'TO PP-SERIES'
,CASE WHEN RIGHT(LEFT([FromPPSeriesGrade],7),4) = RIGHT(LEFT([ToPPSeriesGrade],7),4)
 THEN 'No Series Chg' ELSE 'Series Chg' END AS 'Did Series Chg?'
,[WhatKindofMovement]
,'Remember HRDW starts FY2001 Forward for Transactions' as 'Note'
FROM [dbo].[Transactions]
WHERE (LEFT([FromPPSeriesGrade],2) <> 'ES' AND LEFT([ToPPSeriesGrade],2) ='ES'
AND ([NOAC_AND_DESCRIPTION] LIKE '5%') OR 
(LEFT([NOAC_AND_DESCRIPTION],3) IN ('142','143','145','146','147','148','149','190','762') AND LEFT([ToPPSeriesGrade],2)='ES'))
--ORDER BY [EffectiveDate]


GO
