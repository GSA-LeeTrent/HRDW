USE [HRDW]
GO
/****** Object:  Table [LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [LegacyPirsChrisbo].[PIRS_CJ_Transactions(85,89,90-2000)](
	[PIRS_CJ_ID] [int] IDENTITY(1,1) NOT NULL,
	[PIRS CJ-Chronological Journal] [varchar](20) NOT NULL,
	[PersonID] [int] NULL,
	[FYDESIGNATION] [varchar](6) NOT NULL,
	[SSN] [varchar](11) NOT NULL,
	[FullName] [varchar](75) NOT NULL,
	[ProcessDate] [date] NULL,
	[EffectiveDate] [date] NOT NULL,
	[SCDCivilian] [date] NULL,
	[NOAC AND DESCRIPTION] [varchar](100) NULL,
	[AgencyTransferedTo] [varchar](2) NULL,
	[AgencyTransferedToDescription] [varchar](75) NULL,
	[VeteransPreferenceCode] [varchar](1) NULL,
	[VeteransPreferenceDescription] [varchar](50) NULL,
	[NumberofEmployees] [int] NULL,
	[AuthorityCode1] [varchar](3) NULL,
	[AuthorityCode2] [varchar](3) NULL,
	[BirthDate] [date] NULL,
	[RNOCode] [varchar](1) NULL,
	[RNODescription] [varchar](75) NULL,
	[Gender] [varchar](1) NULL,
	[DutyStationCode] [varchar](9) NULL,
	[DutyStationName] [varchar](50) NULL,
	[DutyStationState] [varchar](50) NULL,
	[DutyStationCounty] [varchar](50) NULL,
	[DSRegion] [varchar](3) NULL,
	[OwningRegion] [varchar](1) NULL,
	[ServingRegion] [varchar](1) NULL,
	[HandicapCode] [varchar](2) NULL,
	[HandicapCodeDescription] [varchar](255) NULL,
	[FromAppointmentTypeCode] [varchar](5) NULL,
	[FromAppointmentTypeDescription] [varchar](255) NULL,
	[ToAppointmentTypeCode] [varchar](2) NULL,
	[ToAppointmentTypeDescription] [varchar](255) NULL,
	[FromOfficeSymbol] [varchar](10) NULL,
	[ToOfficeSymbol] [varchar](10) NULL,
	[OldOrgnCode] [varchar](10) NULL,
	[FromHSSO] [varchar](50) NULL,
	[NewOrgnCode] [varchar](10) NULL,
	[ToHSSO] [varchar](50) NULL,
	[What Kind of Movement?] [varchar](100) NULL,
	[FromSeriesGroupTitle] [varchar](100) NULL,
	[ToSeriesGroupTitle] [varchar](100) NULL,
	[FromPP] [varchar](2) NULL,
	[ToPP] [varchar](2) NULL,
	[FromSeries] [varchar](4) NULL,
	[[ToSeries] [varchar](4) NULL,
	[[FromGrade] [varchar](2) NULL,
	[[ToGrade] [varchar](2) NULL,
	[FromPP-Series-Gr] [varchar](10) NULL,
	[ToPP-Series-Gr] [varchar](10) NULL,
	[From MCO-Mission Critical Occupations] [varchar](255) NULL,
	[From OCO-Organizational Critical Occupations] [varchar](255) NULL,
	[To MCO-Mission Critical Occupations] [varchar](255) NULL,
	[To OCO-Organizational Critical Occupations] [varchar](255) NULL,
	[FromSupervisoryCode] [varchar](1) NULL,
	[FromSupervisoryStatusDesc] [varchar](50) NULL,
	[ToSupervisoryCode] [varchar](1) NULL,
	[ToSupervisoryStatusDesc] [varchar](50) NULL,
	[FromTenureCode] [varchar](1) NULL,
	[FromTenureDescription] [varchar](255) NULL,
	[ToTenureCode] [varchar](1) NULL,
	[ToTenureDescription] [varchar](255) NULL,
	[FromWorkSchedule] [varchar](1) NULL,
	[ToWorkSchedule] [varchar](1) NULL,
	[FromOccupationCategoryCode] [varchar](1) NULL,
	[FromOccupationCategoryDescription] [varchar](255) NULL,
	[ToOccupationCategoryCode] [varchar](1) NULL,
	[ToOccupationCategoryDescription] [varchar](255) NULL,
	[SeparationReasonCode] [varchar](6) NULL,
	[SeparationReason] [varchar](255) NULL,
 CONSTRAINT [PIRS_CJ_pk] PRIMARY KEY NONCLUSTERED 
(
	[PIRS_CJ_ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
