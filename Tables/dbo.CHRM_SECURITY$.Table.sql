USE [HRDW]
GO
/****** Object:  Table [dbo].[CHRM_SECURITY$]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHRM_SECURITY$](
	[Record Date] [datetime] NULL,
	[Social Security] [nvarchar](255) NULL,
	[Clearance Date] [datetime] NULL,
	[Investigation_Type] [nvarchar](255) NULL,
	[Clearance_Description] [nvarchar](255) NULL,
	[Security_Clearance_Number] [nvarchar](255) NULL
) ON [PRIMARY]

GO
