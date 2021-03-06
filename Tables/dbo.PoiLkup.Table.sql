USE [HRDW]
GO
/****** Object:  Table [dbo].[PoiLkup]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PoiLkup](
	[PoiLkupID] [int] IDENTITY(1,1) NOT NULL,
	[PersonnelOfficeID] [numeric](4, 0) NOT NULL,
	[PersonnelOfficeIDDescription] [nvarchar](50) NOT NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [PoiLkup_PK] PRIMARY KEY NONCLUSTERED 
(
	[PoiLkupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains sensitive records pertaining to the Personnel records.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PoiLkup'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be used to used to decode Personnel Office symbols.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PoiLkup'
GO
