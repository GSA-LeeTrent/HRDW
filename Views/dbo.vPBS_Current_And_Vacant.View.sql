USE [HRDW]
GO
/****** Object:  View [dbo].[vPBS_Current_And_Vacant]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- ============ Maintenance Log ================================================
-- Author:      Matt Albucher
-- Date:        2017-03-14  
-- Description: Added latest hire date
-- =============================================================================

-- ============ Maintenance Log ================================================
-- Author:      Matt Albucher
-- Date:        2017-03-13  
-- Description: PBS view for Jenny Sommer (8PT)
-- =============================================================================

CREATE VIEW [dbo].[vPBS_Current_And_Vacant] 
AS 



select
[RecordDate]
,[PositionEncumberedType]
,[AppropriationCode]
,NULL as [PositionSensitivity]-- OK 
,[PositionControlNumber]
,[PositionControlIndicator]
,[PositionTitle]
,[PositionInformationPD]
,[PositionSequenceNumber]
,[PPSeriesGrade]
,[OccupationalSeriesDescription]  as [PositionSeriesDesc]
,ros.[PosOrgAgySubelementCode]
,sso.[PosOrgAgySubelementDescription] as [PosOrgAgySubelementDesc]
,[OfficeSymbol]
,[OfficeSymbol2Char]
,[TargetGradeOrLevel]
,NULL as [FundingFUllTimeEqulvalent]
,[FullName]
,[PersonnelOfficeDescription]
,[BargainingUnitStatusDescription]
,[DutyStationName]
,[DutyStationCounty]
,[DutyStationState]
,NULL as  [PositionObligated?]
,NULL as [ObligatedEmpName]-- OK
,NULL as [PositionDetailed?] -- OK
,NULL as [DetailedEmpName]-- OK
,NULL as [FundingBackFill]
,NULL as [FundingBackFIllDesc]
,[BlockNumberCode]
,[BlockNumberDesc]
,[WorkTelephone]
,[AssignmentUSErStatus]
,[SupervisoryStatusCode]
,[SupervisoryStatusDesc]
,[Position_Supervisor]
,[TotalPay]
,[HourlyPay]
,[FlsaCategoryCode]
,[FlsaCategoryDescription]
, [LatestHireDate]
,[PosAddressOrgInfoLine1]
 ,[PosAddressOrgInfoLine2]
 ,[PosAddressOrgInfoLine3]
 ,[PosAddressOrgInfoLine4]
 ,[PosAddressOrgInfoLine5]
 ,[PosAddressOrgInfoLine6]


FROM [vAlphaOrgRoster-Regular] ros
left outer join ssolkup sso on sso.PosOrgAgySubelementCode=ros.PosOrgAgySubelementCode
WHERE ros.[PosOrgAgySubelementCode] = 'GS03'


UNION

SELECT

[RecordDate]
,[PositionEncumberedType]
,[AppropriationCode]
,[PositionSensitivity]
,[PositionControlNumber]
,[PositionControlIndicator]
,[PositionTitle]
,[PositionInformationPD]
,[PositionSequenceNumber]
,[PPSeriesGrade]
,[PositionSeriesDesc]
,[PosOrgAgySubelementCode]
,[PosOrgAgySubelementDesc]
,[OfficeSymbol]
,[OfficeSymbol2Char]
,NULL as [TargetGradeOrLevel]
,[FundingFUllTimeEqulvalent]
,NULL  as [FullName]
,[PersonnelOfficeDescription]
,[BargainingUnitStatusDescription]
,[DutyStationName]
,[DutyStationCounty]
,[DutyStationState]
,[PositionObligated?]
,[ObligatedEmpName]
,[PositionDetailed?]
,[DetailedEmpName]
,[FundingBackFill]
,[FundingBackFIllDesc]
,[BlockNumberCode]
,[BlockNumberDesc]
,NULL as [WorkTelephone]
,[AssignmentUserStatus]
,[SupervisoryStatusCode]
,[SupervisoryStatusDesc]
,[Position_Supervisor]
,NULL as [TotalPay]
,NULL as [HourlyPay]
,[FlsaCategoryCode]
,[FlsaCategoryDescription]
, NULL as [LatestHireDate]
,[PosAddressOrgInfoLine1]
 ,[PosAddressOrgInfoLine2]
 ,[PosAddressOrgInfoLine3]
 ,[PosAddressOrgInfoLine4]
 ,[PosAddressOrgInfoLine5]
 ,[PosAddressOrgInfoLine6]

FROM [vVacantPositions]
WHERE [PosOrgAgySubelementCode] = 'GS03'




GO
