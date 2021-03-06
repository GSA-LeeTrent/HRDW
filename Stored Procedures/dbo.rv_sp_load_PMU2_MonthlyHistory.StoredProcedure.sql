USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_load_PMU2_MonthlyHistory]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-06-29  
-- Description: Monthly History Version - do not load aaPMU for History
-- =============================================================================
CREATE procedure [dbo].[rv_sp_load_PMU2_MonthlyHistory]
with execute as owner		
as 

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

    exec [dbo].[rv_sp_load_PMU2]              -- Personnel Management Universe    

/* JJM 2016-06-29 No aaPMU processing for History
-- ===========================================================================
print 'Number of rows in aaPMU by RecordDate'
SELECT [Record Date], COUNT(*) AS aaPMUCnt FROM aaPMU GROUP BY [Record Date]
print ''

print 'Exceute rv_sp_load_aaPMU... '
exec rv_sp_load_aaPMU
print 'Exceute rv_sp_load_aaPMU Complete'

-- ===========================================================================
*/

	print 'Dropping Temp Columns...'

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

	print 'Load MonthlyHistory History Complete!'



GO
