USE [HRDW]
GO
/****** Object:  View [REPORTING].[vWAT_AveOnboard]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-06-24  
-- Description: Created View
-- =============================================================================
CREATE VIEW [REPORTING].[vWAT_AveOnboard]
AS
SELECT 
	  AvgOnboardGrade.PayPlan
	, AvgOnboardGrade.Grade
	, AvgOnboardGrade.PositionSeries
	, AvgOnboardGrade.DutyStationName
	, AvgOnboardGrade.GenderDescription
	, AvgOnboardGrade.RNOCode
	, AvgOnboardGrade.MCO
	, AvgOnboardGrade.Supervisor
	, AVG(AvgOnboardGrade.OnboardGradeCounts) AS AvgOnboard
FROM
	(
	SELECT 
		  pos.RecordDate
		, posI.PayPlan
		, posI.Grade
		, posI.[PositionSeries]
		, ds.DutyStationName
		, p.GenderDescription
		, p.RNOCode
--		, MCOlkup.McoAbbreviated
		, pos.MCO
		, CASE
			WHEN posI.[SupervisoryStatusCode] in (2,4,5) THEN 'Y'
			ELSE 'N' 
		  END AS Supervisor
		, COUNT(*) AS OnboardGradeCounts
	FROM dbo.Person p				
	inner join dbo.Position pos
		on pos.PersonID = p.PersonID	
		   and 
		   pos.RecordDate >= 
			(select GETDATE() - 365.25)

/*		   pos.RecordDate = 
			(select Max(pos1.RecordDate) from dbo.Position pos1 where pos1.PersonID = pos.PersonID)
		   and pos.PositionDateID = 
			(
			select Max(pos2.PositionDateID) as MaxPosDateId 
		    from dbo.Position pos2 
			where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate
			)
*/

	inner join dbo.PositionInfo posI
		on posI.PositionInfoId = pos.ChrisPositionId
		   and 
		   (posI.PositionEncumberedType = 'Employee Permanent' or posI.PositionEncumberedType = 'Employee Temporary')

	INNER JOIN dbo.DutyStation ds
		on pos.DutyStationID = ds.DutyStationID

	GROUP BY
		  pos.RecordDate
		, posI.PayPlan
		, posI.Grade
		, posI.[PositionSeries]
		, ds.DutyStationName
		, p.GenderDescription
		, p.RNOCode
--		, MCOlkup.McoAbbreviated
		, pos.MCO
		, CASE
			WHEN posI.[SupervisoryStatusCode] in (2,4,5) THEN 'Y'
			ELSE 'N' 
		  END
	) AS AvgOnboardGrade
GROUP BY
	  AvgOnboardGrade.PayPlan
	, AvgOnboardGrade.Grade
	, AvgOnboardGrade.PositionSeries
	, AvgOnboardGrade.DutyStationName
	, AvgOnboardGrade.GenderDescription
	, AvgOnboardGrade.RNOCode
	, AvgOnboardGrade.MCO
	, AvgOnboardGrade.Supervisor

GO
