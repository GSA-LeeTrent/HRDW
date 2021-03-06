USE [HRDW]
GO
/****** Object:  Table [dbo].[xxTransactionsMod2]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxTransactionsMod2](
	[SSN] [nvarchar](255) NULL,
	[Employee Number] [nvarchar](255) NULL,
	[Effective Date] [date] NULL,
	[FY DESIGNATION] [nvarchar](255) NULL,
	[FAMILY_NOACS] [nvarchar](255) NULL,
	[NOAC_AND_DESCRIPTION] [nvarchar](255) NULL,
	[From Basic Pay] [money] NULL,
	[To Basic Pay] [money] NULL,
	[From Adjusted Basic Pay] [money] NULL,
	[To Adjusted Basic Pay] [money] NULL,
	[From Total Pay] [money] NULL,
	[To Total Pay] [money] NULL
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'A staging table used to load the Transactions FInancial Data.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xxTransactionsMod2'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'To process new external data feeds: 
    1. Compare the physical structure of the spreadsheet against the xx staging table to determine if there are structural changes.  
    2. Reconcile discrepancies with the originating source prior to modifying the: xx staging table, target table and corresponding stored procedure.  
    3. Use SQL Server Import and Export Wizard or corresponding package to load the spreadsheet into the xx staging table.  
    4. Make a database backup prior to executing the stored procedure in case of unrecoverable failure.  
    5. Execute the corresponding stored procedure which loads the raw data into the corresponding target table.  
    Notes: Remember to log the files: as they arrive, are loaded, and when  processed.  Record sufficient details to enable the identification and correction of anomalies.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xxTransactionsMod2'
GO
