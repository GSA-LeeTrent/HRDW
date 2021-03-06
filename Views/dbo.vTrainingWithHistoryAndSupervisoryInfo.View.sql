USE [HRDW]
GO
/****** Object:  View [dbo].[vTrainingWithHistoryAndSupervisoryInfo]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-04-27  
-- Description: Created View
-- =============================================================================
CREATE VIEW [dbo].[vTrainingWithHistoryAndSupervisoryInfo]
AS

SELECT 
  DB_NAME()							AS [Database]
, GETDATE()							AS [System Date and Time]
, pos.RecordDate					AS [Record Date]
, p.LastName						AS [Last Name]
, p.FirstName						AS [First Name]
, IsNull(p.MiddleName, '')			AS [Middle Name]
, p.LastName + ', ' + p.FirstName + ', ' + ISNULL(p.MiddleName,'') 
									AS [Empl Full Name]
, p.EmailAddress					AS [Empl Email]
, posI.SupervisoryStatusDesc		AS [Emp Supv Status]
, trng.TrainingTitle				AS [Training Title]
, trng.CourseCompletionDate			AS [Course Completion Date]
, trng.CourseStartDate				AS [Course Start Date]
, trng.FiscalYear					AS [Fiscal Year]
, poi.OwningRegion					AS [Owning Region]
, poi.ServicingRegion				AS [Servicing Region]
, dutlkup.RegionBasedOnDutyStation	AS [Region Based Duty Station]
, poi.PersonnelOfficeDescription	AS POID
, posI.PositionTitle				AS [Posn Title]
, posI.PayPlan						AS PP
, posI.PositionSeries				AS Series
, posI.Grade
, pos.PosOrgAgySubelementDesc		AS HSSO
, posI.OfficeSymbol					AS [Ofc Sym]
, offlkup.OfficeSymbol2Char			AS [2 Letter]
, trng.NonDutyHours					AS [Non Duty Hrs]
, trng.DutyHours					AS [Duty Hours]
, trng.VendorName					AS Vendor
, trng.SourceType					AS [Source Type]
, trng.TrainingDeliveryTypeDesc		AS [Train Delivery Type Desc]
, trng.TrainingPurposeDesc			AS [Train Purpose Desc]
, trng.TrainingSourceDesc			AS [Train Source Desc]
, trng.TrainingSubTypeDesc			AS [Train Sub Type Desc]
, trng.TrainingTypeDesc				AS [Train Type Desc]
, sup.[Had a Transaction becoming 2-4-5]
, sup.[Situation Status]
, sup.[SupEffDate]
FROM 
	 TssTDS trng
	 INNER JOIN 
	 Person p			ON  p.PersonID = trng.PersonID
	 INNER JOIN 
	 Position pos		ON	pos.PersonID = p.PersonID
							AND 
							pos.RecordDate =
							(
							SELECT MAX(posx.RecordDate) 
							FROM dbo.Position posx
							WHERE posx.PersonID = p.PersonID
							)
	INNER JOIN 
	PositionInfo posI	ON posI.PositionInfoId = pos.ChrisPositionId
						   AND
						   posI.PositionEncumberedType IN (
															'Employee Permanent'
														   ,'Employee Temporary'
														  )
	INNER JOIN 
	PositionDate posD 	ON posD.PositionDateId = pos.PositionDateId
--						   AND
--						   posD.LatestHireDate >='2006-10-01'
						   AND 
						   posD.Retirement_SCD IS NOT NULL
	INNER JOIN PersonnelOffice poi
						ON poi.PersonnelOfficeID = pos.PersonnelOfficeID
	 LEFT OUTER JOIN 
	 vSupervisorsAnyDate sup
	 					ON  sup.PersonID = trng.PersonID
							AND 
							sup.SupEffDate = 
								(
								SELECT MAX(SupEffDate) 
								FROM vSupervisorsAnyDate supx
								WHERE supx.PersonID = sup.PersonID
								)
	LEFT OUTER JOIN [dbo].[SSOLkup] s	
						ON s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]
	LEFT OUTER JOIN dbo.OfficeLkup		
						ON OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]
	LEFT OUTER JOIN dbo.DutyStation ds	
						ON pos.DutyStationID = ds.DutyStationID
	LEFT OUTER JOIN DutyStationCodeStateRegionLkup dutlkup
						ON ds.DutyStationCode = (REPLICATE('0',9 - LEN(dutlkup.DutyStationCode)) 
													+ dutlkup.DutyStationCode)
	LEFT OUTER JOIN OfficeLkup offlkup
						ON offlkup.[OfficeSymbol] = posI.[OfficeSymbol]	
	
------------------
UNION
------------------

SELECT 
  DB_NAME()							AS [Database]
, GETDATE()							AS [System Date and Time]
, pos.RecordDate					AS [Record Date]
, p.LastName						AS [Last Name]
, p.FirstName						AS [First Name]
, IsNull(p.MiddleName, '')			AS [Middle Name]
, p.LastName + ', ' + p.FirstName + ', ' + ISNULL(p.MiddleName,'') 
									AS [Empl Full Name]
, p.EmailAddress					AS [Empl Email]
, posI.SupervisoryStatusDesc		AS [Emp Supv Status]
, trng.TrainingTitle				AS [Training Title]
, trng.CourseCompletionDate			AS [Course Completion Date]
, trng.CourseStartDate				AS [Course Start Date]
, trng.FiscalYear					AS [Fiscal Year]
, poi.OwningRegion					AS [Owning Region]
, poi.ServicingRegion				AS [Servicing Region]
, dutlkup.RegionBasedOnDutyStation	AS [Region Based Duty Station]
, poi.PersonnelOfficeDescription	AS POID
, posI.PositionTitle				AS [Posn Title]
, posI.PayPlan						AS PP
, posI.PositionSeries				AS Series
, posI.Grade
, pos.PosOrgAgySubelementDesc		AS HSSO
, posI.OfficeSymbol					AS [Ofc Sym]
, offlkup.OfficeSymbol2Char			AS [2 Letter]
, trng.NonDutyHours					AS [Non Duty Hrs]
, trng.DutyHours					AS [Duty Hours]
, trng.VendorName					AS Vendor
, trng.SourceType					AS [Source Type]
, trng.TrainingDeliveryTypeDesc		AS [Train Delivery Type Desc]
, trng.TrainingPurposeDesc			AS [Train Purpose Desc]
, trng.TrainingSourceDesc			AS [Train Source Desc]
, trng.TrainingSubTypeDesc			AS [Train Sub Type Desc]
, trng.TrainingTypeDesc				AS [Train Type Desc]
, sup.[Had a Transaction becoming 2-4-5]
, sup.[Situation Status]
, sup.[SupEffDate]
FROM 
	 TssTDSHistory trng
	 INNER JOIN 
	 Person p			ON  p.PersonID = trng.PersonID
	 INNER JOIN 
	 Position pos		ON	pos.PersonID = p.PersonID
							AND 
							pos.RecordDate =
							(
							SELECT MAX(posx.RecordDate) 
							FROM dbo.Position posx
							WHERE posx.PersonID = p.PersonID
							)
	INNER JOIN 
	PositionInfo posI	ON posI.PositionInfoId = pos.ChrisPositionId
						   AND
						   posI.PositionEncumberedType IN (
															'Employee Permanent'
														   ,'Employee Temporary'
														  )
	INNER JOIN 
	PositionDate posD 	ON posD.PositionDateId = pos.PositionDateId
--						   AND
--						   posD.LatestHireDate >='2006-10-01'
						   AND 
						   posD.Retirement_SCD IS NOT NULL
	INNER JOIN PersonnelOffice poi
						ON poi.PersonnelOfficeID = pos.PersonnelOfficeID
	 LEFT OUTER JOIN 
	 vSupervisorsAnyDate sup
	 					ON  sup.PersonID = trng.PersonID
							AND 
							sup.SupEffDate = 
								(
								SELECT MAX(SupEffDate) 
								FROM vSupervisorsAnyDate supx
								WHERE supx.PersonID = sup.PersonID
								)
	LEFT OUTER JOIN [dbo].[SSOLkup] s	
						ON s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]
	LEFT OUTER JOIN dbo.OfficeLkup		
						ON OfficeLkup.[OfficeSymbol] = posI.[OfficeSymbol]
	LEFT OUTER JOIN dbo.DutyStation ds	
						ON pos.DutyStationID = ds.DutyStationID
	LEFT OUTER JOIN DutyStationCodeStateRegionLkup dutlkup
						ON ds.DutyStationCode = (REPLICATE('0',9 - LEN(dutlkup.DutyStationCode)) 
													+ dutlkup.DutyStationCode)
	LEFT OUTER JOIN OfficeLkup offlkup
						ON offlkup.[OfficeSymbol] = posI.[OfficeSymbol]	


GO
