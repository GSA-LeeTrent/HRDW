USE [HRDW]
GO
/****** Object:  Table [dbo].[xxEducationLevelLkup]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxEducationLevelLkup](
	[EducationLevelCode] [int] NULL,
	[ShortDescription] [nvarchar](255) NULL,
	[LongDescription] [nvarchar](max) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
