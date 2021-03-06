USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_TSSTDS]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-04-29  
-- Description: Delete existing Training before inserting latest dataset
-- =============================================================================
CREATE procedure [dbo].[rv_sp_load_TSSTDS]  
with execute as owner  --,   ENCRYPTION  -- Should we Change from Owner to Self and add ENCRYPTION option (as security measure for final deployment)-- Need to check as to why anyone may execute the load scripts
as

Begin

print '=========================================================' 
print 'Inside TssTDS Training, executing... '  
print '=========================================================' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)

print 'Start Date Time: '
print SYSDATETIME()
print ' '
    declare @priorTableCount int
    declare @toLoadCount int      -- Used for # of rows to load in staging xxTable
    declare @loadedCount int      -- Used for xxTable rows loaded into target
    declare @ignoredCount int     -- Used for ignored xxTable rows added to Holding yyTable
    declare @afterLoadCount int   -- Used for target table count 
    --declare @DupCount int         -- Used for check of Duplicate Rows
        
    select @toLoadCount = count(*) from xxTssTDS

	if  @toLoadCount > 0 
		Begin


	-- check if rows exist in TssTDS table. Not feasible here, good for batch loading with Rundates.
	
print 'Step 1 Before loading TssTDS from xxTssTDS staging table'

    select @priorTableCount = count(*) from TssTDS 


print '       # of rows in TssTDS              ' + cast(@priorTableCount as char) 
print '       # of rows to load from xxTssTDS ' + cast(@toLoadCount as char) 
print '       TssTDS + xx Tables               ' + cast(@priorTableCount+@toLoadCount as char) 

print 'Step 2 Loading TssTDS records from xxTssTDS staging table'
print ''
print 'Deleting existing rows from TssTDS prior to loading latest dataset'
DELETE FROM TssTDS

insert into TSSTDS(
	 PersonID 
	,AccreditationIndicatorCode	
	,AccreditationIndicatorDesc
	,AgencyCodeSubelement	
	--,ChrisTransactionId	
	,ContServiceAgreementSigned	
	,CourseCompletionDate	
	,CourseStartDate	
	,CreditDesignationCode	
	,CreditDesignationDesc	
	,CreditTypeDesc	
	,CreditTypeCode	
	,DutyHours	
	--,Employee First Name	
	--,Employee Last Name	
	--,Employee Middle Name	
	,FiscalYear	
	--,Gender	
	--,GradeOrLevel	
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
	--,PositionControlNumber	
	--,PositionSequenceNumber	
	--,PositionTitle	
	,PriorKnowledgeLevelCode	
	,PriorKnowledgeLevelDesc	
	,PriorSupvApprovalReceivedCode	
	,PriorSupvApprovalReceivedDesc	
	,RecommendTrainingToOthersCode	
	,RecommendTrainingToOthersDesc	
	--,Region 
	,RepaymentAgreementRequiredCode	
	,RepaymentAgreementRequiredDesc	
	--,Social Security Number	
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
	--,[DataSource]
 --   ,[SystemSource]
 --   ,[AsOfDate]
)
select 
	p.PersonID
	,[Accreditation Indicator Code]
    ,[Accreditation Indicator Desc]
    ,[Agency Code Subelement]
  --  ,cast([Chris Et Transaction Id] as int)
    ,[Cont Service Agreement Signed]
    ,[Course Completion Date]
    ,[Course Start Date]
    ,[Credit Designation Code]
    ,[Credit Designation Desc]
    ,[Credit Type Desc]
    ,[Credit Type Code]
    ,[Duty Hours]
    --,[Employee First Name]
    --,[Employee Last Name]
    --,[Employee Middle Name]
    ,dbo.Riv_fn_ComputeFiscalYear([Course Completion Date]) -- ,[Fiscal Year] in the TDS source is not reliable, so use Year of the Course Completion Date
    --,[Gender]
    --,[Grade Or Level]
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
    --,[Position Control Number]
    --,[Position Sequence Number]
    --,[Position Title]
    ,[Prior Knowledge Level Code]
    ,[Prior Knowledge Level Desc]
    ,[Prior Supv Approval Received Code]
    ,[Prior Supv Approval Received Desc]
    ,[Recommend Training To Others Code]
    ,[Recommend Training To Others Desc]
    --,[Region]
    ,[Repayment Agreement Required Code]
    ,[Repayment Agreement Required Desc]
    --,[Social Security Number]
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
	--,'' as [DataSource]
	--,'' as [SystemSource]
	--,sysdatetime() as [AsOfDate] 
	  
	  from xxTssTDS b 
	  join person p 
		on p.SSN = b.[Social Security Number]

	-- if records are already in TssTDS, then skip them.
	 where not exists 
	(select * from TssTDS  where 
		PersonID  = p.PersonID 
		and b.[Course Completion Date] = CourseCompletionDate
        and b.[Course Start Date] = CourseStartDate
		and b.[Training Title]= TrainingTitle)


        select @loadedCount = @@rowcount

        select @afterLoadCount = count(*) from TssTDS 


/*
print '       # of rows in TssTDS                    ' + cast(@priorTableCount as char) 
print '       # of rows to load from xxTssTDS       ' + cast(@toLoadCount as char) 
print '       TssTDS + xxTssTDS                     ' + cast(@priorTableCount+@toLoadCount as char) 
*/
print '       # of rows loaded from xxTssTDS        ' + cast(@loadedCount as char) 
print '       TssTDS + xxTssTDS loaded              ' + cast(@afterLoadCount as char) 
print '       # of xxTssTDS Rows ignored            ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 


/*
-- only existing persons' records will be loaded, so new person's records are ignored
--*/
--print 'Step 2b  Inserting into yyTssTDS Holding Table for missing people'

--*** Do INSERT INTO yy Holding

        --select @IgnoredCount = @@rowcount
        
--print '       Anticipated # of Rows ignored to load into yyTssTDS Holding Table  ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 
--print '       Rows inserted into yyTssTDS Holding table (for No Matching Person) ' + cast(@IgnoredCount as char)  
--print ' '
--print 'Load Summary ' 
--print ' '
--print 'Before loading TssTDS from xxTssTDS staging table'
--print '       Before # of TssTDS rows             ' + cast(@priorTableCount as char) 
--print '       # of rows to load from xxTssTDS    ' + cast(@toLoadCount as char) 
--print '       TssTDS + xx Table                   ' + cast(@priorTableCount+@toLoadCount as char) 
--print ' '
--print 'After loading TssTDS from xxTssTDS staging table'
--print '       # of rows inserted into TssTDS from xxTssTDS       ' + ltrim(rtrim(cast(@loadedCount as char)))  
--print '       # of rows from xxTssTDS ignored                    ' + ltrim(rtrim(cast(@IgnoredCount as char)))  
--print '       Total # of rows processed                           ' + ltrim(rtrim(cast(@loadedCount+@IgnoredCount as char)))  
--print ' '
--print '       After # of TssTDS rows                            ' + ltrim(rtrim(cast(@afterLoadCount as char)))  
--print '       Ignored # of rows added to yy tables              ' + cast((@priorTableCount+@toLoadCount)-@afterLoadCount as char) 
--print '       ( Before # + ToLoad # ) - (After # + Ignored #) = ' + cast((@priorTableCount+@toLoadCount)-(@afterLoadCount+@IgnoredCount) as char) 
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
