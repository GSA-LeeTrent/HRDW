USE [HRDW]
GO
/****** Object:  Table [dbo].[GhrNatureOfActionsLkup]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[GhrNatureOfActionsLkup](
	[GhrNatureOfActionsLkupID] [int] IDENTITY(1,1) NOT NULL,
	[NoacCode] [nvarchar](255) NULL,
	[FamilyNoacs] [nvarchar](255) NULL,
	[NoacDescription] [nvarchar](255) NULL,
	[NoaGrouping] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [GhrNatureOfActionsLkup_pk] PRIMARY KEY NONCLUSTERED 
(
	[GhrNatureOfActionsLkupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
