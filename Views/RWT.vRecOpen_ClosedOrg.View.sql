USE [HRDW]
GO
/****** Object:  View [RWT].[vRecOpen_ClosedOrg]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE VIEW [RWT].[vRecOpen_ClosedOrg]
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-03-13  
-- Description: Open Recruits Report
-- =============================================================================
AS

SELECT 
  [Recruit Actions].ID
, [Recruit Actions].Status
, [Recruit Actions].Org
, [Recruit Actions].Center
, [Recruit Actions].[Status Date]
, CASE
  WHEN [HR Consultant] Is Null
      THEN '-No Consultant'
  ELSE [HR Consultant]
  END AS [HR A]
, CASE
  WHEN [status] Is Null
      THEN '00-Blank Status'
  ELSE [status]
  END AS StatusA
, CASE
  WHEN [Eff Date] Is Not Null
      THEN [Eff Date]-[RPA Sent to Staffing]
  WHEN [Retd Due to Inactivity] Is Not Null
      THEN NULL
  WHEN [RPA Cancelled] Is Not Null
      THEN NULL
  WHEN [RPA Sent to Staffing] Is Null
      THEN NULL
  ELSE 
      GETDATE() - [RPA Sent to Staffing]
  END AS RecruitAge
, [Recruit Actions].[RPA#]
, [Recruit Actions].[HR Consultant]
, [Recruit Actions].[Type of Selection]
, [Recruit Actions].[NRC Consultant]
, [Recruit Actions].[Customer POC]
, [Recruit Actions].PCN
, [Recruit Actions].[PCN Ind]
, [Recruit Actions].[Org Code]
, [Recruit Actions].[PD#]
, [Recruit Actions].[Position Title]
, [Recruit Actions].[PP-Ser-Gr]
, [Recruit Actions].FPL
, [Recruit Actions].[Supv Code]
, [Recruit Actions].[Duty Station]
, [Recruit Actions].[Investigation Type]
, [Recruit Actions].HiringAuthority
, [Recruit Actions].[Recruit for Multiple]
, CASE
	WHEN [Selectee Last Name] IS NULL AND [Selectee First Name] IS NULL
	THEN ''
	ELSE ISNULL([Selectee Last Name],'') + ', ' + ISNULL([Selectee First Name],'') 
  END AS Selectee
, [Recruit Actions].[Vac Annct #]
, [Recruit Actions].[Rec Incentive]
, [Recruit Actions].Comments
, [Recruit Actions].[RPA Sent to NCC]
, [Recruit Actions].[RPA Sent to Staffing]
, [Recruit Actions].[RPA Sent to NRC]
, [Recruit Actions].[Strategic Conversation Held]
, [Recruit Actions].[JA Sent to Mgr]
, [Recruit Actions].[Mgr Approved JA]
, [Recruit Actions].[Draft Vac Sent to Mgr]
, [Recruit Actions].[Draft Vac Apprvd by Mgr]
, [Recruit Actions].[Annct Opened]
, [Recruit Actions].[Annct Closed]
, [Recruit Actions].[First Cert Issued]
, [Recruit Actions].[Applicants Notified]
, [Recruit Actions].[Last Cert Issued]
, [Recruit Actions].[Cert Expires]
, [Recruit Actions].[Mgr Retd Cert]
, [Recruit Actions].[Tentative Offer Made]
, [Recruit Actions].[Pkg sent to Security]
, [Recruit Actions].[Initial Access Recd]
, [Recruit Actions].[Final Offer Made]
, [Recruit Actions].[Final Offer Accepted]
, [Recruit Actions].[Sent to CPC]
, [Recruit Actions].[Eff Date]
, [Recruit Actions].[RPA Cancelled]
, [Recruit Actions].[Retd Due to Inactivity]
, CASE
  WHEN DATEDIFF(DAY,[RPA Sent to Staffing],[Strategic Conversation Held]) <= 0
  THEN 0.5
  ELSE DATEDIFF(DAY,[RPA Sent to Staffing],[Strategic Conversation Held])
  END AS [SLA02-Rec in Staff TO Strategic Conv]
, CASE
  WHEN DATEDIFF(DAY,[RPA Sent to Staffing],[Annct Opened]) <= 0
  THEN 0.5
  ELSE DATEDIFF(DAY,[RPA Sent to Staffing],[Annct Opened])
  END AS [SLA03-Rec in Staff TO Ann Open]
, CASE
  WHEN [Recruit for Multiple]='N'
       AND 
	   DATEDIFF(DAY,[Annct Closed],[First Cert Issued]) <= 0
  THEN 0.5
  WHEN [Recruit for Multiple]='N'
       AND 
	   DATEDIFF(DAY,[Annct Closed],[First Cert Issued]) > 0
  THEN DATEDIFF(DAY,[Annct Closed],[First Cert Issued])
  ELSE NULL
  END AS [SLA05-Ann Close TO Cert Issue-Single]
, CASE
  WHEN [Recruit for Multiple]='Y'
       AND 
	   DATEDIFF(DAY,[Annct Closed],[First Cert Issued]) <= 0
  THEN 0.5
  WHEN [Recruit for Multiple]='Y'
       AND 
	   DATEDIFF(DAY,[Annct Closed],[First Cert Issued]) > 0
  THEN DATEDIFF(DAY,[Annct Closed],[First Cert Issued])
  ELSE NULL
  END AS [SLA06-Ann Close TO Cert Issue-Multiple]
, CASE
  WHEN DATEDIFF(DAY,[First Cert Issued],[Applicants Notified]) <= 0
  THEN 0.5
  ELSE DATEDIFF(DAY,[First Cert Issued],[Applicants Notified])
  END AS [SLA0A-Cert Issue TO App Notified]
, CASE
  WHEN DATEDIFF(DAY,[First Cert Issued],[Mgr Retd Cert]) <= 0
  THEN 0.5
  ELSE DATEDIFF(DAY,[First Cert Issued],[Mgr Retd Cert])
  END AS [SLA08-Cert Issue TO Mgr Ret Cert]
, CASE
  WHEN DATEDIFF(DAY,[Mgr Retd Cert],[Tentative Offer Made]) <= 0
  THEN 0.5
  ELSE DATEDIFF(DAY,[Mgr Retd Cert],[Tentative Offer Made])
  END AS [SLA09-Mgr Ret Cert TO Tent Offer Made]
, CASE
  WHEN DATEDIFF(DAY,[Mgr Retd Cert],[Initial Access Recd]) <= 0
  THEN 0.5
  ELSE DATEDIFF(DAY,[Mgr Retd Cert],[Initial Access Recd])
  END AS [SLA0B-Mgr Ret Cert TO Initial Access]
, CASE
  WHEN DATEDIFF(DAY,[Initial Access Recd],[Final Offer Made]) <= 0
  THEN 0.5
  ELSE DATEDIFF(DAY,[Initial Access Recd],[Final Offer Made])
  END AS [SLA10-Initial Access TO Final Offer Made]
, CASE
  WHEN DATEDIFF(DAY,[Final Offer Accepted],[Eff Date]) <= 0
  THEN 0.5
  ELSE DATEDIFF(DAY,[Final Offer Accepted],[Eff Date])
  END AS [SLA11-Final Offer Accept TO EOD]
, CASE
  WHEN DATEDIFF(DAY,[RPA Sent to Staffing],[Tentative Offer Made]) <= 0
  THEN 0.5
  ELSE DATEDIFF(DAY,[RPA Sent to Staffing],[Tentative Offer Made])
  END AS [SLA13-RPA Rec TO Tent Offer Made]
, CASE
  WHEN DATEDIFF(DAY,[RPA Sent to Staffing],[Eff Date]) <= 0
  THEN 0.5
  ELSE DATEDIFF(DAY,[RPA Sent to Staffing],[Eff Date])
  END AS [SLA14-RPA Rec TO EOD]
FROM 
	RWT.[Recruit Actions]






GO
