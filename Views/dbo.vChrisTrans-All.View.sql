USE [HRDW]
GO
/****** Object:  View [dbo].[vChrisTrans-All]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vChrisTrans-All] --WITH SCHEMABINDING 
AS 
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-04-04  
-- Description: Added max run date to where clause and removed distinct from select
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-04-25  
-- Description: Re-order columns as requested by Paul Tsagaroulis.
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-04-27  
-- Description: Add AwardAmount and AwardProcessedDate
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-05-03  
-- Description: Add additional qualifiers to join on Position table
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
-- Author:      James McConville
-- Date:        2016-08-15  
-- Description: Re-Add ToTotalPay as incorrect version of view used to add the
--              column (view was missing 05-17 updates).
-- =============================================================================
-- Author:      Ralph Silvestro
-- Date:        2016-09-14  
-- Description: Add From / To OfficeSymbol2Char (and JOINs) for From / To
-- =============================================================================

SELECT 
--   Report fields --
     CAST(t.[RunDate] AS DATE) as RunDate
	,t.PersonID
    ,t.[FYDESIGNATION] 
	,t.[EffectiveDate] 
	,t.[ProcessedDate]						    -- JJM 2016-04-27 Added AwardProcessedDate 

--   Person / Position fields - 1st Group --
    ,p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName	  
	,p.EmailAddress 
	,s.[PosOrgAgySubelementDescription]

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
    ,posD.[ComputeOptionalRetirement] 
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
	,[AnnuitantIndicator]			--JJM 2016-05-17 Added 
	,[AnnuitantIndicatorDesc]		--JJM 2016-05-17 Added
	,[PayRateDeterminant] 			--JJM 2016-05-17 Added
	,[PayRateDeterminantDesc]		--JJM 2016-05-17 Added
	,[NOAC_AND_DESCRIPTION_2]		--JJM 2016-05-17 Added


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

--   From Only fields --
    ,t.[ReasonForSeparationDesc] 

--   Award fields --
    ,t.[AwardUOM] 
    ,t.[AwardType] 
    ,t.[AwardTypeDesc] 
    ,t.[AwardAppropriationCode] 
    ,t.[AwardApprovingOfficialName] 
    ,t.[AwardJustification]
	,t.[AwardAmount]							-- JJM 2016-04-27 Added AwardAmount 
    ,t.[IncentivePaymentOptionCode] 
    ,t.[IncentivePaymentOptionDesc] 
    ,t.[IncentivePaymentTypeCategroy] 
    ,t.[RetentionIncentiveReviewDate] 
    ,t.[TotalIncentiveAmountPercent] 

FROM Transactions t  
INNER JOIN Person p
	ON p.PersonID = t.PersonID 

INNER JOIN Position pos
	ON  pos.PersonID = p.PersonID	
--		JJM 2016-05-03 Adding additional qualification to Position Join
		and pos.RecordDate = 
			(
			select Max(pos1.RecordDate) as MaxRecDate 
			from dbo.Position pos1 
			where pos1.PersonID = pos.PersonID
			)
	    and pos.PositionDateID = 
			(
			select Max(pos2.PositionDateID) as MaxPosDateId 
			from dbo.Position pos2 
			where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate
			)
INNER JOIN PositionDate posD
	ON posD.PositionDateID = pos.PositionDateID 

INNER JOIN (select pos1.PersonID, Max(pos1.RecordDate) as MaxRecDate
			from Position pos1
			group by pos1.PersonID 
			having pos1.PersonID is not Null) PosMax 
	ON PosMax.PersonID = p.PersonID		
	and pos.RecordDate = PosMax.MaxRecDate 

LEFT OUTER JOIN [dbo].[SSOLkup] s
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

-- Join to OfficeLkup for TO OfficeSymbol2Char
LEFT OUTER JOIN dbo.OfficeLkup OfficeLkupTo			
	on OfficeLkupTo.[OfficeSymbol] = t.[ToOfficeSymbol]	

-- Join to OfficeLkup for FROM OfficeSymbol2Char
LEFT OUTER JOIN dbo.OfficeLkup OfficeLkupFrom			
	on OfficeLkupFrom.[OfficeSymbol] = t.[FromOfficeSymbol]	

WHERE
--	JJM 2016/04/04 - added max rundate selection
	t.RunDate = (select max(t2.rundate) from transactions t2)




GO
