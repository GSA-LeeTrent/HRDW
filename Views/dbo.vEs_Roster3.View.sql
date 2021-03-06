USE [HRDW]
GO
/****** Object:  View [dbo].[vEs_Roster3]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

Create view [dbo].[vEs_Roster3] AS -- WITH SCHEMABINDING AS 

select  distinct
	pos1.FY as PosFY, pos1.recordDate
	, pi.PositionEncumberedType
	, t.PersonID, t.RunDate, t.EffectiveDate, t.FYDESIGNATION as FY, t.ToPPSeriesGrade, t.FAMILY_NOACS
	, t.ToPositionAgencyCodeSubelement, t.AppointmentTypeDesc -- (group 1) Appointment Type
	, s.[PosOrgAgySubelementDescription] as Agency -- (group 2) Agency
	, datediff(year, cast(p.[BirthDate] as datetime), SUBSTRING(pos1.FY,3,4)) as Age    -- (group 3) Age at appointment
	, p.[GenderDescription] as Gender -- (group 4) Gender
	, p.[RNODescription] as Race -- (group 5) Race and Ethnicity
	, p.EducationLevelDesc as Education -- (group 6) Education
	, pos1.YOS_FEDERAL as LOS -- (group 7) Length of Service (LOS)
	, pos1.YOSGSA as LOS_GSA
	, Pay.TotalPay -- (group 8) Salary
	, t.NOAC_AND_DESCRIPTION as NOAC_DESC -- (group 9) Actions
	, t.HireDate
from (
	--Transactions Part 1 PersonID & FYDESIGNATION match Position
	select tt.PersonID, tt.FYDESIGNATION, tt.RunDate
	from (
		-- Get transactions data from the latest RunDate for each person per FY
		select PersonID, FYDESIGNATION, max(RunDate) as RunDate
		from transactions
		where FAMILY_NOACS = 'NOAC 100 FAMILYAccessions'
		--and FYDESIGNATION = 'FY2015'
		group by PersonID, FYDESIGNATION

	) tt
	inner join Position pos 
		on pos.PersonID = tt.PersonID
		and pos.FY = tt.FYDESIGNATION
		and convert(varchar(30), pos.RecordDate, 112) = SUBSTRING(pos.FY,3,4)+'0930'

) trans

inner join transactions t on t.PersonId = trans.PersonId and t.FYDESIGNATION = trans.FYDESIGNATION
	and t.rundate = trans.rundate
	and t.FAMILY_NOACS = 'NOAC 100 FAMILYAccessions'

inner join Position pos1
	on pos1.PersonID = t.PersonID
	and pos1.FY = t.FYDESIGNATION
	and convert(varchar(30), pos1.RecordDate, 112) = SUBSTRING(pos1.FY,3,4)+'0930'

inner join PositionInfo pi
	on pi.PositionInfoID = pos1.ChrisPositionID   

inner join Person p
	on p.PersonID = pos1.PersonID
	
inner join [dbo].[SSOLkup] s  -- join lookup table for Agency Description
        on s.[PosOrgAgySubelementCode] = t.ToPositionAgencyCodeSubelement

inner join [dbo].[Pay]  -- join Pay table for Salary
	on Pay.PayID = pos1.PayID
		
union

select  distinct
	pos1.FY as PosFY, pos1.recordDate
	, pi.PositionEncumberedType
	, t.PersonID, t.RunDate, t.EffectiveDate, t.FYDESIGNATION as FY, t.ToPPSeriesGrade, t.FAMILY_NOACS
	, t.ToPositionAgencyCodeSubelement, t.AppointmentTypeDesc -- (group 1) Appointment Type
	, s.[PosOrgAgySubelementDescription] as Agency -- (group 2) Agency
	, datediff(year, cast(p.[BirthDate] as datetime), SUBSTRING(pos1.FY,3,4)) as Age    -- (group 3) Age at appointment
	, p.[GenderDescription] as Gender -- (group 4) Gender
	, p.[RNODescription] as Race -- (group 5) Race and Ethnicity
	, p.EducationLevelDesc as Education -- (group 6) Education
	, pos1.YOS_FEDERAL as LOS -- (group 7) Length of Service (LOS)
	, pos1.YOSGSA as LOS_GSA
	, Pay.TotalPay -- (group 8) Salary
	, t.NOAC_AND_DESCRIPTION as NOAC_DESC -- (group 9) Actions
	, t.HireDate

from (
	--Transactions Part 2 PersonID match Position
	select tt1.PersonID, tt1.FYDESIGNATION, tt1.RunDate 
	from (
		-- Get transactions data from the latest RunDate for each person in each FY
		select PersonID, FYDESIGNATION, max(RunDate) as RunDate
		from transactions
		where FAMILY_NOACS = 'NOAC 100 FAMILYAccessions'
		--and FYDESIGNATION = 'FY2015'
		group by PersonID, FYDESIGNATION

	) tt1
	where not exists (
		select 1 from (
			
			select tt.PersonID, tt.FYDESIGNATION, tt.RunDate
				from (

						-- Get transactions data from the latest RunDate for each person in each FY
						select PersonID, FYDESIGNATION, max(RunDate) as RunDate
						from transactions
						where FAMILY_NOACS = 'NOAC 100 FAMILYAccessions'
						--and FYDESIGNATION = 'FY2015'
						group by PersonID, FYDESIGNATION
						
				) tt
				inner join Position pos on pos.PersonID = tt.PersonID
					and pos.FY = tt.FYDESIGNATION
					and convert(varchar(30), pos.RecordDate, 112) = SUBSTRING(pos.FY,3,4)+'0930'
		) tt2

		where tt2.personid = tt1.personid -- find tt1.personID not in tt2
	)

) trans

inner join transactions t on t.PersonId = trans.PersonId and t.FYDESIGNATION = trans.FYDESIGNATION
	and t.rundate = trans.rundate
	and t.FAMILY_NOACS = 'NOAC 100 FAMILYAccessions'

inner join Position pos1
	on pos1.PersonID = t.PersonID
	and CAST(SUBSTRING(pos1.FY,3,4) as int) = CAST(SUBSTRING(t.FYDESIGNATION,3,4) as int) + 1
	and pos1.RecordDate = (select max(pos2.RecordDate) from position pos2 where pos2.personid = pos1.personid
		and CAST(SUBSTRING(pos2.FY,3,4) as int) = CAST(SUBSTRING(t.FYDESIGNATION,3,4) as int) + 1)
	
inner join PositionInfo pi
	on pi.PositionInfoID = pos1.ChrisPositionID   

inner join Person p
	on p.PersonID = pos1.PersonID
	
inner join [dbo].[SSOLkup] s  -- join lookup table for Agency Description
        on s.[PosOrgAgySubelementCode] = t.ToPositionAgencyCodeSubelement

inner join [dbo].[Pay]  -- join Pay table for Salary
	on Pay.PayID = pos1.PayID


GO
