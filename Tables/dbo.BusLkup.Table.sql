USE [HRDW]
GO
/****** Object:  Table [dbo].[BusLkup]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[BusLkup](
	[BusLkupID] [int] IDENTITY(1,1) NOT NULL,
	[BargainingUnitStatusCode] [int] NULL,
	[BargainingUnitOrg] [nvarchar](255) NULL,
	[BargainingUnitStatusCodeGroup] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [BusLkup_PK] PRIMARY KEY NONCLUSTERED 
(
	[BusLkupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
