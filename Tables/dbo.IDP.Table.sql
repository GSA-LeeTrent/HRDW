USE [HRDW]
GO
/****** Object:  Table [dbo].[IDP]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[IDP](
	[IDPID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[FiscalYearValidation] [nvarchar](4) NULL,
	[IDPStatus] [nvarchar](128) NULL,
	[IDPRecordNumber] [nvarchar](128) NULL,
	[SharedIDPsRecordType] [nvarchar](255) NULL,
	[SharedIDPsLastModifiedDate] [date] NULL,
	[ShortTermCareerGoalsUnder4Years] [nvarchar](max) NULL,
	[LongTermCareerGoalsOver3Years] [nvarchar](max) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [IDP_PK] PRIMARY KEY NONCLUSTERED 
(
	[IDPID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [dbo].[IDP]  WITH CHECK ADD  CONSTRAINT [IDP_FK01] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[IDP] CHECK CONSTRAINT [IDP_FK01]
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains person unique Indivudial Development Plan records.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IDP'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'IDP'
GO
