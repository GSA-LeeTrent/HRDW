USE [HRDW]
GO
/****** Object:  View [dbo].[vTask1-100-InternPrograms]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vTask1-100-InternPrograms]
AS
SELECT 
	DISTINCT
	 p.PersonID
    ,CASE
	 WHEN FirstActionLACode1 IN ('YEA','YEB','YEC','YEF','YEG','YEH','YEK','YEL','YEP','YER')
		THEN 'Pathways'
	 WHEN FirstActionLACode1 IN	('Y1K','Y2K','Y3K','Y4K','Y5K')
		THEN 'STEP'
	 WHEN FirstActionLACode1 IN ('Y1M','Y2M','Y3M','YBM','YGM')
		THEN 'SCEP'
	 WHEN FirstActionLACode1 IN ('YCM','X9M')
		THEN 'FCIP'
	 END
	 AS ProgramName
    ,t.[RunDate]	 
    ,t.[EffectiveDate] 
    ,t.[HireDate] 
    ,t.[FYDESIGNATION] 
    ,t.FAMILY_NOACS 
    ,t.NOAC_AND_DESCRIPTION 
    ,t.[FirstActionLACode1] 
    ,t.[FirstActionLADesc1] 
    ,t.[FirstActionLACode2] 
    ,t.[FirstActionLADesc2] 
    ,t.[SecondNOACode] 
    ,t.[SecondNOADesc] 
    ,(p.[FirstName]+' '+ ISNULL(p.MiddleName,'') +' '+p.LastName) as FullName -- Removed #2 columns as part of 2276
    ,p.[FirstName]  -- Removed #2 columns as part of 2276
    ,p.MiddleName  -- Removed #2 columns as part of 2276
    ,p.LastName   -- Removed #2 columns as part of 2276
	,p.EmailAddress  -- Removed #2 columns as part of 2276
    ,t.Pathways 
    ,t.SCEP_STEP_PMF 
    ,t.Flex2 
    ,t.ToPositionAgencyCodeSubelementDescription 
    ,t.[ToPPSeriesGrade] 
    ,t.[ToStepOrRate] 
    ,t.[ToPositionTargetGradeorLevel] 
    ,t.FPL 
    ,t.[ToPositionTitle] 
FROM Transactions t  
INNER JOIN Person p
	ON p.PersonID = t.PersonID 
	and t.FAMILY_NOACS = 'NOAC 100 FAMILYAccessions'
--	and (
--		t.FYDESIGNATION = 'FY'+ dbo.Riv_fn_ComputeFiscalYear(GETDATE()) 
--		or t.FYDESIGNATION = 'FY'+ cast( dbo.Riv_fn_ComputeFiscalYear(GETDATE())-1 as varchar(4) ) 
--		)  
INNER JOIN Position pos1
	ON  pos1.PersonID = p.PersonID	
INNER JOIN PositionDate posD
	ON posD.PositionDateID = pos1.PositionDateID 
--INNER JOIN (select pos.PersonID, Max(pos.RecordDate) as MaxRecDate
--			from Position pos
--			group by pos.PersonID 
--			having pos.PersonID is not Null) PosMax 
--	ON PosMax.PersonID = p.PersonID		
--	and pos1.RecordDate = PosMax.MaxRecDate 
WHERE
	FirstActionLACode1 IN
	(
	 'YEA'
	,'YEB'
	,'YEC'
	,'YEF'
	,'YEG'
	,'YEH'
	,'YEK'
	,'YEL'
	,'YEP'
	,'YER'
	)
	OR
	FirstActionLACode1 IN
	(
	 'Y1K'
	,'Y2K'
	,'Y3K'
	,'Y4K'
	,'Y5K'
	)
	OR
	FirstActionLACode1 IN
	(
	 'Y1M'
	,'Y2M'
	,'Y3M'
	,'YBM'
	,'YGM'
	)
	OR
	FirstActionLACode1 IN
	(
	 'YCM'
	,'X9M'
	)


GO
