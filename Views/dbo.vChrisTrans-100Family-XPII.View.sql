USE [HRDW]
GO
/****** Object:  View [dbo].[vChrisTrans-100Family-XPII]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================================================
-- Author:      Ralph Silvestro
-- Date:        2017-09-14  
-- Description:  ToOfficeSymbol2Char
-- ============================================================================= 



CREATE VIEW [dbo].[vChrisTrans-100Family-XPII]
    AS 
SELECT
     c100.[RunDate] 
    ,c100.[EffectiveDate]
    ,(CONVERT(NVARCHAR(4),datepart(YYYY,EffectiveDate))
		+ RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MM, EffectiveDate)), 2)) AS Eff_YYYYMM
	,c100.[ProcessedDate]
--  ,c100.[IncentivePaymentOptionCode] 
--  ,c100.[IncentivePaymentOptionDesc] 
--  ,c100.[IncentivePaymentTypeCategroy] 
--  ,c100.[RetentionIncentiveReviewDate] 
--  ,c100.[TotalIncentiveAmountPercent] 
--  ,c100.[AwardUOM] 
--  ,c100.[AwardType] 
--  ,c100.[AwardAppropriationCode] 
--  ,c100.[AwardApprovingOfficialName] 
    ,c100.[HireDate] 
    ,c100.[FYDESIGNATION] AS FY_APPT 
--  ,c100.FAMILY_NOACS 
    ,c100.NOAC_AND_DESCRIPTION 
--  ,c100.[FirstActionLACode1] 
--  ,c100.[FirstActionLADesc1] 
--  ,c100.[FirstActionLACode2] 
--  ,c100.[FirstActionLADesc2] 
--  ,c100.[SecondNOACode] 
--  ,c100.[SecondNOADesc] 
	,c100.[FullName]
--  ,c100.[FirstName]  -- Removed #2 columns as part of 2276
--  ,c100.MiddleName  -- Removed #2 columns as part of 2276
--  ,c100.LastName   -- Removed #2 columns as part of 2276
	,c100.EmailAddress  -- Removed #2 columns as part of 2276
    ,c100.[TenureDesc] 
    ,c100.[AppointmentTypeDesc] 
    ,c100.[TypeOfEmploymentDesc] 
--  ,c100.[VeteransPreferenceDesc] 
--  ,c100.[VeteransStatusDesc] 
--  ,c100.[WorkScheduleDesc] 
--  ,c100.[ReasonForSeparationDesc] 
--  ,c100.[SupvMgrProbCompletion] 
--  ,c100.[SupvMgrProbBeginDate] 
--  ,c100.[DateConvCareerBegins] 
--  ,c100.[DateConvCareerDue] 
--  ,c100.[AwardTypeDesc] 
    ,c100.[ToAppropriationCode1] 
    ,c100.Pathways 
    ,c100.SCEP_STEP_PMF 
--  ,c100.Flex2 
--  ,c100.[FromOfficeSymbol] 
--  ,c100.[FromLongName] 
    ,c100.[ToOfficeSymbol]
	,c100.ToOfficeSymbol2Char  
    ,c100.[ToLongName] 
--  ,c100.FromPositionAgencyCodeSubelementDescription 
    ,c100.ToPositionAgencyCodeSubelementDescription 
    ,c100.[WhatKindofMovement] 
--  ,c100.[FromPositionControlNumberIndicatorDescription] 
--  ,c100.[FromPositionControlNumberIndicator] 
--  ,c100.[FromPositionControlNumber] 
--  ,c100.[FromPDNumber] 
--  ,c100.[FromPositionSequenceNumber] 
--  ,c100.[FromPPSeriesGrade] 
--  ,c100.[FromStepOrRate] 
--	,c100.[FromPositionTargetGradeorLevel] 
--  ,c100.[ToPositionControlNumberIndicatorDescription] 
    ,c100.[ToPositionControlNumberIndicator] 
    ,c100.[ToPositionControlNumber] 
    ,c100.[ToPDNumber] 
--  ,c100.[ToPositionSequenceNumber] 
    ,c100.[ToPPSeriesGrade] 
--  ,c100.[ToStepOrRate] 
--  ,c100.[ToPositionTargetGradeorLevel] 
--  ,c100.[FromPayBasis] 
--  ,c100.[ToPayBasis] 
--  ,c100.FPL 
--  ,c100.[ToFLSACategory] 
--  ,c100.[FromPositionTitle] 
    ,c100.[ToPositionTitle] 
    ,c100.[DutyStationNameandStateCountry] 
--  ,c100.[FromRegion] 
    ,c100.[ToRegion] 
--  ,c100.[FromServicingRegion] 
--  ,c100.[ToServicingRegion] 
--  ,c100.[ToPOI] 
--  ,c100.[ToBargainingUnitStatusDesc] 
--  ,c100.[ComputeOptionalRetirement] 
--  ,c100.FromPosSupervisorySatusDesc 
--  ,c100.[ToSupervisoryStatusDesc] 
    ,c100.[NewSupervisor] 
--  ,c100.[AwardJustification] 
--  ,c100.[PosOrgAgySubelementCode] AS AgySubElemCode
	,c100.PosOrgAgySubelementDescription AS SSO_Description
FROM [vChrisTrans-100Family] c100


GO
