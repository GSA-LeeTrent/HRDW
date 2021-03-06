USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_boot_createObjIfNecessary]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[rv_sp_boot_createObjIfNecessary]    Script Date: 12/01/2009 13:55:38 ******/




-- Stored Procedure

/**
 * Given an object name and type, create a dummy copy of it if necessary
 * objname Name of the object to create
 * typecode FN for function, P for procedure
 */
Create Procedure [dbo].[rv_sp_boot_createObjIfNecessary]
  @objname varchar(128)
  , @typecode varchar(3)
  , @owner varchar(64) = null
AS
  set nocount on

  set @owner = isnull(@owner, user)

  -- object type to check
  declare @objtype varchar(32)

  -- decode the typecode
  if @typecode in ('FN', 'TF', 'IF')
    set @objtype = 'FUNCTION'
  else if @typecode = 'P'
    set @objtype = 'PROCEDURE'
  else if @typecode = 'V'
    set @objtype = 'VIEW'
  else if @typecode = 'U'
    set @objtype = 'TABLE'

  -- problems?
  if @objtype IS NULL
  BEGIN
    RAISERROR( 'Invalid typecode %s passed to createObjIfNecessary', 
      16, 1, @typecode )
  END

  -- create if necessary
  if not exists(
    SELECT name FROM sysobjects
      WHERE name = @objname AND type = @typecode
  )
  BEGIN
    declare @sql varchar(1024)
    set @sql = 'CREATE ' + @objtype + ' ' + @owner + '.' + @objname
    if @typecode = 'FN'
      set @sql = @sql + '() returns varchar(10) as begin return ''dummy'' end'
    else if @typecode = 'TF'
      set @sql = @sql + '() returns @tab_var table(x int) as begin insert into @tab_var values(42) return end'
    else if @typecode = 'IF'
      set @sql = @sql + '() returns table as return (select 42 as bar)'
    else if @typecode = 'P'
      set @sql = @sql + ' as print ''dummy'''
    else if @typecode = 'V'
      set @sql = @sql + ' as select ''dummy'' dummy'
    else if @typecode = 'U'
      set @sql = @sql + '(dummy int)'
    --print @sql
    exec( @sql )
  END

GO
