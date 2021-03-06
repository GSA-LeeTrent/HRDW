USE [HRDW]
GO
/****** Object:  View [dbo].[vServicePINs]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/****** Object:  View [dbo].[vServicePINs]    Script Date: 03/22/2016 18:03:22 ******/
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-04-12  
-- Description: Removed PersonID column from view
--              Grant "View" access to Public 
-- =============================================================================

CREATE VIEW [dbo].[vServicePINs] WITH SCHEMABINDING 
AS 
Select
pos.RecordDate													--[Record Date]
--  JJM 2016-04-12 - Remove PersonID from view
--added Person ID back in to allow relational joins
, pos.PersonID
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as EmployeeFullName		--[Full Name] based on pos.PersonID
, p1.LastName + ', ' + p1.FirstName + ' ' + IsNull(p1.MiddleName, '') as SupervisorFullName	--PMU_PRIMARY.Posn_Supervisor based on posI.SupervisorID
, pos.[PosOrgAgySubelementCode]
, pos.[PosOrgAgySubelementDesc]	
, ds.[DutyStationName]											--PMU_PRIMARY.[CHRIS Position InformationDuty Station Name]				
, ds.[DutyStationCounty]										--PMU_PRIMARY.[CHRIS Position InformationDuty Station County Name]		
, ds.[DutyStationState]											--PMU_PRIMARY.[Duty Station State Or Country]
, po.OwningRegion												--PMU_PRIMARY.[Owning Region]
, po.ServicingRegion											--PMU_PRIMARY.[Servicing Region]
, po.PersonnelOfficeDescription									--PMU_PRIMARY.[Personnel Office ID Description]
, posI.[OfficeSymbol]												--PMU_PRIMARY.[CHRIS Position InformationOffice Symbol], e.g. 10P1PGW
, OfficeLkup.[OfficeSymbol2Char]								--PMU_PRIMARY.[Final_2 Letter]	
, posI.[PositionTitle]											--PMU_PRIMARY.[CHRIS Position InformationPosition Title]
, posI.PayPlan+'-'+posI.[PositionSeries]+'-'+posI.Grade as PPSeriesGrade --PMU_PRIMARY.[PP-Series-Grade] --Pay Plan + series + grade, e.g. GS-1801-14
, pos.YOS_FEDERAL												--[YOS_FEDERAL] 
, pos.YOSGSA													--[YOSGSA]
, Month(posD.[Serv05Date]) as Month								--PIN Month: the MONTH of the service anniversary. See Note below.

, [HighestNow] =												--[HIGHESTNOW] Is this Year the highest Pin Year? See Note below.
CASE 
	WHEN Year(posD.[Serv05Date])=Year(SYSDATETIME()) THEN '5 Year Pin'
	WHEN Year(posD.[Serv10Date])=Year(SYSDATETIME()) THEN '10 Year Pin'
	WHEN Year(posD.[Serv15Date])=Year(SYSDATETIME()) THEN '15 Year Pin'
	WHEN Year(posD.[Serv20Date])=Year(SYSDATETIME()) THEN '20 Year Pin'
	WHEN Year(posD.[Serv25Date])=Year(SYSDATETIME()) THEN '25 Year Pin'
	WHEN Year(posD.[Serv30Date])=Year(SYSDATETIME()) THEN '30 Year Pin'
	WHEN Year(posD.[Serv35Date])=Year(SYSDATETIME()) THEN '35 Year Pin'
	WHEN Year(posD.[Serv40Date])=Year(SYSDATETIME()) THEN '40 Year Pin'
	WHEN Year(posD.[Serv45Date])=Year(SYSDATETIME()) THEN '45 Year Pin'
	WHEN Year(posD.[Serv50Date])=Year(SYSDATETIME()) THEN '50 Year Pin'
	ELSE 'Some Other Time Period'
END

, [THISCY] =												--[THISCY]: This Calendar Year. Is this Year the Pin Year? See Note below.
CASE 
	WHEN Year(posD.[Serv05Date])=Year(SYSDATETIME()) THEN 'This Year'
	WHEN Year(posD.[Serv10Date])=Year(SYSDATETIME()) THEN 'This Year'
	WHEN Year(posD.[Serv15Date])=Year(SYSDATETIME()) THEN 'This Year'
	WHEN Year(posD.[Serv20Date])=Year(SYSDATETIME()) THEN 'This Year'
	WHEN Year(posD.[Serv25Date])=Year(SYSDATETIME()) THEN 'This Year'
	WHEN Year(posD.[Serv30Date])=Year(SYSDATETIME()) THEN 'This Year'
	WHEN Year(posD.[Serv35Date])=Year(SYSDATETIME()) THEN 'This Year'
	WHEN Year(posD.[Serv40Date])=Year(SYSDATETIME()) THEN 'This Year'
	WHEN Year(posD.[Serv45Date])=Year(SYSDATETIME()) THEN 'This Year'
	WHEN Year(posD.[Serv50Date])=Year(SYSDATETIME()) THEN 'This Year'
	ELSE 'Some Other Time Period'
END

, posD.[SCDCivilian]											--[SCD Civilian]
, posD.[SCDLeave]												--[SCD Leave]
, posD.[Serv05Date]												--[Serv05]
, posD.[Serv10Date]												--[Serv10]
, posD.[Serv15Date]												--[Serv15]
, posD.[Serv20Date]												--[Serv20]
, posD.[Serv25Date]												--[Serv25]
, posD.[Serv30Date]												--[Serv30]
, posD.[Serv35Date]												--[Serv35]
, posD.[Serv40Date]												--[Serv40]
, posD.[Serv45Date]												--[Serv45]
, posD.[Serv50Date]												--[Serv50]

FROM dbo.Position pos	 
inner join dbo.PositionInfo posI
	on posI.PositionInfoID = pos.ChrisPositionID
	and pos.RecordDate = 
		(select Max(pos.RecordDate) as MaxRecDate from dbo.Position pos)  -- select the most recent RecordDate
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) as MaxPosDateId from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)  --make sure one person only contains one Position record. If for any reason, a person has two position dates, get the latest one.
	and (posI.PositionEncumberedType = 'Employee Permanent' or posI.PositionEncumberedType = 'Employee Temporary')	--select only current GSA employees

inner join dbo.PersonnelOffice po
	on po.PersonnelOfficeID = pos.PersonnelOfficeID  

inner join dbo.PositionDate posD
	on posD.[PositionDateID] = pos.[PositionDateID]	

inner join dbo.DutyStation ds
	on ds.DutyStationID = pos.DutyStationID  

left outer join dbo.OfficeLkup 
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]  

-- getting employee's full names
left outer join dbo.Person p
	on p.PersonID = pos.PersonID		

-- getting supervisor's names
left outer join dbo.Person p1
	on p1.PersonID = posI.SupervisorID		




GO
