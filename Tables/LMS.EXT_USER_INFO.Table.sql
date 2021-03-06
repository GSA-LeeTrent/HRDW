USE [HRDW]
GO
/****** Object:  Table [LMS].[EXT_USER_INFO]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LMS].[EXT_USER_INFO](
	[ExtUserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](25) NULL,
	[Agency] [nvarchar](50) NULL,
	[RecordCreated] [datetime] NULL,
	[RecertificationDue] [datetime] NULL,
	[SponsoringAgency] [nvarchar](25) NULL,
	[InactivatedDate] [datetime] NULL,
 CONSTRAINT [aaaaaEXT_USER_INFO_PK] PRIMARY KEY NONCLUSTERED 
(
	[ExtUserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
