USE [HRDW]
GO
/****** Object:  Table [dbo].[LoadLog]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LoadLog](
	[LoadFileID] [int] IDENTITY(1,1) NOT NULL,
	[ServerName] [nvarchar](255) NULL,
	[DBName] [nvarchar](255) NULL,
	[SchemaName] [nvarchar](80) NULL,
	[LoadFileName] [nvarchar](128) NULL,
	[LoadFileType] [nvarchar](50) NULL,
	[LoadFileBeginDateTime] [datetime] NULL,
	[LoadFileRowCount] [int] NULL,
	[StagingTableName] [nvarchar](255) NULL,
	[StagingTableRowsAdded] [int] NULL,
	[TargetTableName] [nvarchar](255) NULL,
	[TargetTableInitialRowCount] [int] NULL,
	[TargetTableRowsAddedViaSP] [int] NULL,
	[TargetTableRowsUpdatedViaSP] [int] NULL,
	[TargetTableAfterRowCount] [int] NULL,
	[StoredProcedureRowsDiscarded] [int] NULL,
	[StoredProcedureName] [nvarchar](255) NULL,
	[LoadFileEndDateTime] [datetime] NULL,
	[LoadFileNotes] [nvarchar](max) NULL,
 CONSTRAINT [PK_LoadLog] PRIMARY KEY NONCLUSTERED 
(
	[LoadFileID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains sensitive records pertaining to the loading of external data sets.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LoadLog'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be used to understand historical trends as well as previous resolutions to issues related to the loading and processing external data feeds.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'LoadLog'
GO
