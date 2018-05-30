USE [HRDW]
GO
/****** Object:  Table [dbo].[xxPerformanceHigh3]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xxPerformanceHigh3](
	[Run Date] [date] NULL,
	[Employee SSN] [varchar](11) NULL,
	[High 3 Only] [varchar](3) NULL,
	[FY] [varchar](6) NULL,
	[PersonID] [int] NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
