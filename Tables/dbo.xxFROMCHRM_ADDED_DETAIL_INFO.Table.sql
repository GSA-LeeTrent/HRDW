USE [HRDW]
GO
/****** Object:  Table [dbo].[xxFROMCHRM_ADDED_DETAIL_INFO]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xxFROMCHRM_ADDED_DETAIL_INFO](
	[SSN] [varchar](11) NULL,
	[DetailNTEStartDate] [datetime] NULL,
	[DetailUniqueID] [varchar](31) NULL,
	[DetailNTE] [datetime] NULL,
	[PosAddressOrgAgySubelmntCode] [varchar](4) NULL,
	[PosAddressOrgAgySubelmntDesc] [varchar](255) NULL,
	[DetailOrganizationName] [varchar](255) NULL,
	[DetailPositionAgencySubelementCode] [varchar](4) NULL,
	[DetailPositionAgencySubelementCodeDesc] [varchar](255) NULL,
	[DetailType] [varchar](1) NULL,
	[DetailTypeDescription] [varchar](255) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
