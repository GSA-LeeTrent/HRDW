USE [HRDW]
GO
/****** Object:  Table [dbo].[NoaGroupingLkup]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[NoaGroupingLkup](
	[NoaGroupingLkupID] [int] IDENTITY(1,1) NOT NULL,
	[NoaGrouping] [nvarchar](255) NULL,
	[NoacCode] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [PK_NoaGroupingLkup] PRIMARY KEY NONCLUSTERED 
(
	[NoaGroupingLkupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
