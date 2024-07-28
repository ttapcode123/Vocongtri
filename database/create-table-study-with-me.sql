DROP DATABASE IF EXISTS `study-with-me`;
CREATE DATABASE IF NOT EXISTS `study-with-me`;
USE `study-with-me`;

CREATE TABLE IF NOT EXISTS `user` (
	`id` BIGINT AUTO_INCREMENT,
	`username` VARCHAR(255) NOT NULL UNIQUE,
	`password` VARCHAR(255) NOT NULL,
	`role` ENUM("ADMIN", "USER") DEFAULT 'USER',
	`email` VARCHAR(255) NOT NULL UNIQUE,
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE") DEFAULT 'ACTIVE',
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `user_info` (
	`id` BIGINT AUTO_INCREMENT,
	`phone` VARCHAR(255) UNIQUE,
	`address` TEXT,
	`fullName` VARCHAR(255),
	`birthDate` DATE,
	`sex` ENUM("MALE", "FEMALE", "OTHER"),
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`avatar` VARCHAR(255),
	`userId` BIGINT UNIQUE,
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `category` (
	`id` BIGINT AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL UNIQUE,
	`description` TEXT,
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE") DEFAULT 'ACTIVE',
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `posts` (
	`id` BIGINT AUTO_INCREMENT,
	`title` VARCHAR(255) NOT NULL,
	`content` LONGTEXT NOT NULL,
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE", "DRAFT") DEFAULT 'ACTIVE',
	`banner` VARCHAR(255),
	`categoryId` BIGINT,
	`numberAccess` BIGINT DEFAULT 0,
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `comment` (
	`id` BIGINT AUTO_INCREMENT,
	`name` VARCHAR(255) NOT NULL,
	`email` VARCHAR(255) NOT NULL,
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE") DEFAULT 'ACTIVE',
	`website` VARCHAR(255),
	`postId` BIGINT,
	`message` TEXT,
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `web_setting` (
	`id` BIGINT AUTO_INCREMENT,
	`content` LONGTEXT NOT NULL,
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE") DEFAULT 'ACTIVE',
	`type` VARCHAR(50),
	`image` VARCHAR(255),
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `ads` (
	`id` BIGINT AUTO_INCREMENT,
	`images` VARCHAR(255),
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE") DEFAULT 'ACTIVE',
	`width` INT,
	`height` INT,
	`position` VARCHAR(255),
	`url` VARCHAR(255),
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `messages` (
	`id` BIGINT AUTO_INCREMENT,
	`subject` VARCHAR(255) NOT NULL,
	`email` VARCHAR(255) NOT NULL,
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`createdBy` VARCHAR(255) DEFAULT NULL,
	`updatedBy` VARCHAR(255) DEFAULT NULL,
	`status` ENUM("ACTIVE", "IN_ACTIVE") DEFAULT 'ACTIVE',
	`message` TEXT,
	PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `history` (
	`id` BIGINT AUTO_INCREMENT,
	`ipAddress` VARCHAR(255),
	`createdDate` DATETIME DEFAULT CURRENT_TIMESTAMP,
	`updatedDate` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	`type` VARCHAR(255),
	`mappingId` BIGINT,
	PRIMARY KEY(`id`)
);

ALTER TABLE `user_info`
ADD FOREIGN KEY(`userId`) REFERENCES `user`(`id`)
ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE `posts`
ADD FOREIGN KEY(`categoryId`) REFERENCES `category`(`id`)
ON UPDATE NO ACTION ON DELETE CASCADE;
ALTER TABLE `comment`
ADD FOREIGN KEY(`postId`) REFERENCES `posts`(`id`)
ON UPDATE NO ACTION ON DELETE CASCADE;