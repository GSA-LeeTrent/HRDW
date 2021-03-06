USE [HRDW]
GO
/****** Object:  Table [LMS].[EXT_USER]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LMS].[EXT_USER](
	[STATUS] [nvarchar](255) NULL,
	[USERID] [nvarchar](255) NOT NULL,
	[USERNAME] [nvarchar](255) NULL,
	[FIRSTNAME] [nvarchar](255) NULL,
	[LASTNAME] [nvarchar](255) NULL,
	[MIDDLE] [nvarchar](255) NULL,
	[GENDER] [nvarchar](255) NULL,
	[EMAIL] [nvarchar](255) NULL,
	[MANAGER] [nvarchar](255) NULL,
	[HR] [nvarchar](255) NULL,
	[DIVISION] [nvarchar](255) NULL,
	[DEPARTMENT] [nvarchar](255) NULL,
	[LOCATION] [nvarchar](255) NULL,
	[JOBCODE] [nvarchar](255) NULL,
	[TIMEZONE] [nvarchar](255) NULL,
	[HIREDATE] [nvarchar](255) NULL,
	[EMPID] [nvarchar](255) NULL,
	[TITLE] [nvarchar](255) NULL,
	[BIZ_PHONE] [nvarchar](255) NULL,
	[FAX] [nvarchar](255) NULL,
	[ADDR1] [nvarchar](255) NULL,
	[ADDR2] [nvarchar](255) NULL,
	[CITY] [nvarchar](255) NULL,
	[STATE] [nvarchar](255) NULL,
	[ZIP] [nvarchar](255) NULL,
	[COUNTRY] [nvarchar](255) NULL,
	[REVIEW_FREQ] [nvarchar](255) NULL,
	[LAST_REVIEW_DATE] [nvarchar](255) NULL,
	[CUSTOM01] [nvarchar](255) NULL,
	[CUSTOM02] [nvarchar](255) NULL,
	[CUSTOM03] [nvarchar](255) NULL,
	[CUSTOM04] [nvarchar](255) NULL,
	[CUSTOM05] [nvarchar](255) NULL,
	[CUSTOM06] [nvarchar](255) NULL,
	[CUSTOM07] [nvarchar](255) NULL,
	[CUSTOM08] [nvarchar](255) NULL,
	[CUSTOM09] [datetime] NULL,
	[CUSTOM10] [nvarchar](255) NULL,
	[CUSTOM11] [nvarchar](255) NULL,
	[CUSTOM12] [nvarchar](255) NULL,
	[CUSTOM13] [nvarchar](255) NULL,
	[CUSTOM14] [nvarchar](255) NULL,
	[CUSTOM15] [nvarchar](255) NULL,
	[DEFAULT_LOCALE] [nvarchar](255) NULL,
	[LOGIN_METHOD] [nvarchar](255) NULL,
 CONSTRAINT [aaaaaEXT_USER_PK] PRIMARY KEY NONCLUSTERED 
(
	[USERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [LMS].[EXT_USER] ADD  DEFAULT ('Active') FOR [STATUS]
GO
ALTER TABLE [LMS].[EXT_USER] ADD  DEFAULT ('NO_MANAGER') FOR [MANAGER]
GO
ALTER TABLE [LMS].[EXT_USER] ADD  DEFAULT ('NO_HR') FOR [HR]
GO
