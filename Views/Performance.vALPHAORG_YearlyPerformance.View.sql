USE [HRDW]
GO
/****** Object:  View [Performance].[vALPHAORG_YearlyPerformance]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [Performance].[vALPHAORG_YearlyPerformance] AS
SELECT dbo.[vAlphaOrgRoster-PII].RecordDate
, dbo.[vAlphaOrgRoster-PII].FullName
, dbo.[vAlphaOrgRoster-PII].[EmailAddress]
, dbo.[vAlphaOrgRoster-PII].[Position_Supervisor]
, dbo.[vAlphaOrgRoster-PII].[Supervisor_Email]
, dbo.[vAlphaOrgRoster-PII].[LatestHireDate]
, dbo.[vAlphaOrgRoster-PII].OfficeSymbol
, dbo.[vAlphaOrgRoster-PII].OfficeSymbol2Char
, dbo.[vAlphaOrgRoster-PII].[DutyStationName]
, dbo.[vAlphaOrgRoster-PII].[DutyStationCounty]
, dbo.[vAlphaOrgRoster-PII].[DutyStationState]
, dbo.[vAlphaOrgRoster-PII].PositionEncumberedType
, dbo.[vAlphaOrgRoster-PII].PositionTitle
, dbo.[vAlphaOrgRoster-PII].PPSeriesGrade
, dbo.[vAlphaOrgRoster-PII].HSSO
, dbo.[vAlphaOrgRoster-PII].SupervisoryStatusDesc
, dbo.[vAlphaOrgRoster-PII].SupervisoryStatusCode
, dbo.[vAlphaOrgRoster-PII].BargainingUnitStatusDescription
, dbo.[vAlphaOrgRoster-PII].BargainingUnitOrg
,dbo.[vAlphaOrgRoster-PII].[RegionBasedOnOfficeSymbol]
,dbo.[vAlphaOrgRoster-PII].[OwningRegion]
,dbo.[vAlphaOrgRoster-PII].[ServicingRegion]
,dbo.[vAlphaOrgRoster-PII].[RegionBasedOnDutyStation]
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
FROM     dbo.[vAlphaOrgRoster-PII] LEFT OUTER JOIN
                  Performance.vAnnualPerformance ON dbo.[vAlphaOrgRoster-PII].PersonID = Performance.vAnnualPerformance.PersonID






GO
