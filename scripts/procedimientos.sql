-- MySQL dump 10.13  Distrib 5.6.35, for osx10.9 (x86_64)
--
-- Host: localhost    Database: clutchyf_ERP
-- ------------------------------------------------------
-- Server version	5.6.35

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'clutchyf_ERP'
--
DROP PROCEDURE IF EXISTS `SP_ERP_INSERTA_SERVICIO`;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ERP_INSERTA_SERVICIO`(IN `nombreCliente` VARCHAR(100), IN `numeroCelular` VARCHAR(20), IN `email` VARCHAR(50), IN `numeroAdicional` VARCHAR(20), IN `marcaVehiculo` VARCHAR(50), IN `modeloVehiculo` VARCHAR(50), IN `anioVehiculo` VARCHAR(50), IN `descripcionServicio` VARCHAR(100))
BEGIN
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
DROP PROCEDURE IF EXISTS `SP_ERP_OBTENER_CLIENTES`;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ERP_OBTENER_CLIENTES`()
BEGIN
	SELECT * FROM tbl_erp_clientes;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
DROP PROCEDURE IF EXISTS `SP_ERP_OBTENER_SERVICIOS`;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'NO_AUTO_VALUE_ON_ZERO' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `SP_ERP_OBTENER_SERVICIOS`(IN `finalizado` INT)
BEGIN
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
        v.modelo_vehiculo,v.anio_vehiculo,v.km_vehiculo,v.placas_vehiculo,
        s.descripcion_servicio,date_format(s.fecha_fin_sevicio,"%d/%M/%Y") as fecha_fin_servicio
        from tbl_erp_servicio s
        inner join tbl_erp_clientes c
        on s.id_cliente = c.id_cliente
        inner join tbl_erp_vehiculos v
        on s.id_vehiculo = v.id_vehiculo
        where s.terminado = 1;
    end if;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-07-03 11:55:20
