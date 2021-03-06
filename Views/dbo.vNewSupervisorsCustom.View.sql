USE [HRDW]
GO
/****** Object:  View [dbo].[vNewSupervisorsCustom]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vNewSupervisorsCustom] 

AS

--Created by Ralph Silvestro 4-14-2016  This looks at Accessions (100 Family), Conversions (500 Family), Movements(700 Family) & Agency Unique(900 Family)
--The specific output from this query is blended with 2 different queries: SUPERVISORY TRAINING & ALL EMPLOYEE TRAINING
--The specific information are PersonID & "Had a Transaction becoming 2-4-5"
--We will save the other information and not use except when a data requester wants to know the specific transaction that caused becoming a Supervisor
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-07-21  
-- Description: Enhanced vNewSupervisor view to included addtional attributes
--              as requested by Pamela Walker. This view will also be posed to
--              a spreadsheet on OHRM Kx.
-- =============================================================================

SELECT DISTINCT 
	  FullName
	, FromPosSupervisorySatusDesc
	, ToSupervisoryStatusDesc
	, NewSupEffDate
	, NOAC_AND_DESCRIPTION
	, [Situation Status]
	, HSSO
	, EmailAddress
	, PositionTitle
	, PPSeriesGrade
	, RegionBasedOnDutyStation
	, OfficeSymbol	
	, OrgLongName
    , DutyStationNameandStateCountry
	, AppointmentTypeDesc
	, TypeOfEmploymentDesc

FROM
(
SELECT                  
	  DISTINCT 
	  dbo.Person.LastName + ', ' + dbo.Person.FirstName + ' ' + IsNull(dbo.Person.MiddleName, '') as FullName
	, dbo.Transactions.FromPosSupervisorySatusDesc
	, dbo.Transactions.ToSupervisoryStatusDesc
	, dbo.Transactions.EffectiveDate AS NewSupEffDate
	, dbo.Transactions.NOAC_AND_DESCRIPTION
	, CASE 
	  WHEN (
		   (dbo.Transactions.FromPosSupervisorySatusDesc <> 'Supervisor (CSRA)') 
	       AND 
           (dbo.Transactions.FromPosSupervisorySatusDesc <> 'Management Official (CSRA)') 
		   AND 
		   (dbo.Transactions.FromPosSupervisorySatusDesc <> 'Supervisor or Manager')) 
		   AND 
		   (
		   (dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor or Manager') 
		   OR 
		   (dbo.Transactions.ToSupervisoryStatusDesc = 'Management Official (CSRA)')
		   OR 
		   (dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')
		   )
	  THEN dbo.Transactions.NOAC_AND_DESCRIPTION  
	  WHEN dbo.Transactions.FromPosSupervisorySatusDesc IS NULL 
		   AND 
		   (
		   (dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor or Manager')
		   OR 
		   (dbo.Transactions.ToSupervisoryStatusDesc = 'Management Official (CSRA)'
		   )
		   OR 
		   (dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')) 
	  THEN dbo.Transactions.NOAC_AND_DESCRIPTION
	  ELSE 'No' 
	  END AS [Situation Status]
	 ,row_number() over 
        (partition by dbo.Person.PersonID order by dbo.Transactions.EffectiveDate desc) as RN
	 , ros.HSSO
	 , ros.EmailAddress
	 , ros.PositionTitle
	 , ros.PPSeriesGrade
	 , ros.RegionBasedOnDutyStation
	 , ros.OfficeSymbol
	 , dbo.Transactions.ToLongName AS OrgLongName
	 , dbo.Transactions.DutyStationNameandStateCountry
	 , dbo.Transactions.AppointmentTypeDesc
	 , dbo.Transactions.TypeOfEmploymentDesc
FROM
	dbo.Person 
	INNER JOIN dbo.Transactions 
		ON 
		dbo.Person.PersonID = dbo.Transactions.PersonID 
		AND 
		(
		dbo.Transactions.FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
		OR
		dbo.Transactions.FAMILY_NOACS = 'NOAC 700 FAMILY Variety of Internal Action Types' 
		OR
		dbo.Transactions.FAMILY_NOACS = 'NOAC 900 FAMILY Agency Unique NOACS that may involve movement'
		OR 
		dbo.Transactions.FAMILY_NOACS = 'NOAC 500 FAMILY Conversions'
		)
	LEFT OUTER JOIN dbo.[vAlphaOrgRoster-with-ExEmployees] ros  		
        on ros.PersonID = dbo.Person.PersonID

WHERE 
	(
	CASE
	WHEN (
		 (dbo.Transactions.FromPosSupervisorySatusDesc <>'Supervisor (CSRA)') 
		 AND 
         (dbo.Transactions.FromPosSupervisorySatusDesc <>'Management Official (CSRA)') 
		 AND 
		 (dbo.Transactions.FromPosSupervisorySatusDesc <>'Supervisor or Manager')
		 ) 
		 AND 
		 (
		 (dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor or Manager') 
		 OR 
		 (dbo.Transactions.ToSupervisoryStatusDesc = 'Management Official (CSRA)'
		 )
		 OR 
		 (dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')
		 )
	THEN dbo.Transactions.NOAC_AND_DESCRIPTION 
	WHEN dbo.Transactions.FromPosSupervisorySatusDesc IS NULL 
		 AND 
		 (
		 (dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor or Manager')
		 OR
		 (dbo.Transactions.ToSupervisoryStatusDesc = 'Management Official (CSRA)')
		 OR 
		 (dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')
		 ) 
	THEN dbo.Transactions.NOAC_AND_DESCRIPTION
	ELSE 'No' END 
	) = dbo.Transactions.NOAC_AND_DESCRIPTION

	AND
--	JJM 2016-05-26 Changed from = max(EffectiveDate) to just getting EffectiveDates in last 2 FYs
	dbo.Transactions.EffectiveDate IN 
		(
		SELECT
			t2.EffectiveDate
		FROM
		 	Transactions t2
		WHERE
			t2.PersonID = dbo.Person.PersonID
			AND
			(
			t2.FAMILY_NOACS = 'NOAC 100 FAMILYAccessions'
			OR
			t2.FAMILY_NOACS = 'NOAC 700 FAMILY Variety of Internal Action Types'
			OR
			t2.FAMILY_NOACS = 'NOAC 900 FAMILY Agency Unique NOACS that may involve movement'
			OR
			t2.FAMILY_NOACS = 'NOAC 500 FAMILY Conversions'
			)
--			JJM Added 2016-05-26
			AND
			(
			dbo.Transactions.FYDESIGNATION = 'FY'+ dbo.Riv_fn_ComputeFiscalYear(GETDATE()) 
			or dbo.Transactions.FYDESIGNATION = 'FY'+ cast( dbo.Riv_fn_ComputeFiscalYear(GETDATE())-1 as varchar(4) ) 
			)
		)
	AND
		(
		dbo.Transactions.FYDESIGNATION = 'FY'+ dbo.Riv_fn_ComputeFiscalYear(GETDATE()) 
		or dbo.Transactions.FYDESIGNATION = 'FY'+ cast( dbo.Riv_fn_ComputeFiscalYear(GETDATE())-1 as varchar(4) ) 
		)
) AS NewSupervisorRecords
WHERE RN = 1



GO
