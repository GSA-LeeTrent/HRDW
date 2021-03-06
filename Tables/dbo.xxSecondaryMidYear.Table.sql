USE [HRDW]
GO
/****** Object:  Table [dbo].[xxSecondaryMidYear]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxSecondaryMidYear](
	[Run Date] [nvarchar](255) NULL,
	[Employee Full Name] [nvarchar](255) NULL,
	[Standard Pattern(APPAS Current Period)] [nvarchar](255) NULL,
	[Rating Period Start Date] [date] NULL,
	[Rating Period End Date] [date] NULL,
	[Overall Rating] [float] NULL,
	[Pay Plan] [nvarchar](255) NULL,
	[Employee SSN] [nvarchar](255) NULL,
	[HSSO] [nvarchar](255) NULL,
	[Final Performance Plan Issue Date] [date] NULL,
	[AP_STATUS] [nvarchar](255) NULL,
	[Appraisal Type Description] [nvarchar](255) NULL,
	[AP_TYPE_DESC] [nvarchar](255) NULL,
	[Appraisal Status] [nvarchar](255) NULL,
	[Current Manager Full Name] [nvarchar](255) NULL,
	[Current Manager SSN] [nvarchar](255) NULL,
	[FAP Manager Full Name] [nvarchar](255) NULL,
	[FAP Manager SSN] [nvarchar](255) NULL,
	[MYR Manager Full Name] [nvarchar](255) NULL,
	[MYR Manager SSN] [nvarchar](255) NULL,
	[Organization] [nvarchar](255) NULL,
	[FAS_2_Letter] [nvarchar](255) NULL,
	[2 letter] [nvarchar](255) NULL,
	[Agency Sub Element] [nvarchar](255) NULL,
	[Owning Region] [nvarchar](255) NULL,
	[Servicing Region] [nvarchar](255) NULL,
	[Personnel Office Identifier] [nvarchar](255) NULL
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'A staging table used to load the SecondaryMidYear table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xxSecondaryMidYear'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'To process new external data feeds: 
    1. Compare the physical structure of the spreadsheet against the xx staging table to determine if there are structural changes.  
    2. Reconcile discrepancies with the originating source prior to modifying the: xx staging table, target table and corresponding stored procedure.  
    3. Use SQL Server Import and Export Wizard or corresponding package to load the spreadsheet into the xx staging table.  
    4. Make a database backup prior to executing the stored procedure in case of unrecoverable failure.  
    5. Execute the corresponding stored procedure which loads the raw data into the corresponding target table.  
    Notes: Remember to log the files: as they arrive, are loaded, and when  processed.  Record sufficient details to enable the identification and correction of anomalies.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xxSecondaryMidYear'
GO
