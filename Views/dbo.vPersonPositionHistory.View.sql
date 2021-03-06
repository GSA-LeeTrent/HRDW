USE [HRDW]
GO
/****** Object:  View [dbo].[vPersonPositionHistory]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vPersonPositionHistory] 
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-03-27  
-- Description: Created view of HRDW person / position info UNIONed with
--              HRDW_DEV person / position (as HRDW_DEV has history)
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-07-31  
-- Description: Fixed NULL OrgLongName issue by surrounding PosAddressOrgInfo1-6
--              with ISNULL.
-- =============================================================================
AS 

SELECT 
  p.[SSN]
, p.[EmailAddress]
, p.[LastName]
, p.[FirstName]
, p.[MiddleName]
, p.[BirthDate]
, p.[VeteransStatusDescription]
, p.[VeteransPreferenceDescription]
, p.[GenderDescription]
, p.[HandicapCode]
, p.[HandicapCodeDescription]
, p.[CitizenshipCode]
, p.[CitizenshipDescription]
, p.[RNOCode]
, rnolkup.RNODescription
, rnolkup.RNOCategory
, rnolkup.MinorityStatus
, p.[AcademicInstitutionCode]
, p.[AcademicInstitutionDesc]
, p.[CollegeMajorMinorCode]
, p.[CollegeMajorMinorDesc]
, p.[EducationLevelCode]
, p.[EducationLevelDesc]
, p.[InstructionalProgramCode]
, p.[InstructionalProgramDesc]
, p.[DegreeObtained]
, p.[AnnuitantIndicatorDescription]
, p.[AnnuitantIndicatorCode]
, p.[ReserveCategoryCode]
, p.[ReserveCategoryDescription]
, p.[RetirementPlanCode]
, p.[RetirementPlanDescription]
, p.[CreditableMilitaryService]
, p.[IsPathways]
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

, posI.[OfficeSymbol]
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

, posi.[DetailType]		
, posi.[DetailTypeDescription]


FROM 
	HRDW.[dbo].[Person] p
    INNER JOIN 
	    HRDW.dbo.Position pos
	    ON pos.PersonID = p.PersonID

	inner join 
		HRDW.dbo.PositionInfo posI
		on posI.PositionInfoId = pos.ChrisPositionId

    LEFT OUTER JOIN 
		HRDW.[dbo].[SSOLkup] s
        ON s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

	INNER JOIN 
		HRDW.dbo.RNOLkup rnolkup
		ON rnolkup.RNOCode = p.RNOCode				

UNION

SELECT 
  p.[SSN]
, p.[EmailAddress]
, p.[LastName]
, p.[FirstName]
, p.[MiddleName]
, p.[BirthDate]
, p.[VeteransStatusDescription]
, p.[VeteransPreferenceDescription]
, p.[GenderDescription]
, p.[HandicapCode]
, p.[HandicapCodeDescription]
, p.[CitizenshipCode]
, p.[CitizenshipDescription]
, p.[RNOCode]
, rnolkup.RNODescription
, rnolkup.RNOCategory
, rnolkup.MinorityStatus
, p.[AcademicInstitutionCode]
, p.[AcademicInstitutionDesc]
, p.[CollegeMajorMinorCode]
, p.[CollegeMajorMinorDesc]
, p.[EducationLevelCode]
, p.[EducationLevelDesc]
, p.[InstructionalProgramCode]
, p.[InstructionalProgramDesc]
, p.[DegreeObtained]
, p.[AnnuitantIndicatorDescription]
, p.[AnnuitantIndicatorCode]
, p.[ReserveCategoryCode]
, p.[ReserveCategoryDescription]
, p.[RetirementPlanCode]
, p.[RetirementPlanDescription]
, p.[CreditableMilitaryService]
, p.[IsPathways]
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
, pos.PosAddressOrgInfoLine1+' '+pos.PosAddressOrgInfoLine2+' '+pos.PosAddressOrgInfoLine3+' '+pos.PosAddressOrgInfoLine4+' '+pos.PosAddressOrgInfoLine5+' '+pos.PosAddressOrgInfoLine6 as OrgLongName

, pos.PublicTrustIndicatorCode	
, pos.PublicTrustIndicatorDesc	

, pos.[TeleworkIndicator]
, pos.[TeleworkIndicatorDescription]
, pos.[TeleworkIneligibilityReason]
, pos.[TeleworkIneligibReasonDescription]

, posI.[OfficeSymbol]
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

, posi.[DetailType]		
, posi.[DetailTypeDescription]

FROM 
	HRDW_DEV.[dbo].[Person] p
    INNER JOIN 
	    HRDW_DEV.dbo.Position pos
	    ON pos.PersonID = p.PersonID

	inner join 
		HRDW_DEV.dbo.PositionInfo posI
		on posI.PositionInfoId = pos.ChrisPositionId

    LEFT OUTER JOIN 
		HRDW_DEV.[dbo].[SSOLkup] s
        ON s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

	INNER JOIN 
		HRDW.dbo.RNOLkup rnolkup
		ON rnolkup.RNOCode = p.RNOCode				



GO
