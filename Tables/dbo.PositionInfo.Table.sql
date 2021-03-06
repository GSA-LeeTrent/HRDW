USE [HRDW]
GO
/****** Object:  Table [dbo].[PositionInfo]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PositionInfo](
	[PositionInfoID] [int] IDENTITY(1,1) NOT NULL,
	[PositionControlNumber] [int] NULL,
	[PositionInformationPD] [nvarchar](16) NULL,
	[PositionTitle] [nvarchar](64) NULL,
	[PositionSeries] [nvarchar](64) NULL,
	[PositionSeriesDesc] [nvarchar](128) NULL,
	[PositionControlIndicator] [char](1) NULL,
	[PositionSequenceNumber] [nvarchar](16) NULL,
	[PositionEncumberedType] [nvarchar](64) NULL,
	[PayPlan] [nvarchar](8) NULL,
	[Grade] [nvarchar](8) NULL,
	[Step] [nvarchar](8) NULL,
	[HssoCode] [int] NULL,
	[SupervisoryStatusCode] [nvarchar](64) NULL,
	[SupervisoryStatusDesc] [nvarchar](64) NULL,
	[PositionSensitivity] [nvarchar](64) NULL,
	[FundingStatus] [nvarchar](64) NULL,
	[FundingStatusDescription] [nvarchar](255) NULL,
	[OccupationalCateGOryCode] [nvarchar](64) NULL,
	[OccupationalCateGOryDescription] [nvarchar](255) NULL,
	[OfficeSymbol] [nvarchar](255) NULL,
	[SupvMgrProbationRequirementCode] [nvarchar](255) NULL,
	[SupvMgrProbationRequirementDesc] [nvarchar](255) NULL,
	[SupervisorID] [int] NULL,
	[TeamLeaderID] [int] NULL,
	[OccupationalSeriesCode] [nvarchar](255) NULL,
	[OccupationalSeriesDescription] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
	[TargetPayPlan] [nvarchar](8) NULL,
	[TargetGradeOrLevel] [nvarchar](8) NULL,
	[DetailType] [nvarchar](255) NULL,
	[DetailTypeDescription] [nvarchar](255) NULL,
 CONSTRAINT [PositionInfo_PK] PRIMARY KEY NONCLUSTERED 
(
	[PositionInfoID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PositionInfo]  WITH CHECK ADD  CONSTRAINT [PositionInfo_FK01] FOREIGN KEY([SupervisorID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PositionInfo] CHECK CONSTRAINT [PositionInfo_FK01]
GO
ALTER TABLE [dbo].[PositionInfo]  WITH CHECK ADD  CONSTRAINT [PositionInfo_FK02] FOREIGN KEY([TeamLeaderID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PositionInfo] CHECK CONSTRAINT [PositionInfo_FK02]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains person unique records pertaininf to positions type and indivudial supervisors.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PositionInfo'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PositionInfo'
GO
