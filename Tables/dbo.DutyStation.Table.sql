USE [HRDW]
GO
/****** Object:  Table [dbo].[DutyStation]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DutyStation](
	[DutyStationID] [int] IDENTITY(1,1) NOT NULL,
	[DutyStationCode] [nvarchar](255) NULL,
	[DutyStationName] [nvarchar](255) NULL,
	[DutyStationState] [nvarchar](255) NULL,
	[DutyStationCounty] [nvarchar](255) NULL,
	[Zip] [nvarchar](255) NULL,
	[Region] [nvarchar](255) NULL,
	[Country] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
 CONSTRAINT [DutyStation_pk] PRIMARY KEY NONCLUSTERED 
(
	[DutyStationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains location specific records.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DutyStation'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DutyStation'
GO
