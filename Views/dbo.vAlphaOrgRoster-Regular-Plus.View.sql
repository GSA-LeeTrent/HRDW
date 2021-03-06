USE [HRDW]
GO
/****** Object:  View [dbo].[vAlphaOrgRoster-Regular-Plus]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-05-23  
-- Description: Added same Duty Station columns for supervisor as Employee
--              and fixed posI join for supervisor info 
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-06-01  
-- Description: Add the following columns:
--              - [ComputeEarlyRetirement(HRDW)]
--              - [ComputeOptionalRetirement(HRDW)]
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-07-10  
-- Description: Renamed IsIDP_Current to IDP_CurrentFY and renamed IDPStatus
--              column to IDPStatus_CurrFY. Added 2 new columns: IDPStatus_NextFY
--              and IDP_NextFY
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-07-31  
-- Description: Fixed NULL OrgLongName issue by surrounding PosAddressOrgInfo1-6
--              with ISNULL.
-- =============================================================================

-- =============================================================================
-- Author:      Ralph Silvestro
-- Date:        2017-09-14  
-- Description: 2 Changes:
--              * Add RegionBasedOnOfficeSymol
--              * Convert RegionBasedOnDutyStation to 'DC' for 'WP%' and 'WQ%'
--                OfficeSymbols where the Duty Station is in Virginia or Maryland.
-- =============================================================================
-- =============================================================================
-- Author:      Ralph Silvestro
-- Date:        2017-09-25
-- Description: Revert back to pre-2017-09-14.
-- =============================================================================

CREATE VIEW [dbo].[vAlphaOrgRoster-Regular-Plus] -- WITH SCHEMABINDING 
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
, p.VeteransPreferenceDescription
, p.[VeteransStatusDescription]
, p.[EmailAddress]
, p.AcademicInstitutionCode						--, PMU_PRIMARY.[Academic Institution Code]
, p.AcademicInstitutionDesc						--, PMU_PRIMARY.[Academic Institution Description]
, p.CollegeMajorMinorCode						--, PMU_PRIMARY.[College-Major-Minor Code]
, p.CollegeMajorMinorDesc						--, PMU_PRIMARY.[College-Major-Minor Description]
, p.EducationLevelCode							--, PMU_PRIMARY.[Educational Level Code]
, p.EducationLevelDesc							--, PMU_PRIMARY.[Educational Level Desc]
, p.InstructionalProgramCode					--, PMU_PRIMARY.[Instructional Program Code]
, p.InstructionalProgramDesc					--, PMU_PRIMARY.[Instructional Program Description]
, p.DegreeObtained								--, PMU_PRIMARY.[Year Degree Cert Attained]
, p.IsPathways									-- college intership (Y/N)

-- Supervisor info
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor	-- JJM 2016-04-13 Added MiddleName
, p1.EmailAddress as Supervisor_Email
, suppos.WorkTelephone as Supervisor_Workphone					--Supervisor Work Phone
, suppos.WorkCellPhoneNumber as Supervisor_CellPhone			--Supervisor Cell Phone

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
-- , pos.BargainingUnitStatusCode		-- JJM 2016-04-13 Removed
, pos.BargainingUnitStatusDescription	--, PMU_PRIMARY.[Bargaining Unit Status Description]
, bus.BargainingUnitOrg					-- JJM 2016-04-13 Added
, pos.[PosOrgAgySubelementCode]
, s.[PosOrgAgySubelementDescription] as HSSO -- SSO lookup for Agency or PosOrgAgySubelementDesc
, s.[SsoAbbreviation]						 --, includes Abbr

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

, pos.PublicTrustIndicatorCode	--, PMU_PRIMARY.[Public Trust Indicator Code]
, pos.PublicTrustIndicatorDesc	--, PMU_PRIMARY.[Public Trust Indicator Desc]

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
, dbo.gsa_fn_ComputeEarlyRetirement(
									 posD.Retirement_SCD
									,posD.SCDCivilian
									,p.BirthDate
								   ) 
		  AS [ComputeEarlyRetirement(HRDW)]			-- JJM 2017-06-01 Added
, posD.ComputeOptionalRetirement
, dbo.gsa_fn_ComputeOptionalRetirement(
									    posD.Retirement_SCD
									   ,posD.SCDCivilian
									   ,p.BirthDate
									   ,posI.PositionSeries
									   ,p.RetirementPlanCode
									  ) 
		  AS [ComputeOptionalRetirement(HRDW)]		-- JJM 2017-06-01 Added
, posD.WGIDateDue
, posD.WGILastEquivalentIncreaseDate
, posD.DateLastPromotion
, posD.ArrivedPersonnelOffice
, posD.ArrivedPresentGrade
, posD.ArrivedPresentPosition
, posD.DateProbTrialPeriodBegins		--, PMU_PRIMARY.[Date Prob/Trial Period Begins]
, posD.DateProbTrialPeriodEnds			--, PMU_PRIMARY.[Date Prob/Trial Period Ends]
, posD.DateConversionCareerBegins		--, PMU_PRIMARY.[Date Conversion Career Begins]
, posD.DateConversionCareerDue			--, PMU_PRIMARY.[Date Conversion Career Due]
, posD.DateofSESAppointment				--, PMU_PRIMARY.[Date of SES Appointment]
, posD.DateSESProbExpires				--,[Date SES Prob Expires]
, posD.DateVRAConversionDue				--,[Date VRA Conversion Due]
, posD.LatestSeparationDate				-- JJM 2016-04-27 Added per the addition to xxPMU

------------------------------
-- Position Info
------------------------------
, posI.[OfficeSymbol]
, OfficeLkup.[OfficeSymbol2Char]
-- 2017-09-14 Add Region Based on Office Symbol BY RALPH SILVESTRO
, OfficeLkup.RegionBasedonOfficeSymbol
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
, posI.SupvMgrProbationRequirementCode	--,[Supv/Mgr Probation Requirement Code]
, posI.SupvMgrProbationRequirementDesc	--,[Supv/Mgr Probation Requirement Desc]

, posi.[OccupationalSeriesCode]			--, PMU_PRIMARY.[CHRIS Position Information#Occupational Series Code]
, posi.[OccupationalSeriesDescription]

, posi.TargetPayPlan					-- JJM 2016-04-27 - Target PP and Grade added to PositionInfo
, posi.TargetGradeOrLevel				-- JJM 2016-04-27 - Target PP and Grade added to PositionInfo

, posi.[DetailType]						-- JJM 2016-05-17 Added
, posi.[DetailTypeDescription]			-- JJM 2016-05-17 Added

------------------------------
-- Financials
------------------------------
, f.EmploymentType						--, PMU_PRIMARY.[Type of Employment Description]
, f.AppointmentType						--, PMU_PRIMARY.[Appointment Type Description]
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

, f.AppointmentAuthCode						--, PMU_PRIMARY.[Current Appointment Auth (1) Code]
, f.AppointmentAuthDesc						--, PMU_PRIMARY.[Current Appointment Auth (1) Desc]
, f.AppointmentAuthCode2					--, PMU_PRIMARY.[Current Appointment Auth (2) Desc]
, f.AppointmentAuthDesc2					--, PMU_PRIMARY.[Current Appointment Auth (2) Code]
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
, ds.DutyStationCounty						--, PMU_PRIMARY.[CHRIS Position InformationDuty Station County Name]
, ds.DutyStationState						--, PMU_PRIMARY.[Duty Station State Or Country]
, ds.Region				
, dutlkup.RegionBasedOnDutyStation			-- JJM 2016-04-13 Added
, dutlkup.LocalityPayArea					-- JJM 2016-05-26 Added
, dutlkup.CoreBasedStatArea					-- JJM 2016-05-26 Added
, dutlkup.CombinedStatArea					-- JJM 2016-05-26 Added

-----------------------------------------------
-- Supervisor Duty Station - Added 2017-05-23
-----------------------------------------------
, supds.DutyStationCode					AS SupDutyStationCode  
, supds.DutyStationName					AS SupDutyStationName
, supds.DutyStationCounty				AS SupDutyStationCounty
, supds.DutyStationState				AS SupDutyStationState
, supds.Region							AS SupRegion				
, supdutlkup.RegionBasedOnDutyStation	AS SupRegionBasedOnDutyStation
, supdutlkup.LocalityPayArea			AS SupLocalityPayArea			
, supdutlkup.CoreBasedStatArea			AS SupCoreBasedStatArea			
, supdutlkup.CombinedStatArea			AS SupCombinedStatArea			

------------------------------
-- Pay
------------------------------
,pay.BasicSalary						--, PMU_PRIMARY.[Basic Salary Rate]
,pay.AdjustedBasic						--, PMU_PRIMARY.[Adjusted Basic Pay]
,pay.TotalPay							--, PMU_PRIMARY.[Total Pay]
,pay.HourlyPay							--, PMU_PRIMARY.[Per- Hour(Total Salary_Total Pay)]

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
, idp.IDPStatus AS IDPStatus_CurrentFY
, IDP_CurrentFY = 
  CASE 
	WHEN cast(idp.FiscalYearValidation as integer) = cast(dbo.Riv_fn_ComputeFiscalYear(getdate()) as integer) and idp.IDPStatus = 'Approved'
    THEN 'Yes'		
	ELSE 'No'
  END
, idp2.IDPStatus IDPStatus_NextFY
, IDP_NextFY = 
  CASE 
	WHEN (cast(idp2.FiscalYearValidation as integer) = cast(dbo.Riv_fn_ComputeFiscalYear(getdate()) as integer) + 1) and idp2.IDPStatus = 'Approved'
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
,pos.DrugTestCode
,pos.DrugTestDescription

from dbo.Person p				--28264 distinct PersonIDs

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

	--Include the following condition if only new hires in current FY is selected. matching 460 rows for new hires in FY2016
	--and datediff(day, cast(dbo.Riv_fn_ComputeFiscalYear(posD.LatestHireDate) as datetime), cast(dbo.Riv_fn_ComputeFiscalYear(getdate()) as datetime)) = 0  

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId

	-- only Perm or Temp employees are selected, getting 11,180 rows
	and (posI.PositionEncumberedType = 'Employee Permanent' or posI.PositionEncumberedType = 'Employee Temporary')	

inner join dbo.Financials f
	on f.FinancialsID = pos.FinancialsID	--11,180 rows

inner join dbo.PersonnelOffice po			--11,180 rows
	on po.PersonnelOfficeID = pos.PersonnelOfficeID

/* JJM 2016-04-21 Changed to LEFT OUTER JOIN */
LEFT OUTER JOIN dbo.DutyStation ds				--11,180 rows
	on pos.DutyStationID = ds.DutyStationID

LEFT OUTER JOIN DutyStationCodeStateRegionLkup dutlkup	-- JJM 2016-04-13 Lkup Region based on DutyStation
	ON ds.DutyStationCode = (REPLICATE('0',9 - LEN(dutlkup.DutyStationCode)) + dutlkup.DutyStationCode)

inner join dbo.Pay pay						--11,180 rows
	on pay.PayID = pos.PayID

left outer join dbo.Security sc				--11,180 rows
	on sc.PersonID = p.PersonID
	-- always get one record with the latest Clearance Date
	and sc.[SecurityID] = 
		(select Max(sc1.[SecurityID]) as MaxSecID 
		from dbo.Security sc1 
		where sc1.PersonID = sc.PersonID
		)

left outer join dbo.IDP idp				--11,180 rows
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

-- get idp for next FY
left outer join dbo.IDP idp2				
	on idp2.PersonID = p.PersonID
	and idp2.[IDPRecordNumber] = 
		(select Max(idpy.[IDPRecordNumber]) as MaxIDPRecDate 
		from dbo.IDP idpy 
		where idpy.PersonID = idp2.PersonID
		  and idpy.FiscalYearValidation = idp2.FiscalYearValidation
		  and idpy.IDPStatus = idp2.IDPStatus
		)
	and 
	cast(idp2.FiscalYearValidation as integer) = (cast(dbo.Riv_fn_ComputeFiscalYear(getdate()) as integer) +1)

-- getting supervisor's names
left outer join Person p1					--11,180 rows
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
left outer join dbo.OfficeLkup				--11,180 rows
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s  			--11,180 rows
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










GO
