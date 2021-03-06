USE [HRDW]
GO
/****** Object:  View [dbo].[vChrisTrans-300Family-XPII]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================================================
-- Author:      Ralph Silvestro
-- Date:        2017-09-14  
-- Description: Add FromOfficeSymbol2Char 
-- ============================================================================= 




CREATE VIEW [dbo].[vChrisTrans-300Family-XPII] AS 
SELECT
     c300.[RunDate] 
    ,c300.[EffectiveDate] 
    ,(CONVERT(NVARCHAR(4),datepart(YYYY,EffectiveDate))
		+ RIGHT('00' + CONVERT(NVARCHAR(2), DATEPART(MM, EffectiveDate)), 2)) AS Eff_YYYYMM
	,c300.[ProcessedDate]
--  ,c300.[IncentivePaymentOptionCode] 
--  ,c300.[IncentivePaymentOptionDesc] 
--  ,c300.[IncentivePaymentTypeCategroy] 

--  ,c300.[RetentionIncentiveReviewDate] 
--  ,c300.[TotalIncentiveAmountPercent] 
--  ,c300.[AwardUOM] 
--  ,c300.[AwardType] 
--  ,c300.[AwardAppropriationCode] 
--  ,c300.[AwardApprovingOfficialName] 

    ,c300.[HireDate] 
    ,c300.[FYDESIGNATION] AS FY_SEP 
--  ,c300.FAMILY_NOACS 
    ,c300.NOAC_AND_DESCRIPTION 

--  ,c300.[FirstActionLACode1] 
--  ,c300.[FirstActionLADesc1] 
--  ,c300.[FirstActionLACode2] 
--  ,c300.[FirstActionLADesc2] 

--  ,c300.[SecondNOACode] 
--  ,c300.[SecondNOADesc] 

    ,c300.[FullName]  --  updated as per 2276
--  ,c300.[FirstName]  --  updated as per 2276
--  ,c300.MiddleName  --  updated as per 2276
--  ,c300.LastName   --  updated as per 2276
    ,c300.EmailAddress  --  updated as per 2276

    ,c300.[TenureDesc] 
    ,c300.[AppointmentTypeDesc] 
    ,c300.[TypeOfEmploymentDesc] 
--  ,c300.[VeteransPreferenceDesc] 
--  ,c300.[VeteransStatusDesc] 

--  ,c300.[WorkScheduleDesc] 
    ,c300.[ReasonForSeparationDesc] 
--  ,c300.[SupvMgrProbCompletion] 
--  ,c300.[SupvMgrProbBeginDate] 

--  ,c300.[DateConvCareerBegins] 
--  ,c300.[DateConvCareerDue] 
--  ,c300.[AwardTypeDesc] 
    ,c300.[ToAppropriationCode1] 
    ,c300.Pathways 

    ,c300.SCEP_STEP_PMF 
--  ,c300.Flex2 
    ,c300.[FromOfficeSymbol] 
	,c300.FromOfficeSymbol2Char--Added 9-14-2017 by Ralph Silvestro
    ,c300.[FromLongName] 
--  ,c300.[ToOfficeSymbol] 
--  ,c300.[ToLongName] 

    ,c300.FromPositionAgencyCodeSubelementDescription 
--  ,c300.ToPositionAgencyCodeSubelementDescription 
    ,c300.[WhatKindofMovement] 
    ,c300.[FromPositionControlNumberIndicatorDescription] 
    ,c300.[FromPositionControlNumberIndicator] 

    ,c300.[FromPositionControlNumber] 
    ,c300.[FromPDNumber] 
--  ,c300.[FromPositionSequenceNumber] 
    ,c300.[FromPPSeriesGrade] 
--  ,c300.[FromStepOrRate] 
--  ,c300.[FromPositionTargetGradeorLevel] 

--  ,c300.[ToPositionControlNumberIndicatorDescription] 
--  ,c300.[ToPositionControlNumberIndicator] 
--  ,c300.[ToPositionControlNumber] 
--  ,c300.[ToPDNumber] 
--  ,c300.[ToPositionSequenceNumber] 

--  ,c300.[ToPPSeriesGrade] 
--  ,c300.[ToStepOrRate] 
--  ,c300.[ToPositionTargetGradeorLevel] 
--  ,c300.[FromPayBasis] 
--  ,c300.[ToPayBasis] 

--  ,c300.FPL 
--  ,c300.[ToFLSACategory] 
    ,c300.[FromPositionTitle] 
--  ,c300.[ToPositionTitle] 
    ,c300.[DutyStationNameandStateCountry] 

    ,c300.[FromRegion] 
--  ,c300.[ToRegion] 
    ,c300.[FromServicingRegion] 
--  ,c300.[ToServicingRegion] 
--  ,c300.[ToPOI] 
--	,c300.[ToBargainingUnitStatusDesc] 

--  ,c300.[ComputeOptionalRetirement] 

    ,c300.FromPosSupervisoryStatusDesc 
--  ,c300.[ToSupervisoryStatusDesc] 
    ,c300.[NewSupervisor] 
--  ,c300.[AwardJustification]
	,c300.PosOrgAgySubelementDescription AS SSO_Description

FROM [vChrisTrans-300Family] c300  



GO
