USE [HRDW]
GO
/****** Object:  Table [dbo].[xxRnoLkup]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxRnoLkup](
	[RnoCode] [float] NULL,
	[RaceNationalOrigin] [nvarchar](255) NULL,
	[RnoCategory] [nvarchar](255) NULL,
	[MinorityStatus] [nvarchar](255) NULL,
	[RnoDescription] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL
) ON [PRIMARY]

GO
