USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_PPID]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rv_sp_load_PPID]  
with execute as owner --,   ENCRYPTION  -- Should we Change from Owner to self and add ENCRYPTION option -- Need to check with mike as to why anyone may execute the load scripts
as
Begin

print '=========================================================' 
print 'Inside PPID, executing... '  
print '=========================================================' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)

    declare @priorTableCount int
    declare @toLoadCount int
    declare @afterLoadCount int
        
    select @toLoadCount = count(*) from xxPPID

print 'Step 1 Before loading, number of rows in xxPPID to load is ' + cast(@toLoadCount as char) 

	if  @toLoadCount >0 
		Begin

print 'Step 1.2 Checking if (run date) exists in PPID'
	
	declare @DupCount int
	
	-- check if FY+RunDate combinations exist in PPID table.

	select @DupCount = count(distinct [RunDate]) 
	from [dbo].[PPID] c
	inner join xxPPID x
		on x.[Run Date] = c.RunDate 

	if @DupCount > 0
	begin
		print 'Performance Plan Issue Date (PPID) data has already been loaded. Please Check xx Staging Table contents.' 

		--print 'Rows already loaded for the following FYs and RunDates:' 

		--select [RunDate], count([RunDate]) 
		--from PPID x
		--group by [RunDate]
		--order by [RunDate]
		--print 'Rows in XX Staging Table for the following FYs and RunDates:' 
		
		--select [Run Date], count([Run Date]) 
		--from xxPPID x
		--group by [Run Date]
		--order by [Run Date]

		--print 'Rows on YY Holding table for the following FYs and RunDates:' 
		--select [Run Date], count([Run Date]) 
		--from yyPPID x
		--group by [Run Date]
		--order by [Run Date]

		return
	end


print 'Step 2 Inserting new PPID records for existing people'

        select @priorTableCount = count(*) from PPID        

print 'before inserting PPIDs, number of rows in PPID is ' + cast(@priorTableCount as char) 

			insert into [dbo].[PPID]
           ([RunDate]
           ,[PersonID]
           ,[PerformancePlanIssueDate]
           ,[RatingPeriodStartDate]
           ,[RatingPeriodEndDate]
           ,[HasPP]
           ,[AgencySubElement]
           ,[HSSO]
           ,[DataSource]
           ,[SystemSource]
           ,[AsOfDate]
               )
           	select 
               [Run Date] as [RunDate]										 -- 1 
               ,[PersonID]                                           
               --,[Employee SSN] 
               ,[Performance Plan Issue Date] as [PerformancePlanIssueDate]
               ,[Rating Period Start Date] as [RatingPeriodStartDate]
               ,[Rating Period End Date] as [RatingPeriodEndDate]
               ,[Has PP] as [HasPP]
               ,[Agency Sub Element] as [AgencySubElement]
               ,[HSSO] 
               ,''	as [DataSource]	 -- 11  -- pass as @variable? spreadsheets have unique # on end of name name 
               ,'APPAS'	as [SystemSource]	-- 12  -- Hard code for each load
               ,SYSDATETIME() as [AsOfDate]  -- 13

			from xxPPID x
			join person p 
					on ltrim(rtrim(x.[Employee SSN]))= p.ssn  

/*
-- only existing persons' PPID records will be loaded, so new person's PPID records are ignored
*/

print 'Rows inserted (for existing persons): ' + cast(@@rowcount as char)  

print 'Anticipated total # of rows ' +  cast(@toLoadCount + @priorTableCount as char) 

        select @afterLoadCount = count(*) from PPID        

print 'After loading, number of rows in PPID is ' + cast(@afterLoadCount as char) 

print '# of Rows ignored: ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 

/* 
All the ignored records will be written into yy tables. 
*/
print 'Step 3  Inserting into yy table for missing people'

  INSERT INTO yyPPID
        ([PersonID]               -- 0 Always null -- Included in table for manual matching to an existing person 
        ,[Run Date]               -- 1 
        ,[Employee SSN]
        ,[Performance Plan Issue Date]
        ,[Rating Period Start Date]
        ,[Rating Period End Date]
        ,[Has PP]
        ,[Agency Sub Element]
        ,[HSSO]         -- 11
        ,[FailureReason]          -- 12	--come back later
        ,[LoadFileName]           -- 13
        ,[FailureDateTime]        -- 14
        ,[ProcessedDate]          -- 15
        ,[ProcessingNotes]        -- 16
        )
 --declare @LoadFileName varchar( 255)
    select 
        null AS PersonID           -- 0 Always null -- Included in table for manual matching to an existing person 
        ,[Run Date]                -- 1 
		,[Employee SSN]
		,[Performance Plan Issue Date]
		,[Rating Period Start Date]
		,[Rating Period End Date]
		,[Has PP]
		,[Agency Sub Element]
		,[HSSO]
		, 'No Matching Person'	 as [FailureReason]   -- 12
		, '' as [LoadFileName]					   -- 13
		, cast(SYSDATETIME() as smallDATEtime) AS FailureDateTime -- 14 
		, null AS [ProcessedDate]  -- 15 -- Manual records removed from yy tables after they are processed -- could keep to keep track of why the people were missing
		, null AS ProcessingNotes  -- 16
    
	From xxPPID x
	left outer join person p
		on p.SSN = x.[Employee SSN]
	where p.SSN is null

print 'Rows inserted into yy Holding table (for No Matching Person): ' + cast(@@rowcount as char)  

		end

	else
		begin
print 'No rows in xxPPID to load ' + cast(@toLoadCount as char) 
		end
end

GO
