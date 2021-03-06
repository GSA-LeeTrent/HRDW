USE [HRDW]
GO
/****** Object:  View [REPORTING].[vAllTransactions1985Forward]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [REPORTING].[vAllTransactions1985Forward] AS

SELECT DISTINCT
      
      [PersonID]
      ,[FYDESIGNATION]
      ,[SSN]
      ,[FullName]
      ,[ProcessDate]
      ,[EffectiveDate]
      ,[NOAC AND DESCRIPTION]
      ,[VeteransPreferenceCode]
      ,[VeteransPreferenceDescription]
      ,[AuthorityCode1]
      ,[AuthorityCode2]
      ,[BirthDate]
      ,[RNOCode]
      ,[RNODescription]
      ,[Gender]
	  ,UPPER(ISNULL([DutyStationName], ''))+', '+UPPER(ISNULL([DutyStationState], '')) AS 'DutyStationNameandState'
      ,[OwningRegion]
      ,[ServingRegion]
      ,[HandicapCode]
      ,[HandicapCodeDescription]
      ,[FromOfficeSymbol]
      ,[ToOfficeSymbol]
      ,[FromHSSO]
      ,[ToHSSO]
      ,[What Kind of Movement?]
      ,[FromSeriesGroupTitle]
      ,[ToSeriesGroupTitle]
      ,[FromPP]
      ,[ToPP]
      ,[FromSeries] AS 'FromSries'
      ,[[ToSeries] AS 'ToSeries'
      ,[[FromGrade] AS 'FromGrade'
      ,[[ToGrade] AS 'ToGrade'
      ,[FromPP-Series-Gr]
      ,[ToPP-Series-Gr]
      ,[From MCO-Mission Critical Occupations]
      ,[From OCO-Organizational Critical Occupations]
      ,[To MCO-Mission Critical Occupations]
      ,[To OCO-Organizational Critical Occupations]
      ,[FromSupervisoryCode]
      ,[FromSupervisoryStatusDesc]
      ,[ToSupervisoryCode]
      ,[ToSupervisoryStatusDesc]
  FROM [LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)]
  --WHERE LEFT([NOAC AND DESCRIPTION],1) LIKE '4%'--3 PLACES TO ALTER THIS QUERY

UNION--This starts the second portion of the query going against the TransactionHistoryTable

SELECT 
      [dbo].[TransactionsHistory].[PersonID]
	  ,[dbo].[TransactionsHistory].[FYDESIGNATION]
	 , [dbo].[Person].[SSN]
	  ,[dbo].[Person].LastName + ', ' + [dbo].[Person].FirstName + ' ' + IsNull([dbo].[Person].MiddleName, '') AS FullName
      ,[dbo].[TransactionsHistory].[ProcessedDate]
	  ,[dbo].[TransactionsHistory].[EffectiveDate]
	  ,[dbo].[TransactionsHistory].[NOAC_AND_DESCRIPTION]
	  , CASE WHEN [VeteransPreferenceDesc] = 'None' THEN '1'
WHEN [dbo].[TransactionsHistory].[VeteransPreferenceDesc] = '5-point' THEN '2'
WHEN [dbo].[TransactionsHistory].[VeteransPreferenceDesc]  = '10-point/disability' THEN '3'
WHEN [dbo].[TransactionsHistory].[VeteransPreferenceDesc]  = '10-POINT/COMPENSABLE' THEN'4'
WHEN [dbo].[TransactionsHistory].[VeteransPreferenceDesc]  = '10-point/other' THEN '5'
WHEN [dbo].[TransactionsHistory].[VeteransPreferenceDesc] = '10-point/compensable/30 percent' THEN '6'
WHEN [dbo].[TransactionsHistory].[VeteransPreferenceDesc] = 'Sole Survivorship Preference eligible' THEN '7'
ELSE 'NULL' END AS  'VeteransPreferenceCode'
	  ,[dbo].[TransactionsHistory].[VeteransPreferenceDesc]
,[dbo].[TransactionsHistory].[FirstActionLACode1]
,[dbo].[TransactionsHistory].[FirstActionLACode2]
,[dbo].[Person].[BirthDate]
,[dbo].[Person].[RNOCode]
,[dbo].[Person].[RNODescription]
,CASE WHEN [dbo].[Person].[GenderDescription] ='Female' THEN 'F'
WHEN [dbo].[Person].[GenderDescription] ='Male' THEN 'M' else ' ' END AS 'Gender'
,[dbo].[TransactionsHistory].[DutyStationNameandStateCountry] AS 'DutyStationNameandState'
,[dbo].[TransactionsHistory].[ToRegion] AS 'OwningRegion'
,[dbo].[TransactionsHistory].[ToServicingRegion] AS 'ServingRegion'
,[dbo].[Person].[HandicapCode]
,[dbo].[Person].[HandicapCodeDescription]
,[dbo].[TransactionsHistory].[FromOfficeSymbol]
,[dbo].[TransactionsHistory].[ToOfficeSymbol]
,CASE WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS01' THEN 'IOA'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS02' THEN 'OAS'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS03' THEN 'PBS'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS04' THEN 'OCR'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS10' THEN 'SBU'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS11' THEN 'OCFO'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS12' THEN 'OGC'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS13' THEN 'CBCA'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS14' THEN 'OHRM/OCPO'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS15' THEN 'OIG'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS16' THEN 'OCAO'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS18' THEN 'TTS'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS19' THEN 'OCSIT'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS20' THEN 'OCIA'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS22' THEN 'ORA'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS24' THEN 'FAS/FSS'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS26' THEN 'OCP'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS27' THEN 'FAS/FTS'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS28' THEN 'OCIO/GSAIT'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS29' THEN 'ChildCare'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS30' THEN 'FAS'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS31' THEN 'OERR/OMA'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS32' THEN 'OCM/OSC'
WHEN [dbo].[TransactionsHistory].[FromPositionAgencyCodeSubelement] ='GS33' THEN 'OCE'
ELSE ' ' END AS 'FromHSSO'
,CASE WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS01' THEN 'IOA'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS02' THEN 'OAS'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS03' THEN 'PBS'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS04' THEN 'OCR'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS10' THEN 'SBU'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS11' THEN 'OCFO'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS12' THEN 'OGC'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS13' THEN 'CBCA'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS14' THEN 'OHRM/OCPO'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS15' THEN 'OIG'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS16' THEN 'OCAO'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS18' THEN 'TTS'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS19' THEN 'OCSIT'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS20' THEN 'OCIA'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS22' THEN 'ORA'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS24' THEN 'FAS/FSS'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS26' THEN 'OCP'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS27' THEN 'FAS/FTS'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS28' THEN 'OCIO/GSAIT'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS29' THEN 'ChildCare'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS30' THEN 'FAS'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS31' THEN 'OERR/OMA'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS32' THEN 'OCM/OSC'
WHEN [dbo].[TransactionsHistory].[ToPositionAgencyCodeSubelement] ='GS33' THEN 'OCE'
ELSE ' ' END AS 'ToHSSO'
,[dbo].[TransactionsHistory].[WhatKindofMovement] AS 'WhatKindofMovement?'
,[dbo].[TransactionsHistory].[FromPositionTitle]
,[dbo].[TransactionsHistory].[ToPositionTitle]
,LEFT([dbo].[TransactionsHistory].[FromPPSeriesGrade],2) AS 'FromPP'
,LEFT([dbo].[TransactionsHistory].[ToPPSeriesGrade],2) AS 'ToPP'
,SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) AS 'FromSeries'
,SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) AS 'ToSeries'
,RIGHT([dbo].[TransactionsHistory].[FromPPSeriesGrade],2) AS 'FromGrade'
,RIGHT([dbo].[TransactionsHistory].[ToPPSeriesGrade],2) AS 'ToGrade'
,[dbo].[TransactionsHistory].[FromPPSeriesGrade] AS 'FromPP-Series-Gr'
,[dbo].[TransactionsHistory].[ToPPSeriesGrade] AS 'ToPP-Series-Gr'
,CASE WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) ='1102' THEN 'Acquisition'
      WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4)IN ('0501','0511','0560') THEN 'Finanical Management'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) = '0201' THEN 'Human Resources'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) IN ('0391','2210','0334','0332','0335') THEN 'Information Technology'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4)= '0340' THEN 'Program Management'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) = '1176' THEN 'Property Management'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) IN ('1170','1171') THEN 'Realty'
	  ELSE 'MSO-Mission Support Occupations' END AS 'From MCO-Mission Critical Occupations'
,CASE WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) IN ('1101','1104') THEN 'Acquisition'
      WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) IN ('0080','0089') THEN 'Emergency & Security'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) IN ('0801','0802','0808','0809') THEN 'Engineering'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) IN ('0260','0360') THEN 'Equal Opportunity' 
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) IN  ('0505','0510') THEN 'Financial Management'   
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) = '0905' THEN 'General Attorney'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) = '0306' THEN 'Government Information' 
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) = '0132'  THEN 'Intelligence'  
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) = '0301' THEN 'Misc. Admin & Program'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[FromPPSeriesGrade],4,4) = '2150'  THEN 'Transportation' 
	  ELSE 'From MSO-Mission Support Occupations' END  AS 'From OCO-Organizational Critical Occupations'
,CASE WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) ='1102' THEN 'Acquisition'
      WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4)IN ('0501','0511','0560') THEN 'Finanical Management'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) = '0201' THEN 'Human Resources'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) IN ('0391','2210','0334','0332','0335') THEN 'Information Technology'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4)= '0340' THEN 'Program Management'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) = '1176' THEN 'Property Management'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) IN ('1170','1171') THEN 'Realty'
	  ELSE 'To MSO-Mission Support Occupations' END AS 'To MCO-Mission Critical Occupations'
,CASE WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) IN ('1101','1104') THEN 'Acquisition'
      WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) IN ('0080','0089') THEN 'Emergency & Security'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) IN ('0801','0802','0808','0809') THEN 'Engineering'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) IN ('0260','0360') THEN 'Equal Opportunity' 
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) IN  ('0505','0510') THEN 'Financial Management'   
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) = '0905' THEN 'General Attorney'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) = '0306' THEN 'Government Information' 
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) = '0132'  THEN 'Intelligence'  
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) = '0301' THEN 'Misc. Admin & Program'
	  WHEN SUBSTRING([dbo].[TransactionsHistory].[ToPPSeriesGrade],4,4) = '2150'  THEN 'Transportation' 
	  ELSE 'To MSO-Mission Support Occupations' END  AS 'To OCO-Organizational Critical Occupations'

,CASE WHEN [FromPosSupervisorySatusDesc] ='Non-Supervisory' THEN '8'
WHEN [FromPosSupervisorySatusDesc] ='Supervisor or Manager' THEN '2'
WHEN [FromPosSupervisorySatusDesc] = 'Supervisor (CSRA)' THEN '4'
WHEN [FromPosSupervisorySatusDesc]= 'Management Official (CSRA)' THEN '5'
WHEN [FromPosSupervisorySatusDesc] =  'Leader' THEN '6'
WHEN [FromPosSupervisorySatusDesc]=  'Team Leader' THEN '7' ELSE 'NULL' END AS 'FromSupervisoryCode'
,[FromPosSupervisorySatusDesc]
,CASE WHEN [ToSupervisoryStatusDesc] ='Non-Supervisory' THEN '8'
WHEN [ToSupervisoryStatusDesc] ='Supervisor or Manager' THEN '2'
WHEN [ToSupervisoryStatusDesc] = 'Supervisor (CSRA)' THEN '4'
WHEN [ToSupervisoryStatusDesc]= 'Management Official (CSRA)' THEN '5'
WHEN [ToSupervisoryStatusDesc] =  'Leader' THEN '6'
WHEN [ToSupervisoryStatusDesc]=  'Team Leader' THEN '7' ELSE 'NULL' END AS 'ToSupervisoryCode'
,[ToSupervisoryStatusDesc]
FROM      dbo.TransactionsHistory LEFT OUTER JOIN
                 dbo.Person ON dbo.TransactionsHistory.PersonID = dbo.Person.PersonID
--WHERE LEFT([dbo].[TransactionsHistory].[NOAC_AND_DESCRIPTION],1) LIKE '4%'--3 PLACES TO ALTER THIS QUERY

UNION --This starts the third portion of the query going against the TransactionHistoryTable

 SELECT 
      [dbo].[Transactions].[PersonID]
	  ,[dbo].[Transactions].[FYDESIGNATION]
	 , [dbo].[Person].[SSN]
	  ,[dbo].[Person].LastName + ', ' + [dbo].[Person].FirstName + ' ' + IsNull([dbo].[Person].MiddleName, '') AS FullName
      ,[dbo].[Transactions].[ProcessedDate]
	  ,[dbo].[Transactions].[EffectiveDate]
	  ,[dbo].[Transactions].[NOAC_AND_DESCRIPTION]
	  , CASE WHEN [VeteransPreferenceDesc] = 'None' THEN '1'
WHEN [dbo].[Transactions].[VeteransPreferenceDesc] = '5-point' THEN '2'
WHEN [dbo].[Transactions].[VeteransPreferenceDesc]  = '10-point/disability' THEN '3'
WHEN [dbo].[Transactions].[VeteransPreferenceDesc]  = '10-POINT/COMPENSABLE' THEN'4'
WHEN [dbo].[Transactions].[VeteransPreferenceDesc]  = '10-point/other' THEN '5'
WHEN [dbo].[Transactions].[VeteransPreferenceDesc] = '10-point/compensable/30 percent' THEN '6'
WHEN [dbo].[Transactions].[VeteransPreferenceDesc] = 'Sole Survivorship Preference eligible' THEN '7'
ELSE 'NULL' END AS  'VeteransPreferenceCode'
	  ,[dbo].[Transactions].[VeteransPreferenceDesc]
,[dbo].[Transactions].[FirstActionLACode1]
,[dbo].[Transactions].[FirstActionLACode2]
,[dbo].[Person].[BirthDate]
,[dbo].[Person].[RNOCode]
,[dbo].[Person].[RNODescription]
,CASE WHEN [dbo].[Person].[GenderDescription] ='Female' THEN 'F'
WHEN [dbo].[Person].[GenderDescription] ='Male' THEN 'M' else ' ' END AS 'Gender'
,[dbo].[Transactions].[DutyStationNameandStateCountry] AS 'DutyStationNameandState'
,[dbo].[Transactions].[ToRegion] AS 'OwningRegion'
,[dbo].[Transactions].[ToServicingRegion] AS 'ServingRegion'
,[dbo].[Person].[HandicapCode]
,[dbo].[Person].[HandicapCodeDescription]
,[dbo].[Transactions].[FromOfficeSymbol]
,[dbo].[Transactions].[ToOfficeSymbol]
,CASE WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS01' THEN 'IOA'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS02' THEN 'OAS'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS03' THEN 'PBS'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS04' THEN 'OCR'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS10' THEN 'SBU'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS11' THEN 'OCFO'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS12' THEN 'OGC'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS13' THEN 'CBCA'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS14' THEN 'OHRM/OCPO'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS15' THEN 'OIG'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS16' THEN 'OCAO'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS18' THEN 'TTS'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS19' THEN 'OCSIT'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS20' THEN 'OCIA'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS22' THEN 'ORA'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS24' THEN 'FAS/FSS'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS26' THEN 'OCP'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS27' THEN 'FAS/FTS'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS28' THEN 'OCIO/GSAIT'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS29' THEN 'ChildCare'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS30' THEN 'FAS'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS31' THEN 'OERR/OMA'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS32' THEN 'OCM/OSC'
WHEN [dbo].[Transactions].[FromPositionAgencyCodeSubelement] ='GS33' THEN 'OCE'
ELSE ' ' END AS 'FromHSSO'
,CASE WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS01' THEN 'IOA'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS02' THEN 'OAS'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS03' THEN 'PBS'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS04' THEN 'OCR'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS10' THEN 'SBU'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS11' THEN 'OCFO'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS12' THEN 'OGC'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS13' THEN 'CBCA'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS14' THEN 'OHRM/OCPO'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS15' THEN 'OIG'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS16' THEN 'OCAO'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS18' THEN 'TTS'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS19' THEN 'OCSIT'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS20' THEN 'OCIA'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS22' THEN 'ORA'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS24' THEN 'FAS/FSS'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS26' THEN 'OCP'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS27' THEN 'FAS/FTS'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS28' THEN 'OCIO/GSAIT'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS29' THEN 'ChildCare'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS30' THEN 'FAS'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS31' THEN 'OERR/OMA'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS32' THEN 'OCM/OSC'
WHEN [dbo].[Transactions].[ToPositionAgencyCodeSubelement] ='GS33' THEN 'OCE'
ELSE ' ' END AS 'ToHSSO'
,[dbo].[Transactions].[WhatKindofMovement] AS 'WhatKindofMovement?'
,[dbo].[Transactions].[FromPositionTitle]
,[dbo].[Transactions].[ToPositionTitle]
,LEFT([dbo].[Transactions].[FromPPSeriesGrade],2) AS 'FromPP'
,LEFT([dbo].[Transactions].[ToPPSeriesGrade],2) AS 'ToPP'
,SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) AS 'FromSeries'
,SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) AS 'ToSeries'
,RIGHT([dbo].[Transactions].[FromPPSeriesGrade],2) AS 'FromGrade'
,RIGHT([dbo].[Transactions].[ToPPSeriesGrade],2) AS 'ToGrade'
,[dbo].[Transactions].[FromPPSeriesGrade] AS 'FromPP-Series-Gr'
,[dbo].[Transactions].[ToPPSeriesGrade] AS 'ToPP-Series-Gr'
,CASE WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) ='1102' THEN 'Acquisition'
      WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4)IN ('0501','0511','0560') THEN 'Finanical Management'
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) = '0201' THEN 'Human Resources'
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) IN ('0391','2210','0334','0332','0335') THEN 'Information Technology'
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4)= '0340' THEN 'Program Management'
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) = '1176' THEN 'Property Management'
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) IN ('1170','1171') THEN 'Realty'
	  ELSE 'MSO-Mission Support Occupations' END AS 'From MCO-Mission Critical Occupations'
,CASE WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) IN ('1101','1104') THEN 'Acquisition'
      WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) IN ('0080','0089') THEN 'Emergency & Security'
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) IN ('0801','0802','0808','0809') THEN 'Engineering'
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) IN ('0260','0360') THEN 'Equal Opportunity' 
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) IN  ('0505','0510') THEN 'Financial Management'   
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) = '0905' THEN 'General Attorney'
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) = '0306' THEN 'Government Information' 
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) = '0132'  THEN 'Intelligence'  
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) = '0301' THEN 'Misc. Admin & Program'
	  WHEN SUBSTRING([dbo].[Transactions].[FromPPSeriesGrade],4,4) = '2150'  THEN 'Transportation' 
	  ELSE 'From MSO-Mission Support Occupations' END  AS 'From OCO-Organizational Critical Occupations'
,CASE WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) ='1102' THEN 'Acquisition'
      WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4)IN ('0501','0511','0560') THEN 'Finanical Management'
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) = '0201' THEN 'Human Resources'
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) IN ('0391','2210','0334','0332','0335') THEN 'Information Technology'
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4)= '0340' THEN 'Program Management'
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) = '1176' THEN 'Property Management'
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) IN ('1170','1171') THEN 'Realty'
	  ELSE 'To MSO-Mission Support Occupations' END AS 'To MCO-Mission Critical Occupations'
,CASE WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) IN ('1101','1104') THEN 'Acquisition'
      WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) IN ('0080','0089') THEN 'Emergency & Security'
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) IN ('0801','0802','0808','0809') THEN 'Engineering'
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) IN ('0260','0360') THEN 'Equal Opportunity' 
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) IN  ('0505','0510') THEN 'Financial Management'   
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) = '0905' THEN 'General Attorney'
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) = '0306' THEN 'Government Information' 
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) = '0132'  THEN 'Intelligence'  
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) = '0301' THEN 'Misc. Admin & Program'
	  WHEN SUBSTRING([dbo].[Transactions].[ToPPSeriesGrade],4,4) = '2150'  THEN 'Transportation' 
	  ELSE 'To MSO-Mission Support Occupations' END  AS 'To OCO-Organizational Critical Occupations'

,CASE WHEN [FromPosSupervisorySatusDesc] ='Non-Supervisory' THEN '8'
WHEN [FromPosSupervisorySatusDesc] ='Supervisor or Manager' THEN '2'
WHEN [FromPosSupervisorySatusDesc] = 'Supervisor (CSRA)' THEN '4'
WHEN [FromPosSupervisorySatusDesc]= 'Management Official (CSRA)' THEN '5'
WHEN [FromPosSupervisorySatusDesc] =  'Leader' THEN '6'
WHEN [FromPosSupervisorySatusDesc]=  'Team Leader' THEN '7' ELSE 'NULL' END AS 'FromSupervisoryCode'
,[FromPosSupervisorySatusDesc]
,CASE WHEN [ToSupervisoryStatusDesc] ='Non-Supervisory' THEN '8'
WHEN [ToSupervisoryStatusDesc] ='Supervisor or Manager' THEN '2'
WHEN [ToSupervisoryStatusDesc] = 'Supervisor (CSRA)' THEN '4'
WHEN [ToSupervisoryStatusDesc]= 'Management Official (CSRA)' THEN '5'
WHEN [ToSupervisoryStatusDesc] =  'Leader' THEN '6'
WHEN [ToSupervisoryStatusDesc]=  'Team Leader' THEN '7' ELSE 'NULL' END AS 'ToSupervisoryCode'
,[ToSupervisoryStatusDesc]
FROM      dbo.Transactions LEFT OUTER JOIN
                 dbo.Person ON dbo.Transactions.PersonID = dbo.Person.PersonID
--WHERE LEFT([dbo].[Transactions].[NOAC_AND_DESCRIPTION],1) LIKE '4%'--3 PLACES TO ALTER THIS QUERY
AND [Transactions].RUNDATE = 
 (SELECT MAX(RUNDATE) FROM dbo.Transactions)--This is how you select most current information from Transactions
        

--ORDER BY [EffectiveDate] ASC

GO
