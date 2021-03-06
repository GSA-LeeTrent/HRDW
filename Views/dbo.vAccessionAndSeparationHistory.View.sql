USE [HRDW]
GO
/****** Object:  View [dbo].[vAccessionAndSeparationHistory]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[vAccessionAndSeparationHistory] 
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-03-27  
-- Description: Created view of 100, 300 Transactions joined with 
--              the most current Person / Position data
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-05-09  
-- Description: Added the following per request of Rachel Sullivan 
--              FLSA
--				Veteran
--				Bargaining unit
--				Years of Service GSA and Fed
--				Retirement eligibility (now, and in next 12 months)
-- =============================================================================
-- Author:      James McConville
-- Date:        2017-07-31  
-- Description: Changed to get supervisor at the time of the transaction rather
--              than the last supervisor for the employee.
--				
--				Fix OrgLongName by putting ISNULL around PosAddressOrgInfo1-6.
-- =============================================================================
AS

------------------------------------------------
-- 100 Transactions
------------------------------------------------
SELECT 
 p.SSN
,  p.LastName+', '+p.FirstName + ' ' + ISNULL(p.MiddleName,'') as FullName
, t.* 
, p.[EmailAddress]
, p.VeteransStatusDescription
, pos.FY
, pos.RecordDate
, pos.PosAddressOrgInfoLine1+' '+pos.PosAddressOrgInfoLine2+' '+pos.PosAddressOrgInfoLine3+' '+pos.PosAddressOrgInfoLine4+' '+pos.PosAddressOrgInfoLine5+' '+pos.PosAddressOrgInfoLine6 as OrgLongName
, pos.FLSACategoryCode
, pos.BargainingUnitStatusCode
, pos.YOSGSA
, pos.YOS_FEDERAL
, posI.[OfficeSymbol]
, posI.Grade
, posi.TargetPayPlan					
, posi.TargetGradeOrLevel
, posD.ComputeEarlyRetirment
, posD.ComputeOptionalRetirement				
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor	-- JJM 2016-04-13 Added MiddleName
, p1.EmailAddress as Supervisor_Email
FROM [dbo].[Transactions] t
	INNER JOIN
	HRDW.dbo.Person p
		ON p.PersonID = t.PersonID

	INNER JOIN dbo.Position pos 
		ON pos.PersonID = p.PersonID
		   AND 
		   pos.RecordDate =
               (
			   SELECT MAX(posx.RecordDate) 
               FROM dbo.Position posx
			   WHERE posx.PersonID = p.PersonID
--					 AND
--					 t.EffectiveDate <= posx.RecordDate 
			   )
	INNER join dbo.PositionInfo posI
		ON posI.PositionInfoId = pos.ChrisPositionId
	INNER join dbo.PositionDate posD
		ON posD.PositionDateId = pos.PositionDateId
	left outer join Person p1	
		on p1.PersonID = posI.SupervisorID

WHERE 
	  (
	  t.[FAMILY_NOACS] LIKE  'NOAC 100%'  
	  )
	  AND 
	  t.[RunDate] =
			(
			SELECT MAX(tx.RunDate) 
			FROM [dbo].[Transactions] tx
			WHERE tx.PersonID = p.PersonID AND tx.[FAMILY_NOACS] LIKE  'NOAC 100%'
			)
	  AND 
	  t.[FYDESIGNATION] >= 'FY2011'

UNION

SELECT 
 p.SSN
,  p.LastName+', '+p.FirstName + ' ' + ISNULL(p.MiddleName,'') as FullName
, t.* 
, p.[EmailAddress]
, p.VeteransStatusDescription
, pos.FY
, pos.RecordDate
, pos.PosAddressOrgInfoLine1+' '+pos.PosAddressOrgInfoLine2+' '+pos.PosAddressOrgInfoLine3+' '+pos.PosAddressOrgInfoLine4+' '+pos.PosAddressOrgInfoLine5+' '+pos.PosAddressOrgInfoLine6 as OrgLongName
, pos.FLSACategoryCode
, pos.BargainingUnitStatusCode
, pos.YOSGSA
, pos.YOS_FEDERAL
, posI.[OfficeSymbol]
, posI.Grade
, posi.TargetPayPlan					
, posi.TargetGradeOrLevel
, posD.ComputeEarlyRetirment
, posD.ComputeOptionalRetirement
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor
, p1.EmailAddress as Supervisor_Email
				
FROM [dbo].[TransactionsHistory] t
	INNER JOIN
	HRDW.dbo.Person p
		ON p.PersonID = t.PersonID

	INNER JOIN dbo.Position pos 
		ON pos.PersonID = p.PersonID
		   AND 
		   pos.RecordDate =
               (
			   SELECT MAX(posx.RecordDate) 
               FROM dbo.Position posx
			   WHERE posx.PersonID = p.PersonID
--					 AND
--					 t.EffectiveDate <= posx.RecordDate 
			   )
	INNER join dbo.PositionInfo posI
		ON posI.PositionInfoId = pos.ChrisPositionId
	INNER join dbo.PositionDate posD
		ON posD.PositionDateId = pos.PositionDateId
	left outer join Person p1	
		on p1.PersonID = posI.SupervisorID

WHERE 
	  (
	  t.[FAMILY_NOACS] LIKE  'NOAC 100%'  
	  )
	  AND 
	  t.[RunDate] =
			(
			SELECT MAX(tx.RunDate) 
			FROM [dbo].[TransactionsHistory] tx
			WHERE tx.PersonID = p.PersonID AND tx.[FAMILY_NOACS] LIKE  'NOAC 100%'
			)
	  AND 
	  t.[FYDESIGNATION] >= 'FY2011'

------------------------------------------------
-- 300 Transactions
------------------------------------------------
UNION

SELECT 
  p.SSN
 , p.LastName+', '+p.FirstName + ' ' + ISNULL(p.MiddleName,'') as FullName
, t.* 
, p.[EmailAddress]
, p.VeteransStatusDescription
, pos.FY
, pos.RecordDate
, pos.PosAddressOrgInfoLine1+' '+pos.PosAddressOrgInfoLine2+' '+pos.PosAddressOrgInfoLine3+' '+pos.PosAddressOrgInfoLine4+' '+pos.PosAddressOrgInfoLine5+' '+pos.PosAddressOrgInfoLine6 as OrgLongName
, pos.FLSACategoryCode
, pos.BargainingUnitStatusCode
, pos.YOSGSA
, pos.YOS_FEDERAL
, posI.[OfficeSymbol]
, posI.Grade
, posi.TargetPayPlan					
, posi.TargetGradeOrLevel
, posD.ComputeEarlyRetirment
, posD.ComputeOptionalRetirement				
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor	-- JJM 2016-04-13 Added MiddleName
, p1.EmailAddress as Supervisor_Email
FROM [dbo].[Transactions] t
	INNER JOIN
	HRDW.dbo.Person p
		ON p.PersonID = t.PersonID

	INNER JOIN dbo.Position pos 
		ON pos.PersonID = p.PersonID
		   AND 
		   pos.RecordDate =
               (
			   SELECT MAX(posx.RecordDate) 
               FROM dbo.Position posx
			   WHERE posx.PersonID = p.PersonID
--					 AND
-- 					 posx.RecordDate <= t.EffectiveDate  
			   )
	INNER join dbo.PositionInfo posI
		ON posI.PositionInfoId = pos.ChrisPositionId
	INNER join dbo.PositionDate posD
		ON posD.PositionDateId = pos.PositionDateId
	left outer join Person p1	
		on p1.PersonID = posI.SupervisorID

WHERE 
	  (
	  t.[FAMILY_NOACS] LIKE  'NOAC 300%'  
	  )
	  AND 
	  t.[RunDate] =
			(
			SELECT MAX(tx.RunDate) 
			FROM [dbo].[Transactions] tx
			WHERE tx.PersonID = p.PersonID AND tx.[FAMILY_NOACS] LIKE  'NOAC 300%'
			)
	  AND 
	  t.[FYDESIGNATION] >= 'FY2011'

UNION

SELECT 
 p.SSN
 , p.LastName+', '+p.FirstName + ' ' + ISNULL(p.MiddleName,'') as FullName
, t.* 
, p.[EmailAddress]
, p.VeteransStatusDescription
, pos.FY
, pos.RecordDate
, pos.PosAddressOrgInfoLine1+' '+pos.PosAddressOrgInfoLine2+' '+pos.PosAddressOrgInfoLine3+' '+pos.PosAddressOrgInfoLine4+' '+pos.PosAddressOrgInfoLine5+' '+pos.PosAddressOrgInfoLine6 as OrgLongName
, pos.FLSACategoryCode
, pos.BargainingUnitStatusCode
, pos.YOSGSA
, pos.YOS_FEDERAL
, posI.[OfficeSymbol]
, posI.Grade
, posi.TargetPayPlan					
, posi.TargetGradeOrLevel
, posD.ComputeEarlyRetirment
, posD.ComputeOptionalRetirement				
, p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor	-- JJM 2016-04-13 Added MiddleName
, p1.EmailAddress as Supervisor_Email

FROM [dbo].[TransactionsHistory] t
	INNER JOIN
	HRDW.dbo.Person p
		ON p.PersonID = t.PersonID

	INNER JOIN dbo.Position pos 
		ON pos.PersonID = p.PersonID
		   AND 
		   pos.RecordDate =
               (
			   SELECT MAX(posx.RecordDate) 
               FROM dbo.Position posx
			   WHERE posx.PersonID = p.PersonID
--					 AND
-- 					 posx.RecordDate <= t.EffectiveDate  
			   )
	INNER join dbo.PositionInfo posI
		ON posI.PositionInfoId = pos.ChrisPositionId
	INNER join dbo.PositionDate posD
		ON posD.PositionDateId = pos.PositionDateId
	left outer join Person p1	
		on p1.PersonID = posI.SupervisorID

WHERE 
	  (
	  t.[FAMILY_NOACS] LIKE  'NOAC 300%'  
	  )
	  AND 
	  t.[RunDate] =
			(
			SELECT MAX(tx.RunDate) 
			FROM [dbo].[TransactionsHistory] tx
			WHERE tx.PersonID = p.PersonID AND tx.[FAMILY_NOACS] LIKE  'NOAC 300%'
			)
	  AND 
	  t.[FYDESIGNATION] >= 'FY2011'




GO
