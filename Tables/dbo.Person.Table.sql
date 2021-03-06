USE [HRDW]
GO
/****** Object:  Table [dbo].[Person]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Person](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeNumber] [int] NULL,
	[SSN] [nvarchar](255) NOT NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[LastName] [nvarchar](255) NULL,
	[FirstName] [nvarchar](255) NULL,
	[MiddleName] [nvarchar](255) NULL,
	[BirthDate] [date] NULL,
	[VeteransStatusDescription] [nvarchar](255) NULL,
	[VeteransPreferenceDescription] [nvarchar](255) NULL,
	[GenderDescription] [nvarchar](255) NULL,
	[HandicapCode] [nvarchar](255) NULL,
	[HandicapCodeDescription] [nvarchar](255) NULL,
	[CitizenshipCode] [nvarchar](255) NULL,
	[CitizenshipDescription] [nvarchar](255) NULL,
	[RNOCode] [nvarchar](255) NULL,
	[RNODescription] [nvarchar](500) NULL,
	[AcademicInstitutionCode] [nvarchar](255) NULL,
	[AcademicInstitutionDesc] [nvarchar](255) NULL,
	[CollegeMajorMinorCode] [nvarchar](255) NULL,
	[CollegeMajorMinorDesc] [nvarchar](255) NULL,
	[EducationLevelCode] [nvarchar](255) NULL,
	[EducationLevelDesc] [nvarchar](255) NULL,
	[InstructionalProgramCode] [nvarchar](255) NULL,
	[InstructionalProgramDesc] [nvarchar](255) NULL,
	[DegreeObtained] [nvarchar](255) NULL,
	[AnnuitantIndicatorDescription] [nvarchar](255) NULL,
	[AnnuitantIndicatorCode] [nvarchar](255) NULL,
	[ReserveCategoryCode] [nvarchar](255) NULL,
	[ReserveCategoryDescription] [nvarchar](255) NULL,
	[RetirementPlanCode] [nvarchar](255) NULL,
	[RetirementPlanDescription] [nvarchar](255) NULL,
	[CreditableMilitaryService] [nvarchar](255) NULL,
	[IsPathways] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [Person_PK] PRIMARY KEY NONCLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains person unique records.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person'
GO
