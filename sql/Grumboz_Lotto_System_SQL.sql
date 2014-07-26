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
  `id` int(11) unsigned DEFAULT NULL,
  `name` varchar(50) NOT NULL,
  `count` int(11) unsigned NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table lotto.entries: ~0 rows (approximately)
/*!40000 ALTER TABLE `entries` DISABLE KEYS */;
/*!40000 ALTER TABLE `entries` ENABLE KEYS */;


-- Dumping structure for table lotto.history
CREATE TABLE IF NOT EXISTS `history` (
  `id` int(11) unsigned DEFAULT NULL,
  `start` int(11) unsigned DEFAULT NULL,
  `winner` varchar(50) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table lotto.history: ~0 rows (approximately)
/*!40000 ALTER TABLE `history` DISABLE KEYS */;
/*!40000 ALTER TABLE `history` ENABLE KEYS */;


-- Dumping structure for table lotto.settings
CREATE TABLE IF NOT EXISTS `settings` (
  `item` int(11) NOT NULL,
  `timer` bigint(20) NOT NULL,
  `comments` varchar(21844) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 MAX_ROWS=1;

-- Dumping data for table lotto.settings: ~1 rows (approximately)
/*!40000 ALTER TABLE `settings` DISABLE KEYS */;
REPLACE INTO `settings` (`item`, `timer`, `comments`) VALUES
	(44209, 604800000, 'item :\r\nthe item id for what they will win(custom currency)\r\n\r\ntimer :\r\n604800000 == 1 week\r\n86400000 == 1 day\r\n3600000 == 1 hour\r\n');
/*!40000 ALTER TABLE `settings` ENABLE KEYS */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
