USE [HRDW]
GO
/****** Object:  Table [RWT].[Posn Mgmt]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RWT].[Posn Mgmt](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Record Date] [nvarchar](255) NULL,
	[Position Agency Subelement Code] [nvarchar](255) NULL,
	[Office Symbol] [nvarchar](255) NULL,
	[Position Control Number] [nvarchar](255) NULL,
	[Position Control Number Indicator] [nvarchar](255) NULL,
	[Position Title] [nvarchar](255) NULL,
	[PD Number] [nvarchar](255) NULL,
	[Position Sequence Number] [nvarchar](255) NULL,
	[PP-Series-Grade] [nvarchar](255) NULL,
	[Target Grade Or Level] [nvarchar](255) NULL,
	[Supervisory Status Code] [nvarchar](255) NULL,
	[Flsa Category Code] [nvarchar](255) NULL,
	[Reporting to PCN] [nvarchar](255) NULL,
	[Reporting to PCN Indicator] [nvarchar](255) NULL,
	[Reporting to Position Office Symbol] [nvarchar](255) NULL,
	[Position Encumbered Type] [nvarchar](255) NULL,
	[Employee Number] [nvarchar](255) NULL,
	[Full Name] [nvarchar](255) NULL,
	[Available for Hiring?] [nvarchar](255) NULL,
	[Position Obligated?] [nvarchar](255) NULL,
	[Obligated Employee Full Name] [nvarchar](255) NULL,
	[Position Detailed?] [nvarchar](255) NULL,
	[Detailed Employee Full Name] [nvarchar](255) NULL,
	[Funding Status] [nvarchar](255) NULL,
	[Funding Full Time Equivalent] [nvarchar](255) NULL,
	[Bargaining Unit Status Code] [nvarchar](255) NULL,
	[Supervisor Employee Number] [nvarchar](255) NULL,
	[Personnel Office ID Code] [nvarchar](255) NULL,
	[Duty Station Name] [nvarchar](255) NULL,
	[Duty Station State or Country Desc] [nvarchar](255) NULL,
	[Supervisory Status Description] [nvarchar](255) NULL,
	[Supervisor First Name] [nvarchar](255) NULL,
	[Supervisor Middle Name] [nvarchar](255) NULL,
	[Supervisor Last Name] [nvarchar](255) NULL,
	[Appropriation Code 1] [nvarchar](255) NULL,
	[Block Number Code] [nvarchar](255) NULL,
	[LastUptimestampstamp] [timestamp] NULL,
	[LastUpdateUser] [nvarchar](50) NULL
) ON [PRIMARY]

GO
ALTER TABLE [RWT].[Posn Mgmt] ADD  DEFAULT (suser_name()) FOR [LastUpdateUser]
GO
