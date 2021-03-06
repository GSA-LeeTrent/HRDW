USE [HRDW]
GO
/****** Object:  Table [RWT].[PDLibrary]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RWT].[PDLibrary](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[PD: PD Record ID] [nvarchar](255) NULL,
	[PD Number] [nvarchar](255) NULL,
	[Position Title] [nvarchar](255) NULL,
	[Classified By] [nvarchar](255) NULL,
	[Classified On] [datetime] NULL,
	[Servicing HR Office] [nvarchar](255) NULL,
	[Service/Staff Office/Region] [nvarchar](255) NULL,
	[PD Status] [nvarchar](255) NULL,
	[Pay Plan] [nvarchar](255) NULL,
	[Grade] [float] NULL,
	[Position Status] [nvarchar](255) NULL,
	[I/A] [nvarchar](255) NULL,
	[Position Sensitivity] [nvarchar](255) NULL,
	[Drug Test] [nvarchar](255) NULL,
	[Public Trust Indicator] [nvarchar](255) NULL,
	[Series] [nvarchar](255) NULL,
	[Supervisory Status] [nvarchar](255) NULL,
	[FPL] [nvarchar](255) NULL,
	[FLSA] [nvarchar](255) NULL,
	[Competitive Level] [nvarchar](255) NULL,
	[Financial Statement] [nvarchar](255) NULL,
	[Occupational Category Code] [nvarchar](255) NULL,
	[LastUpdateUser] [nvarchar](50) NULL,
	[LastUpdateTimestamp] [timestamp] NULL,
 CONSTRAINT [PDLibrary_pk] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [RWT].[PDLibrary] ADD  DEFAULT (suser_name()) FOR [LastUpdateUser]
GO
