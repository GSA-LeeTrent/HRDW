USE [HRDW]
GO
/****** Object:  Table [dbo].[xxSecondary_Reload_This_One]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxSecondary_Reload_This_One](
	[Run Date] [date] NULL,
	[Fiscal Year Rating] [nvarchar](255) NULL,
	[Employee Full Name] [nvarchar](255) NULL,
	[Rating Period Start Date] [datetime] NULL,
	[Rating Period End Date] [datetime] NULL,
	[Overall Rating] [int] NULL,
	[Unratable] [nvarchar](255) NULL,
	[Pay Plan] [nvarchar](255) NULL,
	[Employee SSN] [nvarchar](255) NULL,
	[HSSO] [nvarchar](255) NULL,
	[Appraisal Type Description] [nvarchar](255) NULL,
	[Appraisal Status] [nvarchar](255) NULL,
	[Current Manager Full Name] [nvarchar](255) NULL,
	[Current Manager SSN] [nvarchar](255) NULL,
	[FAP Manager Full Name] [nvarchar](255) NULL,
	[FAP Manager SSN] [nvarchar](255) NULL,
	[MYR Manager Full Name] [nvarchar](255) NULL,
	[MYR Manager SSN] [nvarchar](255) NULL,
	[Organization] [nvarchar](255) NULL,
	[Agency Sub Element] [nvarchar](255) NULL,
	[Owning Region] [nvarchar](255) NULL,
	[Servicing Region] [nvarchar](255) NULL,
	[Personnel Office Identifier] [nvarchar](255) NULL
) ON [PRIMARY]

GO
