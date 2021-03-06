USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_TSSTDSHistory]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-05-23  
-- Description: Created Stored Procedure
-- =============================================================================
CREATE procedure [dbo].[rv_sp_load_TSSTDSHistory]  
with execute as owner
as

Begin

	print '=========================================================' 
	print 'Inside TssTDSHistory Training, executing... '  
	print '=========================================================' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)

	print 'Start Date Time: '
	print SYSDATETIME()
	print ' '
    declare @priorTableCount int
    declare @toLoadCount int      -- Used for # of rows to load in staging xxTable
    declare @loadedCount int      -- Used for xxTable rows loaded into target
    declare @ignoredCount int     -- Used for ignored xxTable rows added to Holding yyTable
    declare @afterLoadCount int   -- Used for target table count 
        
    select @toLoadCount = count(*) from xxTssTDS

	if  @toLoadCount > 0 
		Begin


		-- check if rows exist in TssTDSHistory table. Not feasible here, good for batch loading with Rundates.
	
		print 'Step 1 Before loading TssTDSHistory from xxTssTDS staging table'

		select @priorTableCount = count(*) from TssTDSHistory 


		print '       # of rows in TssTDSHistory              ' + cast(@priorTableCount as char) 
		print '       # of rows to load from xxTssTDS ' + cast(@toLoadCount as char) 
		print '       TssTDSHistory + xx Tables               ' + cast(@priorTableCount+@toLoadCount as char) 

		print 'Step 2 Loading TssTDSHistory records from xxTssTDS staging table'
		print ''

		insert into TssTDSHistory(
				PersonID 
			,AccreditationIndicatorCode	
			,AccreditationIndicatorDesc
			,AgencyCodeSubelement	
			,ContServiceAgreementSigned	
			,CourseCompletionDate	
			,CourseStartDate	
			,CreditDesignationCode	
			,CreditDesignationDesc	
			,CreditTypeDesc	
			,CreditTypeCode	
			,DutyHours	
			,FiscalYear	
			,ImpactOnPerformanceCode	
			,ImpactOnPerformanceDesc	
			,MaterialCost	
			,NongovernmentContributionCost	
			,NonDutyHours	
			,NumberofAssociates	
			,OccupationalSeriesCode	
			,OccupationalSeriesDesc 
			,OrganizationName	
			,PayPlan	
			,PerdiemCost	
			,PriorKnowledgeLevelCode	
			,PriorKnowledgeLevelDesc	
			,PriorSupvApprovalReceivedCode	
			,PriorSupvApprovalReceivedDesc	
			,RecommendTrainingToOthersCode	
			,RecommendTrainingToOthersDesc	
			,RepaymentAgreementRequiredCode	
			,RepaymentAgreementRequiredDesc	
			,SourceType	
			,TrainingCredit	
			,TrainingDeliveryTypeCode	
			,TrainingDeliveryTypeDesc	
			,TrainingLocation	
			,TrainingPartOfIDPCode	
			,TrainingPartOfIDPDesc	
			,TrainingPurposeCode	
			,TrainingPurposeDesc	
			,TrainingSourceCode	
			,TrainingSourceDesc	
			,TrainingSubTypeCode	
			,TrainingSubTypeDesc	
			,TrainingTitle	
			,TrainingTravelIndicator	
			,TrainingTypeCode	
			,TrainingTypeDesc	
			,TravelCosts	
			,TutionAndFees	
			,TypeOfPaymentCode	
			,TypeOfPaymentDesc	
			,VendorName
		)
		select 
			p.PersonID
			,[Accreditation Indicator Code]
			,[Accreditation Indicator Desc]
			,[Agency Code Subelement]
			,[Cont Service Agreement Signed]
			,[Course Completion Date]
			,[Course Start Date]
			,[Credit Designation Code]
			,[Credit Designation Desc]
			,[Credit Type Desc]
			,[Credit Type Code]
			,[Duty Hours]
			,dbo.Riv_fn_ComputeFiscalYear([Course Completion Date]) -- ,[Fiscal Year] in the TDS source is not reliable, so use Year of the Course Completion Date
			,[Impact On Performance Code]
			,[Impact On Performance Desc]
			,[Material Cost]
			,[Nongovernment Contribution Cost]
			,[Non Duty Hours]
			,[Number of Associates]
			,[Occupational Series Code]
			,[Occupational Series Desc]
			,[Organization Name]
			,[Pay Plan]
			,[Perdiem Cost]
			,[Prior Knowledge Level Code]
			,[Prior Knowledge Level Desc]
			,[Prior Supv Approval Received Code]
			,[Prior Supv Approval Received Desc]
			,[Recommend Training To Others Code]
			,[Recommend Training To Others Desc]
			,[Repayment Agreement Required Code]
			,[Repayment Agreement Required Desc]
			,[Source Type]
			,[Training Credit]
			,[Training Delivery Type Code]
			,[Training Delivery Type Desc]
			,[Training Location]
			,[Training Part Of IDP Code]
			,[Training Part Of IDP Desc]
			,[Training Purpose Code]
			,[Training Purpose Desc]
			,[Training Source Code]
			,[Training Source Desc]
			,[Training Sub Type Code]
			,[Training Sub Type Desc]
			,[Training Title]
			,[Training Travel Indicator]
			,[Training Type Code]
			,[Training Type Desc]
			,[Travel Costs]
			,[Tution And Fees]
			,[Type Of Payment Code]
			,[Type Of Payment Desc]
			,[Vendor Name]
	  
		from xxTssTDS b 
		join person p 
		on p.SSN = b.[Social Security Number]

		-- if records are already in TssTDSHistory, then skip them.
		where not exists 
			(select * from TssTDSHistory  where 
				PersonID  = p.PersonID 
				and b.[Course Completion Date] = CourseCompletionDate
				and b.[Course Start Date] = CourseStartDate
				and b.[Training Title]= TrainingTitle)


			select @loadedCount = @@rowcount

			select @afterLoadCount = count(*) from TssTDSHistory 


			print '       # of rows loaded from xxTssTDS        ' + cast(@loadedCount as char) 
			print '       TssTDSHistory + xxTssTDS loaded              ' + cast(@afterLoadCount as char) 
			print '       # of xxTssTDS Rows ignored            ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 


			print ' '
			print 'Finish Date Time: '
			print SYSDATETIME()

		end

	else
		begin
			print 'No rows in xxTssTDS '+ ltrim(rtrim(cast(@toLoadCount as char))) 
			print ' '
			print 'Load Fail Date Time: '
			print SYSDATETIME()

		end
end



GO
