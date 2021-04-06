-- --------------------------------------------------------
-- Host:                         localhost
-- Versión del servidor:         10.5.4-MariaDB-log - mariadb.org binary distribution
-- SO del servidor:              Win64
-- HeidiSQL Versión:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Volcando estructura para tabla apzombies.users
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(40) NOT NULL,
  `characterId` int(20) DEFAULT 1,
  `unlockCharacters` int(11) DEFAULT 0,
  `isVip` int(11) DEFAULT 0,
  `tutorial` int(11) NOT NULL DEFAULT 0,
  `accounts` longtext DEFAULT NULL,
  `group` varchar(50) DEFAULT 'user',
  `inventory` longtext DEFAULT NULL,
  `job` varchar(20) DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT 0,
  `job2` varchar(20) DEFAULT 'unemployed',
  `job_grade2` int(11) unsigned NOT NULL DEFAULT 0,
  `loadout` longtext DEFAULT NULL,
  `position` varchar(255) DEFAULT '{"heading":204.0,"x":-539.2,"y":-214.5,"z":38.65}',
  `firstname` varchar(50) DEFAULT NULL,
  `lastname` varchar(50) DEFAULT NULL,
  `sex` char(50) DEFAULT 'f',
  `dob` varchar(50) DEFAULT NULL,
  `height` varchar(50) DEFAULT NULL,
  `job_invitation` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`identifier`,`id`) USING BTREE,
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

-- Volcando estructura para tabla apzombies.users_characters
CREATE TABLE IF NOT EXISTS `users_characters` (
  `characterId` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `isVip` int(11) NOT NULL DEFAULT 0,
  `inventory` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '{}',
  `accounts` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '{"bank":3000}',
  `job` varchar(20) NOT NULL DEFAULT 'unemployed',
  `job_grade` int(11) NOT NULL DEFAULT 0,
  `job2` varchar(20) NOT NULL DEFAULT 'unemployed',
  `job_grade2` int(11) NOT NULL DEFAULT 0,
  `loadout` longtext DEFAULT NULL,
  `position` varchar(255) DEFAULT '{"heading":204.0,"x":-539.2,"y":-214.5,"z":38.65}',
  `firstname` varchar(50) NOT NULL,
  `lastname` varchar(50) NOT NULL,
  `sex` char(50) NOT NULL DEFAULT 'f',
  `dob` varchar(50) NOT NULL,
  `height` varchar(50) NOT NULL,
  `job_invitation` varchar(255) DEFAULT NULL,
  `phone_number` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`characterId`),
  KEY `charid` (`characterId`) USING BTREE,
  KEY `identifier` (`identifier`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;

-- La exportación de datos fue deseleccionada.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
