USE [HRDW]
GO
/****** Object:  View [REPORTING].[vDetailTransactions2-PII]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [REPORTING].[vDetailTransactions2-PII] AS

(SELECT REPORTING.vDETAILSCENARIOPART1.SSN
, REPORTING.vDETAILSCENARIOPART1.PersonID, REPORTING.vDETAILSCENARIOPART1.DetailUniqueID, 
                  REPORTING.vDETAILSCENARIOPART1.LastName, REPORTING.vDETAILSCENARIOPART1.FirstName, REPORTING.vDETAILSCENARIOPART1.MiddleName, 
                  REPORTING.vDETAILSCENARIOPART1.[Employee Name], REPORTING.vDETAILSCENARIOPART1.[Detail Start Date aka Eff Dte of Trans], 
                  REPORTING.vDETAILSCENARIOPART1.[Detail End Date from Desc Section], REPORTING.vDETAILSCENARIOPART1.FYDESIGNATION, 
                  REPORTING.vDETAILSCENARIOPART1.HireDate, REPORTING.vDETAILSCENARIOPART1.FromRegion, REPORTING.vDETAILSCENARIOPART1.ToRegion, 
                  REPORTING.vDETAILSCENARIOPART1.FAMILY_NOACS, REPORTING.vDETAILSCENARIOPART1.NOAC_AND_DESCRIPTION, 
                  REPORTING.vDETAILSCENARIOPART1.NOAC_AND_DESCRIPTION_2, REPORTING.vDETAILSCENARIOPART1.FirstActionLACode1, 
                  REPORTING.vDETAILSCENARIOPART1.FirstActionLADesc1, REPORTING.vDETAILSCENARIOPART1.FirstActionLACode2, 
                  REPORTING.vDETAILSCENARIOPART1.FirstActionLADesc2, REPORTING.vDETAILSCENARIOPART1.SecondNOACode, 
                  REPORTING.vDETAILSCENARIOPART1.SecondNOADesc, REPORTING.vDETAILSCENARIOPART1.[From Ofc Sym aka Return to after Detail Over], 
                  dbo.OfficeLkup.OfficeSymbol, REPORTING.vDETAILSCENARIOPART1.[To Ofc Sym as mentioned both sides have same in CHRIS], 
                  REPORTING.vDETAILSCENARIOPART1.FromPositionAgencyCodeSubelementDescription, 
                  REPORTING.vDETAILSCENARIOPART1.ToPositionAgencyCodeSubelementDescription, REPORTING.vDETAILSCENARIOPART1.FromHSSO, 
                  REPORTING.vDETAILSCENARIOPART1.ToHSSO, REPORTING.vDETAILSCENARIOPART1.WhatKindofMovement, 
                  REPORTING.vDETAILSCENARIOPART1.FromPPSeriesGrade, REPORTING.vDETAILSCENARIOPART1.ToPPSeriesGrade, 
                  REPORTING.vDETAILSCENARIOPART1.FromPositionTitle, REPORTING.vDETAILSCENARIOPART1.ToPositionTitle, 
                  REPORTING.vDETAILSCENARIOPART1.DutyStationNameandStateCountry, REPORTING.vDETAILSCENARIOPART1.[From Basic Pay], 
                  REPORTING.vDETAILSCENARIOPART1.[To Basic Pay], REPORTING.vDETAILSCENARIOPART1.[From Adj Basic Pay], 
                  REPORTING.vDETAILSCENARIOPART1.[To Adj Basic Pay], REPORTING.vDETAILSCENARIOPART1.[From Total Pay], REPORTING.vDETAILSCENARIOPART1.[To Total Pay], 
                  dbo.xxFROMCHRM_ADDED_DETAIL_INFO.DetailNTEStartDate, dbo.xxFROMCHRM_ADDED_DETAIL_INFO.DetailUniqueID AS 'DetailUniqueNumber' 
                  ,dbo.xxFROMCHRM_ADDED_DETAIL_INFO.DetailNTE 
				  
				  
				  , dbo.xxFROMCHRM_ADDED_DETAIL_INFO.PosAddressOrgAgySubelmntCode, 
                  dbo.xxFROMCHRM_ADDED_DETAIL_INFO.PosAddressOrgAgySubelmntDesc, dbo.xxFROMCHRM_ADDED_DETAIL_INFO.DetailOrganizationName, 
                  dbo.xxFROMCHRM_ADDED_DETAIL_INFO.DetailPositionAgencySubelementCode, dbo.xxFROMCHRM_ADDED_DETAIL_INFO.DetailPositionAgencySubelementCodeDesc, 
                  dbo.xxFROMCHRM_ADDED_DETAIL_INFO.DetailType, dbo.xxFROMCHRM_ADDED_DETAIL_INFO.DetailTypeDescription
FROM     REPORTING.vDETAILSCENARIOPART1 LEFT OUTER JOIN
                  dbo.xxFROMCHRM_ADDED_DETAIL_INFO ON 
                  REPORTING.vDETAILSCENARIOPART1.DetailUniqueID = dbo.xxFROMCHRM_ADDED_DETAIL_INFO.DetailUniqueID LEFT OUTER JOIN
                  dbo.OfficeLkup ON REPORTING.vDETAILSCENARIOPART1.[To Ofc Sym as mentioned both sides have same in CHRIS] = dbo.OfficeLkup.OfficeSymbol AND 
                  REPORTING.vDETAILSCENARIOPART1.[From Ofc Sym aka Return to after Detail Over] = dbo.OfficeLkup.OfficeSymbol

  )


GO
