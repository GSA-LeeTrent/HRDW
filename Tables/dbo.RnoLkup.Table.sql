USE [HRDW]
GO
/****** Object:  Table [dbo].[RnoLkup]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RnoLkup](
	[RnoLkupID] [int] IDENTITY(1,1) NOT NULL,
	[RnoCode] [float] NULL,
	[RaceNationalOrigin] [nvarchar](255) NULL,
	[RnoCategory] [nvarchar](255) NULL,
	[MinorityStatus] [nvarchar](255) NULL,
	[RnoDescription] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [RnoLkup_pk] PRIMARY KEY NONCLUSTERED 
(
	[RnoLkupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
