-- --------------------------------------------------------
-- Host:                         localhost
-- Server version:               5.6.10 - MySQL Community Server (GPL)
-- Server OS:                    Win64
-- HeidiSQL Version:             8.3.0.4796
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
  `guid` int(11) unsigned NOT NULL COMMENT 'player db guid',
  `count` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table lotto.entries: ~0 rows (approximately)
/*!40000 ALTER TABLE `entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `entries` ENABLE KEYS */;


-- Dumping structure for table lotto.settings
CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(1) unsigned NOT NULL AUTO_INCREMENT,
  `item` int(11) unsigned DEFAULT NULL,
  `timer` int(10) unsigned NOT NULL,
  `operation` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `mumax` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `comments` varchar(21844) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=latin1 MAX_ROWS=1;

-- Dumping data for table lotto.settings: ~0 rows (approximately)
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` (`id`, `item`, `timer`, `operation`, `mumax`, `comments`) VALUES
	(1, 44209, 1800000, 1, 10, 'item :\r\nthe item id for what they will win(custom currency)\r\n\r\ntimer :\r\n604800000 == 1 week\r\n86400000 == 1 day\r\n3600000 == 1 hour\r\n60000 == 1 minute');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;


