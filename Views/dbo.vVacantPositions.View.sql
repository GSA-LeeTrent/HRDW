USE [HRDW]
GO
/****** Object:  View [dbo].[vVacantPositions]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-04-12  
-- Description: Removed PersonID and EmployeeFullName from view
--              Grant "View" access to Public 
--Modified vy Ralph Silvestro
--Date: 12-8-2016
--Added Pos Org Lines 1-6 at end of view
-- =============================================================================
CREATE VIEW [dbo].[vVacantPositions] WITH SCHEMABINDING 
AS (

SELECT 
pos.RecordDate							--PMU_PRIMARY.[Record Date]
/*JJM 2016-04-12 - Commented out PersonID and EmployeeFullName
, pos.PersonID
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as EmployeeFullName		--[Full Name] based on pos.PersonID
*/
, pi.[OfficeSymbol]						--PMU_PRIMARY.[CHRIS Position InformationOffice Symbol], e.g. 10P1PGW
, OfficeLkup.[OfficeSymbol2Char]		--PMU_PRIMARY.[Final_2 Letter]			
, pi.[PositionControlIndicator]			--PMU_PRIMARY.[CHRIS Position InformationPosition Control Number Indicator]
, pi.[PositionControlNumber]			--PMU_PRIMARY.[CHRIS Position InformationPosition Control Number]
, pi.[PositionInformationPD]			--PMU_PRIMARY.[CHRIS Position InformationPD Number]
, pi.[PositionEncumberedType]			--PMU_PRIMARY.[Position Encumbered Type]
, pi.[PositionTitle]					--PMU_PRIMARY.[CHRIS Position InformationPosition Title]
, pos.[MCO]								--PMU_PRIMARY.MCO

, pi.PayPlan+'-'+pi.[PositionSeries]+'-'+pi.Grade as PPSeriesGrade
										--PMU_PRIMARY.[PP-Series-Grade] --Pay Plan + series + grade, e.g. GS-1801-14

, pi.[PositionSeries]					--PMU_PRIMARY.[CHRIS Position InformationOccupational Series Code]
, pi.[PositionSeriesDesc]				--PMU_PRIMARY.[CHRIS Position InformationOccupational Series Description]

/* 
Currently, we don't separate Valid Grade (current grade) from Target Grade (performance grade when matured), 
we have only one Grade column in PositionInfo table. Suggested to add a new column for TargetGrade. 
*/

--, pi.Grade								--PMU_PRIMARY.[CHRIS Position Information#Valid Grade Or Level] -- this field is not used in SP_PMU2
, pi.PayPlan							--PMU_PRIMARY.[Target Pay Plan]
, pi.Grade								--PMU_PRIMARY.[Target Grade Or Level]
, ds.[DutyStationName]					--PMU_PRIMARY.[CHRIS Position InformationDuty Station Name]				
, ds.[DutyStationCounty]				--PMU_PRIMARY.[CHRIS Position InformationDuty Station County Name]		
, ds.[DutyStationState]					--PMU_PRIMARY.[Duty Station State Or Country]
, pi.[SupervisoryStatusCode]			--PMU_PRIMARY.[CHRIS Position InformationSupervisory Status Code]
, pi.[SupervisoryStatusDesc]			--PMU_PRIMARY.[CHRIS Position InformationSupervisory Status Description]
, pos.[WorkScheduleDescription]			--PMU_PRIMARY.[Work Schedule Description]
, pi.[PositionSensitivity]				--PMU_PRIMARY.[CHRIS Position InformationPosition Sensitivity Description]
, pos.[BargainingUnitStatusCode]		--PMU_PRIMARY.[Bargaining Unit Status Code]
, pos.[BargainingUnitStatusDescription]	--PMU_PRIMARY.[Bargaining Unit Status Description]

--6 Line translation added 7-5-2016 by Ralph Silvestro
,ISNULL(PosAddressOrgInfoLine1, ' ') + ISNULL(PosAddressOrgInfoLine2, ' ') + ISNULL(PosAddressOrgInfoLine3, ' ')+ ISNULL(PosAddressOrgInfoLine4, ' ') +ISNULL(PosAddressOrgInfoLine5, ' ')+ISNULL(PosAddressOrgInfoLine6, ' ') OrgLongName

--,PosAddressOrgInfoLine2+' '+PosAddressOrgInfoLine3+' '+PosAddressOrgInfoLine4+' '+PosAddressOrgInfoLine5+' '+PosAddressOrgInfoLine6 as OrgLongName
										--PMU_PRIMARY.[Pos Organization Long Name] --positionInfo.PosAddewssOrgInfoline2-6

, po.OwningRegion						--PMU_PRIMARY.[Owning Region]
, po.ServicingRegion					--PMU_PRIMARY.[Servicing Region]
, po.PersonnelOfficeDescription			--PMU_PRIMARY.[Personnel Office ID Description]
, pos.[PosOrgAgySubelementCode]
, pos.[PosOrgAgySubelementDesc]			--PMU_PRIMARY.[Pos Org Agy Subelement Desc]

--, pi.SupervisorID						--PMU_PRIMARY.Posn_Supervisor
, p1.LastName+', '+p1.FirstName as Position_Supervisor

--, pi.TeamLeaderID						--PMU_PRIMARY.[Team Leaders Name]
, p2.LastName+', '+p2.FirstName as TeamLeadersName

, f.AppropriationCode					--PMU_PRIMARY.[Appropriation Code 1]
, f.FundingBackFill						--PMU_PRIMARY.[Funding Back Fill]
, f.FundingBackFIllDesc					--PMU_PRIMARY.[Funding Back Fill Description]
, f.FundingFUllTimeEqulvalent			--PMU_PRIMARY.[Funding Full Time Equivalent]

, pi.[FundingStatus]					--PMU_PRIMARY.[CHRIS Position WMT InformationFunding Status Description]
, pi.[PositionSequenceNumber]			--PMU_PRIMARY.[CHRIS Position InformationPosition Sequence Number]

--, PMU_PRIMARY.[Available for Hiring?]	-- maybe in DDL build

, [PositionDetailed?] =					--, PMU_PRIMARY.[Position Detailed?]
CASE 
	WHEN DetailedPositionID is not null THEN 'Y'
	ELSE Null
END

, pos.[FlsaCategoryCode]				--PMU_PRIMARY.[Flsa Category Code]
, pos.[FlsaCategoryDescription]			--PMU_PRIMARY.[Flsa Category Description]
, f.BlockNumberCode						--PMU_PRIMARY.[Block Number Code]
, f.BlockNumberDesc						--PMU_PRIMARY.[Block Number Description]
, pos.AssignmentUserStatus				--PMU_PRIMARY.[Assignment User Status]

, p4.LastName+', '+p4.FirstName as DetailedEmpName	-- PMU_PRIMARY.[Detailed Employee Full Name]

, [PositionObligated?] =				--, PMU_PRIMARY.[Position Obligated?]
CASE 
	WHEN pos.ObligatedPositionID is not null THEN 'Y'
	ELSE Null
END

, p3.LastName+', '+p3.FirstName as ObligatedEmpName	--, PMU_PRIMARY.[Obligated Employee Full Name]

, pi.[OccupationalCategoryCode]			--PMU_PRIMARY.[CHRIS Position InformationOccupational Category Code]
, pi.[OccupationalCategoryDescription]	--PMU_PRIMARY.[CHRIS Position InformationOccupational Category Description]

--Added Translation of Line 1-6 on 12-8-2016

,pos.[PosAddressOrgInfoLine1]
,pos.[PosAddressOrgInfoLine2]
,pos.[PosAddressOrgInfoLine3]
,pos.[PosAddressOrgInfoLine4]
,pos.[PosAddressOrgInfoLine5]
,pos.[PosAddressOrgInfoLine6]


FROM dbo.Position pos	 
inner join dbo.PositionInfo pi
	on pi.PositionInfoID = pos.ChrisPositionID
	and pos.RecordDate = 
		(select Max(pos.RecordDate) as MaxRecDate from dbo.Position pos)  -- 34457 rows, select the most recent RecordDate

inner join dbo.PersonnelOffice po
	on po.PersonnelOfficeID = pos.PersonnelOfficeID  -- 34457 rows

inner join dbo.Financials f
	on f.FinancialsID = pos.FinancialsID  -- 34457 rows

inner join dbo.DutyStation ds
	on ds.DutyStationID = pos.DutyStationID  -- 34457 rows

left outer join dbo.OfficeLkup 
	on OfficeLkup.[OfficeSymbol] = pi.[OfficeSymbol]  -- 34487 rows

-- the extra 30 rows are from the two office symbols (7QSBBAB and QSDQC) which two matching rows in OfficeLkup table
-- remove the duplicate rows
-- duplicate rows removed on 2/9/2016

-- getting employee's full names
left outer join dbo.Person p
	on p.PersonID = pos.PersonID	

-- getting supervisor's names
left outer join dbo.Person p1
	on p1.PersonID = pi.SupervisorID

-- getting team leader's names
left outer join dbo.Person p2
	on p2.PersonID = pi.TeamLeaderID

-- getting Obligated Employee's names
left outer join dbo.Person p3
	on p3.PersonID = pos.PersonID
	and pos.ObligatedPositionID is not null

-- getting Detailed Employee's names
left outer join dbo.Person p4
	on p4.PersonID = pos.PersonID
	and pos.DetailedPositionID is not null

WHERE pi.PositionEncumberedType='Vacant' )   -- 6333 rows


GO
