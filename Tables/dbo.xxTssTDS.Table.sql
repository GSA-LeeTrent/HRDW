USE [HRDW]
GO
/****** Object:  Table [dbo].[xxTssTDS]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[xxTssTDS](
	[Accreditation Indicator Code] [nvarchar](255) NULL,
	[Accreditation Indicator Desc] [nvarchar](255) NULL,
	[Agency Code Subelement] [nvarchar](255) NULL,
	[Chris Et Transaction Id] [float] NULL,
	[Cont Service Agreement Signed] [datetime] NULL,
	[Course Completion Date] [date] NULL,
	[Course Start Date] [date] NULL,
	[Credit Designation Code] [nvarchar](255) NULL,
	[Credit Designation Desc] [nvarchar](255) NULL,
	[Credit Type Desc] [nvarchar](255) NULL,
	[Credit Type Code] [nvarchar](255) NULL,
	[Duty Hours] [float] NULL,
	[Employee First Name] [nvarchar](255) NULL,
	[Employee Last Name] [nvarchar](255) NULL,
	[Employee Middle Name] [nvarchar](255) NULL,
	[Fiscal Year] [nvarchar](255) NULL,
	[Gender] [nvarchar](255) NULL,
	[Grade Or Level] [nvarchar](255) NULL,
	[Impact On Performance Code] [nvarchar](255) NULL,
	[Impact On Performance Desc] [nvarchar](255) NULL,
	[Material Cost] [float] NULL,
	[Nongovernment Contribution Cost] [float] NULL,
	[Non Duty Hours] [float] NULL,
	[Number of Associates] [float] NULL,
	[Occupational Series Code] [nvarchar](255) NULL,
	[Occupational Series Desc] [nvarchar](255) NULL,
	[Organization Name] [nvarchar](255) NULL,
	[Pay Plan] [nvarchar](255) NULL,
	[Perdiem Cost] [float] NULL,
	[Position Control Number] [nvarchar](255) NULL,
	[Position Sequence Number] [nvarchar](255) NULL,
	[Position Title] [nvarchar](255) NULL,
	[Prior Knowledge Level Code] [nvarchar](255) NULL,
	[Prior Knowledge Level Desc] [nvarchar](255) NULL,
	[Prior Supv Approval Received Code] [nvarchar](255) NULL,
	[Prior Supv Approval Received Desc] [nvarchar](255) NULL,
	[Recommend Training To Others Code] [nvarchar](255) NULL,
	[Recommend Training To Others Desc] [nvarchar](255) NULL,
	[Region] [nvarchar](255) NULL,
	[Repayment Agreement Required Code] [nvarchar](255) NULL,
	[Repayment Agreement Required Desc] [nvarchar](255) NULL,
	[Social Security Number] [nvarchar](255) NULL,
	[Source Type] [nvarchar](255) NULL,
	[Training Credit] [float] NULL,
	[Training Delivery Type Code] [nvarchar](255) NULL,
	[Training Delivery Type Desc] [nvarchar](255) NULL,
	[Training Location] [nvarchar](255) NULL,
	[Training Part Of IDP Code] [nvarchar](255) NULL,
	[Training Part Of IDP Desc] [nvarchar](255) NULL,
	[Training Purpose Code] [nvarchar](255) NULL,
	[Training Purpose Desc] [nvarchar](255) NULL,
	[Training Source Code] [nvarchar](255) NULL,
	[Training Source Desc] [nvarchar](255) NULL,
	[Training Sub Type Code] [nvarchar](255) NULL,
	[Training Sub Type Desc] [nvarchar](255) NULL,
	[Training Title] [nvarchar](255) NULL,
	[Training Travel Indicator] [nvarchar](255) NULL,
	[Training Type Code] [nvarchar](255) NULL,
	[Training Type Desc] [nvarchar](255) NULL,
	[Travel Costs] [float] NULL,
	[Tution And Fees] [float] NULL,
	[Type Of Payment Code] [nvarchar](255) NULL,
	[Type Of Payment Desc] [nvarchar](255) NULL,
	[Vendor Name] [nvarchar](255) NULL
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'A staging table used to load the TSSTDS staging table.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xxTssTDS'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'To process new external data feeds: 
    1. Compare the physical structure of the spreadsheet against the xx staging table to determine if there are structural changes.  
    2. Reconcile discrepancies with the originating source prior to modifying the: xx staging table, target table and corresponding stored procedure.  
    3. Use SQL Server Import and Export Wizard or corresponding package to load the spreadsheet into the xx staging table.  
    4. Make a database backup prior to executing the stored procedure in case of unrecoverable failure.  
    5. Execute the corresponding stored procedure which loads the raw data into the corresponding target table.  
    Notes: Remember to log the files: as they arrive, are loaded, and when  processed.  Record sufficient details to enable the identification and correction of anomalies.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'xxTssTDS'
GO
