USE [HRDW]
GO
/****** Object:  View [dbo].[vTrainingAllEmployees]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [dbo].[vTrainingAllEmployees] 

AS 
--Training Query created 4-12-2016 by Ralph Silvestro.  Version 1
--Version 2 Modification by James McConville 4-21-2016
--This is the SQL Version to replace what was updated Biweekly on the Interim HRDW up on Google for Training.
--A Separate Reporting View Exists for Just Current Supervisors (2,4,5).
--This represents all training for the past FY & Current FY.

SELECT
	   DB_NAME() AS 'Database'
--   , dbo.Person.PersonID
	 , GETDATE() AS 'System Date and Time'
	 , dbo.Position.RecordDate AS [Record Date]
	 , dbo.Person.LastName AS [Last Name]
	 , dbo.Person.FirstName AS [First Name]
	 , dbo.Person.MiddleName AS [Middle Name]
	 , dbo.Person.LastName + ', ' + dbo.Person.FirstName + ', ' + ISNULL(dbo.Person.MiddleName,'') AS [Empl Full Name]
	 , dbo.Person.EmailAddress AS [Empl Email]
	 , dbo.PositionInfo.SupervisoryStatusDesc AS [Emp Supv Status]
	 , dbo.TssTDS.TrainingTitle AS [Training Title]
	 , dbo.TssTDS.CourseCompletionDate AS [Course Completion Date]
	 , dbo.TssTDS.CourseStartDate AS [Course Start Date]
	 , dbo.TssTDS.FiscalYear AS [Fiscal Year]
	 , dbo.PersonnelOffice.OwningRegion AS [Owning Region]
	 , dbo.PersonnelOffice.ServicingRegion AS [Servicing Region]
	 , dbo.DutyStationCodeStateRegionLkup.RegionBasedOnDutyStation AS [Region Based Duty Station]
	 , dbo.PersonnelOffice.PersonnelOfficeDescription AS POID
	 , dbo.PositionInfo.PositionTitle AS [Posn Title]
	 , dbo.PositionInfo.PayPlan AS PP
	 , dbo.PositionInfo.PositionSeries AS Series
	 , dbo.PositionInfo.Grade
	 , dbo.Position.PosOrgAgySubelementDesc AS HSSO
	 , dbo.PositionInfo.OfficeSymbol AS [Ofc Sym]
	 , dbo.OfficeLkup.OfficeSymbol2Char AS [2 Letter]
	 , dbo.TssTDS.NonDutyHours AS [Non Duty Hrs]
	 , dbo.TssTDS.DutyHours AS [Duty Hours]
	 , dbo.TssTDS.VendorName AS Vendor
	 , dbo.TssTDS.SourceType AS [Source Type]
	 , dbo.TssTDS.TrainingDeliveryTypeDesc AS [Train Delivery Type Desc]
	 , dbo.TssTDS.TrainingPurposeDesc AS [Train Purpose Desc]
	 , dbo.TssTDS.TrainingSourceDesc AS [Train Source Desc]
	 , dbo.TssTDS.TrainingSubTypeDesc AS [Train Sub Type Desc]
	 , dbo.TssTDS.TrainingTypeDesc AS [Train Type Desc]

	 , dbo.vNewSupervisors.[Had a Transaction becoming 2-4-5]
	 , dbo.vNewSupervisors.[Situation Status]
	 , dbo.vNewSupervisors.[NewSupEffDate]
FROM            
	dbo.Person 
	INNER JOIN      dbo.Position						ON dbo.Person.PersonID = dbo.Position.PersonID
					AND
					dbo.Position.RecordDate =
					(
					select Max(pos1.RecordDate) as MaxRecDate from dbo.Position pos1 where pos1.PersonID = dbo.Position.PersonID
					) 
	INNER JOIN      dbo.PositionInfo					ON dbo.Position.ChrisPositionID = dbo.PositionInfo.PositionInfoID
					AND
					(
					PositionInfo.PositionEncumberedType = 'Employee Permanent' 
					OR 
					PositionInfo.PositionEncumberedType = 'Employee Temporary'
					OR
					PositionInfo.PositionEncumberedType ='EX-Employee Permanent'
					)	 
	LEFT OUTER JOIN	dbo.TssTDS							ON dbo.Person.PersonID = dbo.TssTDS.PersonID 
	INNER JOIN      dbo.PersonnelOffice					ON dbo.Position.PersonnelOfficeID = dbo.PersonnelOffice.PersonnelOfficeID
	LEFT OUTER JOIN dbo.DutyStation						ON dbo.Position.DutyStationID = dbo.DutyStation.DutyStationID 
	LEFT OUTER JOIN dbo.DutyStationCodeStateRegionLkup	ON dbo.DutyStation.DutyStationCode = (REPLICATE('0',9 - LEN(dbo.DutyStationCodeStateRegionLkup.DutyStationCode)) + dbo.DutyStationCodeStateRegionLkup.DutyStationCode)
	LEFT OUTER JOIN dbo.OfficeLkup						ON dbo.PositionInfo.OfficeSymbol = dbo.OfficeLkup.OfficeSymbol
	LEFT OUTER JOIN	dbo.vNewSupervisors                 ON dbo.Person.PersonID = dbo.vNewSupervisors.PersonID
WHERE        
	(dbo.Position.RecordDate = (SELECT MAX(pos1.RecordDate) FROM dbo.Position pos1))




GO
