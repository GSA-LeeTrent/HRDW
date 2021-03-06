USE [HRDW]
GO
/****** Object:  Table [dbo].[Telework]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Telework](
	[TeleworkID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[TeleworkElgible] [nvarchar](3) NULL,
	[InElgibleReason] [nvarchar](255) NULL,
	[AgreementDate] [date] NULL,
	[EmpStatus] [nvarchar](255) NULL,
	[TeleworkStatus] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [Telework_PK] PRIMARY KEY NONCLUSTERED 
(
	[TeleworkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Telework]  WITH CHECK ADD  CONSTRAINT [Telework_FK02] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Telework] CHECK CONSTRAINT [Telework_FK02]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains person unique telework records.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Telework'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Telework'
GO
