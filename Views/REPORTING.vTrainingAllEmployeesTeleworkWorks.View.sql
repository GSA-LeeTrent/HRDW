USE [HRDW]
GO
/****** Object:  View [REPORTING].[vTrainingAllEmployeesTeleworkWorks]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE VIEW [REPORTING].[vTrainingAllEmployeesTeleworkWorks] 
AS
-- ============ Maintenance Log ================================================
-- Author:      Ralph Silvestro / James McConville
-- Date:        2016-06-06  
-- Description: Created view
-- =============================================================================
SELECT 
	   DB_NAME() AS 'Database'
	 , GETDATE() AS 'System Date and Time'
	 , pos.RecordDate AS [Record Date]
	 , p.LastName AS [Last Name]
	 , p.FirstName AS [First Name]
	 , p.MiddleName AS [Middle Name]
	 , p.LastName + ', ' + p.FirstName + ', ' + ISNULL(p.MiddleName,'') AS [Empl Full Name]
	 , p.EmailAddress AS [Empl Email]
	 , posI.SupervisoryStatusDesc AS [Emp Supv Status]
	 , COALESCE(t.TrainingTitle, th.TrainingTitle) AS [Training Title]
	 , COALESCE(t.CourseCompletionDate, th.CourseCompletionDate) AS [Course Completion Date]
	 , COALESCE(t.CourseStartDate, th.CourseStartDate) AS [Course Start Date]
	 , COALESCE(t.FiscalYear, th.FiscalYear) AS [Fiscal Year]
	 , po.OwningRegion AS [Owning Region]
	 , po.ServicingRegion AS [Servicing Region]
	 , dslkup.RegionBasedOnDutyStation AS [Region Based On Duty Station]
	 , offlkup.RegionBasedOnOfficeSymbol AS [Region Based On Office Symbol]
	 , po.PersonnelOfficeDescription AS POID
	 , posI.PositionTitle AS [Posn Title]
	 , posI.PayPlan AS PP
	 , posI.PositionSeries AS Series
	 , posI.Grade
	 , pos.PosOrgAgySubelementDesc AS HSSO
	 , s.[SsoAbbreviation]
	 , posI.OfficeSymbol AS [Ofc Sym]
	 , offlkup.OfficeSymbol2Char AS [2 Letter]
	 , COALESCE(t.NonDutyHours, th.NonDutyHours) AS [Non Duty Hrs]
	 , COALESCE(t.DutyHours, th.DutyHours) AS [Duty Hours]
	 , COALESCE(t.VendorName, th.VendorName) AS Vendor
	 , COALESCE(t.SourceType, th.SourceType) AS [Source Type]
	 , COALESCE(t.TrainingDeliveryTypeDesc, th.TrainingDeliveryTypeDesc) AS [Train Delivery Type Desc]
	 , COALESCE(t.TrainingPurposeDesc, th.TrainingPurposeDesc) AS [Train Purpose Desc]
	 , COALESCE(t.TrainingSourceDesc, th.TrainingSourceDesc) AS [Train Source Desc]
	 , COALESCE(t.TrainingSubTypeDesc, th.TrainingSubTypeDesc) AS [Train Sub Type Desc]
	 , COALESCE(t.TrainingTypeDesc, th.TrainingTypeDesc) AS [Train Type Desc]
	 , posD.LatestHireDate
	 , p1.LastName+', '+p1.FirstName + ' ' + ISNULL(p1.MiddleName,'') as Position_Supervisor	-- JJM 2016-04-13 Added MiddleName
	 , p1.EmailAddress as Supervisor_Email

	 , pos.TeleworkIndicator AS PMUTeleworkIndicator
	 , pos.TeleworkIndicatorDescription AS PMUTeleworkIndicatorDescription
	 , pos.TeleworkIneligibilityReason AS PMUTeleworkIneligibilityReason
	 , pos.TeleworkIneligibReasonDescription AS PMUTeleworkIneligibReasonDescription

------------------------------
-- telework 
------------------------------
	 , tel.TeleworkElgible
	 , tel.InelgibleReason
	 , tel.AgreementDate
	 , CASE
	   WHEN tel.EmpStatus IS NULL
	   THEN 'None'
	   ELSE tel.EmpStatus
	   END AS TeleworkEmpStatus
	 , CASE
	   WHEN tel.TeleworkStatus IS NULL
	   THEN 'No Agreement on Salesforce File'
	   ELSE tel.TeleworkStatus
	   END AS TeleworkStatus
	 , CASE 
	   WHEN tel.[EmpStatus] is null 
	   THEN 'No Matching Salesforce Information on key data field'		
	   ELSE 'No'
	   END AS IsEmpStatusBlank
	 , CASE
	   WHEN tx.EmailAddress IS NOT NULL
	   THEN 'YES'
	   ELSE 'NO'
	   END AS ExcludeFlag
	  ,eps.PAY_STATUS_CD
	  ,eps.PAY_STATUS_DESC
FROM     
	dbo.Person p
	INNER JOIN
    dbo.Position pos 
	ON	p.PersonID = pos.PersonID 
		AND 
--		pos.RecordDate = (select Max(pos1.RecordDate) from dbo.Position pos1 where pos1.PersonID = pos.PersonID)
	    pos.RecordDate = 
--      JJM 2016-10-03 get max RecordDate for table instead of Person so that employees with changed SSNs are excluded
		(select Max(pos1.RecordDate) as MaxRecDate from dbo.Position pos1)
	and pos.PositionDateID = 
		(select Max(pos2.PositionDateID) as MaxPosDateId from dbo.Position pos2 
		where pos2.FY = pos.FY and pos2.PersonID = pos.PersonID and pos2.RecordDate = pos.RecordDate)  -- 28,264 records, make sure one person only contains one Position record. If for any reason, a person has two position dates, get the latest one.
     
	INNER JOIN
    dbo.PositionInfo posI 
		ON pos.ChrisPositionID = posI.PositionInfoID

	inner join dbo.PositionDate posD
		on posD.PositionDateId = pos.PositionDateId

	-- getting supervisor's names
	left outer join Person p1	
		on p1.PersonID = posI.SupervisorID

	left outer join [dbo].[Telework] tel
		on tel.[PersonID] = p.PersonID

    LEFT OUTER JOIN
	dbo.TssTDS t 
		ON	t.PersonID = p.PersonID 
			AND
			t.TrainingTitle = 'Telework Works'
			AND
			t.CourseStartDate = 
				(
				SELECT MAX(t2.CourseStartDate)
				FROM dbo.TssTDS t2
				WHERE t2.PersonID = t.PersonID
					  AND
					  t2.TrainingTitle = 'Telework Works'
				) 
			AND
			t.CourseCompletionDate = 
				(
				SELECT MAX(t3.CourseCompletionDate)
				FROM dbo.TssTDS t3
				WHERE t3.PersonID = t.PersonID
					  AND
					  t3.TrainingTitle = 'Telework Works'
				) 

	 LEFT OUTER JOIN
	 dbo.TssTDSHistory th 
		ON	th.PersonID = p.PersonID
			AND
			th.TrainingTitle = 'Telework Works'
			AND
			th.CourseStartDate = 
				(
				SELECT MAX(th2.CourseStartDate)
				FROM dbo.TssTDSHistory th2
				WHERE th2.PersonID = th.PersonID
					  AND
					  th2.TrainingTitle = 'Telework Works'
				) 
			AND
			th.CourseCompletionDate = 
				(
				SELECT MAX(th3.CourseCompletionDate)
				FROM dbo.TssTDSHistory th3
				WHERE th3.PersonID = th.PersonID
					  AND
					  th3.TrainingTitle = 'Telework Works'
				) 
	INNER JOIN  
	dbo.PersonnelOffice po
		ON pos.PersonnelOfficeID = po.PersonnelOfficeID
	LEFT OUTER JOIN 
	dbo.DutyStation	ds
		ON pos.DutyStationID = ds.DutyStationID 
	LEFT OUTER JOIN 
	dbo.DutyStationCodeStateRegionLkup dslkup	
		ON ds.DutyStationCode = (REPLICATE('0',9 - LEN(dslkup.DutyStationCode)) + dslkup.DutyStationCode)
	LEFT OUTER JOIN 
	dbo.OfficeLkup offlkup
		ON posI.OfficeSymbol = offlkup.OfficeSymbol
	left outer join [dbo].[SSOLkup] s  		
        on s.[PosOrgAgySubelementCode] = pos.[PosOrgAgySubelementCode]

	LEFT OUTER JOIN 
	REPORTING.TeleworkExcludeUsers tx
		ON p.EmailAddress = tx.EmailAddress
	LEFT OUTER JOIN 
	REPORTING.EmployeePayStatus eps
		ON p.SSN = eps.SSN

WHERE  
	posI.PositionEncumberedType IN ('Employee Permanent','Employee Temporary')




GO
