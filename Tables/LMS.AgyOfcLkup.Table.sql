USE [HRDW]
GO
/****** Object:  Table [LMS].[AgyOfcLkup]    Script Date: 5/1/2018 1:39:16 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [LMS].[AgyOfcLkup](
	[AgyOfcLkupID] [int] IDENTITY(1,1) NOT NULL,
	[AgencySubElementCode] [nvarchar](4) NOT NULL,
	[OfficeSymbol] [nvarchar](18) NOT NULL,
 CONSTRAINT [AgyOfcLkup_pk] PRIMARY KEY NONCLUSTERED 
(
	[AgyOfcLkupID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
