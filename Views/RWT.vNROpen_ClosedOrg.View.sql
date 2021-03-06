USE [HRDW]
GO
/****** Object:  View [RWT].[vNROpen_ClosedOrg]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [RWT].[vNROpen_ClosedOrg]
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-03-13  
-- Description: Open Non-Recruits Report
-- =============================================================================
AS
SELECT
  CASE 
    WHEN [Rec'd in HR] Is Null
    THEN ''
    WHEN [RPA Cancelled] Is Not Null
    THEN 'RPA Cancelled'
    WHEN [To CPC for Proc] Is Not Null
    THEN 'Sent to CPC for Processing'
    ELSE 'RPA Received'
  END AS Status
, CASE
    WHEN [Rec'd in HR] Is Null
    THEN ''
    WHEN [RPA Cancelled] Is Not Null
    THEN FORMAT([RPA Cancelled], 'd', 'en-US') 
    WHEN [To CPC for Proc] Is Not Null
    THEN FORMAT([To CPC for Proc], 'd', 'en-US')
    ELSE FORMAT([Rec'd in HR], 'd', 'en-US')
  END AS [Status Date]
, FORMAT([Eff Date], 'd', 'en-US') AS [Eff Date]
, CASE
    WHEN [RPA Cancelled] Is Not Null
    THEN ''
    WHEN [To CPC for Proc] Is Null 
    THEN DATEDIFF(dd, GETDATE(), [rec'd in hr])
    ELSE DATEDIFF(dd, [rec'd in hr], [To CPC for Proc])
  END AS Age
, Center
, [HR Consultant]
, [RPA#]
, Org
, [NonRecruit Type]
, Employee
, FORMAT([Rec'd in HR], 'd', 'en-US') AS [Rec'd in HR]
, FORMAT([To CPC for Proc], 'd', 'en-US') AS [To CPC for Proc]
, FORMAT([RPA Cancelled], 'd', 'en-US') AS [RPA Cancelled]
, [Comments/Notes]
FROM RWT.[NonRecruit Actions]

GO
