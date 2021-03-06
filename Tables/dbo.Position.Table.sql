USE [HRDW]
GO
/****** Object:  Table [dbo].[Position]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Position](
	[PositionID] [int] IDENTITY(1,1) NOT NULL,
	[RecordDate] [date] NOT NULL,
	[WorkTelephone] [nvarchar](255) NULL,
	[LeaveCateGOry] [nvarchar](255) NULL,
	[TenureDescription] [nvarchar](255) NULL,
	[CompetativeArea] [nvarchar](64) NULL,
	[CompetativeLevel] [nvarchar](64) NULL,
	[WorkScheduleDescription] [nvarchar](255) NULL,
	[BargainingUnitStatusCode] [nvarchar](255) NULL,
	[BargainingUnitStatusDescription] [nvarchar](255) NULL,
	[YOSGSA] [float] NULL,
	[YOS_FEDERAL] [float] NULL,
	[MCO] [nvarchar](255) NULL,
	[FlsaCateGOryCode] [nvarchar](255) NULL,
	[FlsaCateGOryDescription] [nvarchar](255) NULL,
	[DrugTestCode] [nvarchar](255) NULL,
	[DrugTestDescription] [nvarchar](255) NULL,
	[KeyEmergencyEssentialCode] [nvarchar](255) NULL,
	[KeyEmergencyEssentialDescription] [nvarchar](255) NULL,
	[AssignmentUSErStatus] [nvarchar](255) NULL,
	[WorkCellPhoneNumber] [nvarchar](255) NULL,
	[VorS] [char](1) NULL,
	[FurloughIndicator] [nvarchar](255) NULL,
	[FurloughIndicatorDesc] [nvarchar](255) NULL,
	[WorkAddressLine1] [nvarchar](255) NULL,
	[WorkAddressLine2] [nvarchar](255) NULL,
	[WorkAddressLine3] [nvarchar](255) NULL,
	[WorkBuilding] [nvarchar](255) NULL,
	[WorkCity] [nvarchar](255) NULL,
	[WorkCounty] [nvarchar](255) NULL,
	[WorkState] [nvarchar](255) NULL,
	[WorkZip] [nvarchar](255) NULL,
	[PosOrgAgySubelementCode] [nvarchar](255) NULL,
	[PosOrgAgySubelementDesc] [nvarchar](255) NULL,
	[PosAddressOrgInfoLine1] [nvarchar](255) NULL,
	[PosAddressOrgInfoLine2] [nvarchar](255) NULL,
	[PosAddressOrgInfoLine3] [nvarchar](255) NULL,
	[PosAddressOrgInfoLine4] [nvarchar](255) NULL,
	[PosAddressOrgInfoLine5] [nvarchar](255) NULL,
	[PosAddressOrgInfoLine6] [nvarchar](255) NULL,
	[AvailableForHiring] [nvarchar](255) NULL,
	[CybersecurityCode] [nvarchar](255) NULL,
	[CybersecurityCodeDesc] [nvarchar](255) NULL,
	[FY] [nvarchar](6) NULL,
	[PublicTrustIndicatorDesc] [nvarchar](255) NULL,
	[PublicTrustIndicatorCode] [nvarchar](255) NULL,
	[TeleworkIndicator] [nvarchar](255) NULL,
	[TeleworkIndicatorDescription] [nvarchar](255) NULL,
	[TeleworkIneligibilityReason] [nvarchar](255) NULL,
	[TeleworkIneligibReasonDescription] [nvarchar](255) NULL,
	[PersonID] [int] NULL,
	[DutyStationID] [int] NULL,
	[FinancialsID] [int] NULL,
	[PersonnelOfficeID] [int] NULL,
	[ChrisPositionID] [int] NULL,
	[DetailedPositionID] [int] NULL,
	[ObligatedPositionID] [int] NULL,
	[PositionDateID] [int] NULL,
	[PayID] [int] NULL,
	[IsHistoric] [int] NOT NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [Position_PK] PRIMARY KEY NONCLUSTERED 
(
	[PositionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Position] ADD  DEFAULT ((0)) FOR [IsHistoric]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [Position_FK01] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [Position_FK01]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [Position_FK02] FOREIGN KEY([DutyStationID])
REFERENCES [dbo].[DutyStation] ([DutyStationID])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [Position_FK02]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [Position_FK04] FOREIGN KEY([FinancialsID])
REFERENCES [dbo].[Financials] ([FinancialsID])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [Position_FK04]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [Position_FK05] FOREIGN KEY([PersonnelOfficeID])
REFERENCES [dbo].[PersonnelOffice] ([PersonnelOfficeID])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [Position_FK05]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [Position_FK06] FOREIGN KEY([ChrisPositionID])
REFERENCES [dbo].[PositionInfo] ([PositionInfoID])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [Position_FK06]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [Position_FK07] FOREIGN KEY([DetailedPositionID])
REFERENCES [dbo].[PositionInfo] ([PositionInfoID])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [Position_FK07]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [Position_FK08] FOREIGN KEY([ObligatedPositionID])
REFERENCES [dbo].[PositionInfo] ([PositionInfoID])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [Position_FK08]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [Position_FK09] FOREIGN KEY([PositionDateID])
REFERENCES [dbo].[PositionDate] ([PositionDateID])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [Position_FK09]
GO
ALTER TABLE [dbo].[Position]  WITH CHECK ADD  CONSTRAINT [Position_FK10] FOREIGN KEY([PayID])
REFERENCES [dbo].[Pay] ([PayID])
GO
ALTER TABLE [dbo].[Position] CHECK CONSTRAINT [Position_FK10]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains person unique records pertaining to their positions.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Position'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Position'
GO
