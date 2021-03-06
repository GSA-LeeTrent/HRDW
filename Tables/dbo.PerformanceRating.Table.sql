USE [HRDW]
GO
/****** Object:  Table [dbo].[PerformanceRating]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PerformanceRating](
	[PerformanceRatingID] [int] IDENTITY(1,1) NOT NULL,
	[RunDate] [smalldatetime] NULL,
	[FiscalYearRating] [nvarchar](255) NULL,
	[EmployeeFullName] [nvarchar](255) NULL,
	[RatingPeriodStartDate] [date] NULL,
	[RatingPeriodEndDate] [date] NULL,
	[OverallRating] [int] NULL,
	[Unratable] [nvarchar](255) NULL,
	[PayPlan] [nvarchar](255) NULL,
	[PersonID] [int] NULL,
	[HSSO] [nvarchar](255) NULL,
	[AppraisalTypeDescription] [nvarchar](255) NULL,
	[AppraisalStatus] [nvarchar](255) NULL,
	[CurrentManagerID] [int] NULL,
	[FAPManagerID] [int] NULL,
	[MidYearManagerID] [int] NULL,
	[Organization] [nvarchar](255) NULL,
	[AgencySubElement] [nvarchar](255) NULL,
	[OwningRegion] [nvarchar](255) NULL,
	[ServicingRegion] [nvarchar](255) NULL,
	[PersonnelOfficeIdentifier] [nvarchar](255) NULL,
	[UnratableReason] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
	[High3Flag] [varchar](3) NULL,
 CONSTRAINT [PerformanceRating_PK] PRIMARY KEY NONCLUSTERED 
(
	[PerformanceRatingID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PerformanceRating]  WITH CHECK ADD  CONSTRAINT [PerformanceRating_FK01] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PerformanceRating] CHECK CONSTRAINT [PerformanceRating_FK01]
GO
ALTER TABLE [dbo].[PerformanceRating]  WITH CHECK ADD  CONSTRAINT [PerformanceRating_FK02] FOREIGN KEY([CurrentManagerID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PerformanceRating] CHECK CONSTRAINT [PerformanceRating_FK02]
GO
ALTER TABLE [dbo].[PerformanceRating]  WITH CHECK ADD  CONSTRAINT [PerformanceRating_FK03] FOREIGN KEY([FAPManagerID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PerformanceRating] CHECK CONSTRAINT [PerformanceRating_FK03]
GO
ALTER TABLE [dbo].[PerformanceRating]  WITH CHECK ADD  CONSTRAINT [PerformanceRating_FK04] FOREIGN KEY([MidYearManagerID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PerformanceRating] CHECK CONSTRAINT [PerformanceRating_FK04]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains person unique records to determine Performance Ratings.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PerformanceRating'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PerformanceRating'
GO
