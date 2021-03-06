USE [HRDW]
GO
/****** Object:  View [SURVEY].[vVOESurveyData]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [SURVEY].[vVOESurveyData]
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-11-17  
-- Description: Created view based on Roster-Regular, but added 
--              PositionEncumberedType of 'Ex-Employee'.
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-07-31  
-- Description: Fixed NULL OrgLongName issue by surrounding PosAddressOrgInfo1-6
--              with ISNULL.
-- =============================================================================
AS
Select 
------------------------------
-- Person
------------------------------
  p.PersonID
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName
, p.[LastName] AS Employee_LN
, p.[FirstName] AS Employee_FN
, p.MiddleName AS Employee_MN
, survey.SurveyTypeDesc
, survey.SurveySendDate
, survey.SurveyResponseDate
, p.VeteransPreferenceDescription
, p.[VeteransStatusDescription]
, p.[EmailAddress]
, p.AcademicInstitutionCode
, p.AcademicInstitutionDesc
, p.CollegeMajorMinorCode	
, p.CollegeMajorMinorDesc	
, p.EducationLevelCode		
, p.EducationLevelDesc		
, p.InstructionalProgramCode
, p.InstructionalProgramDesc
, p.DegreeObtained			
, p.IsPathways				

-- Supervisor info
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor	-- JJM 2016-04-13 Added MiddleName
, p1.EmailAddress as Supervisor_Email
-- JJM 2016/04/04 - Updated to use pos2 alias as the outer join alias was updated
, pos2.WorkTelephone as Supervisor_Workphone					--Supervisor Work Phone
, pos2.WorkCellPhoneNumber as Supervisor_CellPhone				--Supervisor Cell Phone

-- Add Later - Training information. This area will be a separate data report (Task 4-8).
/*
, [New Supervisor]
, [Experienced Supervisor]
, [New GSA employee]
-- all the training classes with a Y or N
*/

------------------------------
-- Position
------------------------------
, pos.FY
, Month(pos.RecordDate) as Month_Name
, pos.RecordDate
, pos.TenureDescription
, pos.LeaveCateGOry

, pos.CompetativeArea
, pos.CompetativeLevel
, pos.CybersecurityCode
, pos.CybersecurityCodeDesc

, pos.FlsaCateGOryCode
, pos.FlsaCateGOryDescription
, pos.KeyEmergencyEssentialCode
, pos.KeyEmergencyEssentialDescription
, pos.AssignmentUSErStatus
, pos.MCO
--, pos.BargainingUnitStatusCode		-- JJM 2016-04-13 Removed
, pos.BargainingUnitStatusDescription
, bus.BargainingUnitOrg					-- JJM 2016-04-13 Added
, pos.[PosOrgAgySubelementCode]
, s.[PosOrgAgySubelementDescription] as HSSO 
, s.[SsoAbbreviation]						 

, pos.WorkTelephone
, pos.WorkCellPhoneNumber
, pos.WorkBuilding
, pos.WorkAddressLine1
, pos.WorkAddressLine2
, pos.WorkAddressLine3
, pos.WorkCounty
, pos.WorkState
, pos.WorkZip

, pos.PosAddressOrgInfoLine1
, pos.PosAddressOrgInfoLine2
, pos.PosAddressOrgInfoLine3
, pos.PosAddressOrgInfoLine4
, pos.PosAddressOrgInfoLine5
, pos.PosAddressOrgInfoLine6
, ISNULL(pos.PosAddressOrgInfoLine1,'')
	+' '+ISNULL(pos.PosAddressOrgInfoLine2,'')
	+' '+ISNULL(pos.PosAddressOrgInfoLine3,'')
	+' '+ISNULL(pos.PosAddressOrgInfoLine4,'')
	+' '+ISNULL(pos.PosAddressOrgInfoLine5,'')
	+' '+ISNULL(pos.PosAddressOrgInfoLine6,'') 
	AS OrgLongName


, pos.PublicTrustIndicatorCode	
, pos.PublicTrustIndicatorDesc	

, pos.[TeleworkIndicator]
, pos.[TeleworkIndicatorDescription]
, pos.[TeleworkIneligibilityReason]
, pos.[TeleworkIneligibReasonDescription]

------------------------------
-- Position Date
------------------------------
, posD.LatestHireDate
, posD.SCDCivilian
, posD.SCDLeave
, posD.ComputeEarlyRetirment
, posD.ComputeOptionalRetirement
, posD.WGIDateDue
, posD.WGILastEquivalentIncreaseDate
, posD.DateLastPromotion
, posD.ArrivedPersonnelOffice
, posD.ArrivedPresentGrade
, posD.ArrivedPresentPosition
, posD.DateProbTrialPeriodBegins
, posD.DateProbTrialPeriodEnds	
, posD.DateConversionCareerBegins
, posD.DateConversionCareerDue	
, posD.DateofSESAppointment		
, posD.DateSESProbExpires		
, posD.DateVRAConversionDue		
, posD.LatestSeparationDate		

------------------------------
-- Position Info
------------------------------
, posI.[OfficeSymbol]
, OfficeLkup.[OfficeSymbol2Char]
, posI.PositionEncumberedType
, posI.PositionControlNumber
, posI.PositionControlIndicator
, posI.PositionInformationPD
, posI.PositionSequenceNumber
, posI.[SupervisoryStatusCode]
, posI.[SupervisoryStatusDesc]				-- JJM 2016-04-13 Added
, posI.PositionTitle
, posI.OccupationalCateGOryDescription
, posI.PayPlan+'-'+posI.[PositionSeries]+'-'+posI.Grade as PPSeriesGrade 
, posI.[PositionSeries]
, posI.Grade
, posI.Step
, posI.SupvMgrProbationRequirementCode	
, posI.SupvMgrProbationRequirementDesc	

, posi.[OccupationalSeriesCode]			
, posi.[OccupationalSeriesDescription]

, posi.TargetPayPlan					-- JJM 2016-04-27 - Target PP and Grade added to PositionInfo
, posi.TargetGradeOrLevel				-- JJM 2016-04-27 - Target PP and Grade added to PositionInfo

, posi.[DetailType]						-- JJM 2016-05-17 Added
, posi.[DetailTypeDescription]			-- JJM 2016-05-17 Added

------------------------------
-- Financials
------------------------------
, f.EmploymentType						
, f.AppointmentType						
, f.BlockNumberCode
, f.BlockNumberDesc
, f.AppropriationCode

, f.OrgCodeBudgetFinance
, f.FundCode
, f.BudgetActivity
, f.CostElement
, f.ObjectClass
, f.ORG_BA_FC
, f.RR_ORG_BA_FC

, f.AppointmentAuthCode						
, f.AppointmentAuthDesc						
, f.AppointmentAuthCode2					
, f.AppointmentAuthDesc2					
, f.FinancialStatementCode
, f.FinancialStatementDesc

, f.[PayRateDeterminantCode]				-- JJM 2016-05-17 Added	
, f.[PayRateDeterminantDescription]			-- JJM 2016-05-17 Added	

------------------------------
-- Personnel Office
------------------------------
, po.OwningRegion
, po.ServicingRegion
, po.PersonnelOfficeDescription

------------------------------
-- Duty Station
------------------------------
, ds.DutyStationCode
, ds.DutyStationName
, ds.DutyStationCounty						
, ds.DutyStationState						
, ds.Region				
, dutlkup.RegionBasedOnDutyStation			-- JJM 2016-04-13 Added
, dutlkup.LocalityPayArea					-- JJM 2016-05-26 Added
, dutlkup.CoreBasedStatArea					-- JJM 2016-05-26 Added
, dutlkup.CombinedStatArea					-- JJM 2016-05-26 Added

------------------------------
-- Pay
------------------------------
,pay.BasicSalary
,pay.AdjustedBasic
,pay.TotalPay		
,pay.HourlyPay		

-----------------------------
-- Security
------------------------------
, sc.ClearanceDate
, sc.InvestigationType
, sc.ClearanceDescription
, sc.SecurityClearanceNumber

------------------------------
-- IDP: Individual Development Plan
------------------------------
-- load in the most current FY into IDP table for all emp's IDP status = "Approved" 

--, IIf([IDP 2016]![IDP Status]="Approved","Yes","No") AS [IDP_Current] -- latest FY?
-- If IDP record is present in current FY and the IDP status is approved, then it's current. 
-- (Note. In the current SP version, we only load in IDP records with ADP status = 'Approved')

, idp.FiscalYearValidation
, idp.IDPStatus

, IsIDP_Current = 
CASE 
	WHEN cast(idp.FiscalYearValidation as integer) = cast(dbo.Riv_fn_ComputeFiscalYear(getdate()) as integer) and idp.IDPStatus = 'Approved'
		THEN 'Yes'		
	ELSE 'No'
END

------------------------------
-- PPID: Performance Plan Issue Date
------------------------------

-- 
-- Get PPID data for max Run Date for current FY (using FY from RatingPeriodStartDate)
-- 
, ppid.RunDate
, ppid.PerformancePlanIssueDate
, ppid.HasPP

------------------------------
-- PerformanceRating: Performance Ratings from APPAS
------------------------------
-- 
-- Get Annual and Mid-Year Rating Data
-- 

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

------------------------------
--Service PIN 
------------------------------
-- go to Task 3 (ServicePIN View)

------------------------------
-- telework 
------------------------------
, tel.[TeleworkStatus]
, tel.[EmpStatus]
, tel.[TeleworkElgible]

--, IIf(IsNull([Emp Status]),"No Matching Salesforce Information on key data field","No") AS [Is Emp Status Blank]
, IsEmpStatusBlank = 
CASE 
	WHEN tel.[EmpStatus] is null THEN 'No Matching Salesforce Information on key data field'		

	ELSE 'No'
END

/*
------------------------------
-- VorS
------------------------------
-- from VorS table
, [V OR S]![Satellite or Virtual] AS [Virtual or Satellite]

*/
FROM
SURVEY.SurveyResponseDate survey
INNER JOIN 
dbo.Person p 
	ON p.EmailAddress = LEFT(survey.EmailAddress, charindex('/',survey.EmailAddress) -1)

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	

inner join dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId	

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId

	and (
		posI.PositionEncumberedType = 'Employee Permanent' 
		or 
		posI.PositionEncumberedType = 'Employee Temporary'
		or
		posI.PositionEncumberedType = 'Ex-Employee Permanent' 
		)	

inner join dbo.Financials f
	on f.FinancialsID = pos.FinancialsID

inner join dbo.PersonnelOffice po		
	on po.PersonnelOfficeID = pos.PersonnelOfficeID

/* JJM 2016-04-21 Changed to LEFT OUTER JOIN */
LEFT OUTER JOIN dbo.DutyStation ds		
	on pos.DutyStationID = ds.DutyStationID

LEFT OUTER JOIN DutyStationCodeStateRegionLkup dutlkup	-- JJM 2016-04-13 Lkup Region based on DutyStation
	ON ds.DutyStationCode = (REPLICATE('0',9 - LEN(dutlkup.DutyStationCode)) + dutlkup.DutyStationCode)

inner join dbo.Pay pay	
	on pay.PayID = pos.PayID

left outer join dbo.Security sc
	on sc.PersonID = p.PersonID
	-- always get one record with the latest Clearance Date
	and sc.[SecurityID] = 
		(select Max(sc1.[SecurityID]) as MaxSecID 
		from dbo.Security sc1 
		where sc1.PersonID = sc.PersonID
		)

left outer join dbo.IDP idp		
	on idp.PersonID = p.PersonID
	-- when multiple IDP records are present in a FY, always get one record with the latest IDP Record Date
	and idp.[IDPRecordNumber] = 
		(select Max(idp1.[IDPRecordNumber]) as MaxIDPRecDate 
		from dbo.IDP idp1 
		where idp1.PersonID = idp.PersonID
		  and idp1.FiscalYearValidation = idp.FiscalYearValidation
		  and idp1.IDPStatus = idp.IDPStatus
		)
	and 
	cast(idp.FiscalYearValidation as integer) = cast(dbo.Riv_fn_ComputeFiscalYear(getdate()) as integer)

-- getting supervisor's names
left outer join Person p1		
	on p1.PersonID = posI.SupervisorID

-- getting supervisor's position Info (phone, etc)
left outer join Position pos2	
	on pos2.PersonID = posI.SupervisorID
	and posI.PositionInfoID = pos2.ChrisPositionId
	and posI.PositionInfoID = pos.ChrisPositionID
	and pos2.RecordDate = 
--      JJM 2016/04/04 - Update join on Max Record Date
		(select Max(pos3.RecordDate) from dbo.Position pos3 where pos3.PersonID = pos2.PersonID)

-- join lookup table for Office Symbol
left outer join dbo.OfficeLkup	
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

-- join telework table for employee's telework agreement
left outer join [dbo].[Telework] tel
	on tel.[PersonID] = p.PersonID

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
	ppid.PerformancePlanIssueDate = (
									select Max(ppid3.PerformancePlanIssueDate) 
									from dbo.PPID ppid3
									where ppid3.PersonID = ppid.PersonID
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
