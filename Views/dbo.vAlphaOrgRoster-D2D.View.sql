USE [HRDW]
GO
/****** Object:  View [dbo].[vAlphaOrgRoster-D2D]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vAlphaOrgRoster-D2D]
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
-- Author:      Paul Tsagaroulis
-- Date:        2016-05-11
-- Description: Created new view for D2D using vAlphaOrgRoster-XPII
-- =============================================================================

SELECT 
	   ros.RecordDate
	  ,ros.FullName
	  ,ros.EmailAddress
	  ,ros.HSSO + ' (' +  ros.PosOrgAgySubelementCode + ')' AS [Pos Org Agy Subelement Desc]
--    ,dbo.Person.LastName + ', ' + dbo.Person.FirstName + ', ' + ISNULL(dbo.Person.MiddleName,'') AS [Empl Full Name]
	  ,ros.OfficeSymbol
	  ,ros.DutyStationName
	  ,ros.DutyStationState
      ,ros.PositionTitle
	  ,ros.PPSeriesGrade
	  ,ros.SupervisoryStatusCode
      ,ros.SupervisoryStatusDesc 
	  ,ros.LatestHireDate
      ,ros.Position_Supervisor  
--	  ,ros.SsoAbbreviation
--    ,ros.OfficeSymbol2Char
--	  ,ros.OccupationalSeriesCode 
--	  ,ros.Grade
--	  ,ros.TargetGradeOrLevel				-- JJM 2016-04-27 - TargetGrade added to base view
--	  ,ros.Step
--	  ,ros.RegionBasedOnDutyStation			-- JJM 2016-04-13 Added 	
--	  ,ros.PersonnelOfficeDescription
--	  ,ros.OwningRegion
--	  ,ros.ServicingRegion
--	  ,ros.Supervisor_Email
--	  ,ros.WorkAddressLine1
--	  ,ros.WorkBuilding
--	  ,ros.WorkCellPhoneNumber			
--	  ,ros.WorkTelephone				
--	  ,ros.DutyStationCode
--	  ,ros.DutyStationCounty
--	  ,ros.WorkState
--	  ,ros.ArrivedPersonnelOffice
--	  ,ros.ArrivedPresentGrade
--	  ,ros.ArrivedPresentPosition
--	  ,ros.ComputeEarlyRetirment AS ComputeEarlyRetirement			-- JJM 2016-04-13 Added
--	  ,ros.ComputeOptionalRetirement								-- JJM 2016-04-13 Added
--	  ,ros.SCDCivilian
--	  ,ros.SCDLeave
--	  ,ros.DateConversionCareerBegins	
--	  ,ros.DateConversionCareerDue	
--	  ,ros.DateLastPromotion
--	  ,ros.DateProbTrialPeriodBegins
--	  ,ros.DateProbTrialPeriodEnds	
--	  ,ros.DateVRAConversionDue
--	  ,ros.WGIDateDue
--	  ,ros.WGILastEquivalentIncreaseDate
--	  ,ros.PosAddressOrgInfoLine1
--	  ,ros.PosAddressOrgInfoLine2
--	  ,ros.PosAddressOrgInfoLine3
--	  ,ros.PosAddressOrgInfoLine4
--	  ,ros.PosAddressOrgInfoLine5
--	  ,ros.PosAddressOrgInfoLine6
--	  ,ros.AdjustedBasic		
--	  ,ros.BasicSalary
--	  ,ros.HourlyPay
--	  ,ros.LeaveCateGOry				
--	  ,ros.TotalPay			
--	  ,ros.AppointmentAuthCode
--	  ,ros.AppointmentAuthCode2
--	  ,ros.AppointmentAuthDesc
--	  ,ros.AppointmentAuthDesc2
--	  ,ros.AppointmentType
--	  ,ros.AppropriationCode
--	  ,ros.AssignmentUSErStatus					-- JJM 2016-04-13 Added
--	  ,ros.BargainingUnitOrg
--	  ,ros.BargainingUnitStatusDescription
--	  ,ros.BlockNumberDesc				
--	  ,ros.CompetativeArea				
--	  ,ros.CompetativeLevel				
--	  ,(ros.PositionInformationPD + ros.PositionSequenceNumber) AS CPCN
--	  ,ros.CybersecurityCodeDesc
--	  ,ros.EmploymentType
--	  ,ros.FinancialStatementDesc
--	  ,ros.FlsaCateGOryDescription
--	  ,ros.KeyEmergencyEssentialDescription
--	  ,ros.MCO
--	  ,ros.OccupationalCateGOryDescription	
--	  ,ros.OccupationalSeriesDescription	
--	  ,ros.IsPathways
--	  ,ros.PositionControlIndicator		
--	  ,ros.PositionControlNumber		
--	  ,ros.PositionInformationPD		
--	  ,ros.PositionSequenceNumber		
--	  ,ros.TenureDescription				-- JJM 2016-04-13 Added
--	  ,ros.TeleworkElgible
--	  ,ros.EmpStatus AS TeleworkEmpStatus
--	  ,ros.TeleworkIneligibReasonDescription
--	  ,ros.TeleworkStatus
--    ,ros.VeteransPreferenceDescription	-- JJM 2016-04-13 Added
--	  ,ros.VeteransStatusDescription		-- JJM 2016-04-13 Added
--	  ,ros.IsIDP_Current AS IDP_IsCurrent
--	  ,ros.AcademicInstitutionDesc
--	  ,ros.CollegeMajorMinorDesc	
--	  ,ros.DateofSESAppointment
--	  ,ros.DegreeObtained
--	  ,ros.EducationLevelDesc	
--	  ,ros.InstructionalProgramDesc
--	  ,ros.APPAS_FY
--	  ,ros.HasPP AS APPAS_HasPerformancePlan
--	  ,ros.[Annual Rating] AS APPAS_Review_Annual
--	  ,ros.[Mid Yr Rating] AS APPAS_Review_MidYear
--	  ,ros.ClearanceDate				
--	  ,ros.ClearanceDescription			
--	  ,ros.InvestigationType			
--	  ,ros.PublicTrustIndicatorDesc		
--	  ,ros.SecurityClearanceNumber		
	
FROM 
	 [vAlphaOrgRoster-Regular] ros





GO
