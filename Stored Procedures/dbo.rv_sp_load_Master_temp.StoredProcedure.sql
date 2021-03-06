USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_Master_temp]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-04-27  
-- Description: execute the following procedures to load archive (aa) tables
--              - rv_sp_load_aaPMU
--              - rv_sp_load_aaTransactions
-- =============================================================================
CREATE procedure [dbo].[rv_sp_load_Master_temp]
with execute as owner		
as 

/* -- temp commented on 2018-04-03
IF EXISTS(
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
    print 'Warning! One of the required temp columns exists in xx tables.' + CHAR(13) + CHAR(10)+ CHAR(13) + CHAR(10)
	print 'Removing existing temp columns...'
	
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

END

	print 'Adding temp columns...'

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
*/
--  temporarily point to "temp" version due to transport error
    exec [dbo].[rv_sp_load_PMU2_temp]              -- Personnel Management Universe    

-- ===========================================================================
print 'Number of rows in aaPMU by RecordDate'
SELECT [Record Date], COUNT(*) AS aaPMUCnt FROM aaPMU GROUP BY [Record Date]
print ''

print 'Exceute rv_sp_load_aaPMU... '
exec rv_sp_load_aaPMU
print 'Exceute rv_sp_load_aaPMU Complete'

-- ===========================================================================

	--TODO Use JulyOnly only for the inital load of July 2015 xxPMU file
	--exec rv_sp_load_PMU2_JulyOnly

	exec dbo.rv_sp_load_IDP					-- Individual Development Plan
	exec dbo.rv_sp_load_CriticalElement		-- Criteria for Performance Rating
	exec dbo.rv_sp_load_PerformanceRating	-- Actual Performance Rating
	--exec rv_sp_load_Performance 
	--exec rv_sp_load_PerformancePlan
	--exec rv_sp_load_SecondaryMidYear
	exec rv_sp_load_Security			--Clearance data
	exec rv_sp_load_Telework			--Telework requirement
	--exec rv_sp_load_VorS
	exec rv_sp_load_TSSTDS				--Training Courses
	exec rv_sp_load_PPID				--Performance Plans

	exec rv_sp_load_transactions			
	--exec rv_sp_load_High3

-- ===========================================================================
print 'Number of rows in aaTransactions by Run Date'
SELECT [Run Date], COUNT(*) AS aaTransactionsCnt FROM aaTransactions GROUP BY [Run Date]
print ''

print 'Exceute rv_sp_load_aaTransactions... '
exec rv_sp_load_aaTransactions
print 'Exceute rv_sp_load_aaTransactions Complete'

-- ===========================================================================

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




GO
