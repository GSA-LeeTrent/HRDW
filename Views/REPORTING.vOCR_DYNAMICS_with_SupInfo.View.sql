USE [HRDW]
GO
/****** Object:  View [REPORTING].[vOCR_DYNAMICS_with_SupInfo]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [REPORTING].[vOCR_DYNAMICS_with_SupInfo]
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-02-23  
-- Description: Cloned vOCR_DYNAMICS view to add Supervisor Demographic data
-- =============================================================================
AS
SELECT      
 Safeguard
,EmpSupervisorID
,[Database]
,[Record Date DB ]
,EmpPersonID
,EmpToPPSeriesGrade
,EmpRNOCd
,EmpRNODesc
,EmpGender
,EmpDOB
,EmpDisabilityCd
,EmpDisabilityDesc
,EmpVetPrefCd
,EmpVetPrefDesc
,EmpVetStatusCd
,EmpVetStatusDesc
,EmpEducLvlCode
,EmpEducLvlDesc
,EmpTenureCd
,EmpTenureDesc
,EmpSupvStatusCd
,EmpSupStatusDesc
,EmpDutyStnDesc
,EmpGenericNOACDesc
,EmpAwardUOM 
,EmpAwardType
,[ToPositionTargetGradeorLevel]
,[FromPositionTargetGradeorLevel]
,[AwardAmount]	
,EmpSpecificNOACDesc
,[Nte Dte or Name Chg or Move to Another Agy]
,EmpNOACEffDate
,FYDesignation
,ProcessDate
--======================================================================================
,p2.[PersonID]									AS SupPersonID
,p2.[RNOCode]									AS SupRNOCd
,rnolkup2.RNODescription						AS SupRNODesc
,p2.[GenderDescription]							AS SupGender
,FORMAT (p2.[BirthDate],'M/dd/yyyy', 'en-US')	AS SupDOB
,p2.[HandicapCode]								AS SupDisabilityCd
,p2.[HandicapCodeDescription]					AS SupDisabilityDesc
,CASE 
	WHEN p2.VeteransPreferenceDescription ='NONE' THEN '1'
    WHEN p2.VeteransPreferenceDescription = '5 point' THEN '2'
	WHEN p2.VeteransPreferenceDescription = '10 point/disability' THEN '3'
	WHEN p2.VeteransPreferenceDescription = '10 point/compensable' THEN '4'
	WHEN p2.VeteransPreferenceDescription = '10 point/other' THEN '5'
	WHEN p2.VeteransPreferenceDescription = '10 point/compensable/30 percent' THEN '6'
	ELSE '7' 
 END											AS SupVetPrefCd --Code 7 = Sole Survivorship Pref eligible
,p2.[VeteransPreferenceDescription]				AS SupVetPrefDesc
,CASE 
	WHEN p2.VeteransStatusDescription ='Not a Vietnam-era veteran' THEN 'N'
    WHEN p2.VeteransStatusDescription ='Vietnam-era veteran' THEN 'V'
    WHEN p2.VeteransStatusDescription ='Pre-Vietnam-era veteran' THEN 'B'
    WHEN p2.VeteransStatusDescription ='Post-Vietnam-era veteran' THEN 'P'
    ELSE 'X' 
 END											AS SupVetStatusCd --Note X value means Not A Veteran
,p2.[VeteransStatusDescription]					AS SupVetStatusDesc
,p2.EducationLevelCode							AS SupEducLvlCode
,p2.EducationLevelDesc							AS SupEducLvlDesc

FROM
(
SELECT      
	 'PII' AS Safeguard
   , posI.SupervisorID							AS EmpSupervisorID
   , DB_NAME() AS [Database]
   , FORMAT(GETDATE(), 'M/dd/yyyy', 'en-US')	AS [Record Date DB ]
   ,p.[PersonID]								AS [EmpPersonID]
   ,trans.[ToPPSeriesGrade]						AS EmpToPPSeriesGrade
   ,p.[RNOCode]									AS EmpRNOCd
   ,rnolkup.[RNODescription]					AS EmpRNODesc
   ,p.[GenderDescription]						AS EmpGender
   ,FORMAT (p.[BirthDate],'M/dd/yyyy', 'en-US')	AS EmpDOB
   ,p.[HandicapCode]							AS EmpDisabilityCd
   ,p.[HandicapCodeDescription]					AS EmpDisabilityDesc
   ,CASE WHEN p.VeteransPreferenceDescription ='NONE' THEN '1'
         WHEN p.VeteransPreferenceDescription = '5 point' THEN '2'
		 WHEN p.VeteransPreferenceDescription = '10 point/disability' THEN '3'
		 WHEN p.VeteransPreferenceDescription = '10 point/compensable' THEN '4'
		 WHEN p.VeteransPreferenceDescription = '10 point/other' THEN '5'
		 WHEN p.VeteransPreferenceDescription = '10 point/compensable/30 percent' THEN '6'
		 ELSE '7' 
	END											AS EmpVetPrefCd --Code 7 = Sole Survivorship Pref eligible
   ,p.[VeteransPreferenceDescription]			AS EmpVetPrefDesc
   ,CASE WHEN p.VeteransStatusDescription ='Not a Vietnam-era veteran' THEN 'N'
         WHEN p.VeteransStatusDescription ='Vietnam-era veteran' THEN 'V'
         WHEN p.VeteransStatusDescription ='Pre-Vietnam-era veteran' THEN 'B'
         WHEN p.VeteransStatusDescription ='Post-Vietnam-era veteran' THEN 'P'
         ELSE 'X' 
	END											AS EmpVetStatusCd --Note X value means Not A Veteran
   ,p.[VeteransStatusDescription]				AS EmpVetStatusDesc
   ,p.EducationLevelCode						AS EmpEducLvlCode
   ,p.EducationLevelDesc						AS EmpEducLvlDesc
   ,CASE WHEN trans.[TenureDesc] LIKE '%No Tenure Group%' THEN '0'
         WHEN trans.[TenureDesc] LIKE '%Tenure Group 1%' THEN '1'
		 WHEN trans.[TenureDesc] LIKE '%Tenure Group 2%' THEN '2'
		 ELSE '3' 
	END											AS EmpTenureCd --Value 3 = Tenure group 3
   ,trans.[TenureDesc]								AS EmpTenureDesc
   ,CASE 
		WHEN trans.[ToSupervisoryStatusDesc]='Supervisor or Manager' THEN '2'
        WHEN trans.[ToSupervisoryStatusDesc]='Management Official (CSRA)' THEN '5'
		WHEN trans.[ToSupervisoryStatusDesc]='Supervisor (CSRA)' THEN '4'
		WHEN trans.[ToSupervisoryStatusDesc]='Leader' THEN '6'
		WHEN trans.[ToSupervisoryStatusDesc]='Team Leader' THEN '7'
		ELSE '8' 
	END											AS EmpSupvStatusCd
   ,trans.[ToSupervisoryStatusDesc]					AS EmpSupStatusDesc
   ,trans.[DutyStationNameandStateCountry]			AS EmpDutyStnDesc
   ,trans.[NOAC_AND_DESCRIPTION]						AS EmpGenericNOACDesc
   ,trans.[AwardUOM]									AS EmpAwardUOM 
   ,trans.[AwardType]									AS EmpAwardType
   ,trans.[ToPositionTargetGradeorLevel]
   ,trans.[FromPositionTargetGradeorLevel]
   ,trans.[AwardAmount]	
   ,trans.[NOAC_AND_DESCRIPTION_2]						AS EmpSpecificNOACDesc
   ,CASE 
		WHEN trans.[NOAC_AND_DESCRIPTION_2] LIKE '%NTE%' THEN RIGHT (([NOAC_AND_DESCRIPTION_2]),11) 
		WHEN trans.[NOAC_AND_DESCRIPTION_2] LIKE '%Name Chg%' THEN 'Name Change' --NOAC 780
		WHEN LEFT(trans.[NOAC_AND_DESCRIPTION_2],3) ='352' THEN 'Move to Another Agency'
		ELSE ' ' 
	END													AS 'Nte Dte or Name Chg or Move to Another Agy'
   ,FORMAT (trans.[EffectiveDate],'M/dd/yyyy', 'en-US') AS EmpNOACEffDate
   ,[FYDESIGNATION]										AS FYDesignation
   ,FORMAT (trans.[ProcessedDate],'M/dd/yyyy', 'en-US') AS ProcessDate

FROM 
	dbo.[vChrisTrans-All] trans
	INNER JOIN dbo.Person p
		ON trans.PersonID = p.PersonID
	LEFT OUTER JOIN dbo.Position pos
		ON pos.PersonID = p.PersonID	
		   AND
		   pos.RecordDate = 
			(
			SELECT MAX(pos1.RecordDate) as MaxRecDate 
			FROM dbo.Position pos1
			WHERE pos1.RecordDate <= trans.EffectiveDate
			)
	LEFT OUTER JOIN dbo.PositionInfo posI
		ON posI.PositionInfoId = pos.ChrisPositionId
	LEFT OUTER JOIN dbo.Rnolkup rnolkup
		ON rnolkup.RNOCode = p.RNOCode
)
AS Emp
LEFT OUTER JOIN Person p2
	ON p2.PersonID = Emp.EmpSupervisorID
LEFT OUTER JOIN RnoLkup rnolkup2
	ON rnolkup2.RNOCode = p2.RNOCode


GO
