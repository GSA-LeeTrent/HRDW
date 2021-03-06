USE [HRDW]
GO
/****** Object:  View [dbo].[vAlphaOrgRoster-CFO]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vAlphaOrgRoster-CFO]
AS
SELECT 

'PII' AS 'SAFEGUARD'
,[RecordDate]
,[FullName]
,[EmailAddress]
,[ComputeEarlyRetirment]
,[ComputeEarlyRetirement(HRDW)]
,[ComputeOptionalRetirement]
,[ComputeOptionalRetirement(HRDW)]
,[OfficeSymbol]
,[HSSO]
,[PosOrgAgySubelementCode]
,[OfficeSymbol2Char]
,[PositionTitle]
,[PPSeriesGrade]
,[Step]
,[WGIDateDue]
,[WGILastEquivalentIncreaseDate]
,[DateLastPromotion]
,[BasicSalary]
,[AdjustedBasic]
,[TotalPay]
,[AppropriationCode]
,[OrgCodeBudgetFinance]
,[FundCode]
,[BudgetActivity]
,[CostElement]
,[ObjectClass]
,[DutyStationName]
,[DutyStationState]
,[SupervisoryStatusCode]
,[SupervisoryStatusDesc]
,[LatestHireDate]
,[Position_Supervisor]
FROM [dbo].[vAlphaOrgRoster-Regular]



GO
