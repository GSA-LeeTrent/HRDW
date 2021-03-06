USE [HRDW]
GO
/****** Object:  View [dbo].[vAlphaOrgRoster-with-ExEmployees]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[vAlphaOrgRoster-with-ExEmployees]
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-06-01  
-- Description: Created
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-05-01  
-- Description: Use functions for HRDWComputeEarlyRetirement and
--              HRDWComputeOptionalRetirement
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-05-23  
-- Description: Added same Duty Station columns for supervisor as Employee 
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-06-23  
-- Description: Added the following columns
--              - officelkup.RegionBasedOnOfficeSymbol
--              - pos.YOS_FEDERAL
--              - pos.YOSGSA 
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-07-11  
-- Description: Added the following columns
--              - NOAC_AND_DESCRIPTION_2
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-07-14  
-- Description: Added Overall Rating - COALESCE( current rating, prev rating)
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-07-14  
-- Description: Added High3Flag and fixed join on PPID so that join on 
--              subqueries include PersonID
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
--              * Add RegionBasedOnOfficeSymbol
--              * Convert RegionBasedOnDutyStation to 'DC' for 'WP%' and 'WQ%'
--                OfficeSymbols where the Duty Station is in Virginia or Maryland.
-- =============================================================================
-- =============================================================================
-- Author:      Ralph Silvestro
-- Date:        2017-09-25 
-- Description: Revert Back to original logic pre-2017-09-04
-- =============================================================================

AS
SELECT * FROM
(
SELECT 
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
-- JJM 2016/04/04 - Updated to use pos2 alias as the outer join alias was updated
, suppos.WorkTelephone as Supervisor_Workphone					--Supervisor Work Phone
, suppos.WorkCellPhoneNumber as Supervisor_CellPhone				--Supervisor Cell Phone

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
, pos.BargainingUnitStatusCode		
, pos.BargainingUnitStatusDescription
, bus.BargainingUnitOrg				
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
, pos.YOS_FEDERAL
, pos.YOSGSA

------------------------------
-- Position Date
------------------------------
, posD.LatestHireDate
, posD.SCDCivilian
, posD.SCDLeave
, posD.ComputeEarlyRetirment
, dbo.gsa_fn_ComputeEarlyRetirement(posD.Retirement_SCD,posD.SCDCivilian,p.Birthdate) 
			AS [ComputeEarlyRetirement(HRDW)]
, posD.ComputeOptionalRetirement
, dbo.gsa_fn_ComputeOptionalRetirement(posD.Retirement_SCD,posD.SCDCivilian,p.Birthdate,posI.PositionSeries,p.RetirementPlanCode) 
			AS [ComputeOptionalRetirement(HRDW)]
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
-- 2017-09-14 Add Region Based on Office Symbol BY RALPH SILVESTRO
, OfficeLkup.[RegionBasedOnOfficeSymbol]
, posI.PositionEncumberedType
, posI.PositionControlNumber
, posI.PositionControlIndicator
, posI.PositionInformationPD
, posI.PositionSequenceNumber
, posI.[SupervisoryStatusCode]
, posI.[SupervisoryStatusDesc]			
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

, posi.TargetPayPlan					
, posi.TargetGradeOrLevel				

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
, dutlkup.RegionBasedOnDutyStation	

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

 , COALESCE(perf.[FiscalYearRating], perf2.[FiscalYearRating]) AS APPAS_FY

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
 , COALESCE(
   CASE 
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
	END
 ,
   CASE 
	 WHEN posI.PayPlan IN ('CA','EX','ES','IG') 
	 THEN 'Exclude' --This is exclude Certain Pay Plans

	  WHEN pos.[PosOrgAgySubelementCode] ='GS15' 
	  THEN 'Exclude' --This is exclude IG
	  
	  WHEN perf2.[AppraisalTypeDescription] = 'Annual' AND DATEDIFF(DAY,posD.LatestHireDate,pos.RecordDate) < '45' 
	  THEN 'Exclude' --This excludes employees here less than 45 days

      WHEN perf2.[AppraisalTypeDescription] = 'Annual'
	       AND
		   perf2.[RatingPeriodEndDate] >= (CAST((RIGHT(perf.[FiscalYearRating],4) +'-06-01') AS DATE))
		   AND
		   perf2.[AppraisalStatus] = 'Plan in Progress'
		   AND 
		   perf2.[Unratable] = 'Y'
      THEN 'Unrateable'

	  WHEN perf2.[AppraisalTypeDescription] = 'Annual' AND perf2.[AppraisalStatus] = 'Completed'
	  THEN 'Y'

	  ELSE 'N' 
	END
	) AS [Annual Rating]

 , COALESCE(perf.OverallRating, perf2.OverallRating) AS OverallRating
 , COALESCE(perf.[AppraisalTypeDescription], perf2.[AppraisalTypeDescription]) As AppraisalTypeDescription
 , COALESCE(perf.[High3Flag], perf2.[High3Flag]) AS High3Flag

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

, COALESCE(t.NOAC_AND_DESCRIPTION, th.NOAC_AND_DESCRIPTION) AS NOAC_AND_DESCRIPTION
, COALESCE(t.ReasonForSeparationDesc, th.ReasonForSeparationDesc) AS ReasonForSeparationDesc
, COALESCE(t.EffectiveDate, th.EffectiveDate) AS EffectiveDate
, COALESCE(t.NOAC_AND_DESCRIPTION_2, th.NOAC_AND_DESCRIPTION_2) AS NOAC_AND_DESCRIPTION_2

,row_number() over 
	(partition by p.PersonID order by t.EffectiveDate desc) as RN

from dbo.Person p
inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
	and pos.RecordDate = 
--      JJM 2016-10-03 get max RecordDate for table instead of Person so that employees with changed SSNs are excluded
		(select Max(pos1.RecordDate) as MaxRecDate from dbo.Position pos1)
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) as MaxPosDateId from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)  -- make sure one person only contains one Position record. If for any reason, a person has two position dates, get the latest one.

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
left outer join Position suppos
	on suppos.PersonID = posI.SupervisorID
	and suppos.RecordDate = 
		(select Max(pos3.RecordDate) from dbo.Position pos3 where pos3.PersonID = suppos.PersonID)

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
LEFT OUTER JOIN BusLkup bus					
	ON pos.BargainingUnitStatusCode = bus.BargainingUnitStatusCode


-- join PerformanceRating for Performance info
LEFT OUTER JOIN PerformanceRating perf	
	ON p.PersonID = perf.PersonID

	AND
	perf.RunDate = (
				   select Max(perfa.RunDate) from dbo.PerformanceRating perfa
				   WHERE perfa.PersonID = perf.PersonID
				   )
	AND
	perf.OverallRating IS NOT NULL

	AND
	perf.RatingPeriodStartDate = (
								 select Max(perfb.RatingPeriodStartDate) 
								 from dbo.PerformanceRating perfb
								 where perfb.PersonID = perf.PersonID
								 )
	AND
	perf.RatingPeriodEndDate = (
							   select Max(perfc.RatingPeriodEndDate) 
							   from dbo.PerformanceRating perfc
							   where perfc.PersonID = perf.PersonID
							   )
LEFT OUTER JOIN PerformanceRating perf2
	ON p.PersonID = perf2.PersonID
	AND
	perf2.RunDate = (
					select Max(perfx.RunDate) from dbo.PerformanceRating perfx
				    WHERE perfx.PersonID = perf2.PersonID
						  AND
						  perfx.[AppraisalTypeDescription] = 'Annual' AND perfx.[AppraisalStatus] = 'Completed'
					)
	AND
	perf2.OverallRating IS NOT NULL

	AND
	perf2.RatingPeriodStartDate = (
								 select Max(perfy.RatingPeriodStartDate) 
								 from dbo.PerformanceRating perfy
								 where perfy.PersonID = perf2.PersonID
									   AND
									   perfy.[AppraisalTypeDescription] = 'Annual' AND perfy.[AppraisalStatus] = 'Completed'
								 )
	AND
	perf2.RatingPeriodEndDate = (
							   select Max(perfz.RatingPeriodEndDate) 
							   from dbo.PerformanceRating perfz
							   where perfz.PersonID = perf2.PersonID
									 AND
									 perfz.[AppraisalTypeDescription] = 'Annual' AND perfz.[AppraisalStatus] = 'Completed'
							   )

	AND
	perf2.[AppraisalTypeDescription] = 'Annual'

-- join PPID for HasPP
LEFT OUTER JOIN PPID ppid					
	ON ppid.PersonID = p.PersonID
	AND
	ppid.PerformancePlanIssueDate = (select Max(ppid3.PerformancePlanIssueDate) 
									 from dbo.PPID ppid3
									 WHERE ppid3.PersonID = p.PersonID)
	AND
	ppid.RatingPeriodStartDate = (select Max(ppid4.RatingPeriodStartDate) 
								  from dbo.PPID ppid4
								  WHERE ppid4.PersonID = p.PersonID)
	AND
	ppid.RatingPeriodEndDate = (select Max(ppid5.RatingPeriodEndDate) 
							    from dbo.PPID ppid5
								WHERE ppid5.PersonID = p.PersonID)

LEFT OUTER JOIN dbo.Transactions t
	ON t.PersonID = p.PersonID
	   AND 
	   t.FAMILY_NOACS = 'NOAC 300 FAMILY Separations'

LEFT OUTER JOIN dbo.TransactionsHistory th
	ON th.PersonID = p.PersonID
	   AND 
	   th.FAMILY_NOACS = 'NOAC 300 FAMILY Separations'

) AS RosterIncludingExEmp
WHERE
	RN = 1










GO
