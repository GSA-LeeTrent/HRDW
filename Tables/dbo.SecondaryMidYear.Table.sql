USE [HRDW]
GO
/****** Object:  Table [dbo].[SecondaryMidYear]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SecondaryMidYear](
	[SecondaryMidYearID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[StandardPattern] [nvarchar](255) NULL,
	[RatingPeriodStart] [date] NULL,
	[RatingPeriodEnd] [date] NULL,
	[High3] [int] NULL,
	[OverallRating] [int] NULL,
	[FinalPerformancePlanIssue] [date] NULL,
	[AP_STATUS] [nvarchar](255) NULL,
	[AppraisalTypeDescription] [nvarchar](255) NULL,
	[AP_TYPE_DESC] [nvarchar](255) NULL,
	[AppraisalStatus] [nvarchar](255) NULL,
	[CurrentManagerID] [int] NULL,
	[FAPManagerID] [int] NULL,
	[MidYearManagerID] [int] NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [SecondaryMidYear_PK] PRIMARY KEY NONCLUSTERED 
(
	[SecondaryMidYearID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[SecondaryMidYear]  WITH CHECK ADD  CONSTRAINT [SecondaryMidYear_FK01] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[SecondaryMidYear] CHECK CONSTRAINT [SecondaryMidYear_FK01]
GO
ALTER TABLE [dbo].[SecondaryMidYear]  WITH CHECK ADD  CONSTRAINT [SecondaryMidYear_FK02] FOREIGN KEY([CurrentManagerID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[SecondaryMidYear] CHECK CONSTRAINT [SecondaryMidYear_FK02]
GO
ALTER TABLE [dbo].[SecondaryMidYear]  WITH CHECK ADD  CONSTRAINT [SecondaryMidYear_FK03] FOREIGN KEY([FAPManagerID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[SecondaryMidYear] CHECK CONSTRAINT [SecondaryMidYear_FK03]
GO
ALTER TABLE [dbo].[SecondaryMidYear]  WITH CHECK ADD  CONSTRAINT [SecondaryMidYear_FK04] FOREIGN KEY([MidYearManagerID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[SecondaryMidYear] CHECK CONSTRAINT [SecondaryMidYear_FK04]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains person unique midyear performance ratings.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SecondaryMidYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SecondaryMidYear'
GO
