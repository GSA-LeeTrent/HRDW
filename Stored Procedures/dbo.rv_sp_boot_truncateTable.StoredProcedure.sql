USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_boot_truncateTable]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[rv_sp_boot_truncateTable]    Script Date: 12/01/2009 13:55:38 ******/




/**
 * Utility procedure to truncate a USER TABLE
 *
 * Must be performed as "sa" or table owner.
 */
Create Procedure [dbo].[rv_sp_boot_truncateTable]
  @objname varchar(128)
  , @owner varchar(64) = null
AS
  set nocount on

  set @owner = isnull(@owner, user)

  if exists(
    SELECT name FROM sysobjects
      WHERE name = @objname AND type = 'U'
  )
  begin
    declare @sql varchar(128)
    set @sql = 'truncate table [' + @owner + '].[' + @objname + ']'
    exec( @sql )
  end


GO
