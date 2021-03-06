USE [HRDW]
GO
/****** Object:  View [dbo].[vSupervisorsAnyDate]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vSupervisorsAnyDate] 
AS
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2016-04-19  
-- Description: Created view to identify individuals that were ever 
--              a supervisor
-- =============================================================================

SELECT                  
	  DISTINCT 
	  p.PersonID
	, p.LastName
	, p.FirstName
	, ISNULL(p.MiddleName, ' ') AS MiddleName
	, t.FromPosSupervisorySatusDesc
	, t.ToSupervisoryStatusDesc
	, t.EffectiveDate AS SupEffDate
	, t.NOAC_AND_DESCRIPTION
	, t.FYDESIGNATION
	, CASE
      WHEN DATEPART(mm,t.EffectiveDate) IN ('10','11','12') 
		THEN '1st Qtr'
	  WHEN DATEPART(mm,t.EffectiveDate) IN('1','2','3')
		THEN '2nd Qtr'
	  WHEN DATEPART(mm,t.EffectiveDate) IN('4','5','6')
		THEN '3rd Qtr'
	  ELSE '4th Qtr' 
	  END AS [Had a Transaction becoming 2-4-5]
	, CASE 
	  WHEN (
		   (t.FromPosSupervisorySatusDesc <> 'Supervisor (CSRA)') 
	       AND 
           (t.FromPosSupervisorySatusDesc <> 'Management Official (CSRA)') 
		   AND 
		   (t.FromPosSupervisorySatusDesc <> 'Supervisor or Manager')) 
		   AND 
		   (
		   (t.ToSupervisoryStatusDesc = 'Supervisor or Manager') 
		   OR 
		   (t.ToSupervisoryStatusDesc = 'Management Official (CSRA)')
		   OR 
		   (t.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')
		   )
	  THEN t.NOAC_AND_DESCRIPTION  
	  WHEN t.FromPosSupervisorySatusDesc IS NULL 
		   AND 
		   (
		   (t.ToSupervisoryStatusDesc = 'Supervisor or Manager')
		   OR 
		   (t.ToSupervisoryStatusDesc = 'Management Official (CSRA)'
		   )
		   OR 
		   (t.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')) 
	  THEN t.NOAC_AND_DESCRIPTION
	  ELSE 'No' 
	  END AS [Situation Status]
FROM
	dbo.Person p
	INNER JOIN dbo.Transactions t
		ON 
		p.PersonID = t.PersonID 
		AND 
		(
		t.FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
		OR
		t.FAMILY_NOACS = 'NOAC 700 FAMILY Variety of Internal Action Types' 
		OR
		t.FAMILY_NOACS = 'NOAC 900 FAMILY Agency Unique NOACS that may involve movement'
		OR 
		t.FAMILY_NOACS = 'NOAC 500 FAMILY Conversions'
		)
WHERE 
	(
	CASE
	WHEN (
		 (t.FromPosSupervisorySatusDesc <>'Supervisor (CSRA)') 
		 AND 
         (t.FromPosSupervisorySatusDesc <>'Management Official (CSRA)') 
		 AND 
		 (t.FromPosSupervisorySatusDesc <>'Supervisor or Manager')
		 ) 
		 AND 
		 (
		 (t.ToSupervisoryStatusDesc = 'Supervisor or Manager') 
		 OR 
		 (t.ToSupervisoryStatusDesc = 'Management Official (CSRA)'
		 )
		 OR 
		 (t.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')
		 )
	THEN t.NOAC_AND_DESCRIPTION 
	WHEN t.FromPosSupervisorySatusDesc IS NULL 
		 AND 
		 (
		 (t.ToSupervisoryStatusDesc = 'Supervisor or Manager')
		 OR
		 (t.ToSupervisoryStatusDesc = 'Management Official (CSRA)')
		 OR 
		 (t.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')
		 ) 
	THEN t.NOAC_AND_DESCRIPTION
	ELSE 'No' END 
	) = t.NOAC_AND_DESCRIPTION

-----------------
UNION
-----------------

SELECT                  
	  DISTINCT 
	  p.PersonID
	, p.LastName
	, p.FirstName
	, ISNULL(p.MiddleName, ' ') AS MiddleName
	, t.FromPosSupervisorySatusDesc
	, t.ToSupervisoryStatusDesc
	, t.EffectiveDate AS NewSupEffDate
	, t.NOAC_AND_DESCRIPTION
	, t.FYDESIGNATION
	, CASE
      WHEN DATEPART(mm,t.EffectiveDate) IN ('10','11','12') 
		THEN '1st Qtr'
	  WHEN DATEPART(mm,t.EffectiveDate) IN('1','2','3')
		THEN '2nd Qtr'
	  WHEN DATEPART(mm,t.EffectiveDate) IN('4','5','6')
		THEN '3rd Qtr'
	  ELSE '4th Qtr' 
	  END AS [Had a Transaction becoming 2-4-5]
	, CASE 
	  WHEN (
		   (t.FromPosSupervisorySatusDesc <> 'Supervisor (CSRA)') 
	       AND 
           (t.FromPosSupervisorySatusDesc <> 'Management Official (CSRA)') 
		   AND 
		   (t.FromPosSupervisorySatusDesc <> 'Supervisor or Manager')) 
		   AND 
		   (
		   (t.ToSupervisoryStatusDesc = 'Supervisor or Manager') 
		   OR 
		   (t.ToSupervisoryStatusDesc = 'Management Official (CSRA)')
		   OR 
		   (t.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')
		   )
	  THEN t.NOAC_AND_DESCRIPTION  
	  WHEN t.FromPosSupervisorySatusDesc IS NULL 
		   AND 
		   (
		   (t.ToSupervisoryStatusDesc = 'Supervisor or Manager')
		   OR 
		   (t.ToSupervisoryStatusDesc = 'Management Official (CSRA)'
		   )
		   OR 
		   (t.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')) 
	  THEN t.NOAC_AND_DESCRIPTION
	  ELSE 'No' 
	  END AS [Situation Status]
FROM
	dbo.Person p
	INNER JOIN dbo.TransactionsHistory t
		ON 
		p.PersonID = t.PersonID 
		AND 
		(
		t.FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
		OR
		t.FAMILY_NOACS = 'NOAC 700 FAMILY Variety of Internal Action Types' 
		OR
		t.FAMILY_NOACS = 'NOAC 900 FAMILY Agency Unique NOACS that may involve movement'
		OR 
		t.FAMILY_NOACS = 'NOAC 500 FAMILY Conversions'
		)
WHERE 
	(
	CASE
	WHEN (
		 (t.FromPosSupervisorySatusDesc <>'Supervisor (CSRA)') 
		 AND 
         (t.FromPosSupervisorySatusDesc <>'Management Official (CSRA)') 
		 AND 
		 (t.FromPosSupervisorySatusDesc <>'Supervisor or Manager')
		 ) 
		 AND 
		 (
		 (t.ToSupervisoryStatusDesc = 'Supervisor or Manager') 
		 OR 
		 (t.ToSupervisoryStatusDesc = 'Management Official (CSRA)'
		 )
		 OR 
		 (t.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')
		 )
	THEN t.NOAC_AND_DESCRIPTION 
	WHEN t.FromPosSupervisorySatusDesc IS NULL 
		 AND 
		 (
		 (t.ToSupervisoryStatusDesc = 'Supervisor or Manager')
		 OR
		 (t.ToSupervisoryStatusDesc = 'Management Official (CSRA)')
		 OR 
		 (t.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')
		 ) 
	THEN t.NOAC_AND_DESCRIPTION
	ELSE 'No' END 
	) = t.NOAC_AND_DESCRIPTION

GO
