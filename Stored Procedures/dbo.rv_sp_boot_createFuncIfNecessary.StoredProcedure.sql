USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_boot_createFuncIfNecessary]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****** Object:  StoredProcedure [dbo].[rv_sp_boot_createFuncIfNecessary]    Script Date: 12/01/2009 13:55:37 ******/




/**
 * Given a function name, create a dummy copy of it if necessary
 */
create PROCEDURE [dbo].[rv_sp_boot_createFuncIfNecessary]
  @objname varchar(128)
  , @owner varchar(64) = null
AS
  set nocount on
  exec dbo.rv_sp_boot_createObjIfNecessary @objName, 'FN', @owner


GO
