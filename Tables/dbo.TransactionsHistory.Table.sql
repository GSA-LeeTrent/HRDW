USE [HRDW]
GO
/****** Object:  Table [dbo].[TransactionsHistory]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransactionsHistory](
	[TransactionsHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[RunDate] [smalldatetime] NOT NULL,
	[EffectiveDate] [date] NULL,
	[FYDESIGNATION] [nvarchar](255) NULL,
	[FAMILY_NOACS] [nvarchar](255) NULL,
	[NOAC_AND_DESCRIPTION] [nvarchar](255) NULL,
	[FirstActionLACode1] [nvarchar](255) NULL,
	[FirstActionLADesc1] [nvarchar](255) NULL,
	[FirstActionLACode2] [nvarchar](255) NULL,
	[FirstActionLADesc2] [nvarchar](255) NULL,
	[SecondNOACode] [nvarchar](255) NULL,
	[SecondNOADesc] [nvarchar](255) NULL,
	[TenureDesc] [nvarchar](255) NULL,
	[AppointmentTypeDesc] [nvarchar](255) NULL,
	[TypeOfEmploymentDesc] [nvarchar](255) NULL,
	[VeteransPreferenceDesc] [nvarchar](255) NULL,
	[VeteransStatusDesc] [nvarchar](255) NULL,
	[WorkScheduleDesc] [nvarchar](255) NULL,
	[ReasonForSeparationDesc] [nvarchar](255) NULL,
	[SupvMgrProbCompletion] [nvarchar](255) NULL,
	[SupvMgrProbBeginDate] [date] NULL,
	[DateConvCareerBegins] [date] NULL,
	[DateConvCareerDue] [date] NULL,
	[AwardTypeDesc] [nvarchar](255) NULL,
	[ToAppropriationCode1] [nvarchar](255) NULL,
	[Pathways] [nvarchar](255) NULL,
	[SCEP_STEP_PMF] [nvarchar](255) NULL,
	[Flex2] [nvarchar](255) NULL,
	[PathwaysProgramStartDate] [date] NULL,
	[PathwaysProgramEndDate] [date] NULL,
	[PathwaysProgramExtnEndDate] [date] NULL,
	[FromOfficeSymbol] [nvarchar](255) NULL,
	[FromLongName] [nvarchar](255) NULL,
	[ToOfficeSymbol] [nvarchar](255) NULL,
	[ToLongName] [nvarchar](255) NULL,
	[FromPositionAgencyCodeSubelementDescription] [nvarchar](255) NULL,
	[ToPositionAgencyCodeSubelementDescription] [nvarchar](255) NULL,
	[WhatKindofMovement] [nvarchar](255) NULL,
	[FromPositionControlNumberIndicatorDescription] [nvarchar](255) NULL,
	[FromPositionControlNumberIndicator] [nvarchar](255) NULL,
	[FromPositionControlNumber] [nvarchar](255) NULL,
	[FromPDNumber] [nvarchar](255) NULL,
	[FromPositionSequenceNumber] [nvarchar](255) NULL,
	[FromPPSeriesGrade] [nvarchar](255) NULL,
	[FromPositionTargetGradeorLevel] [nvarchar](255) NULL,
	[ToPositionControlNumberIndicatorDescription] [nvarchar](255) NULL,
	[ToPositionControlNumberIndicator] [nvarchar](255) NULL,
	[ToPositionControlNumber] [nvarchar](255) NULL,
	[ToPDNumber] [nvarchar](255) NULL,
	[ToPositionSequenceNumber] [nvarchar](255) NULL,
	[ToPPSeriesGrade] [nvarchar](255) NULL,
	[ToPositionTargetGradeorLevel] [nvarchar](255) NULL,
	[FromPayBasis] [nvarchar](255) NULL,
	[ToPayBasis] [nvarchar](255) NULL,
	[FPL] [nvarchar](255) NULL,
	[ToFLSACateGOry] [nvarchar](255) NULL,
	[FromPositionTitle] [nvarchar](255) NULL,
	[ToPositionTitle] [nvarchar](255) NULL,
	[DutyStationNameandStateCountry] [nvarchar](255) NULL,
	[FromRegion] [nvarchar](255) NULL,
	[ToRegion] [nvarchar](255) NULL,
	[FromServicingRegion] [nvarchar](255) NULL,
	[ToServicingRegion] [nvarchar](255) NULL,
	[ToPOI] [nvarchar](255) NULL,
	[ToBargainingUnitStatusDesc] [nvarchar](255) NULL,
	[FromPosSupervisorySatusDesc] [nvarchar](255) NULL,
	[ToSupervisoryStatusDesc] [nvarchar](255) NULL,
	[NewSupervisor] [nvarchar](255) NULL,
	[EmployeeNumber] [nvarchar](255) NULL,
	[NOAFamilyCode] [nvarchar](255) NULL,
	[ReasonForSeparation] [nvarchar](255) NULL,
	[RetirementPlan] [nvarchar](255) NULL,
	[RetirementPlanDesc] [nvarchar](255) NULL,
	[MandatoryRetirementDate] [date] NULL,
	[Tenure] [nvarchar](255) NULL,
	[TypeOfEmployment] [nvarchar](255) NULL,
	[AppointmentType] [nvarchar](255) NULL,
	[AgencyCodeTransferFrom] [nvarchar](255) NULL,
	[AgencyCodeTransferFromDesc] [nvarchar](255) NULL,
	[AgencyCodeTransferTo] [nvarchar](255) NULL,
	[AgencyCodeTransferToDesc] [nvarchar](255) NULL,
	[FromPositionAgencyCodeSubelement] [nvarchar](255) NULL,
	[ToPositionAgencyCodeSubelement] [nvarchar](255) NULL,
	[ToDutyStationCode] [nvarchar](255) NULL,
	[FromStepOrRate] [nvarchar](255) NULL,
	[ToStepOrRate] [nvarchar](255) NULL,
	[HireDate] [date] NULL,
	[IncentivePaymentOptionCode] [nvarchar](255) NULL,
	[IncentivePaymentOptionDesc] [nvarchar](255) NULL,
	[IncentivePaymentTypeCategroy] [nvarchar](255) NULL,
	[RetentionIncentiveReviewDate] [date] NULL,
	[TotalIncentiveAmountPercent] [nvarchar](255) NULL,
	[AwardAppropriationCode] [nvarchar](255) NULL,
	[AwardApprovinGOfficialName] [nvarchar](255) NULL,
	[AwardJustification] [nvarchar](max) NULL,
	[AwardType] [nvarchar](255) NULL,
	[AwardTypeDesc1] [nvarchar](255) NULL,
	[AwardUOM] [nvarchar](255) NULL,
	[FromBasicPay] [money] NULL,
	[ToBasicPay] [money] NULL,
	[FromAdjustedBasicPay] [money] NULL,
	[ToAdjustedBasicPay] [money] NULL,
	[FromTotalPay] [money] NULL,
	[ToTotalPay] [money] NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
	[AwardAmount] [numeric](13, 2) NULL,
	[ProcessedDate] [date] NULL,
	[AnnuitantIndicator] [nvarchar](255) NULL,
	[AnnuitantIndicatorDesc] [nvarchar](255) NULL,
	[PayRateDeterminant] [nvarchar](255) NULL,
	[PayRateDeterminantDesc] [nvarchar](255) NULL,
	[NOAC_AND_DESCRIPTION_2] [nvarchar](255) NULL,
 CONSTRAINT [TransactionsHistory_pk] PRIMARY KEY NONCLUSTERED 
(
	[TransactionsHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[TransactionsHistory]  WITH CHECK ADD  CONSTRAINT [TransactionsHistory_FK01] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[TransactionsHistory] CHECK CONSTRAINT [TransactionsHistory_FK01]
GO
