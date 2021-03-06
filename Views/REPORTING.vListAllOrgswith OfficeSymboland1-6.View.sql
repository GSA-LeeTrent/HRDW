USE [HRDW]
GO
/****** Object:  View [REPORTING].[vListAllOrgswith OfficeSymboland1-6]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [REPORTING].[vListAllOrgswith OfficeSymboland1-6]
AS 
--Note the request as stated would also include GS27 besides GS30
--Involves unioned result between  [dbo].[vAlphaOrgRoster-PII-with-ExEmp] and [dbo].[vVacantPositions]
SELECT DISTINCT
[PosOrgAgySubelementCode]
,[OfficeSymbol]
,[OfficeSymbol2Char]
,[PosAddressOrgInfoLine1]
,[PosAddressOrgInfoLine2]
,[PosAddressOrgInfoLine3]
,[PosAddressOrgInfoLine4]
,[PosAddressOrgInfoLine5]
,[PosAddressOrgInfoLine6]
,[OrgLongName]
FROM [dbo].[vAlphaOrgRoster-PII-with-ExEmp]
WHERE [PosOrgAgySubelementCode] IN ('GS30','GS27')
UNION
SELECT DISTINCT
[PosOrgAgySubelementCode]
,[OfficeSymbol]
,[OfficeSymbol2Char]
,[PosAddressOrgInfoLine1]
,[PosAddressOrgInfoLine2]
,[PosAddressOrgInfoLine3]
,[PosAddressOrgInfoLine4]
,[PosAddressOrgInfoLine5]
,[PosAddressOrgInfoLine6]
,[OrgLongName]
FROM [dbo].[vVacantPositions]
WHERE [PosOrgAgySubelementCode] IN ('GS30','GS27')

GO
