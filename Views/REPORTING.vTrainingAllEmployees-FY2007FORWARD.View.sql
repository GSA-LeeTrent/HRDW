USE [HRDW]
GO
/****** Object:  View [REPORTING].[vTrainingAllEmployees-FY2007FORWARD]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [REPORTING].[vTrainingAllEmployees-FY2007FORWARD]
AS
SELECT dbo.[vAlphaOrgRoster-Regular-Plus].RecordDate
     , dbo.[vAlphaOrgRoster-Regular-Plus].[PersonID]
     , dbo.[vAlphaOrgRoster-Regular-Plus].FullName
	 , dbo.[vAlphaOrgRoster-Regular-Plus].LatestHireDate
	 , dbo.[vAlphaOrgRoster-Regular-Plus].HSSO
	 , dbo.[vAlphaOrgRoster-Regular-Plus].SsoAbbreviation
	 , dbo.[vAlphaOrgRoster-Regular-Plus].OfficeSymbol
	 , dbo.[vAlphaOrgRoster-Regular-Plus].PPSeriesGrade
	 , dbo.[vAlphaOrgRoster-Regular-Plus].PositionTitle
	 , dbo.[vAlphaOrgRoster-Regular-Plus].OfficeSymbol2Char
     , dbo.[vAlphaOrgRoster-Regular-Plus].EmailAddress
     , dbo.TssTDS.TrainingTitle AS [Training Title]
	 , dbo.TssTDS.CourseCompletionDate AS [Course Completion Date]
	 , dbo.TssTDS.CourseStartDate AS [Course Start Date]
	 , dbo.TssTDS.FiscalYear AS [Fiscal Year]
	 , dbo.TssTDS.NonDutyHours AS [Non Duty Hrs]
	 , dbo.TssTDS.DutyHours AS [Duty Hours]
	 , dbo.TssTDS.VendorName AS Vendor
	 , dbo.TssTDS.SourceType AS [Source Type]
	 , dbo.TssTDS.TrainingDeliveryTypeDesc AS [Train Delivery Type Desc]
	 , dbo.TssTDS.TrainingPurposeDesc AS [Train Purpose Desc]
	 , dbo.TssTDS.TrainingSourceDesc AS [Train Source Desc]
	 , dbo.TssTDS.TrainingSubTypeDesc AS [Train Sub Type Desc]
	 , dbo.TssTDS.TrainingTypeDesc AS [Train Type Desc]
	 FROM [dbo].[TssTDS]
	 JOIN [dbo].[vAlphaOrgRoster-Regular-Plus] ON [dbo].[vAlphaOrgRoster-Regular-Plus].PersonID = dbo.TssTDS.[PersonID]
	 WHERE CourseCompletionDate >='2006-10-01' --FY2007 FORWARD
	 
	 UNION
	 SELECT dbo.[vAlphaOrgRoster-Regular-Plus].RecordDate
	 , dbo.[vAlphaOrgRoster-Regular-Plus].[PersonID]
     , dbo.[vAlphaOrgRoster-Regular-Plus].FullName
	 , dbo.[vAlphaOrgRoster-Regular-Plus].LatestHireDate
	 , dbo.[vAlphaOrgRoster-Regular-Plus].HSSO
	 , dbo.[vAlphaOrgRoster-Regular-Plus].SsoAbbreviation
	 , dbo.[vAlphaOrgRoster-Regular-Plus].OfficeSymbol
	 , dbo.[vAlphaOrgRoster-Regular-Plus].PPSeriesGrade
     , dbo.[vAlphaOrgRoster-Regular-Plus].PositionTitle
	 , dbo.[vAlphaOrgRoster-Regular-Plus].OfficeSymbol2Char
	 , dbo.[vAlphaOrgRoster-Regular-Plus].EmailAddress
     , dbo.TssTDSHistory.TrainingTitle AS [Training Title]
	 , dbo.TssTDSHistory.CourseCompletionDate AS [Course Completion Date]
	 , dbo.TssTDSHistory.CourseStartDate AS [Course Start Date]
	 , dbo.TssTDSHistory.FiscalYear AS [Fiscal Year]
	 , dbo.TssTDSHistory.NonDutyHours AS [Non Duty Hrs]
	 , dbo.TssTDSHistory.DutyHours AS [Duty Hours]
	 , dbo.TssTDSHistory.VendorName AS Vendor
	 , dbo.TssTDSHistory.SourceType AS [Source Type]
	 , dbo.TssTDSHistory.TrainingDeliveryTypeDesc AS [Train Delivery Type Desc]
	 , dbo.TssTDSHistory.TrainingPurposeDesc AS [Train Purpose Desc]
	 , dbo.TssTDSHistory.TrainingSourceDesc AS [Train Source Desc]
	 , dbo.TssTDSHistory.TrainingSubTypeDesc AS [Train Sub Type Desc]
	 , dbo.TssTDSHistory.TrainingTypeDesc AS [Train Type Desc]
	 FROM [dbo].[TssTDSHistory]
	 JOIN [dbo].[vAlphaOrgRoster-Regular-Plus] ON [dbo].[vAlphaOrgRoster-Regular-Plus].PersonID = dbo.TssTDSHistory.[PersonID]
	 WHERE CourseCompletionDate >='2006-10-01' --FY2007 FORWARD
	 
	
	       




GO
