USE [HRDW]
GO
/****** Object:  View [Performance].[vALPHAORG_WITHEXEmps_YearlyPerformance]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [Performance].[vALPHAORG_WITHEXEmps_YearlyPerformance] AS
SELECT [dbo].[vAlphaOrgRoster-with-ExEmployees].RecordDate
, [dbo].[vAlphaOrgRoster-with-ExEmployees].FullName
, [dbo].[vAlphaOrgRoster-with-ExEmployees].[EmailAddress]
, [dbo].[vAlphaOrgRoster-with-ExEmployees].[Position_Supervisor]
, [dbo].[vAlphaOrgRoster-with-ExEmployees].[Supervisor_Email]
, [dbo].[vAlphaOrgRoster-with-ExEmployees].[LatestHireDate]
, [dbo].[vAlphaOrgRoster-with-ExEmployees].[LatestSeparationDate]
, [dbo].[vAlphaOrgRoster-with-ExEmployees].OfficeSymbol
, [dbo].[vAlphaOrgRoster-with-ExEmployees].OfficeSymbol2Char
, [dbo].[vAlphaOrgRoster-with-ExEmployees].[DutyStationName]
, [dbo].[vAlphaOrgRoster-with-ExEmployees].[DutyStationCounty]
, [dbo].[vAlphaOrgRoster-with-ExEmployees].[DutyStationState]
, [dbo].[vAlphaOrgRoster-with-ExEmployees].[RegionBasedOnDutyStation]
, [dbo].[vAlphaOrgRoster-with-ExEmployees].PositionEncumberedType
, [dbo].[vAlphaOrgRoster-with-ExEmployees].PositionTitle
, [dbo].[vAlphaOrgRoster-with-ExEmployees].PPSeriesGrade
, [dbo].[vAlphaOrgRoster-with-ExEmployees].HSSO
, [dbo].[vAlphaOrgRoster-with-ExEmployees].SupervisoryStatusDesc
, [dbo].[vAlphaOrgRoster-with-ExEmployees].SupervisoryStatusCode
, [dbo].[vAlphaOrgRoster-with-ExEmployees].BargainingUnitStatusDescription
, [dbo].[vAlphaOrgRoster-with-ExEmployees].BargainingUnitOrg
, Performance.vAnnualPerformance.AppraisalTypeDescription
, Performance.vAnnualPerformance.AppraisalStatus
, Performance.vAnnualPerformance.FY2005
, Performance.vAnnualPerformance.FY2006
, Performance.vAnnualPerformance.FY2007
, Performance.vAnnualPerformance.FY2008
, Performance.vAnnualPerformance.FY2009
, Performance.vAnnualPerformance.FY2010
, Performance.vAnnualPerformance.FY2011
, Performance.vAnnualPerformance.FY2012
, Performance.vAnnualPerformance.FY2013
, Performance.vAnnualPerformance.FY2014
, Performance.vAnnualPerformance.FY2015
, Performance.vAnnualPerformance.FY2016
, Performance.vAnnualPerformance.FY2017
, Performance.vAnnualPerformance.FY2018
FROM     [dbo].[vAlphaOrgRoster-with-ExEmployees] LEFT OUTER JOIN
                  Performance.vAnnualPerformance ON [dbo].[vAlphaOrgRoster-with-ExEmployees].PersonID = Performance.vAnnualPerformance.PersonID






GO
