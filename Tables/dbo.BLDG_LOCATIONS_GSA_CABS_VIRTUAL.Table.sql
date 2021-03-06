USE [HRDW]
GO
/****** Object:  Table [dbo].[BLDG_LOCATIONS_GSA_CABS_VIRTUAL]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[BLDG_LOCATIONS_GSA_CABS_VIRTUAL](
	[LocationType] [varchar](7) NULL,
	[IBMLocationCode] [varchar](10) NOT NULL,
	[EffectiveDate] [date] NULL,
	[BldgDescription] [varchar](100) NULL,
	[GeoLocationGCIMS] [varchar](12) NULL,
	[GeoLocationCode] [varchar](9) NULL,
	[Address_1] [varchar](50) NULL,
	[Address_2] [varchar](50) NULL,
	[Address_3] [varchar](50) NULL,
	[Address_4] [varchar](50) NULL,
	[City] [varchar](30) NULL,
	[PostalCode] [varchar](12) NULL,
	[Country] [varchar](25) NULL,
	[USCounty] [varchar](30) NULL,
	[TeleworkValue] [varchar](1) NULL,
	[USState] [varchar](2) NULL,
	[BuildingLocationCode] [varchar](10) NULL,
	[Region] [varchar](50) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
