USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_TransactionsHistory_by_FY]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--DROP procedure [dbo].[rv_sp_load_TransactionsHistory_by_FY]  
--GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-04-20  
-- Description: Created Stored Procedure to load TransactionsHistory for a
--              specific FY (passed as a parameter.
-- =============================================================================

CREATE procedure [dbo].[rv_sp_load_TransactionsHistory_by_FY]  
(
@FY CHAR(6)
)
with execute as owner

AS

Begin

print '=========================================================' 
print 'Inside TransactionsHistory, executing... '  
print '=========================================================' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)

print 'Start Date Time: '
print SYSDATETIME()
print ' '
    declare @recDateCount int 
	declare @priorTableCount int  -- After yy table before new load
    declare @toLoadCount int      -- Used for # of rows to load in staging xxTable
    declare @loadedCount int      -- Used for xxTable rows loaded into target
    declare @ignoredCount int     -- Used for ignored xxTable rows added to Holding yyTable
    declare @afterLoadCount int   -- Used for target table count 
    declare @toReprocessCount int -- Used for reprocessing prior yy rows that now have a matching person
	declare @DupCount int


	-- check for rows to process
    select @toLoadCount = count(*) from xxTransactions 

	if  @toLoadCount > 0 
		Begin

		-- check if the same RunDate already exists in Transactions

			select @DupCount = count(distinct RunDate) 
			from TransactionsHistory t
			inner join xxTransactions x
				on x.[FY DESIGNATION] = t.FYDESIGNATION
				and x.[Run Date] = t.RunDate
				and x.[FY DESIGNATION] = @FY 


			if @DupCount > 0
			begin
				print 'Step 0 Checking if content is already in TransactionsHistory (FY+ Run Date) '+CHAR(13) + CHAR(10)
				print 'Please review xxTransactions contents against TransactionsHistory.' 
				print ' '
				return
			end

			print 'Step 1 Before loading TransactionsHistory from xxTransactions staging table'

			select @priorTableCount = count(*) from TransactionsHistory 


			print '     # of rows in TransactionsHistory           ' + cast(@priorTableCount as char) 
			print '     # of rows to load from xxTransactions      ' + cast(@toLoadCount as char) 
			print '     TransactionsHistory + xx Tables            ' + cast(@priorTableCount+@toLoadCount as char) 

			print 'Step 2 Loading TransactionsHistory records from xxTransactions staging table'


			insert into HRDW.dbo.TransactionsHistory
				(
				   [PersonID]
				  ,[RunDate]
				  ,[EffectiveDate]
				  ,[FYDESIGNATION]
				  ,[FAMILY_NOACS]
				  ,[NOAC_AND_DESCRIPTION]
				  ,[FirstActionLACode1]
				  ,[FirstActionLADesc1]
				  ,[FirstActionLACode2]  -- 2015/11/02 Rob Cornelsen new field added to support new spreadsheet format
				  ,[FirstActionLADesc2]  -- 2015/11/02 Rob Cornelsen new field added to support new spreadsheet format
				  ,[SecondNOACode]
				  ,[SecondNOADesc]
				  ,[TenureDesc]
				  ,[AppointmentTypeDesc]
				  ,[TypeOfEmploymentDesc]
				  ,[VeteransPreferenceDesc]
				  ,[VeteransStatusDesc]
				  ,[WorkScheduleDesc]
				  ,[ReasonForSeparationDesc]
				  ,[SupvMgrProbCompletion]
				  ,[SupvMgrProbBeginDate]
				  ,[DateConvCareerBegins]
				  ,[DateConvCareerDue]
				  ,[AwardTypeDesc]
				  ,[ToAppropriationCode1]
				  ,[Pathways]
				  ,[SCEP_STEP_PMF]
				  ,[Flex2]
				  ,[PathwaysProgramStartDate]
				  ,[PathwaysProgramEndDate]
				  ,[PathwaysProgramExtnEndDate]
				  ,[FromOfficeSymbol]
				  ,[FromLongName]
				  ,[ToOfficeSymbol]
				  ,[ToLongName]
				  ,[FromPositionAgencyCodeSubelementDescription]
				  ,[ToPositionAgencyCodeSubelementDescription]
				  ,[WhatKindofMovement]
				  ,[FromPositionControlNumberIndicatorDescription]
				  ,[FromPositionControlNumberIndicator]
				  ,[FromPositionControlNumber]
				  ,[FromPDNumber]
				  ,[FromPositionSequenceNumber]
				  ,[FromPPSeriesGrade]
				  ,[FromPositionTargetGradeorLevel]
				  ,[ToPositionControlNumberIndicatorDescription]
				  ,[ToPositionControlNumberIndicator]
				  ,[ToPositionControlNumber]
				  ,[ToPDNumber]
				  ,[ToPositionSequenceNumber]
				  ,[ToPPSeriesGrade]
				  ,[ToPositionTargetGradeorLevel]
				  ,[FromPayBasis]
				  ,[ToPayBasis]
				  ,[FPL]
				  ,[ToFLSACategory]
				  ,[FromPositionTitle]
				  ,[ToPositionTitle]
				  ,[DutyStationNameandStateCountry]
				  ,[FromRegion]
				  ,[ToRegion]
				  ,[FromServicingRegion]
				  ,[ToServicingRegion]
				  ,[ToPOI]
				  ,[ToBargainingUnitStatusDesc]
				  ,[FromPosSupervisorySatusDesc]
				  ,[ToSupervisoryStatusDesc]
				  ,[NewSupervisor]
				  ,[EmployeeNumber]
				  ,[NOAFamilyCode]
				  ,[ReasonForSeparation]
				  ,[RetirementPlan]
				  ,[RetirementPlanDesc]
				  ,[MandatoryRetirementDate]
				  ,[Tenure]
				  ,[TypeOfEmployment]
				  ,[AppointmentType]
				  ,[AgencyCodeTransferFrom]
				  ,[AgencyCodeTransferFromDesc]
				  ,[AgencyCodeTransferTo]
				  ,[AgencyCodeTransferToDesc]
				  ,[FromPositionAgencyCodeSubelement]
				  ,[ToPositionAgencyCodeSubelement]
				  ,[ToDutyStationCode]
				  ,[FromStepOrRate]
				  ,[ToStepOrRate]
				  ,[HireDate]
				  ,[IncentivePaymentOptionCode]
				  ,[IncentivePaymentOptionDesc]
				  ,[IncentivePaymentTypeCategroy]
				  ,[RetentionIncentiveReviewDate]
				  ,[TotalIncentiveAmountPercent]
				  ,[AwardAppropriationCode]
				  ,[AwardApprovingOfficialName]
				  ,[AwardJustification]
				  ,[AwardType]
				  ,[AwardTypeDesc1]
				  ,[AwardUOM]
				  ,[FromBasicPay] -- 2016/01/27 Rob Cornelsen as per 2297
				  ,[ToBasicPay] -- 2016/01/20 Rob Cornelsen as per 2297
				  ,[FromAdjustedBasicPay] -- 2016/01/20 Rob Cornelsen as per 2297
				  ,[ToAdjustedBasicPay] -- 2016/01/20 Rob Cornelsen as per 2297
				  ,[FromTotalPay] -- 2016/01/20 Rob Cornelsen as per 2297
				  ,[ToTotalPay]  -- 2016/01/20 Rob Cornelsen as per 2297
				  ,[AwardAmount]				-- JJM 2016-05-03 Added
				  ,[ProcessedDate]				-- JJM 2016-05-03 Added
				  ,[AnnuitantIndicator] 		-- JJM 2016-05-16 Added
				  ,[AnnuitantIndicatorDesc] 	-- JJM 2016-05-16 Added
				  ,[PayRateDeterminant] 		-- JJM 2016-05-16 Added
				  ,[PayRateDeterminantDesc] 	-- JJM 2016-05-16 Added
				  ,[NOAC_AND_DESCRIPTION_2] 	-- JJM 2016-05-16 Added

				)
				select 
				   p.PersonID
				  ,cast([Run Date] as smalldatetime)
				  ,[Effective Date]
				  ,[FY DESIGNATION]
				  ,t.[FAMILY_NOACS]
				  ,t.[NOAC_AND_DESCRIPTION]
				  ,[First Action LA Code1]
				  ,[First Action LA Desc1]
				  ,[First Action LA Code2]
				  ,[First Action LA Desc2]
				  ,[Second NOA Code]
				  ,[Second NOA Desc]
				  ,[Tenure Desc]
				  ,[Appointment Type Desc]
				  ,[Type Of Employment Desc]
				  ,[Veterans Preference Desc]
				  ,[Veterans Status Desc]
				  ,[Work Schedule Desc]
				  ,[Reason For Separation Desc]
				  ,[Supv Mgr Prob Completion]
				  ,[Supv Mgr Prob Begin Date]
				  ,[Date Conv Career Begins]
				  ,[Date Conv Career Due]
				  ,[Award Type Desc]
				  ,[To Appropriation Code 1]
				  ,t.[Pathways]
				  ,t.[SCEP_STEP_PMF]
				  ,t.[Flex2]
				  ,[Pathways Program Start Date]
				  ,[Pathways Program End Date]
				  ,[Pathways Program Extn End Date]
				  ,[From Office Symbol]
				  ,[From Long Name]
				  ,[To Office Symbol]
				  ,[To Long Name]
				  ,[From Position Agency Code/Subelement Description]
				  ,[To Position Agency Code/Subelement Description]
				  ,[What Kind of Movement]
				  ,[From Position Control Number Indicator Description]
				  ,[From Position Control Number Indicator]
				  ,[From Position Control Number]
				  ,[From PD Number]
				  ,[From Position Sequence Number]
				  ,[From PP-Series-Grade]
				  ,[From Position Target Grade or Level]
				  ,[To Position Control Number Indicator Description]
				  ,[To Position Control Number Indicator]
				  ,[To Position Control Number]
				  ,[To PD Number]
				  ,[To Position Sequence Number]
				  ,[To PP-Series-Grade]
				  ,[To Position Target Grade or Level]
				  ,[From Pay Basis]
				  ,[To Pay Basis]
				  ,t.[FPL]
				  ,[To FLSA Category]
				  ,[From Position Title]
				  ,[To Position Title]
				  ,[Duty Station Name and State_Country]
				  ,[From Region]
				  ,[To Region]
				  ,[From Servicing Region]
				  ,[To Servicing Region]
				  ,[To POI]
				  ,[To Bargaining Unit Status Desc]
				  ,[From Pos Supervisory Sts Desc]
				  ,[To Supervisory Status Desc]
				  ,[New Supervisor?]
				  ,[Employee Number]
				  ,[NOA Family Code]
				  ,[Reason For Separation]
				  ,[Retirement Plan]
				  ,[Retirement Plan Desc]
				  ,[Mandatory Retirement Date]
				  ,t.[Tenure]
				  ,[Type Of Employment]
				  ,[Appointment Type ]  
				  ,[Agency Code Transfer From]
				  ,[Agency Code Transfer From Desc]
				  ,[Agency Code Transfer To]
				  ,[Agency Code Transfer To Desc]
				  ,[From Position Agency Code/Subelement]
				  ,[To Position Agency Code/Subelement]
				  ,[To Duty Station Code]
				  ,[From Step Or Rate]
				  ,[To Step Or Rate]
				  ,[Hire Date]
				  ,[Incentive Payment Option Code]
				  ,[Incentive Payment Option Desc]
				  ,[Incentive Payment Type (Categroy)]
				  ,[Retention Incentive Review Date]
				  ,[Total Incentive Amount/Percent]
				  ,[Award Appropriation Code]
				  ,[Award Approving Official Name]
				  ,[Award Justification]
				  ,[Award Type]
				  ,[Award Type Desc1]
				  ,[Award UOM]
				  ,[From Basic Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				  ,[To Basic Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				  ,[From Adjusted Basic Pay] -- 2016/01/20 Rob Cornelsen as per 2297 
				  ,[To Adjusted Basic Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				  ,[From Total Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				  ,[To Total Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				  ,[Award Amount]				-- JJM 2016-05-03 Added
				  ,[Processed Date]				-- JJM 2016-05-03 Added
				  ,[Annuitant Indicator] 		-- JJM 2016-05-16 Added
				  ,[Annuitant Indicator Desc] 	-- JJM 2016-05-16 Added
				  ,[Pay Rate Determinant] 		-- JJM 2016-05-16 Added
				  ,[Pay Rate Determinant Desc] 	-- JJM 2016-05-16 Added
				  ,[NOAC_AND_DESCRIPTION_2] 	-- JJM 2016-05-16 Added

				from xxTransactions t 
				     INNER JOIN Person p 
								ON p.SSN=t.[SSN]
								   AND
								   t.[FY DESIGNATION] = @FY


			select @loadedCount = @@rowcount

			select @afterLoadCount = count(*) from TransactionsHistory      
       
			print '       # of rows loaded from xxTransactions           ' + cast(@loadedCount as char) 
			print '       TransactionsHistory + xxTransactions loaded    ' + cast(@afterLoadCount as char) 
			print '       # of xxTransactions Rows ignored               ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 
 

			-- Employee' records will be written into yy tables. (if SSNs are not in Person)

			print 'Step 3  Inserting into yy table for missing people'

   
			INSERT INTO yyTransactions 
				([PersonID]
				,[SSN]
				,[Run Date]
				,[Database]
				,[Effective Date]
				,[FY DESIGNATION]
				,[FAMILY_NOACS]
				,[NOAC_AND_DESCRIPTION]
				,[First Action LA Code1]
				,[First Action LA Desc1]
				,[First Action LA Code2]
				,[First Action LA Desc2]
				,[Second NOA Code]
				,[Second NOA Desc]
				,[Full Name]
				,[Tenure Desc]
				,[Appointment Type Desc]
				,[Type Of Employment Desc]
				,[Veterans Preference Desc]
				,[Veterans Status Desc]
				,[Work Schedule Desc]
				,[Reason For Separation Desc]
				,[Supv Mgr Prob Completion]
				,[Supv Mgr Prob Begin Date]
				,[Date Conv Career Begins]
				,[Date Conv Career Due]
				,[Award Type Desc]
				,[To Appropriation Code 1]
				,[Pathways]
				,[SCEP_STEP_PMF]
				,[Flex2]
				,[Pathways Program Start Date]
				,[Pathways Program End Date]
				,[Pathways Program Extn End Date]
				,[From Office Symbol]
				,[From Long Name]
				,[F36]
				,[To Office Symbol]
				,[To Long Name]
				,[F39]
				,[From Position Agency Code/Subelement Description]
				,[To Position Agency Code/Subelement Description]
				,[What Kind of Movement]
				,[From Position Control Number Indicator Description]
				,[From Position Control Number Indicator]
				,[From Position Control Number]
				,[From PD Number]
				,[From Position Sequence Number]
				,[From PP-Series-Grade]
				,[From Position Target Grade or Level]
				,[To Position Control Number Indicator Description]
				,[To Position Control Number Indicator]
				,[To Position Control Number]
				,[To PD Number]
				,[To Position Sequence Number]
				,[To PP-Series-Grade]
				,[To Position Target Grade or Level]
				,[From Pay Basis]
				,[To Pay Basis]
				,[FPL]
				,[To FLSA Category]
				,[From Position Title]
				,[To Position Title]
				,[Duty Station Name and State_Country]
				,[From Region]
				,[To Region]
				,[From Servicing Region]
				,[To Servicing Region]
				,[To POI]
				,[To Bargaining Unit Status Desc]
				,[From Pos Supervisory Sts Desc]
				,[To Supervisory Status Desc]
				,[New Supervisor?]
				,[Employee Number]
				,[NOA Family Code]
				,[Reason For Separation]
				,[Retirement Plan]
				,[Retirement Plan Desc]
				,[Mandatory Retirement Date]
				,[Tenure]
				,[Credibility Mil Service]
				,[Veterans Preference]
				,[Veterans Status]
				,[Type Of Employment]
				,[RNO Desc]
				,[RNO Code]
				,[Handicap Code]
				,[Handicap Code Desc]
				,[Gender]
				,[DOB]
				,[Appointment Type ]
				,[Agency Code Transfer From]
				,[Agency Code Transfer From Desc]
				,[Agency Code Transfer To]
				,[Agency Code Transfer To Desc]
				,[From Position Agency Code/Subelement]
				,[To Position Agency Code/Subelement]
				,[To Duty Station Code]
				,[From Step Or Rate]
				,[To Step Or Rate]
				,[Hire Date]
				,[Incentive Payment Option Code]
				,[Incentive Payment Option Desc]
				,[Incentive Payment Type (Categroy)]
				,[Retention Incentive Review Date]
				,[Total Incentive Amount/Percent]
				,[Award Appropriation Code]
				,[Award Approving Official Name]
				,[Award Justification]
				,[F106]
				,[F107]
				,[F108]
				,[F109]
				,[F110]
				,[F111]
				,[F112]
				,[F113]
				,[F114]
				,[F115]
				,[F116]
				,[Award Type]
				,[Award Type Desc1]
				,[Award UOM]
				,[From Basic Pay] -- 2016/01/27 Rob Cornelsen as per 2297
				,[To Basic Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				,[From Adjusted Basic Pay] -- 2016/01/20 Rob Cornelsen as per 2297 
				,[To Adjusted Basic Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				,[From Total Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				,[To Total Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				,[FailureReason]
				,[LoadFileName]
				,[FailureDateTime]
				,[ProcessedDate]
				,[ProcessingNotes]
				,[Award Amount]					-- JJM 2016-05-03 Added
				,[Processed Date]				-- JJM 2016-05-03 Added
				,[Annuitant Indicator] 			-- JJM 2016-05-16 Added
				,[Annuitant Indicator Desc] 	-- JJM 2016-05-16 Added
				,[Pay Rate Determinant] 		-- JJM 2016-05-16 Added
				,[Pay Rate Determinant Desc] 	-- JJM 2016-05-16 Added
				,[NOAC_AND_DESCRIPTION_2] 		-- JJM 2016-05-16 Added

				)
				select null as PersonID
				,xx.[SSN]
				,[Run Date]
				,[Database]
				,[Effective Date]
				,[FY DESIGNATION]
				,[FAMILY_NOACS]
				,[NOAC_AND_DESCRIPTION]
				,[First Action LA Code1]
				,[First Action LA Desc1]
				,[First Action LA Code2]
				,[First Action LA Desc2]
				,[Second NOA Code]
				,[Second NOA Desc]
				,[Full Name]
				,[Tenure Desc]
				,[Appointment Type Desc]
				,[Type Of Employment Desc]
				,[Veterans Preference Desc]
				,[Veterans Status Desc]
				,[Work Schedule Desc]
				,[Reason For Separation Desc]
				,[Supv Mgr Prob Completion]
				,[Supv Mgr Prob Begin Date]
				,[Date Conv Career Begins]
				,[Date Conv Career Due]
				,[Award Type Desc]
				,[To Appropriation Code 1]
				,[Pathways]
				,[SCEP_STEP_PMF]
				,[Flex2]
				,[Pathways Program Start Date]
				,[Pathways Program End Date]
				,[Pathways Program Extn End Date]
				,[From Office Symbol]
				,[From Long Name]
				,[F36]
				,[To Office Symbol]
				,[To Long Name]
				,[F39]
				,[From Position Agency Code/Subelement Description]
				,[To Position Agency Code/Subelement Description]
				,[What Kind of Movement]
				,[From Position Control Number Indicator Description]
				,[From Position Control Number Indicator]
				,[From Position Control Number]
				,[From PD Number]
				,[From Position Sequence Number]
				,[From PP-Series-Grade]
				,[From Position Target Grade or Level]
				,[To Position Control Number Indicator Description]
				,[To Position Control Number Indicator]
				,[To Position Control Number]
				,[To PD Number]
				,[To Position Sequence Number]
				,[To PP-Series-Grade]
				,[To Position Target Grade or Level]
				,[From Pay Basis]
				,[To Pay Basis]
				,[FPL]
				,[To FLSA Category]
				,[From Position Title]
				,[To Position Title]
				,[Duty Station Name and State_Country]
				,[From Region]
				,[To Region]
				,[From Servicing Region]
				,[To Servicing Region]
				,[To POI]
				,[To Bargaining Unit Status Desc]
				,[From Pos Supervisory Sts Desc]
				,[To Supervisory Status Desc]
				,[New Supervisor?]
				,[Employee Number]
				,[NOA Family Code]
				,[Reason For Separation]
				,[Retirement Plan]
				,[Retirement Plan Desc]
				,[Mandatory Retirement Date]
				,[Tenure]
				,[Credibility Mil Service]
				,[Veterans Preference]
				,[Veterans Status]
				,[Type Of Employment]
				,[RNO Desc]
				,[RNO Code]
				,[Handicap Code]
				,[Handicap Code Desc]
				,[Gender]
				,[DOB]
				,[Appointment Type ]
				,[Agency Code Transfer From]
				,[Agency Code Transfer From Desc]
				,[Agency Code Transfer To]
				,[Agency Code Transfer To Desc]
				,[From Position Agency Code/Subelement]
				,[To Position Agency Code/Subelement]
				,[To Duty Station Code]
				,[From Step Or Rate]
				,[To Step Or Rate]
				,[Hire Date]
				,[Incentive Payment Option Code]
				,[Incentive Payment Option Desc]
				,[Incentive Payment Type (Categroy)]
				,[Retention Incentive Review Date]
				,[Total Incentive Amount/Percent]
				,[Award Appropriation Code]
				,[Award Approving Official Name]
				,[Award Justification]
				,[F106]
				,[F107]
				,[F108]
				,[F109]
				,[F110]
				,[F111]
				,[F112]
				,[F113]
				,[F114]
				,[F115]
				,[F116]
				,[Award Type]
				,[Award Type Desc1]
				,[Award UOM]
				,[From Basic Pay] -- 2016/01/27 Rob Cornelsen as per 2297
				,[To Basic Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				,[From Adjusted Basic Pay] -- 2016/01/20 Rob Cornelsen as per 2297 
				,[To Adjusted Basic Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				,[From Total Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				,[To Total Pay] -- 2016/01/20 Rob Cornelsen as per 2297
				, 'No Matching Person' AS FailureReason
				, NULL AS LoadFileName   -- Future add spreadsheet name
				, cast(SYSDATETIME() as smallDATEtime) AS FailureDateTime 
				,[ProcessedDate]
				, null AS ProcessingNotes
				,[Award Amount]					-- JJM 2016-05-03 Added
				,[Processed Date]				-- JJM 2016-05-03 Added
				,[Annuitant Indicator] 			-- JJM 2016-05-16 Added
				,[Annuitant Indicator Desc] 	-- JJM 2016-05-16 Added
				,[Pay Rate Determinant] 		-- JJM 2016-05-16 Added
				,[Pay Rate Determinant Desc] 	-- JJM 2016-05-16 Added
				,[NOAC_AND_DESCRIPTION_2] 		-- JJM 2016-05-16 Added

			From HRDW.dbo.xxTransactions xx
--				 LEFT OUTER JOIN Person p
--								 ON p.SSN = xx.[SSN]
--								 where p.SSN is null
--									   AND
			WHERE xx.[FY DESIGNATION] = @FY  

 
		    select @IgnoredCount = @@rowcount

			print 'Rows inserted into yy Holding table (for No Matching Person): ' + cast(@IgnoredCount as char)  

			print 'Unaccount ignored rows                                        ' + CAST ((@toLoadCount + @priorTableCount - @afterLoadCount)-@IgnoredCount as char) 

			print ' '
			print 'Finish Date Time: '
			print SYSDATETIME()

		end
	else
		begin
			print 'No rows in xxTransactions '+ ltrim(rtrim(cast(@toLoadCount as char))) 
			print ' '
			print 'Load Fail Date Time: '
			print SYSDATETIME()

		end
end






GO
