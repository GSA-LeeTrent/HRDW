USE [HRDW]
GO
/****** Object:  View [dbo].[vFinancials]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--CREATE VIEW [dbo].[vEs_Combined] -- WITH SCHEMABINDING
---- 2016-01-12 Jerry Shay - updated, use PMU to get TotalPay (group 8)
---- 2016-01-26 Rob Cornelsen -- Removed #2 columns as part of 2276
--    AS 
--    SELECT 
--        cast(t.RunDate as date) as RunDate
--		, t.EffectiveDate
--		, t.FYDESIGNATION FY
--        , t.FAMILY_NOACS    -- Family NOACS = 100
--        , t.ToPPSeriesGrade -- Pay Grade = 'ES'
--        , t.ToPositionAgencyCodeSubelement -- Agency subelement code neq 'GS15'
--        , t.AppointmentTypeDesc -- (group 1) Appointment Type
--        --, s.[PosOrgAgySubelementDescription] -- (group 2) Agency
--        , s.[PosOrgAgySubelementDescription] as Agency -- (group 2) Agency
--        , datediff(year, cast(p.[BirthDate] as datetime), EffectiveDate) as Age -- (group 3) Age at appointment   -- Removed #2 columns as part of 2276
--        , p.[GenderDescription] as Gender -- (group 4) Gender  -- Removed #2 columns as part of 2276
--		, p.[RNODescription] as Race -- (group 5) Race and Ethnicity  -- Removed #2 columns as part of 2276
--		--, R.RNO -- (group 5) Race and Ethnicity via lookup table
--		--, R.[RNO Code] --(group 5) Race and Ethnicity via lookup table
--		--, R.[Minority Status] --(group 5) Race and Ethnicity via lookup table
--		, p.EducationLevelDesc as Education -- (group 6) Education  -- Removed #2 columns as part of 2276
--		, pos.YOS_FEDERAL as LOS -- (group 7) Length of Service (LOS)
--		, pos.YOSGSA as LOS_GSA
--		, pos.RecordDate as Pos_RecDate
--		, Pay.TotalPay -- (group 8) Salary
--		, t.NOAC_AND_DESCRIPTION as NOAC_DESC -- (group 9) Actions
--    FROM [dbo].Transactions t
--        left join [dbo].[SSOLkup] s  -- join lookup table for Agency Description
--                on s.[PosOrgAgySubelementCode] = t.ToPositionAgencyCodeSubelement
--        left join [dbo].[Person] p -- join Person table for Birthday, Gender
--                on p.PersonID = t.PersonID
--        --left join [dbo].[RNOLkup] r
--		--	on r.RNO = p.[RNODescription]  -- Removed #2 columns as part of 2276
--		Left join [dbo].[Position] pos -- join Position table for Length of Service (LOS)
--			on pos.PersonID = t.PersonID
--		Left join [dbo].[Pay]  -- join Pay table for Salary
--			on Pay.PayID = pos.PayID
--    	WHERE 0=0
--		--and FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
--	    and left(ToPPSeriesGrade,2) = 'ES' 
--    	and [ToPositionAgencyCodeSubelement] <> 'GS15'
--		and month(pos.RecordDate) = 9
--		and day(pos.RecordDate) = 30
--		and year(pos.RecordDate) = Right(t.FYDESIGNATION,4)

--GO

--Create view [dbo].[vEs_Roster] -- WITH SCHEMABINDING 
---- 2016-01-19 Jerry Shay - created
---- 2016-01-26 Rob Cornelsen - Removed #2 columns as part of 2276
--    AS 
--select 
--    t.EffectiveDate
--	, t.FYDESIGNATION 
--	, t.ToPPSeriesGrade
--	, t.FAMILY_NOACS
--	, pos.FY
--	, pos.PersonID
--	, pos.recordDate
--	, pi.PositionEncumberedType
--	, datediff(year, cast(p.[BirthDate] as datetime), Sysdatetime()) as Age  -- Removed #2 columns as part of 2276

--from Position pos
--left outer join Transactions t
--	on t.PersonID = pos.PersonID
--left outer join PositionInfo pi
--	on pi.PositionInfoID = pos.ChrisPositionID
--left join Person p
--    on p.PersonID = t.PersonID
--where  0=0
--	--and t.FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
--    and left(t.ToPPSeriesGrade,2) = 'ES' 
--	and t.ToPositionAgencyCodeSubelement <> 'GS15'
--	--and (pi.PositionEncumberedType = 'Employee Permanent' or pi.PositionEncumberedType = 'Employee Temporary')
--	and month(pos.RecordDate) = 9
--	and day(pos.RecordDate) = 30
--	and year(pos.RecordDate) = Right(pos.FY,4)

--GO

--Create view [dbo].[vEs_Roster2] -- WITH SCHEMABINDING AS 
---- 2016-01-27 Jerry Shay - created
--    AS 
--select distinct
--    t.EffectiveDate
--	, t.FYDESIGNATION 
--	, t.ToPPSeriesGrade
--	, t.FAMILY_NOACS
--	, pos.FY
--	, pos.PersonID
--	, pos.recordDate
--	, pi.PositionEncumberedType
--	, datediff(year, cast(p.[BirthDate] as datetime), Sysdatetime()) as Age    

--from Position pos   

--inner join PositionInfo pi
--	on pi.PositionInfoID = pos.ChrisPositionID   
--	and (pi.PositionEncumberedType = 'Employee Permanent' or pi.PositionEncumberedType = 'Employee Temporary')
--	and month(pos.RecordDate) = 9
--	and day(pos.RecordDate) = 30
--	and year(pos.RecordDate) = Right(pos.FY,4)
	
--inner join Person p
--    on p.PersonID = pos.PersonID  

--left outer join (
--	select t2.PersonID, t2.FYDESIGNATION, t2.EffectiveDate, t2.FAMILY_NOACS, t2.ToPPSeriesGrade
--	from ( 
--		--Query the latest transaction of person's most recent EffectiveDate per FY
--		select t4.PersonID, t4.FYDESIGNATION, max(t4.transactionsID) as MaxtransactionsID
--		from (
--			--Query the most recent EffectiveDate per person per FY
--			select t3.PersonID, t3.FYDESIGNATION, Max(t3.EffectiveDate) as MaxEffDate
--			from Transactions t3
--			group by t3.PersonID, t3.FYDESIGNATION
--			) rs

--		inner join Transactions t4 
--			on t4.PersonID = rs.PersonID
--			and t4.FYDESIGNATION = rs.FYDESIGNATION
--			and t4.EffectiveDate = rs.MaxEffDate
--		group by t4.PersonID, t4.FYDESIGNATION

--	) rs2
--	inner join Transactions t2 
--		on t2.transactionsID = rs2.MaxtransactionsID

--) t 
--	on t.PersonID = pos.PersonID   
--	and t.FYDESIGNATION = pos.FY  

--GO

--Create view [dbo].[vEsActions] -- WITH SCHEMABINDING 
---- 2016-01-12 Jerry Shay - New
--    AS 
--select
--    cast(t.RunDate as date) as RunDate
--	, t.EffectiveDate
--	, t.FYDESIGNATION FY
--    , t.FAMILY_NOACS    -- Family NOACS = 100
--    , t.ToPPSeriesGrade -- Pay Grade = 'ES'
--    , t.ToPositionAgencyCodeSubelement -- Agency subelement code neq 'GS15'
--	, t.NOAC_AND_DESCRIPTION as NOAC_DESC -- (group 9) Actions
--	, Left(t.NOAC_AND_DESCRIPTION, 3) as  NOAC_Code
--	--, @NCode = t.NOAC_AND_DESCRIPTION --as  NOAC_Code
--	, act.NoacCode as Ref_NOAC_Code
--	, act.FamilyNoacs as Ref_Family_NOACS
--	, act.NoacDescription as Ref_NOAC_DESC
--	, act.NoaGrouping
--	, IsNULL(act.NoaGrouping, act.NoacDescription) as Dynamics
--FROM Transactions t
--    left join [dbo].[SSOLkup] s  -- join lookup table for Agency Description
--        on s.[PosOrgAgySubelementCode] = t.ToPositionAgencyCodeSubelement
--	Left join [dbo].[GhrNatureOfActionsLkup] act
--		on act.NoacCode = Left(t.NOAC_AND_DESCRIPTION, 3)
--    left join [dbo].[Person] p -- join Person table for Birthday, Gender
--        on p.PersonID = t.PersonID
--	Left join [dbo].[Position] pos -- join Position table for Length of Service (LOS)
--		on pos.PersonID = t.PersonID
--	Left join [dbo].[Pay]  -- join Pay table for Salary
--		on Pay.PayID = pos.PayID
--WHERE 0=0
--	--and FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
--	and left(ToPPSeriesGrade,2) = 'ES' 
--    and [ToPositionAgencyCodeSubelement] <> 'GS15'
--	and month(pos.RecordDate) = 9
--	and day(pos.RecordDate) = 30
--	and year(pos.RecordDate) = Right(t.FYDESIGNATION,4)

--GO

--Create view [dbo].[vEsAge] -- WITH SCHEMABINDING 
---- 2016-01-12 Jerry Shay - updated
---- 2016-01-26 Rob Cornelsen - Removed #2 columns as part of 2276
--    AS 
--    SELECT 
--	    Rundate
--    	, EffectiveDate
--		, FYDESIGNATION FY
--	    , ToPPSeriesGrade
--	    , FAMILY_NOACS 
--    	, datediff(year, cast(p.[BirthDate] as datetime), Sysdatetime()) as Age -- Removed #2 columns as part of 2276
--    from [dbo].Transactions t
--        left join [dbo].[Person] p
--        on p.PersonID = t.PersonID
--    where 0=0
--		--and FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
--        and left(ToPPSeriesGrade,2) = 'ES' 
--		and [ToPositionAgencyCodeSubelement] <> 'GS15'

--GO

--CREATE VIEW [dbo].[vEsAgency] --WITH SCHEMABINDING 
---- 2016-01-12 Jerry Shay - updated
--    AS 
--    select 
--        Rundate
--        , EffectiveDate
--        , ToPPSeriesGrade
--        , FAMILY_NOACS 
--        , s.[PosOrgAgySubelementDescription]
--    from [dbo].Transactions t
--        inner join [dbo].[SSOLkup] s
--        on s.[PosOrgAgySubelementCode] = t.ToPositionAgencyCodeSubelement
--    where FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
--        and left(ToPPSeriesGrade,2) = 'ES' 
--        and [ToPositionAgencyCodeSubelement] <> 'GS15'

--GO

--CREATE VIEW [dbo].[vEsAppointment] --WITH SCHEMABINDING 
---- 2016-01-12 Jerry Shay - updated
--    AS 
--    SELECT 
--        Rundate
--        , EffectiveDate
--        , AppointmentTypeDesc
--        , ToPPSeriesGrade
--        , FAMILY_NOACS 
--        , [ToPositionAgencyCodeSubelementDescription]
--    FROM [dbo].Transactions t
--    WHERE FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
--        and left(ToPPSeriesGrade,2) = 'ES' 
--        and [ToPositionAgencyCodeSubelement] <> 'GS15'

--GO

--Create view [dbo].[vEsGender] --WITH SCHEMABINDING 
---- 2016-01-12 Jerry Shay - updated
--    AS 
--    SELECT 
--	    Rundate
--    	, EffectiveDate
--	    , ToPPSeriesGrade
--	    , FAMILY_NOACS 
--	    , p.[GenderDescription] -- gender   -- Removed #2 columns as part of 2276
--    FROM [dbo].Transactions t
--        left join [dbo].[Person] p
--            on p.PersonID = t.PersonID
--    WHERE FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
--        and left(ToPPSeriesGrade,2) = 'ES' 
--		and [ToPositionAgencyCodeSubelement] <> 'GS15'

--GO

--Create view [dbo].[vEsLOS] -- WITH SCHEMABINDING 
---- 2016-01-12 Jerry Shay - added FY, commented out NOAC 100
--    AS 
--    SELECT 
--	    Rundate
--    	, EffectiveDate
--		, FYDESIGNATION FY
--	    , ToPPSeriesGrade
--	    , FAMILY_NOACS 
--		, pos.YOS_FEDERAL as LOS -- (group 7) Length of Service (LOS)
--    from [dbo].Transactions t
--	Left join [dbo].[Position] pos -- join Position table for Length of Service (LOS)
--		on pos.PersonID = t.PersonID
--    where 0=0
--		--and FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
--        and left(ToPPSeriesGrade,2) = 'ES' 
--		and [ToPositionAgencyCodeSubelement] <> 'GS15'

--GO

--CREATE VIEW [dbo].[vEsRace] -- WITH SCHEMABINDING 
---- 2016-01-06 Jerry Shay - New
---- 2016-01-26 Rob Cornelsen - Removed #2 columns as part of 2276
--    AS 
--    select 
--        Rundate
--        , EffectiveDate
--        , ToPPSeriesGrade
--        , FAMILY_NOACS 
--		, p.[RNODescription] as Race -- Removed #2 columns as part of 2276
--        --, R.RNO
--		--, R.[RNO Code]
--		--, R.[Minority Status]
--    from Transactions t
--		left join [dbo].[Person] p -- join Person table for Race and Ethnicity
--            on p.PersonID = t.PersonID
--        --left join [dbo].[RNOLkup] r
--		--	on r.RNO = p.[RNODescription] -- Removed #2 columns as part of 2276
--    where FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
--        and left(ToPPSeriesGrade,2) = 'ES' 
--        and [ToPositionAgencyCodeSubelement] <> 'GS15'

--GO

--Create view [dbo].[vEsSalary] -- WITH SCHEMABINDING 
---- For any given Person in a given FY
---- 1. Get the Record Date (in Position table) = '09/30/FY' (End of FY)
---- 2016-01-04 Jerry Shay - New
---- 2016-01-12 Jerry Shay - updated, use PMU to get TotalPay
--    AS 
--    SELECT 
--	    cast(t.RunDate as date) as Rundate
--		, t.PersonID
--    	, t.EffectiveDate
--		, t.FYDESIGNATION as FY
--	    , t.ToPPSeriesGrade
--	    , t.FAMILY_NOACS 
--		, pos.RecordDate 
--		, Pay.TotalPay -- (group 8) Salary
--    from [dbo].Transactions t
--	Left join [dbo].[Position] pos  
--		on pos.PersonID = t.PersonID
--	Left join [dbo].[Pay]  -- join Pay table for Salary
--		on Pay.PayID = pos.PayID
--    where 
--		0=0 
--		and FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
--        and left(ToPPSeriesGrade,2) = 'ES' 
--		and [ToPositionAgencyCodeSubelement] <> 'GS15'
--		and month(pos.RecordDate) = 9
--		and day(pos.RecordDate) = 30
--		and year(pos.RecordDate) = Right(t.FYDESIGNATION,4)

--GO

--CREATE VIEW [dbo].[vEsTable1] --WITH SCHEMABINDING 
---- 2016-01-12 Jerry Shay - added
--    AS 
--    SELECT LEFT(EffectiveDate,4)'Calendar Year', AppointmentTypeDesc,count(*) 'Count'
--        FROM [dbo].[vEsAppointment] a
--        group by [AppointmentTypeDesc], LEFT(EffectiveDate,4)
--        --order by LEFT(EffectiveDate,4), [AppointmentTypeDesc]

--GO

CREATE VIEW [dbo].[vFinancials] WITH SCHEMABINDING 
-- 2016-03-08 Rob Cornelsen updated table based views to match latest table structure
    AS 
    SELECT [FinancialsID]
      ,[AppointmentAuthCode]
      ,[AppointmentAuthDesc]
      ,[AppointmentAuthCode2]
      ,[AppointmentAuthDesc2]
      ,[AppointmentType]
      ,[EmploymentType]
      ,[FundingBackFill]
      ,[FundingBackFIllDesc]
      ,[FundingFUllTimeEqulvalent]
      ,[AppropriationCode]
      ,[BlockNumberCode]
      ,[BlockNumberDesc]
      ,[FinancialStatementCode]
      ,[FinancialStatementDesc]
      ,[OrgCodeBudgetFinance]
      ,[FundCode]
      ,[BudgetActivity]
      ,[CostElement]
      ,[ObjectClass]
      ,[ORG_BA_FC]
      ,[RR_ORG_BA_FC]
      ,[DataSource]
      ,[SystemSource]
      ,[AsOfDate]
    FROM [dbo].[Financials]

GO
