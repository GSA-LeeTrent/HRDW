USE [HRDW]
GO
/****** Object:  View [REPORTING].[vDETAILSCENARIOPART1]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [REPORTING].[vDETAILSCENARIOPART1] AS 

SELECT 

DISTINCT 
      [Transactions].[PersonID]
	  ,[SSN]
	  ,CONCAT ([SSN],[EffectiveDate],CASE  
	  WHEN RIGHT([NOAC_AND_DESCRIPTION_2],3) = 'NTE' THEN NULL
	  WHEN [NOAC_AND_DESCRIPTION_2] IS NULL THEN NULL--Magic------
	  WHEN RIGHT([NOAC_AND_DESCRIPTION_2],3) = '' THEN NULL
	  WHEN LEFT([NOAC_AND_DESCRIPTION_2],3) IN ('730','731','930','931') 
	  THEN CAST(RIGHT([NOAC_AND_DESCRIPTION_2],11) AS DATE )
	  WHEN LEFT([NOAC_AND_DESCRIPTION_2],3) IN ('732','932') THEN NULL
	  ELSE '' END ) AS DetailUniqueID
	  ,[LastName] 
	  ,[FirstName]
	  ,[MiddleName] 
	  ,ISNULL([LastName] , ' ') + ', '+ ISNULL([FirstName] , ' ') +', '+ + ISNULL([MiddleName] , ' ') as 'Employee Name'
     ,[EffectiveDate] AS 'Detail Start Date aka Eff Dte of Trans'
	  , CASE  
	  WHEN RIGHT([NOAC_AND_DESCRIPTION_2],3) = 'NTE' THEN NULL
	  WHEN [NOAC_AND_DESCRIPTION_2] IS NULL THEN NULL--Magic------
	  WHEN RIGHT([NOAC_AND_DESCRIPTION_2],3) = '' THEN NULL
	  WHEN LEFT([NOAC_AND_DESCRIPTION_2],3) IN ('730','731','930','931') 
	  THEN CAST(RIGHT([NOAC_AND_DESCRIPTION_2],11) AS DATE )
	  WHEN LEFT([NOAC_AND_DESCRIPTION_2],3) IN ('732','932') THEN NULL
	  ELSE '' END AS 'Detail End Date from Desc Section'
	 --, FORMAT(CAST(RIGHT([NOAC_AND_DESCRIPTION_2],11) AS DATE ), 'yyyy-MM-dd') as 'Test'
	 
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
WHEN [EffectiveDate] BETWEEN '2017-10-01' AND '2018-09-30' THEN 'FY2018'
WHEN [EffectiveDate] BETWEEN '2018-10-01' AND '2019-09-30' THEN 'FY2019'
ELSE 'NPF Yet' END AS 'FYDESIGNATION'
,[HireDate]
,[FromRegion]
,[ToRegion]
      ,[FAMILY_NOACS]
      ,[NOAC_AND_DESCRIPTION]
	  ,[NOAC_AND_DESCRIPTION_2]
      ,[FirstActionLACode1]
      ,[FirstActionLADesc1]
      ,[FirstActionLACode2]
      ,[FirstActionLADesc2]
      ,[SecondNOACode]
      ,[SecondNOADesc]
      ,[FromOfficeSymbol] AS 'From Ofc Sym aka Return to after Detail Over'
      ,[ToOfficeSymbol] AS 'To Ofc Sym as mentioned both sides have same in CHRIS'
      ,[FromPositionAgencyCodeSubelementDescription]
      ,[ToPositionAgencyCodeSubelementDescription]
	  ,Right([FromPositionAgencyCodeSubelementDescription],6) AS 'FromHSSO'
	  ,Right([ToPositionAgencyCodeSubelementDescription],6) AS 'ToHSSO'
      ,[WhatKindofMovement]
      ,[FromPPSeriesGrade]
      ,[ToPPSeriesGrade]
      ,[FromPositionTitle]
      ,[ToPositionTitle]
	  , [DutyStationNameandStateCountry]
	  , FORMAT([FromBasicPay],'c') AS 'From Basic Pay'
, FORMAT([ToBasicPay],'c') AS 'To Basic Pay'
, FORMAT([FromAdjustedBasicPay],'c') AS 'From Adj Basic Pay'
, FORMAT([ToAdjustedBasicPay],'c') AS 'To Adj Basic Pay'
, FORMAT([FromTotalPay],'c') AS 'From Total Pay'
, FORMAT([ToTotalPay],'c') AS 'To Total Pay'
      FROM 

	   dbo.Person RIGHT OUTER JOIN
        [dbo].[Transactions] ON dbo.Person.PersonID = Transactions.PersonID
  WHERE LEFT([NOAC_AND_DESCRIPTION],3) IN ('730','731','732','930','931','932')

UNION

SELECT 

DISTINCT 
      [TransactionsHistory].[PersonID]
	  ,[SSN]
	  ,CONCAT ([SSN],[EffectiveDate],CASE  
	  WHEN RIGHT([NOAC_AND_DESCRIPTION_2],3) = 'NTE' THEN NULL
	  WHEN [NOAC_AND_DESCRIPTION_2] IS NULL THEN NULL--Magic------
	  WHEN RIGHT([NOAC_AND_DESCRIPTION_2],3) = '' THEN NULL
	  WHEN LEFT([NOAC_AND_DESCRIPTION_2],3) IN ('730','731','930','931') 
	  THEN CAST(RIGHT([NOAC_AND_DESCRIPTION_2],11) AS DATE )
	  WHEN LEFT([NOAC_AND_DESCRIPTION_2],3) IN ('732','932') THEN NULL
	  ELSE '' END ) AS DetailUniqueID
	  ,[LastName] 
	  ,[FirstName]
	  ,[MiddleName] 
	  ,ISNULL([LastName] , ' ') + ', '+ ISNULL([FirstName] , ' ') +', '+ + ISNULL([MiddleName] , ' ') as 'Employee Name'
     ,[EffectiveDate] AS 'Detail Start Date aka Eff Dte of Trans'
	  , CASE  
	  WHEN RIGHT([NOAC_AND_DESCRIPTION_2],3) = 'NTE' THEN NULL
	  WHEN [NOAC_AND_DESCRIPTION_2] IS NULL THEN NULL--Magic------
	  WHEN RIGHT([NOAC_AND_DESCRIPTION_2],3) = '' THEN NULL
	  WHEN LEFT([NOAC_AND_DESCRIPTION_2],3) IN ('730','731','930','931') 
	  THEN CAST(RIGHT([NOAC_AND_DESCRIPTION_2],11) AS DATE )
	  WHEN LEFT([NOAC_AND_DESCRIPTION_2],3) IN ('732','932') THEN NULL
	  ELSE '' END AS 'Detail End Date from Desc Section'
	 --, FORMAT(CAST(RIGHT([NOAC_AND_DESCRIPTION_2],11) AS DATE ), 'yyyy-MM-dd') as 'Test'
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
WHEN [EffectiveDate] BETWEEN '2017-10-01' AND '2018-09-30' THEN 'FY2018'
WHEN [EffectiveDate] BETWEEN '2018-10-01' AND '2019-09-30' THEN 'FY2019'
ELSE 'NPF Yet' END AS 'FYDESIGNATION'
,[HireDate]
,[FromRegion]
,[ToRegion]
      ,[FAMILY_NOACS]
      ,[NOAC_AND_DESCRIPTION]
	  ,[NOAC_AND_DESCRIPTION_2]
      ,[FirstActionLACode1]
      ,[FirstActionLADesc1]
      ,[FirstActionLACode2]
      ,[FirstActionLADesc2]
      ,[SecondNOACode]
      ,[SecondNOADesc]
      ,[FromOfficeSymbol] AS 'From Ofc Sym aka Return to after Detail Over'
      ,[ToOfficeSymbol] AS 'To Ofc Sym as mentioned both sides have same in CHRIS'
      ,[FromPositionAgencyCodeSubelementDescription]
      ,[ToPositionAgencyCodeSubelementDescription]
	  ,Right([FromPositionAgencyCodeSubelementDescription],6) AS 'FromHSSO'
	  ,Right([ToPositionAgencyCodeSubelementDescription],6) AS 'ToHSSO'
      ,[WhatKindofMovement]
      ,[FromPPSeriesGrade]
      ,[ToPPSeriesGrade]
      ,[FromPositionTitle]
      ,[ToPositionTitle]
	  ,[DutyStationNameandStateCountry]
	  , FORMAT([FromBasicPay],'c') AS 'From Basic Pay'
, FORMAT([ToBasicPay],'c') AS 'To Basic Pay'
, FORMAT([FromAdjustedBasicPay],'c') AS 'From Adj Basic Pay'
, FORMAT([ToAdjustedBasicPay],'c') AS 'To Adj Basic Pay'
, FORMAT([FromTotalPay],'c') AS 'From Total Pay'
, FORMAT([ToTotalPay],'c') AS 'To Total Pay'
      FROM 

	   dbo.Person RIGHT OUTER JOIN
        [dbo].[TransactionsHistory] ON dbo.Person.PersonID = TransactionsHistory.PersonID
  WHERE LEFT([NOAC_AND_DESCRIPTION],3) IN ('730','731','732','930','931','932')






GO
