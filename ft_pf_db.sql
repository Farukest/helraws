/*
Navicat MySQL Data Transfer

Source Server         : Remote - Mysql
Source Server Version : 80030
Source Host           : 38.242.131.224:3306
Source Database       : ft_pf_db

Target Server Type    : MYSQL
Target Server Version : 80030
File Encoding         : 65001

Date: 2022-10-10 05:45:09
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for cities
-- ----------------------------
DROP TABLE IF EXISTS `cities`;
CREATE TABLE `cities` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL DEFAULT '',
  `ServerIP` text NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `a` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for devices
-- ----------------------------
DROP TABLE IF EXISTS `devices`;
CREATE TABLE `devices` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) DEFAULT NULL,
  `PublicIP` varchar(255) DEFAULT NULL,
  `Link` varchar(255) DEFAULT NULL,
  `Brand` varchar(255) DEFAULT NULL,
  `LocalIP` varchar(255) DEFAULT NULL,
  `Active` bit(1) DEFAULT b'1',
  `UdpStatus` bit(1) DEFAULT b'1',
  `LastPortTransferDate` datetime DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `LastSignalTimeDate` datetime DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP,
  `BlockGap` int DEFAULT NULL,
  `CityID` int DEFAULT NULL,
  `CityName` varchar(255) DEFAULT NULL,
  `DefaultPfStatus` bit(1) DEFAULT b'1',
  `Note` text,
  `ModemIP` varchar(255) DEFAULT '',
  `ListenPort` int DEFAULT NULL,
  `SendPort` int DEFAULT NULL,
  `UserID` int DEFAULT NULL,
  `UserName` varchar(255) DEFAULT NULL,
  `SshPort` int DEFAULT NULL,
  `IsWifi` bit(1) DEFAULT b'0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `Id` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL DEFAULT '',
  `Role` int NOT NULL,
  `TelegramTag` varchar(255) NOT NULL,
  PRIMARY KEY (`Id`),
  UNIQUE KEY `a` (`Name`)
) ENGINE=InnoDB AUTO_INCREMENT=50 DEFAULT CHARSET=utf8mb3;
SET FOREIGN_KEY_CHECKS=1;
