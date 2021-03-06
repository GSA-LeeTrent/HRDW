USE [HRDW]
GO
/****** Object:  View [REPORTING].[vOCR_DYNAMICS]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



--Created by Ralph Silvestro 5-31-2016
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-03-06  
-- Description: View Updated to get RNODecription from RNOLkup instead of Person
-- =============================================================================

CREATE VIEW [REPORTING].[vOCR_DYNAMICS] AS

SELECT      'PII' AS Safeguard
   , DB_NAME() AS [Database]
   , FORMAT(GETDATE(), 'M/dd/yyyy', 'en-US') AS [Record Date DB ]
   ,dbo.Person.[PersonID] AS [Person ID]
   ,[ToPPSeriesGrade]
   ,dbo.Person.[RNOCode] AS 'RNO Cd'
   ,rnolkup.[RNODescription] AS 'RNO Desc'
   ,[GenderDescription] AS 'Gender'
   ,FORMAT ([BirthDate], 'M/dd/yyyy', 'en-US') AS 'DOB'
   ,[HandicapCode] AS 'Disability Cd'
   ,[HandicapCodeDescription] AS 'Disability Desc'
   ,CASE WHEN dbo.[Person].VeteransPreferenceDescription ='NONE' THEN '1'
         WHEN dbo.[Person].VeteransPreferenceDescription = '5 point' THEN '2'
		 WHEN dbo.[Person].VeteransPreferenceDescription = '10 point/disability' THEN '3'
		 WHEN dbo.[Person].VeteransPreferenceDescription = '10 point/compensable' THEN '4'
		 WHEN dbo.[Person].VeteransPreferenceDescription = '10 point/other' THEN '5'
		 WHEN dbo.[Person].VeteransPreferenceDescription = '10 point/compensable/30 percent' THEN '6'
		 ELSE '7' END AS 'Vet Pref Cd'--Code 7 = Sole Survivorship Pref eligible
   ,[VeteransPreferenceDescription] AS 'Vet Pref Desc'
   ,CASE WHEN dbo.[Person].VeteransStatusDescription ='Not a Vietnam-era veteran' THEN 'N'
         WHEN dbo.[Person].VeteransStatusDescription ='Vietnam-era veteran' THEN 'V'
         WHEN dbo.[Person].VeteransStatusDescription ='Pre-Vietnam-era veteran' THEN 'B'
         WHEN dbo.[Person].VeteransStatusDescription ='Post-Vietnam-era veteran' THEN 'P'
         ELSE 'X' END AS 'Vet Status Cd'--Note X value means Not A Veteran
   ,[VeteransStatusDescription] AS 'Vet Status Desc'
   , dbo.[Person].EducationLevelCode AS 'Educ Lvl Code'
   , dbo.[Person].EducationLevelDesc AS 'Educ Lvl Desc'
   ,CASE WHEN dbo.[vChrisTrans-All].[TenureDesc] LIKE '%No Tenure Group%' THEN '0'
         WHEN dbo.[vChrisTrans-All].[TenureDesc] LIKE '%Tenure Group 1%' THEN '1'
		 WHEN dbo.[vChrisTrans-All].[TenureDesc] LIKE '%Tenure Group 2%' THEN '2'
		 ELSE '3' END AS 'Tenure Cd'--Value 3 = Tenure group 3
   ,[TenureDesc] AS 'Tenure Desc'
   ,CASE WHEN dbo.[vChrisTrans-All].[ToSupervisoryStatusDesc]='Supervisor or Manager' THEN '2'
        WHEN dbo.[vChrisTrans-All].[ToSupervisoryStatusDesc]='Management Official (CSRA)' THEN '5'
		WHEN dbo.[vChrisTrans-All].[ToSupervisoryStatusDesc]='Supervisor (CSRA)' THEN '4'
		WHEN dbo.[vChrisTrans-All].[ToSupervisoryStatusDesc]='Leader' THEN '6'
		WHEN dbo.[vChrisTrans-All].[ToSupervisoryStatusDesc]='Team Leader' THEN '7'
		ELSE '8' END AS 'Supv Status Cd'
   ,[ToSupervisoryStatusDesc] AS 'Supv Status Desc'
   ,[DutyStationNameandStateCountry] AS 'DS Desc'
   ,[NOAC_AND_DESCRIPTION] AS 'Generic Noac Desc'
   ,[AwardUOM] 
   ,[AwardType]
   ,[ToPositionTargetGradeorLevel]
   ,[FromPositionTargetGradeorLevel]
   ,[AwardAmount]	
   ,[NOAC_AND_DESCRIPTION_2] AS 'Specific Noac Desc'
   , CASE WHEN [NOAC_AND_DESCRIPTION_2] LIKE '%NTE%' THEN RIGHT (([NOAC_AND_DESCRIPTION_2]),11) 
     WHEN [NOAC_AND_DESCRIPTION_2] LIKE '%Name Chg%' THEN 'Name Change' --NOAC 780
	 WHEN LEFT([NOAC_AND_DESCRIPTION_2],3) ='352' THEN 'Move to Another Agency'
	 ELSE ' ' END AS 'Nte Dte or Name Chg or Move to Another Agy'
   ,FORMAT ([EffectiveDate], 'M/dd/yyyy', 'en-US') AS 'Noac Eff Dte'
   ,[FYDESIGNATION] AS 'FY Designation'
   ,FORMAT ([ProcessedDate], 'M/dd/yyyy', 'en-US') AS 'Process Dte'
   --,CASE WHEN [FirstActionLACode1] IS Null THEN ' ' ELSE [FirstActionLACode1] END  AS 'Fist LAC'
   --,CASE WHEN [FirstActionLADesc1] IS NULL THEN ' ' ELSE [FirstActionLADesc1] END  AS 'First LAC Desc'
  -- ,CASE WHEN [FirstActionLACode2] IS NULL THEN ' ' ELSE [FirstActionLACode2] END AS 'Sec LAC'
  -- ,CASE WHEN [FirstActionLADesc2] IS NULL THEN ' ' ELSE  [FirstActionLADesc2] END  AS 'Sec LAC Desc'

FROM
    dbo.[vChrisTrans-All] 
	INNER JOIN dbo.Person 
		ON dbo.[vChrisTrans-All].PersonID = dbo.Person.PersonID
	LEFT OUTER JOIN dbo.RNOLkup rnolkup
		ON rnolkup.RNOCode = dbo.Person.RNOCode	


GO
