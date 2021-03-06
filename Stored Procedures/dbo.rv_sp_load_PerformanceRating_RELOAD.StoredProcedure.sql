USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_PerformanceRating_RELOAD]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-10-02  
-- Description: Add update to PerformanceRating.High3Flag for employees in 
--              the xxHigh3 table.
-- =============================================================================
CREATE procedure [dbo].[rv_sp_load_PerformanceRating_RELOAD]  
with execute as owner --,   ENCRYPTION  -- Should we Change from Owner to Self and add ENCRYPTION option (as security measure for final deployment)-- Need to check with mike as to why anyone may execute the load scripts
as
Begin

print '=========================================================' 
print 'Inside PerformanceRating, executing... '  
print '=========================================================' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)

    declare @priorTableCount int
    declare @priorTableCount2 int -- Used for after xxSecondary load before xxUnrateable load
    declare @toLoadCount int      -- Used for xxSecondary 
    declare @toLoadCount2 int     -- Used for xxUnrateable
    declare @loadedCount int      -- Used for xxSecondary rows loaded into PerformanceRating
    declare @loadedCount2 int     -- Used for xxUnrateable rows loaded into PerformanceRating
    declare @IgnoredCount int     -- Used for ignored xxSecondary rows added to yy tables 
    declare @IgnoredCount2 int    -- Used for ignored xxUnrateable rows added to yy tables 
    declare @afterLoadCount int   -- Used for xxSecondary
    declare @afterLoadCount2 int  -- Used for xxUnrateable
    declare @prcount int          -- Used for PerformanceRating after load count
        
    select @toLoadCount = count(*) from HRDW.dbo.xxSecondary_Reload_This_One
    select @toLoadCount2 = count(*) from HRDW.dbo.xxUnrateable

	if  @toLoadCount+@toLoadCount2 >0 
		Begin

	declare @DupCount int
    declare @DupCount2 int	

	-- check if FY+RunDate combinations exist in PerformanceRating table.

	select @DupCount = count(distinct [FiscalYearRating]) 
	from [dbo].PerformanceRating c
	inner join HRDW.dbo.xxSecondary_Reload_This_One x
		on x.[Fiscal Year Rating] = c.FiscalYearRating
		and x.[Run Date] = c.RunDate 

    select @DupCount2 = count(distinct [FiscalYearRating]) 
	from HRDW.[dbo].PerformanceRating c
	inner join HRDW.dbo.xxUnrateable x
		on x.[Fiscal Year Rating] = c.FiscalYearRating
		and x.[Run Date] = c.RunDate 
/*
	if @DupCount+@DupCount2 > 0
	begin
        print 'Checking if content in xxSecondary and xxUnrateable staging tables exists in PerformanceRating (FY+ Run Date) '
        print ' '
		--print 'Performance Rating data has already been loaded. '
  --      print ' '
		print 'Please review xxSecondary and xxUnrateable Staging Table contents against PerformanceRating.' 
		--print 'Count xxSecondary Staging Table FYs and RunDates '  + cast(@DupCount as char) 
		--print 'Count xxUnrateable Staging Table FYs and RunDates '  + cast(@DupCount2 as char) 
        print ' '
		print 'Rows in PerformanceRating for the following FYs and RunDates (See Results Tab):' 

		select [FiscalYearRating],[RunDate], count([RunDate]) as Rows 
		from PerformanceRating 
		group by [FiscalYearRating],[RunDate]
		order by [FiscalYearRating]
		print ' '
		print SYSDATETIME()
		return
	end
*/
    select @priorTableCount = count(*) from PerformanceRating 
print 'Step 1 Before loading PerformanceRating from xxSecondary and xxUnrateable staging tables'
print '       # of rows in PerformanceRating      ' + cast(@priorTableCount as char) 
print '       # of rows to load from xxSecondary  ' + cast(@toLoadCount as char) 
print '       # of rows to load from xxUnrateable ' + cast(@toLoadCount2 as char) 
print '       PerformanceRating + xx Tables       ' + cast(@priorTableCount+@toLoadCount+@toLoadCount2 as char) 

			INSERT INTO HRDW.dbo.PerformanceRating(
               [RunDate]                 -- 1 
			   ,[FiscalYearRating]
			   ,[EmployeeFullName]
			   ,[RatingPeriodStartDate]
			   ,[RatingPeriodEndDate]
			   ,[OverallRating]
			   ,[Unratable]
			   ,[PayPlan]
			   ,[PersonID]
			   ,[HSSO]
			   ,[AppraisalTypeDescription]
			   ,[AppraisalStatus]
			   ,[CurrentManagerID]
			   ,[FAPManagerID]
			   ,[MidYearManagerID]
			   ,[Organization]
			   ,[AgencySubElement]
			   ,[OwningRegion]
			   ,[ServicingRegion]
			   ,[PersonnelOfficeIdentifier]
			   ,[DataSource]
			   ,[SystemSource]
			   ,[AsOfDate]
			   ,[High3Flag]
			   )
          	select 
               x.[Run Date]						-- 1 
			  ,[Fiscal Year Rating]
			  ,[Employee Full Name]
			  ,[Rating Period Start Date]
			  ,[Rating Period End Date]
			  ,[Overall Rating]
			  ,[Unratable]
			  ,[Pay Plan]
			  ,p.[PersonID]  -- Replaces [Employee SSN]
			  ,[HSSO]
			  ,[Appraisal Type Description]
			  ,[Appraisal Status]
--			  ,[Current Manager Full Name]						-- may prove usefulness to add Manager fullname if not existed in Person
			  --,dbo.rv_fn_PersonIdViaSSN([Current Manager SSN])	
			  , p1.PersonID
--			  ,[FAP Manager Full Name]
			  --,dbo.rv_fn_PersonIdViaSSN([FAP Manager SSN])		
			  , p2.PersonID
--			  ,[MYR Manager Full Name]
			  --,dbo.rv_fn_PersonIdViaSSN([MYR Manager SSN])		
			  , p3.PersonID
			  ,[Organization]
			  ,[Agency Sub Element]
			  ,[Owning Region]
			  ,[Servicing Region]
			  ,[Personnel Office Identifier]
               ,null							-- 11  -- Many spreadsheets have the same name  -- should we ask client to include unique number on end of NAME like PMU and include as column "DataSource" as 2nd to last row in spreadsheet
               ,null							-- 12  -- should we ask client to include as column "SystemSource" as last row in spreadsheet
               ,SYSDATETIME()			        -- 13
--              JJM 2016-10-02 - Add Update to High3Flag
			   ,CASE 
					WHEN xh.[High 3 Only] IS NOT NULL
					THEN 'Yes'		
					ELSE 'No'
				END
			from HRDW.dbo.xxSecondary_Reload_This_One x
			join HRDW.dbo.person p 
				on ltrim(rtrim(x.[Employee SSN]))= p.ssn  
			left outer join HRDW.dbo.person p1
				on ltrim(rtrim(x.[Current Manager SSN]))= p1.ssn   -- Should we use inner join where[Current Manager SSN] not null  and send missing people to yy?
			left outer join HRDW.dbo.person p2
				on ltrim(rtrim(x.[FAP Manager SSN]))= p2.ssn
			left outer join HRDW.dbo.person p3
				on ltrim(rtrim(x.[MYR Manager SSN]))= p3.ssn
--          JJM 2016-10-02 - Add Update to High3Flag
			left outer join HRDW.dbo.xxHIGH3_Reload xh
				on ltrim(rtrim(xh.[Employee SSN])) = p.ssn
				   AND
				   xh.FYDESIGNATION = x.[Fiscal Year Rating]

        select @loadedCount = @@rowcount
        select @afterLoadCount = count(*) from PerformanceRating     
/*
-- only existing persons' Secondary records will be loaded, so new person's Secondary records are ignored
*/
print 'Step 2 Loading PerformanceRating records from xxSecondary staging table'
print '       # of rows in PerformanceRating         ' + cast(@priorTableCount as char) 
print '       # of rows to load from xxSecondary     ' + cast(@toLoadCount as char) 
print '       PerformanceRating + xxSecondary        ' + cast(@priorTableCount+@toLoadCount as char) 
print '       # of rows loaded from xxSecondary      ' + cast(@loadedCount as char) 
print '       PerformanceRating + xxSecondary loaded ' + cast(@afterLoadCount as char) 
print '       # of xxSecondary Rows ignored          ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 

/* 
All the ignored records will be written into yy tables. 
*/

    INSERT INTO HRDW.dbo.yySecondary
        ([PersonID]               -- 0 Always null -- Included in table for manual matching to an existing person 
        ,[Run Date]               -- 1 
        ,[Fiscal Year Rating]
        ,[Employee Full Name]
        ,[Rating Period Start Date]
        ,[Rating Period End Date]
        ,[Overall Rating]
        ,[Unratable]
        ,[Pay Plan]
        ,[Employee SSN]
        ,[HSSO]
        ,[Appraisal Type Description]
        ,[Appraisal Status]
        ,[Current Manager Full Name]
        ,[Current Manager SSN]
        ,[FAP Manager Full Name]
        ,[FAP Manager SSN]
        ,[MYR Manager Full Name]
        ,[MYR Manager SSN]
        ,[Organization]
        ,[Agency Sub Element]
        ,[Owning Region]
        ,[Servicing Region]
        ,[Personnel Office Identifier]
        ,[FailureReason]          -- 12	-- yy Specific
        ,[LoadFileName]           -- 13	-- same as DataSource
        ,[FailureDateTime]        -- 14	-- yy Specific
        ,[ProcessedDate]          -- 15	-- yy Specific
        ,[ProcessingNotes]        -- 16	-- yy Specific
        )
 --declare @LoadFileName varchar( 255)
    select 
        null AS PersonID           -- 0 Always null -- Included in table for manual matching to an existing person 
        ,x.[Run Date]                -- 1 
        ,x.[Fiscal Year Rating]
        ,x.[Employee Full Name]
        ,x.[Rating Period Start Date]
        ,x.[Rating Period End Date]
        ,x.[Overall Rating]
        ,x.[Unratable]
        ,x.[Pay Plan]
        ,x.[Employee SSN]
        ,x.[HSSO]
        ,x.[Appraisal Type Description]
        ,x.[Appraisal Status]
        ,x.[Current Manager Full Name]
        ,x.[Current Manager SSN]
        ,x.[FAP Manager Full Name]
        ,x.[FAP Manager SSN]
        ,x.[MYR Manager Full Name]
        ,x.[MYR Manager SSN]
        ,x.[Organization]
        ,x.[Agency Sub Element]
        ,x.[Owning Region]
        ,x.[Servicing Region]
        ,x.[Personnel Office Identifier]
		, 'No Matching Person'	   -- 12	-- yy Specific [FailureReason]
		, null					   -- 13    -- yy Specific [LoadFileName]
		, cast(SYSDATETIME() as smallDATEtime) AS FailureDateTime -- 14 
		, null AS [ProcessedDate]  -- 15 -- Manual records removed from yy tables after they are processed -- could keep to keep track of why the people were missing
		, null AS ProcessingNotes  -- 16 -- Manual input  - Intended for caputre of analysis while attempting to match records between diffrent systems
    
	From HRDW.dbo.xxSecondary_Reload_This_One x
	left outer join HRDW.dbo.person p
		on p.SSN = x.[Employee SSN]
	where p.SSN is null

        select @IgnoredCount = @@rowcount
        --select @afterLoadCount = count(*) from PerformanceRating     
print 'Step 2b  Inserting into yySecondary Holding Table for missing people'
print '       Anticipated # of Rows ignored to load into yySecondary Holding Table  ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 
print '       Rows inserted into yySecondary Holding table (for No Matching Person) ' + cast(@IgnoredCount as char)  
print ' '
/*
        select @priorTableCount2 = count(*) from PerformanceRating        

			INSERT INTO dbo.PerformanceRating(
               [RunDate]                 -- 1 
			   ,[FiscalYearRating]
			   ,[EmployeeFullName]
			   ,[RatingPeriodStartDate]
			   ,[RatingPeriodEndDate]
			   ,[OverallRating]
			   ,[Unratable]
			   ,[PayPlan]
			   ,[PersonID]
			   ,[HSSO]
			   ,[AppraisalTypeDescription]
			   ,[AppraisalStatus]
			   ,[CurrentManagerID]
			   ,[FAPManagerID]
			   ,[MidYearManagerID]
			   ,[Organization]
			   ,[AgencySubElement]
			   ,[OwningRegion]
			   ,[ServicingRegion]
			   ,[PersonnelOfficeIdentifier]
	  		   ,[UnratableReason]  -- Only used for Unratable
			   ,[DataSource]
			   ,[SystemSource]
			   ,[AsOfDate]
			   )
          	select 
               [Run Date]											 -- 1 
               ,[Fiscal Year Rating]
               ,[Employee Full Name]
               ,[Rating Period Start Date]
               ,[Rating Period End Date]
               ,[Overall Rating]
               ,[Unratable]
               ,[Pay Plan]
               ,p.[PersonID]  -- Replaces [Employee SSN]
               ,[HSSO]
               ,[Appraisal Type Description]
               ,[Appraisal Status]
               --,[Current Manager Full Name]						-- may prove usefulness to add Manager fullname if not existed in Person
               --,dbo.rv_fn_PersonIdViaSSN([Current Manager SSN])
			   , p1.PersonID
               --,[FAP Manager Full Name]
               --,dbo.rv_fn_PersonIdViaSSN([FAP Manager SSN])
			   , p2.PersonID
               --,[MYR Manager Full Name]
               --,dbo.rv_fn_PersonIdViaSSN([MYR Manager SSN])
			   , p3.PersonID
               ,[Organization]
               ,[Agency Sub Element]
               ,[Owning Region]
               ,[Servicing Region]
               ,[Personnel Office Identifier]
               ,[Unratable Reason]  -- Only used for Unratable note SP diffrence between spreadsheet tab and column names - both seem to be correct may client context specific spelling 
               ,null												 -- 11  -- Many spreadsheets have the same name  -- should we ask client to include unique number on end of NAME like PMU and include as column "DataSource" as 2nd to last row in spreadsheet
               ,null											     -- 12  -- should we ask client to include as column "SystemSource" as last row in spreadsheet
               ,SYSDATETIME()			                             -- 13

			from xxUnrateable x
			join person p 
					on ltrim(rtrim(x.[Employee SSN]))= p.ssn  
			left outer join person p1
				on ltrim(rtrim(x.[Current Manager SSN]))= p1.ssn
			left outer join person p2
				on ltrim(rtrim(x.[FAP Manager SSN]))= p2.ssn
			left outer join person p3
				on ltrim(rtrim(x.[MYR Manager SSN]))= p3.ssn
--          JJM 2016-09-19 - Exclude employees in With Annual / Mid-Year ratings from being loaded
--                           in Performance Rating w/ Unrateable
			WHERE p.PersonID NOT IN (
					SELECT pr.PersonID 
					FROM
						PerformanceRating pr
				    WHERE
						pr.RunDate = (select max(pr2.RunDate) from PerformanceRating pr2)
								    )
*/
        select @loadedCount2 = @@rowcount

/*
-- only existing persons' Secondary records will be loaded, so new person's Secondary records are ignored
*/

        select @afterLoadCount2 = count(*) FROM HRDW.dbo.PerformanceRating        

print 'Step 3 Loading PerformanceRating records from xxUnrateable staging table'
print '       # of rows in PerformanceRating          ' + cast(@priorTableCount2 as char) 
print '       # of rows to load from xxUnrateable     ' + cast(@toLoadCount2 as char) 
print '       PerformanceRating + xxUnrateable        ' + cast(@priorTableCount2+@toLoadCount2 as char) 
print '       # of rows loaded from xxUnrateable      ' + cast(@loadedCount2 as char) 
print '       PerformanceRating + xxUnrateable loaded ' + cast(@afterLoadCount2 as char) 
print '       # of xxUnrateable Rows ignored          ' + cast(@toLoadCount2 + @priorTableCount2 - @afterLoadCount2  as char) 


/* 
All the ignored records will be written into yy tables. 
*/
/*
    INSERT INTO yyUnrateable
        ([PersonID]               -- 0 Always null -- Included in table for manual matching to an existing person 
        ,[Run Date]               -- 1 
        ,[Fiscal Year Rating]
        ,[Employee Full Name]
        ,[Rating Period Start Date]
        ,[Rating Period End Date]
        ,[Overall Rating]
        ,[Unratable]
        ,[Pay Plan]
        ,[Employee SSN]
        ,[HSSO]
        ,[Appraisal Type Description]
        ,[Appraisal Status]
        ,[Current Manager Full Name]
        ,[Current Manager SSN]
        ,[FAP Manager Full Name]
        ,[FAP Manager SSN]
        ,[MYR Manager Full Name]
        ,[MYR Manager SSN]
        ,[Organization]
        ,[Agency Sub Element]
        ,[Owning Region]
        ,[Servicing Region]
        ,[Personnel Office Identifier]
        ,[Unratable Reason]
        ,[FailureReason]          -- 12	-- yy Specific
        ,[LoadFileName]           -- 13	-- same as DataSource
        ,[FailureDateTime]        -- 14	-- yy Specific
        ,[ProcessedDate]          -- 15	-- yy Specific
        ,[ProcessingNotes]        -- 16	-- yy Specific
        )
 --declare @LoadFileName varchar( 255)
    select 
        null AS PersonID           -- 0 Always null -- Included in table for manual matching to an existing person 
        ,[Run Date]                -- 1 
        ,[Fiscal Year Rating]
        ,[Employee Full Name]
        ,[Rating Period Start Date]
        ,[Rating Period End Date]
        ,[Overall Rating]
        ,[Unratable]
        ,[Pay Plan]
        ,[Employee SSN]
        ,[HSSO]
        ,[Appraisal Type Description]
        ,[Appraisal Status]
        ,[Current Manager Full Name]
        ,[Current Manager SSN]
        ,[FAP Manager Full Name]
        ,[FAP Manager SSN]
        ,[MYR Manager Full Name]
        ,[MYR Manager SSN]
        ,[Organization]
        ,[Agency Sub Element]
        ,[Owning Region]
        ,[Servicing Region]
        ,[Personnel Office Identifier]
        ,[Unratable Reason]
		, 'No Matching Person'	   -- 12	-- yy Specific [FailureReason]
		, null					   -- 13    -- same as DataSource [LoadFileName] -- Jerry recomendation reconsile on single name for all files
		, cast(SYSDATETIME() as smallDATEtime) AS FailureDateTime -- 14 
		, null AS [ProcessedDate]  -- 15 -- Manual records removed from yy tables after they are processed -- could keep to keep track of why the people were missing
		, null AS ProcessingNotes  -- 16 -- Manual input  - Intended for caputre of analysis while attempting to match records between diffrent systems
    
	From xxUnrateable x
	left outer join person p
		on p.SSN = x.[Employee SSN]
	where p.SSN is null

        select @IgnoredCount2 = @@rowcount
*/
print 'Step 3b  Inserting into yyUnrateable Holding Table for missing people'
print '       Anticipated # of Rows ignored to load into yyUnrateable Holding Table  ' + cast(@toLoadCount2 + @priorTableCount2 - @afterLoadCount2  as char) 
print '       Rows inserted into yyUnrateable Holding table (for No Matching Person) ' + cast(@IgnoredCount2 as char)  
print ' '
    select @prcount = count(*) from HRDW.dbo.PerformanceRating
print 'Load Summary ' 
print ' '
print 'Before loading PerformanceRating from xxSecondary and xxUnrateable staging tables'
print '       Before # of PerformanceRating rows  ' + cast(@priorTableCount as char) 
print '       # of rows to load from xxSecondary  ' + cast(@toLoadCount as char) 
print '       # of rows to load from xxUnrateable ' + cast(@toLoadCount2 as char) 
print '       PerformanceRating + xx Tables       ' + cast(@priorTableCount+@toLoadCount+@toLoadCount2 as char) 
print ' '
print 'After loading PerformanceRating from xxSecondary and xxUnrateable staging tables'
print '       # of rows inserted into PerformanceRating from xxSecondary     ' + ltrim(rtrim(cast(@loadedCount as char)))  
print '       # of rows inserted into PerformanceRating from xxUnrateable    ' + ltrim(rtrim(cast(@loadedCount2 as char)))  
print '       # of rows from xxSecondary ignored and placed in yySecondary   ' + ltrim(rtrim(cast(@IgnoredCount as char)))  
print '       # of rows from xxUnrateable ignored and placed in yyUnrateable ' + ltrim(rtrim(cast(@IgnoredCount2 as char)))  
print '       Total # of rows processed                                      ' + ltrim(rtrim(cast(@loadedCount+@loadedCount2+@IgnoredCount+@IgnoredCount2 as char)))  

print ' '

print '       After # of PerformanceRating rows                 ' + ltrim(rtrim(cast(@prcount as char)))  
print '       Ignored # of rows added to yy tables              ' + cast((@priorTableCount+@toLoadCount+@toLoadCount2)-@prcount as char) 
print '       ( Before # + ToLoad # ) - (After # + Ignored #) = ' + cast((@priorTableCount+@toLoadCount+@toLoadCount2)-(@prcount+@IgnoredCount+@IgnoredCount2) as char) 
print ' '
print SYSDATETIME()

--print '       Total # of rows in PerformanceRating ' + ltrim(rtrim(cast(@afterLoadCount2-@priorTableCount as char)))  

		end

	else
		begin
			print 'No rows in xxSecondary '+ ltrim(rtrim(cast(@toLoadCount as char)))+' or xxUnrateable to load ' + ltrim(rtrim(cast(@toLoadCount2 as char))) 
			print ' '
			print SYSDATETIME()

		end
end




GO
