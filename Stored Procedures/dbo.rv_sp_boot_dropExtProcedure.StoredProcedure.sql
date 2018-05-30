USE [HRDW]
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_boot_dropExtProcedure]    Script Date: 5/1/2018 1:37:50 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/****** Object:  StoredProcedure [dbo].[rv_sp_boot_dropExtProcedure]    Script Date: 12/01/2009 13:55:38 ******/




/**
 * Utility procedure to drop an EXTENDED PROCEDURE
 */
Create Procedure [dbo].[rv_sp_boot_dropExtProcedure]
  @objname varchar(128)
  , @owner varchar(64) = null
AS
  set nocount on

  exec dbo.rv_sp_boot_dropObject @objname, 'X', @owner


GO
