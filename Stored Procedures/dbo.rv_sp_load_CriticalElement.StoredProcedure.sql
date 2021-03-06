USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_CriticalElement]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rv_sp_load_CriticalElement]  
with execute as owner --,   ENCRYPTION  -- Should we Change from Owner to self and add ENCRYPTION option -- Need to check with mike as to why anyone may execute the load scripts
as
Begin

print '=========================================================' 
print 'Inside CriticalElement, executing... '  
print '=========================================================' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)

    declare @priorTableCount int
    declare @toLoadCount int
    declare @afterLoadCount int
        
    select @toLoadCount = count(*) from xxCriticalElement

print 'Step 1 Before loading, number of rows in xxCriticalElement to load is ' + cast(@toLoadCount as char) 

	if  @toLoadCount >0 
		Begin

print 'Step 1.2 Checking if (FY+ run date) exists in CriticalElement'
	
	declare @DupCount int
	
	-- check if FY+RunDate combinations exist in CriticalElement table.

	select @DupCount = count(distinct [FiscalYearHigh3]) 
	from [dbo].[CriticalElement] c
	inner join xxCriticalElement x
		on x.[Fiscal Year High 3] = c.FiscalYearHigh3
		and x.[Run Date] = c.RunDate 

/*
	declare @Results varchar(1000) =
		(select distinct [FiscalYearHigh3], [RunDate] 
		from [dbo].[CriticalElement] c
		inner join xxCriticalElement x
		on x.[Fiscal Year High 3] = c.FiscalYearHigh3
			and x.[Run Date] = c.RunDate )

	print 'here:'+@Results
*/

	if @DupCount > 0
	begin
		print 'Critical Elements data has already been loaded. Please Check xx Staging Table contents.' 

		print 'Rows already loaded for the following FYs and RunDates:' 

		select [FiscalYearHigh3],[RunDate], count([RunDate]) 
		from CriticalElement x
		group by [FiscalYearHigh3],[RunDate]
		order by [FiscalYearHigh3]
		print 'Rows in XX Staging Table for the following FYs and RunDates:' 
		
		select [Fiscal Year High 3],[Run Date], count([Run Date]) 
		from xxCriticalElement x
		group by [Fiscal Year High 3],[Run Date]
		order by [Fiscal Year High 3]

		print 'Rows on YY Holding table for the following FYs and RunDates:' 
		select [Fiscal Year High 3],[Run Date], count([Run Date]) 
		from yyCriticalElement x
		group by [Fiscal Year High 3],[Run Date]
		order by [Fiscal Year High 3]

		return
	end


print 'Step 2 Inserting new CriticalElement records for existing people'

        select @priorTableCount = count(*) from CriticalElement        

print 'before inserting CriticalElements, number of rows in CriticalElement is ' + cast(@priorTableCount as char) 

			insert into dbo.CriticalElement(
               [RunDate]                 -- 1 
               ,[FiscalYearHigh3]        -- 2
               ,[PersonID]               -- 3
               ,[CriticalElementNumber]  -- 4
               ,[CriticalElementName]    -- 5
               ,[PercentageWeighting]    -- 6
               ,[CrticalElementRating]   -- 7
               ,[High3Element]           -- 8
               ,[GroupName]              -- 9
               ,[OverallRating]          -- 10
               ,DataSource               -- 11	-- drop it
               ,SystemSource             -- 12  -- JShay: remove it
               ,AsOfDate                 -- 13
               )
           	select 
               [Run Date]											 -- 1 
               ,[Fiscal Year High 3]					             -- 2
               ,[PersonID]                                           -- 3 [Employee SSN] AS [SSN]
               ,[Critical Element Number]							 -- 4
               ,[Critical Element Name]								 -- 5
               ,[Percentage Weighting]								 -- 6
               ,[Crtical Element Rating]							 -- 7 
               ,[High 3 Element?]					                 -- 8
               ,[Group Name]				                         -- 9
               ,[Overall Rating]									 -- 10
               ,''													 -- 11  -- Many spreadsheets have the same name  -- should we ask client to include unique number on end of NAME like PMU
               ,''												     -- 12  -- Hard code for each load or pass as paramater?
               ,SYSDATETIME()			                             -- 13

			from xxCriticalElement x
			join person p 
					on ltrim(rtrim(x.[Employee SSN]))= p.ssn  

/*
-- only existing persons' CriticalElement records will be loaded, so new person's CriticalElement records are ignored
*/

print 'Rows inserted (for existing persons): ' + cast(@@rowcount as char)  

print 'Anticipated total # of rows ' +  cast(@toLoadCount + @priorTableCount as char) 

        select @afterLoadCount = count(*) from CriticalElement        

print 'After loading, number of rows in CriticalElement is ' + cast(@afterLoadCount as char) 

print '# of Rows ignored: ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 

/* 
All the ignored records will be written into yy tables. 
*/
print 'Step 3  Inserting into yy table for missing people'

  INSERT INTO yyCriticalElement
        ([PersonID]               -- 0 Always null -- Included in table for manual matching to an existing person 
        ,[Run Date]               -- 1 
        ,[Fiscal Year High 3]     -- 2
        ,[Employee SSN]           -- 3
        ,[Critical Element Number]-- 4
        ,[Critical Element Name]  -- 5
        ,[F6]                     -- 6                  
        ,[Percentage Weighting]   -- 7
        ,[Crtical Element Rating] -- 8
        ,[High 3 Element?]        -- 9
        ,[Group Name]             -- 10
        ,[Overall Rating]         -- 11
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
        ,[Fiscal Year High 3]      -- 2
        ,[Employee SSN]            -- 3
        ,[Critical Element Number] -- 4
        ,[Critical Element Name]   -- 5
        ,[F6]                      -- 6
        ,[Percentage Weighting]    -- 7
        ,[Crtical Element Rating]  -- 8 
        ,[High 3 Element?]         -- 9
        ,[Group Name]              -- 10
        ,[Overall Rating]          -- 11        
		, 'No Matching Person'	   -- 12
		, ''					   -- 13
		, cast(SYSDATETIME() as smallDATEtime) AS FailureDateTime -- 14 
		, null AS [ProcessedDate]  -- 15 -- Manual records removed from yy tables after they are processed -- could keep to keep track of why the people were missing
		, null AS ProcessingNotes  -- 16
    
	From xxCriticalElement x
	left outer join person p
		on p.SSN = x.[Employee SSN]
	where p.SSN is null

print 'Rows inserted into yy Holding table (for No Matching Person): ' + cast(@@rowcount as char)  

		end

	else
		begin
print 'No rows in xxCriticalElement to load ' + cast(@toLoadCount as char) 
		end
end

GO
