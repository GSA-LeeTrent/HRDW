USE [HRDW]
GO
/****** Object:  View [dbo].[vAwards-CurrentFY&PreviousFY-OLD]    Script Date: 5/1/2018 1:44:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [dbo].[vAwards-CurrentFY&PreviousFY-OLD]
AS
SELECT
	  DB_NAME() AS [Database]
	, FORMAT(GETDATE(), 'M/dd/yyyy', 'en-US') AS 'Run Date'
	, dbo.[vChrisTrans-All].FYDESIGNATION
	, dbo.[vChrisTrans-All].FullName
	, LEFT(dbo.[vChrisTrans-All].FromPPSeriesGrade, 2) AS [From PP]
	, LEFT(dbo.[vChrisTrans-All].ToPPSeriesGrade, 2) AS [To PP]
	, RIGHT(dbo.[vChrisTrans-All].FromPPSeriesGrade, 2) AS [From Grade]
	, RIGHT(dbo.[vChrisTrans-All].ToPPSeriesGrade, 2) AS [To Grade]
	, dbo.PositionInfo.PositionEncumberedType AS [Posn Employee Type]
	, FORMAT(dbo.[vChrisTrans-All].HireDate, 'M/dd/yyyy', 'en-US') AS [Latest Hire Dte]
	, CASE 
		WHEN dbo.[PositionDate].LatestSeparationDate IS NULL 
		THEN ' ' 
		ELSE FORMAT(dbo.[PositionDate].LatestSeparationDate, 'M/dd/yyyy', 'en-US') 
      END AS [Latest Separation Date]
	, dbo.[vChrisTrans-All].ToOfficeSymbol AS [Ofc Symbol]
	, Offlkup.OfficeSymbol2Char AS [2 Letter]
	, dbo.[vChrisTrans-All].AwardAppropriationCode AS [Awd Approp Code]
	, SUBSTRING(RIGHT(dbo.[vChrisTrans-All ].ToPositionAgencyCodeSubelementDescription, 5), 1, 4) AS [HSSO Code]
	, dbo.[vChrisTrans-All].ToPositionAgencyCodeSubelementDescription AS HSSO
	, dbo.[vChrisTrans-All].ToPOI AS POID
	, dbo.PoiLkup.PersonnelOfficeIDDescription AS [POID Desc]
	, dbo.[vChrisTrans-All].AwardType AS [Awd Type]
	, dbo.[vChrisTrans-All].AwardTypeDesc AS [Awd Type Desc]
	, dbo.[vChrisTrans-All].AwardUOM AS [Awd UOM]
	, dbo.[vChrisTrans-All].AwardAmount AS [Awd Amt]
	, FORMAT(dbo.[vChrisTrans-All].EffectiveDate, 'M/dd/yyyy', 'en-US') AS [Action Eff Dte]
	, FORMAT(dbo.[vChrisTrans-All].ProcessedDate, 'M/dd/yyyy', 'en-US') AS [Processed Dte]
	, LEFT(dbo.[vChrisTrans-All].NOAC_AND_DESCRIPTION, 3) AS [First NOA Code]
	, SUBSTRING(dbo.[vChrisTrans-All].NOAC_AND_DESCRIPTION, 7, 50) AS [First NOA Desc]
	, dbo.[vChrisTrans-All].FirstActionLACode1
	, dbo.[vChrisTrans-All].FirstActionLADesc1
	, dbo.[vChrisTrans-All].ToSupervisoryStatusDesc
	, dbo.[vChrisTrans-All].ToBargainingUnitStatusDesc
	, dbo.Person.EmailAddress 
FROM
	dbo.Person 
		INNER JOIN dbo.Position					ON dbo.Person.PersonID = dbo.Position.PersonID 
		INNER JOIN dbo.PositionInfo				ON dbo.Position.ChrisPositionID = dbo.PositionInfo.PositionInfoID 
		LEFT OUTER JOIN dbo.PositionDate		ON dbo.Position.PositionDateID = dbo.PositionDate.PositionDateID 
		LEFT OUTER JOIN dbo.[vChrisTrans-All]	ON dbo.Person.PersonID = dbo.[vChrisTrans-All].PersonID
		LEFT OUTER JOIN dbo.OfficeLkup offlkup	ON offlkup.OfficeSymbol = dbo.[vChrisTrans-All].ToOfficeSymbol 
		LEFT OUTER JOIN dbo.PoiLkup			ON dbo.PoiLkup.PersonnelOfficeID = dbo.[vChrisTrans-All].ToPOI
 WHERE 
	(dbo.Position.RecordDate = (SELECT MAX(p1.RecordDate) FROM dbo.Position p1)) 
	AND 
	(dbo.[vChrisTrans-All ].FAMILY_NOACS = 'NOAC 800 Family Transactions') 
	AND 
	(
	FYDESIGNATION = 'FY'+ dbo.Riv_fn_ComputeFiscalYear(GETDATE()) 
	OR 
	FYDESIGNATION = 'FY'+ cast( dbo.Riv_fn_ComputeFiscalYear(GETDATE())-1 as varchar(4) ) 
	)
	AND 
	(LEFT(dbo.[vChrisTrans-All ].NOAC_AND_DESCRIPTION, 3) IN ('840', '841', '846', '847', '849', '878', '879')) 
	AND 
	(NOT (dbo.PositionInfo.PayPlan IN ('EX', 'ES', 'SL', 'IG', 'CA', 'AD'))) 
	AND 
    (dbo.Position.PosOrgAgySubelementCode <> 'GS15')



GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[65] 4[4] 2[12] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "Person"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 288
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "Position"
            Begin Extent = 
               Top = 6
               Left = 326
               Bottom = 135
               Right = 600
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PositionInfo"
            Begin Extent = 
               Top = 6
               Left = 638
               Bottom = 135
               Right = 923
            End
            DisplayFlags = 280
            TopColumn = 30
         End
         Begin Table = "PositionDate"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 1
         End
         Begin Table = "OfficeLkup_1"
            Begin Extent = 
               Top = 138
               Left = 330
               Bottom = 267
               Right = 522
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PoiLkup"
            Begin Extent = 
               Top = 138
               Left = 560
               Bottom = 267
               Right = 804
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vChrisTrans-All "
            Begin Extent = 
               Top = 270
               Left = 38
               Bottom = 470
               Right = 514
            End
         ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vAwards-CurrentFY&PreviousFY-OLD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'   DisplayFlags = 280
            TopColumn = 9
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vAwards-CurrentFY&PreviousFY-OLD'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vAwards-CurrentFY&PreviousFY-OLD'
GO
