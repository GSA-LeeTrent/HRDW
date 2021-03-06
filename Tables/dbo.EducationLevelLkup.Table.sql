USE [HRDW]
GO
/****** Object:  Table [dbo].[EducationLevelLkup]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EducationLevelLkup](
	[EducationLevelLkupID] [int] IDENTITY(1,1) NOT NULL,
	[EducationLevelCode] [int] NULL,
	[ShortDescription] [nvarchar](255) NULL,
	[LongDescription] [nvarchar](max) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [EducationLevelLkup_pk] PRIMARY KEY NONCLUSTERED 
(
	[EducationLevelLkupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
