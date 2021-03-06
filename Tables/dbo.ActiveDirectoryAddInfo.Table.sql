USE [HRDW]
GO
/****** Object:  Table [dbo].[ActiveDirectoryAddInfo]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActiveDirectoryAddInfo](
	[UserPrincipalName] [nvarchar](255) NOT NULL,
	[ADDomain] [nvarchar](255) NULL,
	[sAMAccountName] [nvarchar](255) NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[PwdLastSet] [datetime] NULL,
	[Affiliation] [nvarchar](255) NULL,
	[LastUpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [ActiveDirectoryAddInfo_pk] PRIMARY KEY NONCLUSTERED 
(
	[UserPrincipalName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ActiveDirectoryAddInfo] ADD  DEFAULT (getdate()) FOR [LastUpdateTimestamp]
GO
