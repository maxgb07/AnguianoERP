-- phpMyAdmin SQL Dump
-- version 4.8.3
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 31-01-2019 a las 16:11:47
-- Versión del servidor: 10.2.21-MariaDB
-- Versión de PHP: 7.2.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `clutchyf_ERP`
--
DROP DATABASE IF EXISTS `clutchyf_ERP`;
CREATE DATABASE IF NOT EXISTS `clutchyf_ERP` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `clutchyf_ERP`;

DELIMITER $$
--
-- Procedimientos
--
DROP PROCEDURE IF EXISTS `SP_ERP_FINALIZA_SERVICIO`$$
CREATE DEFINER=`clutchyf`@`localhost` PROCEDURE `SP_ERP_FINALIZA_SERVICIO` (IN `idServicio` VARCHAR(10), IN `placas` VARCHAR(10), IN `kilometros` VARCHAR(10), IN `unidadVehiculo` VARCHAR(10), IN `descripcionServicio` VARCHAR(100))  BEGIN
	declare idVehiculo int;
	declare servicio int;
    SET servicio = cast(idServicio as unsigned int);
	IF EXISTS (SELECT * FROM tbl_erp_servicio where id_servicio = servicio)THEN
		set idVehiculo = (select id_vehiculo from tbl_erp_servicio where id_servicio = servicio);
		UPDATE tbl_erp_servicio set fecha_fin_sevicio = now(), descripcion_servicio = upper(descripcionServicio), terminado = 1 WHERE id_servicio = servicio;
        UPDATE tbl_erp_vehiculos set placas_vehiculo = upper(placas) , km_vehiculo = kilometros, unidad_vehiculo = upper(unidadVehiculo) WHERE id_vehiculo = idVehiculo;
        SELECT 'finalizado' as estatus;
	ELSE
		SELECT 'error' as estatus;
	END IF;
END$$

DROP PROCEDURE IF EXISTS `SP_ERP_INSERTA_SERVICIO`$$
CREATE DEFINER=`clutchyf`@`localhost` PROCEDURE `SP_ERP_INSERTA_SERVICIO` (IN `nombreCliente` VARCHAR(100), IN `numeroCelular` VARCHAR(20), IN `email` VARCHAR(50), IN `numeroAdicional` VARCHAR(20), IN `marcaVehiculo` VARCHAR(50), IN `modeloVehiculo` VARCHAR(50), IN `anioVehiculo` VARCHAR(50), IN `descripcionServicio` VARCHAR(100))  BEGIN
declare idCliente int;
declare idVehiculo int;
IF EXISTS (SELECT * FROM tbl_erp_clientes where nombre_cliente = nombreCliente) THEN
  set idCliente = (Select id_cliente FROM tbl_erp_clientes where nombre_cliente = nombreCliente);
  insert into tbl_erp_vehiculos(id_cliente,marca_vehiculo,modelo_vehiculo,anio_vehiculo)
    values(idCliente,upper(marcaVehiculo),upper(modeloVehiculo),anioVehiculo);
    set idVehiculo = (Select id_vehiculo from tbl_erp_vehiculos where id_cliente = idCliente LIMIT 1);
    insert into tbl_erp_servicio(id_cliente,id_vehiculo,fecha_inicio_servicio,descripcion_servicio,terminado)
  values(idCliente,idVehiculo,now(),upper(descripcionServicio),0);
    select 'guardado' as estatus;
ELSE
  INSERT INTO tbl_erp_clientes (nombre_cliente,numero_celular,numero_adicional,email)
    VALUES (upper(nombreCliente),numeroCelular,numeroAdicional,email);
    set idCliente = (Select id_cliente FROM tbl_erp_clientes ORDER by id_cliente desc LIMIT 1);
    insert into tbl_erp_vehiculos(id_cliente,marca_vehiculo,modelo_vehiculo,anio_vehiculo)
    values(idCliente,upper(marcaVehiculo),upper(modeloVehiculo),anioVehiculo);
    set idVehiculo = (Select id_vehiculo FROM tbl_erp_vehiculos ORDER by id_vehiculo desc LIMIT 1);
    insert into tbl_erp_servicio(id_cliente,id_vehiculo,fecha_inicio_servicio,descripcion_servicio,terminado)
  values(idCliente,idVehiculo,now(),upper(descripcionServicio),0);
    select 'guardado' as estatus;
END IF;
END$$

DROP PROCEDURE IF EXISTS `SP_ERP_OBTENER_CLIENTES`$$
CREATE DEFINER=`clutchyf`@`localhost` PROCEDURE `SP_ERP_OBTENER_CLIENTES` ()  BEGIN
	SELECT * FROM tbl_erp_clientes;
END$$

DROP PROCEDURE IF EXISTS `SP_ERP_OBTENER_SERVICIOS`$$
CREATE DEFINER=`clutchyf`@`localhost` PROCEDURE `SP_ERP_OBTENER_SERVICIOS` (IN `finalizado` INT)  BEGIN
  SET lc_time_names = 'es_MX';
  IF finalizado = 0 then
    select 
        s.id_servicio,c.nombre_cliente,v.marca_vehiculo,
        v.modelo_vehiculo,v.anio_vehiculo, date_format(s.fecha_inicio_servicio,"%d/%M/%Y") as fecha_inicio_servicio,
        s.descripcion_servicio,v.placas_vehiculo,v.km_vehiculo,date_format(s.fecha_fin_sevicio,"%d/%M/%Y") as fecha_fin_servicio
        from tbl_erp_servicio s
        inner join tbl_erp_clientes c
        on s.id_cliente = c.id_cliente
        inner join tbl_erp_vehiculos v
        on s.id_vehiculo = v.id_vehiculo
        where s.terminado = finalizado;
    else
    select s.id_servicio,c.nombre_cliente,v.marca_vehiculo,
        v.modelo_vehiculo,v.anio_vehiculo,v.km_vehiculo,v.placas_vehiculo,v.unidad_vehiculo,
        s.descripcion_servicio,date_format(s.fecha_fin_sevicio,"%d/%M/%Y") as fecha_fin_servicio,
        date_format(s.fecha_inicio_servicio,"%d/%M/%Y") as fecha_inicio_servicio
        from tbl_erp_servicio s
        inner join tbl_erp_clientes c
        on s.id_cliente = c.id_cliente
        inner join tbl_erp_vehiculos v
        on s.id_vehiculo = v.id_vehiculo
        where s.terminado = 1;
    end if;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `productos_codigo_barras`
--

DROP TABLE IF EXISTS `productos_codigo_barras`;
CREATE TABLE `productos_codigo_barras` (
  `id_producto` int(11) NOT NULL,
  `cve_producto` varchar(50) NOT NULL,
  `codigo_barras` varchar(50) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `productos_codigo_barras`
--

INSERT INTO `productos_codigo_barras` (`id_producto`, `cve_producto`, `codigo_barras`) VALUES
(1, 'RD70', NULL),
(2, 'RD80', NULL),
(3, 'RD85', NULL),
(4, 'RD90', NULL),
(5, 'RD100', NULL),
(6, 'RD120', NULL),
(7, 'RD140', NULL),
(8, 'RD150', NULL),
(9, 'RD160', NULL),
(10, 'RD180', NULL),
(11, 'RD200', NULL),
(12, 'RD240', NULL),
(13, 'MO100', NULL),
(14, 'MO200', NULL),
(15, 'MO300', NULL),
(16, 'MO400', NULL),
(17, 'MO500', NULL),
(18, 'MO600', NULL),
(19, 'MO700', NULL),
(20, 'MO800', NULL),
(21, 'MO900', NULL),
(22, 'MO1000', NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_erp_clientes`
--

DROP TABLE IF EXISTS `tbl_erp_clientes`;
CREATE TABLE `tbl_erp_clientes` (
  `id_cliente` int(11) NOT NULL,
  `nombre_cliente` varchar(255) NOT NULL,
  `numero_celular` varchar(20) NOT NULL,
  `numero_adicional` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tbl_erp_clientes`
--

INSERT INTO `tbl_erp_clientes` (`id_cliente`, `nombre_cliente`, `numero_celular`, `numero_adicional`, `email`) VALUES
(1, 'Maximiliano Gonzalez', '4433425609', NULL, NULL),
(2, 'Pedro', '4444444444', NULL, NULL),
(3, 'Perenganito', '4444444444', NULL, NULL),
(4, 'Miroslava Lopez', '4432227241', NULL, NULL),
(5, 'estatus', '45454', '4564', NULL),
(6, 'qwqw', 'qwqw', 'qwqw', NULL),
(7, 'fgdfgdf', 'dfgfdg', 'fdgfdg', NULL),
(8, 'rtret', 'retret', 'retret', NULL),
(9, 'prueba en server', '4433425609', 'qwertyu', NULL),
(10, 'emilio gonzalez', '4433425609', 'asasas', NULL),
(11, 'EDUARDO CASTILLO', '4431649813', 'xxxx', NULL),
(12, 'Prueba desde mÃ³vil ', '4433425609', '4433425609', NULL),
(13, 'PRUEBA DESDE SERVIDOR', '4444', '', 'maxgb07@outlook.com'),
(14, 'MAXIMILIANO GONZALEZ BETANCOURT', '014433425609', '014433425609', 'maxgb07@gmail.com'),
(15, 'FER OSEGUERA', '4433425609', '56565', 'DKLGNSFLKGN@KFJGHK-COM'),
(16, 'GDFGFD', 'fdgdfg', 'fgfdg', 'gffdg');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_erp_servicio`
--

DROP TABLE IF EXISTS `tbl_erp_servicio`;
CREATE TABLE `tbl_erp_servicio` (
  `id_servicio` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `id_vehiculo` int(11) NOT NULL,
  `fecha_inicio_servicio` datetime NOT NULL,
  `fecha_fin_sevicio` datetime DEFAULT NULL,
  `descripcion_servicio` varchar(1000) DEFAULT NULL,
  `terminado` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tbl_erp_servicio`
--

INSERT INTO `tbl_erp_servicio` (`id_servicio`, `id_cliente`, `id_vehiculo`, `fecha_inicio_servicio`, `fecha_fin_sevicio`, `descripcion_servicio`, `terminado`) VALUES
(1, 1, 1, '2018-05-23 00:00:00', NULL, 'Cambio de baltas 4 ruedas', 0),
(2, 2, 2, '2018-05-30 09:58:29', NULL, 'cambio de clutch', 0),
(3, 3, 3, '2018-05-30 09:58:56', NULL, 'revision de 4 ruedas y clutch', 0),
(4, 1, 1, '2018-05-30 14:00:10', NULL, 'Prueba SP3', 0),
(5, 4, 8, '2018-05-30 15:31:34', NULL, 'otra prueba', 0),
(6, 5, 9, '2018-05-31 13:35:37', NULL, 'fdgdfgf', 0),
(7, 6, 10, '2018-05-31 13:58:53', NULL, 'qwqw', 0),
(8, 6, 10, '2018-05-31 13:59:27', NULL, 'qwqw', 0),
(9, 7, 12, '2018-05-31 14:31:51', NULL, 'fdgfdg', 0),
(10, 8, 13, '2018-05-31 14:39:17', NULL, 'retretret', 0),
(11, 8, 13, '2018-05-31 14:39:27', NULL, 'retretret', 0),
(12, 8, 13, '2018-05-31 14:44:46', NULL, 'retretret', 0),
(13, 8, 13, '2018-05-31 14:44:53', NULL, 'retretret', 0),
(14, 8, 13, '2018-05-31 14:45:35', NULL, 'retretret', 0),
(15, 8, 13, '2018-05-31 14:46:14', NULL, 'retretret', 0),
(16, 8, 13, '2018-05-31 14:46:30', NULL, 'retretret', 0),
(17, 8, 13, '2018-05-31 14:52:28', NULL, 'retretret', 0),
(18, 8, 13, '2018-05-31 14:52:29', NULL, 'retretret', 0),
(19, 8, 13, '2018-05-31 14:53:03', NULL, 'retretret', 0),
(20, 9, 23, '2018-06-01 17:37:11', NULL, 'balatas delanteras', 0),
(21, 10, 24, '2018-06-02 08:33:48', '2018-06-02 08:44:22', 'suena la suspension', 1),
(22, 11, 25, '2018-06-02 09:57:22', NULL, 'REVISION DE LAS 4 RUEDAS', 0),
(23, 12, 26, '2018-06-04 10:09:07', NULL, 'Prueba desde mÃ³vil ', 0),
(24, 10, 24, '2018-06-26 11:14:21', NULL, 'Rechina frenos delanteros', 0),
(25, 13, 28, '2018-07-03 12:41:31', '2019-01-28 14:02:06', '', 1),
(28, 16, 31, '2019-01-31 14:22:12', NULL, 'FGDFG', 0),
(26, 14, 29, '2018-07-13 14:05:29', '2018-07-13 14:05:58', 'PRUEBA A SERVICIOS FINALIZADOS', 1),
(27, 15, 30, '2019-01-24 18:01:31', '2019-01-24 18:05:30', 'WD26', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `tbl_erp_vehiculos`
--

DROP TABLE IF EXISTS `tbl_erp_vehiculos`;
CREATE TABLE `tbl_erp_vehiculos` (
  `id_vehiculo` int(11) NOT NULL,
  `id_cliente` int(11) NOT NULL,
  `marca_vehiculo` varchar(25) DEFAULT NULL,
  `modelo_vehiculo` varchar(25) DEFAULT NULL,
  `anio_vehiculo` varchar(10) DEFAULT NULL,
  `placas_vehiculo` varchar(10) DEFAULT NULL,
  `km_vehiculo` varchar(255) DEFAULT NULL,
  `unidad_vehiculo` varchar(10) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `tbl_erp_vehiculos`
--

INSERT INTO `tbl_erp_vehiculos` (`id_vehiculo`, `id_cliente`, `marca_vehiculo`, `modelo_vehiculo`, `anio_vehiculo`, `placas_vehiculo`, `km_vehiculo`, `unidad_vehiculo`) VALUES
(1, 1, 'Volkswagen', 'Polo', '2018', 'PFZ309P', '10000', NULL),
(2, 2, 'Seat', 'Ibiza', '2010', NULL, NULL, NULL),
(3, 3, 'Ford', 'Lobo', '2005', NULL, NULL, NULL),
(4, 1, 'Suzuki', 'Swift', '2013', NULL, NULL, NULL),
(5, 1, 'Honda', 'Accord', '2015', NULL, NULL, NULL),
(6, 1, 'Chrysler', 'Voyager', '2006', NULL, NULL, NULL),
(7, 1, 'smart', 'for two', '2009', NULL, NULL, NULL),
(8, 4, 'chrysler', 'voyager', '1996', NULL, NULL, NULL),
(9, 5, 'sdfhl', 'fgfdg', '2008', NULL, NULL, NULL),
(10, 6, 'qwqw', 'qwqw', 'qwqw', NULL, NULL, NULL),
(11, 6, 'qwqw', 'qwqw', 'qwqw', NULL, NULL, NULL),
(12, 7, 'fdgfdg', 'fdgfdg', 'fdgfdg', NULL, NULL, NULL),
(13, 8, 'retret', 'retret', 'retret', NULL, NULL, NULL),
(14, 8, 'retret', 'retret', 'retret', NULL, NULL, NULL),
(15, 8, 'retret', 'retret', 'retret', NULL, NULL, NULL),
(16, 8, 'retret', 'retret', 'retret', NULL, NULL, NULL),
(17, 8, 'retret', 'retret', 'retret', NULL, NULL, NULL),
(18, 8, 'retret', 'retret', 'retret', NULL, NULL, NULL),
(19, 8, 'retret', 'retret', 'retret', NULL, NULL, NULL),
(20, 8, 'retret', 'retret', 'retret', NULL, NULL, NULL),
(21, 8, 'retret', 'retret', 'retret', NULL, NULL, NULL),
(22, 8, 'retret', 'retret', 'retret', NULL, NULL, NULL),
(23, 9, 'Audi', 'A1', '2015', NULL, NULL, NULL),
(24, 10, 'suzuki', 'Swift', '2013', NULL, NULL, NULL),
(25, 11, 'TOYOTA', 'RAV4', '2005', NULL, NULL, NULL),
(26, 12, 'Seat', 'Ibiza', '2009', NULL, NULL, NULL),
(27, 10, 'Suzuki', 'Swift', '2013', NULL, NULL, NULL),
(28, 13, 'VOLKSWAGEN', 'POLO', '2018', '4435', '45354', ''),
(29, 14, 'VOLKSWAGEN', 'POLO', '2018', 'PFZ509P', '13000', 'UNIDAD 56'),
(30, 15, 'NISSAN', 'PICKUP', '2005', 'XFGFCGFD', '4566', ''),
(31, 16, 'FDGDFG', 'FDGDF', 'fdgdfg', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE `usuarios` (
  `id_usuario` int(11) NOT NULL,
  `nombre_usuario` varchar(100) NOT NULL,
  `contrasena_usuario` varchar(100) NOT NULL,
  `activo` tinyint(1) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`id_usuario`, `nombre_usuario`, `contrasena_usuario`, `activo`) VALUES
(1, 'maxgb07', 'Abcde1', 1);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `productos_codigo_barras`
--
ALTER TABLE `productos_codigo_barras`
  ADD PRIMARY KEY (`id_producto`);

--
-- Indices de la tabla `tbl_erp_clientes`
--
ALTER TABLE `tbl_erp_clientes`
  ADD PRIMARY KEY (`id_cliente`);

--
-- Indices de la tabla `tbl_erp_servicio`
--
ALTER TABLE `tbl_erp_servicio`
  ADD PRIMARY KEY (`id_servicio`);

--
-- Indices de la tabla `tbl_erp_vehiculos`
--
ALTER TABLE `tbl_erp_vehiculos`
  ADD PRIMARY KEY (`id_vehiculo`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id_usuario`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `productos_codigo_barras`
--
ALTER TABLE `productos_codigo_barras`
  MODIFY `id_producto` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT de la tabla `tbl_erp_clientes`
--
ALTER TABLE `tbl_erp_clientes`
  MODIFY `id_cliente` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT de la tabla `tbl_erp_servicio`
--
ALTER TABLE `tbl_erp_servicio`
  MODIFY `id_servicio` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT de la tabla `tbl_erp_vehiculos`
--
ALTER TABLE `tbl_erp_vehiculos`
  MODIFY `id_vehiculo` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id_usuario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
