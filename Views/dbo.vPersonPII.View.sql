USE [HRDW]
GO
/****** Object:  View [dbo].[vPersonPII]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vPersonPII] 
-- 2016-03-08 Rob Cornelsen updated to match table structure
-- ============ Maintenance Log ================================================
-- Author:      James McConville
-- Date:        2017-03-06  
-- Description: View Updated to get RNODecription from RNOLkup instead of Person
-- =============================================================================
AS 
SELECT Person.[PersonID]
      ,Person.[EmployeeNumber]
      ,Person.[SSN]
      ,Person.[EmailAddress]
      --,Person.[FullName]
      ,Person.[LastName]
      ,Person.[FirstName]
      ,Person.[MiddleName]
      ,Person.[BirthDate]
      ,Person.[VeteransStatusDescription]
      ,Person.[VeteransPreferenceDescription]
      ,Person.[GenderDescription]
      ,Person.[HandicapCode]
      ,Person.[HandicapCodeDescription]
      ,Person.[CitizenshipCode]
      ,Person.[CitizenshipDescription]
      ,Person.[RNOCode]
      ,RNOlkup.[RNODescription]
      ,Person.[AcademicInstitutionCode]
      ,Person.[AcademicInstitutionDesc]
      ,Person.[CollegeMajorMinorCode]
      ,Person.[CollegeMajorMinorDesc]
      ,Person.[EducationLevelCode]
      ,Person.[EducationLevelDesc]
      ,Person.[InstructionalProgramCode]
      ,Person.[InstructionalProgramDesc]
      ,Person.[DegreeObtained]
      ,Person.[AnnuitantIndicatorDescription]
      ,[AnnuitantIndicatorCode]
      ,Person.[ReserveCategoryCode]
      ,Person.[ReserveCategoryDescription]
      ,Person.[RetirementPlanCode]
      ,Person.[RetirementPlanDescription]
      ,Person.[CreditableMilitaryService]
	  ,Person.[IsPathways]
      ,Person.[DataSource]
      ,Person.[SystemSource]
      ,Person.[AsOfDate]
FROM 
	[dbo].[Person]
	LEFT OUTER JOIN RNOLkup rnolkup
		ON rnolkup.RNOCode = Person.RNOCode


GO
