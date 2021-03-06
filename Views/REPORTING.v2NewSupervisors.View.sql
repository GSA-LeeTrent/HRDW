USE [HRDW]
GO
/****** Object:  View [REPORTING].[v2NewSupervisors]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [REPORTING].[v2NewSupervisors] AS

(SELECT
DISTINCT 
                        dbo.Person.PersonID, dbo.Person.LastName, dbo.Person.FirstName, dbo.Person.MiddleName, dbo.Transactions.FromPosSupervisorySatusDesc, 
                         dbo.Transactions.ToSupervisoryStatusDesc, dbo.Transactions.EffectiveDate AS NewSupEffDate, dbo.Transactions.NOAC_AND_DESCRIPTION, 
                         CASE WHEN DATEPART(mm, dbo.Transactions.EffectiveDate) IN ('10', '11', '12') THEN '1st Qtr' WHEN DATEPART(mm, dbo.Transactions.EffectiveDate) IN ('1', '2', '3') 
                         THEN '2nd Qtr' WHEN DATEPART(mm, dbo.Transactions.EffectiveDate) IN ('4', '5', '6') THEN '3rd Qtr' ELSE '4th Qtr' END AS [Had a Transaction becoming 2-4-5], 
                         CASE WHEN ((dbo.Transactions.FromPosSupervisorySatusDesc <> 'Supervisor (CSRA)') AND 
                         (dbo.Transactions.FromPosSupervisorySatusDesc <> 'Management Official (CSRA)') AND 
                         (dbo.Transactions.FromPosSupervisorySatusDesc <> 'Supervisor or Manager')) AND ((dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor or Manager') OR
                         (dbo.Transactions.ToSupervisoryStatusDesc = 'Management Official (CSRA)') OR
                         (dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')) 
                         THEN dbo.Transactions.NOAC_AND_DESCRIPTION WHEN dbo.Transactions.FromPosSupervisorySatusDesc IS NULL AND 
                         ((dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor or Manager') OR
                         (dbo.Transactions.ToSupervisoryStatusDesc = 'Management Official (CSRA)') OR
                         (dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')) THEN dbo.Transactions.NOAC_AND_DESCRIPTION ELSE 'No' END AS [Situation Status]
FROM            dbo.Person INNER JOIN
                         dbo.Transactions ON dbo.Person.PersonID = dbo.Transactions.PersonID AND (dbo.Transactions.FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' OR
                         dbo.Transactions.FAMILY_NOACS = 'NOAC 700 FAMILY Variety of Internal Action Types' OR
                         dbo.Transactions.FAMILY_NOACS = 'NOAC 900 FAMILY Agency Unique NOACS that may involve movement' OR
                         dbo.Transactions.FAMILY_NOACS = 'NOAC 500 FAMILY Conversions')
WHERE        ((CASE WHEN ((dbo.Transactions.FromPosSupervisorySatusDesc <> 'Supervisor (CSRA)') AND 
                         (dbo.Transactions.FromPosSupervisorySatusDesc <> 'Management Official (CSRA)') AND 
                         (dbo.Transactions.FromPosSupervisorySatusDesc <> 'Supervisor or Manager')) AND ((dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor or Manager') OR
                         (dbo.Transactions.ToSupervisoryStatusDesc = 'Management Official (CSRA)') OR
                         (dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')) 
                         THEN dbo.Transactions.NOAC_AND_DESCRIPTION WHEN dbo.Transactions.FromPosSupervisorySatusDesc IS NULL AND 
                         ((dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor or Manager') OR
                         (dbo.Transactions.ToSupervisoryStatusDesc = 'Management Official (CSRA)') OR
                         (dbo.Transactions.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')) THEN dbo.Transactions.NOAC_AND_DESCRIPTION ELSE 'No' END) 
                         = dbo.Transactions.NOAC_AND_DESCRIPTION) AND (dbo.Transactions.EffectiveDate =
                             (SELECT        MAX(EffectiveDate) AS Expr1
                               FROM            dbo.Transactions AS t2
                               WHERE        (PersonID = dbo.Person.PersonID) AND (FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' OR
                                                         FAMILY_NOACS = 'NOAC 700 FAMILY Variety of Internal Action Types' OR
                                                         FAMILY_NOACS = 'NOAC 900 FAMILY Agency Unique NOACS that may involve movement' OR
                                                         FAMILY_NOACS = 'NOAC 500 FAMILY Conversions'))) 
	)													 

GO
