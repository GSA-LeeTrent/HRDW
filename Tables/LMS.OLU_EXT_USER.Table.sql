USE [HRDW]
GO
/****** Object:  Table [LMS].[OLU_EXT_USER]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LMS].[OLU_EXT_USER](
	[ExtID] [int] IDENTITY(1,1) NOT NULL,
	[ExtUserID] [int] NULL,
	[Status] [nvarchar](20) NULL,
	[EmailAddress] [nvarchar](50) NULL,
	[FirstName] [nvarchar](150) NULL,
	[LastName] [nvarchar](150) NULL,
	[MiddleName] [nvarchar](150) NULL,
	[Agency] [nvarchar](50) NULL,
	[Program] [nvarchar](50) NULL,
	[Title] [nvarchar](150) NULL,
	[GSAAgencySponsor] [nvarchar](255) NULL,
	[SupervisorEmailAddress] [nvarchar](255) NULL,
	[AccountExpiration] [date] NULL,
	[RecertificationDue] [datetime] NULL,
	[SponsoringAgency] [nvarchar](25) NULL,
	[RecordCreated] [datetime] NULL,
	[InactivatedDate] [datetime] NULL,
	[LastUpdateTimestamp] [datetime] NULL,
 CONSTRAINT [EXT_USER_INFO_PK] PRIMARY KEY NONCLUSTERED 
(
	[ExtID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [LMS].[OLU_EXT_USER] ADD  DEFAULT (getdate()) FOR [LastUpdateTimestamp]
GO
