USE [HRDW]
GO
/****** Object:  View [dbo].[vAlphaOrgRoster-PII-Plus]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[vAlphaOrgRoster-PII-Plus] -- WITH SCHEMABINDING 
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-03-06  
-- Description: View Updated to get RNODecription from RNOLkup instead of Person
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-03-21  
-- Description: View Updated to use RNOCategory instead of RNOCode_Cleanedup
--              and add MinorityStatus
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-05-23  
-- Description: Changed a.* to individual columns and Added same Duty Station 
--              columns for supervisor as Employee 
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-07-24  
-- Description: Renamed IsIDP_Current to IDP_CurrentFY and renamed IDPStatus
--              column to IDPStatus_CurrentFY. Added 2 new columns: IDPStatus_NextFY
--              and IDP_NextFY
-- =============================================================================
-- =============================================================================
-- Author:      Ralph Silvestro
-- Date:        2017-09-15  
-- Description: Add RegionBasedOnOfficeSymbol
-- =============================================================================
AS 

SELECT 
	pii.SSN
	, pii.EmployeeNumber
	, pii.AnnuitantIndicatorCode
	, pii.AnnuitantIndicatorDescription
	, pii.CitizenshipDescription
	, pii.HandicapCode
	, pii.HandicapCodeDescription
	, pii.GenderDescription
	, pii.RNOCode
	, rnolkup.RNODescription
	, rnolkup.RNOCategory
	, rnolkup.MinorityStatus
	, pii.RetirementPlanCode
	, pii.RetirementPlanDescription
	, pii.ReserveCategoryCode
	, pii.ReserveCategoryDescription
	, pii.CreditableMilitaryService
	, pii.BirthDate
	  ,a.[PersonID]
      ,a.[FullName]
      ,a.[Employee_LN]
      ,a.[Employee_FN]
      ,a.[Employee_MN]
      ,a.[VeteransPreferenceDescription]
      ,a.[VeteransStatusDescription]
      ,a.[EmailAddress]
      ,a.[AcademicInstitutionCode]
      ,a.[AcademicInstitutionDesc]
      ,a.[CollegeMajorMinorCode]
      ,a.[CollegeMajorMinorDesc]
      ,a.[EducationLevelCode]
      ,a.[EducationLevelDesc]
      ,a.[InstructionalProgramCode]
      ,a.[InstructionalProgramDesc]
      ,a.[DegreeObtained]
      ,a.[IsPathways]
      ,a.[Position_Supervisor]
      ,a.[Supervisor_Email]
      ,a.[Supervisor_Workphone]
      ,a.[Supervisor_CellPhone]
      ,a.[FY]
      ,a.[Month_Name]
      ,a.[RecordDate]
      ,a.[TenureDescription]
      ,a.[LeaveCateGOry]
      ,a.[CompetativeArea]
      ,a.[CompetativeLevel]
      ,a.[CybersecurityCode]
      ,a.[CybersecurityCodeDesc]
      ,a.[FlsaCateGOryCode]
      ,a.[FlsaCateGOryDescription]
      ,a.[KeyEmergencyEssentialCode]
      ,a.[KeyEmergencyEssentialDescription]
      ,a.[AssignmentUSErStatus]
      ,a.[MCO]
      ,a.[BargainingUnitStatusDescription]
      ,a.[BargainingUnitOrg]
      ,a.[PosOrgAgySubelementCode]
      ,a.[HSSO]
      ,a.[SsoAbbreviation]
      ,a.[WorkTelephone]
      ,a.[WorkCellPhoneNumber]
      ,a.[WorkBuilding]
      ,a.[WorkAddressLine1]
      ,a.[WorkAddressLine2]
      ,a.[WorkAddressLine3]
      ,a.[WorkCounty]
      ,a.[WorkState]
      ,a.[WorkZip]
      ,a.[PosAddressOrgInfoLine1]
      ,a.[PosAddressOrgInfoLine2]
      ,a.[PosAddressOrgInfoLine3]
      ,a.[PosAddressOrgInfoLine4]
      ,a.[PosAddressOrgInfoLine5]
      ,a.[PosAddressOrgInfoLine6]
      ,a.[OrgLongName]
      ,a.[PublicTrustIndicatorCode]
      ,a.[PublicTrustIndicatorDesc]
      ,a.[TeleworkIndicator]
      ,a.[TeleworkIndicatorDescription]
      ,a.[TeleworkIneligibilityReason]
      ,a.[TeleworkIneligibReasonDescription]
      ,a.[LatestHireDate]
      ,a.[SCDCivilian]
      ,a.[SCDLeave]
      ,a.[ComputeEarlyRetirment]
      ,a.[ComputeEarlyRetirement(HRDW)]
      ,a.[ComputeOptionalRetirement]
      ,a.[ComputeOptionalRetirement(HRDW)]
      ,a.[WGIDateDue]
      ,a.[WGILastEquivalentIncreaseDate]
      ,a.[DateLastPromotion]
      ,a.[ArrivedPersonnelOffice]
      ,a.[ArrivedPresentGrade]
      ,a.[ArrivedPresentPosition]
      ,a.[DateProbTrialPeriodBegins]
      ,a.[DateProbTrialPeriodEnds]
      ,a.[DateConversionCareerBegins]
      ,a.[DateConversionCareerDue]
      ,a.[DateofSESAppointment]
      ,a.[DateSESProbExpires]
      ,a.[DateVRAConversionDue]
      ,a.[LatestSeparationDate]
      ,a.[OfficeSymbol]
      ,a.[OfficeSymbol2Char]
      ,a.[PositionEncumberedType]
      ,a.[PositionControlNumber]
      ,a.[PositionControlIndicator]
      ,a.[PositionInformationPD]
      ,a.[PositionSequenceNumber]
      ,a.[SupervisoryStatusCode]
      ,a.[SupervisoryStatusDesc]
      ,a.[PositionTitle]
      ,a.[OccupationalCateGOryDescription]
      ,a.[PPSeriesGrade]
      ,a.[PositionSeries]
      ,a.[Grade]
      ,a.[Step]
      ,a.[SupvMgrProbationRequirementCode]
      ,a.[SupvMgrProbationRequirementDesc]
      ,a.[OccupationalSeriesCode]
      ,a.[OccupationalSeriesDescription]
      ,a.[TargetPayPlan]
      ,a.[TargetGradeOrLevel]
      ,a.[DetailType]
      ,a.[DetailTypeDescription]
      ,a.[EmploymentType]
      ,a.[AppointmentType]
      ,a.[BlockNumberCode]
      ,a.[BlockNumberDesc]
      ,a.[AppropriationCode]
      ,a.[OrgCodeBudgetFinance]
      ,a.[FundCode]
      ,a.[BudgetActivity]
      ,a.[CostElement]
      ,a.[ObjectClass]
      ,a.[ORG_BA_FC]
      ,a.[RR_ORG_BA_FC]
      ,a.[AppointmentAuthCode]
      ,a.[AppointmentAuthDesc]
      ,a.[AppointmentAuthCode2]
      ,a.[AppointmentAuthDesc2]
      ,a.[FinancialStatementCode]
      ,a.[FinancialStatementDesc]
      ,a.[PayRateDeterminantCode]
      ,a.[PayRateDeterminantDescription]
      ,a.[OwningRegion]
      ,a.[ServicingRegion]
      ,a.[PersonnelOfficeDescription]
      ,a.[DutyStationCode]
      ,a.[DutyStationName]
      ,a.[DutyStationCounty]
      ,a.[DutyStationState]
      ,a.[Region]
      ,a.[RegionBasedOnDutyStation]
	   -- 2017-09-14 Added RegionBasedOnOfficeSymbol
	  ,a.RegionBasedOnOfficeSymbol
      ,a.[LocalityPayArea]
      ,a.[CoreBasedStatArea]
      ,a.[CombinedStatArea]
      ,a.[SupDutyStationCode]
      ,a.[SupDutyStationName]
      ,a.[SupDutyStationCounty]
      ,a.[SupDutyStationState]
      ,a.[SupRegion]
      ,a.[SupRegionBasedOnDutyStation]
      ,a.[SupLocalityPayArea]
      ,a.[SupCoreBasedStatArea]
      ,a.[SupCombinedStatArea]
      ,a.[BasicSalary]
      ,a.[AdjustedBasic]
      ,a.[TotalPay]
      ,a.[HourlyPay]
      ,a.[ClearanceDate]
      ,a.[InvestigationType]
      ,a.[ClearanceDescription]
      ,a.[SecurityClearanceNumber]
      ,a.[FiscalYearValidation]
      ,a.[IDPStatus_CurrentFY]
      ,a.[IDP_CurrentFY]
      ,a.[IDPStatus_NextFY]
      ,a.[IDP_NextFY]
      ,a.[RunDate]
      ,a.[PerformancePlanIssueDate]
      ,a.[HasPP]
      ,a.[APPAS_FY]
      ,a.[MID Yr Rating]
      ,a.[Annual Rating]
      ,a.[TeleworkStatus]
      ,a.[EmpStatus]
      ,a.[TeleworkElgible]
      ,a.[IsEmpStatusBlank]
      ,a.[DrugTestCode]
      ,a.[DrugTestDescription]
FROM
	[dbo].[vAlphaOrgRoster-Regular-Plus] a
	INNER JOIN Person pii
		ON pii.PersonID = a.PersonID
	LEFT OUTER JOIN RNOLkup rnolkup
		ON rnolkup.RNOCode = pii.RNOCode
		







GO
