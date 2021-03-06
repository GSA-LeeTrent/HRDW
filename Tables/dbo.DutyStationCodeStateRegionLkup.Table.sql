USE [HRDW]
GO
/****** Object:  Table [dbo].[DutyStationCodeStateRegionLkup]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DutyStationCodeStateRegionLkup](
	[DutyStationCodeStateRegionLkupID] [int] IDENTITY(1,1) NOT NULL,
	[DutyStationCode] [nvarchar](255) NULL,
	[DutyStationStateOrCountry] [nvarchar](255) NULL,
	[RegionBasedOnDutyStation] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
	[LocalityPayArea] [char](2) NULL,
	[CoreBasedStatArea] [char](5) NULL,
	[CombinedStatArea] [char](3) NULL,
 CONSTRAINT [DutyStationCodeStateRegionLkup_pk] PRIMARY KEY NONCLUSTERED 
(
	[DutyStationCodeStateRegionLkupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
