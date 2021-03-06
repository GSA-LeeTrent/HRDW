USE [HRDW]
GO
/****** Object:  View [dbo].[vAPPAS_Info_by_Supervisor]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vAPPAS_Info_by_Supervisor]
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-05-30  
-- Description: Created a specialized subset of Roster data with APPAS info
--              including 1st and 2nd level Supervisors.
-- =============================================================================
AS 

SELECT 
  p2.LastName+', '+p2.FirstName + ' ' + ISNULL(p2.MiddleName,'') as SupervisorName_2ndLevel
, p2.EmailAddress AS SupervisorEmail_2ndLevel
, APPAS_Info.SupervisorName_1stLevel
, APPAS_Info.SupervisorEmail_1stLevel
, APPAS_Info.EmployeeFullName
, APPAS_Info.EmployeeEmail
, APPAS_Info.SupRegionBasedOnDutyStation
, APPAS_Info.APPAS_FY
, APPAS_Info.HasPP
, APPAS_Info.[Annual Rating]
, APPAS_Info.[MID Yr Rating]
, APPAS_Info.PerformancePlanIssueDate
, APPAS_Info.[OfficeSymbol2Char]
, APPAS_Info.[OfficeSymbol]
, APPAS_Info.PosOrgAgySubelementCode
, APPAS_Info.HSSO
, APPAS_Info.SsoAbbreviation
, APPAS_Info.PPSeriesGrade 
, APPAS_Info.RegionBasedOnDutyStation
, APPAS_Info.PersonnelOfficeDescription
, APPAS_Info.OwningRegion
, APPAS_Info.ServicingRegion
, APPAS_Info.WorkBuilding
, APPAS_Info.WorkAddressLine1
, APPAS_Info.WorkAddressLine2
, APPAS_Info.WorkState
, APPAS_Info.DutyStationName
, APPAS_Info.DutyStationCounty
, APPAS_Info.BargainingUnitStatusDescription
, APPAS_Info.PositionTitle
, APPAS_Info.[SupervisoryStatusDesc]
, APPAS_Info.Employee_LN
, APPAS_Info.Employee_FN
, APPAS_Info.Employee_MN
FROM
(
SELECT 
  posI.SupervisorID
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as SupervisorName_1stLevel
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as EmployeeFullName
, supdutlkup.RegionBasedOnDutyStation	AS SupRegionBasedOnDutyStation
, perf.[FiscalYearRating] AS APPAS_FY
, ppid.HasPP
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
, ppid.PerformancePlanIssueDate
, OfficeLkup.[OfficeSymbol2Char]
, posI.[OfficeSymbol]
, pos.[PosOrgAgySubelementCode]
, s.[PosOrgAgySubelementDescription] AS HSSO -- SSO lookup for Agency or PosOrgAgySubelementDesc
, s.[SsoAbbreviation]						 -- includes Abbr
, posI.PayPlan + '-' + posI.[PositionSeries] + '-' + posI.Grade AS PPSeriesGrade 
, dutlkup.RegionBasedOnDutyStation
, po.PersonnelOfficeDescription
, po.OwningRegion
, po.ServicingRegion
, pos.WorkBuilding
, pos.WorkAddressLine1
, pos.WorkAddressLine2
, pos.WorkState
, ds.DutyStationName
, ds.DutyStationCounty
, pos.BargainingUnitStatusDescription
, posI.PositionTitle
, posI.[SupervisoryStatusDesc]
, p1.EmailAddress AS SupervisorEmail_1stLevel
, p.EmailAddress AS EmployeeEmail
, p.[LastName] AS Employee_LN
, p.[FirstName] AS Employee_FN
, p.MiddleName AS Employee_MN

from dbo.Person p				

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
	and pos.RecordDate = 
--      JJM 2016-10-03 get max RecordDate for table instead of Person so that employees with changed SSNs are excluded
		(select Max(pos1.RecordDate) as MaxRecDate from dbo.Position pos1)
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) as MaxPosDateId from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)  -- 28,264 records, make sure one person only contains one Position record. If for any reason, a person has two position dates, get the latest one.

inner join dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId			--28,264 rows

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId

	and (
		posI.PositionEncumberedType = 'Employee Permanent' 
		or 
		posI.PositionEncumberedType = 'Employee Temporary'
		)	

inner join dbo.PersonnelOffice po
	on po.PersonnelOfficeID = pos.PersonnelOfficeID

LEFT OUTER JOIN dbo.DutyStation ds
	on pos.DutyStationID = ds.DutyStationID

LEFT OUTER JOIN DutyStationCodeStateRegionLkup dutlkup
	ON ds.DutyStationCode = (REPLICATE('0',9 - LEN(dutlkup.DutyStationCode)) + dutlkup.DutyStationCode)

-- getting supervisor's names
left outer join Person p1	
	on p1.PersonID = posI.SupervisorID

-- getting supervisor's position Info (phone, etc)
left outer join Position suppos
	on suppos.PersonID = posI.SupervisorID
	and suppos.RecordDate = 
		(select Max(pos3.RecordDate) from dbo.Position pos3 where pos3.PersonID = suppos.PersonID)

/* JJM 2017-05-23 Adding Supervisor Duty Station info*/
LEFT OUTER JOIN dbo.DutyStation supds
	on suppos.DutyStationID = supds.DutyStationID

LEFT OUTER JOIN DutyStationCodeStateRegionLkup supdutlkup
	ON supds.DutyStationCode = (REPLICATE('0',9 - LEN(supdutlkup.DutyStationCode)) + supdutlkup.DutyStationCode)
/* JJM 2017-05-23 End */


-- join lookup table for Office Symbol
left outer join dbo.OfficeLkup	
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

-- join BusLkup for BargainingUnitOrg
LEFT OUTER JOIN BusLkup bus					--JJM 2016-04-13 Added
	ON pos.BargainingUnitStatusCode = bus.BargainingUnitStatusCode

-- join PPID for HasPP
LEFT OUTER JOIN PPID ppid					--JJM 2016-04-13 Added
	ON ppid.PersonID = p.PersonID
	AND
	CAST(dbo.Riv_fn_ComputeFiscalYear(ppid.RatingPeriodStartDate) AS INTEGER) 
						= CAST(dbo.Riv_fn_ComputeFiscalYear(GETDATE()) AS INTEGER)
	AND
	ppid.RunDate = (select Max(ppid2.RunDate) from dbo.PPID ppid2)

	AND
	(
	ppid.PerformancePlanIssueDate = (
									select Max(ppid3.PerformancePlanIssueDate) 
									from dbo.PPID ppid3
									where ppid3.PersonID = ppid.PersonID
									      and
										  -- JJM 2017-04-10
										  -- Added to address issue with 
										  --   latest issue date < latest RunDate 
										  ppid3.RunDate = ppid.RunDate
									)
	-- JJM 2017-04-10 Allow for NULL PerformancePlanIssueDate
	OR
	PerformancePlanIssueDate IS NULL
	)
	AND
	ppid.RatingPeriodStartDate =	(
									select Max(ppid4.RatingPeriodStartDate) 
									from dbo.PPID ppid4
									where ppid4.PersonID = ppid.PersonID
									)
	AND
	ppid.RatingPeriodEndDate =		(
									select Max(ppid5.RatingPeriodEndDate) 
									from dbo.PPID ppid5
									where ppid5.PersonID = ppid.PersonID
									)

-- join PerformanceRating for Performance info
LEFT OUTER JOIN PerformanceRating perf					--JJM 2016-04-21 Added
	ON p.PersonID = perf.PersonID
	AND
	perf.RunDate = (select Max(perf2.RunDate) from dbo.PerformanceRating perf2)
	AND
	perf.RatingPeriodStartDate = (
								 select Max(perf3.RatingPeriodStartDate) 
								 from dbo.PerformanceRating perf3
								 where perf3.PersonID = perf.PersonID
								 )
	AND
	perf.RatingPeriodEndDate = (
							   select Max(perf4.RatingPeriodEndDate) 
							   from dbo.PerformanceRating perf4
							   where perf4.PersonID = perf.PersonID
							   )
)
AS APPAS_Info

LEFT OUTER JOIN dbo.Position pos
	ON pos.PersonID = APPAS_Info.SupervisorID	
	AND pos.RecordDate = 
--      JJM 2016-10-03 get max RecordDate for table instead of Person so that employees with changed SSNs are excluded
		(select Max(pos1.RecordDate) as MaxRecDate from dbo.Position pos1)
	AND pos.PositionDateID = 
		(select Max(pos2.PositionDateID) as MaxPosDateId from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = APPAS_Info.SupervisorID and pos2.RecordDate = pos.RecordDate)  -- 28,264 records, make sure one person only contains one Position record. If for any reason, a person has two position dates, get the latest one.

INNER JOIN dbo.PositionDate posD
	ON posD.PositionDateId = pos.PositionDateId

INNER JOIN dbo.PositionInfo posI
	ON posI.PositionInfoId = pos.ChrisPositionId

LEFT OUTER JOIN Person p2	
	ON p2.PersonID = posI.SupervisorID



GO
