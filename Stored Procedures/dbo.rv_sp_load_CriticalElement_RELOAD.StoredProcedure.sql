USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_CriticalElement_RELOAD]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--DROP procedure [dbo].[rv_sp_load_CriticalElement_RELOAD]  
--GO

CREATE procedure [dbo].[rv_sp_load_CriticalElement_RELOAD]  
with execute as owner 
as
Begin

print '=========================================================' 
print 'Inside CriticalElement, executing... '  
print '=========================================================' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)

    declare @priorTableCount int
    declare @toLoadCount int
    declare @afterLoadCount int
        
--  Temporarily use xxCECriticalElements  select @toLoadCount = count(*) from xxCriticalElement
	select @toLoadCount = count(*) from xxCECriticalElements
print 'Step 1 Before loading, number of rows in xxCriticalElement to load is ' + cast(@toLoadCount as char) 

	if  @toLoadCount >0 
		Begin

print 'Step 1.2 Checking if (FY+ run date) exists in CriticalElement'
	
	declare @DupCount int
	
	-- check if FY+RunDate combinations exist in CriticalElement table.

	select @DupCount = count(distinct c.[FYDESIGNATION]) 
	from [dbo].[CriticalElement] c
	inner join xxHigh3_Reload h3
		on h3.[FYDESIGNATION] = c.[FYDESIGNATION]
		and h3.[Run Date] = c.RunDate 
	inner join xxCECriticalElements x
		on (CAST('FY' + (CAST(YEAR(x.RatingPeriodEndDate) AS CHAR(4))) AS CHAR(6))) = c.FYDESIGNATION
		-- JJM 2017-11-27 replace with RPED year - on x.[Fiscal Year High 3] = c.FYDESIGNATION
		and h3.[Run Date] = c.RunDate 


	if @DupCount > 0
	begin
		print 'Critical Elements data has already been loaded. Please Check xx Staging Table contents.' 

		print 'Rows already loaded for the following FYs and RunDates:' 

		select [FYDESIGNATION],[RunDate], count([RunDate]) 
		from CriticalElement x
		group by [FYDESIGNATION],[RunDate]
		order by [FYDESIGNATION]
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

        --JJM 2017-11-27 Use CriticalElement temporarily --select @priorTableCount = count(*) from CriticalElement        
        select @priorTableCount = count(*) from CriticalElement        

print 'before inserting CriticalElements, number of rows in CriticalElement is ' + cast(@priorTableCount as char) 

			insert into dbo.CriticalElement(
                [RunDate]                 -- 1 
               ,[FYDESIGNATION]          -- 2
               ,[PersonID]               -- 3
               ,[CriticalElementNumber]  -- 4
               ,[CriticalElementName]    -- 5
               ,[PercentageWeighting]    -- 6
               ,[CrticalElementRating]   -- 7
               ,[High3Element]           -- 8
               -- JJM 2017-11-27 removed column ,[GroupName]              -- 9
               ,[OverallRating]          -- 10
               ,DataSource               -- 11	-- drop it
               ,SystemSource             -- 12  -- JShay: remove it
               ,AsOfDate                 -- 13
               )
           	select 
                GETDATE() 
               ,(CAST('FY' + (CAST(YEAR(x.RatingPeriodEndDate) AS CHAR(4))) AS CHAR(6)))	-- 2
               ,p.[PersonID]																-- 3 [Employee SSN] AS [SSN]
               ,x.[CriticalElementNumber]													-- 4
               ,x.[CriticalElementName]														-- 5
               ,CAST(ROUND(x.[PercentageWeighting],0) AS INT)								-- 6
               ,x.[CrticalElementRating]													-- 7 
               ,h3.[High 3 Only]															-- 8
               -- JJM 2017-11-27 removed column ,[Group Name]				                -- 9
               ,perf.[OverallRating]														-- 10
               ,'CHRISBI'																	-- 11  
               ,'APPAS Universe'															-- 12
               ,SYSDATETIME()																-- 13

			-- JJM 2017-11-27 temporarily changed to xxCECriticalElements --from xxCriticalElement x
			from xxCECriticalElements x
			inner join person p 
					-- JJM 2017-11-27 remove blank in SSN column - on ltrim(rtrim(x.[Employee SSN]))= p.ssn  
					on ltrim(rtrim(x.[EmployeeSSN]))= p.ssn  
--          JJM 2017-11-27 Add join to xxHigh3_RELOAD
			left outer join xxHIGH3_Reload h3
					-- JJM 2017-11-27 remove blank in SSN column - on ltrim(rtrim(x.[Employee SSN]))= p.ssn  
					on h3.[Employee SSN] = p.ssn  
					   and
					   h3.FYDESIGNATION = (CAST('FY' + (CAST(YEAR(x.RatingPeriodEndDate) AS CHAR(4))) AS CHAR(6)))   
--			JJM 2017-11-27 Add join to PerformanceRating table for OverallRating 
			left outer join PerformanceRating perf 
					-- JJM 2017-11-27 remove blank in SSN column - on ltrim(rtrim(x.[Employee SSN]))= p.ssn  
					on perf.[PersonID] = p.PersonID
					   and
					   perf.FiscalYearRating = (CAST('FY' + (CAST(YEAR(x.RatingPeriodEndDate) AS CHAR(4))) AS CHAR(6)))   

/*
-- only existing persons' CriticalElement records will be loaded, so new person's CriticalElement records are ignored
*/

print 'Rows inserted (for existing persons): ' + cast(@@rowcount as char)  

print 'Anticipated total # of rows ' +  cast(@toLoadCount + @priorTableCount as char) 

--      JJM 2017-11-27 Temporarily changed to CriticalElement - select @afterLoadCount = count(*) from CriticalElement        
        select @afterLoadCount = count(*) from CriticalElement        
print 'After loading, number of rows in CriticalElement is ' + cast(@afterLoadCount as char) 

print '# of Rows ignored: ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 

/* 
All the ignored records will be written into yy tables. 
*/
print 'Step 3  Inserting into yy table for missing people'
/*
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
*/
		end

	else
		begin
print 'No rows in xxCriticalElement to load ' + cast(@toLoadCount as char) 
		end
end


GO
