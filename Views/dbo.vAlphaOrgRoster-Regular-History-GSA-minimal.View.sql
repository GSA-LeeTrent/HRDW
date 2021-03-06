USE [HRDW]
GO
/****** Object:  View [dbo].[vAlphaOrgRoster-Regular-History-GSA-minimal]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vAlphaOrgRoster-Regular-History-GSA-minimal] 

-- =============================================================================
-- Author:      Paul Tsagaroulis
-- Date:        2017-12-12 
-- Description: Trimmed fields for total GSA report
-- Original query: [dbo].[vAlphaOrgRoster-Regular-History-OHRM-GS14]
-- =============================================================================

AS 

Select 
------------------------------
-- Person
------------------------------
  p.PersonID
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName

------------------------------
-- Position
------------------------------
, pos.FY
, Month(pos.RecordDate) as Month_Name
, pos.RecordDate

, pos.[PosOrgAgySubelementCode]
, s.[PosOrgAgySubelementDescription] as HSSO -- SSO lookup for Agency or PosOrgAgySubelementDesc
, s.[SsoAbbreviation]						 -- includes Abbr

------------------------------
-- Position Date
------------------------------
, posD.LatestHireDate
, posD.SCDCivilian
, posD.SCDLeave
, posD.ComputeEarlyRetirment
, dbo.gsa_fn_ComputeEarlyRetirement(
									 posD.Retirement_SCD
									,posD.SCDCivilian
									,p.BirthDate
								   ) 
		  AS [ComputeEarlyRetirement(HRDW)]			-- JJM 2017-06-01 Added
, posD.ComputeOptionalRetirement
, dbo.gsa_fn_ComputeOptionalRetirement(
									    posD.Retirement_SCD
									   ,posD.SCDCivilian
									   ,p.BirthDate
									   ,posI.PositionSeries
									   ,p.RetirementPlanCode
									  ) 
		  AS [ComputeOptionalRetirement(HRDW)]		-- JJM 2017-06-01 Added
, posD.WGIDateDue
, posD.WGILastEquivalentIncreaseDate
, posD.DateLastPromotion
, posD.ArrivedPersonnelOffice
, posD.ArrivedPresentGrade
, posD.ArrivedPresentPosition

------------------------------
-- Position Info
------------------------------
, posI.[OfficeSymbol]
, OfficeLkup.[OfficeSymbol2Char]
, OfficeLkup.RegionBasedonOfficeSymbol
, posI.PositionEncumberedType
, posI.PositionControlNumber
, posI.PositionControlIndicator
, posI.PositionInformationPD
, posI.PositionSequenceNumber
, posI.[SupervisoryStatusCode]
, posI.[SupervisoryStatusDesc]				-- JJM 2016-04-13 Added
, posI.PositionTitle
, posI.OccupationalCateGOryDescription
, posI.PayPlan+'-'+posI.[PositionSeries]+'-'+posI.Grade as PPSeriesGrade 
, posI.[PositionSeries]
, posI.Grade
, posI.Step
, posi.[OccupationalSeriesCode]			--, PMU_PRIMARY.[CHRIS Position Information#Occupational Series Code]
, posi.[OccupationalSeriesDescription]
, posi.TargetPayPlan					-- JJM 2016-04-27 - Target PP and Grade added to PositionInfo
, posi.TargetGradeOrLevel				-- JJM 2016-04-27 - Target PP and Grade added to PositionInfo
, posi.[DetailType]						-- JJM 2016-05-17 Added
, posi.[DetailTypeDescription]			-- JJM 2016-05-17 Added

------------------------------
-- Financials
------------------------------
, f.EmploymentType						--, PMU_PRIMARY.[Type of Employment Description]
, f.AppointmentType						--, PMU_PRIMARY.[Appointment Type Description]
, f.BlockNumberCode
, f.BlockNumberDesc
, f.AppropriationCode
, f.OrgCodeBudgetFinance
, f.FundCode
, f.BudgetActivity
, f.CostElement
, f.ObjectClass
, f.ORG_BA_FC
, f.RR_ORG_BA_FC

------------------------------
-- Duty Station
------------------------------
, ds.DutyStationCode
, ds.DutyStationName
, ds.DutyStationCounty						--, PMU_PRIMARY.[CHRIS Position InformationDuty Station County Name]
, ds.DutyStationState						--, PMU_PRIMARY.[Duty Station State Or Country]
, ds.Region				
, dutlkup.RegionBasedOnDutyStation			-- JJM 2016-04-13 Added

------------------------------
-- Pay
------------------------------
,pay.BasicSalary						--, PMU_PRIMARY.[Basic Salary Rate]
,pay.AdjustedBasic						--, PMU_PRIMARY.[Adjusted Basic Pay]
,pay.TotalPay							--, PMU_PRIMARY.[Total Pay]
,pay.HourlyPay							--, PMU_PRIMARY.[Per- Hour(Total Salary_Total Pay)]

from dbo.Person p				--28264 distinct PersonIDs

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
--	and pos.RecordDate = 
--      JJM 2016/04/04 - Update joing on Max Report Date to use PersonID instead of FY
--		(select Max(pos1.RecordDate) as MaxRecDate from dbo.Position pos1 where pos1.FY = pos.FY)	-- always get the latest RecordDate
--		(select Max(pos1.RecordDate) as MaxRecDate from dbo.Position pos1 where pos1.PersonID = pos.PersonID)	-- always get the latest RecordDate
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) as MaxPosDateId from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)  -- 28,264 records, make sure one person only contains one Position record. If for any reason, a person has two position dates, get the latest one.

inner join dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId			--28,264 rows

	--Include the following condition if only new hires in current FY is selected. matching 460 rows for new hires in FY2016
	--and datediff(day, cast(dbo.Riv_fn_ComputeFiscalYear(posD.LatestHireDate) as datetime), cast(dbo.Riv_fn_ComputeFiscalYear(getdate()) as datetime)) = 0  

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId

	-- only Perm or Temp employees are selected, getting 11,180 rows
	and (posI.PositionEncumberedType = 'Employee Permanent' or posI.PositionEncumberedType = 'Employee Temporary')	

inner join dbo.Financials f
	on f.FinancialsID = pos.FinancialsID	--11,180 rows

inner join dbo.PersonnelOffice po			--11,180 rows
	on po.PersonnelOfficeID = pos.PersonnelOfficeID

/* JJM 2016-04-21 Changed to LEFT OUTER JOIN */
LEFT OUTER JOIN dbo.DutyStation ds				--11,180 rows
	on pos.DutyStationID = ds.DutyStationID

LEFT OUTER JOIN DutyStationCodeStateRegionLkup dutlkup	-- JJM 2016-04-13 Lkup Region based on DutyStation
	ON ds.DutyStationCode = (REPLICATE('0',9 - LEN(dutlkup.DutyStationCode)) + dutlkup.DutyStationCode)

inner join dbo.Pay pay						--11,180 rows
	on pay.PayID = pos.PayID

left outer join dbo.Security sc				--11,180 rows
	on sc.PersonID = p.PersonID
	-- always get one record with the latest Clearance Date
	and sc.[SecurityID] = 
		(select Max(sc1.[SecurityID]) as MaxSecID 
		from dbo.Security sc1 
		where sc1.PersonID = sc.PersonID
		)

left outer join dbo.IDP idp				--11,180 rows
	on idp.PersonID = p.PersonID
	-- when multiple IDP records are present in a FY, always get one record with the latest IDP Record Date
	and idp.[IDPRecordNumber] = 
		(select Max(idp1.[IDPRecordNumber]) as MaxIDPRecDate 
		from dbo.IDP idp1 
		where idp1.PersonID = idp.PersonID
		  and idp1.FiscalYearValidation = idp.FiscalYearValidation
		  and idp1.IDPStatus = idp.IDPStatus
		)
	and 
	cast(idp.FiscalYearValidation as integer) = cast(dbo.Riv_fn_ComputeFiscalYear(getdate()) as integer)

-- getting supervisor's names
left outer join Person p1					--11,180 rows
	on p1.PersonID = posI.SupervisorID

-- getting supervisor's position Info (phone, etc)
left outer join Position suppos
	on suppos.PersonID = posI.SupervisorID
	and suppos.RecordDate = 
		(select Max(pos3.RecordDate) from dbo.Position pos3 where pos3.PersonID = suppos.PersonID)

/* JJM 2017-05-23 Adding Supervisor Duty Station info*/
LEFT OUTER JOIN dbo.DutyStation supds
	on suppos.DutyStationID = supds.DutyStationID

LEFT OUTER JOIN DutyStationCodeStateRegionLkup supdutlkup
	ON supds.DutyStationCode = (REPLICATE('0',9 - LEN(supdutlkup.DutyStationCode)) + supdutlkup.DutyStationCode)
/* JJM 2017-05-23 End */

-- join lookup table for Office Symbol
left outer join dbo.OfficeLkup				--11,180 rows
	on OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]	

-- join lookup table for Agency Description
left outer join [dbo].[SSOLkup] s  			--11,180 rows
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]


GO
