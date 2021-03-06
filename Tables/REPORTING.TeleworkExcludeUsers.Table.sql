USE [HRDW]
GO
/****** Object:  Table [REPORTING].[TeleworkExcludeUsers]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [REPORTING].[TeleworkExcludeUsers](
	[EmailAddress] [nvarchar](255) NOT NULL,
	[FullName] [nvarchar](255) NULL,
 CONSTRAINT [TeleworkExcludeUsers_pk] PRIMARY KEY NONCLUSTERED 
(
	[EmailAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
