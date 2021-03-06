USE [HRDW]
GO
/****** Object:  Table [dbo].[PPID]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PPID](
	[PPIDID] [int] IDENTITY(1,1) NOT NULL,
	[RunDate] [smalldatetime] NULL,
	[PersonID] [int] NULL,
	[PerformancePlanIssueDate] [date] NULL,
	[RatingPeriodStartDate] [date] NULL,
	[RatingPeriodEndDate] [date] NULL,
	[HasPP] [nvarchar](255) NULL,
	[AgencySubElement] [nvarchar](255) NULL,
	[HSSO] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [PPID_PK] PRIMARY KEY NONCLUSTERED 
(
	[PPIDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[PPID]  WITH CHECK ADD  CONSTRAINT [PPID_FK01] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PPID] CHECK CONSTRAINT [PPID_FK01]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains person unique Performance Plan Issue Date (PPID) records.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPID'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PPID'
GO
