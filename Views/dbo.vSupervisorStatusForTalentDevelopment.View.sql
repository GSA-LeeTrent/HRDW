USE [HRDW]
GO
/****** Object:  View [dbo].[vSupervisorStatusForTalentDevelopment]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vSupervisorStatusForTalentDevelopment]
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-08-07  
-- Description: Created view per request of Rachel Wright. This view adds a 
--              supervisory status column to be used for talent development. 
-- =============================================================================
AS
SELECT 
  ros.RecordDate
, ros.FullName
, ros.EmailAddress
, ros.HSSO
, ros.PPSeriesGrade
, ros.TargetGradeOrLevel
, ros.Step
, ros.Position_Supervisor
, ros.Supervisor_Email
, ros.RegionBasedOnDutyStation
, ros.PositionTitle
, ros.SupervisoryStatusDesc
, CASE
  WHEN ros.SupervisoryStatusCode IN ('2','4')
	   AND 
	   LEFT(ros.PPSeriesGrade, 2) IN ('SL','EX','ES')
  THEN 'Executive'
  WHEN ros.PersonID IN 
			(
			SELECT
			   posI2.SupervisorID
			FROM
				Person ps
				inner join dbo.Position pos2
					on pos2.PersonID = ps.PersonID	
					and pos2.RecordDate = 
					(select Max(posz.RecordDate) as MaxRecDate from dbo.Position posz)
				inner join dbo.PositionInfo posI2
					on posI2.PositionInfoId = pos2.ChrisPositionId
					and (
					posI2.PositionEncumberedType = 'Employee Permanent' 
					or 
					posI2.PositionEncumberedType = 'Employee Temporary'
						)	
			WHERE
				posI2.SupervisoryStatusCode IN ('2','4')
			)
  THEN 'Manager'
  WHEN ros.SupervisoryStatusCode IN ('2','4')
  THEN 'Supervisor'
  ELSE 'Non-Supervisory'
  END AS SupervisoryStatusForTalentDevelopment
FROM
	[vAlphaOrgRoster-Regular] ros


GO
