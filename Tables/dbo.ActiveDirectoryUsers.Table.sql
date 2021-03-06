USE [HRDW]
GO
/****** Object:  Table [dbo].[ActiveDirectoryUsers]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ActiveDirectoryUsers](
	[UserPrincipalName] [nvarchar](255) NOT NULL,
	[ADDomain] [nvarchar](255) NULL,
	[FirstName] [nvarchar](255) NULL,
	[LastName] [nvarchar](255) NULL,
	[MiddleInitial] [nvarchar](255) NULL,
	[UserID] [nvarchar](255) NULL,
	[UserType] [nvarchar](20) NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[EmployeeNumber] [nvarchar](255) NULL,
	[Emp_Status] [nvarchar](255) NULL,
	[Emp_Service] [nvarchar](255) NULL,
	[OfficeSymbol] [nvarchar](255) NULL,
	[Agency] [nvarchar](255) NULL,
	[Region] [nvarchar](255) NULL,
	[LibraryAccess] [nvarchar](255) NULL,
	[PositionTitle] [nvarchar](255) NULL,
	[SupervisorName] [nvarchar](255) NULL,
	[SupervisorEmail] [nvarchar](255) NULL,
	[SupervisorEmployeeNumber] [nvarchar](255) NULL,
	[PayPlan] [nvarchar](255) NULL,
	[JobSeries] [nvarchar](255) NULL,
	[Grade] [nvarchar](255) NULL,
	[PositionLevel] [nvarchar](255) NULL,
	[EntryOnDuty] [date] NULL,
	[EntryOnPosition] [date] NULL,
	[SupervisoryStatus] [nvarchar](255) NULL,
	[CHRISEmployeeID] [nvarchar](255) NULL,
	[Affiliation] [nvarchar](255) NULL,
	[LastLoginTimestamp] [nvarchar](255) NULL,
	[InactiveTimestamp] [datetime] NULL,
	[LastUpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [ActiveDirectoryUsers_pk] PRIMARY KEY NONCLUSTERED 
(
	[UserPrincipalName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[ActiveDirectoryUsers] ADD  DEFAULT (getdate()) FOR [LastUpdateTimestamp]
GO
