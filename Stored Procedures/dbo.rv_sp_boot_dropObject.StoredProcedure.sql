USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_boot_dropObject]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[rv_sp_boot_dropObject]    Script Date: 12/01/2009 13:55:38 ******/




Create Procedure [dbo].[rv_sp_boot_dropObject]
  @objname varchar(128)
  , @typecode varchar(2)
  , @schema_in varchar(128) = null
AS
  set nocount on

  set @schema_in = isnull(@schema_in, user)

  declare @sFullName varchar(128)
  set @sFullName = isnull(@schema_in, '')
  if len(@sFullName) <> 0 set @sFullName = @sFullName + '.'
  set @sFullName = @sFullName + @objname ;

  -- object type to drop
  declare @objtype varchar(32)
  -- decode the typecode
  if @typecode = 'FN' OR @typecode = 'IF' OR @typecode = 'TF'
    set @objtype = 'FUNCTION'
  ELSE IF @typecode = 'P' or @typecode = 'X' or @typecode = 'PC'
    set @objtype = 'PROCEDURE'
  ELSE IF @typecode = 'TR'
    set @objtype = 'TRIGGER'
  ELSE IF @typecode = 'U'
    set @objtype = 'TABLE'
  ELSE IF @typecode = 'V'
    set @objtype = 'VIEW'

  -- problems?
  if @objtype IS NULL
  BEGIN
    RAISERROR( 'Invalid typecode %s passed to dropObject', 
      16, 1, @typecode )
  END

  -- do the work
  declare @sql varchar(1024)
  set @sql =
    'IF EXISTS(' +
    '  SELECT name FROM sysobjects ' +
    '  WHERE name = ''' + @objname + ''' AND type = ''' + @typecode + '''' +
    ')' +
    '  DROP ' + @objtype + ' ' + @sFullName
  exec( @sql )


GO
