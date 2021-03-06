USE [HRDW]
GO
/****** Object:  View [dbo].[vChrisTrans-All-with-History]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [dbo].[vChrisTrans-All-with-History]
AS 
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-12-20  
-- Description: Created view to get data going back to current FY - 8 years
-- =============================================================================
-- =============================================================================
-- Author:      Ralph Silvestro
-- Date:        2017-09-14  
-- Description: Add FromOfficeSymbol2Char and ToOfficeSymbol2Char
-- ============================================================================= 
-- Author:      James McConville
-- Date:        2017-12-06  
-- Description: Add 2018 to Transactions and 2016 to TransactionsHistory
-- ============================================================================= 

SELECT 
--   Report fields --
     CAST(t.[RunDate] AS DATE) as RunDate
	,t.PersonID
    ,t.[FYDESIGNATION] 
	,t.[EffectiveDate] 
	,t.[ProcessedDate]

--   Person / Position fields - 1st Group --
    ,p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName	  
	,p.EmailAddress 
--	,s.[PosOrgAgySubelementDescription]

--   Action fields --
    ,t.FAMILY_NOACS 
    ,t.NOAC_AND_DESCRIPTION 
    ,t.[WhatKindofMovement] 
    ,t.[FirstActionLACode1] 
    ,t.[FirstActionLADesc1] 
    ,t.[FirstActionLACode2] 
    ,t.[FirstActionLADesc2] 
    ,t.[SecondNOACode] 
    ,t.[SecondNOADesc] 
    ,t.Flex2 

--   Person / Position fields - 2nd Group --
--    ,posD.[ComputeOptionalRetirement] 
    ,t.[DutyStationNameandStateCountry] 
    ,t.FPL 
    ,t.[NewSupervisor] 
    ,t.Pathways 
    ,t.SCEP_STEP_PMF 
    ,t.[TenureDesc]
    ,t.[TypeOfEmploymentDesc] 
    ,t.[WorkScheduleDesc] 
    ,t.[VeteransPreferenceDesc] 
    ,t.[VeteransStatusDesc] 

--   Appointment fields --
    ,t.[HireDate] 

--   Appointment / Conversion fields -- 
    ,t.[AppointmentTypeDesc] 
    ,t.[DateConvCareerBegins] 
    ,t.[DateConvCareerDue] 
    ,t.[SupvMgrProbCompletion] 
    ,t.[SupvMgrProbBeginDate] 

--   To Only fields - 1st Group --
    ,t.[ToAppropriationCode1] 
	,t.[ToBargainingUnitStatusDesc] 
    ,t.[ToFLSACategory] 

--   To / From fields - 1st Group --
    ,t.[ToLongName] 
    ,t.[ToOfficeSymbol] 
	--   2017-09-14 Add To OfficeSymbol2Char
    ,OfficeLkupTo.[OfficeSymbol2Char] AS ToOfficeSymbol2Char  
    ,t.[ToPayBasis] 
    ,t.[ToTotalPay] 
    ,t.[ToPDNumber] 

--   To Only fields - 2nd Group --
    ,t.[ToPOI] 
	,[AnnuitantIndicator]		
	,[AnnuitantIndicatorDesc]	
	,[PayRateDeterminant] 		
	,[PayRateDeterminantDesc]	
	,[NOAC_AND_DESCRIPTION_2]	


--   To / From fields - 2nd Group --
    ,t.ToPositionAgencyCodeSubelementDescription 
    ,t.[ToPositionControlNumber] 
    ,t.[ToPositionControlNumberIndicator] 
    ,t.[ToPositionControlNumberIndicatorDescription] 
    ,t.[ToPositionSequenceNumber] 
    ,t.[ToPositionTargetGradeorLevel] 
    ,t.[ToPositionTitle] 
    ,t.[ToPPSeriesGrade] 
    ,t.[ToRegion] 
    ,t.[ToServicingRegion] 
    ,t.[ToStepOrRate] 

--   To Only fields - 3rd Group --
    ,t.[ToSupervisoryStatusDesc] 

--   From / To fields - 1st Group --
    ,t.[FromLongName] 
    ,t.[FromOfficeSymbol] 
	--   2017-09-14 Add From OfficeSymbol2Char
    ,OfficeLkupFrom.[OfficeSymbol2Char] AS FromOfficeSymbol2Char 
    ,t.[FromPayBasis] 
    ,t.[FromPDNumber] 
    ,t.FromPositionAgencyCodeSubelementDescription 
    ,t.[FromPositionControlNumber] 
    ,t.[FromPositionControlNumberIndicator] 
    ,t.[FromPositionControlNumberIndicatorDescription] 
    ,t.[FromPositionSequenceNumber] 
	,t.[FromPositionTargetGradeorLevel] 
    ,t.[FromPositionTitle] 
    ,t.FromPosSupervisorySatusDesc AS FromPosSupervisoryStatusDesc
    ,t.[FromPPSeriesGrade] 
    ,t.[FromRegion] 
    ,t.[FromServicingRegion] 
    ,t.[FromStepOrRate] 
	,t.[FromTotalPay]

--   From Only fields --
    ,t.[ReasonForSeparationDesc] 

--   Award fields --
    ,t.[AwardUOM] 
    ,t.[AwardType] 
    ,t.[AwardTypeDesc] 
    ,t.[AwardAppropriationCode] 
    ,t.[AwardApprovingOfficialName] 
    ,t.[AwardJustification]
	,t.[AwardAmount]			
    ,t.[IncentivePaymentOptionCode] 
    ,t.[IncentivePaymentOptionDesc] 
    ,t.[IncentivePaymentTypeCategroy] 
    ,t.[RetentionIncentiveReviewDate] 
    ,t.[TotalIncentiveAmountPercent] 

FROM Transactions t  
INNER JOIN Person p
	ON p.PersonID = t.PersonID 
	-- Join to OfficeLkup for TO OfficeSymbol2Char
LEFT OUTER JOIN dbo.OfficeLkup OfficeLkupTo			
	on OfficeLkupTo.[OfficeSymbol] = [ToOfficeSymbol]	

-- Join to OfficeLkup for FROM OfficeSymbol2Char
LEFT OUTER JOIN dbo.OfficeLkup OfficeLkupFrom			
	on OfficeLkupFrom.[OfficeSymbol] = [FromOfficeSymbol]	
WHERE
	(
	(
	t.FYDESIGNATION = 'FY2017' 
	AND 
	t.RunDate = (select max(t2.rundate) from transactions t2 where t2.FYDESIGNATION = 'FY2017')
	)
	OR
	(
	t.FYDESIGNATION = 'FY2016'
	AND 
--	t.RunDate = (select max(t2.rundate) from transactions t2 where t2.FYDESIGNATION = 'FY2016')
	t.RunDate = '2016-12-12'
	)
	OR	 
	(
	t.FYDESIGNATION = 'FY2015'
	AND 
	t.RunDate = (select max(t2.rundate) from transactions t2 where t2.FYDESIGNATION = 'FY2015')
	)
	)
--
UNION
--
SELECT 
--   Report fields --
     CAST(t.[RunDate] AS DATE) as RunDate
	,t.PersonID
    ,t.[FYDESIGNATION] 
	,t.[EffectiveDate] 
	,t.[ProcessedDate]

--   Person / Position fields - 1st Group --
    ,p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName	  
	,p.EmailAddress 
--	,s.[PosOrgAgySubelementDescription]

--   Action fields --
    ,t.FAMILY_NOACS 
    ,t.NOAC_AND_DESCRIPTION 
    ,t.[WhatKindofMovement] 
    ,t.[FirstActionLACode1] 
    ,t.[FirstActionLADesc1] 
    ,t.[FirstActionLACode2] 
    ,t.[FirstActionLADesc2] 
    ,t.[SecondNOACode] 
    ,t.[SecondNOADesc] 
    ,t.Flex2 

--   Person / Position fields - 2nd Group --
--    ,posD.[ComputeOptionalRetirement] 
    ,t.[DutyStationNameandStateCountry] 
    ,t.FPL 
    ,t.[NewSupervisor] 
    ,t.Pathways 
    ,t.SCEP_STEP_PMF 
    ,t.[TenureDesc]
    ,t.[TypeOfEmploymentDesc] 
    ,t.[WorkScheduleDesc] 
    ,t.[VeteransPreferenceDesc] 
    ,t.[VeteransStatusDesc] 

--   Appointment fields --
    ,t.[HireDate] 

--   Appointment / Conversion fields -- 
    ,t.[AppointmentTypeDesc] 
    ,t.[DateConvCareerBegins] 
    ,t.[DateConvCareerDue] 
    ,t.[SupvMgrProbCompletion] 
    ,t.[SupvMgrProbBeginDate] 

--   To Only fields - 1st Group --
    ,t.[ToAppropriationCode1] 
	,t.[ToBargainingUnitStatusDesc] 
    ,t.[ToFLSACategory] 

--   To / From fields - 1st Group --
    ,t.[ToLongName] 
    ,t.[ToOfficeSymbol] 
	--   2017-09-14 Add To OfficeSymbol2Char
    ,OfficeLkupTo.[OfficeSymbol2Char] AS ToOfficeSymbol2Char  
    ,t.[ToPayBasis] 
    ,t.[ToTotalPay] 
    ,t.[ToPDNumber] 

--   To Only fields - 2nd Group --
    ,t.[ToPOI] 
	,[AnnuitantIndicator]		
	,[AnnuitantIndicatorDesc]	
	,[PayRateDeterminant] 		
	,[PayRateDeterminantDesc]	
	,[NOAC_AND_DESCRIPTION_2]	


--   To / From fields - 2nd Group --
    ,t.ToPositionAgencyCodeSubelementDescription 
    ,t.[ToPositionControlNumber] 
    ,t.[ToPositionControlNumberIndicator] 
    ,t.[ToPositionControlNumberIndicatorDescription] 
    ,t.[ToPositionSequenceNumber] 
    ,t.[ToPositionTargetGradeorLevel] 
    ,t.[ToPositionTitle] 
    ,t.[ToPPSeriesGrade] 
    ,t.[ToRegion] 
    ,t.[ToServicingRegion] 
    ,t.[ToStepOrRate] 

--   To Only fields - 3rd Group --
    ,t.[ToSupervisoryStatusDesc] 

--   From / To fields - 1st Group --
    ,t.[FromLongName] 
    ,t.[FromOfficeSymbol] 
	--   2017-09-14 Add From OfficeSymbol2Char
    ,OfficeLkupFrom.[OfficeSymbol2Char] AS FromOfficeSymbol2Char 
    ,t.[FromPayBasis] 
    ,t.[FromPDNumber] 
    ,t.FromPositionAgencyCodeSubelementDescription 
    ,t.[FromPositionControlNumber] 
    ,t.[FromPositionControlNumberIndicator] 
    ,t.[FromPositionControlNumberIndicatorDescription] 
    ,t.[FromPositionSequenceNumber] 
	,t.[FromPositionTargetGradeorLevel] 
    ,t.[FromPositionTitle] 
    ,t.FromPosSupervisorySatusDesc AS FromPosSupervisoryStatusDesc
    ,t.[FromPPSeriesGrade] 
    ,t.[FromRegion] 
    ,t.[FromServicingRegion] 
    ,t.[FromStepOrRate] 
	,t.[FromTotalPay]

--   From Only fields --
    ,t.[ReasonForSeparationDesc] 

--   Award fields --
    ,t.[AwardUOM] 
    ,t.[AwardType] 
    ,t.[AwardTypeDesc] 
    ,t.[AwardAppropriationCode] 
    ,t.[AwardApprovingOfficialName] 
    ,t.[AwardJustification]
	,t.[AwardAmount]			
    ,t.[IncentivePaymentOptionCode] 
    ,t.[IncentivePaymentOptionDesc] 
    ,t.[IncentivePaymentTypeCategroy] 
    ,t.[RetentionIncentiveReviewDate] 
    ,t.[TotalIncentiveAmountPercent] 

FROM Transactions t  
INNER JOIN Person p
	ON p.PersonID = t.PersonID 
		-- Join to OfficeLkup for TO OfficeSymbol2Char
LEFT OUTER JOIN dbo.OfficeLkup OfficeLkupTo			
	on OfficeLkupTo.[OfficeSymbol] = [ToOfficeSymbol]	

-- Join to OfficeLkup for FROM OfficeSymbol2Char
LEFT OUTER JOIN dbo.OfficeLkup OfficeLkupFrom			
	on OfficeLkupFrom.[OfficeSymbol] = [FromOfficeSymbol]	
WHERE

--	JJM 2016/04/04 - added max rundate selection
--	JJM 2017/12/06 - added 2017
	(
	(
	t.FYDESIGNATION = 'FY2018' 
	AND 
	t.RunDate = (select max(t2.rundate) from transactions t2 where t2.FYDESIGNATION = 'FY2018')
	)
	OR
	(
	t.FYDESIGNATION = 'FY2017' 
	AND 
	t.RunDate = (select max(t2.rundate) from transactions t2 where t2.FYDESIGNATION = 'FY2017')
	)
	OR
	(
	t.FYDESIGNATION = 'FY2016'
	AND 
	t.RunDate = (select max(t2.rundate) from transactions t2 where t2.FYDESIGNATION = 'FY2016')
	)
	OR	 
	(
	FYDESIGNATION = 'FY2015'
	AND 
	t.RunDate = (select max(t2.rundate) from transactions t2 where t2.FYDESIGNATION = 'FY2015')
	)
	)
--
UNION
--
SELECT 
--   Report fields --
     CAST(th.[RunDate] AS DATE) as RunDate
	,th.PersonID
    ,th.[FYDESIGNATION] 
	,th.[EffectiveDate] 
	,th.[ProcessedDate]

--   Person / Position fields - 1st Group --
    ,p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName	  
	,p.EmailAddress 
--	,s.[PosOrgAgySubelementDescription]

--   Action fields --
    ,th.FAMILY_NOACS 
    ,th.NOAC_AND_DESCRIPTION 
    ,th.[WhatKindofMovement] 
    ,th.[FirstActionLACode1] 
    ,th.[FirstActionLADesc1] 
    ,th.[FirstActionLACode2] 
    ,th.[FirstActionLADesc2] 
    ,th.[SecondNOACode] 
    ,th.[SecondNOADesc] 
    ,th.Flex2 

--   Person / Position fields - 2nd Group --
--    ,posD.[ComputeOptionalRetirement] 
    ,th.[DutyStationNameandStateCountry] 
    ,th.FPL 
    ,th.[NewSupervisor] 
    ,th.Pathways 
    ,th.SCEP_STEP_PMF 
    ,th.[TenureDesc]
    ,th.[TypeOfEmploymentDesc] 
    ,th.[WorkScheduleDesc] 
    ,th.[VeteransPreferenceDesc] 
    ,th.[VeteransStatusDesc] 

--   Appointment fields --
    ,th.[HireDate] 

--   Appointment / Conversion fields -- 
    ,th.[AppointmentTypeDesc] 
    ,th.[DateConvCareerBegins] 
    ,th.[DateConvCareerDue] 
    ,th.[SupvMgrProbCompletion] 
    ,th.[SupvMgrProbBeginDate] 

--   To Only fields - 1st Group --
    ,th.[ToAppropriationCode1] 
	,th.[ToBargainingUnitStatusDesc] 
    ,th.[ToFLSACategory] 

--   To / From fields - 1st Group --
    ,th.[ToLongName] 
    ,th.[ToOfficeSymbol] 
		--   2017-09-14 Add To OfficeSymbol2Char
    ,OfficeLkupTo.[OfficeSymbol2Char] AS ToOfficeSymbol2Char  
    ,th.[ToPayBasis] 
    ,th.[ToTotalPay] 
    ,th.[ToPDNumber] 

--   To Only fields - 2nd Group --
    ,th.[ToPOI] 
	,th.[AnnuitantIndicator]		
	,th.[AnnuitantIndicatorDesc]	
	,th.[PayRateDeterminant] 		
	,th.[PayRateDeterminantDesc]	
	,th.[NOAC_AND_DESCRIPTION_2]	


--   To / From fields - 2nd Group --
    ,th.ToPositionAgencyCodeSubelementDescription 
    ,th.[ToPositionControlNumber] 
    ,th.[ToPositionControlNumberIndicator] 
    ,th.[ToPositionControlNumberIndicatorDescription] 
    ,th.[ToPositionSequenceNumber] 
    ,th.[ToPositionTargetGradeorLevel] 
    ,th.[ToPositionTitle] 
    ,th.[ToPPSeriesGrade] 
    ,th.[ToRegion] 
    ,th.[ToServicingRegion] 
    ,th.[ToStepOrRate] 

--   To Only fields - 3rd Group --
    ,th.[ToSupervisoryStatusDesc] 

--   From / To fields - 1st Group --
    ,th.[FromLongName] 
    ,th.[FromOfficeSymbol] 
	--   2017-09-14 Add From OfficeSymbol2Char
    ,OfficeLkupFrom.[OfficeSymbol2Char] AS FromOfficeSymbol2Char 
    ,th.[FromPayBasis] 
    ,th.[FromPDNumber] 
    ,th.FromPositionAgencyCodeSubelementDescription 
    ,th.[FromPositionControlNumber] 
    ,th.[FromPositionControlNumberIndicator] 
    ,th.[FromPositionControlNumberIndicatorDescription] 
    ,th.[FromPositionSequenceNumber] 
	,th.[FromPositionTargetGradeorLevel] 
    ,th.[FromPositionTitle] 
    ,th.FromPosSupervisorySatusDesc AS FromPosSupervisoryStatusDesc
    ,th.[FromPPSeriesGrade] 
    ,th.[FromRegion] 
    ,th.[FromServicingRegion] 
    ,th.[FromStepOrRate] 
	,th.[FromTotalPay]

--   From Only fields --
    ,th.[ReasonForSeparationDesc] 

--   Award fields --
    ,th.[AwardUOM] 
    ,th.[AwardType] 
    ,th.[AwardTypeDesc] 
    ,th.[AwardAppropriationCode] 
    ,th.[AwardApprovingOfficialName] 
    ,th.[AwardJustification]
	,th.[AwardAmount]			
    ,th.[IncentivePaymentOptionCode] 
    ,th.[IncentivePaymentOptionDesc] 
    ,th.[IncentivePaymentTypeCategroy] 
    ,th.[RetentionIncentiveReviewDate] 
    ,th.[TotalIncentiveAmountPercent] 

FROM TransactionsHistory th  
INNER JOIN Person p
	ON p.PersonID = th.PersonID 
LEFT OUTER JOIN dbo.OfficeLkup OfficeLkupTo			
	on OfficeLkupTo.[OfficeSymbol] = [ToOfficeSymbol]	

-- Join to OfficeLkup for FROM OfficeSymbol2Char
LEFT OUTER JOIN dbo.OfficeLkup OfficeLkupFrom			
	on OfficeLkupFrom.[OfficeSymbol] = [FromOfficeSymbol]
WHERE
th.FYDESIGNATION IN ('FY2009'
					,'FY2010'
					,'FY2011'
					,'FY2012'
					,'FY2013'
					,'FY2014'
					,'FY2015' -- ADDED by Ralph Silvestro on 5-5-2017 Due to results missing from FY2015 in View per email from Anthony Calisti- not seeing FY2015
					,'FY2016') -- JJM 2017-12-06 Added
/*		(
		th.FYDESIGNATION >= 'FY'+ dbo.Riv_fn_ComputeFiscalYear(GETDATE()) 
		AND 
		th.FYDESIGNATION <= 'FY'+ cast( dbo.Riv_fn_ComputeFiscalYear(GETDATE()) - 8 as varchar(4) ) 
		) 
*/




GO
