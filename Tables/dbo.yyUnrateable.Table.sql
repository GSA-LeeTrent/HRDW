USE [HRDW]
GO
/****** Object:  Table [dbo].[yyUnrateable]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[yyUnrateable](
	[yyUnrateableID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[Run Date] [smalldatetime] NULL,
	[Fiscal Year Rating] [nvarchar](255) NULL,
	[Employee Full Name] [nvarchar](255) NULL,
	[Rating Period Start Date] [date] NULL,
	[Rating Period End Date] [date] NULL,
	[Overall Rating] [int] NULL,
	[Unratable] [nvarchar](255) NULL,
	[Pay Plan] [nvarchar](255) NULL,
	[Employee SSN] [nvarchar](255) NULL,
	[HSSO] [nvarchar](255) NULL,
	[Appraisal Type Description] [nvarchar](255) NULL,
	[Appraisal Status] [nvarchar](255) NULL,
	[Current Manager Full Name] [nvarchar](255) NULL,
	[Current Manager SSN] [nvarchar](255) NULL,
	[FAP Manager Full Name] [nvarchar](255) NULL,
	[FAP Manager SSN] [nvarchar](255) NULL,
	[MYR Manager Full Name] [nvarchar](255) NULL,
	[MYR Manager SSN] [nvarchar](255) NULL,
	[Organization] [nvarchar](255) NULL,
	[Agency Sub Element] [nvarchar](255) NULL,
	[Owning Region] [nvarchar](255) NULL,
	[Servicing Region] [nvarchar](255) NULL,
	[Personnel Office Identifier] [nvarchar](255) NULL,
	[Unratable Reason] [nvarchar](255) NULL,
	[FailureReason] [nvarchar](255) NULL,
	[LoadFileName] [nvarchar](255) NULL,
	[FailureDateTime] [date] NOT NULL,
	[ProcessedDate] [date] NULL,
	[ProcessingNotes] [nvarchar](255) NULL,
 CONSTRAINT [yyUnrateable_pk] PRIMARY KEY NONCLUSTERED 
(
	[yyUnrateableID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'A holding table used preserve incoming unmatched rows until they are able to be processed.  Table includes the failure reason for subsequent analysis.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'yyUnrateable'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'To review data records recieved from external data feeds against existing persons: 
    1. Select columns for analysis (such as candidate keys to aide in the identification and matching rows from the holding table to existing person rows).  
    2. Review data 
    3. Mark rows for reprocessing (If a coresponding person is found populate the Person Identifier of the item in the holding table.)  
    4. Make a database backup prior to executing the stored procedure in case of unrecoverable failure.  
    5. Execute the corresponding stored procedure which loads the holding data into the corresponding target table.  
    Notes: Remember to log the files: as processed.  Record sufficient details to enable the identification and correction of anomalies.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'yyUnrateable'
GO
