USE [HRDW]
GO
/****** Object:  Table [dbo].[PositionDate]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PositionDate](
	[PositionDateID] [int] IDENTITY(1,1) NOT NULL,
	[LatestHireDate] [date] NULL,
	[DateLastPromotion] [date] NULL,
	[DateProbTrialPeriodBegins] [date] NULL,
	[DateProbTrialPeriodEnds] [date] NULL,
	[DateConversionCareerDue] [date] NULL,
	[DateConversionCareerBegins] [date] NULL,
	[WGIDateDue] [date] NULL,
	[DateVRAConversionDue] [date] NULL,
	[DetailNTEStartDate] [date] NULL,
	[DetailNTEdate] [date] NULL,
	[DateofSESAppointment] [date] NULL,
	[DateSESProbExpires] [date] NULL,
	[WGILastEquivalentIncreaseDate] [date] NULL,
	[SCDCivilian] [date] NULL,
	[SCDLeave] [date] NULL,
	[ComputeEarlyRetirment] [date] NULL,
	[ComputeOptionalRetirement] [date] NULL,
	[ArrivedPersonnelOffice] [date] NULL,
	[ArrivedPresentGrade] [date] NULL,
	[ArrivedPresentPosition] [date] NULL,
	[PayPeriodEndDate] [date] NULL,
	[DateSpvrMgrProbEnds] [date] NULL,
	[Serv05Date] [date] NULL,
	[Serv10Date] [date] NULL,
	[Serv15Date] [date] NULL,
	[Serv20Date] [date] NULL,
	[Serv25Date] [date] NULL,
	[Serv30Date] [date] NULL,
	[Serv35Date] [date] NULL,
	[Serv40Date] [date] NULL,
	[Serv45Date] [date] NULL,
	[Serv50Date] [date] NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
	[LatestSeparationDate] [date] NULL,
	[LWOPNTE] [date] NULL,
	[LWOPNTEStartDate] [date] NULL,
	[LWPNTE] [date] NULL,
	[LWPNTEStartDate] [date] NULL,
	[SabbaticalNTE] [date] NULL,
	[SabbaticalNTEStartDate] [date] NULL,
	[SuspensionNTE] [date] NULL,
	[SuspensionNTEStartDate] [date] NULL,
	[TempPromotionNTEDate] [date] NULL,
	[TempPromotionNTEStartDate] [date] NULL,
	[TempReassignmentNTEDate] [date] NULL,
	[TempReassignNTEStartDate] [date] NULL,
	[Retirement_SCD] [date] NULL,
	[SCD_LengthOfService] [date] NULL,
	[SCD_RIF] [date] NULL,
 CONSTRAINT [PositionDate_PK] PRIMARY KEY NONCLUSTERED 
(
	[PositionDateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains person unique records pertaining to position events.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PositionDate'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PositionDate'
GO
