USE [HRDW]
GO
/****** Object:  View [REPORTING].[vMERGE_PEOPLE_AWARDS]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [REPORTING].[vMERGE_PEOPLE_AWARDS]
AS

Select 

 REPORTING.vGettingTransactionHistory.[Database]
,REPORTING.vGettingTransactionHistory.[Record Date DB ]
,REPORTING.vGettingEXandEMPLOYEES.[FullName]
,REPORTING.vGettingEXandEMPLOYEES.[EmailAddress]
,REPORTING.vGettingEXandEMPLOYEES.[Posn Employee Type]
,REPORTING.vGettingEXandEMPLOYEES.[Latest Hire Dte]
,REPORTING.vGettingEXandEMPLOYEES.[Latest Separation Date]
,REPORTING.vGettingEXandEMPLOYEES.[Ofc Symbol]
,REPORTING.vGettingEXandEMPLOYEES.[2 Letter]
,REPORTING.vGettingTransactionHistory.[From PP]
,REPORTING.vGettingTransactionHistory.[To PP]
,REPORTING.vGettingTransactionHistory.[From Grade]
,REPORTING.vGettingTransactionHistory.[To Grade]
,REPORTING.vGettingTransactionHistory.[AwardAppropriationCode]
,REPORTING.vGettingTransactionHistory.[HSSO Code]
,REPORTING.vGettingTransactionHistory.[HSSO]
,REPORTING.vGettingTransactionHistory.[POID]
,REPORTING.vGettingTransactionHistory.[FromRegion]
,REPORTING.vGettingTransactionHistory.[ToRegion]
,REPORTING.vGettingTransactionHistory.[Awd Type]
,REPORTING.vGettingTransactionHistory.[Awd Type Desc]
,REPORTING.vGettingTransactionHistory.[Awd UOM]
,REPORTING.vGettingTransactionHistory.[Awd Amt]
,REPORTING.vGettingTransactionHistory.[Action Eff Dte]
,REPORTING.vGettingTransactionHistory.[Processed Dte]
,REPORTING.vGettingTransactionHistory.[First NOA Code]
,REPORTING.vGettingTransactionHistory.[First NOA Desc]
,REPORTING.vGettingTransactionHistory.[FirstActionLACode1]
,REPORTING.vGettingTransactionHistory.[FirstActionLADesc1]
,REPORTING.vGettingTransactionHistory.[ToSupervisoryStatusDesc]
,REPORTING.vGettingTransactionHistory.[ToBargainingUnitStatusDesc]
,REPORTING.vGettingTransactionHistory.[DutyStationNameandStateCountry]

FROM REPORTING.vGettingEXandEMPLOYEES  INNER JOIN
                  REPORTING.vGettingTransactionHistory  ON REPORTING.vGettingEXandEMPLOYEES.PersonID = REPORTING.vGettingTransactionHistory.PersonID


GO
