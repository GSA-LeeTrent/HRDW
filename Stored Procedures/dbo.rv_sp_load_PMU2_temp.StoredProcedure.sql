USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_PMU2_temp]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-04-20  
-- Description: Use actual grade and pay plan in PositionInfo columns 9, 10
--              instead of the Target Pay Plan and Grade.
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-04-27  
-- Description: - Map [Target Pay Plan] and [Target Grade Or Level] from xxPMU
--                to PositionInfo columns
--				- Add LatestSeparationDate to PositionDate table
-- =============================================================================
-- Author:      James McConville
-- Date:        2016-05-16  
-- Description: Add the following new columns
--				-- Financials
--				xxPMU.[Pay Rate Determinant Code]		TO Financials.[PayRateDeterminantCode]
--				xxPMU.[Pay Rate Determinant Description]TO Financials.[PayRateDeterminantDescription]
--				-- PositionInfo
--				xxPMU.[Detail Type]						TO PositionInfo.[DetailType]
--				xxPMU.[Detail Type  Description]		TO PositionInfo.[DetailTypeDescription]
--				-- PositionDate
--				xxPMU.[LWOP NTE]						TO PositionDate.[LWOPNTE]
--				xxPMU.[LWOP NTE Start Date]				TO PositionDate.[LWOPNTEStartDate]
--				xxPMU.[LWP NTE]							TO PositionDate.[LWPNTE]
--				xxPMU.[LWP NTE Start Date]				TO PositionDate.[LWPNTEStartDate]
--				xxPMU.[Sabbatical NTE]					TO PositionDate.[SabbaticalNTE]
--				xxPMU.[Sabbatical NTE Start Date]		TO PositionDate.[SabbaticalNTEStartDate]
--				xxPMU.[Suspension NTE]					TO PositionDate.[SuspensionNTE]
--				xxPMU.[Suspension NTE Start Date]		TO PositionDate.[SuspensionNTEStartDate]
--				xxPMU.[Temp Promotion NTE Date]			TO PositionDate.[TempPromotionNTEDate
--				xxPMU.[Temp Promotion NTE Start Date]	TO PositionDate.[TempPromotionNTEStartDate]
--				xxPMU.[Temp Reassignment NTE Date]		TO PositionDate.[TempReassignmentNTEDate]
--				xxPMU.[Temp Reassign NTE Start Date]	TO PositionDate.[TempReassignNTEStartDate]
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-04-05  
-- Description: Add the following PMU SCD attributes from the xxPMU_SCD table:
--                  [Retirement_SCD]      DATE NULL
--                  [SCD_LengthOfService] DATE NULL
--                  [SCD_RIF]             DATE NULL
--				Note that this data will only exist for PMU data on or after
--              the 04/23/2017 RecordDate.
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-04-26  
-- Description: Add FY Designation to JOIN to xxPMU_SCD for PositionDate Insert.
-- =============================================================================

CREATE procedure [dbo].[rv_sp_load_PMU2_temp]

with execute as owner		
as	

/*
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO
*/

print '=========================================================' 
print 'Inside PMU2, executing... '  
print '=========================================================' + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)

print 'Step 1 Checking existence of xxPMU data to process '  

    declare @RowsToProcess int
	declare @RowsToProcess1 int
    select @RowsToProcess = COUNT (*) from xxPMU     

	if @RowsToProcess = 0
	begin
			print 'No rows in xxPUM '
			print ' '
			print 'Process ends at ' + cast(SYSDATETIME() as char)
			return
	end

    select @RowsToProcess1 = COUNT (*) from xxPMU   

print 'xxPMU records to process '  + cast(@RowsToProcess1 as char)
/* -- temp commented on 2018-04-03
print 'Step 2 Checking if record date exists in Position table'

	declare @RecordDate date
	select top 1 @RecordDate = [Record Date] from xxPMU

	if @recordDate in (select isnull([RecordDate],'') from position)
	begin
		print 'PMU data for this Record Date already loaded '  + cast(@RecordDate as char) + CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10)
		print 'No PMU records loaded'
		return
	end
*/

--check if xxPMU temp columns exist
/*
	--Additional temp columns are needed to compile this PMU2 sp.  
	--Use Master Store Procedure to load data or run the ALTER ADD scripts below.
	--Note tht these temp columns need to be dropped upon finishing.

	alter table xxPMU add pmuID int identity(1,1) 
	alter table xxPMU add PersonID int null
	alter table xxPMU add ChrisPositionID int null 
	alter table xxPMU add ObligatedPositionID int null
	alter table xxPMU add DetailedPositionID int null
	alter table xxPMU add PayID int null
	alter table xxPMU add DutyStationId int null
	alter table xxPMU add FinancialsID int null
	alter table xxPMU add PersonnelOfficeID int null
	alter table xxPMU add PositionDateID int null
	alter table xxPMU add OrganizationID int null
	alter table PositionInfo add pmuID int null
	alter table Pay add pmuID int null
	alter table DutyStation add PmuID int null
	alter table financials add PmuID int null
	alter table PersonnelOffice add PmuID int null
	alter table PositionDate Add PmuID int null

	alter table xxPMU drop column pmuID 
	alter table xxPMU drop column PersonID 
	alter table xxPMU drop column ChrisPositionID 
	alter table xxPMU drop column ObligatedPositionID 
	alter table xxPMU drop column DetailedPositionID 
	alter table xxPMU drop column PayID 
	alter table xxPMU drop column DutyStationId 
	alter table xxPMU drop column FinancialsID 
	alter table xxPMU drop column PersonnelOfficeID 
	alter table xxPMU drop column PositionDateID 
	alter table xxPMU drop column OrganizationID 
	alter table PositionInfo drop column pmuID 
	alter table Pay drop column pmuID 
	alter table DutyStation drop column PmuID 
	alter table financials drop column PmuID 
	alter table PersonnelOffice drop column PmuID 
	alter table PositionDate drop column PmuID 

*/
/* -- temp commented on 2018-04-03
IF NOT EXISTS(
	SELECT 1 FROM sys.columns 
	WHERE 
		(
			(Name = N'pmuID' or Name = N'PersonID' or Name = N'ChrisPositionID' or Name = N'ObligatedPositionID' or Name = N'DetailedPositionID' or Name = N'PayID'
			or Name = N'DutyStationId' or Name = N'FinancialsID' or Name = N'PersonnelOfficeID' or Name = N'PositionDateID' or Name = N'OrganizationID' )
			AND Object_ID = Object_ID(N'xxPMU') 
		)
		or 
		(
			Name = N'pmuID' AND 
			(Object_ID = Object_ID(N'PositionInfo') or Object_ID = Object_ID(N'Pay')  or Object_ID = Object_ID(N'DutyStation') or Object_ID = Object_ID(N'financials') 
			or Object_ID = Object_ID(N'PersonnelOffice') or Object_ID = Object_ID(N'PositionDate') 
			)
		)
	)

BEGIN
    print 'Warning! One of the required temp columns does not exist in xx tables.' + CHAR(13) + CHAR(10)+ CHAR(13) + CHAR(10)
	print 'Please use Master Store Procedure to load data or run the ALTER scripts above.'
	return
END
*/ 

/* -- temp commented on 2018-04-03
print 'Step 3 Creating Temp Table PositionInfoSupervisor'    
	-- if temp table exists, then drop it first before you create it	
	if object_id('tempdb..#PositionInfoSupervisor') is not null
		BEGIN
			drop table #PositionInfoSupervisor
		END
	
	create table #PositionInfoSupervisor(PositionInfoID int, SupSSN varchar(255), TeamLeadSSN varchar(255), OfficeSymbol varchar(64), PositionType varchar(64) )

print 'Temp Table PositionInfoSupervisor Created'
    
print 'Step 4 Creating tempPerson to store employees PeronIDs from current Person table'    
  	-- if temp table exists, then drop it first before you create it
	if object_id('tempdb..#tempPerson') is not null
		BEGIN
			drop table #tempPerson
		END
			
	create table #tempPerson(personID int, SSN varchar(255))

print 'Temp Table tempPerson Created'

print 'Adding rows to tempPerson'

	insert into #tempPerson(personID, SSN)
	select personID, ltrim(rtrim(ssn)) 
	from Person

print 'tempPerson Populated ' + cast(@@rowcount as char)

print 'Step 5 adding new people...'

    declare @DistinctSSN int
    select @DistinctSSN = count(distinct [Social Security]) from xxPMU where [Social Security] is not null

print 'Number of distinct SSNs in xxPMU: ' + cast(@DistinctSSN as char)

	insert into person(ssn)
	select distinct ltrim(rtrim([Social Security]))  
	from xxPMU x 
	left outer join #tempPerson p 
		on p.SSN=x.[Social Security] 
		and x.[Social Security] is not null
	where p.personID is null 
		and x.[Social Security] is not null

print 'New Person records added ' + cast(@@rowcount as char)

   declare @DistinctPerson int
   select @DistinctPerson = count(distinct [SSN]) from Person where SSN is not null

print 'After new persons added, the new number of distinct people in Person is ' + cast(@DistinctPerson as char)

print 'Step 6 Remove tempPerson '
	
	truncate table #tempPerson

print 'Step 6  tempPerson removed '

print 'Step 7 Repopulate tempPerson from updated person table '

	insert into #tempPerson(personID, SSN) 
	select personID, ltrim(rtrim(ssn)) 
	from Person

print 'tempPerson Repopulated rows ' + cast(@@rowcount as char)

print 'Step 8 updating PersonID in xxPMU '
	update xxPMU
	set PersonID =p.PersonID
	from xxPMU x 
	join #tempPerson p 
		on ltrim(rtrim(x.[Social Security]))=p.SSN
	where x.[Social Security] is not null

print 'xxPMU personID updated ' + cast(@@rowcount as char)

/*
-- 22 people (22 SSNs) have two rows in xxPMU table with different Employee Numbers

select [Social Security], count(  [Social Security]) 
from xxPMU
group by [Social Security]
having count(  [Social Security]) > 1

*/

print 'Step 9 Updating Person table with the latest data from xxPMU '

   declare @PersonUpdated2 int
   select @PersonUpdated2 = count(distinct [SSN]) from Person where SSN is not null

print 'before the update, number of rows in Person is ' + cast(@PersonUpdated2 as char) 
	
	Update Person 
		set
			EmployeeNumber = x.[Employee Number]  
			,EmailAddress =	x.[Email Address] 
			,LastName = x.[Last Name]   
			,FirstName = x.[First Name] 
			,MiddleName = x.[Middle Name]
		--	,FullName = x.[Full Name] 
			,BirthDate = x.[Birth Date]
			,VeteransStatusDescription = x.[Veterans Status Description]
			,VeteransPreferenceDescription = x.[Veterans Preference Description]
			,GenderDescription = x.[Gender Description]
			,HandicapCode = x.[Handicap Code]  
			,HandicapCodeDescription = x.[Handicap Code Description]
			,CitizenshipCode = x.[Citizenship Code]
			,CitizenshipDescription	= x.[Citizenship Description]
			,RNOCode = x.[RNO Code]
			,RNODescription = x.[RNO Description]
			,AcademicInstitutionCode = x.[Academic Institution Code] 
			,AcademicInstitutionDesc = x.[Academic Institution Description] 
			,CollegeMajorMinorCode = x.[College-Major-Minor Code] 
			,CollegeMajorMinorDesc = x.[College-Major-Minor Description] 
			,EducationLevelCode = x.[Educational Level Code] 
			,EducationLevelDesc = x.[Educational Level Desc] 
			,InstructionalProgramCode =	x.[Instructional Program Code] 
			,InstructionalProgramDesc =	x.[Instructional Program Description] 
			,DegreeObtained = x.[Year Degree Cert Attained]
			,AnnuitantIndicatorDescription = x.[Annuitant Indicator Description]		
			,AnnuitantIndicatorCode = x.[Annuitant Indicator Code]						
			,ReserveCategoryCode = x.[Reserve Category Code]							
			,ReserveCategoryDescription = x.[Reserve Category Description]				
			,RetirementPlanCode = x.[Retirement Plan Code]								
			,RetirementPlanDescription = x.[Retirement Plan Description]				
			,CreditableMilitaryService = x.[Creditable Military Service]						
			,[IsPathways] = x.[Pathways(Y/N)]
			,[DataSource] = ''														-- future improvement: Source Data File, e.g. 'PMU(POSN_MGMT_UNI)-PRIMARY-RIVIDIUM - 2515956'
			,[SystemSource] = ''													-- future improvement: Source System, e.g. 'CHRIS BI'
			,[AsOfDate] = SYSDATETIME()
		
		from Person P
		join xxPMU x 
			on p.PersonID = x.PersonID

			-- if an employee has two records in the same PMU Extract due to different employee numbers of the same SSN, 
			-- make sure only the record with the larger Emp# gets updated.
			and x.[Employee Number] =				
			(
			select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
			where x1.PersonID = x.PersonID
			)

		print 'Person records updated ' + cast(@@rowcount as char)

-- Note that 22 people have two rows in xxPMU (same SSN different Employee Numbers), we only got the latest record updated in Person table using the above script

print 'Step 10-1 inserting PositionInfo table for CHRIS position '

   declare @PositionInfoRegular int
   select @PositionInfoRegular = count(*) from PositionInfo 

print 'before inserting positions, number of rows in PositionInfo is ' + cast(@PositionInfoRegular as char) 

-- Every position record gets inserted into PositionInfo table, including Obligated and Detailed positions 

	insert into PositionInfo(
		PositionControlNumber               --1
		,PositionInformationPD              --2
		,PositionTitle                      --3
		,PositionSeries                     --4
		,PositionSeriesDesc                 --5
		,PositionControlIndicator           --6
		,PositionSequenceNumber             --7
		,PositionEncumberedType             --8
		,PayPlan                            --9
		,Grade                              --10
		,Step                               --11
		,SupervisoryStatusCode              --12
		,SupervisoryStatusDesc              --13
		,PositionSensitivity                --14
		,FundingStatus                      --15
		,FundingStatusDescription           --15.1	add this Desc as new column, then copy current FundingStatus to FundingStatusDesc, and then put null values to FundingStatus column  
		,OccupationalCategoryCode           --16
		,OccupationalCategoryDescription    --17 

		--new columns for Task 9:
		,OccupationalSeriesCode
		,OccupationalSeriesDescription

		,OfficeSymbol                       --18
	    ,[SupvMgrProbationRequirementCode]	--19	
        ,[SupvMgrProbationRequirementDesc]	--20
		,[DataSource]
		,[SystemSource]
		,[AsOfDate]
		,pmuID                              --21
		,TargetPayPlan						--22	-- JJM 2016-04-27 Added
		,TargetGradeOrLevel					--23	-- JJM 2016-04-27 Added
    	,[DetailType]						--24	-- JJM 2016-05-16 Added
	    ,[DetailTypeDescription]			--25	-- JJM 2016-05-16 Added

	)
	select 
		 [CHRIS Position Information#Position Control Number]			--1 Keep all null values as null, need to remove all isNull() after changes are stablized
		,[CHRIS Position Information#PD Number]                         --2
		,[CHRIS Position Information#Position Title]                    --3
		,[CHRIS Position Information#Occupational Series Code]          --4
		,[CHRIS Position Information#Occupational Series Description]   --5
		,[CHRIS Position Information#Position Control Number Indicator] --6
		,[CHRIS Position Information#Position Sequence Number]			--7
		,[CHRIS Position Information#Position Encumbered Type]			--8
/* JJM 2016-04-20 Replace Target with actual Pay Plan and Grade
		,[Target Pay Plan]                                              --9	
		,[Target Grade Or Level]                                        --10 */
		,LEFT([PP-Series-Grade],2)                                      --9	
		,[CHRIS Position Information#Valid Grade Or Level]              --10
		,[Step Or Rate]                                                 --11
		,[CHRIS Position Information#Supervisory Status Code]           --12 
		,[CHRIS Position Information#Supervisory Status Description]    --13
		,[CHRIS Position Information#Position Sensitivity Description]  --14
		,[CHRIS Position WMT Information#Funding Status]                --15  
		,[CHRIS Position WMT Information#Funding Status Description]    --15.1
		,[CHRIS Position Information#Occupational Category Code]        --16
		,[CHRIS Position Information#Occupational Category Description] --17

		--new columns for Task 9:
		,[CHRIS Position Information#Occupational Series Code]
		,[CHRIS Position Information#Occupational Series Description]


		,[CHRIS Position Information#Office Symbol]                     --18          
		,[Supv/Mgr Probation Requirement Code]							--19		
		,[Supv/Mgr Probation Requirement Desc]							--20
		,''
		,''
		,SYSDATETIME()
		,[pmuID]                                                        --21  
		,[Target Pay Plan]												--22	-- JJM 2016-04-27 Added
		,[Target Grade Or Level]										--23	-- JJM 2016-04-27 Added
	    ,[Detail Type]													--24	-- JJM 2016-05-16 Added
	    ,[Detail Type  Description]										--25	-- JJM 2016-05-16 Added

	from xxPMU x

	-- when an employee has two Emp#s with the same SSN, make sure only the record with the larger Emp# gets inserted into PositionInfo table
	where x.[Employee Number] =	
				(
				select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
				where x1.PersonID = x.PersonID
				)
		or x.[Employee Number] is null

	print 'Positions inserted ' + cast(@@rowcount as char)

	-- Every position gets a positionInfoID in xxPMU
	update xxPMU
	set ChrisPositionID =p.PositionInfoID
	from xxPMU x 
	join PositionInfo p 
		on x.pmuID=p.PmuID  -- Note x.pmuID provided by identity column

*/    
print 'xxPMU updated for ChrisPositionIDs ' + cast(@@rowcount as char)

	update PositionInfo set pmuID =null

print 'Update PositionInfo to set temp processing field to null ' + cast(@@rowcount as char)

   declare @PositionInfoObligated int
   select @PositionInfoObligated = 
		(select count( [CHRIS Obligated Position#Position Control Number]) from xxPMU
		where [CHRIS Obligated Position#Position Control Number] is not null)
   
print 'before inserting, number of distinct Obligated Positions in xxPMU is ' + cast(@PositionInfoObligated as char) 

print 'Step 10-2 inserting into PositionInfo table for obligated positions '

	insert into PositionInfo(
		PositionControlNumber               --1
		,PositionInformationPD              --2
		,PositionTitle                      --3
		,PositionSeries                     --4
		,PositionSeriesDesc                 --5
		,PositionControlIndicator           --6
		,PositionSequenceNumber             --7
		,PositionEncumberedType             --8
		,PayPlan                            --9
		,Grade                              --10
		,Step                               --11
		,SupervisoryStatusCode              --12
		,SupervisoryStatusDesc              --13
		,PositionSensitivity                --14
		,FundingStatus                      --15
		,FundingStatusDescription           --15.1
		,OccupationalCategoryCode           --16
		,OccupationalCategoryDescription    --17 

		--new columns for Task 9:
		,OccupationalSeriesCode
		,OccupationalSeriesDescription

		,OfficeSymbol                       --18
	    ,[SupvMgrProbationRequirementCode]	--19	
        ,[SupvMgrProbationRequirementDesc]	--20
		,[DataSource]
		,[SystemSource]
		,[AsOfDate]
		,pmuID                              --21
		,TargetPayPlan						--22	-- JJM 2016-04-27 Added
		,TargetGradeOrLevel					--23	-- JJM 2016-04-27 Added
    	,[DetailType]						--24	-- JJM 2016-05-16 Added
	    ,[DetailTypeDescription]			--25	-- JJM 2016-05-16 Added
	)
	select 
		[CHRIS Obligated Position#Position Control Number]					--1
		,[CHRIS Obligated Position#PD Number]								--2 
		,[CHRIS Obligated Position#Position Title]							--3
		,[CHRIS Obligated Position#Occupational Series Code]				--4
		,[CHRIS Obligated Position#Occupational Series Description]			--5
		,[CHRIS Obligated Position#Position Control Number Indicator]		--6
		,[CHRIS Obligated Position#Position Sequence Number]				--7
		,[CHRIS Obligated Position#Encumbered Type]							--8	  field supplied on 2/22 load
		,[CHRIS Obligated Position#Valid Pay Plan]							--9
		,[CHRIS Obligated Position#Valid Grade Or Level]					--10
		,[Step Or Rate]														--11
		,[CHRIS Obligated Position#Supervisory Status Code]					--12  field supplied on 2/22 load
		,[CHRIS Obligated Position#Supervisory Status Description]			--13
		,[CHRIS Obligated Position#Position Sensitivity Description]		--14
		,[CHRIS Obligated Position WMT Information#Funding Status]			--15  field supplied on 2/22 load			
        ,[CHRIS Obligated Position WMT Information#Funding Status Descript]	--15.1 
        ,[CHRIS Obligated Position#Occupational Category Code]				--16  filed supplied on 2/22 load
        ,[CHRIS Obligated Position#Occupational Category Description]		--17  filed supplied on 2/22 load 

		--new columns for Task 9:
		,[CHRIS Obligated Position#Occupational Series Code]
		,[CHRIS Obligated Position#Occupational Series Description]

		,[CHRIS Obligated Position#Office Symbol]                           --18
		,[Supv/Mgr Probation Requirement Code]								--19		
		,[Supv/Mgr Probation Requirement Desc]								--20
		,''
		,''
		,SYSDATETIME()
		,[pmuID]                                                            --21 
		,[Target Pay Plan]													--22	-- JJM 2016-04-27 Added
		,[Target Grade Or Level]											--23	-- JJM 2016-04-27 Added
	    ,[Detail Type]														--24	-- JJM 2016-05-16 Added
	    ,[Detail Type  Description]											--25	-- JJM 2016-05-16 Added

	from xxPMU x
	where [CHRIS Obligated Position#Position Control Number] is not null

		-- when an employee has two Emp#s with the same SSN, make sure only the record with the larger Emp# gets inserted into PositionInfo table
		and (x.[Employee Number] =	
					(
					select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
					where x1.PersonID = x.PersonID
					)
			or x.[Employee Number] is null)

print 'Obligated Positions inserted ' + cast(@@rowcount as char)

	update xxPMU
	set ObligatedPositionID =p.PositionInfoID
	from xxPMU x 
	join PositionInfo p 
		on x.pmuID=p.PmuID

print 'xxPMU updated for ObligatedPositionIDs ' + cast(@@rowcount as char)
    
	update PositionInfo set pmuID =null

print 'Update PositionInfo to set temp processing field to null ' + cast(@@rowcount as char)

   declare @PositionInfoDetailed int
   select @PositionInfoDetailed = 
		(select count( [CHRIS Detailed Position#Position Control Number]) from xxPMU
		where [CHRIS Detailed Position#Position Control Number] is not null)
   
print 'before inserting, number of distinct Detailed Positions in xxPMU is ' + cast(@PositionInfoDetailed as char) 

print 'Step 10-3 inserting PositionInfo table for detailed positions '

	insert into PositionInfo(
		PositionControlNumber               --1
		,PositionInformationPD              --2
		,PositionTitle                      --3
		,PositionSeries                     --4
		,PositionSeriesDesc                 --5
		,PositionControlIndicator           --6
		,PositionSequenceNumber             --7
		,PositionEncumberedType             --8
		,PayPlan                            --9
		,Grade                              --10
		,Step                               --11
		,SupervisoryStatusCode              --12
		,SupervisoryStatusDesc              --13
		,PositionSensitivity                --14
		,FundingStatus                      --15
		,FundingStatusDescription           --15.1
		,OccupationalCategoryCode           --16
		,OccupationalCategoryDescription    --17 

		--new columns for Task 9:
		,OccupationalSeriesCode
		,OccupationalSeriesDescription

		,OfficeSymbol                       --18
	    ,[SupvMgrProbationRequirementCode]	--19	
        ,[SupvMgrProbationRequirementDesc]	--20
		,[DataSource]
		,[SystemSource]
		,[AsOfDate]
		,pmuID                              --21
		,TargetPayPlan						--22	-- JJM 2016-04-27 Added
		,TargetGradeOrLevel					--23	-- JJM 2016-04-27 Added
    	,[DetailType]						--24	-- JJM 2016-05-16 Added
	    ,[DetailTypeDescription]			--25	-- JJM 2016-05-16 Added
	)
	select 
		[CHRIS Detailed Position#Position Control Number]					--1
		,[CHRIS Detailed Position#PD Number]								--2
		,[CHRIS Detailed Position#Position Title]							--3
		,[CHRIS Detailed Position#Occupational Series Code]					--4
		,[CHRIS Detailed Position#Occupational Series Description]			--5
		,[CHRIS Detailed Position#Position Control Number Indicator]		--6
		,[CHRIS Detailed Position#Position Sequence Number]					--7
		,[CHRIS Detailed Position#Position Encumbered Type]					--8  field supplied on 2/22 load
		,[CHRIS Detailed Position#Valid Pay Plan]							--9  
		,[CHRIS Detailed Position#Valid Grade Or Level]						--10  
		,[Step Or Rate]														--11	
		,[CHRIS Detailed Position#Supervisory Status Code]					--12  field supplied on 2/22 load
		,[CHRIS Detailed Position#Supervisory Status Description]			--13
		,[CHRIS Detailed Position#Position Sensitivity Description]			--14
		,[CHRIS Detailed Position WMT Information#Funding Status]			--15  field supplied on 2/22 load
		,[CHRIS Detailed Position WMT Information#Funding Status Descript1]	--15.1
		,[CHRIS Detailed Position#Occupational Category Code]				--16  field supplied on 2/22 load
		,[CHRIS Detailed Position#Occupational Category Description]		--17  field supplied on 2/22 load

		--new columns for Task 9:
		,[CHRIS Detailed Position#Occupational Series Code]
		,[CHRIS Detailed Position#Occupational Series Description]

		,[CHRIS Detailed Position#Office Symbol]							--18
		,[Supv/Mgr Probation Requirement Code]								--19		
		,[Supv/Mgr Probation Requirement Desc]								--20
		,''
		,''
		,SYSDATETIME()
		,[pmuID]															--21 
		,[Target Pay Plan]													--22	-- JJM 2016-04-27 Added
		,[Target Grade Or Level]											--23	-- JJM 2016-04-27 Added
	    ,[Detail Type]														--24	-- JJM 2016-05-16 Added
	    ,[Detail Type  Description]											--25	-- JJM 2016-05-16 Added

	from xxPMU x
	where 	[CHRIS Detailed Position#Position Control Number] is not null
		
		-- when an employee has two Emp#s with the same SSN, make sure only the record with the larger Emp# gets inserted into PositionInfo table
		and (x.[Employee Number] =	
					(
					select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
					where x1.PersonID = x.PersonID
					)
			or x.[Employee Number] is null)

print 'Detailed Positions inserted ' + cast(@@rowcount as char)

	update xxPMU
	set DetailedPositionID =p.PositionInfoID
	from xxPMU x 
	join PositionInfo p 
		on x.pmuID=p.PmuID  -- Note x.pmuID provided by identity column

print 'xxPMU updated for DetailedPositionIDs ' + cast(@@rowcount as char)

	update PositionInfo set pmuID= null

print 'Update PositionInfo to set temp processing field to null ' + cast(@@rowcount as char)

--Supervisor Load Setup		
print 'Step 11 inserting position supervisors info to Temp table... '

	-- For Chris Positions: everybody
	insert into #PositionInfoSupervisor( 
		PositionInfoID
		,SupSSN
		,TeamLeadSSN
		,OfficeSymbol
		,PositionType
		)
	select 
		ChrisPositionID
		,[Position Reporting To Information#Supervisor Social Security Num]			
		,[Position Reporting To Information#Team Lead Social Security Numb]
		,[CHRIS Position Information#Office Symbol]		
		,'Position'
    from xxPMU x
	
	-- when an employee has two Emp#s with the same SSN, make sure only the record with the larger Emp# gets inserted into PositionInfo table for supervisor/team lead IDs
	where x.[Employee Number] =	
					(
					select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
					where x1.PersonID = x.PersonID
					)
			or x.[Employee Number] is null

print 'Position supervisor loaded into temp table ' + cast(@@rowcount as char)

	-- For Obligated Positions: only people whoes ObligatedPositionID is populated
	insert into #PositionInfoSupervisor( 
		PositionInfoID
		,SupSSN
		,TeamLeadSSN
		,OfficeSymbol
		,PositionType
	)
	select 
		ObligatedPositionID
		,[Obligated Position Reporting To Information#Supervisor Social Se]				--field supplied on 2/22 load	
		,[Obligated Position Reporting To Information#Team Lead Social Sec]
		,[CHRIS Obligated Position#Office Symbol]	
		,'Obligated'
    from xxPMU x

	-- when an employee has two Emp#s with the same SSN, make sure only the record with the larger Emp# gets inserted into PositionInfo table for supervisor/team lead IDs
	where x.[Employee Number] =	
					(
					select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
					where x1.PersonID = x.PersonID
					)
			or x.[Employee Number] is null

print 'Obligated position supervisor loaded into temp table ' + cast(@@rowcount as char)

	insert into #PositionInfoSupervisor( 
		PositionInfoID
		,SupSSN
		,TeamLeadSSN
		,OfficeSymbol
		,PositionType
		)
	select 
		DetailedPositionID
		,[Detailed Position Reporting To Information#Supervisor Social Sec]				--field supplied on 2/22 load
		,[Detailed Position Reporting To Information#Team Lead Social Secu]
		,[CHRIS Detailed Position#Office Symbol]	
		,'Detailed'
    from xxPMU x

	-- when an employee has two Emp#s with the same SSN, make sure only the record with the larger Emp# gets inserted into PositionInfo table for supervisor/team lead IDs
	where x.[Employee Number] =	
					(
					select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
					where x1.PersonID = x.PersonID
					)
			or x.[Employee Number] is null

print 'Detailed position supervisor loaded into temp table ' + cast(@@rowcount as char)

print 'Step 12 inserting pay data into Pay table... '

   declare @PayData int
   select @PayData = count(*) from Pay 

print 'before the insert, number of rows in Pay is ' + cast(@PayData as char) 

	insert into Pay(BasicSalary,AdjustedBasic,TotalPay,HourlyPay,DataSource,SystemSource,AsOfDate,PMUID)
	select 
		[Basic Salary Rate]
		,[Adjusted Basic Pay]
		,[Total Pay]
		,cast([Per- Hour(Total Salary_Total Pay)] as money)
		,''
		,''
		,SYSDATETIME()
		,pmuID
	from xxPMU x

	-- when an employee has two Emp#s with the same SSN, make sure only the record with the larger Emp# gets inserted into Pay table
	where x.[Employee Number] =	
					(
					select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
					where x1.PersonID = x.PersonID
					)
			or x.[Employee Number] is null
			    
print 'Pay data inserted ' + cast(@@rowcount as char) + 'Anticipated total # of rows ' +  cast(@PayData + @@rowcount as char) 

   declare @PayData2 int
   select @PayData2 = count(*) from Pay 

print 'after the insert, number of rows in Pay is ' + cast(@PayData2 as char) 

	update xxPMU  
	set PayID = p.PayID
	from xxPMU x 
	join Pay p 
		on x.pmuID=p.PmuID

print 'xxPMU updated for PayIDs ' + cast(@@rowcount as char)

print 'Step 13 inserting Duty Station data into DutyStation table... '

   declare @DutyStation int
   select @DutyStation = count(*) from DutyStation 

print 'before the insert, number of rows in DutyStation is ' + cast(@DutyStation as char) 

	insert into DutyStation(
		DutyStationCode
		, DutyStationName
		, DutyStationState
		, DutyStationCounty
		, Zip
		, region
		,[DataSource]
		,[SystemSource]
		,[AsOfDate]
		, PmuID)
	select 
		[Duty Station Code]
		,[CHRIS Position Information#Duty Station Name]
		,[Duty Station State Or Country]
		,[CHRIS Position Information#Duty Station County Name]
		,''
		,[Region(Duty Station)]
		,''
		,''
		,SYSDATETIME()
		,PMUID
	from xxPMU x

	-- when an employee has two Emp#s with the same SSN, make sure only the record with the larger Emp# gets inserted into DutyStation table
	where x.[Employee Number] =	
					(
					select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
					where x1.PersonID = x.PersonID
					)
			or x.[Employee Number] is null

print 'Duty Station data inserted ' + cast(@@rowcount as char) + 'Anticipated total # of rows ' +  cast(@DutyStation + @@rowcount as char)   

    declare @DutyStation2 int
    select @DutyStation2 = count(*) from DutyStation 

print 'after the insert, number of rows in DutyStation is ' + cast(@DutyStation2 as char) 

	update xxPMU
	set DutyStationID  =p.DutyStationID
	from xxPMU x 
	join DutyStation p 
		on x.pmuID=p.PmuID
    
print 'xxPMU updated for DutyStationID ' + cast(@@rowcount as char)

print 'Step 14 Inserting data into Financials table... '

   declare @Financials int
   select @Financials = count(*) from Financials 

print 'before the insert, number of rows in Financials is ' + cast(@Financials as char) 

	insert into Financials(
	AppointmentAuthCode
	,AppointmentAuthDesc 
	,AppointmentAuthCode2 
	,AppointmentAuthDesc2 
	,AppointmentType
	,EmploymentType 
	,FundingBackFill 
	,FundingBackFIllDesc 
	,FundingFUllTimeEqulvalent 
	,AppropriationCode 

	--new columns for Task 9:
    ,[OrgCodeBudgetFinance]
    ,[FundCode]
    ,[BudgetActivity]
    ,[CostElement]
    ,[ObjectClass]
    ,[ORG_BA_FC]
    ,[RR_ORG_BA_FC]

	,BlockNumberCode 
	,BlockNumberDesc  
	,FinancialStatementCode  
	,FinancialStatementDesc
	,[DataSource]
	,[SystemSource]
	,[AsOfDate]
	,pmuID
    ,[PayRateDeterminantCode]							-- JJM 2016-05-16 Added
	,[PayRateDeterminantDescription]					-- JJM 2016-05-16 Added
	)

	select 
	[Current Appointment Auth (1) Code]
	,[Current Appointment Auth (1) Desc]
	,[Current Appointment Auth (2) Code] 
	,[Current Appointment Auth (2) Desc] 
	,[Appointment Type Description]
	,[Type of Employment Description]
	,[Funding Back Fill]
	,[Funding Back Fill Description]
	,[Funding Full Time Equivalent]
	,[Appropriation Code 1]

	--new columns for Task 9:
    ,[Organization Code(Budget Finance)]
    ,[Fund Code]
    ,[Budget Activity]
    ,[Cost Element]
    ,[Object Class]
    ,[ORG/BA/FC]
    ,[RR/ORG/BA/FC]

	,[Block Number Code]
	,[Block Number Description]
	,[Financial Statement Code]
	,[Financial Statement Description]
	,''
	,''
	,SYSDATETIME()
	,PMUID
    ,[Pay Rate Determinant Code]							-- JJM 2016-05-16 Added
	,[Pay Rate Determinant Description]						-- JJM 2016-05-16 Added

	from xxPMU x

	-- when an employee has two Emp#s with the same SSN, make sure only the record with the larger Emp# gets inserted into Financials table for supervisor/team lead IDs
	where x.[Employee Number] =	
					(
					select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
					where x1.PersonID = x.PersonID
					)
			or x.[Employee Number] is null

print 'Financials data inserted ' + cast(@@rowcount as char) + 'Anticipated total # of rows ' +  cast(@Financials + @@rowcount as char)   

    declare @Financials2 int
    select @Financials2 = count(*) from Financials 

print 'after the insert, number of rows in Financials is ' + cast(@Financials2 as char) 

	update xxPMU
	set FinancialsID  =p.FinancialsID
	from xxPMU x 
	join Financials p 
		on x.pmuID=p.PmuID

print 'xxPMU updated for FinancialsID ' + cast(@@rowcount as char)

print 'Step 15 Inserting data into PersonnelOffice table... '

   declare @PersonnelOffice int
   select @PersonnelOffice = count(*) from PersonnelOffice 

print 'before the insert, number of rows in PersonnelOffice is ' + cast(@PersonnelOffice as char) 

	insert into PersonnelOffice(
		OwningRegion 
		,ServicingRegion
		,PersonnelOfficeDescription
		,[DataSource]
		,[SystemSource]
		,[AsOfDate]
		,PmuID
		)
	select
		[Owning Region]
		,[Servicing Region]
		,[Personnel Office ID Description]
		,''
		,''
		,SYSDATETIME()
		,PMUID

	from xxPMU x

	-- when an employee has two Emp#s with the same SSN, make sure only the record with the larger Emp# gets inserted into PersonnelOffice table for supervisor/team lead IDs
	where x.[Employee Number] =	
					(
					select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
					where x1.PersonID = x.PersonID
					)
			or x.[Employee Number] is null

print 'PersonnelOffice data inserted ' + cast(@@rowcount as char) + 'Anticipated total # of rows ' +  cast(@PersonnelOffice + @@rowcount as char)   

    declare @PersonnelOffice2 int
    select @PersonnelOffice2 = count(*) from PersonnelOffice 

print 'after the insert, number of rows in PersonnelOffice is ' + cast(@PersonnelOffice2 as char) 

	update xxPMU
	set PersonnelOfficeID  =p.PersonnelOfficeID
	from xxPMU x 
	join PersonnelOffice p 
		on x.pmuID=p.PmuID

print 'xxPMU updated for PersonnelOfficeID ' + cast(@@rowcount as char)

print 'Step 16 Inserting data into PositionDate table... '

   declare @PositionDate int
   select @PositionDate = count(*) from PositionDate 

print 'before the insert, number of rows in PositionDate is ' + cast(@PositionDate as char) 

	insert into PositionDate(	
		--RecordDate				-- consider to drop this column from Create Table statement
		LatestHireDate              -- 1
		,DateLastPromotion          -- 2
		,DateProbTrialPeriodBegins  -- 3
		,DateProbTrialPeriodEnds    -- 4
		,DateConversionCareerDue    -- 5
		,DateConversionCareerBegins -- 6
		,WGIDateDue                 -- 7
		,DateVRAConversionDue       -- 8
		,DetailNTEStartDate         -- 9
		,DateofSESAppointment          --10
		,WGILastEquivalentIncreaseDate --11
		,SCDCivilian                   --12
		,SCDLeave                      --13
		,ComputeEarlyRetirment         --14
		,ComputeOptionalRetirement     --15
		,ArrivedPersonnelOffice        --16
		,ArrivedPresentGrade           --17
		,ArrivedPresentPosition        --18
		,PayPeriodEndDate              --19
		,Serv05Date                    --20
		,Serv10Date                    --21
		,Serv15Date                    --22
		,Serv20Date                    --23
		,Serv25Date                    --24
		,Serv30Date                    --25
		,Serv35Date                    --26
		,Serv40Date                    --27
		,Serv45Date                    --28
		,Serv50Date                    --29
		,DateSESProbExpires			   --30			--field added for 2/22 load
		,[DateSpvrMgrProbEnds]		   --31	
		,[DataSource]
		,[SystemSource]
		,[AsOfDate]
		,pmuID                         --32
		,LatestSeparationDate	       --33			-- JJM 2016-04-27 Added per new column in xxPMU
		,[LWOPNTE]				       --34			-- JJM 2016-05-16 Added per new column in xxPMU
		,[LWOPNTEStartDate]		       --35			-- JJM 2016-05-16 Added per new column in xxPMU
		,[LWPNTE]					   --36			-- JJM 2016-05-16 Added per new column in xxPMU
		,[LWPNTEStartDate]		       --37			-- JJM 2016-05-16 Added per new column in xxPMU
		,[SabbaticalNTE]		       --38			-- JJM 2016-05-16 Added per new column in xxPMU
		,[SabbaticalNTEStartDate]      --39			-- JJM 2016-05-16 Added per new column in xxPMU
		,[SuspensionNTE]		       --40			-- JJM 2016-05-16 Added per new column in xxPMU
		,[SuspensionNTEStartDate]      --41			-- JJM 2016-05-16 Added per new column in xxPMU
		,[TempPromotionNTEDate]	       --42			-- JJM 2016-05-16 Added per new column in xxPMU
		,[TempPromotionNTEStartDate]   --43			-- JJM 2016-05-16 Added per new column in xxPMU
		,[TempReassignmentNTEDate]     --44			-- JJM 2016-05-16 Added per new column in xxPMU
		,[TempReassignNTEStartDate]    --45			-- JJM 2016-05-16 Added per new column in xxPMU

	    ,[Retirement_SCD]			   --46         -- JJM 2017-04-05 Added
		,[SCD_LengthOfService]	       --47         -- JJM 2017-04-05 Added
		,[SCD_RIF]					   --48         -- JJM 2017-04-05 Added

		)
	select 
		--[Record Date]
		 [Latest Hire Date]                   --1
		,[Date Last Promotion]                --2
		,[Date Prob/Trial Period Begins]      --3
		,[Date Prob/Trial Period Ends]        --4
		,[Date Conversion Career Due]         --5
		,[Date Conversion Career Begins]      --6
		,[WGI Date Due]                       --7
		,[Date VRA Conversion Due]            --8
		,[Detail NTE Start Date]              --9
		,[Date of SES Appointment]            --10
		,[WGI Last Equivalent Increase Date]  --11
		,[SCD Civilian]                       --12
		,[SCD Leave]                          --13
		,[Compute Early Retirment]            --14
		,[Compute Optional Retirement]        --15
		,[Date Arrived Personnel Office]      --16 
		,[Date Arrived Present Grade]         --17
		,[Date Arrived Present Position]      --18
		,[Pay Period End Date]                --19
		,Serv05                               --20
		,Serv10                               --21
		,Serv15                               --22 
		,Serv20                               --23
		,Serv25                               --24
		,Serv30                               --25
		,Serv35                               --26
		,Serv40                               --27
		,Serv45                               --28
		,Serv50                               --29
		,[Date SES Prob Expires]			  --30  --field supplied on 2/22 load	
		,[Date Spvr/Mgr Prob Ends]			  --31	
		,''
		,''
		,SYSDATETIME()
		,pmuID                                --32
		,[Last Seperation Date]		          --33  -- JJM 2016-04-27 Added per new column in xxPMU
		,[LWOP NTE]							  --34	-- JJM 2016-05-16 Added per new column in xxPMU
		,[LWOP NTE Start Date]				  --35	-- JJM 2016-05-16 Added per new column in xxPMU
		,[LWP NTE]							  --36	-- JJM 2016-05-16 Added per new column in xxPMU
		,[LWP NTE Start Date]				  --37	-- JJM 2016-05-16 Added per new column in xxPMU
		,[Sabbatical NTE]					  --38	-- JJM 2016-05-16 Added per new column in xxPMU
		,[Sabbatical NTE Start Date]		  --39	-- JJM 2016-05-16 Added per new column in xxPMU
		,[Suspension NTE]					  --40	-- JJM 2016-05-16 Added per new column in xxPMU
		,[Suspension NTE Start Date]		  --41  -- JJM 2016-05-16 Added per new column in xxPMU
		,[Temp Promotion NTE Date]	          --42	-- JJM 2016-05-16 Added per new column in xxPMU
		,[Temp Promotion NTE Start Date]      --43	-- JJM 2016-05-16 Added per new column in xxPMU
		,[Temp Reassignment NTE Date]         --44	-- JJM 2016-05-16 Added per new column in xxPMU
		,[Temp Reassign NTE Start Date]       --45	-- JJM 2016-05-16 Added per new column in xxPMU

	    ,xs.[Retirement SCD]					  --46  -- JJM 2017-04-05 Added
		,xs.[SCD Length Of Service]			  --47  -- JJM 2017-04-05 Added
		,xs.[SCD RIF]							  --48  -- JJM 2017-04-05 Added
		
	from xxPMU x
	    LEFT OUTER JOIN xxPMU_SCD xs
			ON xs.[Social Security] = x.[Social Security]
			   AND
			   xs.[FYDESIGNATION] = x.[FY DESIGNATION]

	-- when an employee has two Emp#s with the same SSN, make sure only the record with the larger Emp# gets inserted into PositionDate table for supervisor/team lead IDs
	where x.[Employee Number] =	
					(
					select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
					where x1.PersonID = x.PersonID
					)
			or x.[Employee Number] is null

print 'PositionDate data inserted ' + cast(@@rowcount as char) + 'Anticipated total # of rows ' +  cast(@PositionDate + @@rowcount as char)   

    declare @PositionDate2 int
    select @PositionDate2 = count(*) from PositionDate 

print 'after the insert, number of rows in PositionDate is ' + cast(@PositionDate2 as char) 
	
	update xxPMU
	set PositionDateID = p.PositionDateID
	from xxPMU x 
	join PositionDate p 
		on x.pmuID=p.PmuID

print 'xxPMU updated for PositionDateID ' + cast(@@rowcount as char)
	
print 'Step 17 Inserting data into Position table... '

   declare @Position int
   select @Position = count(*) from Position 

print 'before the insert, number of rows in Position is ' + cast(@Position as char) 

	insert into Position(
		RecordDate                        -- 1
		,WorkTelephone                    -- 2
		,LeaveCategory                    -- 3
		,TenureDescription                -- 4
		,CompetativeArea                  -- 5
		,CompetativeLevel                 -- 6
		,WorkScheduleDescription          -- 7
		,BargainingUnitStatusCode         -- 8
		,BargainingUnitStatusDescription  -- 9
		,YOSGSA                           --10
		,YOS_FEDERAL                      --11
		,MCO                              --12
		,FlsaCategoryCode                 --13 
		,FlsaCategoryDescription          --14
		,DrugTestCode                     --15 
		,DrugTestDescription              --16 
		,KeyEmergencyEssentialCode        --17
		,KeyEmergencyEssentialDescription --18
		,AssignmentUserStatus             --19 
		,WorkCellPhoneNumber              --20 
		,FurloughIndicator                --21 
		,FurloughIndicatorDesc            --22
		,WorkAddressLine1                 --23 
		,WorkAddressLine2                 --24
		,WorkAddressLine3                 --25 
		,WorkBuilding                     --26 
		,WorkCity                         --27 
		,WorkCounty                       --28 
		,WorkState                        --29 
		,WorkZip                          --30 
		,PersonID                         --31  
		,DutyStationID                    --32 
		,FinancialsID                     --33 
		,PersonnelOfficeID                --34 
		,ChrisPositionID                  --35 
		,DetailedPositionID               --36 
		,ObligatedPositionID              --37 
		,PositionDateID                   --38 
		,PayID                            --39  
		,FY                               --40
		,IsHistoric                       --41
		,PosOrgAgySubelementCode          --42 
		,PosOrgAgySubelementDesc          --43 
		,PosAddressOrgInfoLine1           --44 
		,PosAddressOrgInfoLine2           --45 
		,PosAddressOrgInfoLine3           --46 
		,PosAddressOrgInfoLine4           --47 
		,PosAddressOrgInfoLine5           --48 
		,PosAddressOrgInfoLine6           --49 
		,CybersecurityCode                --50 -- 01/11/2016 Rob Cornelsen added as per 2296 01/11/2016 
		,CybersecurityCodeDesc            --51 -- 01/11/2016 Rob Cornelsen added as per 2296 
		,AvailableForHiring				  --52 --field added for 2/22 load		--suggested to move to PositionInfo

		--new columns for Task 9:
		,PublicTrustIndicatorDesc
		,PublicTrustIndicatorCode
		,TeleworkIndicator
		,TeleworkIndicatorDescription
		,TeleworkIneligibilityReason
		,TeleworkIneligibReasonDescription

		,[DataSource]
		,[SystemSource]
		,[AsOfDate]
	)
	select 
		[Record Date]							--1
		,[Work Telephone]						--2
		,[Leave Category]						--3
		,[Tenure Description]					--4
		,[Competitive Area Code]				--5
		,[Competitive Level Code]				--6
		,[Work Schedule Description]			--7
		,[Bargaining Unit Status Code]			--8
		,[Bargaining Unit Status Description]	--9
		,YOSGSA									--10  
		,YOS_FEDERAL							--11  
		,MCO									--12
		,[Flsa Category Code]					--13
		,[Flsa Category Description]			--14
		,[Drug Test Code]						--15
		,[Drug Test Description]				--16
		,[Key Emergency Essential Code]			--17
		,[Key Emergency Essential Description]	--18
		,[Assignment User Status]				--19
		,[Work Cell Phone Number]				--20
		,[Furlough Indicator]					--21
		,[Furlough Indicator Desc]				--22
		,[Work Address Line 1]					--23
		,[Work Address Line 2]					--24
		,[Work Address Line 3]					--25
		,[Work Building]						--26
		,[Work City]							--27
		,[Work County]							--28
		,[Work State]							--29
		,[Work Zip]								--30
		,PersonID								--31
		,DutyStationId							--32
		,FinancialsID							--33
		,PersonnelOfficeID						--34
		,ChrisPositionID						--35
		,ObligatedPositionID					--36
		,DetailedPositionID						--37
		,PositionDateID							--38
		,PayID									--39
		,[FY DESIGNATION]						--40
		,0										--41  Always sets column to 0 for the latest load
		,[Pos Org Agy Subelement Code]			--42
		,[Pos Org Agy Subelement Desc]			--43
		,[Pos Address Org Info Line 1]			--44
		,[Pos Address Org Info Line 2]			--45
		,[Pos Address Org Info Line 3]			--46
		,[Pos Address Org Info Line 4]			--47
		,[Pos Address Org Info Line 5]			--48
		,[Pos Address Org Info Line 6]			--49
		,[Cybersecurity Code]					--50 -- 01/06/2016 Rob Cornelsen added as per 2296
		,[Cybersecurity Code Desc]				--51 -- 01/06/2016 Rob Cornelsen Added as per 2296
		,[Available for Hiring?]				--52 --field added for 2/22 load

		--new columns for Task 9:
		,[Public Trust Indicator Desc]
		,[Public Trust Indicator Code]
		,[Telework Indicator]
		,[Telework Indicator Description]
		,[Telework Ineligibility Reason]
		,[Telework Ineligib Reason Description]

		,''
		,''
		,SYSDATETIME()

	from xxPMU x

	-- when an employee has two Emp#s with the same SSN, make sure only the record with the larger Emp# gets inserted into Position table for supervisor/team lead IDs
	where x.[Employee Number] =	
					(
					select max(cast(x1.[Employee Number] as int)) from xxPMU x1 
					where x1.PersonID = x.PersonID
					)
			or x.[Employee Number] is null

print 'Position data inserted ' + cast(@@rowcount as char) + 'Anticipated total # of rows ' +  cast(@Position + @@rowcount as char)   

    declare @Position2 int
    select @Position2 = count(*) from Position 

print 'after the insert, number of rows in Position is ' + cast(@Position2 as char) 
	
--Update Supervisor ID in positionInfo table	
print 'Step 18 Update Supervisor ID in positionInfo table... '

  update PositionInfo
  set SupervisorID = c.PersonID
  from PositionInfo a 
  join #PositionInfoSupervisor b 
		on b.PositionInfoID = a.PositionInfoID  
		and b.SupSSN is not null
  join #tempPerson c 
		on c.ssn = ltrim(rtrim(b.SupSSN))  

print 'Supervisor rows updated in PositionInfo ' + cast(@@rowcount as char)

-- Update TeamleaderID in positionInfo table	
print 'Step 19 Update Teamleader ID in positionInfo table... '

  update PositionInfo									
  set TeamLeaderID = c.PersonID
  from PositionInfo a 
  join #PositionInfoSupervisor b 
		on b.PositionInfoID = a.PositionInfoID  
		and b.TeamLeadSSN is not null
  join #tempPerson c 
		on c.ssn = ltrim(rtrim(b.TeamLeadSSN))  
		
print 'Teamleader rows updated in PositionInfo' + cast(@@rowcount as char)
	
--Set isHistoric ID
print 'Step 20 Update Historic ID in Position table... '

  	-- if temp table exists, then drop it first before you create it
	if object_id('tempdb..#Historic') is not null
		BEGIN
			drop table #Historic
		END

	create table #Historic(HistoricID int identity(0,1),RecordDate date)

	insert into #Historic(RecordDate)
	select distinct RecordDate 
	from Position 
	order by RecordDate desc
	
	update Position 
	set isHistoric = HistoricID
	from #Historic h 
	join  Position p 
		on h.RecordDate = p.RecordDate

print 'Load sequence updated ' + cast(@@rowcount as char)
	

-- Cleanup 
print 'Step 21 Cleanup Temp Objects... ' 
TRUNCATE TABLE #PositionInfoSupervisor
TRUNCATE TABLE #tempPerson
TRUNCATE TABLE #Historic


DROP TABLE #PositionInfoSupervisor
DROP TABLE #tempPerson
DROP TABLE #Historic
print 'Temporary objects removed '





GO
