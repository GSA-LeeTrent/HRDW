USE [HRDW]
GO
/****** Object:  Table [dbo].[yyTelework]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[yyTelework](
	[yyTeleworkID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
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
	[F36] [nvarchar](255) NULL,
	[FailureReason] [nvarchar](255) NULL,
	[LoadFileName] [nvarchar](255) NULL,
	[FailureDateTime] [date] NOT NULL,
	[ProcessedDate] [date] NULL,
	[ProcessingNotes] [nvarchar](255) NULL,
 CONSTRAINT [yyTelework_pk] PRIMARY KEY NONCLUSTERED 
(
	[yyTeleworkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'A holding table used preserve incoming unmatched rows until they are able to be processed.  Table includes the failure reason for subsiquent analysis.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'yyTelework'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'To review data records recieved from external data feeds against existing persons: 
    1. Select columns for analysis (such as candidate keys to aide in the identification and matching rows from the holding table to existing person rows).  
    2. Review data 
    3. Mark rows for reprocessing (If a coresponding person is found populate the Person Identifier of the item in the holding table.)  
    4. Make a database backup prior to executing the stored procedure in case of unrecoverable failure.  
    5. Execute the corresponding stored procedure which loads the holding data into the corresponding target table.  
    Notes: Remember to log the files: as processed.  Record sufficient details to enable the identification and correction of anomalies.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'yyTelework'
GO
