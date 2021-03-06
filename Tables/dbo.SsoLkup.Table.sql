USE [HRDW]
GO
/****** Object:  Table [dbo].[SsoLkup]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SsoLkup](
	[SsoLkupID] [int] IDENTITY(1,1) NOT NULL,
	[PosOrgAgySubelementCode] [nvarchar](255) NULL,
	[PosOrgAgySubelementDescription] [nvarchar](255) NULL,
	[SsoAbbreviation] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [SsoLkup_pk] PRIMARY KEY NONCLUSTERED 
(
	[SsoLkupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
