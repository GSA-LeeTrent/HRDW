USE [HRDW]
GO
/****** Object:  View [REPORTING].[vAlphaOrgRoster-XPII-with-ExEmp]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [REPORTING].[vAlphaOrgRoster-XPII-with-ExEmp]
    AS 
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-06-01  
-- Description: Created
-- =============================================================================
-- =============================================================================
-- Author:      Ralph Silvestro
-- Date:        2017-09-15  
-- Description: Add RegionBasedOnOfficeSymbol
-- =============================================================================
SELECT 
	   ros.RecordDate
	  ,ros.FullName
	  ,ros.EmailAddress
	  ,ros.SsoAbbreviation
	  ,ros.HSSO					
      ,ros.OfficeSymbol2Char
	  ,ros.OfficeSymbol
	  ,ros.PPSeriesGrade					
	  ,ros.OccupationalSeriesCode    
	  ,ros.Grade
	  ,ros.TargetGradeOrLevel	
	  ,ros.Step
	  ,ros.RegionBasedOnDutyStation
	  ,ros.RegionBasedOnOfficeSymbol
	  ,ros.PersonnelOfficeDescription
	  ,ros.OwningRegion
	  ,ros.ServicingRegion
	  ,ros.Position_Supervisor
	  ,ros.Supervisor_Email
	  ,ros.WorkAddressLine1
	  ,ros.WorkBuilding
	  ,ros.WorkCellPhoneNumber			
	  ,ros.WorkTelephone				
	  ,ros.DutyStationCode
	  ,ros.DutyStationCounty
	  ,ros.DutyStationName
	  ,ros.DutyStationState
	  ,ros.WorkState
	  ,ros.ArrivedPersonnelOffice
	  ,ros.ArrivedPresentGrade
	  ,ros.ArrivedPresentPosition
	  ,ros.ComputeEarlyRetirment AS ComputeEarlyRetirement
	  ,ros.ComputeOptionalRetirement						
	  ,ros.SCDCivilian
	  ,ros.SCDLeave
	  ,ros.DateConversionCareerBegins	
	  ,ros.DateConversionCareerDue	
	  ,ros.DateLastPromotion
	  ,ros.DateProbTrialPeriodBegins
	  ,ros.DateProbTrialPeriodEnds	
	  ,ros.DateVRAConversionDue
	  ,ros.LatestHireDate
	  ,ros.LatestSeparationDate
	  ,ros.PositionEncumberedType
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
	  ,ros.AssignmentUSErStatus				
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
	  ,ros.TenureDescription				
	  ,ros.TeleworkElgible
	  ,ros.EmpStatus AS TeleworkEmpStatus
	  ,ros.TeleworkIneligibReasonDescription
	  ,ros.TeleworkStatus
      ,ros.VeteransPreferenceDescription	
	  ,ros.VeteransStatusDescription		
	  ,ros.IsIDP_Current AS IDP_IsCurrent
	  ,ros.AcademicInstitutionDesc
	  ,ros.CollegeMajorMinorDesc	
	  ,ros.DateofSESAppointment
	  ,ros.DegreeObtained
	  ,ros.EducationLevelDesc	
	  ,ros.InstructionalProgramDesc
	  ,ros.APPAS_FY
	  ,ros.HasPP AS APPAS_HasPerformancePlan
	  ,ros.[Annual Rating] AS APPAS_Review_Annual
	  ,ros.[Mid Yr Rating] AS APPAS_Review_MidYear
	  ,ros.ClearanceDate				
	  ,ros.ClearanceDescription			
	  ,ros.InvestigationType			
	  ,ros.PublicTrustIndicatorDesc		
	  ,ros.SecurityClearanceNumber		
	
FROM 
	 [dbo].[vAlphaOrgRoster-with-ExEmployees] ros






GO
