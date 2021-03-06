USE [HRDW]
GO
/****** Object:  Table [dbo].[xxPerformancePMUHistory]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xxPerformancePMUHistory](
	[Record Date] [datetime] NULL,
	[Social Security] [varchar](11) NULL,
	[Full Name] [varchar](255) NULL,
	[Valid Pay Plan] [varchar](20) NULL,
	[Valid Grade Or Level] [varchar](20) NULL,
	[Employee Type] [varchar](50) NULL,
	[Latest Hire Date] [date] NULL,
	[Last Seperation Date] [date] NULL,
	[Office Symbol] [varchar](20) NULL,
	[Organization Agency Subelement Desc] [varchar](255) NULL,
	[Organization Agency Subelement Code] [varchar](20) NULL,
	[Personnel Office ID Code] [varchar](20) NULL,
	[Personnel Office ID Description] [varchar](255) NULL,
	[Pos Org Agy Subelement Desc] [varchar](255) NULL,
	[Bargaining Unit Status Code] [varchar](20) NULL,
	[Bargaining Unit Status Description] [varchar](255) NULL,
	[Total Pay] [money] NULL,
	[Posn_Supervisor] [varchar](255) NULL,
	[FY] [varchar](6) NULL,
	[PersonID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
