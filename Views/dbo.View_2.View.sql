USE [HRDW]
GO
/****** Object:  View [dbo].[View_2]    Script Date: 5/1/2018 1:44:43 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[View_2]
AS
SELECT        TOP (100) PERCENT dbo.Position.RecordDate AS [Record Date], dbo.Person.LastName AS [Emp Last], dbo.Person.FirstName AS [Emp First], 
                         dbo.Person.MiddleName AS [Empl Middle], dbo.Person.LastName + ', ' + dbo.Person.FirstName + ', ' + ISNULL(dbo.Person.MiddleName, N'') AS [Empl Full Name], 
                         dbo.PositionInfo.SupervisoryStatusDesc AS [Empl Supv Desc], dbo.PositionInfo.PositionTitle AS [Empl Title], dbo.PositionInfo.PayPlan AS [Empl PP], 
                         dbo.PositionInfo.PositionSeries AS [Empl Series], dbo.PositionInfo.Grade AS [Emp Grade], dbo.Position.PosOrgAgySubelementDesc AS [Empl HSSO], 
                         dbo.PositionInfo.OfficeSymbol AS [Empl Ofc Sym], dbo.OfficeLkup.OfficeSymbol2Char AS [Empl 2 Letter], '$' + FORMAT(dbo.Pay.BasicSalary, 'N', 'en-us') 
                         AS [Empl Basic Salary], '$' + FORMAT(dbo.Pay.AdjustedBasic, 'N', 'en-us') AS [Empl Adj Salary], '$' + FORMAT(dbo.Pay.TotalPay, 'N', 'en-us') AS [Empl Total Pay], 
                         dbo.PositionInfo.SupervisorID AS [Supv ID]
FROM            dbo.Position INNER JOIN
                         dbo.Pay ON dbo.Position.PayID = dbo.Pay.PayID LEFT OUTER JOIN
                         dbo.Person ON dbo.Position.PersonID = dbo.Person.PersonID LEFT OUTER JOIN
                         dbo.PositionDate ON dbo.Position.PositionDateID = dbo.PositionDate.PositionDateID LEFT OUTER JOIN
                         dbo.PositionInfo ON dbo.Position.ChrisPositionID = dbo.PositionInfo.PositionInfoID LEFT OUTER JOIN
                         dbo.OfficeLkup ON dbo.PositionInfo.OfficeSymbol = dbo.OfficeLkup.OfficeSymbol
WHERE        (dbo.PositionInfo.PositionEncumberedType = 'Employee Permanent' OR
                         dbo.PositionInfo.PositionEncumberedType = 'Employee Temporary') AND (dbo.Position.RecordDate =
                             (SELECT        MAX(RecordDate) AS MaxRecDate
                               FROM            dbo.Position AS Position_1))
ORDER BY 'Empl Full Name'

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
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
         Begin Table = "Position"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 135
               Right = 312
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Pay"
            Begin Extent = 
               Top = 6
               Left = 350
               Bottom = 135
               Right = 520
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "Person"
            Begin Extent = 
               Top = 6
               Left = 558
               Bottom = 135
               Right = 808
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PositionDate"
            Begin Extent = 
               Top = 138
               Left = 38
               Bottom = 267
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "PositionInfo"
            Begin Extent = 
               Top = 138
               Left = 330
               Bottom = 267
               Right = 615
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "OfficeLkup"
            Begin Extent = 
               Top = 138
               Left = 653
               Bottom = 267
               Right = 845
            End
            DisplayFlags = 280
            TopColumn = 0
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
         Width = 1500' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_2'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'View_2'
GO
