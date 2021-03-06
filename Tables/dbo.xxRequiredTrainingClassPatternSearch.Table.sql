USE [HRDW]
GO
/****** Object:  Table [dbo].[xxRequiredTrainingClassPatternSearch]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxRequiredTrainingClassPatternSearch](
	[Required Employee Grouping per OLU] [nvarchar](255) NULL,
	[FY16 Due Date] [date] NULL,
	[How to Identify] [nvarchar](255) NULL,
	[OLU Title] [nvarchar](255) NULL,
	[Pattern Search] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL
) ON [PRIMARY]

GO
