USE [HRDW]
GO
/****** Object:  Table [dbo].[TssTDS]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TssTDS](
	[TssTDSID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[AccreditationIndicatorCode] [nvarchar](255) NULL,
	[AccreditationIndicatorDesc] [nvarchar](255) NULL,
	[AgencyCodeSubelement] [nvarchar](255) NULL,
	[ContServiceAgreementSigned] [date] NULL,
	[CourseCompletionDate] [date] NULL,
	[CourseStartDate] [date] NULL,
	[CreditDesignationCode] [nvarchar](255) NULL,
	[CreditDesignationDesc] [nvarchar](255) NULL,
	[CreditTypeDesc] [nvarchar](255) NULL,
	[CreditTypeCode] [nvarchar](255) NULL,
	[DutyHours] [float] NULL,
	[FiscalYear] [nvarchar](255) NULL,
	[ImpactOnPerformanceCode] [nvarchar](255) NULL,
	[ImpactOnPerformanceDesc] [nvarchar](255) NULL,
	[MaterialCost] [float] NULL,
	[NonGOvernmentContributionCost] [float] NULL,
	[NonDutyHours] [float] NULL,
	[NumberofAssociates] [float] NULL,
	[OccupationalSeriesCode] [nvarchar](255) NULL,
	[OccupationalSeriesDesc] [nvarchar](255) NULL,
	[OrganizationName] [nvarchar](255) NULL,
	[PayPlan] [nvarchar](255) NULL,
	[PerdiemCost] [float] NULL,
	[PriorKnowledgeLevelCode] [nvarchar](255) NULL,
	[PriorKnowledgeLevelDesc] [nvarchar](255) NULL,
	[PriorSupvApprovalReceivedCode] [nvarchar](255) NULL,
	[PriorSupvApprovalReceivedDesc] [nvarchar](255) NULL,
	[RecommendTrainingToOthersCode] [nvarchar](255) NULL,
	[RecommendTrainingToOthersDesc] [nvarchar](255) NULL,
	[RepaymentAgreementRequiredCode] [nvarchar](255) NULL,
	[RepaymentAgreementRequiredDesc] [nvarchar](255) NULL,
	[SourceType] [nvarchar](255) NULL,
	[TrainingCredit] [float] NULL,
	[TrainingDeliveryTypeCode] [nvarchar](255) NULL,
	[TrainingDeliveryTypeDesc] [nvarchar](255) NULL,
	[TrainingLocation] [nvarchar](255) NULL,
	[TrainingPartOfIDPCode] [nvarchar](255) NULL,
	[TrainingPartOfIDPDesc] [nvarchar](255) NULL,
	[TrainingPurposeCode] [nvarchar](255) NULL,
	[TrainingPurposeDesc] [nvarchar](255) NULL,
	[TrainingSourceCode] [nvarchar](255) NULL,
	[TrainingSourceDesc] [nvarchar](255) NULL,
	[TrainingSubTypeCode] [nvarchar](255) NULL,
	[TrainingSubTypeDesc] [nvarchar](255) NULL,
	[TrainingTitle] [nvarchar](255) NULL,
	[TrainingTravelIndicator] [nvarchar](255) NULL,
	[TrainingTypeCode] [nvarchar](255) NULL,
	[TrainingTypeDesc] [nvarchar](255) NULL,
	[TravelCosts] [float] NULL,
	[TutionAndFees] [float] NULL,
	[TypeOfPaymentCode] [nvarchar](255) NULL,
	[TypeOfPaymentDesc] [nvarchar](255) NULL,
	[VendorName] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [TssTDS_PK] PRIMARY KEY NONCLUSTERED 
(
	[TssTDSID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[TssTDS]  WITH CHECK ADD  CONSTRAINT [TssTDS_FK01] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[TssTDS] CHECK CONSTRAINT [TssTDS_FK01]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains person unique training records.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TssTDS'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TssTDS'
GO
