USE [HRDW]
GO
/****** Object:  Table [RWT].[UserInfo]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RWT].[UserInfo](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NULL,
	[Account] [nvarchar](255) NULL,
	[Work e-mail] [nvarchar](255) NULL,
	[About me] [ntext] NULL,
	[SIP Address] [nvarchar](255) NULL,
	[Is Site Admin] [bit] NULL,
	[Deleted] [bit] NULL,
	[Picture] [ntext] NULL,
	[Department] [nvarchar](255) NULL,
	[Title] [nvarchar](255) NULL,
	[First name] [nvarchar](255) NULL,
	[Last name] [nvarchar](255) NULL,
	[Work phone] [nvarchar](255) NULL,
	[Office] [nvarchar](255) NULL,
	[User name] [nvarchar](255) NULL,
	[Web site] [ntext] NULL,
	[Responsibilities] [ntext] NULL,
	[Attachments] [ntext] NULL,
	[LastUptimestampstamp] [timestamp] NULL,
	[LastUpdateUser] [nvarchar](50) NULL,
 CONSTRAINT [UserInfo_pk] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [RWT].[UserInfo] ADD  DEFAULT (suser_name()) FOR [LastUpdateUser]
GO
