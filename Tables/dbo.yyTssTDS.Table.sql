USE [HRDW]
GO
/****** Object:  Table [dbo].[yyTssTDS]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[yyTssTDS](
	[yyTssTdsID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NULL,
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
	[Vendor Name] [nvarchar](255) NULL,
	[FailureReason] [nvarchar](255) NULL,
	[LoadFileName] [nvarchar](255) NULL,
	[FailureDateTime] [date] NOT NULL,
	[ProcessedDate] [date] NULL,
	[ProcessingNotes] [nvarchar](255) NULL,
 CONSTRAINT [yyTssTDS_pk] PRIMARY KEY NONCLUSTERED 
(
	[yyTssTdsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'A holding table used preserve incoming unmatched rows until they are able to be processed.  Table includes the failure reason for subsequent analysis.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'yyTssTDS'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'To review data records recieved from external data feeds against existing persons: 
    1. Select columns for analysis (such as candidate keys to aide in the identification and matching rows from the holding table to existing person rows).  
    2. Review data 
    3. Mark rows for reprocessing (If a coresponding person is found populate the Person Identifier of the item in the holding table.)  
    4. Make a database backup prior to executing the stored procedure in case of unrecoverable failure.  
    5. Execute the corresponding stored procedure which loads the holding data into the corresponding target table.  
    Notes: Remember to log the files: as processed.  Record sufficient details to enable the identification and correction of anomalies.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'yyTssTDS'
GO
