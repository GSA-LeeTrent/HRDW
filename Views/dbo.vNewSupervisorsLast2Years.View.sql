USE [HRDW]
GO
/****** Object:  View [dbo].[vNewSupervisorsLast2Years]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vNewSupervisorsLast2Years] 

AS
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-05-15  
-- Description: This is a copy of the vNewSupervisors view that returns new
--              supervisors in the last two calendar years instead of the
--              current and prior fiscal years AND excludes NTE Appointments.
-- =============================================================================
SELECT DISTINCT 
	  PersonID
	, LastName
	, FirstName
	, MiddleName
	, FromPosSupervisorySatusDesc
	, ToSupervisoryStatusDesc
	, NewSupEffDate
	, NOAC_AND_DESCRIPTION
FROM
(
SELECT                  
	  DISTINCT 
	  p.PersonID
	, t.EffectiveDate
	, p.LastName
	, p.FirstName
	, ISNULL(p.MiddleName,'') AS MiddleName
	, t.FromPosSupervisorySatusDesc
	, t.ToSupervisoryStatusDesc
	, t.EffectiveDate AS NewSupEffDate
	, t.NOAC_AND_DESCRIPTION
	,row_number() over 
        (partition by p.PersonID order by t.EffectiveDate desc) as RN
FROM
	dbo.Person p
	INNER JOIN dbo.Transactions t 
		ON 
		p.PersonID = t.PersonID 
		AND 
		t.FAMILY_NOACS IN
		(
		 'NOAC 100 FAMILYAccessions' 
		,'NOAC 700 FAMILY Variety of Internal Action Types' 
		,'NOAC 900 FAMILY Agency Unique NOACS that may involve movement'
		,'NOAC 500 FAMILY Conversions'
		)
		AND
		t.NOAC_AND_DESCRIPTION NOT LIKE '%NTE%'
		AND
		(
		(
		(t.FromPosSupervisorySatusDesc NOT IN ('Supervisor (CSRA)','Supervisor or Manager'))
		AND 
		(t.ToSupervisoryStatusDesc IN ('Supervisor or Manager','Supervisor (CSRA)'))
		)
		OR
		(
		(t.FromPosSupervisorySatusDesc IS NULL)
		AND 
		(t.ToSupervisoryStatusDesc IN ('Supervisor or Manager','Supervisor (CSRA)'))
		)
		)
WHERE 
	t.EffectiveDate >= DATEADD(yy,-2,GETDATE())
	AND
	t.EffectiveDate =
	(
	SELECT MAX(t2.EffectiveDate)
	FROM
		dbo.Transactions t2
    WHERE
		t2.PersonID = t.PersonID
		AND 
		t2.FAMILY_NOACS IN
		(
		 'NOAC 100 FAMILYAccessions' 
		,'NOAC 700 FAMILY Variety of Internal Action Types' 
		,'NOAC 900 FAMILY Agency Unique NOACS that may involve movement'
		,'NOAC 500 FAMILY Conversions'
		)
		AND
		t.NOAC_AND_DESCRIPTION NOT LIKE '%NTE%'
		AND
		(
		(
		(t2.FromPosSupervisorySatusDesc NOT IN ('Supervisor (CSRA)','Supervisor or Manager'))
		AND 
		(t2.ToSupervisoryStatusDesc IN ('Supervisor or Manager','Supervisor (CSRA)'))
		)
		OR
		(
		(t2.FromPosSupervisorySatusDesc IS NULL)
		AND 
		(t2.ToSupervisoryStatusDesc IN ('Supervisor or Manager','Supervisor (CSRA)'))
		)
		)
		)
) AS NewSupervisorRecords
WHERE 
	RN = 1
---------------------------------------------
UNION
---------------------------------------------
SELECT DISTINCT 
	  PersonID
	, LastName
	, FirstName
	, MiddleName
	, FromPosSupervisorySatusDesc
	, ToSupervisoryStatusDesc
	, NewSupEffDate
	, NOAC_AND_DESCRIPTION
FROM
(
SELECT                  
	  DISTINCT 
	  p.PersonID
	, t.EffectiveDate
	, p.LastName
	, p.FirstName
	, ISNULL(p.MiddleName,'') AS MiddleName
	, t.FromPosSupervisorySatusDesc
	, t.ToSupervisoryStatusDesc
	, t.EffectiveDate AS NewSupEffDate
	, t.NOAC_AND_DESCRIPTION
	,row_number() over 
        (partition by p.PersonID order by t.EffectiveDate desc) as RN
FROM
	dbo.Person p
	INNER JOIN dbo.TransactionsHistory t 
		ON 
		p.PersonID = t.PersonID 
		AND 
		t.FAMILY_NOACS IN
		(
		 'NOAC 100 FAMILYAccessions' 
		,'NOAC 700 FAMILY Variety of Internal Action Types' 
		,'NOAC 900 FAMILY Agency Unique NOACS that may involve movement'
		,'NOAC 500 FAMILY Conversions'
		)
		AND
		t.NOAC_AND_DESCRIPTION NOT LIKE '%NTE%'
		AND
		(
		(
		(t.FromPosSupervisorySatusDesc NOT IN ('Supervisor (CSRA)','Supervisor or Manager'))
		AND 
		(t.ToSupervisoryStatusDesc IN ('Supervisor or Manager','Supervisor (CSRA)'))
		)
		OR
		(
		(t.FromPosSupervisorySatusDesc IS NULL)
		AND 
		(t.ToSupervisoryStatusDesc IN ('Supervisor or Manager','Supervisor (CSRA)'))
		)
		)
WHERE 
	t.EffectiveDate >= DATEADD(yy,-2,GETDATE())
	AND
	t.EffectiveDate =
	(
	SELECT MAX(t2.EffectiveDate)
	FROM
		dbo.Transactions t2
    WHERE
		t2.PersonID = t.PersonID
		AND 
		t2.FAMILY_NOACS IN
		(
		 'NOAC 100 FAMILYAccessions' 
		,'NOAC 700 FAMILY Variety of Internal Action Types' 
		,'NOAC 900 FAMILY Agency Unique NOACS that may involve movement'
		,'NOAC 500 FAMILY Conversions'
		)
		AND
		t.NOAC_AND_DESCRIPTION NOT LIKE '%NTE%'
		AND
		(
		(
		(t2.FromPosSupervisorySatusDesc NOT IN ('Supervisor (CSRA)','Supervisor or Manager'))
		AND 
		(t2.ToSupervisoryStatusDesc IN ('Supervisor or Manager','Supervisor (CSRA)'))
		)
		OR
		(
		(t2.FromPosSupervisorySatusDesc IS NULL)
		AND 
		(t2.ToSupervisoryStatusDesc IN ('Supervisor or Manager','Supervisor (CSRA)'))
		)
		)
		)
) AS NewSupervisorRecords
WHERE 
	RN = 1


GO
