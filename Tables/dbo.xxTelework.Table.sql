USE [HRDW]
GO
/****** Object:  Table [dbo].[xxTelework]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxTelework](
	[Emp Status] [nvarchar](255) NULL,
	[Emp Last Name] [nvarchar](255) NULL,
	[Emp First Name] [nvarchar](255) NULL,
	[Telework Status] [nvarchar](255) NULL,
	[Date] [smalldatetime] NULL,
	[Reg/Svc] [nvarchar](255) NULL,
	[Current Reg/Svc] [nvarchar](255) NULL,
	[Corr Symbol] [nvarchar](255) NULL,
	[Current Corr Symbol] [nvarchar](255) NULL,
	[Official Worksite] [nvarchar](255) NULL,
	[Emp Phone] [float] NULL,
	[Emp Email] [nvarchar](255) NULL,
	[Emp Cell] [float] NULL,
	[Sup] [nvarchar](255) NULL,
	[Sup phone] [float] NULL,
	[Sup email] [nvarchar](255) NULL,
	[Sup cell] [float] NULL,
	[TW Coord] [nvarchar](255) NULL,
	[Elig] [nvarchar](255) NULL,
	[no reason] [nvarchar](255) NULL,
	[Completed Training] [nvarchar](255) NULL,
	[Decline] [nvarchar](255) NULL,
	[Sched] [nvarchar](255) NULL,
	[Report to Office - Acknowledge] [nvarchar](255) NULL,
	[Report to Office - Hours Notice] [float] NULL,
	[Alt Ofc] [nvarchar](255) NULL,
	[IT] [nvarchar](255) NULL,
	[Emp Cert] [nvarchar](255) NULL,
	[Temp Inelig] [nvarchar](255) NULL,
	[Reason] [nvarchar](255) NULL,
	[Plan] [nvarchar](255) NULL,
	[Perm Inelig] [nvarchar](255) NULL,
	[Sup Cert] [nvarchar](255) NULL,
	[Sup Comments] [nvarchar](255) NULL,
	[F36] [nvarchar](255) NULL
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'A staging table used to load the Telework table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xxTelework'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'To process new external data feeds: 
    1. Compare the physical structure of the spreadsheet against the xx staging table to determine if there are structural changes.  
    2. Reconcile discrepancies with the originating source prior to modifying the: xx staging table, target table and corresponding stored procedure.  
    3. Use SQL Server Import and Export Wizard or corresponding package to load the spreadsheet into the xx staging table.  
    4. Make a database backup prior to executing the stored procedure in case of unrecoverable failure.  
    5. Execute the corresponding stored procedure which loads the raw data into the corresponding target table.  
    Notes: Remember to log the files: as they arrive, are loaded, and when  processed.  Record sufficient details to enable the identification and correction of anomalies.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xxTelework'
GO
