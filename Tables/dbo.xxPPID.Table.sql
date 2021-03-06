USE [HRDW]
GO
/****** Object:  Table [dbo].[xxPPID]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxPPID](
	[Run Date] [smalldatetime] NULL,
	[Employee SSN] [nvarchar](255) NULL,
	[Performance Plan Issue Date] [date] NULL,
	[Rating Period Start Date] [date] NULL,
	[Rating Period End Date] [date] NULL,
	[Has PP] [nvarchar](255) NULL,
	[Agency Sub Element] [nvarchar](255) NULL,
	[HSSO] [nvarchar](255) NULL
) ON [PRIMARY]

GO
