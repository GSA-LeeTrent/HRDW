USE [HRDW]
GO
/****** Object:  View [dbo].[vAlphaOrgRoster-XPII]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[vAlphaOrgRoster-XPII]
    AS 
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-04-13  
-- Description: Add Columns to Roster
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-04-21  
-- Description: Add Performance Rating Columns
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-04-26  
-- Description: - Re-order columns and re-label columns as requested by Paul Tsagaroulis.
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-04-27  
-- Description: Uncomment TargetPayPlan and TargetGradeOrLevel mapping
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-05-17  
-- Description: - Added new Financials and PositionInfo Columns
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-04-11  
-- Description: Added PerformancePlanIssueDate
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-04-26  
-- Description: Add the following columns:
--              - FYEarlyRetirement
--              - FYOptionalRetirement
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-06-01  
-- Description: Add the following columns:
--              - [ComputeEarlyRetirement(HRDW)]
--              - [ComputeOptionalRetirement(HRDW)]
--			    - SupDutyStationCode  
--			    - SupDutyStationName
--			    - SupDutyStationCounty
--			    - SupDutyStationState
--			    - SupRegion				
--			    - SupRegionBasedOnDutyStation
--			    - SupLocalityPayArea			
--			    - SupCoreBasedStatArea			
--			    - SupCombinedStatArea			
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-07-10  
-- Description: Renamed IsIDP_Current to IDP_CurrentFY and renamed IDPStatus
--              column to IDPStatus_CurrFY. Added 2 new columns: IDPStatus_NextFY
--              and IDP_NextFY
-- =============================================================================
-- Author:      Ralph Silvestro
-- Date:        2017-09-14  
-- Description: Add RegionBasedOnOfficeSymbol
-- =============================================================================

SELECT 
	   ros.RecordDate
	  ,ros.FullName
	  ,ros.Employee_LN						-- JJM 2016-10-04 Added
	  ,ros.Employee_FN						-- JJM 2016-10-04 Added
	  ,ros.Employee_MN						-- JJM 2016-10-04 Added
	  ,ros.EmailAddress
	  ,ros.SsoAbbreviation
	  ,ros.PosOrgAgySubelementCode
	  ,ros.HSSO								-- JJM 2016-04-13 Added
      ,ros.OfficeSymbol2Char
	  ,ros.OfficeSymbol
	  ,ros.PPSeriesGrade					
	  ,ros.OccupationalSeriesCode    
	  ,ros.Grade
	  ,ros.TargetGradeOrLevel				-- JJM 2016-04-27 - TargetGrade added to base view
	  ,ros.Step
	  ,ros.PersonnelOfficeDescription
	  ,ros.OwningRegion
	  ,ros.ServicingRegion
	  ,ros.Position_Supervisor
	  ,ros.Supervisor_Email
	  ,ros.WorkAddressLine1
	  ,ros.WorkBuilding
	  ,ros.WorkCellPhoneNumber			
	  ,ros.WorkTelephone				
	  ------------------------------
      -- Duty Station
      ------------------------------
	  ,ros.DutyStationCode
	  ,ros.DutyStationName
	  ,ros.DutyStationCounty
	  ,ros.DutyStationState
	  --Take out this data field per Paul T 9-19-2017
	 -- ,ros.Region				
	  ,ros.RegionBasedOnDutyStation
       -- 2017-09-14 Added RegionBasedOnOfficeSymbol
	  ,ros.RegionBasedOnOfficeSymbol
	  ,ros.LocalityPayArea		
	  ,ros.CoreBasedStatArea		
	  ,ros.CombinedStatArea		
	  -----------------------------------------------
	  -- Supervisor Duty Station - Added 2017-06-01
	  -----------------------------------------------
	  ,ros.SupDutyStationCode  
	  ,ros.SupDutyStationName
	  ,ros.SupDutyStationCounty
	  ,ros.SupDutyStationState
	  ,ros.SupRegion				
	  ,ros.SupRegionBasedOnDutyStation
	  ,ros.SupLocalityPayArea			
	  ,ros.SupCoreBasedStatArea			
	  ,ros.SupCombinedStatArea			

	  ,ros.WorkState
	  ,ros.ArrivedPersonnelOffice
	  ,ros.ArrivedPresentGrade
	  ,ros.ArrivedPresentPosition
	  ,ros.ComputeEarlyRetirment AS ComputeEarlyRetirement			-- JJM 2016-04-13 Added
	  ,ros.FYEarlyRetirement										-- JJM 2017-04-26 Added
	  ,ros.[ComputeEarlyRetirement(HRDW)]							-- JJM 2017-06-01 Added
	  ,ros.ComputeOptionalRetirement								-- JJM 2016-04-13 Added
	  ,ros.FYOptionalRetirement										-- JJM 2017-04-26 Added
	  ,ros.[ComputeOptionalRetirement(HRDW)]						-- JJM 2017-06-01 Added
	  ,ros.SCDCivilian
	  ,ros.SCDLeave
	  ,ros.DateConversionCareerBegins	
	  ,ros.DateConversionCareerDue	
	  ,ros.DateLastPromotion
	  ,ros.DateProbTrialPeriodBegins
	  ,ros.DateProbTrialPeriodEnds	
	  ,ros.DateVRAConversionDue
	  ,ros.LatestHireDate
	  ,ros.WGIDateDue
	  ,ros.WGILastEquivalentIncreaseDate
	  ,ros.PosAddressOrgInfoLine1
	  ,ros.PosAddressOrgInfoLine2
	  ,ros.PosAddressOrgInfoLine3
	  ,ros.PosAddressOrgInfoLine4
	  ,ros.PosAddressOrgInfoLine5
	  ,ros.PosAddressOrgInfoLine6
	  ,ros.AdjustedBasic		
	  ,ros.BasicSalary
	  ,ros.HourlyPay
	  ,ros.LeaveCateGOry				
	  ,ros.TotalPay			
	  ,ros.AppointmentAuthCode
	  ,ros.AppointmentAuthCode2
	  ,ros.AppointmentAuthDesc
	  ,ros.AppointmentAuthDesc2
	  ,ros.AppointmentType
	  ,ros.AppropriationCode
      ,ros.[PayRateDeterminantCode]				-- JJM 2016-05-17 Added	
	  ,ros.[PayRateDeterminantDescription]		-- JJM 2016-05-17 Added	

	  ,ros.AssignmentUSErStatus					-- JJM 2016-04-13 Added
	  ,ros.[DetailType]							-- JJM 2016-05-17 Added
      ,ros.[DetailTypeDescription]				-- JJM 2016-05-17 Added

	  ,ros.BargainingUnitOrg
	  ,ros.BargainingUnitStatusDescription
	  ,ros.BlockNumberDesc				
	  ,ros.CompetativeArea				
	  ,ros.CompetativeLevel				
	  ,(ros.PositionInformationPD + ros.PositionSequenceNumber) AS CPCN
	  ,ros.CybersecurityCodeDesc
	  ,ros.EmploymentType
	  ,ros.FinancialStatementDesc
	  ,ros.FlsaCateGOryDescription
	  ,ros.KeyEmergencyEssentialDescription
	  ,ros.MCO
	  ,ros.OccupationalCateGOryDescription	
	  ,ros.OccupationalSeriesDescription	
	  ,ros.IsPathways
	  ,ros.PositionControlIndicator		
	  ,ros.PositionControlNumber		
	  ,ros.PositionInformationPD		
	  ,ros.PositionSequenceNumber		
      ,ros.PositionTitle
	  ,ros.SupervisoryStatusDesc
	  ,ros.TenureDescription				-- JJM 2016-04-13 Added
	  ,ros.TeleworkElgible
	  ,ros.EmpStatus AS TeleworkEmpStatus
	  ,ros.TeleworkIneligibReasonDescription
	  ,ros.TeleworkStatus
      ,ros.VeteransPreferenceDescription	-- JJM 2016-04-13 Added
	  ,ros.VeteransStatusDescription		-- JJM 2016-04-13 Added
	  ,ros.IDPStatus_CurrentFY
	  ,ros.IDP_CurrentFY
	  ,ros.IDPStatus_NextFY
	  ,ros.IDP_NextFY
	  ,ros.AcademicInstitutionDesc
	  ,ros.CollegeMajorMinorDesc	
	  ,ros.DateofSESAppointment
	  ,ros.DegreeObtained
	  ,ros.EducationLevelDesc	
	  ,ros.InstructionalProgramDesc
	  ,ros.APPAS_FY
	  ,ros.HasPP AS APPAS_HasPerformancePlan
	  ,ros.PerformancePlanIssueDate
	  ,ros.[Annual Rating] AS APPAS_Review_Annual
	  ,ros.[Mid Yr Rating] AS APPAS_Review_MidYear
	  ,ros.ClearanceDate				
	  ,ros.ClearanceDescription			
	  ,ros.InvestigationType			
	  ,ros.PublicTrustIndicatorDesc		
	  ,ros.SecurityClearanceNumber		
	
FROM 
	 [vAlphaOrgRoster-Regular] ros








GO
