USE [HRDW]
GO
/****** Object:  Table [dbo].[xxGSAOrganizations]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxGSAOrganizations](
	[Office Symbol] [nvarchar](50) NULL,
	[Pos Organization Name] [nvarchar](50) NULL,
	[Pos Org Date Abolished] [date] NULL,
	[Pos Org Created By Order] [nvarchar](255) NULL,
	[Pos Org Effective Start Date] [date] NULL,
	[Pos Org Effective End Date] [date] NULL,
	[Pos Address Org Changed By Order] [nvarchar](255) NULL,
	[Pos Address Org Date Of Last Chg] [date] NULL,
	[Pos Org Abolished By Order] [nvarchar](255) NULL,
	[Pos Address Org Info Line 1] [nvarchar](255) NULL,
	[Pos Address Org Info Line 2] [nvarchar](255) NULL,
	[Pos Address Org Info Line 3] [nvarchar](255) NULL,
	[Pos Address Org Info Line 4] [nvarchar](255) NULL,
	[Pos Address Org Info Line 5] [nvarchar](255) NULL,
	[Pos Address Org Info Line 6] [nvarchar](255) NULL
) ON [PRIMARY]

GO
