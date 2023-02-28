-- Use this schema to create a SQL database which is
-- compatible with all of the scripts in this repository

-- MySQL dump 10.13  Distrib 8.0.31, for Linux (x86_64)
--
--
-- ------------------------------------------------------
-- Server version	8.0.28

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `Accounts`
--

DROP TABLE IF EXISTS `Accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Accounts` (
  `AccountId` varchar(255) NOT NULL,
  `UserId` varchar(255) NOT NULL,
  `PlaidAccessCode` varchar(255) NOT NULL,
  `AccountName` varchar(45) NOT NULL,
  PRIMARY KEY (`AccountId`),
  UNIQUE KEY `UserId_UNIQUE` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Categories`
--

DROP TABLE IF EXISTS `Categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Categories` (
  `CategoryId` varchar(255) NOT NULL,
  `Category` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`CategoryId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `CategoryTransactions`
--

DROP TABLE IF EXISTS `CategoryTransactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CategoryTransactions` (
  `CategoryId` varchar(255) NOT NULL,
  `TransactionId` varchar(255) NOT NULL,
  PRIMARY KEY (`CategoryId`,`TransactionId`),
  KEY `CategoryTransactions_ibfk_2` (`TransactionId`),
  CONSTRAINT `CategoryTransactions_ibfk_1` FOREIGN KEY (`CategoryId`) REFERENCES `Categories` (`CategoryId`),
  CONSTRAINT `CategoryTransactions_ibfk_2` FOREIGN KEY (`TransactionId`) REFERENCES `Transactions` (`TransactionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Shares`
--

DROP TABLE IF EXISTS `Shares`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Shares` (
  `SharesId` varchar(255) NOT NULL,
  `Amount` double NOT NULL,
  `UserId` varchar(255) NOT NULL,
  `TransactionId` varchar(255) NOT NULL,
  PRIMARY KEY (`SharesId`),
  KEY `Shares_ibfk_1` (`TransactionId`),
  KEY `Shares_ibfk_2` (`UserId`),
  CONSTRAINT `Shares_ibfk_1` FOREIGN KEY (`TransactionId`) REFERENCES `Transactions` (`TransactionId`),
  CONSTRAINT `Shares_ibfk_2` FOREIGN KEY (`UserId`) REFERENCES `Users` (`UserId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `TagTransactions`
--

DROP TABLE IF EXISTS `TagTransactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `TagTransactions` (
  `TagId` varchar(255) NOT NULL,
  `TransactionId` varchar(255) NOT NULL,
  PRIMARY KEY (`TagId`,`TransactionId`),
  KEY `TagTransactions_ibfk_2` (`TransactionId`),
  CONSTRAINT `TagTransactions_ibfk_1` FOREIGN KEY (`TagId`) REFERENCES `Tags` (`TagId`),
  CONSTRAINT `TagTransactions_ibfk_2` FOREIGN KEY (`TransactionId`) REFERENCES `Transactions` (`TransactionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Tags`
--

DROP TABLE IF EXISTS `Tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Tags` (
  `TagId` varchar(255) NOT NULL,
  `Tag` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`TagId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Transactions`
--

DROP TABLE IF EXISTS `Transactions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Transactions` (
  `TransactionId` varchar(255) NOT NULL,
  `Name` varchar(255) NOT NULL,
  `MerchantName` varchar(255) DEFAULT NULL,
  `PrimaryCategory` varchar(255) NOT NULL,
  `Categories` varchar(255) DEFAULT NULL,
  `CategoryId` varchar(255) DEFAULT NULL,
  `AccountId` varchar(255) NOT NULL,
  `AccountOwner` varchar(255) NOT NULL,
  `Amount` double NOT NULL,
  `IsPending` tinyint(1) NOT NULL DEFAULT '0',
  `AuthorizedDatetime` timestamp NOT NULL,
  `DateTime` timestamp NULL DEFAULT NULL,
  `PendingTransactionId` varchar(255) DEFAULT NULL,
  `IsoCurrencyCode` varchar(255) DEFAULT NULL,
  `UnofficialCurrencyCode` varchar(255) DEFAULT NULL,
  `PaymentChannel` varchar(255) DEFAULT NULL,
  `TransactionCode` varchar(255) DEFAULT NULL,
  `TransactionType` varchar(255) DEFAULT NULL,
  `CheckNumber` varchar(255) DEFAULT NULL,
  `PersonalFinanceCategory` varchar(255) DEFAULT NULL,
  `ShouldHide` tinyint(1) NOT NULL DEFAULT '0',
  `IsForecastedTransaction` tinyint(1) NOT NULL DEFAULT '0',
  `ShouldEstimate` tinyint(1) NOT NULL DEFAULT '1',
  `Aggregate` tinyint(1) NOT NULL DEFAULT '0',
  `Placeholder` tinyint(1) NOT NULL DEFAULT '0',
  `IsFinalized` tinyint(1) NOT NULL DEFAULT '0',
  `Description` varchar(1000) DEFAULT NULL,
  `Address` varchar(255) DEFAULT NULL,
  `City` varchar(255) DEFAULT NULL,
  `Region` varchar(255) DEFAULT NULL,
  `PostalCode` varchar(255) DEFAULT NULL,
  `Lat` int DEFAULT NULL,
  `Lon` int DEFAULT NULL,
  `Country` varchar(255) DEFAULT NULL,
  `StoreNumber` varchar(255) DEFAULT NULL,
  `AccountName` varchar(255) NOT NULL,
  /* You can rename the two User#Share columns to the names of the users they are associated with,
    but if you do you will also need to update the .env file accordingly. Eventually the scripts
    will be updated to support splitting transactions with an unlimited number of users and these
    two columns will not be needed at all. */
  `User1Share` double DEFAULT '0', 
  `User2Share` double DEFAULT '0',
  `ShouldReview` tinyint(1) DEFAULT '0',
  `WasChecked` tinyint(1) DEFAULT '0',
  `Recipient` varchar(255) DEFAULT NULL,
  `ShouldSplit` tinyint(1) DEFAULT '0',
  `IsGift` tinyint(1) DEFAULT '0',
  `Trip` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`TransactionId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `Users`
--

DROP TABLE IF EXISTS `Users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Users` (
  `UserId` varchar(255) NOT NULL,
  `Username` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL,
  `PhoneNumber` varchar(255) DEFAULT NULL,
  `PlaidAccessCode` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`UserId`),
  UNIQUE KEY `Username_UNIQUE` (`Username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-02-27 17:46:55
