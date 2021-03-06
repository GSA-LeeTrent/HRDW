USE [HRDW]
GO
/****** Object:  Table [dbo].[CHRIS_LMS_Users]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CHRIS_LMS_Users](
	[CHRIS_LMS_UserID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [nvarchar](150) NULL,
	[LastName] [nvarchar](150) NULL,
	[MiddleInitial] [nvarchar](60) NULL,
	[Email] [nvarchar](240) NULL,
	[AgencySubElementCode] [nvarchar](4) NULL,
	[OfficeSymbol] [nvarchar](18) NULL,
	[DutyStationCode] [nvarchar](9) NULL,
	[OccupationalSeries] [nvarchar](4) NULL,
	[LatestHireDate] [datetime] NULL,
	[EmployeeNumber] [nvarchar](30) NULL,
	[PositionTitle] [nvarchar](60) NULL,
	[WorkPhoneNumber] [nvarchar](60) NULL,
	[WorkAddressLine1] [nvarchar](240) NULL,
	[WorkAddressLine2] [nvarchar](240) NULL,
	[WorkAddressCity] [nvarchar](30) NULL,
	[WorkAddressState] [nvarchar](50) NULL,
	[WorkAddressZip] [nvarchar](30) NULL,
	[OccupationalSeriesDescription] [nvarchar](60) NULL,
	[EducationLevel] [nvarchar](2) NULL,
	[SupervisorCode] [nvarchar](1) NULL,
	[Grade] [nvarchar](2) NULL,
	[PayPlan] [nvarchar](2) NULL,
	[StepOrRate] [nvarchar](2) NULL,
	[PositionPOI] [nvarchar](4) NULL,
	[EntryOnPosition] [datetime] NULL,
	[CHRISEmployeeID] [nvarchar](12) NULL,
	[ManagerCHRISEmployeeID] [nvarchar](12) NULL,
	[InactiveTimestamp] [datetime] NULL,
	[LastUpdateTimestamp] [datetime] NOT NULL,
 CONSTRAINT [CHRIS_LMS_Users_pk] PRIMARY KEY NONCLUSTERED 
(
	[CHRIS_LMS_UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[CHRIS_LMS_Users] ADD  DEFAULT (getdate()) FOR [LastUpdateTimestamp]
GO
