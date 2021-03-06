USE [HRDW]
GO
/****** Object:  Table [dbo].[yySecurity]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[yySecurity](
	[yySecurityID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
	[Current?] [nvarchar](255) NULL,
	[Record Date] [date] NULL,
	[Social Security] [nvarchar](255) NULL,
	[Clearance Date] [date] NULL,
	[Investigation_Type] [nvarchar](255) NULL,
	[Clearance_Description] [nvarchar](255) NULL,
	[Security_Clearance_Number] [nvarchar](255) NULL,
	[FailureReason] [nvarchar](255) NULL,
	[LoadFileName] [nvarchar](255) NULL,
	[FailureDateTime] [date] NOT NULL,
	[ProcessedDate] [date] NULL,
	[ProcessingNotes] [nvarchar](255) NULL,
 CONSTRAINT [yySecurity_pk] PRIMARY KEY NONCLUSTERED 
(
	[yySecurityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'A holding table used preserve incoming unmatched rows until they are able to be processed.  Table includes the failure reason for subsiquent analysis.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'yySecurity'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'To review data records recieved from external data feeds against existing persons: 
    1. Select columns for analysis (such as candidate keys to aide in the identification and matching rows from the holding table to existing person rows).  
    2. Review data 
    3. Mark rows for reprocessing (If a coresponding person is found populate the Person Identifier of the item in the holding table.)  
    4. Make a database backup prior to executing the stored procedure in case of unrecoverable failure.  
    5. Execute the corresponding stored procedure which loads the holding data into the corresponding target table.  
    Notes: Remember to log the files: as processed.  Record sufficient details to enable the identification and correction of anomalies.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'yySecurity'
GO
