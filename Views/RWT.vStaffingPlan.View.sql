USE [HRDW]
GO
/****** Object:  View [RWT].[vStaffingPlan]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [RWT].[vStaffingPlan]
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-03-13  
-- Description: Staffing Plan Report
-- =============================================================================
AS
SELECT 
  Divisions.Org
, [Recruit Actions].[RPA#]
, [Recruit Actions].[Status]
, [Recruit Actions].[Status Date]
, CASE
	WHEN [Recruit Actions].[Selectee Last Name] IS NULL 
		 AND 
		 [Recruit Actions].[Selectee First Name] IS NULL
	THEN ''
	ELSE ISNULL([Recruit Actions].[Selectee Last Name],'') 
			+ ', ' + ISNULL([Recruit Actions].[Selectee First Name],'') 
  END AS [Selectee Name]
, [Posn Mgmt].[Office Symbol]
, [Posn Mgmt].[Position Control Number]
, [Posn Mgmt].[Position Control Number Indicator]
, [Posn Mgmt].[Position Title]
, [Posn Mgmt].[PD Number]
, [Posn Mgmt].[PP-Series-Grade]
, [Posn Mgmt].[Target Grade Or Level]
, [Posn Mgmt].[Supervisory Status Code]
, [Posn Mgmt].[Flsa Category Code]
, [Posn Mgmt].[Reporting to PCN]
, [Posn Mgmt].[Reporting to PCN Indicator]
, [Posn Mgmt].[Reporting to Position Office Symbol]
, [Posn Mgmt].[Position Encumbered Type]
, [Posn Mgmt].[Employee Number]
, [Posn Mgmt].[Full Name]
, [Posn Mgmt].[Position Obligated?]
, [Posn Mgmt].[Obligated Employee Full Name]
, [Posn Mgmt].[Position Detailed?]
, [Posn Mgmt].[Detailed Employee Full Name]
, [Posn Mgmt].[Funding Status]
, [Posn Mgmt].[Funding Full Time Equivalent]
, [Posn Mgmt].[Available for Hiring?]
, [Posn Mgmt].[Bargaining Unit Status Code]
, [Posn Mgmt].[Supervisor Employee Number]
, [Posn Mgmt].[Personnel Office ID Code]
, [Posn Mgmt].[Duty Station Name]
, [states].[Abbr] AS [Duty State]
, [Posn Mgmt].[Supervisory Status Description]
, [Posn Mgmt].[Supervisor First Name]
, [Posn Mgmt].[Supervisor Middle Name]
, [Posn Mgmt].[Supervisor Last Name]
, [Posn Mgmt].[Appropriation Code 1]
, [Posn Mgmt].[Block Number Code]

FROM 
	RWT.[Posn Mgmt] 
	LEFT OUTER JOIN RWT.Divisions 
		ON [Posn Mgmt].[Office Symbol] = Divisions.[Office Symbol]
	LEFT OUTER JOIN RWT.[Recruit Actions] 
		ON (
		   [Posn Mgmt].[Position Control Number Indicator] = [Recruit Actions].[PCN Ind] 
		   AND 
		   [Posn Mgmt].[Position Control Number] = [Recruit Actions].PCN
		   )
		   AND
		   (
		   LEFT([Recruit Actions].Status,1) <> '2' 
		   OR
		   (
		   [Recruit Actions].Status Like '20-Closed-Employee EOD%'
		   AND 
		   [Recruit Actions].[Status Date] > GETDATE()-14
		   )
		   )

	LEFT OUTER JOIN RWT.States 
		ON [Posn Mgmt].[Duty Station State or Country Desc] = States.State


GO
