USE [HRDW]
GO
/****** Object:  View [dbo].[vChrisTrans-All-Excluding-800]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Object:  View [dbo].[vChrisTrans-All-Excluding-800]    Script Date: 04/27/2016 09:11:05 ******/
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-04-27  
-- Description: Created view - select from vChrisTrans-All <> 800 Family
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-04-27  
-- Description: Add AwardAmount and AwardProcessedDate
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-05-17  
-- Description: Added new columns:
--				[AnnuitantIndicator]		
--				[AnnuitantIndicatorDesc]	
--				[PayRateDeterminant] 	
--				[PayRateDeterminantDesc]
--				[NOAC_AND_DESCRIPTION_2]
-- =============================================================================
-- =============================================================================
-- Author:      Ralph Silvestro
-- Date:        2017-09-14  
-- Description: Add FromOfficeSymbol2Char and ToOfficeSymbol2Char
-- ============================================================================= 


CREATE VIEW [dbo].[vChrisTrans-All-Excluding-800] --WITH SCHEMABINDING 
AS 

SELECT 
--   Report -- 
     [RunDate] 
    ,[FYDESIGNATION] 
    ,[EffectiveDate] 
	,[ProcessedDate]						-- JJM 2016-04-27 Added ProcessedDate 
--   Person / Position --
	,FullName		
	,EmailAddress 
	,[PosOrgAgySubelementDescription]			

--  Action --
    ,FAMILY_NOACS 
    ,NOAC_AND_DESCRIPTION 
    ,[WhatKindofMovement] 
    ,[FirstActionLACode1] 
    ,[FirstActionLADesc1] 
    ,[FirstActionLACode2] 
    ,[FirstActionLADesc2] 
    ,[SecondNOACode] 
    ,[SecondNOADesc] 
    ,Flex2 

--   Person / Position --
    ,[ComputeOptionalRetirement]
    ,[DutyStationNameandStateCountry] 
    ,FPL 
    ,[NewSupervisor] 
    ,Pathways 
    ,SCEP_STEP_PMF 
    ,[TenureDesc] 
    ,[TypeOfEmploymentDesc] 
    ,[WorkScheduleDesc] 
    ,[VeteransPreferenceDesc] 
    ,[VeteransStatusDesc] 

--   Appointment --
    ,[HireDate] 

--   Appointment / Conversion --
    ,[AppointmentTypeDesc] 
    ,[DateConvCareerBegins] 
    ,[DateConvCareerDue] 
    ,[SupvMgrProbBeginDate] 
    ,[SupvMgrProbCompletion] 

--   To Only --
    ,[ToAppropriationCode1] 
	,[ToBargainingUnitStatusDesc] 
    ,[ToFLSACategory] 

--   To / From --
    ,[ToLongName] 
    ,[ToOfficeSymbol] 
	,ToOfficeSymbol2Char --ADDED 2017-09-14 BY RALPH SILVESTRO
    ,[ToPayBasis] 
    ,[ToPDNumber] 

--   To Only --
    ,[ToPOI] 
	,[AnnuitantIndicator]			--JJM 2016-05-17 Added 
	,[AnnuitantIndicatorDesc]		--JJM 2016-05-17 Added
	,[PayRateDeterminant] 			--JJM 2016-05-17 Added
	,[PayRateDeterminantDesc]		--JJM 2016-05-17 Added
	,[NOAC_AND_DESCRIPTION_2]		--JJM 2016-05-17 Added

--   To / From --
    ,ToPositionAgencyCodeSubelementDescription 
    ,[ToPositionControlNumber] 
    ,[ToPositionControlNumberIndicator] 
    ,[ToPositionControlNumberIndicatorDescription] 
    ,[ToPositionSequenceNumber] 
    ,[ToPositionTargetGradeorLevel] 
    ,[ToPositionTitle] 
    ,[ToPPSeriesGrade] 
    ,[ToRegion] 
    ,[ToServicingRegion] 
    ,[ToStepOrRate] 

--   To Only --
    ,[ToSupervisoryStatusDesc] 

--   From / To --
    ,[FromLongName] 
    ,[FromOfficeSymbol]
	,FromOfficeSymbol2Char--ADDED 2017-09-14 BY RALPH SILVESTRO 
    ,[FromPayBasis] 
    ,[FromPDNumber] 
    ,FromPositionAgencyCodeSubelementDescription 
    ,[FromPositionControlNumber] 
    ,[FromPositionControlNumberIndicator] 
    ,[FromPositionControlNumberIndicatorDescription] 
    ,[FromPositionSequenceNumber] 
	,[FromPositionTargetGradeorLevel] 
    ,[FromPositionTitle] 
    ,FromPosSupervisoryStatusDesc 
    ,[FromPPSeriesGrade] 
    ,[FromRegion] 
    ,[FromServicingRegion] 
    ,[FromStepOrRate] 

--   From Only --
    ,[ReasonForSeparationDesc] 

--   Award --
    ,[AwardUOM] 
    ,[AwardType] 
    ,[AwardTypeDesc] 
    ,[AwardAppropriationCode] 
    ,[AwardApprovingOfficialName] 
    ,[AwardJustification]  
	,[AwardAmount]							-- JJM 2016-04-27 Added AwardAmount 
    ,[IncentivePaymentOptionCode] 
    ,[IncentivePaymentOptionDesc] 
    ,[IncentivePaymentTypeCategroy] 
    ,[RetentionIncentiveReviewDate] 
    ,[TotalIncentiveAmountPercent] 

from [dbo].[vChrisTrans-All]
where FAMILY_NOACS <> 'NOAC 800 Family Transactions'
	  and (
		FYDESIGNATION = 'FY'+ dbo.Riv_fn_ComputeFiscalYear(GETDATE()) 
		or FYDESIGNATION = 'FY'+ cast( dbo.Riv_fn_ComputeFiscalYear(GETDATE())-1 as varchar(4) ) 
	  ) 



GO
