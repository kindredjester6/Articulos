USE [master]
GO
/****** Object:  Database [Articulos]    Script Date: 8/27/2023 11:23:34 PM ******/
CREATE DATABASE [Articulos]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Articulos', FILENAME = N'C:\Users\Hussein\Articulos.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Articulos_log', FILENAME = N'C:\Users\Hussein\Articulos_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [Articulos] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Articulos].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Articulos] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Articulos] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Articulos] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Articulos] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Articulos] SET ARITHABORT OFF 
GO
ALTER DATABASE [Articulos] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Articulos] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Articulos] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Articulos] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Articulos] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Articulos] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Articulos] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Articulos] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Articulos] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Articulos] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Articulos] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Articulos] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Articulos] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Articulos] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Articulos] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Articulos] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Articulos] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Articulos] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Articulos] SET  MULTI_USER 
GO
ALTER DATABASE [Articulos] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Articulos] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Articulos] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Articulos] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Articulos] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Articulos] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [Articulos] SET QUERY_STORE = ON
GO
ALTER DATABASE [Articulos] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [Articulos]
GO
/****** Object:  Table [dbo].[Articulo]    Script Date: 8/27/2023 11:23:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Articulo](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[Nombre] [varchar](128) NOT NULL,
	[Precio] [money] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[ListaArticulosQueCumplenPatron]    Script Date: 8/27/2023 11:23:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ListaArticulosQueCumplenPatron] 
	@inPatron VARCHAR(32)
	, @outResultCode INT OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY  -- no siempre se hace try catch en SP que hacen consultas
		SET @outResultCode = 0;  -- no error code

		-- SE HACEN VALIDACIONES

		IF (@inPatron IS NULL)
		BEGIN
			SET @outResultCode = 50002;  -- parametro de entrada es nulo
			RETURN;
		END;

		select @outResultCode  as resultado

		SELECT A.[id]
			, A.[Nombre]
			, A.[Precio]
		FROM dbo.Articulo A
		WHERE A.Nombre like '%'+@inPatron+'%';

	END TRY
	BEGIN CATCH

		INSERT INTO dbo.DBErrors	VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
		);

		Set @outResultCode=50005;
	
	END CATCH


	SET NOCOUNT OFF;
END;
GO
/****** Object:  StoredProcedure [dbo].[OrdenarLista]    Script Date: 8/27/2023 11:23:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OrdenarLista]
AS
SELECT *
From [dbo].[Articulo]
ORDER BY nombre

GO
/****** Object:  StoredProcedure [dbo].[UpdateArticulo]    Script Date: 8/27/2023 11:23:34 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[UpdateArticulo] 
	@inIdArticulo INT			-- PK del articulo cuyos datos vamos a modificar
	, @inNombre VARCHAR(128)		-- Nuevo Nombre de articulo
	, @inPrecio MONEY				-- Nuevo Precion
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	-- Se validan los datos de entrada, pues no estamos seguros que se validaron en capa logica.
	-- Validar que articulo exista.

	BEGIN TRY
		-- Inicia codigo en el cual se captura errores

		DECLARE @outResultCode int
		SET @outResultCode=0;  -- Por default codigo error 0 es que no hubo error

		IF NOT EXISTS (SELECT 1 FROM dbo.Articulo A WHERE A.id=@inIdArticulo)
		BEGIN
			-- procesar error
			SET @outResultCode=50001;		-- Articulo no exist
			RETURN;
		END; 
			INSERT [dbo].[Articulo] (
				 [Nombre]
				, [Precio])
			VALUES (
				 @inNombre
				, @inPrecio
			);
	END TRY
	BEGIN CATCH

		IF @@TRANCOUNT>0  -- error sucedio dentro de la transaccion
		BEGIN
			ROLLBACK TRANSACTION tUpdateArticulo; -- se deshacen los cambios realizados
		END;
		INSERT INTO dbo.DBErrors	VALUES (
			SUSER_SNAME(),
			ERROR_NUMBER(),
			ERROR_STATE(),
			ERROR_SEVERITY(),
			ERROR_LINE(),
			ERROR_PROCEDURE(),
			ERROR_MESSAGE(),
			GETDATE()
		);

		Set @outResultCode=50005;
	
	END CATCH

	SET NOCOUNT OFF;
END;

GO
USE [master]
GO
ALTER DATABASE [Articulos] SET  READ_WRITE 
GO
