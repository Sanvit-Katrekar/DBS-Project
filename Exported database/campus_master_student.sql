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
-- Table structure for table `master_student`
--

DROP TABLE IF EXISTS `master_student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `master_student` (
  `s_id` varchar(15) NOT NULL,
  `full_name` varchar(50) DEFAULT NULL,
  `email` varchar(250) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `nationality_id` varchar(3) DEFAULT NULL,
  `emirates_id` int DEFAULT NULL,
  `passport_no` varchar(15) DEFAULT NULL,
  `join_date` date DEFAULT NULL,
  `is_hosteler` tinyint DEFAULT NULL,
  PRIMARY KEY (`s_id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `phone` (`phone`),
  UNIQUE KEY `emirates_id` (`emirates_id`),
  UNIQUE KEY `passport_no` (`passport_no`),
  KEY `nationality_id` (`nationality_id`),
  CONSTRAINT `master_student_ibfk_1` FOREIGN KEY (`nationality_id`) REFERENCES `nationalities` (`n_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `master_student`
--

LOCK TABLES `master_student` WRITE;
/*!40000 ALTER TABLE `master_student` DISABLE KEYS */;
INSERT INTO `master_student` VALUES ('2019A4PS0076U','Cristiano Ronaldo','finis@ronaldo.com','+971535542','Portugal, near ronaldo','IND',67123,'89567','2024-02-11',1),('2020A1PS0008U','Sadio Mane','mane@sad.com','+9719839473','Senegal, Al Qusqa, near Touba Mosque','IND',55555,'67671','2020-12-12',0),('2021A7PS0045U','Harry Potter','harry@potter.com','+97145334','Bruh','IND',4353,'234234','2023-11-02',1),('2021A7PS0063U','Lionel Messi','goat@ronaldo.com','+9714534525','Argentina, BuenoAires airport','IND',45321,'90891','2021-12-01',1),('2021AATS0078U','Manuel Akanji','manuel@qq.com','+971534542','Switzerland, Sector 45, Jungefrau','IND',4343,'42343','2023-11-02',0);
/*!40000 ALTER TABLE `master_student` ENABLE KEYS */;
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `student_to_hostel` AFTER INSERT ON `master_student` FOR EACH ROW BEGIN
	IF NEW.is_hosteler THEN
	INSERT INTO hostel.HostlersInfo VALUES (
    NEW.s_id,
    SUBSTRING_INDEX(NEW.full_name,' ', 1),
    SUBSTRING_INDEX(NEW.full_name,' ', -1),
    NEW.emirates_id,
    NEW.passport_no,
    NEW.phone
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
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `student_to_hostel_2` AFTER UPDATE ON `master_student` FOR EACH ROW BEGIN
	IF NEW.is_hosteler THEN
	INSERT INTO hostel.HostlersInfo VALUES (
    NEW.s_id,
    SUBSTRING_INDEX(NEW.full_name,' ', 1),
    SUBSTRING_INDEX(NEW.full_name,' ', -1),
    NEW.emirates_id,
    NEW.passport_no,
    NEW.phone
    );
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

-- Dump completed on 2023-04-30 13:22:04
