USE [HRDW]
GO
/****** Object:  View [REPORTING].[vNewSupervisorsFY2007FORWARD]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--Created by Raph Silvestro 4-17-2017

CREATE VIEW [REPORTING].[vNewSupervisorsFY2007FORWARD] 
AS SELECT 
      dbo.Transactions.PersonID
	, dbo.Transactions.FromPosSupervisorySatusDesc
	, dbo.Transactions.ToSupervisoryStatusDesc
	, dbo.Transactions.EffectiveDate AS NewSupEffDate
	, dbo.Transactions.NOAC_AND_DESCRIPTION
	, CASE
      WHEN DATEPART(mm,dbo.Transactions.EffectiveDate) IN ('10','11','12') 
		THEN '1st Qtr'
	  WHEN DATEPART(mm,dbo.Transactions.EffectiveDate) IN('1','2','3')
		THEN '2nd Qtr'
	  WHEN DATEPART(mm,dbo.Transactions.EffectiveDate) IN('4','5','6')
		THEN '3rd Qtr'
	  ELSE '4th Qtr' 
	  END AS [Had a Transaction becoming 2-4-5]
	  ,CASE WHEN DATEPART(MM,dbo.Transactions.EffectiveDate) IN('01','02','03','04','05','06','07','08','09') THEN YEAR(dbo.Transactions.EffectiveDate)
	   WHEN DATEPART(MM,dbo.Transactions.EffectiveDate) IN('10','11','12') THEN YEAR(dbo.Transactions.EffectiveDate) + 1  END AS 'FYDesignation'
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
FROM [dbo].[Transactions]--Transactions-Remember for this table it has current FY & Previous FY
WHERE [RunDate] =(SELECT MAX([RunDate]) AS MaxRunDate FROM [dbo].[Transactions])
AND  [dbo].[Transactions].[EffectiveDate] >='2006-10-01'
 and (dbo.Transactions.FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
		OR
		dbo.Transactions.FAMILY_NOACS = 'NOAC 700 FAMILY Variety of Internal Action Types' 
		OR
		dbo.Transactions.FAMILY_NOACS = 'NOAC 900 FAMILY Agency Unique NOACS that may involve movement'
		OR 
		dbo.Transactions.FAMILY_NOACS = 'NOAC 500 FAMILY Conversions')
UNION
SELECT 
      dbo.TransactionsHistory.PersonID
	, dbo.TransactionsHistory.FromPosSupervisorySatusDesc
	, dbo.TransactionsHistory.ToSupervisoryStatusDesc
	, dbo.TransactionsHistory.EffectiveDate AS NewSupEffDate
	, dbo.TransactionsHistory.NOAC_AND_DESCRIPTION
	, CASE
      WHEN DATEPART(mm,dbo.TransactionsHistory.EffectiveDate) IN ('10','11','12') 
		THEN '1st Qtr'
	  WHEN DATEPART(mm,dbo.TransactionsHistory.EffectiveDate) IN('1','2','3')
		THEN '2nd Qtr'
	  WHEN DATEPART(mm,dbo.TransactionsHistory.EffectiveDate) IN('4','5','6')
		THEN '3rd Qtr'
	  ELSE '4th Qtr' 
	  END AS [Had a Transaction becoming 2-4-5]
	  ,CASE WHEN DATEPART(MM,dbo.TransactionsHistory.EffectiveDate) IN('01','02','03','04','05','06','07','08','09') THEN YEAR(dbo.TransactionsHistory.EffectiveDate)
	   WHEN DATEPART(MM,dbo.TransactionsHistory.EffectiveDate) IN('10','11','12') THEN YEAR(dbo.TransactionsHistory.EffectiveDate) + 1  END AS 'FYDesignation'
	, CASE 
	  WHEN (
		   (dbo.TransactionsHistory.FromPosSupervisorySatusDesc <> 'Supervisor (CSRA)') 
	       AND 
           (dbo.TransactionsHistory.FromPosSupervisorySatusDesc <> 'Management Official (CSRA)') 
		   AND 
		   (dbo.TransactionsHistory.FromPosSupervisorySatusDesc <> 'Supervisor or Manager')) 
		   AND 
		   (
		   (dbo.TransactionsHistory.ToSupervisoryStatusDesc = 'Supervisor or Manager') 
		   OR 
		   (dbo.TransactionsHistory.ToSupervisoryStatusDesc = 'Management Official (CSRA)')
		   OR 
		   (dbo.TransactionsHistory.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')
		   )
	  THEN dbo.TransactionsHistory.NOAC_AND_DESCRIPTION  
	  WHEN dbo.TransactionsHistory.FromPosSupervisorySatusDesc IS NULL 
		   AND 
		   (
		   (dbo.TransactionsHistory.ToSupervisoryStatusDesc = 'Supervisor or Manager')
		   OR 
		   (dbo.TransactionsHistory.ToSupervisoryStatusDesc = 'Management Official (CSRA)'
		   )
		   OR 
		   (dbo.TransactionsHistory.ToSupervisoryStatusDesc = 'Supervisor (CSRA)')) 
	  THEN dbo.TransactionsHistory.NOAC_AND_DESCRIPTION
	  ELSE 'No' 
	  END AS [Situation Status]
FROM [dbo].[TransactionsHistory]--Transactions-Remember for this table it has current FY & Previous FY
WHERE 
[dbo].[TransactionsHistory].[EffectiveDate] >='2006-10-01'
 AND (dbo.TransactionsHistory.FAMILY_NOACS = 'NOAC 100 FAMILYAccessions' 
		OR
		dbo.TransactionsHistory.FAMILY_NOACS = 'NOAC 700 FAMILY Variety of Internal Action Types' 
		OR
		dbo.TransactionsHistory.FAMILY_NOACS = 'NOAC 900 FAMILY Agency Unique NOACS that may involve movement'
		OR 
		dbo.TransactionsHistory.FAMILY_NOACS = 'NOAC 500 FAMILY Conversions')




GO
