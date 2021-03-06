USE [HRDW]
GO
/****** Object:  Table [dbo].[xxservices]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xxservices](
	[SERVICECODE] [varchar](20) NULL,
	[SERVICENAME] [varchar](255) NULL,
	[SERVICEABBR] [varchar](20) NULL,
	[SERVICESYMBOL] [varchar](5) NULL,
	[SERVICEFUND] [varchar](4) NULL,
	[SERVICEORG] [varchar](5) NULL,
	[SERVICENOTES] [varchar](50) NULL,
	[SERVICEBEGIN] [varchar](20) NULL,
	[SERVICEEND] [varchar](20) NULL,
	[SERVICEFROMPAR] [varchar](1) NULL,
	[REGIONFROMPAR] [varchar](2) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
