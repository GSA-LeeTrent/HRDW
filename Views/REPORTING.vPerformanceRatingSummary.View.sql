USE [HRDW]
GO
/****** Object:  View [REPORTING].[vPerformanceRatingSummary]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [REPORTING].[vPerformanceRatingSummary]
    AS 
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-08-04  
-- Description: Created view 
-- =============================================================================

-- ----------------------------------------- 2016 ----------------------------------------------
SELECT DISTINCT
------------------------------
-- Person
------------------------------
  p.PersonID
, perf.RunDate
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName
, posI.PayPlan+'-'+posI.[PositionSeries]+'-'+posI.Grade as PPSeriesGrade 
, posI.PositionEncumberedType
, posD.LatestHireDate
, posD.LatestSeparationDate
, posI.[OfficeSymbol]
, s.[PosOrgAgySubelementDescription] as HSSO 
, pos.[PosOrgAgySubelementCode]
, po.PersonnelOfficeDescription
, pos.BargainingUnitStatusCode		
, pos.BargainingUnitStatusDescription
, pay.TotalPay
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor
, perf.[FiscalYearRating] AS APPAS_FY
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] = 'GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [MID Yr Rating]
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] ='GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[AppraisalTypeDescription] = 'Annual'
	       AND
		   perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [Annual Rating]
, perf.[OverallRating] AS CurrOverallRating
, perf.RatingPeriodStartDate
, perf.RatingPeriodEndDate
, perf.High3Flag 
, t.NOAC_AND_DESCRIPTION
, t.ReasonForSeparationDesc
, t.EffectiveDate
, t.AwardType

from dbo.Person p

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
	and pos.RecordDate = 
		(select Max(pos1.RecordDate) from dbo.Position pos1 where pos1.PersonID = pos.PersonID)	
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)

inner join dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId		

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId
	and (
		posI.PositionEncumberedType = 'Employee Permanent' 
		or 
		posI.PositionEncumberedType = 'Employee Temporary'
		or
		posI.PositionEncumberedType = 'EX-Employee Permanent'
		)	

inner join dbo.Financials f
	on f.FinancialsID = pos.FinancialsID

inner join dbo.PersonnelOffice po		
	on po.PersonnelOfficeID = pos.PersonnelOfficeID

inner join dbo.Pay pay
	on pay.PayID = pos.PayID

-- getting supervisor's names
left outer join Person p1
	on p1.PersonID = posI.SupervisorID

-- join lookup table for Office Symbol
left outer join dbo.OfficeLkup		
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s  	
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

-- join BusLkup for BargainingUnitOrg
LEFT OUTER JOIN BusLkup bus					
	ON pos.BargainingUnitStatusCode = bus.BargainingUnitStatusCode

-- join PerformanceRating for Performance info

INNER JOIN PerformanceRating perf ON
 	 p.PersonID = perf.PersonID
	 and
	 perf.FiscalYearRating = 'FY2016'
	 AND
	 perf.RunDate = (select max(perf2.RunDate) from PerformanceRating perf2
					 where perf2.PersonID = perf.PersonID
					 	   and
						   perf2.FiscalYearRating = 'FY2016'
					)
LEFT OUTER JOIN dbo.Transactions t
	ON t.PersonID = p.PersonID
	   AND 
	   (
	   LEFT(t.[NOAC_AND_DESCRIPTION],3) IN ('846','849','892')
	   OR
	   t.AwardType IN ('G6','G0','GT','GS')
	   )
	   AND
	   LEFT(t.ToPPSeriesGrade,2) NOT IN ('EX','ES','SL','CA','IG','AD')
	   AND
	   t.ToPositionAgencyCodeSubelement <> 'GS15'
	   AND
	   t.EffectiveDate BETWEEN perf.RatingPeriodStartDate AND perf.RatingPeriodEndDate
--	   AND 
--	   t.RunDate = (SELECT MAX(t1.RunDate) from Transactions t1 where t1.PersonID = t.PersonID)

-- ----------------------------------------- 2015 ----------------------------------------------
UNION
SELECT DISTINCT
------------------------------
-- Person
------------------------------
  p.PersonID
, perf.RunDate
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName
, posI.PayPlan+'-'+posI.[PositionSeries]+'-'+posI.Grade as PPSeriesGrade 
, posI.PositionEncumberedType
, posD.LatestHireDate
, posD.LatestSeparationDate
, posI.[OfficeSymbol]
, s.[PosOrgAgySubelementDescription] as HSSO 
, pos.[PosOrgAgySubelementCode]
, po.PersonnelOfficeDescription
, pos.BargainingUnitStatusCode		
, pos.BargainingUnitStatusDescription
, pay.TotalPay
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor
, perf.[FiscalYearRating] AS APPAS_FY
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] = 'GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [MID Yr Rating]
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] ='GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[AppraisalTypeDescription] = 'Annual'
	       AND
		   perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [Annual Rating]
, perf.[OverallRating] AS CurrOverallRating
, perf.RatingPeriodStartDate
, perf.RatingPeriodEndDate 
, perf.High3Flag 
, th.NOAC_AND_DESCRIPTION
, th.ReasonForSeparationDesc
, th.EffectiveDate
, th.AwardType

from dbo.Person p

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
	and pos.RecordDate = 
		(select Max(pos1.RecordDate) from dbo.Position pos1 where pos1.PersonID = pos.PersonID)	
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)

inner join dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId		

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId
	and (
		posI.PositionEncumberedType = 'Employee Permanent' 
		or 
		posI.PositionEncumberedType = 'Employee Temporary'
		or
		posI.PositionEncumberedType = 'EX-Employee Permanent'
		)	

inner join dbo.Financials f
	on f.FinancialsID = pos.FinancialsID

inner join dbo.PersonnelOffice po		
	on po.PersonnelOfficeID = pos.PersonnelOfficeID

inner join dbo.Pay pay
	on pay.PayID = pos.PayID

-- getting supervisor's names
left outer join Person p1
	on p1.PersonID = posI.SupervisorID

-- join lookup table for Office Symbol
left outer join dbo.OfficeLkup		
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s  	
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

-- join BusLkup for BargainingUnitOrg
LEFT OUTER JOIN BusLkup bus					
	ON pos.BargainingUnitStatusCode = bus.BargainingUnitStatusCode

-- join PerformanceRating for Performance info

INNER JOIN PerformanceRating perf ON
 	 p.PersonID = perf.PersonID
	 and
	 perf.FiscalYearRating = 'FY2015'
	 AND
	 perf.RunDate = (select max(perf2.RunDate) from PerformanceRating perf2
					 where perf2.PersonID = perf.PersonID
					 	   and
						   perf2.FiscalYearRating = 'FY2015'
					)

LEFT OUTER JOIN dbo.TransactionsHistory th
	ON th.PersonID = p.PersonID
	   AND 
	   (
	   LEFT(th.[NOAC_AND_DESCRIPTION],3) IN ('846','849','892')
	   OR
	   th.AwardType IN ('G6','G0','GT','GS')
	   )
	   AND
	   LEFT(th.ToPPSeriesGrade,2) NOT IN ('EX','ES','SL','CA','IG','AD')
	   AND
	   th.ToPositionAgencyCodeSubelement <> 'GS15'
	   AND
	   th.EffectiveDate BETWEEN perf.RatingPeriodStartDate AND perf.RatingPeriodEndDate
--	   AND 
--	   th.RunDate = (SELECT MAX(t1.RunDate) from Transactions t1 where t1.PersonID = t.PersonID)

-- ----------------------------------------- 2014 ----------------------------------------------
UNION
SELECT DISTINCT
------------------------------
-- Person
------------------------------
  p.PersonID
, perf.RunDate
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName
, posI.PayPlan+'-'+posI.[PositionSeries]+'-'+posI.Grade as PPSeriesGrade 
, posI.PositionEncumberedType
, posD.LatestHireDate
, posD.LatestSeparationDate
, posI.[OfficeSymbol]
, s.[PosOrgAgySubelementDescription] as HSSO 
, pos.[PosOrgAgySubelementCode]
, po.PersonnelOfficeDescription
, pos.BargainingUnitStatusCode		
, pos.BargainingUnitStatusDescription
, pay.TotalPay
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor
, perf.[FiscalYearRating] AS APPAS_FY
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] = 'GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [MID Yr Rating]
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] ='GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[AppraisalTypeDescription] = 'Annual'
	       AND
		   perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [Annual Rating]
, perf.[OverallRating] AS CurrOverallRating
, perf.RatingPeriodStartDate
, perf.RatingPeriodEndDate 
, perf.High3Flag 
, th.NOAC_AND_DESCRIPTION
, th.ReasonForSeparationDesc
, th.EffectiveDate
, th.AwardType

from dbo.Person p

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
	and pos.RecordDate = 
		(select Max(pos1.RecordDate) from dbo.Position pos1 where pos1.PersonID = pos.PersonID)	
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)

inner join dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId		

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId
	and (
		posI.PositionEncumberedType = 'Employee Permanent' 
		or 
		posI.PositionEncumberedType = 'Employee Temporary'
		or
		posI.PositionEncumberedType = 'EX-Employee Permanent'
		)	

inner join dbo.Financials f
	on f.FinancialsID = pos.FinancialsID

inner join dbo.PersonnelOffice po		
	on po.PersonnelOfficeID = pos.PersonnelOfficeID

inner join dbo.Pay pay
	on pay.PayID = pos.PayID

-- getting supervisor's names
left outer join Person p1
	on p1.PersonID = posI.SupervisorID

-- join lookup table for Office Symbol
left outer join dbo.OfficeLkup		
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s  	
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

-- join BusLkup for BargainingUnitOrg
LEFT OUTER JOIN BusLkup bus					
	ON pos.BargainingUnitStatusCode = bus.BargainingUnitStatusCode

-- join PerformanceRating for Performance info

INNER JOIN PerformanceRating perf ON
 	 p.PersonID = perf.PersonID
	 and
	 perf.FiscalYearRating = 'FY2014'
	 AND
	 perf.RunDate = (select max(perf2.RunDate) from PerformanceRating perf2
					 where perf2.PersonID = perf.PersonID
					 	   and
						   perf2.FiscalYearRating = 'FY2014'
					)
LEFT OUTER JOIN dbo.TransactionsHistory th
	ON th.PersonID = p.PersonID
	   AND 
	   (
	   LEFT(th.[NOAC_AND_DESCRIPTION],3) IN ('846','849','892')
	   OR
	   th.AwardType IN ('G6','G0','GT','GS')
	   )
	   AND
	   LEFT(th.ToPPSeriesGrade,2) NOT IN ('EX','ES','SL','CA','IG','AD')
	   AND
	   th.ToPositionAgencyCodeSubelement <> 'GS15'
	   AND
	   th.EffectiveDate BETWEEN perf.RatingPeriodStartDate AND perf.RatingPeriodEndDate
--	   AND 
--	   th.RunDate = (SELECT MAX(t1.RunDate) from Transactions t1 where t1.PersonID = t.PersonID)

-- ----------------------------------------- 2013 ----------------------------------------------
UNION
SELECT DISTINCT
------------------------------
-- Person
------------------------------
  p.PersonID
, perf.RunDate
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName
, posI.PayPlan+'-'+posI.[PositionSeries]+'-'+posI.Grade as PPSeriesGrade 
, posI.PositionEncumberedType
, posD.LatestHireDate
, posD.LatestSeparationDate
, posI.[OfficeSymbol]
, s.[PosOrgAgySubelementDescription] as HSSO 
, pos.[PosOrgAgySubelementCode]
, po.PersonnelOfficeDescription
, pos.BargainingUnitStatusCode		
, pos.BargainingUnitStatusDescription
, pay.TotalPay
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor
, perf.[FiscalYearRating] AS APPAS_FY
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] = 'GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [MID Yr Rating]
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] ='GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[AppraisalTypeDescription] = 'Annual'
	       AND
		   perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [Annual Rating]
, perf.[OverallRating] AS CurrOverallRating
, perf.RatingPeriodStartDate
, perf.RatingPeriodEndDate 
, perf.High3Flag 
, th.NOAC_AND_DESCRIPTION
, th.ReasonForSeparationDesc
, th.EffectiveDate
, th.AwardType

from dbo.Person p

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
	and pos.RecordDate = 
		(select Max(pos1.RecordDate) from dbo.Position pos1 where pos1.PersonID = pos.PersonID)	
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)

inner join dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId		

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId
	and (
		posI.PositionEncumberedType = 'Employee Permanent' 
		or 
		posI.PositionEncumberedType = 'Employee Temporary'
		or
		posI.PositionEncumberedType = 'EX-Employee Permanent'
		)	

inner join dbo.Financials f
	on f.FinancialsID = pos.FinancialsID

inner join dbo.PersonnelOffice po		
	on po.PersonnelOfficeID = pos.PersonnelOfficeID

inner join dbo.Pay pay
	on pay.PayID = pos.PayID

-- getting supervisor's names
left outer join Person p1
	on p1.PersonID = posI.SupervisorID

-- join lookup table for Office Symbol
left outer join dbo.OfficeLkup		
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s  	
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

-- join BusLkup for BargainingUnitOrg
LEFT OUTER JOIN BusLkup bus					
	ON pos.BargainingUnitStatusCode = bus.BargainingUnitStatusCode

-- join PerformanceRating for Performance info

INNER JOIN PerformanceRating perf ON
 	 p.PersonID = perf.PersonID
	 and
	 perf.FiscalYearRating = 'FY2013'
	 AND
	 perf.RunDate = (select max(perf2.RunDate) from PerformanceRating perf2
					 where perf2.PersonID = perf.PersonID
					 	   and
						   perf2.FiscalYearRating = 'FY2013'
					)
LEFT OUTER JOIN dbo.TransactionsHistory th
	ON th.PersonID = p.PersonID
	   AND 
	   (
	   LEFT(th.[NOAC_AND_DESCRIPTION],3) IN ('846','849','892')
	   OR
	   th.AwardType IN ('G6','G0','GT','GS')
	   )
	   AND
	   LEFT(th.ToPPSeriesGrade,2) NOT IN ('EX','ES','SL','CA','IG','AD')
	   AND
	   th.ToPositionAgencyCodeSubelement <> 'GS15'
	   AND
	   th.EffectiveDate BETWEEN perf.RatingPeriodStartDate AND perf.RatingPeriodEndDate
--	   AND 
--	   th.RunDate = (SELECT MAX(t1.RunDate) from Transactions t1 where t1.PersonID = t.PersonID)

-- ----------------------------------------- 2012 ----------------------------------------------
UNION
SELECT DISTINCT
------------------------------
-- Person
------------------------------
  p.PersonID
, perf.RunDate
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName
, posI.PayPlan+'-'+posI.[PositionSeries]+'-'+posI.Grade as PPSeriesGrade 
, posI.PositionEncumberedType
, posD.LatestHireDate
, posD.LatestSeparationDate
, posI.[OfficeSymbol]
, s.[PosOrgAgySubelementDescription] as HSSO 
, pos.[PosOrgAgySubelementCode]
, po.PersonnelOfficeDescription
, pos.BargainingUnitStatusCode		
, pos.BargainingUnitStatusDescription
, pay.TotalPay
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor
, perf.[FiscalYearRating] AS APPAS_FY
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] = 'GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [MID Yr Rating]
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] ='GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[AppraisalTypeDescription] = 'Annual'
	       AND
		   perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [Annual Rating]
, perf.[OverallRating] AS CurrOverallRating
, perf.RatingPeriodStartDate
, perf.RatingPeriodEndDate 
, perf.High3Flag 
, th.NOAC_AND_DESCRIPTION
, th.ReasonForSeparationDesc
, th.EffectiveDate
, th.AwardType
from dbo.Person p

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
	and pos.RecordDate = 
		(select Max(pos1.RecordDate) from dbo.Position pos1 where pos1.PersonID = pos.PersonID)	
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)

inner join dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId		

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId
	and (
		posI.PositionEncumberedType = 'Employee Permanent' 
		or 
		posI.PositionEncumberedType = 'Employee Temporary'
		or
		posI.PositionEncumberedType = 'EX-Employee Permanent'
		)	

inner join dbo.Financials f
	on f.FinancialsID = pos.FinancialsID

inner join dbo.PersonnelOffice po		
	on po.PersonnelOfficeID = pos.PersonnelOfficeID

inner join dbo.Pay pay
	on pay.PayID = pos.PayID

-- getting supervisor's names
left outer join Person p1
	on p1.PersonID = posI.SupervisorID

-- join lookup table for Office Symbol
left outer join dbo.OfficeLkup		
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s  	
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

-- join BusLkup for BargainingUnitOrg
LEFT OUTER JOIN BusLkup bus					
	ON pos.BargainingUnitStatusCode = bus.BargainingUnitStatusCode

-- join PerformanceRating for Performance info

INNER JOIN PerformanceRating perf ON
 	 p.PersonID = perf.PersonID
	 and
	 perf.FiscalYearRating = 'FY2012'
	 AND
	 perf.RunDate = (select max(perf2.RunDate) from PerformanceRating perf2
					 where perf2.PersonID = perf.PersonID
					 	   and
						   perf2.FiscalYearRating = 'FY2012'
					)
LEFT OUTER JOIN dbo.TransactionsHistory th
	ON th.PersonID = p.PersonID
	   AND 
	   (
	   LEFT(th.[NOAC_AND_DESCRIPTION],3) IN ('846','849','892')
	   OR
	   th.AwardType IN ('G6','G0','GT','GS')
	   )
	   AND
	   LEFT(th.ToPPSeriesGrade,2) NOT IN ('EX','ES','SL','CA','IG','AD')
	   AND
	   th.ToPositionAgencyCodeSubelement <> 'GS15'
	   AND
	   th.EffectiveDate BETWEEN perf.RatingPeriodStartDate AND perf.RatingPeriodEndDate
--	   AND 
--	   th.RunDate = (SELECT MAX(t1.RunDate) from Transactions t1 where t1.PersonID = t.PersonID)

-- ----------------------------------------- 2011 ----------------------------------------------
UNION
SELECT DISTINCT
------------------------------
-- Person
------------------------------
  p.PersonID
, perf.RunDate
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName
, posI.PayPlan+'-'+posI.[PositionSeries]+'-'+posI.Grade as PPSeriesGrade 
, posI.PositionEncumberedType
, posD.LatestHireDate
, posD.LatestSeparationDate
, posI.[OfficeSymbol]
, s.[PosOrgAgySubelementDescription] as HSSO 
, pos.[PosOrgAgySubelementCode]
, po.PersonnelOfficeDescription
, pos.BargainingUnitStatusCode		
, pos.BargainingUnitStatusDescription
, pay.TotalPay
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor
, perf.[FiscalYearRating] AS APPAS_FY
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] = 'GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [MID Yr Rating]
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] ='GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[AppraisalTypeDescription] = 'Annual'
	       AND
		   perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [Annual Rating]
, perf.[OverallRating] AS CurrOverallRating
, perf.RatingPeriodStartDate
, perf.RatingPeriodEndDate 
, perf.High3Flag 
, th.NOAC_AND_DESCRIPTION
, th.ReasonForSeparationDesc
, th.EffectiveDate
, th.AwardType

from dbo.Person p

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
	and pos.RecordDate = 
		(select Max(pos1.RecordDate) from dbo.Position pos1 where pos1.PersonID = pos.PersonID)	
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)

inner join dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId		

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId
	and (
		posI.PositionEncumberedType = 'Employee Permanent' 
		or 
		posI.PositionEncumberedType = 'Employee Temporary'
		or
		posI.PositionEncumberedType = 'EX-Employee Permanent'
		)	

inner join dbo.Financials f
	on f.FinancialsID = pos.FinancialsID

inner join dbo.PersonnelOffice po		
	on po.PersonnelOfficeID = pos.PersonnelOfficeID

inner join dbo.Pay pay
	on pay.PayID = pos.PayID

-- getting supervisor's names
left outer join Person p1
	on p1.PersonID = posI.SupervisorID

-- join lookup table for Office Symbol
left outer join dbo.OfficeLkup		
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s  	
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

-- join BusLkup for BargainingUnitOrg
LEFT OUTER JOIN BusLkup bus					
	ON pos.BargainingUnitStatusCode = bus.BargainingUnitStatusCode

-- join PerformanceRating for Performance info

INNER JOIN PerformanceRating perf ON
 	 p.PersonID = perf.PersonID
	 and
	 perf.FiscalYearRating = 'FY2011'
	 AND
	 perf.RunDate = (select max(perf2.RunDate) from PerformanceRating perf2
					 where perf2.PersonID = perf.PersonID
					 	   and
						   perf2.FiscalYearRating = 'FY2011'
					)
LEFT OUTER JOIN dbo.TransactionsHistory th
	ON th.PersonID = p.PersonID
	   AND 
	   (
	   LEFT(th.[NOAC_AND_DESCRIPTION],3) IN ('846','849','892')
	   OR
	   th.AwardType IN ('G6','G0','GT','GS')
	   )
	   AND
	   LEFT(th.ToPPSeriesGrade,2) NOT IN ('EX','ES','SL','CA','IG','AD')
	   AND
	   th.ToPositionAgencyCodeSubelement <> 'GS15'
	   AND
	   th.EffectiveDate BETWEEN perf.RatingPeriodStartDate AND perf.RatingPeriodEndDate
--	   AND 
--	   th.RunDate = (SELECT MAX(t1.RunDate) from Transactions t1 where t1.PersonID = t.PersonID)

-- ----------------------------------------- 2010 ----------------------------------------------
UNION
SELECT DISTINCT
------------------------------
-- Person
------------------------------
  p.PersonID
, perf.RunDate
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName
, posI.PayPlan+'-'+posI.[PositionSeries]+'-'+posI.Grade as PPSeriesGrade 
, posI.PositionEncumberedType
, posD.LatestHireDate
, posD.LatestSeparationDate
, posI.[OfficeSymbol]
, s.[PosOrgAgySubelementDescription] as HSSO 
, pos.[PosOrgAgySubelementCode]
, po.PersonnelOfficeDescription
, pos.BargainingUnitStatusCode		
, pos.BargainingUnitStatusDescription
, pay.TotalPay
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor
, perf.[FiscalYearRating] AS APPAS_FY
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] = 'GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [MID Yr Rating]
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] ='GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[AppraisalTypeDescription] = 'Annual'
	       AND
		   perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [Annual Rating]
, perf.[OverallRating] AS CurrOverallRating
, perf.RatingPeriodStartDate
, perf.RatingPeriodEndDate 
, perf.High3Flag 
, th.NOAC_AND_DESCRIPTION
, th.ReasonForSeparationDesc
, th.EffectiveDate
, th.AwardType

from dbo.Person p

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
	and pos.RecordDate = 
		(select Max(pos1.RecordDate) from dbo.Position pos1 where pos1.PersonID = pos.PersonID)	
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)

inner join dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId		

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId
	and (
		posI.PositionEncumberedType = 'Employee Permanent' 
		or 
		posI.PositionEncumberedType = 'Employee Temporary'
		or
		posI.PositionEncumberedType = 'EX-Employee Permanent'
		)	

inner join dbo.Financials f
	on f.FinancialsID = pos.FinancialsID

inner join dbo.PersonnelOffice po		
	on po.PersonnelOfficeID = pos.PersonnelOfficeID

inner join dbo.Pay pay
	on pay.PayID = pos.PayID

-- getting supervisor's names
left outer join Person p1
	on p1.PersonID = posI.SupervisorID

-- join lookup table for Office Symbol
left outer join dbo.OfficeLkup		
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s  	
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

-- join BusLkup for BargainingUnitOrg
LEFT OUTER JOIN BusLkup bus					
	ON pos.BargainingUnitStatusCode = bus.BargainingUnitStatusCode

-- join PerformanceRating for Performance info

INNER JOIN PerformanceRating perf ON
 	 p.PersonID = perf.PersonID
	 and
	 perf.FiscalYearRating = 'FY2010'
	 AND
	 perf.RunDate = (select max(perf2.RunDate) from PerformanceRating perf2
					 where perf2.PersonID = perf.PersonID
					 	   and
						   perf2.FiscalYearRating = 'FY2010'
					)
LEFT OUTER JOIN dbo.TransactionsHistory th
	ON th.PersonID = p.PersonID
	   AND 
	   (
	   LEFT(th.[NOAC_AND_DESCRIPTION],3) IN ('846','849','892')
	   OR
	   th.AwardType IN ('G6','G0','GT','GS')
	   )
	   AND
	   LEFT(th.ToPPSeriesGrade,2) NOT IN ('EX','ES','SL','CA','IG','AD')
	   AND
	   th.ToPositionAgencyCodeSubelement <> 'GS15'
	   AND
	   th.EffectiveDate BETWEEN perf.RatingPeriodStartDate AND perf.RatingPeriodEndDate
--	   AND 
--	   th.RunDate = (SELECT MAX(t1.RunDate) from Transactions t1 where t1.PersonID = t.PersonID)

-- ----------------------------------------- 2009 ----------------------------------------------
UNION
SELECT DISTINCT
------------------------------
-- Person
------------------------------
  p.PersonID
, perf.RunDate
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName
, posI.PayPlan+'-'+posI.[PositionSeries]+'-'+posI.Grade as PPSeriesGrade 
, posI.PositionEncumberedType
, posD.LatestHireDate
, posD.LatestSeparationDate
, posI.[OfficeSymbol]
, s.[PosOrgAgySubelementDescription] as HSSO 
, pos.[PosOrgAgySubelementCode]
, po.PersonnelOfficeDescription
, pos.BargainingUnitStatusCode		
, pos.BargainingUnitStatusDescription
, pay.TotalPay
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor
, perf.[FiscalYearRating] AS APPAS_FY
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] = 'GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Mid-Year' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [MID Yr Rating]
, CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] ='GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf.[AppraisalTypeDescription] = 'Annual'
	       AND
		   perf.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf.[AppraisalTypeDescription] = 'Annual' AND perf.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
  END AS [Annual Rating]
, perf.[OverallRating] AS CurrOverallRating
, perf.RatingPeriodStartDate
, perf.RatingPeriodEndDate 
, perf.High3Flag 
, th.NOAC_AND_DESCRIPTION
, th.ReasonForSeparationDesc
, th.EffectiveDate
, th.AwardType

from dbo.Person p

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
	and pos.RecordDate = 
		(select Max(pos1.RecordDate) from dbo.Position pos1 where pos1.PersonID = pos.PersonID)	
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)

inner join dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId		

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId
	and (
		posI.PositionEncumberedType = 'Employee Permanent' 
		or 
		posI.PositionEncumberedType = 'Employee Temporary'
		or
		posI.PositionEncumberedType = 'EX-Employee Permanent'
		)	

inner join dbo.Financials f
	on f.FinancialsID = pos.FinancialsID

inner join dbo.PersonnelOffice po		
	on po.PersonnelOfficeID = pos.PersonnelOfficeID

inner join dbo.Pay pay
	on pay.PayID = pos.PayID

-- getting supervisor's names
left outer join Person p1
	on p1.PersonID = posI.SupervisorID

-- join lookup table for Office Symbol
left outer join dbo.OfficeLkup		
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s  	
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

-- join BusLkup for BargainingUnitOrg
LEFT OUTER JOIN BusLkup bus					
	ON pos.BargainingUnitStatusCode = bus.BargainingUnitStatusCode

-- join PerformanceRating for Performance info

INNER JOIN PerformanceRating perf ON
 	 p.PersonID = perf.PersonID
	 and
	 perf.FiscalYearRating = 'FY2009'
	 AND
	 perf.RunDate = (select max(perf2.RunDate) from PerformanceRating perf2
					 where perf2.PersonID = perf.PersonID
					 	   and
						   perf2.FiscalYearRating = 'FY2009'
					)
LEFT OUTER JOIN dbo.TransactionsHistory th
	ON th.PersonID = p.PersonID
	   AND 
	   (
	   LEFT(th.[NOAC_AND_DESCRIPTION],3) IN ('846','849','892')
	   OR
	   th.AwardType IN ('G6','G0','GT','GS')
	   )
	   AND
	   LEFT(th.ToPPSeriesGrade,2) NOT IN ('EX','ES','SL','CA','IG','AD')
	   AND
	   th.ToPositionAgencyCodeSubelement <> 'GS15'
	   AND
	   th.EffectiveDate BETWEEN perf.RatingPeriodStartDate AND perf.RatingPeriodEndDate
--	   AND 
--	   th.RunDate = (SELECT MAX(t1.RunDate) from Transactions t1 where t1.PersonID = t.PersonID)


GO
