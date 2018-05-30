USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_boot_createTableIfNecessary]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****** Object:  StoredProcedure [dbo].[rv_sp_boot_createTableIfNecessary]    Script Date: 12/01/2009 13:55:38 ******/




/**
 * Given a table name, create a dummy copy of it if necessary
 */
Create Procedure [dbo].[rv_sp_boot_createTableIfNecessary]
  @objname varchar(128)
  , @owner varchar(64) = null
AS
  set nocount on
  exec dbo.rv_sp_boot_createObjIfNecessary @objName, 'U', @owner


GO
