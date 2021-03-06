USE [HRDW]
GO
/****** Object:  View [STAFFING].[vNSA_StaffingPlan]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [STAFFING].[vNSA_StaffingPlan] 
AS
SELECT 
       dtl.[SERVICECODE]
	  ,svc.[SERVICEABBR]
      ,dtl.[FY]
      ,dtl.[REGION]
      ,dtl.[NAME]
      ,posi.[PositionTitle]
      ,dtl.[FUND]
      ,dtl.[SERIES]
	  ,posi.[PayPlan]
      ,dtl.[GRADE]
      ,dtl.[STEP]
	  ,posi.[TargetGradeOrLevel] AS FPL
	  ,dtl.[VACANCYID]
	  ,NULL							AS POSITIONCONTROLNO
	  ,NULL							AS VACANCYSTAGE
	  ,NULL							AS FILLMETHODID
      ,SUM(dtl.[BASEPAY])			AS SALARY
      ,SUM(dtl.[GLI])				AS GLI
      ,SUM(dtl.[MEDICARE])			AS MEDICARE
      ,SUM(dtl.[OASDI])				AS OASDI
      ,SUM(dtl.[TSP_BASIC])			AS TSP_BASIC
      ,SUM(dtl.[TSP_MATCH])			AS TSP_MATCH
      ,SUM(dtl.[HBI])				AS HBI
      ,SUM(dtl.[RET])				AS RET
      ,SUM(dtl.[NON_FOR_COLA])		AS NON_FOR_COLA
      ,SUM(dtl.[BIWEEKLYBENEFITS])	AS BENEFITS
      ,SUM(dtl.[BIWEEKLYTOTAL])		AS TOTALPAY
      ,SUM(dtl.[TERMINALLEAVE])		AS TERMINALLEAVE
      ,SUM(dtl.[OTHERCOSTS])		AS OTHERCOSTS
      ,SUM(dtl.[COSTTOTAL])			AS COSTTOTAL
      ,SUM(dtl.[GRADEDELTA])		AS GRADEDELTA
	  ,SUM(dtl.[STEPDELTA])			AS STEPDELTA
FROM 
	 STAFFING.[TBLSALARYPROJECTIONSINDIVBYPP] dtl
		LEFT OUTER JOIN dbo.Person per
			ON dtl.Name = per.LastName + ', ' + per.FirstName + ' ' + IsNull(per.MiddleName, '')

		LEFT OUTER JOIN dbo.Position pos
			ON pos.PersonID = per.PersonID	
			   AND
			   pos.RecordDate = 
				(
				select Max(pos1.RecordDate)
				from dbo.Position pos1
				where pos1.PersonID = pos.PersonID
				)
		
		LEFT OUTER JOIN dbo.PositionInfo posi
			ON posi.PositionInfoId = pos.ChrisPositionId
			-- only Perm or Temp employees are selected, getting 11,180 rows
			AND 
			(
			posI.PositionEncumberedType = 'Employee Permanent'
			OR
			posI.PositionEncumberedType = 'Employee Temporary'
			)	

		LEFT OUTER JOIN STAFFING.TBLSERVICES svc
		    ON dtl.SERVICECODE = svc.SERVICECODE
WHERE
	dtl.VACANCYID = 0
	AND
	dtl.FY = dbo.Riv_fn_ComputeFiscalYear(GETDATE())
	AND
	CAST(dtl.PPEDATE AS DATE)
		=	(
			SELECT MIN(CAST(dtl1.PPEDATE AS DATE)) 
			FROM
				STAFFING.TBLSALARYPROJECTIONSINDIVBYPP dtl1
			WHERE
				dtl1.NAME = dtl1.NAME
			)
GROUP BY
       dtl.[SERVICECODE]
	  ,svc.[SERVICEABBR]
	  ,dtl.[FY]
      ,dtl.[REGION]
      ,dtl.[NAME]
	  ,posi.[PositionTitle]
	  ,dtl.[FUND]
      ,dtl.[SERIES]
	  ,posi.[PayPlan]
      ,dtl.[GRADE]
      ,dtl.[STEP]
	  ,posi.[TargetGradeOrLevel]
	  ,dtl.[VACANCYID]

UNION

SELECT 
       agg.[SERVICECODE]
	  ,vac.[SERVICEABBR]
      ,dbo.Riv_fn_ComputeFiscalYear(GETDATE()) AS FY
      ,vac.[REGION]
      ,agg.[NAME]
      ,vac.[TITLE]
      ,agg.[FUND]
      ,vac.[SERIES]
	  ,vac.[PAYPLAN]
      ,vac.[GRADESTART]				AS GRADE
      ,0							AS STEP
	  ,CAST(vac.[FPL] AS char(4))
	  ,vac.[VACANCYID]
	  ,vac.POSITIONCONTROLNO
	  ,vac.VACANCYSTAGE
	  ,vac.FILLMETHODID
      ,(agg.[SALARY])				AS SALARY
      ,0							AS GLI
      ,0							AS MEDICARE
      ,0							AS OASDI
      ,0							AS TSP_BASIC
      ,0							AS TSP_MATCH
      ,0							AS HBI
      ,0							AS RET
      ,0							AS NON_FOR_COLA
      ,(agg.[BENEFITS])				AS BENEFITS
      ,0							AS TOTALPAY
      ,0							AS TERMINALLEAVE
      ,0							AS OTHERCOSTS
      ,0							AS COSTTOTAL
      ,0							AS GRADEDELTA
	  ,0							AS STEPDELTA
	  
FROM 
	 STAFFING.[TBLSALARYPROJECTIONSINDIVIDUAL] agg
		
		LEFT OUTER JOIN STAFFING.[TBLVACANCIES] vac
			ON agg.VACANCYID = vac.VACANCYID

WHERE
	agg.PERIODNAME = 'Remainder of this FY'
	AND
	agg.VACANCYID <> 0


GO
