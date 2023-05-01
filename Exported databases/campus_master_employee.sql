-- MySQL dump 10.13  Distrib 8.0.30, for macos12 (x86_64)
--
-- Host: localhost    Database: campus
-- ------------------------------------------------------
-- Server version	8.0.32

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `master_employee`
--

DROP TABLE IF EXISTS `master_employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_employee` (
  `e_id` varchar(15) NOT NULL,
  `full_name` varchar(50) DEFAULT NULL,
  `email` varchar(250) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `emirates_id` int DEFAULT NULL,
  `nationality_id` varchar(3) DEFAULT NULL,
  `designation` varchar(50) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `yearly_salary` decimal(10,2) DEFAULT NULL,
  `join_date` date DEFAULT NULL,
  `management` varchar(15) DEFAULT NULL,
  PRIMARY KEY (`e_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `emirates_id` (`emirates_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_employee`
--

LOCK TABLES `master_employee` WRITE;
/*!40000 ALTER TABLE `master_employee` DISABLE KEYS */;
INSERT INTO `master_employee` VALUES ('132','Mark Jackson','jack@mark.com','+98278347834',488243,'IND','Coordinator','Al Quaa',20000.00,'2023-09-12','library'),('145','Roy Keane','keen@roy.com','+971561893232',488242,'IND','Warden','DSO',10000.00,'2023-09-12','hostel'),('176','Jones Jackson','jones@indiana.com','+9322423423',488244,'IND','Cafeteria Personal','Georgia',30000.00,'2023-09-12','hostel'),('260','Mark Bober','mark@1.com','+971458954652',488240,'IND','Cleaning Staff','Sky Zone',50000.00,'2023-07-11','hostel'),('265','Mark Rober','mark@42.com','+9714589232',488245,'IND','Cleaning Staff','Sky Zone',40000.00,'2023-07-11','academics'),('300','Bruher','bru@bruh.com','+971458434',748324,'IND','Cleaning Staff','Sky Zone',40000.00,'2023-07-11','canteen'),('302','Idk whats','brugdfg@bruh.com','+9714584534',748332423,'IND','Cleaning Staff','Sky Zone',40000.00,'2023-07-11','library');
/*!40000 ALTER TABLE `master_employee` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `employee_to_hostel` AFTER INSERT ON `master_employee` FOR EACH ROW BEGIN
	IF NEW.management = 'hostel' THEN
	INSERT INTO hostel.HostelStaff VALUES (
    NEW.e_id,
    SUBSTRING_INDEX(NEW.full_name,' ', 1),
    SUBSTRING_INDEX(NEW.full_name,' ', -1),
    NEW.email,
    NEW.phone,
    NEW.designation
    );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `employee_to_canteen` AFTER INSERT ON `master_employee` FOR EACH ROW BEGIN
	IF NEW.management = 'canteen' THEN
	INSERT INTO canteen.CanteenStaff VALUES (
    NEW.e_id,
    SUBSTRING_INDEX(NEW.full_name,' ', 1),
    SUBSTRING_INDEX(NEW.full_name,' ', -1),
    NEW.phone,
    NEW.designation
    );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `employee_to_library` AFTER INSERT ON `master_employee` FOR EACH ROW BEGIN
	IF NEW.management = 'library' THEN
	INSERT INTO library.LibraryStaff VALUES (
    NEW.e_id,
    SUBSTRING_INDEX(NEW.full_name,' ', 1),
    SUBSTRING_INDEX(NEW.full_name,' ', -1),
    NEW.designation,
    NEW.email
    );
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `update_employee_details` AFTER UPDATE ON `master_employee` FOR EACH ROW BEGIN
	IF OLD.management = 'hostel' AND NEW.management = 'hostel' THEN # No change in the hostler status
	UPDATE hostel.HostelStaff SET
    staff_id = NEW.e_id,
    fname = SUBSTRING_INDEX(NEW.full_name,' ', 1),
    lname = SUBSTRING_INDEX(NEW.full_name,' ', -1),
    email= NEW.email,
    phone = NEW.phone
    WHERE staff_id = OLD.e_id;
    END IF;
    
	IF OLD.management = 'academics' AND NEW.management = 'academics' THEN # No change in academics status
	UPDATE academics.Professor SET
    prof_id = NEW.e_id,
    fname = SUBSTRING_INDEX(NEW.full_name,' ', 1),
    lname = SUBSTRING_INDEX(NEW.full_name,' ', -1),
    email= NEW.email,
    phone = NEW.phone
    WHERE prof_id = OLD.e_id;
    END IF;

	IF OLD.management = 'canteen' AND NEW.management = 'canteen' THEN # No change in canteen status
	UPDATE canteen.CanteenStaff SET
    staff_id = NEW.e_id,
    fname = SUBSTRING_INDEX(NEW.full_name,' ', 1),
    lname = SUBSTRING_INDEX(NEW.full_name,' ', -1),
    phone = NEW.phone,
    designation = NEW.designation
    WHERE staff_id = OLD.e_id;
    END IF;

	IF OLD.management = 'library' AND NEW.management = 'library' THEN # No change in canteen status
	UPDATE canteen.CanteenStaff SET
    staff_id = NEW.e_id,
    fname = SUBSTRING_INDEX(NEW.full_name,' ', 1),
    lname = SUBSTRING_INDEX(NEW.full_name,' ', -1),
    designation = NEW.designation,
    email = NEW.email
    WHERE staff_id = OLD.e_id;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `assign_employee` AFTER UPDATE ON `master_employee` FOR EACH ROW BEGIN
	IF OLD.management IS NULL THEN
		IF NEW.management = 'hostel' THEN
		INSERT INTO hostel.HostelStaff VALUES (
		NEW.e_id,
		SUBSTRING_INDEX(NEW.full_name,' ', 1),
		SUBSTRING_INDEX(NEW.full_name,' ', -1),
		NEW.email,
		NEW.phone,
		NEW.designation
		);

		ELSEIF NEW.management = 'academics' THEN
		INSERT INTO academics.Professor(prof_id, fname, lname,designation, email) VALUES (
		NEW.e_id,
		SUBSTRING_INDEX(NEW.full_name,' ', 1),
		SUBSTRING_INDEX(NEW.full_name,' ', -1),
		NEW.designation,
		NEW.email
		);
		ELSEIF NEW.management = 'canteen' THEN
		INSERT INTO canteen.CanteenStaff(staff_id, fname, lname, phone, designation) VALUES (
		NEW.e_id,
		SUBSTRING_INDEX(NEW.full_name,' ', 1),
		SUBSTRING_INDEX(NEW.full_name,' ', -1),
		NEW.phone,
		NEW.designation
		);
		ELSEIF NEW.management = 'library' THEN
		INSERT INTO library.LibraryStaff VALUES (
		NEW.e_id,
		SUBSTRING_INDEX(NEW.full_name,' ', 1),
		SUBSTRING_INDEX(NEW.full_name,' ', -1),
		NEW.designation,
		NEW.email
		);
        END IF;
	END IF;
END */;;
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

-- Dump completed on 2023-05-01 23:03:53
