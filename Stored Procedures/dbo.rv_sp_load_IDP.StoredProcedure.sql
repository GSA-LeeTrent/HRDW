USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_IDP]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[rv_sp_load_IDP]
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-04-06  
-- Description: Updated join on Position to include the Max Record Date
--              - otherwise mutliple IDProws were inserted per person.             
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-04-29  
-- Description: Delete existing IDP rows before adding latest dataset             
-- =============================================================================
with execute as owner		
as

print '=========================================================' 
print 'Inside IDP, executing... '  
print '=========================================================' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)


    declare @priorTableCount int
    declare @toLoadCount int
    declare @afterLoadCount int
    
select @toLoadCount = count(*) from xxIDP
print 'Before loading, number of rows in xxIDP to load is ' + cast(@toLoadCount as char) 

	if  @toLoadCount >0 
		Begin

print 'Step 1  Inserting new IDP records for existing people'

select @priorTableCount = count(*) from IDP        
print 'before inserting IDPs, number of rows in IDP is ' + cast(@priorTableCount as char) 
print ''
print 'Deleting existing rows from IDP prior to loading latest dataset'
DELETE FROM IDP

print 'Inserting latest IDP dataset'

			insert into IDP(
			 PersonID
			,FiscalYearValidation
			,IDPStatus
			,IDPRecordNumber
			,SharedIDPsRecordType             
			,SharedIDPsLastModifiedDate       
			,ShortTermCareerGoalsUnder4Years  
			,LongTermCareerGoalsOver3Years    
        	,DataSource
	        ,SystemSource
            ,AsOfDate
			)
			select
			p.PersonID
			,x.[IDP Fiscal Year Validation]
			,x.[IDP Status]
			,x.[Shared IDPs: IDP Record Number]
			,x.[Shared IDPs: Record Type]
			,x.[Shared IDPs: Last Modified Date]
			,x.[Short Term Career Goals (1-3 Years)]
			,x.[Long-Term Career Goals (3+ Years)]
        	,''
	        ,''
			,SYSDATETIME()  

			from xxIDP x
			join Person p 
				on ltrim(rtrim(x.[Employee Email]))= p.EmailAddress 
			
			--since training system (salesforce) doesn't provide SSN nor Emp Number, 
			--we will use "email" and PositionEncumberedType to load IDP data for only current employees.	
												
			join position pos
				on pos.PersonID = p.PersonID
--              JJM 2016/04/06 - Update join on Max Record Date
				and pos.RecordDate =
		        (select Max(pos1.RecordDate) from dbo.Position pos1 where pos1.PersonID = pos.PersonID)

			join positionInfo posI
				on posI.PositionInfoId = pos.ChrisPositionID
				and (posi.[PositionEncumberedType] = 'Employee Permanent' or posi.[PositionEncumberedType] = 'Employee Temporary')

			-- only add new IDP records for existing employees
			where not exists
			(
				select 1
				from IDP i
				where i.PersonID = p.PersonID	
					and ISNULL(i.FiscalYearValidation, '') = ISNULL(cast(x.[IDP Fiscal Year Validation] as varchar(4)), '')
					and ISNULL(i.IDPStatus, '') = ISNULL(x.[IDP Status], '')
					and ISNULL(i.IDPRecordNumber, '') = ISNULL(x.[Shared IDPs: IDP Record Number], '')
					and ISNULL(i.SharedIDPsRecordType, '') = ISNULL(x.[Shared IDPs: Record Type], '')
					and ISNULL(i.SharedIDPsLastModifiedDate, '') = ISNULL(x.[Shared IDPs: Last Modified Date], '')
					and ISNULL(i.ShortTermCareerGoalsUnder4Years, '') = ISNULL(x.[Short Term Career Goals (1-3 Years)], '')
					and ISNULL(i.LongTermCareerGoalsOver3Years, '') = ISNULL(x.[Long-Term Career Goals (3+ Years)], '')			
			)
		        
print 'Rows inserted (for existing persons): ' + cast(@@rowcount as char)  

--print 'Anticipated total # of rows ' +  cast(@toLoadCount + @priorTableCount as char) 
select @afterLoadCount = count(*) from IDP        
print 'After loading, number of rows in IDP is ' + cast(@afterLoadCount as char) 
print '# of Rows ignored: ' + cast(@toLoadCount - @afterLoadCount as char) 

	
		end

	else
		begin
			print 'No rows in xxIDP to load ' + cast(@toLoadCount as char) 
		end


GO
