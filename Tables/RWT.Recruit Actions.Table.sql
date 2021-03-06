USE [HRDW]
GO
/****** Object:  Table [RWT].[Recruit Actions]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [RWT].[Recruit Actions](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Center] [nvarchar](255) NULL,
	[RPA#] [nvarchar](255) NULL,
	[Org] [nvarchar](255) NULL,
	[HR Consultant] [nvarchar](255) NULL,
	[NRC Consultant] [nvarchar](255) NULL,
	[Customer POC] [nvarchar](255) NULL,
	[Status] [nvarchar](255) NULL,
	[Status Date] [datetime] NULL,
	[PCN] [nvarchar](255) NULL,
	[PCN Ind] [nvarchar](255) NULL,
	[Org Code] [nvarchar](255) NULL,
	[PD#] [nvarchar](255) NULL,
	[Position Title] [nvarchar](255) NULL,
	[PP-Ser-Gr] [nvarchar](255) NULL,
	[FPL] [nvarchar](255) NULL,
	[Supv Code] [nvarchar](255) NULL,
	[Duty Station] [nvarchar](255) NULL,
	[Investigation Type] [nvarchar](255) NULL,
	[HiringAuthority] [nvarchar](255) NULL,
	[Recruit for Multiple] [nvarchar](3) NULL,
	[Vac Annct #] [nvarchar](255) NULL,
	[Annct Type] [nvarchar](255) NULL,
	[Selectee Last Name] [nvarchar](255) NULL,
	[Selectee First Name] [nvarchar](255) NULL,
	[Type of Selection] [nvarchar](255) NULL,
	[Rec Incentive] [nvarchar](255) NULL,
	[Comments] [ntext] NULL,
	[RPA Sent to NCC] [datetime] NULL,
	[RPA Sent to Staffing] [datetime] NULL,
	[RPA Sent to NRC] [datetime] NULL,
	[Strategic Conversation Held] [datetime] NULL,
	[JA Sent to Mgr] [datetime] NULL,
	[Mgr Approved JA] [datetime] NULL,
	[Draft Vac Sent to Mgr] [datetime] NULL,
	[Draft Vac Apprvd by Mgr] [datetime] NULL,
	[Annct Opened] [datetime] NULL,
	[Annct Closed] [datetime] NULL,
	[First Cert Issued] [datetime] NULL,
	[Applicants Notified] [datetime] NULL,
	[Last Cert Issued] [datetime] NULL,
	[Cert Expires] [datetime] NULL,
	[Mgr Retd Cert] [datetime] NULL,
	[Tentative Offer Made] [datetime] NULL,
	[Pkg sent to Security] [datetime] NULL,
	[Initial Access Recd] [datetime] NULL,
	[Final Offer Made] [datetime] NULL,
	[Final Offer Accepted] [datetime] NULL,
	[Sent to CPC] [datetime] NULL,
	[Eff Date] [datetime] NULL,
	[RPA Cancelled] [datetime] NULL,
	[Retd Due to Inactivity] [datetime] NULL,
	[LastUpdateUser] [nvarchar](50) NULL,
	[LastUpdateTimestamp] [timestamp] NULL,
 CONSTRAINT [RecruitActions_pk] PRIMARY KEY NONCLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
ALTER TABLE [RWT].[Recruit Actions] ADD  DEFAULT (suser_name()) FOR [LastUpdateUser]
GO
