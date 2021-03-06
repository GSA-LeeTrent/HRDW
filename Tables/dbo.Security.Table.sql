USE [HRDW]
GO
/****** Object:  Table [dbo].[Security]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Security](
	[SecurityID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[RecordDate] [smalldatetime] NULL,
	[ClearanceCurrent] [nvarchar](255) NULL,
	[ClearanceDate] [date] NULL,
	[InvestigationType] [nvarchar](255) NULL,
	[ClearanceDescription] [nvarchar](255) NULL,
	[SecurityClearanceNumber] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [Security_PK] PRIMARY KEY NONCLUSTERED 
(
	[SecurityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Security]  WITH CHECK ADD  CONSTRAINT [Security_FK01] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Security] CHECK CONSTRAINT [Security_FK01]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains person unique records.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Security'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Security'
GO
