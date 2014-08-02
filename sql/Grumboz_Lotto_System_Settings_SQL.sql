-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.5.9-log - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             8.3.0.4694
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping database structure for lotto
CREATE DATABASE IF NOT EXISTS `lotto` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `lotto`;


-- Dumping structure for table lotto.entries
CREATE TABLE IF NOT EXISTS `entries` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `count` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=latin1;

-- Dumping data for table lotto.entries: ~5 rows (approximately)
/*!40000 ALTER TABLE `entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `entries` ENABLE KEYS */;


-- Dumping structure for table lotto.history
CREATE TABLE IF NOT EXISTS `history` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `start` bigint(20) unsigned DEFAULT NULL,
  `winner` varchar(50) NOT NULL,
  `amount` int(11) DEFAULT NULL,
  `entries` int(11) DEFAULT '0',
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=387 DEFAULT CHARSET=latin1;

-- Dumping data for table lotto.history: ~9 rows (approximately)
/*!40000 ALTER TABLE `history` DISABLE KEYS */;
/*!40000 ALTER TABLE `history` ENABLE KEYS */;


-- Dumping structure for table lotto.settings
CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(1) unsigned NOT NULL AUTO_INCREMENT,
  `item` int(11) unsigned NOT NULL,
  `timer` bigint(20) unsigned NOT NULL,
  `operation` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `mumax` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `comments` varchar(21844) NOT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 MAX_ROWS=1;

-- Dumping data for table lotto.settings: ~1 rows (approximately)
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
REPLACE INTO `settings` (`id`, `item`, `timer`, `operation`, `mumax`, `comments`) VALUES
	(1, 44209, 300000, 1, 10, 'item :\r\nthe item id for what they will win(custom currency)\r\n\r\ntimer :\r\n604800000 == 1 week\r\n86400000 == 1 day\r\n3600000 == 1 hour\r\n60000 == 1 minute');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
