USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_Security]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-04-29  
-- Description: Delete existing Security rows before inserting latest dataset
-- =============================================================================
CREATE procedure [dbo].[rv_sp_load_Security]
with execute as owner		
as

Begin

print '=========================================================' 
print 'Inside Security, executing... '  
print '=========================================================' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)


print 'Start Date Time: '
print SYSDATETIME()
print ' '
    declare @recDateCount int 
	declare @priorTableCount int
    declare @toLoadCount int      -- Used for # of rows to load in staging xxTable
    declare @loadedCount int      -- Used for xxTable rows loaded into target
    declare @ignoredCount1 int    -- Used for ignored xxTable rows added to Holding yyTable (missing people)
	declare @ignoredCount2 int    -- Used for ignored xxTable rows added to Holding yyTable (null Clearance Date or Clearance Number)
    declare @afterLoadCount int   -- Used for target table count 

-- check if xxSecurity table contains multiple Rundates. if it does, then stop the script, go back and truncate xx table, keep only one RecordDate.
print 'Step 0 (A) Checking for multiple Record Dates in xxSecurity'

	select @recDateCount=count(distinct [Record Date]) from [dbo].[xxSecurity]

	if  @recDateCount > 1 
	Begin
		print cast(@recDateCount as char) +' RecordDates exist in xxSecurity. Go back and truncate xx table, keep only one RecordDate.'
		return
	End

print 'Step 0 (B) Checking if record date exists in Security table'

	declare @SRecordDate date
	select top 1 @SRecordDate = [Record Date] from [xxSecurity]

	if @SRecordDate in (select isnull([RecordDate],'') from Security)
	begin
		print 'Security data for this Record Date already loaded '  + cast(@SRecordDate as char) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
		print 'No Security records loaded'
		return
	end

    select @toLoadCount = count(*) from xxSecurity

	if  @toLoadCount > 0 
		Begin

print 'Step 1 Before loading Security from xxSecurity staging table'

    select @priorTableCount = count(*) from Security 

print '       # of rows in Security              ' + cast(@priorTableCount as char) 
print '       # of rows to load from xxSecurity  ' + cast(@toLoadCount as char) 
print '       Security + xx Tables               ' + cast(@priorTableCount+@toLoadCount as char) 

print 'Step 2 Loading Security records from xxSecurity staging table'
print ''
print 'Deleting existing rows from Security prior to loading latest dataset'
DELETE FROM Security

	insert into security(
		PersonID				 -- 1
		,RecordDate				 -- 2		-- Keep it
		--,ClearanceCurrent        -- 3       -- remove it per Ralph's email on 2/22/2016
		,ClearanceDate           -- 4  
		,InvestigationType       -- 5      
		,ClearanceDescription    -- 6          
		,SecurityClearanceNumber -- 7            
		,[DataSource]            -- 8
		,[SystemSource]          -- 9
		,[AsOfDate]              -- 10	-- change to "DateLoaded"
	)
	select
        p.PersonID						-- 1  
        ,t.[Record Date]				-- 2		    
        --,t.[Current?]					-- 3	-- remove it per Ralph's email on 2/22/2016
        ,t.[Clearance Date]				-- 4
        ,t.[Investigation_Type]			-- 5
        ,t.[Clearance_Description]		-- 6
        ,t.[Security_Clearance_Number]	-- 7
		,'' as [DataSource]              -- 8
		,'' as [SystemSource]            -- 9
		,sysdatetime() as [AsOfDate]     -- 10		-- change to "DateLoaded"

	from xxSecurity t
	join Person p
	on ltrim(rtrim(t.[Social Security])) = p.SSN 
		--and t.Security_Clearance_Number is not null --as long as the Clearance Date is not null, we will load them per Ralph on 2/22/2016 email.
		and t.[Clearance Date] is not null
		  
	-- only insert new security records for existing employees (existed in Person)
    where not exists    
	(
		select s.PersonID,s.ClearanceDate,s.InvestigationType,s.SecurityClearanceNumber  
		from Security s
		where s.PersonID = p.PersonID 
		and s.ClearanceDate = t.[Clearance Date] 
		and s.InvestigationType = t.[Investigation_Type]
		and s.SecurityClearanceNumber = t.[Security_Clearance_Number]
   )
       select @loadedCount = @@rowcount

       select @afterLoadCount = count(*) from Security
              
print '       # of rows loaded from xxSecurity        ' + cast(@loadedCount as char) 
print '       Security + xxSecurity loaded              ' + cast(@afterLoadCount as char) 
print '       # of xxSecurity Rows ignored            ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 
 
/* 
Rejected records will be written into yy tables for the following reasons: (1) if SSNs are not in Person; (2) if either Clearance Date or Clearance Number is null.
Note that the rejected xx records will not be inserted into yy table if they already existed in Security table.
*/

print CHAR(13) + CHAR(10)+'Step 3  Inserting into yy table for missing people'

INSERT INTO yySecurity
        ([PersonID]               -- 0 Always null -- Included in table for manual matching to an existing person 
        ,[Current?]               -- 1
        ,[Record Date]            -- 2   
        ,[Social Security]        -- 3       
        ,[Clearance Date]         -- 4      
        ,[Investigation_Type]     -- 5          
        ,[Clearance_Description]  -- 6             
        ,[Security_Clearance_Number] -- 7
        ,[FailureReason]          -- 8	--future add case statements if other reasons
        ,[LoadFileName]           -- 9
        ,[FailureDateTime]        -- 10
        ,[ProcessedDate]          -- 11
        ,[ProcessingNotes]        -- 12
        )
 --declare @LoadFileName varchar( 255)
    select 
        null AS PersonID           -- 0 Always null -- Included in table for manual matching to an existing person 
        ,[Current?]               -- 1
        ,[Record Date]            -- 2   
        ,[Social Security]        -- 3       
        ,[Clearance Date]         -- 4      
        ,[Investigation_Type]     -- 5          
        ,[Clearance_Description]  -- 6             
        ,[Security_Clearance_Number] -- 7
		, 'No Matching Person'	   -- 8
		, ''					   -- 9
		, cast(SYSDATETIME() as smallDATEtime) AS FailureDateTime -- 10 
		, null AS [ProcessedDate]  -- 11 -- Manual records removed from yy tables after they are processed -- could keep to keep track of why the people were missing
		, null AS ProcessingNotes  -- 12
    
	From xxSecurity x

	left outer join person p
		on p.SSN = x.[Social Security]
	where p.SSN is null

    select @IgnoredCount1 = @@rowcount

print 'Rows inserted into yy Holding table (for No Matching Person): ' + cast(@IgnoredCount1 as char)  
      
print CHAR(13) + CHAR(10)+'Step 4  Inserting into yy table for those rejected records which either Clearance Date or Clearance Number is null'

INSERT INTO yySecurity
        ([PersonID]               -- 0  
        ,[Current?]               -- 1
        ,[Record Date]            -- 2   
        ,[Social Security]        -- 3       
        ,[Clearance Date]         -- 4      
        ,[Investigation_Type]     -- 5          
        ,[Clearance_Description]  -- 6             
        ,[Security_Clearance_Number] -- 7
        ,[FailureReason]          -- 8	--future add case statements if other reasons
        ,[LoadFileName]           -- 9
        ,[FailureDateTime]        -- 10
        ,[ProcessedDate]          -- 11
        ,[ProcessingNotes]        -- 12
        )
 
     select 
        p.PersonID				  -- 0 
        ,[Current?]               -- 1
        ,[Record Date]            -- 2   
        ,[Social Security]        -- 3       
        ,[Clearance Date]         -- 4      
        ,[Investigation_Type]     -- 5          
        ,[Clearance_Description]  -- 6             
        ,[Security_Clearance_Number] -- 7
		, 'Null Clearance Date or Clearance Number'	   -- 8
		, ''					   -- 9
		, cast(SYSDATETIME() as smallDATEtime) AS FailureDateTime -- 10 
		, null AS [ProcessedDate]  -- 11 -- Manual records removed from yy tables after they are processed  
		, null AS ProcessingNotes  -- 12
    
	from xxSecurity t
	join Person p
	on ltrim(rtrim(t.[Social Security])) = p.SSN	
		and 
		 t.[Clearance Date] is null
		
    select @IgnoredCount2 = @@rowcount

print 'Rows inserted into yy Holding table (for null Clearance Date or Clearance Number): ' + cast(@IgnoredCount2 as char)  

--print '       Anticipated # of Rows ignored to load into yySecurity Holding Table  ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 
--print '       Rows inserted into yySecurity Holding table (for No Matching Person) ' + cast(@IgnoredCount as char)  
--print ' '
--print 'Load Summary ' 
--print ' '
--print 'Before loading Security from xxSecurity staging table'
--print '       Before # of Security rows             ' + cast(@priorTableCount as char) 
--print '       # of rows to load from xxSecurity    ' + cast(@toLoadCount as char) 
--print '       Security + xx Table                   ' + cast(@priorTableCount+@toLoadCount as char) 
--print ' '
--print 'After loading Security from xxSecurity staging table'
--print '       # of rows inserted into Security from xxSecurity       ' + ltrim(rtrim(cast(@loadedCount as char)))  
--print '       # of rows from xxSecurity ignored                    ' + ltrim(rtrim(cast(@IgnoredCount as char)))  
--print '       Total # of rows processed                           ' + ltrim(rtrim(cast(@loadedCount+@IgnoredCount as char)))  
--print ' '
--print '       After # of Security rows                            ' + ltrim(rtrim(cast(@afterLoadCount as char)))  
--print '       Ignored # of rows added to yy tables              ' + cast((@priorTableCount+@toLoadCount)-@afterLoadCount as char) 
--print '       ( Before # + ToLoad # ) - (After # + Ignored #) = ' + cast((@priorTableCount+@toLoadCount)-(@afterLoadCount+@IgnoredCount) as char) 
print ' '
print 'Finish Date Time: '
print SYSDATETIME()

		end

	else
		begin
			print 'No rows in xxSecurity '+ ltrim(rtrim(cast(@toLoadCount as char))) 
			print ' '
			print 'Load Fail Date Time: '
			print SYSDATETIME()

		end
end


GO
