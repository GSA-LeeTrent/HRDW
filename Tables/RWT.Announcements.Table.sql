USE [HRDW]
GO
/****** Object:  Table [RWT].[Announcements]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RWT].[Announcements](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[RPA#] [nvarchar](255) NULL,
	[Vac Annct #] [nvarchar](255) NULL,
	[Type of Ann] [nvarchar](25) NULL,
	[Vac Annct Opened] [datetime] NULL,
	[Vac Annct Closed] [datetime] NULL,
	[Applicants Notified] [datetime] NULL,
	[First Cert Issued] [datetime] NULL,
	[Last Cert Issued] [datetime] NULL,
	[Cert Expiration] [datetime] NULL,
	[Mgr Ret'd Cert] [datetime] NULL,
	[Selection Made] [bit] NULL,
	[Selectee Last Name] [nvarchar](50) NULL,
	[Selectee First Name] [nvarchar](50) NULL,
	[Type of Selection] [nvarchar](50) NULL,
	[Reg] [nvarchar](2) NULL,
	[FY] [nvarchar](2) NULL,
	[Journal_Nbr] [float] NULL,
	[HiringAuthority] [nvarchar](255) NULL,
	[RPA_ID] [int] NULL,
	[LastUpdateUser] [nvarchar](50) NULL,
	[LastUpdateTimestamp] [timestamp] NULL,
 CONSTRAINT [Announcements_pk] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [RWT].[Announcements]  WITH CHECK ADD FOREIGN KEY([RPA_ID])
REFERENCES [RWT].[Recruit Actions] ([ID])
ON DELETE CASCADE
GO
