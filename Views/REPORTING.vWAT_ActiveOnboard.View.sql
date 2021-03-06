USE [HRDW]
GO
/****** Object:  View [REPORTING].[vWAT_ActiveOnboard]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-06-24  
-- Description: Created View
-- =============================================================================
CREATE VIEW [REPORTING].[vWAT_ActiveOnboard]
AS
SELECT
	  posI.PayPlan
	, posI.Grade
	, posI.[PositionSeries]
	, ds.DutyStationName
--	, p.HandicapCode
	, p.GenderDescription
	, p.RNOCode
--	, p.RetirementPlanCode
--	, MCOlkup.McoAbbreviated
	, pos.MCO
-- =============================== ADD SSO ===================
	, CASE
		WHEN posI.[SupervisoryStatusCode] in (2,4,5) THEN 'Y'
		ELSE 'N' 
	  END AS Supervisor
	, count(*)	AS TotalOnboard
from dbo.Person p				

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
	and pos.RecordDate = 
		(select Max(pos1.RecordDate) from dbo.Position pos1 where pos1.PersonID = pos.PersonID)
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) as MaxPosDateId from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)  -- 28,264 records, make sure one person only contains one Position record. If for any reason, a person has two position dates, get the latest one.

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId
	and (posI.PositionEncumberedType = 'Employee Permanent' or posI.PositionEncumberedType = 'Employee Temporary')	

INNER JOIN dbo.DutyStation ds
	on pos.DutyStationID = ds.DutyStationID

/*
LEFT OUTER JOIN MCOLkup MCOlkup
	ON posI.[PositionSeries] = 
		CAST(REPLICATE('0',4 - LEN(MCOlkup.OccupationalSeriesCode)) AS NVARCHAR(1)) 
			+ CAST((MCOlkup.OccupationalSeriesCode) AS NVARCHAR(4))
*/
GROUP BY
	  posI.PayPlan
	, posI.Grade
	, posI.[PositionSeries]
	, ds.DutyStationName
--	, p.HandicapCode
	, p.HandicapCodeDescription
	, p.GenderDescription
	, p.RNOCode
--	, p.RetirementPlanCode
--	, MCOlkup.McoAbbreviated
	, pos.MCO
	, CASE
		WHEN posI.[SupervisoryStatusCode] in (2,4,5) THEN 'Y'
		ELSE 'N' 
	  END


GO
