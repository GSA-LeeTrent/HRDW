USE [HRDW]
GO
/****** Object:  Table [dbo].[xxGhrNatureOfActionsLkup]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxGhrNatureOfActionsLkup](
	[NoacCode] [nvarchar](255) NULL,
	[FamilyNoacs] [nvarchar](255) NULL,
	[NoacDescription] [nvarchar](255) NULL,
	[NoaGrouping] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL
) ON [PRIMARY]

GO
