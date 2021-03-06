USE [HRDW]
GO
/****** Object:  Table [dbo].[Financials]    Script Date: 5/1/2018 1:39:15 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Financials](
	[FinancialsID] [int] IDENTITY(1,1) NOT NULL,
	[AppointmentAuthCode] [nvarchar](255) NULL,
	[AppointmentAuthDesc] [nvarchar](255) NULL,
	[AppointmentAuthCode2] [nvarchar](255) NULL,
	[AppointmentAuthDesc2] [nvarchar](255) NULL,
	[AppointmentType] [nvarchar](255) NULL,
	[EmploymentType] [nvarchar](255) NULL,
	[FundingBackFill] [nvarchar](255) NULL,
	[FundingBackFIllDesc] [nvarchar](255) NULL,
	[FundingFUllTimeEqulvalent] [float] NULL,
	[AppropriationCode] [nvarchar](255) NULL,
	[BlockNumberCode] [nvarchar](255) NULL,
	[BlockNumberDesc] [nvarchar](255) NULL,
	[FinancialStatementCode] [nvarchar](255) NULL,
	[FinancialStatementDesc] [nvarchar](255) NULL,
	[OrgCodeBudgetFinance] [nvarchar](255) NULL,
	[FundCode] [nvarchar](255) NULL,
	[BudgetActivity] [nvarchar](255) NULL,
	[CostElement] [nvarchar](255) NULL,
	[ObjectClass] [nvarchar](255) NULL,
	[ORG_BA_FC] [nvarchar](255) NULL,
	[RR_ORG_BA_FC] [nvarchar](255) NULL,
	[DataSource] [nvarchar](255) NULL,
	[SystemSource] [nvarchar](255) NULL,
	[AsOfDate] [datetime] NULL,
	[PayRateDeterminantCode] [nvarchar](255) NULL,
	[PayRateDeterminantDescription] [nvarchar](255) NULL,
 CONSTRAINT [Financials_pk] PRIMARY KEY NONCLUSTERED 
(
	[FinancialsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
EXEC sys.sp_addextendedproperty @name=N'Description', @value=N'This table contains Appointment, Appropriation, and Financial Statement information.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Financials'
GO
EXEC sys.sp_addextendedproperty @name=N'Use', @value=N'The data in this table may be combined with other tables to produce current enterprise wide results (except Transactions) or it may be compared to specific RunDate sets within the Transactions table to review current vs historic trends.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Financials'
GO
