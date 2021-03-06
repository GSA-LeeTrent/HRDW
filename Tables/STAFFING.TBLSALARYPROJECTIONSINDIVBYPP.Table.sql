USE [HRDW]
GO
/****** Object:  Table [STAFFING].[TBLSALARYPROJECTIONSINDIVBYPP]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [STAFFING].[TBLSALARYPROJECTIONSINDIVBYPP](
	[IndivProjectionID] [int] IDENTITY(1,1) NOT NULL,
	[SSN] [varchar](255) NULL,
	[REGION] [varchar](255) NULL,
	[VACANCYID] [numeric](10, 0) NULL,
	[NAME] [varchar](255) NULL,
	[PPEDATE] [varchar](255) NULL,
	[PPNO] [numeric](10, 0) NULL,
	[FY] [numeric](10, 0) NULL,
	[FUND] [varchar](255) NULL,
	[ORGSYMBOL] [varchar](255) NULL,
	[ORGCODE] [varchar](255) NULL,
	[SERIES] [numeric](10, 0) NULL,
	[GRADE] [numeric](10, 0) NULL,
	[STEP] [numeric](10, 0) NULL,
	[JOBCATID] [numeric](10, 0) NULL,
	[HEADCOUNT] [numeric](10, 0) NULL,
	[VACANCYCOUNT] [numeric](10, 0) NULL,
	[BASEPAY] [numeric](13, 2) NULL,
	[GLI] [numeric](13, 2) NULL,
	[MEDICARE] [numeric](13, 2) NULL,
	[OASDI] [numeric](13, 2) NULL,
	[TSP_BASIC] [numeric](13, 2) NULL,
	[TSP_MATCH] [numeric](13, 2) NULL,
	[HBI] [numeric](13, 2) NULL,
	[RET] [numeric](13, 2) NULL,
	[NON_FOR_COLA] [numeric](13, 2) NULL,
	[BIWEEKLYBENEFITS] [numeric](13, 2) NULL,
	[BIWEEKLYTOTAL] [numeric](13, 2) NULL,
	[TERMINALLEAVE] [numeric](13, 2) NULL,
	[OTHERCOSTS] [numeric](13, 2) NULL,
	[COSTTOTAL] [numeric](13, 2) NULL,
	[GRADEDELTA] [numeric](13, 2) NULL,
	[STEPDELTA] [numeric](13, 2) NULL,
	[SERVICECODE] [varchar](255) NULL,
 CONSTRAINT [TBLSALARYPROJECTIONSINDIVBYPP_pk] PRIMARY KEY NONCLUSTERED 
(
	[IndivProjectionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
