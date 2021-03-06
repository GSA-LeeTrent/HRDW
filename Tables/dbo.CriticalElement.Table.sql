USE [HRDW]
GO
/****** Object:  Table [dbo].[CriticalElement]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CriticalElement](
	[CriticalElementID] [int] IDENTITY(1,1) NOT NULL,
	[RunDate] [smalldatetime] NOT NULL,
	[FYDESIGNATION] [nvarchar](255) NULL,
	[PersonID] [int] NULL,
	[CriticalElementNumber] [int] NULL,
	[CriticalElementName] [nvarchar](255) NULL,
	[PercentageWeighting] [int] NULL,
	[CrticalElementRating] [int] NULL,
	[High3Element] [nvarchar](255) NULL,
	[OverallRating] [int] NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [CriticalElement_PK] PRIMARY KEY NONCLUSTERED 
(
	[CriticalElementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[CriticalElement]  WITH CHECK ADD  CONSTRAINT [CriticalElement_FK01] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[CriticalElement] CHECK CONSTRAINT [CriticalElement_FK01]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains person unique records of the criteria used to determine performance awards.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CriticalElement'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CriticalElement'
GO
