USE [HRDW]
GO
/****** Object:  View [SURVEY].[vVOESurveyData2]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [SURVEY].[vVOESurveyData2]
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-03-13  
-- Description: Created abridged version of vVOESurveyData
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-03-13  
-- Description: Add the following data elements to the view:
--               Position title
--               MCO
--               Target grade
--               Career Ladder (Y/N)
--               Pathways (Y/N)
--               Age
--               Disability
--               Veterans status 
--               Education level
--               Latest hire date
--               YOS GSA
-- =============================================================================

AS
SELECT 
DISTINCT
  p.PersonID
, pos.RecordDate
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName
, p.[LastName] AS Employee_LN
, p.[FirstName] AS Employee_FN
, p.MiddleName AS Employee_MN
, p.EmailAddress
, posI.PositionTitle
, pos.MCO
, posI.TargetGradeOrLevel
, CASE
  WHEN posI.TargetGradeOrLevel < posI.Grade
  THEN 'Y'
  ELSE 'N'
  END AS CareerLadder
, p.IsPathways
, dbo.gsa_fn_CalculateAge(p.BirthDate,survey.SurveySendDate) AS Age
, p.HandicapCode
, p.VeteransStatusDescription
, p.EducationLevelCode
, posD.LatestHireDate
, CASE
  WHEN posD.SCDCivilian <= posD.SCDLeave
  THEN posD.SCDCivilian
  ELSE
      posD.SCDLeave
  END AS SCDate
, survey.SurveyTypeDesc
, survey.SurveySendDate
, survey.SurveyResponseDate
, pos.[PosOrgAgySubelementCode]
, s.[PosOrgAgySubelementDescription] as HSSO 
, s.[SsoAbbreviation]						 
, posI.[OfficeSymbol]
, OfficeLkup.[OfficeSymbol2Char]
, posI.PayPlan+'-'+posI.[PositionSeries]+'-'+posI.Grade as PPSeriesGrade 
, posI.[PositionSeries]
, ds.DutyStationCode
, ds.DutyStationName
, ds.DutyStationCounty						
, ds.DutyStationState						
, ds.Region				
, pii.GenderDescription
, pii.RNOCode
, rnolkup.RNODescription
, RNOCode_CleanedUp = 
  CASE 
	WHEN CHARINDEX(',', rnolkup.RNODescription, 1) > 0 THEN '2 or More'		
	ELSE rnolkup.RNODescription
  END

FROM
SURVEY.SurveyResponseDate survey
INNER JOIN 
dbo.Person p 
	ON p.EmailAddress = LEFT(survey.EmailAddress, charindex('/',survey.EmailAddress) -1)

INNER JOIN dbo.Position pos
	on pos.PersonID = p.PersonID	
INNER JOIN dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId
INNER JOIN dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId

	and (
		posI.PositionEncumberedType = 'Employee Permanent' 
		or 
		posI.PositionEncumberedType = 'Employee Temporary'
		or
		posI.PositionEncumberedType = 'Ex-Employee Permanent' 
		)	

INNER JOIN Person pii
		ON pii.PersonID = p.PersonID
LEFT OUTER JOIN RNOLkup rnolkup
		ON rnolkup.RNOCode = pii.RNOCode

LEFT OUTER JOIN dbo.DutyStation ds		
	on pos.DutyStationID = ds.DutyStationID

LEFT OUTER JOIN DutyStationCodeStateRegionLkup dutlkup	-- JJM 2016-04-13 Lkup Region based on DutyStation
	ON ds.DutyStationCode = (REPLICATE('0',9 - LEN(dutlkup.DutyStationCode)) + dutlkup.DutyStationCode)

-- join lookup table for Office Symbol
left outer join dbo.OfficeLkup	
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]


WHERE 
--  SurveyResponseDate IS NOT NULL
--
--  AND SurveyResponseDate >= MIN position.RecordDate
--  AND SurveyResponseDate = MAX position.RecordDate
--  AND position.RecordDate <= SurveyResonseDate 
--
	(
	  survey.SurveyResponseDate IS NOT NULL
	  AND
	  (
	  (
	  survey.SurveyResponseDate >=
						(
						SELECT MIN(posa.RecordDate)
						FROM Position posa
						WHERE posa.PersonID = p.PersonID
						)
	  )
  	  AND
	  (
	  pos.RecordDate =  (
						SELECT MAX(posb.RecordDate)
						FROM Position posb
						WHERE posb.PersonID = p.PersonID
							  AND
							  posb.RecordDate <= survey.SurveyResponseDate
						)
	  )
	  )
--
	  OR
--  SurveyResponseDate IS NOT NULL
--
--  AND SurveyResponseDate < MIN position.RecordDate
--  AND SurveyResponseDate = MIN position.RecordDate
--
	  (
	  (
	  survey.SurveyResponseDate <
						(
						SELECT MIN(posc.RecordDate)
						FROM Position posc
						WHERE posc.PersonID = p.PersonID
						)
	  AND
	  (
	  pos.RecordDate =  (
						SELECT MIN(posd.RecordDate)
						FROM Position posd
						WHERE posd.PersonID = p.PersonID
						)
	  )
	  )
	  )
	)
	OR
--  SurveyResponseDate IS NULL
--
--  AND SurveySendDate >= MIN position.RecordDate
--  AND SurveySendDate = MAX position.RecordDate
--  AND position.RecordDate <= SurveySendDate 
--
	(
	  survey.SurveyResponseDate IS NULL
	  AND
	  (
	  (
	  survey.SurveySendDate >=
						(
						SELECT MIN(posw.RecordDate)
						FROM Position posw
						WHERE posw.PersonID = p.PersonID
						)
	  )
  	  AND
	  (
	  pos.RecordDate =  (
						SELECT MAX(posx.RecordDate)
						FROM Position posx
						WHERE posx.PersonID = p.PersonID
							  AND
							  posx.RecordDate <= survey.SurveySendDate
						)
	  )
	  )
--
	  OR
--  SurveyResponseDate IS NULL
--
--  AND SurveySendDate < MIN position.RecordDate
--  AND SurveySendDate = MIN position.RecordDate
--
	  (
	  (
	  survey.SurveySendDate <
						(
						SELECT MIN(posy.RecordDate)
						FROM Position posy
						WHERE posy.PersonID = p.PersonID
						)
	  AND
	  (
	  pos.RecordDate =  (
						SELECT MIN(posz.RecordDate)
						FROM Position posz
						WHERE posz.PersonID = p.PersonID
						)
	  )
	  )
	  )
	)



GO
