USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_Telework]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-04-29  
-- Description: Delete existing Telework rows before inserting latest dataset
-- =============================================================================
CREATE procedure [dbo].[rv_sp_load_Telework]
with execute as owner		
as

Begin

print '=========================================================' 
print 'Inside Telework, executing... '  
print '=========================================================' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)

print 'Start Date Time: '
print SYSDATETIME()
print ' '
    declare @recDateCount int 
	declare @priorTableCount int
    declare @toLoadCount int      -- Used for # of rows to load in staging xxTable
    declare @loadedCount int      -- Used for xxTable rows loaded into target
    declare @ignoredCount int     -- Used for ignored xxTable rows added to Holding yyTable
    declare @ignoredCoun2 int     -- Used for ignored xxTable rows for missing AgreementDate
    declare @afterLoadCount int   -- Used for target table count 

-- check for rows to process
    select @toLoadCount = count(*) from xxTelework 

	if  @toLoadCount > 0 
		Begin


print 'Step 1 Before loading Telework from xxTelework staging table'

    select @priorTableCount = count(*) from Telework 


print '       # of rows in Telework              ' + cast(@priorTableCount as char) 
print '       # of rows to load from xxTelework  ' + cast(@toLoadCount as char) 
print '       Telework + xx Tables               ' + cast(@priorTableCount+@toLoadCount as char) 

print ''
print 'Deleting existing rows from Telework prior to loading latest dataset'
DELETE FROM Telework


print 'Step 2 Loading Telework records from xxTelework staging table'


	insert into telework(
		PersonID
		,TeleworkElgible
		,InElgibleReason
		,AgreementDate
		,EmpStatus

		--new columns for Task 9:
		,TeleworkStatus

		,[DataSource]
		,[SystemSource]
		,[AsOfDate]

	)

	select distinct
		p.PersonID
		,x.[ELIG] 
		,x.[no reason] 
		,x.[Date] 
		,x.[Emp Status]

		--new columns for Task 9:
		,x.[Telework Status]

		,''
		,''
		,SYSDATETIME()

	from xxTelework x
	join Person p on
		ltrim(rtrim(x.[Emp email])) = p.emailAddress
    where not exists 
	(
	select 1 from telework tel
	where tel.PersonID =p.PersonID 
		and tel.AgreementDate = x.[Date]
	)

    select @loadedCount = @@rowcount

    select @afterLoadCount = count(*) from Telework      
       
print '       # of rows loaded from xxTelework       ' + cast(@loadedCount as char) 
print '       Telework + xxTelework loaded              ' + cast(@afterLoadCount as char) 
print '       # of xxTelework Rows ignored            ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 
 
/* 
New employees' records will be written into yy tables. (if Emails are not in Person)
*/
print 'Step 3  Inserting into yy table for missing people'

INSERT INTO yyTelework  -- Needs case statement due to multiple reasons
        ([PersonID]                         -- 0 Always null -- Included in table for manual matching to an existing person 
        ,[Emp Status]                       -- 1
        ,[Emp Last Name]                    -- 2
        ,[Emp First Name]                   -- 3
        ,[Telework Status]                  -- 4
        ,[Date]                             -- 5
        ,[Reg/Svc]                          -- 6
        ,[Current Reg/Svc]                  -- 7
        ,[Corr Symbol]                      -- 8
        ,[Current Corr Symbol]              -- 9
        ,[Official Worksite]                -- 10
        ,[Emp Phone]                        -- 11
        ,[Emp Email]                        -- 12
        ,[Emp Cell]                         -- 13
        ,[Sup]                              -- 14
        ,[Sup phone]                        -- 15
        ,[Sup email]                        -- 16
        ,[Sup cell]                         -- 17
        ,[TW Coord]                         -- 18
        ,[Elig]                             -- 19
        ,[no reason]                        -- 20
        ,[Completed Training]               -- 21
        ,[Decline]                          -- 22
        ,[Sched]                            -- 23
        ,[Report to Office - Acknowledge]   -- 24
        ,[Report to Office - Hours Notice]  -- 25
        ,[Alt Ofc]                          -- 26
        ,[IT]                               -- 27
        ,[Emp Cert]                         -- 28
        ,[Temp Inelig]                      -- 29
        ,[Reason]                           -- 30
        ,[Plan]                             -- 31
        ,[Perm Inelig]                      -- 32
        ,[Sup Cert]                         -- 33
        ,[Sup Comments]                     -- 34
        ,[F36]                              -- 35
        ,[FailureReason]                    -- 36 --future add case statements if other reasons
        ,[LoadFileName]                     -- 37
        ,[FailureDateTime]                  -- 38
        ,[ProcessedDate]                    -- 39
        ,[ProcessingNotes]                  -- 40

        )
 
    select  distinct						-- 1816 distinct emails 
        null AS PersonID					-- 0 Always null -- Included in table for manual matching to an existing person 
        ,[Emp Status]                       -- 1
        ,[Emp Last Name]                    -- 2
        ,[Emp First Name]                   -- 3
        ,[Telework Status]                  -- 4
        ,[Date]                             -- 5
        ,[Reg/Svc]                          -- 6
        ,[Current Reg/Svc]                  -- 7
        ,[Corr Symbol]                      -- 8
        ,[Current Corr Symbol]              -- 9
        ,[Official Worksite]                -- 10
        ,[Emp Phone]                        -- 11
        ,[Emp Email]                        -- 12
        ,[Emp Cell]                         -- 13
        ,[Sup]                              -- 14
        ,[Sup phone]                        -- 15
        ,[Sup email]                        -- 16
        ,[Sup cell]                         -- 17
        ,[TW Coord]                         -- 18
        ,[Elig]                             -- 19
        ,[no reason]                        -- 20
        ,[Completed Training]               -- 21
        ,[Decline]                          -- 22
        ,[Sched]                            -- 23
        ,[Report to Office - Acknowledge]   -- 24
        ,[Report to Office - Hours Notice]  -- 25
        ,[Alt Ofc]                          -- 26
        ,[IT]                               -- 27
        ,[Emp Cert]                         -- 28
        ,[Temp Inelig]                      -- 29
        ,[Reason]                           -- 30
        ,[Plan]                             -- 31
        ,[Perm Inelig]                      -- 32
        ,[Sup Cert]                         -- 33
        ,[Sup Comments]                     -- 34
        ,[F36]                              -- 35
		, 'No Matching Email' as [FailureReason] -- 36
		, '' as [LoadFileName]     -- 37  -- Spreadsheet name (future file name in include in load?)
		, cast(SYSDATETIME() as smallDATEtime) AS FailureDateTime -- 38 
		, null AS [ProcessedDate]  -- 39 -- populated to record when records are processed from yy tables  - should we keep history to track why the people were missing?
		, null AS ProcessingNotes  -- 40 -- Manual entry to track resolution of issue
   
	From xxTelework x
	left outer join Person p on
		ltrim(rtrim(x.[Emp email])) = p.emailAddress
    where p.emailAddress IS NULL 
    
    select @IgnoredCount = @@rowcount

print 'Rows inserted into yy Holding table (for No Matching Person): ' + cast(@IgnoredCount as char)  



--print 'Unaccount ignored rows                                        ' + CAST ((@toLoadCount + @priorTableCount - @afterLoadCount)-@IgnoredCount-@ignoredCoun2 as char) 

--print 'Capturing load information in dbo.LoadLog'

--    INSERT INTO [dbo].[LoadLog]
--           ([ServerName]
--           ,[DBName]
--           ,[SchemaName]
--           ,[LoadFileName]
--           ,[LoadFileType]
--           ,[LoadFileBeginDateTime]
--           ,[LoadFileRowCount]
--           ,[StagingTableName]
--           ,[StagingTableRowsAdded]
--           ,[TargetTableName]
--           ,[TargetTableInitialRowCount]
--           ,[TargetTableRowsAddedViaSP]
--           ,[TargetTableRowsUpdatedViaSP]
--           ,[TargetTableAfterRowCount]
--           ,[StoredProcedureRowsDiscarded]
--           ,[StoredProcedureName]
--           ,[LoadFileEndDateTime]
--           ,[LoadFileNotes])
--     select  
--             (@@SERVERNAME) as [ServerName]
--           , [DBName]
--           ,[SchemaName]
--           ,[LoadFileName]
--           ,[LoadFileType]
--           ,[LoadFileBeginDateTime]
--           ,[LoadFileRowCount]
--           ,[StagingTableName]
--           ,[StagingTableRowsAdded]
--           ,[TargetTableName]
--           ,[TargetTableInitialRowCount]
--           ,[TargetTableRowsAddedViaSP]
--           ,[TargetTableRowsUpdatedViaSP]
--           ,[TargetTableAfterRowCount]
--           ,[StoredProcedureRowsDiscarded]
--           ,[StoredProcedureName]
--           ,[LoadFileEndDateTime]
--           ,[LoadFileNotes])
    
      
--print '       Anticipated # of Rows ignored to load into yyTelework Holding Table  ' + cast(@toLoadCount + @priorTableCount - @afterLoadCount  as char) 
--print '       Rows inserted into yyTelework Holding table (for No Matching Person) ' + cast(@IgnoredCount as char)  
--print ' '
--print 'Load Summary ' 
--print ' '
--print 'Before loading Telework from xxTelework staging table'
--print '       Before # of Telework rows             ' + cast(@priorTableCount as char) 
--print '       # of rows to load from xxTelework    ' + cast(@toLoadCount as char) 
--print '       Telework + xx Table                   ' + cast(@priorTableCount+@toLoadCount as char) 
--print ' '
--print 'After loading Telework from xxTelework staging table'
--print '       # of rows inserted into Telework from xxTelework       ' + ltrim(rtrim(cast(@loadedCount as char)))  
--print '       # of rows from xxTelework ignored                    ' + ltrim(rtrim(cast(@IgnoredCount as char)))  
--print '       Total # of rows processed                           ' + ltrim(rtrim(cast(@loadedCount+@IgnoredCount as char)))  
--print ' '
--print '       After # of Telework rows                            ' + ltrim(rtrim(cast(@afterLoadCount as char)))  
--print '       Ignored # of rows added to yy tables              ' + cast((@priorTableCount+@toLoadCount)-@afterLoadCount as char) 
--print '       ( Before # + ToLoad # ) - (After # + Ignored #) = ' + cast((@priorTableCount+@toLoadCount)-(@afterLoadCount+@IgnoredCount) as char) 
print ' '
print 'Finish Date Time: '
print SYSDATETIME()

		end

	else
		begin
			print 'No rows in xxTelework '+ ltrim(rtrim(cast(@toLoadCount as char))) 
			print ' '
			print 'Load Fail Date Time: '
			print SYSDATETIME()

		end
end


GO
