USE [HRDW]
GO
/****** Object:  View [REPORTING].[vCLP_CareerLadder]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--Query Name = CLP-Career Ladder Report
--Created by Ralph Silvestro
--This only pulls Current Employees whose Current Grade Level is less than their FPL or Target Grade
--Also Note Theoretically Earliest to Promote-Not Automatic'--add 1 year to Dte Last Promotion

CREATE VIEW [REPORTING].[vCLP_CareerLadder] AS



SELECT 'Safeguard PII' AS 'PII'
      ,DB_NAME() AS [Database]
	  ,[RecordDate]  AS 'Recd Dte'
      ,[Employee_LN] AS 'Last Name'
	  ,[Employee_FN] AS 'First Name'
	  ,CASE WHEN [Employee_MN] IS NULL THEN ' ' ELSE [Employee_MN] END AS 'Middle Name'
	  ,[FullName] AS 'Full Name'
	  ,[Position_Supervisor] AS 'Posn Supv'
	  ,[Supervisor_Email] AS 'Supv Email'
	  ,[PersonnelOfficeDescription] AS 'POID Desc'
	  ,[Region]AS 'Region'
	  ,[RegionBasedOnDutyStation] AS 'Rgn based on Duty Station'
	  ,[OwningRegion] AS 'Owning'
	  ,[ServicingRegion] AS 'Servicing'
	  ,[ArrivedPersonnelOffice] AS 'Dte Arrive HR Ofc'
	  ,[ArrivedPresentPosition] AS 'Dte Arrive Present Posn'
	  ,[ArrivedPresentGrade]AS 'Dte Arrive Present Grade'
	  ,[DateLastPromotion] AS 'Date Last Promo'
	  ,DATEADD(yy,1,[DateLastPromotion]) AS 'Theoretically Earliest to Promote-Not Automatic'--add 1 year to Dte Last Promotion
	  ,[LatestHireDate] AS 'Late Hire Dte'
	  ,[EmployeeNumber] AS 'Emp Num'
	  ,[PositionControlNumber] AS 'PCN'
	  ,[PositionControlIndicator] AS 'PCN Indicator'
	  ,[PositionInformationPD] AS 'PD Num'
      ,[PositionSequenceNumber] AS 'Posn Seq Num'
	  ,[PositionInformationPD] + CAST([PositionSequenceNumber] AS CHAR(3)) AS 'PD Num + Seq'
	  ,[PositionTitle] AS 'Title'
	  ,CASE WHEN [OrgLongName] IS NULL THEN ' ' ELSE [OrgLongName] END  AS 'Org Long Name'
	  ,[HSSO] AS 'HSSO'
	  ,[SsoAbbreviation] AS 'HSSO Abrev'
	  ,[OccupationalSeriesDescription]  AS 'Occup Series Desc'
	  ,[SupervisoryStatusDesc] AS 'Supv Status Desc'
	  ,[AppointmentType] AS 'Appt Type'
	  ,[OfficeSymbol] AS 'Ofc Sym'
	  ,[OfficeSymbol2Char] AS '2 Letter'
	  ,[OrgCodeBudgetFinance]
	  ,LEFT ([PPSeriesGrade],2) AS 'Valid PP'
	  ,SUBSTRING ([PPSeriesGrade],4,4) AS 'Series'
	  ,RIGHT([PPSeriesGrade],2) AS 'Valid Grade'
      ,[TargetGradeOrLevel] AS 'Target Grd or FPL'
	  ,[PPSeriesGrade]AS 'PP-Series-Gr'
	  ,[DutyStationName] AS 'DS Name'
	  ,[DutyStationCounty] AS 'DS County'
	  ,[DutyStationState] AS 'DS State or Country'
	  ,[MCO] AS 'MCO'
	  FROM [dbo].[vAlphaOrgRoster-PII]
	  WHERE RIGHT([PPSeriesGrade],2) < [TargetGradeOrLevel]--Only Pulls Emps whose Current Grade is less than FPL or Traget Grade
	--  ORDER BY [FullName] ASC
	  


GO
