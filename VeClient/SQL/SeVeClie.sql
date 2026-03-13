USE [master]
GO
CREATE DATABASE [VeClient]
GO

ALTER DATABASE [VeClient] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))

begin
EXEC [VeClient].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [VeClient] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [VeClient] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [VeClient] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [VeClient] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [VeClient] SET ARITHABORT OFF 
GO
ALTER DATABASE [VeClient] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [VeClient] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [VeClient] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [VeClient] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [VeClient] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [VeClient] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [VeClient] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [VeClient] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [VeClient] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [VeClient] SET  DISABLE_BROKER 
GO
ALTER DATABASE [VeClient] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [VeClient] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [VeClient] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [VeClient] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [VeClient] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [VeClient] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [VeClient] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [VeClient] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [VeClient] SET  MULTI_USER 
GO
ALTER DATABASE [VeClient] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [VeClient] SET DB_CHAINING OFF 
GO
ALTER DATABASE [VeClient] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [VeClient] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [VeClient] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [VeClient] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [VeClient] SET QUERY_STORE = OFF
GO

USE [VeClient]
GO
/****** Object:  Table [dbo].[EstCivil]    Script Date: 3/13/2026 10:27:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EstCivil](
	[id_estado_civil] [int] IDENTITY(1,1) NOT NULL,
	[estado_civil] [varchar](50) NOT NULL,
 CONSTRAINT [PK_EstadoCivil] PRIMARY KEY CLUSTERED 
(
	[id_estado_civil] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[SeVeClie]    Script Date: 3/13/2026 10:27:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SeVeClie](
	[id_clie] [nvarchar](50) NOT NULL,
	[cedula] [varchar](50) NOT NULL,
	[nombre] [varchar](50) NOT NULL,
	[apellido] [varchar](50) NULL,
	[genero] [varchar](50) NOT NULL,
	[fecha_nac] [datetime] NOT NULL,
	[id_estado_civil] [int] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_VeClient] PRIMARY KEY CLUSTERED 
(
	[id_clie] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [IX_SeVeClie] UNIQUE NONCLUSTERED 
(
	[cedula] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[User]    Script Date: 3/13/2026 10:27:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[User](
	[id_user] [nvarchar](50) NOT NULL,
	[username] [varchar](50) NOT NULL,
	[password] [varchar](150) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NOT NULL,
	[deleted_at] [datetime] NULL,
 CONSTRAINT [PK_User] PRIMARY KEY CLUSTERED 
(
	[id_user] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[SeVeClie]  WITH CHECK ADD  CONSTRAINT [FK_VeClient_EstadoCivil] FOREIGN KEY([id_estado_civil])
REFERENCES [dbo].[EstCivil] ([id_estado_civil])
GO
ALTER TABLE [dbo].[SeVeClie] CHECK CONSTRAINT [FK_VeClient_EstadoCivil]
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllSeVeClie]    Script Date: 3/13/2026 10:27:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		
-- Create date: 3/11/2026
-- Description:	Obtener la información de todos los clientes, aplicando filtros y paginado
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetAllSeVeClie]
	@PageSize INT,
	@PageNum INT,
	@OrderField VARCHAR(20),
	@OrderDir VARCHAR(4),
	@FilterValue VARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @ClieFiltered TABLE (id_clie VARCHAR(50) PRIMARY KEY,[Row] INT);
	DECLARE @IdClieTemporal TABLE ([Row] INT PRIMARY KEY IDENTITY(1,1) NOT NULL, id_clie VARCHAR(50));
		
	INSERT INTO @ClieFiltered
	SELECT svc.id_clie,
	ROW_NUMBER() OVER(ORDER BY
	CASE WHEN @OrderField = 'cedula' AND @OrderDir='asc' THEN svc.[cedula] END ASC,
	CASE WHEN @OrderField = 'cedula' AND @OrderDir='desc' THEN svc.[cedula] END DESC,
	CASE WHEN @OrderField = 'nombre' AND @OrderDir='asc' THEN svc.[nombre] END ASC,
	CASE WHEN @OrderField = 'nombre' AND @OrderDir='desc' THEN svc.[nombre] END DESC,
	CASE WHEN @OrderField = 'genero' AND @OrderDir='asc' THEN svc.[genero] END ASC,
	CASE WHEN @OrderField = 'genero' AND @OrderDir='desc' THEN svc.[genero] END DESC,
	CASE WHEN @OrderField = 'estado_civil' AND @OrderDir='asc' THEN ec.[estado_civil] END ASC,
	CASE WHEN @OrderField = 'estado_civil' AND @OrderDir='desc' THEN ec.[estado_civil] END DESC) AS [Row]
	FROM SeVeClie AS svc
	INNER JOIN EstCivil ec ON svc.id_estado_civil = ec.id_estado_civil
	WHERE (ISNULL(@FilterValue,'') = '' OR (
	svc.cedula like (@FilterValue)+'%' OR
	svc.nombre like (@FilterValue)+'%' OR
	svc.genero like (@FilterValue)+'%' OR
	ec.estado_civil like (@FilterValue)+'%'))
	and svc.deleted_at is null


	INSERT INTO @IdClieTemporal
		SELECT cf.id_clie
		FROM @ClieFiltered cf
		ORDER BY cf.[Row]
		OFFSET @PageSize * @PageNum ROWS
		FETCH NEXT @PageSize ROWS ONLY

	SELECT 
		svc.id_clie, 
		svc.cedula,
		svc.nombre,
		svc.apellido,
		svc.genero,
		svc.fecha_nac,
		ec.estado_civil,
		(SELECT COUNT(1) [TotalRec] FROM @ClieFiltered) [total_rec]
	FROM @IdClieTemporal AS icf
	INNER JOIN SeVeClie svc on icf.id_clie = svc.id_clie
	INNER JOIN EstCivil ec on svc.id_estado_civil = ec.id_estado_civil
	ORDER BY icf.[Row]
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetAllSeVeClie_Report]    Script Date: 3/13/2026 10:27:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		
-- Create date: 3/12/2026
-- Description:	Obtener la información de todos los clientes para el reporte
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetAllSeVeClie_Report]
	@FilterValue VARCHAR(50) null
AS
BEGIN
	SELECT 
		svc.id_clie, 
		svc.cedula,
		svc.nombre,
		svc.apellido,
		svc.genero,
		svc.fecha_nac,
		ec.estado_civil
	FROM SeVeClie AS svc
	INNER JOIN EstCivil ec on svc.id_estado_civil = ec.id_estado_civil
	WHERE (ISNULL(@FilterValue,'') = '' OR (
	svc.cedula like (@FilterValue)+'%' OR
	svc.nombre like (@FilterValue)+'%' OR
	svc.genero like (@FilterValue)+'%' OR
	ec.estado_civil like (@FilterValue)+'%'))
	ORDER BY SVC.cedula
END
GO
/****** Object:  StoredProcedure [dbo].[sp_GetSeVeClieById]    Script Date: 3/13/2026 10:27:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		
-- Create date: 3/11/2026
-- Description:	Obtener la información de un cliente dado su id
-- =============================================
CREATE PROCEDURE [dbo].[sp_GetSeVeClieById]
@IdClie nvarchar(50)
AS
BEGIN
	SELECT 
		svc.id_clie,
		svc.cedula, 
		svc.nombre, 
		svc.apellido, 
		svc.genero, 
		svc.fecha_nac, 
		svc.id_estado_civil
	FROM SeVeClie AS svc 
	WHERE svc.id_clie = @IdClie and svc.deleted_at is null
END
GO
/****** Object:  StoredProcedure [dbo].[sp_UpdateSeVeClieById]    Script Date: 3/13/2026 10:27:36 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		
-- Create date: 3/11/2026
-- Description:	Actualizar la información de un cliente dado su id
-- =============================================
CREATE PROCEDURE [dbo].[sp_UpdateSeVeClieById]
	@IdClie nvarchar(50),
	@Cedula varchar(50),
	@Nombre varchar(50),
	@Apellido varchar(50),
	@Genero varchar(50),
	@Fecha_nac Datetime,
	@Id_estado_civil int,
	@Updated_at Datetime
AS
BEGIN
	update SeVeClie set
		cedula = case when @Cedula != cedula then @Cedula else cedula end,
		nombre = case when @Nombre != nombre then @Nombre else nombre end,
		apellido = case when @Apellido != apellido then @Apellido else apellido end,
		genero = case when @Genero != genero then @Genero else genero end,
		fecha_nac = case when @Fecha_nac != fecha_nac then @Fecha_nac else fecha_nac end,
		id_estado_civil = case when @Id_estado_civil != id_estado_civil then @Id_estado_civil else id_estado_civil end,
		updated_at = @Updated_at
	where id_clie = @IdClie
END
GO
USE [master]
GO
ALTER DATABASE [VeClient] SET  READ_WRITE 
GO
