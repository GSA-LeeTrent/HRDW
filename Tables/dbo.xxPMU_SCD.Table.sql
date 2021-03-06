USE [HRDW]
GO
/****** Object:  Table [dbo].[xxPMU_SCD]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[xxPMU_SCD](
	[Social Security] [nvarchar](255) NULL,
	[Retirement SCD] [date] NULL,
	[SCD Length Of Service] [date] NULL,
	[SCD RIF] [date] NULL,
	[FYDESIGNATION] [varchar](6) NULL
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'A staging table used to load the PMU Service Computation Dates table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xxPMU_SCD'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'Add SCD dates to a separate xx (staging) table. This table is joined with the xxPMU during the load of the PMU PositionDate table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xxPMU_SCD'
GO
