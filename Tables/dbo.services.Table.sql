USE [HRDW]
GO
/****** Object:  Table [dbo].[services]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[services](
	[SERVICECODE] [varchar](50) NULL,
	[SERVICENAME] [varchar](50) NULL,
	[SERVICEABBR] [varchar](50) NULL,
	[SERVICESYMBOL] [varchar](50) NULL,
	[SERVICEFUND] [varchar](50) NULL,
	[SERVICEORG] [varchar](50) NULL,
	[SERVICENOTES] [varchar](50) NULL,
	[SERVICEBEGIN] [varchar](50) NULL,
	[SERVICEEND] [varchar](50) NULL,
	[SERVICEFROMPAR] [varchar](50) NULL,
	[REGIONFROMPAR] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
