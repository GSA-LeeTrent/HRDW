USE [HRDW]
GO
/****** Object:  Table [dbo].[xxBusLkup]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxBusLkup](
	[BargainingUnitStatusCode] [int] NULL,
	[BargainingUnitOrg] [nvarchar](255) NULL,
	[BargainingUnitStatusCodeGroup] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL
) ON [PRIMARY]

GO
