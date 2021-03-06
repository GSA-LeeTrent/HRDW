USE [HRDW]
GO
/****** Object:  Table [LMS].[CD_LABEL]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LMS].[CD_LABEL](
	[STATUS] [nvarchar](25) NULL,
	[USERID] [nvarchar](25) NOT NULL,
	[USERNAME] [nvarchar](25) NULL,
	[FIRSTNAME] [nvarchar](25) NULL,
	[LASTNAME] [nvarchar](25) NULL,
	[MIDDLE] [nvarchar](25) NULL,
	[GENDER] [nvarchar](25) NULL,
	[EMAIL] [nvarchar](25) NULL,
	[MANAGER] [nvarchar](25) NULL,
	[HR] [nvarchar](25) NULL,
	[DIVISION] [nvarchar](25) NULL,
	[DEPARTMENT] [nvarchar](25) NULL,
	[LOCATION] [nvarchar](25) NULL,
	[JOBCODE] [nvarchar](25) NULL,
	[TIMEZONE] [nvarchar](25) NULL,
	[HIREDATE] [nvarchar](25) NULL,
	[EMPID] [nvarchar](25) NULL,
	[TITLE] [nvarchar](25) NULL,
	[BIZ_PHONE] [nvarchar](25) NULL,
	[FAX] [nvarchar](25) NULL,
	[ADDR1] [nvarchar](25) NULL,
	[ADDR2] [nvarchar](25) NULL,
	[CITY] [nvarchar](25) NULL,
	[STATE] [nvarchar](25) NULL,
	[ZIP] [nvarchar](25) NULL,
	[COUNTRY] [nvarchar](25) NULL,
	[REVIEW_FREQ] [nvarchar](25) NULL,
	[LAST_REVIEW_DATE] [nvarchar](25) NULL,
	[CUSTOM01] [nvarchar](25) NULL,
	[CUSTOM02] [nvarchar](25) NULL,
	[CUSTOM03] [nvarchar](25) NULL,
	[CUSTOM04] [nvarchar](25) NULL,
	[CUSTOM05] [nvarchar](25) NULL,
	[CUSTOM06] [nvarchar](25) NULL,
	[CUSTOM07] [nvarchar](25) NULL,
	[CUSTOM08] [nvarchar](25) NULL,
	[CUSTOM09] [nvarchar](25) NULL,
	[CUSTOM10] [nvarchar](25) NULL,
	[CUSTOM11] [nvarchar](25) NULL,
	[CUSTOM12] [nvarchar](25) NULL,
	[CUSTOM13] [nvarchar](25) NULL,
	[CUSTOM14] [nvarchar](25) NULL,
	[CUSTOM15] [nvarchar](25) NULL,
	[DEFAULT_LOCALE] [nvarchar](25) NULL,
	[LOGIN_METHOD] [nvarchar](25) NULL,
 CONSTRAINT [aaaaaCD_LABEL_PK] PRIMARY KEY NONCLUSTERED 
(
	[USERID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
