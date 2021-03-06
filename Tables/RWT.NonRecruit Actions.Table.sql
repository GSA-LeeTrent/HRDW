USE [HRDW]
GO
/****** Object:  Table [RWT].[NonRecruit Actions]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RWT].[NonRecruit Actions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Center] [nvarchar](255) NULL,
	[RPA#] [nvarchar](255) NULL,
	[Org] [nvarchar](255) NULL,
	[PCN] [nvarchar](255) NULL,
	[PCN Ind] [nvarchar](255) NULL,
	[HR Consultant] [nvarchar](255) NULL,
	[NonRecruit Type] [nvarchar](255) NULL,
	[Employee] [nvarchar](255) NULL,
	[Rec'd in HR] [datetime] NULL,
	[To CPC for Proc] [datetime] NULL,
	[RPA Cancelled] [datetime] NULL,
	[Eff Date] [datetime] NULL,
	[Comments/Notes] [nvarchar](255) NULL,
	[Off Symbol] [nvarchar](255) NULL,
	[Position Title] [nvarchar](255) NULL,
	[PD#] [nvarchar](255) NULL,
	[PP-Ser-Gr] [nvarchar](255) NULL,
	[FPL] [nvarchar](255) NULL,
	[Supv] [nvarchar](255) NULL,
	[LastUptimestampstamp] [timestamp] NULL,
	[LastUpdateUser] [nvarchar](50) NULL,
 CONSTRAINT [NonRecruitActions_pk] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [RWT].[NonRecruit Actions] ADD  DEFAULT (suser_name()) FOR [LastUpdateUser]
GO
