USE [HRDW]
GO
/****** Object:  Table [dbo].[xxMcoLkup]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxMcoLkup](
	[OccupationalSeriesCode] [int] NULL,
	[McoAbbreviated] [nvarchar](255) NULL,
	[McoGrouped] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL
) ON [PRIMARY]

GO
