USE [HRDW]
GO
/****** Object:  Table [dbo].[RegionDutyStationLkup]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RegionDutyStationLkup](
	[DutyStationStateOrCountry] [nvarchar](255) NULL,
	[RegionBasedOnDutyStation] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL
) ON [PRIMARY]

GO
