USE [HRDW]
GO
/****** Object:  Table [dbo].[xxCECriticalElements]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxCECriticalElements](
	[EmployeeSSN] [nvarchar](255) NULL,
	[RatingPeriodEndDate] [date] NULL,
	[CriticalElementNumber] [int] NULL,
	[CriticalElementName] [nvarchar](255) NULL,
	[PercentageWeighting] [nvarchar](255) NULL,
	[CrticalElementRating] [int] NULL
) ON [PRIMARY]

GO
