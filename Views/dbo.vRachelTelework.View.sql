USE [HRDW]
GO
/****** Object:  View [dbo].[vRachelTelework]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vRachelTelework] -- WITH SCHEMABINDING 
AS

SELECT 
------------------------------
-- Person
------------------------------
--  p.PersonID
  pos.RecordDate
, p.LastName + ', ' + p.FirstName + ' ' + IsNull(p.MiddleName, '') as FullName
, pos.TeleworkIndicator AS PMUTeleworkIndicator
, pos.TeleworkIndicatorDescription AS PMUTeleworkIndicatorDescription
, pos.TeleworkIneligibilityReason AS PMUTeleworkIneligibilityReason
, pos.TeleworkIneligibReasonDescription AS PMUTeleworkIneligibReasonDescription

------------------------------
-- telework 
------------------------------
, tel.TeleworkElgible
, tel.InelgibleReason
, tel.AgreementDate
, CASE
  WHEN tel.EmpStatus IS NULL
  THEN 'None'
  ELSE tel.EmpStatus
  END AS EmpStatus
, CASE
  WHEN tel.TeleworkStatus IS NULL
  THEN 'No Agreement on Salesforce File'
  ELSE tel.TeleworkStatus
  END AS TeleworkStatus
, CASE 
  WHEN tel.[EmpStatus] is null 
  THEN 'No Matching Salesforce Information on key data field'		
  ELSE 'No'
  END AS IsEmpStatusBlank

, p.[LastName] AS Employee_LN
, p.[FirstName] AS Employee_FN
, p.MiddleName AS Employee_MN
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor	-- JJM 2016-04-13 Added MiddleName
, p1.EmailAddress as Supervisor_Email

from dbo.Person p				

inner join dbo.Position pos
	on pos.PersonID = p.PersonID	
	and pos.RecordDate = 
--      JJM 2016-10-03 get max RecordDate for table instead of Person so that employees with changed SSNs are excluded
		(select Max(pos1.RecordDate) as MaxRecDate from dbo.Position pos1)
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) as MaxPosDateId from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)  -- 28,264 records, make sure one person only contains one Position record. If for any reason, a person has two position dates, get the latest one.

inner join dbo.PositionDate posD
	on posD.PositionDateId = pos.PositionDateId

	--Include the following condition if only new hires in current FY is selected. matching 460 rows for new hires in FY2016
	--and datediff(day, cast(dbo.Riv_fn_ComputeFiscalYear(posD.LatestHireDate) as datetime), cast(dbo.Riv_fn_ComputeFiscalYear(getdate()) as datetime)) = 0  

inner join dbo.PositionInfo posI
	on posI.PositionInfoId = pos.ChrisPositionId

	-- only Perm or Temp employees are selected
	and (posI.PositionEncumberedType = 'Employee Permanent' or posI.PositionEncumberedType = 'Employee Temporary')	

-- getting supervisor's names
left outer join Person p1	
	on p1.PersonID = posI.SupervisorID

-- join telework table for employee's telework agreement
left outer join [dbo].[Telework] tel
	on tel.[PersonID] = p.PersonID

	
GO
