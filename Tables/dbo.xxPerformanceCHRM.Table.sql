USE [HRDW]
GO
/****** Object:  Table [dbo].[xxPerformanceCHRM]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxPerformanceCHRM](
	[Record Date] [date] NULL,
	[Social Security] [nvarchar](255) NULL,
	[Personnel Office ID Description] [nvarchar](255) NULL,
	[Owning Region] [nvarchar](255) NULL,
	[Servicing Region] [nvarchar](255) NULL,
	[Pos Org Agy Subelement Desc] [nvarchar](255) NULL,
	[Office Symbol] [nvarchar](255) NULL,
	[Full Name] [nvarchar](255) NULL,
	[Position Title] [nvarchar](255) NULL,
	[PP-Series-Grade] [nvarchar](255) NULL,
	[Latest Hire Date] [date] NULL,
	[Employee >= 45  Days from LHD?] [nvarchar](255) NULL,
	[Date Arrived Present Position] [date] NULL,
	[Days(btwn recd dte & dte present posn)] [float] NULL,
	[CHK(<=45 Days Present Posn?)] [nvarchar](255) NULL,
	[Valid Pay Plan] [nvarchar](255) NULL,
	[Valid Grade Or Level] [nvarchar](255) NULL,
	[PP-GR] [nvarchar](255) NULL,
	[Grades] [nvarchar](255) NULL
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'A staging table used to load the PerformanceCHRM table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xxPerformanceCHRM'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'To process new external data feeds: 
    1. Compare the physical structure of the spreadsheet against the xx staging table to determine if there are structural changes.  
    2. Reconcile discrepancies with the originating source prior to modifying the: xx staging table, target table and corresponding stored procedure.  
    3. Use SQL Server Import and Export Wizard or corresponding package to load the spreadsheet into the xx staging table.  
    4. Make a database backup prior to executing the stored procedure in case of unrecoverable failure.  
    5. Execute the corresponding stored procedure which loads the raw data into the corresponding target table.  
    Notes: Remember to log the files: as they arrive, are loaded, and when  processed.  Record sufficient details to enable the identification and correction of anomalies.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xxPerformanceCHRM'
GO
