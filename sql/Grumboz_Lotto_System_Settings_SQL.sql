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
  `name` varchar(20) NOT NULL,
  `guid` int(11) NOT NULL,
  `count` int(11) unsigned NOT NULL DEFAULT '0',
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table lotto.entries: ~0 rows (approximately)
/*!40000 ALTER TABLE `entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `entries` ENABLE KEYS */;


-- Dumping structure for table lotto.settings
CREATE TABLE IF NOT EXISTS `settings` (
  `item` int(11) unsigned NOT NULL,
  `cost` tinyint(3) unsigned NOT NULL,
  `timer` int(10) unsigned NOT NULL,
  `operation` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `rndmax` int(3) unsigned NOT NULL DEFAULT '1',
  `require` tinyint(3) unsigned NOT NULL DEFAULT '4',
  `maxcount` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `comments` varchar(11844) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 MAX_ROWS=1;

-- Dumping data for table lotto.settings: 1 rows
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
INSERT INTO `settings` (`item`, `cost`, `timer`, `operation`, `rndmax`, `require`, `maxcount`, `comments`) VALUES
	(44209, 1, 90000, 1, 10, 4, 3, 'item :\r\nthe item id for what they will win(custom currency)\r\n\r\ncost:\r\nhow many of (item) per entry\r\n\r\ntimer:\r\n604800000 == 1 week\r\n86400000 == 1 day\r\n3600000 == 1 hour\r\n1800000 == 30 minutes\r\n900000 == 15 minutes\r\n600000 == 10 minutes\r\n60000 == 1 minute\r\n\r\nrequire:\r\nhow many entrries are required for the lotto to search for a winner.\r\ndefault = 4\r\nmaxcount:\r\nhow many times a player can enter a lotto\r\n0 == infinate amount of entries.\r\n1+ == max amount a player can enter per lotto');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
