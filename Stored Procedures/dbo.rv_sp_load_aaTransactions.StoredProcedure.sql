USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_aaTransactions]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-05-16  
-- Description: Add the following new columns
--			    [Award Amount]
--				[Processed Date]
--				[AnnuitantIndicator]
--				[AnnuitantIndicatorDesc]
--				[PayRateDeterminant] 	
--				[PayRateDeterminantDesc]
--				[NOAC_AND_DESCRIPTION_2]
-- =============================================================================
CREATE procedure [dbo].[rv_sp_load_aaTransactions]
with execute as owner		
as
--  if the RunDate already exists in the aaTransactions table, abort the load	
	declare @DupCount int

	select @DupCount = count(distinct xx.[Run Date])
	from 
		 [dbo].xxTransactions xx 
		,[dbo].aaTransactions aa
	where xx.[Run Date] = aa.[Run Date] 

	print 'Run Date already exists in aaTransactions: ' + (CAST(@DupCount AS char(6)))
	
	if @DupCount > 0
	begin
		print 'Transaction data for this Run Date already loaded into aaTransactions'
		print 'No xxTransactions records loaded into aaTransactions'
		return
	end

INSERT INTO [dbo].[aaTransactions]
    (
    [ProcessedDate],
    [SSN],
    [Run Date],
    [Database],
    [Effective Date],
    [FY DESIGNATION],
    [FAMILY_NOACS],
    [NOAC_AND_DESCRIPTION],
    [First Action LA Code1],
    [First Action LA Desc1],
    [First Action LA Code2],
    [First Action LA Desc2],
    [Second NOA Code],
    [Second NOA Desc],
    [Full Name],
    [Tenure Desc],
    [Appointment Type Desc],
    [Type Of Employment Desc],
    [Veterans Preference Desc],
    [Veterans Status Desc],
    [Work Schedule Desc],
    [Reason For Separation Desc],
    [Supv Mgr Prob Completion],
    [Supv Mgr Prob Begin Date],
    [Date Conv Career Begins],
    [Date Conv Career Due],
    [Award Type Desc],
    [To Appropriation Code 1],
    [Pathways],
    [SCEP_STEP_PMF],
    [Flex2],
    [Pathways Program Start Date],
    [Pathways Program End Date],
    [Pathways Program Extn End Date],
    [From Office Symbol],
    [From Long Name],
    [F36],
    [To Office Symbol],
    [To Long Name],
    [F39],
    [From Position Agency Code/Subelement Description],
    [To Position Agency Code/Subelement Description],
    [What Kind of Movement],
    [From Position Control Number Indicator Description],
    [From Position Control Number Indicator],
    [From Position Control Number],
    [From PD Number],
    [From Position Sequence Number],
    [From PP-Series-Grade],
    [From Position Target Grade or Level],
    [To Position Control Number Indicator Description],
    [To Position Control Number Indicator],
    [To Position Control Number],
    [To PD Number],
    [To Position Sequence Number],
    [To PP-Series-Grade],
    [To Position Target Grade or Level],
    [From Pay Basis],
    [To Pay Basis],
    [FPL],
    [To FLSA Category],
    [From Position Title],
    [To Position Title],
    [Duty Station Name and State_Country],
    [From Region],
    [To Region],
    [From Servicing Region],
    [To Servicing Region],
    [To POI],
    [To Bargaining Unit Status Desc],
    [From Pos Supervisory Sts Desc],
    [To Supervisory Status Desc],
    [New Supervisor?],
    [Employee Number],
    [NOA Family Code],
    [Reason For Separation],
    [Retirement Plan],
    [Retirement Plan Desc],
    [Mandatory Retirement Date],
    [Tenure],
    [Credibility Mil Service],
    [Veterans Preference],
    [Veterans Status],
    [Type Of Employment],
    [RNO Desc],
    [RNO Code],
    [Handicap Code],
    [Handicap Code Desc],
    [Gender],
    [DOB],
    [Appointment Type ],
    [Agency Code Transfer From],
    [Agency Code Transfer From Desc],
    [Agency Code Transfer To],
    [Agency Code Transfer To Desc],
    [From Position Agency Code/Subelement],
    [To Position Agency Code/Subelement],
    [To Duty Station Code],
    [From Step Or Rate],
    [To Step Or Rate],
    [Hire Date],
    [Incentive Payment Option Code],
    [Incentive Payment Option Desc],
    [Incentive Payment Type (Categroy)],
    [Retention Incentive Review Date],
    [Total Incentive Amount/Percent],
    [Award Appropriation Code],
    [Award Approving Official Name],
    [Award Justification],
    [F106],
    [F107],
    [F108],
    [F109],
    [F110],
    [F111],
    [F112],
    [F113],
    [F114],
    [F115],
    [F116],
    [Award Type],
    [Award Type Desc1],
    [Award UOM],
    [From Basic Pay],
    [To Basic Pay],
    [From Adjusted Basic Pay],
    [To Adjusted Basic Pay],
    [From Total Pay],
    [To Total Pay],
    [AsOfDate]
    ,[Award Amount]					-- JJM 2016-05-16 Added
	,[Processed Date]				-- JJM 2016-05-16 Added
	,[Annuitant Indicator] 			-- JJM 2016-05-16 Added
	,[Annuitant Indicator Desc] 	-- JJM 2016-05-16 Added
	,[Pay Rate Determinant] 		-- JJM 2016-05-16 Added
	,[Pay Rate Determinant Desc] 	-- JJM 2016-05-16 Added
	,[NOAC_AND_DESCRIPTION_2] 		-- JJM 2016-05-16 Added

	)
    SELECT  
	    [ProcessedDate],
    [SSN],
    [Run Date],
    [Database],
    [Effective Date],
    [FY DESIGNATION],
    [FAMILY_NOACS],
    [NOAC_AND_DESCRIPTION],
    [First Action LA Code1],
    [First Action LA Desc1],
    [First Action LA Code2],
    [First Action LA Desc2],
    [Second NOA Code],
    [Second NOA Desc],
    [Full Name],
    [Tenure Desc],
    [Appointment Type Desc],
    [Type Of Employment Desc],
    [Veterans Preference Desc],
    [Veterans Status Desc],
    [Work Schedule Desc],
    [Reason For Separation Desc],
    [Supv Mgr Prob Completion],
    [Supv Mgr Prob Begin Date],
    [Date Conv Career Begins],
    [Date Conv Career Due],
    [Award Type Desc],
    [To Appropriation Code 1],
    [Pathways],
    [SCEP_STEP_PMF],
    [Flex2],
    [Pathways Program Start Date],
    [Pathways Program End Date],
    [Pathways Program Extn End Date],
    [From Office Symbol],
    [From Long Name],
    [F36],
    [To Office Symbol],
    [To Long Name],
    [F39],
    [From Position Agency Code/Subelement Description],
    [To Position Agency Code/Subelement Description],
    [What Kind of Movement],
    [From Position Control Number Indicator Description],
    [From Position Control Number Indicator],
    [From Position Control Number],
    [From PD Number],
    [From Position Sequence Number],
    [From PP-Series-Grade],
    [From Position Target Grade or Level],
    [To Position Control Number Indicator Description],
    [To Position Control Number Indicator],
    [To Position Control Number],
    [To PD Number],
    [To Position Sequence Number],
    [To PP-Series-Grade],
    [To Position Target Grade or Level],
    [From Pay Basis],
    [To Pay Basis],
    [FPL],
    [To FLSA Category],
    [From Position Title],
    [To Position Title],
    [Duty Station Name and State_Country],
    [From Region],
    [To Region],
    [From Servicing Region],
    [To Servicing Region],
    [To POI],
    [To Bargaining Unit Status Desc],
    [From Pos Supervisory Sts Desc],
    [To Supervisory Status Desc],
    [New Supervisor?],
    [Employee Number],
    [NOA Family Code],
    [Reason For Separation],
    [Retirement Plan],
    [Retirement Plan Desc],
    [Mandatory Retirement Date],
    [Tenure],
    [Credibility Mil Service],
    [Veterans Preference],
    [Veterans Status],
    [Type Of Employment],
    [RNO Desc],
    [RNO Code],
    [Handicap Code],
    [Handicap Code Desc],
    [Gender],
    [DOB],
    [Appointment Type ],
    [Agency Code Transfer From],
    [Agency Code Transfer From Desc],
    [Agency Code Transfer To],
    [Agency Code Transfer To Desc],
    [From Position Agency Code/Subelement],
    [To Position Agency Code/Subelement],
    [To Duty Station Code],
    [From Step Or Rate],
    [To Step Or Rate],
    [Hire Date],
    [Incentive Payment Option Code],
    [Incentive Payment Option Desc],
    [Incentive Payment Type (Categroy)],
    [Retention Incentive Review Date],
    [Total Incentive Amount/Percent],
    [Award Appropriation Code],
    [Award Approving Official Name],
    [Award Justification],
    [F106],
    [F107],
    [F108],
    [F109],
    [F110],
    [F111],
    [F112],
    [F113],
    [F114],
    [F115],
    [F116],
    [Award Type],
    [Award Type Desc1],
    [Award UOM],
    [From Basic Pay],
    [To Basic Pay],
    [From Adjusted Basic Pay],
    [To Adjusted Basic Pay],
    [From Total Pay],
    [To Total Pay],
	SYSDATETIME()
    ,[Award Amount]					-- JJM 2016-05-16 Added
	,[Processed Date]				-- JJM 2016-05-16 Added
	,[Annuitant Indicator] 			-- JJM 2016-05-16 Added
	,[Annuitant Indicator Desc] 	-- JJM 2016-05-16 Added
	,[Pay Rate Determinant] 		-- JJM 2016-05-16 Added
	,[Pay Rate Determinant Desc] 	-- JJM 2016-05-16 Added
	,[NOAC_AND_DESCRIPTION_2] 		-- JJM 2016-05-16 Added

FROM [dbo].[xxTransactions]




GO
