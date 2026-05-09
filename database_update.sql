-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : sam. 09 mai 2026 à 22:19
-- Version du serveur : 8.0.31
-- Version de PHP : 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

START TRANSACTION;

SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */
;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */
;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */
;
/*!40101 SET NAMES utf8mb4 */
;

--
-- Base de données : `projet_annuel`
--

-- --------------------------------------------------------

--
-- Structure de la table `admin`
--

DROP TABLE IF EXISTS `admin`;

CREATE TABLE IF NOT EXISTS `admin` (
    `Id_USER` int NOT NULL,
    `Role_Level` varchar(50) DEFAULT NULL,
    PRIMARY KEY (`Id_USER`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- Déchargement des données de la table `admin`
--

INSERT INTO
    `admin` (`Id_USER`, `Role_Level`)
VALUES (9, '2'),
    (20, NULL),
    (21, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `advice`
--

DROP TABLE IF EXISTS `advice`;

CREATE TABLE IF NOT EXISTS `advice` (
    `Id_ADVICE` int NOT NULL AUTO_INCREMENT,
    `Title` varchar(150) NOT NULL,
    `Excerpt` varchar(255) NOT NULL,
    `Content` text NOT NULL,
    `Created_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Updated_At` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `Created_By` int NOT NULL,
    PRIMARY KEY (`Id_ADVICE`),
    KEY `Created_By` (`Created_By`)
) ENGINE = MyISAM AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `advice`
--

INSERT INTO
    `advice` (
        `Id_ADVICE`,
        `Title`,
        `Excerpt`,
        `Content`,
        `Created_At`,
        `Updated_At`,
        `Created_By`
    )
VALUES (
        1,
        'Test',
        'C\'est pour le test',
        'OUIOUO',
        '2026-05-08 02:50:33',
        '2026-05-08 03:03:42',
        20
    );

-- --------------------------------------------------------

--
-- Structure de la table `animates`
--

DROP TABLE IF EXISTS `animates`;

CREATE TABLE IF NOT EXISTS `animates` (
    `Id_USER` int NOT NULL,
    `Id_EVENT` int NOT NULL,
    PRIMARY KEY (`Id_USER`, `Id_EVENT`),
    KEY `Id_EVENT` (`Id_EVENT`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `cart_item`
--

DROP TABLE IF EXISTS `cart_item`;

CREATE TABLE IF NOT EXISTS `cart_item` (
    `Id_USER` int NOT NULL,
    `Id_PRODUCT` int NOT NULL,
    `Qty` int NOT NULL DEFAULT '1',
    `Created_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Updated_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id_USER`, `Id_PRODUCT`),
    KEY `fk_cart_product` (`Id_PRODUCT`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `category`
--

DROP TABLE IF EXISTS `category`;

CREATE TABLE IF NOT EXISTS `category` (
    `Id_CATEGORY` int NOT NULL AUTO_INCREMENT,
    `Name` varchar(50) NOT NULL,
    PRIMARY KEY (`Id_CATEGORY`),
    UNIQUE KEY `Name` (`Name`)
) ENGINE = InnoDB AUTO_INCREMENT = 5 DEFAULT CHARSET = utf8mb3;

--
-- Déchargement des données de la table `category`
--

INSERT INTO
    `category` (`Id_CATEGORY`, `Name`)
VALUES (1, 'Bien-étre'),
    (4, 'Maison & Habitat'),
    (2, 'Santé'),
    (3, 'Services á domicile');

-- --------------------------------------------------------

--
-- Structure de la table `chat`
--

DROP TABLE IF EXISTS `chat`;

CREATE TABLE IF NOT EXISTS `chat` (
    `Id_CHAT` int NOT NULL AUTO_INCREMENT,
    `Content` text NOT NULL,
    `Send_date` datetime DEFAULT CURRENT_TIMESTAMP,
    `Is_read` tinyint(1) DEFAULT '0',
    `Id_USER` int NOT NULL,
    `Id_USER_1` int NOT NULL,
    PRIMARY KEY (`Id_CHAT`),
    KEY `Id_USER` (`Id_USER`),
    KEY `Id_USER_1` (`Id_USER_1`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `document`
--

DROP TABLE IF EXISTS `document`;

CREATE TABLE IF NOT EXISTS `document` (
    `Id_DOCUMENT` int NOT NULL AUTO_INCREMENT,
    `Upload_Date` datetime DEFAULT CURRENT_TIMESTAMP,
    `File_Path` varchar(250) DEFAULT NULL,
    `Type` varchar(50) DEFAULT NULL,
    `Id_USER` int NOT NULL,
    `Description` text,
    `Id_CATEGORY` int DEFAULT NULL,
    PRIMARY KEY (`Id_DOCUMENT`),
    KEY `Id_USER` (`Id_USER`),
    KEY `fk_document_category` (`Id_CATEGORY`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

-- --------------------------------------------------------

--
-- Structure de la table `event`
--

DROP TABLE IF EXISTS `event`;

CREATE TABLE IF NOT EXISTS `event` (
    `Id_EVENT` int NOT NULL AUTO_INCREMENT,
    `Title` varchar(50) DEFAULT NULL,
    `Location` varchar(100) DEFAULT NULL,
    `Description` text,
    `Event_Date` datetime DEFAULT NULL,
    `Max_Participants` int DEFAULT NULL,
    `Validation_Status` tinyint(1) DEFAULT '0',
    `Price_Cents` int DEFAULT '0',
    `Is_Paid` tinyint(1) DEFAULT '0',
    `Price` int NOT NULL DEFAULT '0',
    PRIMARY KEY (`Id_EVENT`)
) ENGINE = InnoDB AUTO_INCREMENT = 16 DEFAULT CHARSET = utf8mb3;

--
-- Déchargement des données de la table `event`
--

INSERT INTO
    `event` (
        `Id_EVENT`,
        `Title`,
        `Location`,
        `Description`,
        `Event_Date`,
        `Max_Participants`,
        `Validation_Status`,
        `Price_Cents`,
        `Is_Paid`,
        `Price`
    )
VALUES (
        14,
        'Oui',
        'oui',
        'Je te v le v',
        '2026-05-11 06:00:00',
        10,
        0,
        0,
        0,
        10
    ),
    (
        15,
        'zevpezpve',
        'pezkvezp',
        'lzekvnezvnzkv',
        '2026-05-12 12:00:00',
        20,
        0,
        0,
        0,
        0
    );

-- --------------------------------------------------------

--
-- Structure de la table `event_registration`
--

DROP TABLE IF EXISTS `event_registration`;

CREATE TABLE IF NOT EXISTS `event_registration` (
    `Id_EVENT` int NOT NULL,
    `Id_USER` int NOT NULL,
    `Created_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id_EVENT`, `Id_USER`),
    KEY `fk_eventreg_user` (`Id_USER`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `event_registration`
--

INSERT INTO
    `event_registration` (
        `Id_EVENT`,
        `Id_USER`,
        `Created_At`
    )
VALUES (11, 19, '2026-04-15 10:59:34'),
    (9, 19, '2026-04-14 18:47:58');

-- --------------------------------------------------------

--
-- Structure de la table `intervention`
--

DROP TABLE IF EXISTS `intervention`;

CREATE TABLE IF NOT EXISTS `intervention` (
    `Id_INTERVENTION` int NOT NULL AUTO_INCREMENT,
    `Date_Start` datetime DEFAULT NULL,
    `Date_End` datetime DEFAULT NULL,
    `Status` varchar(50) DEFAULT 'Pending',
    `Senior_Rating` decimal(2, 0) DEFAULT NULL,
    `Senior_Comment` text,
    `Id_INVOICE` int DEFAULT NULL,
    `Id_SERVICE_TYPE` int NOT NULL,
    `Id_PROVIDER` int DEFAULT NULL,
    `Id_SENIOR` int NOT NULL,
    `Admin_Approved` tinyint(1) NOT NULL DEFAULT '0',
    `Provider_Approved` tinyint(1) NOT NULL DEFAULT '0',
    `Created_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id_INTERVENTION`),
    KEY `Id_INVOICE` (`Id_INVOICE`),
    KEY `Id_SERVICE_TYPE` (`Id_SERVICE_TYPE`),
    KEY `Id_PROVIDER` (`Id_PROVIDER`),
    KEY `Id_SENIOR` (`Id_SENIOR`)
) ENGINE = InnoDB AUTO_INCREMENT = 58 DEFAULT CHARSET = utf8mb3;

--
-- Déchargement des données de la table `intervention`
--

INSERT INTO
    `intervention` (
        `Id_INTERVENTION`,
        `Date_Start`,
        `Date_End`,
        `Status`,
        `Senior_Rating`,
        `Senior_Comment`,
        `Id_INVOICE`,
        `Id_SERVICE_TYPE`,
        `Id_PROVIDER`,
        `Id_SENIOR`,
        `Admin_Approved`,
        `Provider_Approved`,
        `Created_At`
    )
VALUES (
        23,
        '2026-04-13 19:00:00',
        '2026-04-13 20:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        0,
        '2026-04-30 01:39:45'
    ),
    (
        24,
        '2026-04-13 18:00:00',
        '2026-04-13 19:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        0,
        '2026-04-30 01:39:45'
    ),
    (
        25,
        '2026-04-20 13:00:00',
        '2026-04-20 14:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        0,
        '2026-04-30 01:39:45'
    ),
    (
        26,
        '2026-04-20 17:00:00',
        '2026-04-20 18:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        0,
        '2026-04-30 01:39:45'
    ),
    (
        27,
        '2026-04-20 15:00:00',
        '2026-04-20 16:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        0,
        '2026-04-30 01:39:45'
    ),
    (
        28,
        '2026-04-20 14:00:00',
        '2026-04-20 15:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        0,
        '2026-04-30 01:39:45'
    ),
    (
        29,
        '2026-04-20 15:00:00',
        '2026-04-20 16:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        0,
        '2026-04-30 01:39:45'
    ),
    (
        30,
        '2026-04-20 17:00:00',
        '2026-04-20 18:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        31,
        '2026-04-20 15:00:00',
        '2026-04-20 16:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        32,
        '2026-04-20 15:00:00',
        '2026-04-20 16:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        33,
        '2026-04-20 15:00:00',
        '2026-04-20 16:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        34,
        '2026-04-20 15:00:00',
        '2026-04-20 16:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        35,
        '2026-04-20 12:00:00',
        '2026-04-20 13:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        36,
        '2026-04-20 15:00:00',
        '2026-04-20 16:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        1,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        37,
        '2026-04-20 14:00:00',
        '2026-04-20 15:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        1,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        38,
        '2026-04-20 15:00:00',
        '2026-04-20 16:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        39,
        '2026-04-20 16:00:00',
        '2026-04-20 17:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        40,
        '2026-04-20 15:00:00',
        '2026-04-20 16:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        41,
        '2026-04-20 15:00:00',
        '2026-04-20 16:00:00',
        'Accepted',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        1,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        42,
        '2026-04-27 15:00:00',
        '2026-04-27 16:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        3,
        23,
        19,
        0,
        0,
        '2026-04-30 01:39:45'
    ),
    (
        43,
        '2026-04-27 15:00:00',
        '2026-04-27 16:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        5,
        23,
        19,
        0,
        1,
        '2026-04-30 01:39:45'
    ),
    (
        45,
        '2026-04-07 10:00:00',
        '2026-04-07 12:00:00',
        'Accepted',
        NULL,
        'Séance de coaching réalisée chez moi.',
        NULL,
        3,
        24,
        8,
        1,
        1,
        '2026-05-07 19:30:54'
    ),
    (
        46,
        '2026-04-30 14:00:00',
        '2026-04-30 16:00:00',
        'Accepted',
        NULL,
        'Bonne séance, à refaire.',
        NULL,
        3,
        24,
        8,
        1,
        1,
        '2026-05-07 19:30:54'
    ),
    (
        47,
        '2026-04-15 09:00:00',
        '2026-04-15 11:00:00',
        'Canceled',
        NULL,
        'Annulée par mes soins, désolé.',
        NULL,
        3,
        24,
        8,
        1,
        1,
        '2026-05-07 19:30:54'
    ),
    (
        48,
        '2026-05-08 15:00:00',
        '2026-05-08 17:00:00',
        'Accepted',
        NULL,
        'Pensez à apporter les haltères légers.',
        NULL,
        3,
        24,
        8,
        1,
        1,
        '2026-05-07 19:30:54'
    ),
    (
        49,
        '2026-05-14 10:00:00',
        '2026-05-14 12:00:00',
        'Accepted',
        NULL,
        'Premier RDV, sonner au 2e étage.',
        NULL,
        3,
        24,
        8,
        1,
        1,
        '2026-05-07 19:30:54'
    ),
    (
        50,
        '2026-05-18 10:00:00',
        '2026-05-18 11:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        2,
        24,
        19,
        0,
        0,
        '2026-05-07 20:30:04'
    ),
    (
        51,
        '2026-06-22 10:00:00',
        '2026-06-22 11:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        2,
        24,
        19,
        0,
        0,
        '2026-05-08 00:01:46'
    ),
    (
        52,
        '2026-05-18 10:00:00',
        '2026-05-18 11:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        2,
        24,
        19,
        0,
        0,
        '2026-05-08 00:14:56'
    ),
    (
        53,
        '2026-05-25 10:00:00',
        '2026-05-25 11:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        2,
        24,
        19,
        0,
        0,
        '2026-05-08 00:15:29'
    ),
    (
        54,
        '2026-05-18 10:00:00',
        '2026-05-18 11:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        2,
        24,
        19,
        0,
        1,
        '2026-05-08 04:30:09'
    ),
    (
        55,
        '2026-05-25 10:00:00',
        '2026-05-25 11:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        2,
        24,
        19,
        0,
        1,
        '2026-05-08 05:01:14'
    ),
    (
        56,
        '2026-05-18 10:00:00',
        '2026-05-18 11:00:00',
        'Canceled',
        NULL,
        '',
        NULL,
        2,
        24,
        19,
        0,
        1,
        '2026-05-08 17:57:14'
    ),
    (
        57,
        '2026-05-18 10:00:00',
        '2026-05-18 11:00:00',
        'Pending',
        NULL,
        '',
        NULL,
        2,
        24,
        19,
        0,
        1,
        '2026-05-08 18:07:34'
    );

-- --------------------------------------------------------

--
-- Structure de la table `invoice`
--

DROP TABLE IF EXISTS `invoice`;

CREATE TABLE IF NOT EXISTS `invoice` (
    `Id_INVOICE` int NOT NULL AUTO_INCREMENT,
    `Date_Generated` datetime DEFAULT CURRENT_TIMESTAMP,
    `PDF_Url` varchar(250) DEFAULT NULL,
    `Total_Amount` decimal(10, 2) DEFAULT NULL,
    `Is_Paid` tinyint(1) DEFAULT '0',
    PRIMARY KEY (`Id_INVOICE`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

-- --------------------------------------------------------

--
-- Structure de la table `medical_appointment`
--

DROP TABLE IF EXISTS `medical_appointment`;

CREATE TABLE IF NOT EXISTS `medical_appointment` (
    `Id_MEDICAL` int NOT NULL AUTO_INCREMENT,
    `Id_USER` int NOT NULL,
    `Start_At` datetime NOT NULL,
    `Doctor_Name` varchar(120) NOT NULL,
    `Location` varchar(160) NOT NULL,
    `Details` text,
    `Created_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id_MEDICAL`),
    KEY `Id_USER` (`Id_USER`)
) ENGINE = MyISAM AUTO_INCREMENT = 8 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `medical_appointment`
--

INSERT INTO
    `medical_appointment` (
        `Id_MEDICAL`,
        `Id_USER`,
        `Start_At`,
        `Doctor_Name`,
        `Location`,
        `Details`,
        `Created_At`
    )
VALUES (
        7,
        19,
        '2026-05-28 18:00:00',
        'Cabinet Dentaire Paris',
        '2, 92110 clichy',
        '',
        '2026-05-08 04:56:49'
    ),
    (
        6,
        19,
        '2026-05-29 20:00:00',
        'Cabinet Dentaire Paris',
        '2, 92110 clichy',
        '',
        '2026-05-08 04:55:56'
    );

-- --------------------------------------------------------

--
-- Structure de la table `message`
--

DROP TABLE IF EXISTS `message`;

CREATE TABLE IF NOT EXISTS `message` (
    `Id_MESSAGE` int NOT NULL AUTO_INCREMENT,
    `Id_SENDER` int NOT NULL,
    `Id_RECEIVER` int NOT NULL,
    `Content` text NOT NULL,
    `Is_Read` tinyint(1) NOT NULL DEFAULT '0',
    `Created_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id_MESSAGE`),
    KEY `Id_SENDER` (`Id_SENDER`),
    KEY `Id_RECEIVER` (`Id_RECEIVER`)
) ENGINE = MyISAM AUTO_INCREMENT = 36 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `message`
--

INSERT INTO
    `message` (
        `Id_MESSAGE`,
        `Id_SENDER`,
        `Id_RECEIVER`,
        `Content`,
        `Is_Read`,
        `Created_At`
    )
VALUES (
        1,
        19,
        23,
        'Nouvelle réservation de Un senior pour Coaching Sportif — testt le 20/04/2026 à 14h00.',
        1,
        '2026-04-14 16:36:40'
    ),
    (
        2,
        23,
        19,
        'Votre réservation a été acceptée par le prestataire.',
        1,
        '2026-04-14 16:38:01'
    ),
    (
        3,
        1,
        19,
        'Votre réservation a été confirmée par l\'administration.',
        1,
        '2026-04-14 16:52:42'
    ),
    (
        4,
        19,
        23,
        'Nouvelle réservation de Un senior pour Coaching Sportif — testt le 20/04/2026 à 15h00.',
        1,
        '2026-04-14 17:00:17'
    ),
    (
        5,
        23,
        19,
        'Votre réservation a été acceptée par le prestataire.',
        1,
        '2026-04-14 17:00:39'
    ),
    (
        6,
        1,
        19,
        'Votre réservation a été confirmée par l\'administration.',
        1,
        '2026-04-14 17:01:34'
    ),
    (
        7,
        19,
        23,
        'Nouvelle réservation de Un senior pour Coaching Sportif — testt le 20/04/2026 à 16h00.',
        1,
        '2026-04-14 17:36:18'
    ),
    (
        8,
        23,
        19,
        'Votre réservation a été acceptée par le prestataire.',
        1,
        '2026-04-14 17:36:52'
    ),
    (
        9,
        1,
        19,
        'Votre réservation a été confirmée par l\'administration.',
        1,
        '2026-04-14 17:37:27'
    ),
    (
        10,
        1,
        19,
        'Votre réservation a été annulée par l\'administration.',
        1,
        '2026-04-14 17:43:51'
    ),
    (
        11,
        1,
        19,
        'Votre réservation a été annulée par l\'administration.',
        1,
        '2026-04-14 17:43:53'
    ),
    (
        12,
        19,
        23,
        'Nouvelle réservation de Un senior pour Coaching Sportif — testt le 20/04/2026 à 15h00.',
        1,
        '2026-04-14 17:44:07'
    ),
    (
        13,
        23,
        19,
        'Votre réservation a été acceptée par le prestataire.',
        1,
        '2026-04-14 17:44:20'
    ),
    (
        14,
        1,
        19,
        'Votre réservation a été confirmée par l\'administration.',
        1,
        '2026-04-14 17:44:30'
    ),
    (
        15,
        1,
        19,
        'Votre réservation a été annulée par l\'administration.',
        1,
        '2026-04-14 18:23:24'
    ),
    (
        16,
        19,
        23,
        'Nouvelle réservation de Un senior pour Coaching Sportif — testt le 20/04/2026 à 15h00.',
        1,
        '2026-04-14 18:23:45'
    ),
    (
        17,
        23,
        19,
        'Votre réservation a été acceptée par le prestataire.',
        1,
        '2026-04-14 19:49:18'
    ),
    (
        18,
        1,
        19,
        'Votre réservation a été confirmée par l\'administration.',
        1,
        '2026-04-15 11:19:17'
    ),
    (
        19,
        23,
        19,
        'oui',
        1,
        '2026-04-15 16:43:31'
    ),
    (
        20,
        19,
        23,
        'Nouvelle réservation de Un senior pour Coaching Sportif — testt le 27/04/2026 à 15h00.',
        0,
        '2026-04-21 00:47:50'
    ),
    (
        21,
        19,
        23,
        'Nouvelle réservation de Un senior pour Yoga Seniors — testt le 27/04/2026 à 15h00.',
        0,
        '2026-04-21 16:30:35'
    ),
    (
        22,
        23,
        19,
        'Votre réservation a été acceptée par le prestataire.',
        1,
        '2026-04-21 16:43:35'
    ),
    (
        23,
        19,
        24,
        'Nouvelle réservation de Un senior pour Jardinage — ouais le 18/05/2026 à 10h00.',
        0,
        '2026-05-07 20:30:04'
    ),
    (
        24,
        19,
        4,
        'aloo',
        0,
        '2026-05-07 20:44:54'
    ),
    (
        25,
        19,
        24,
        'Nouvelle réservation de Un senior pour Jardinage — ouais le 22/06/2026 à 10h00.',
        0,
        '2026-05-08 00:01:46'
    ),
    (
        26,
        19,
        24,
        'Nouvelle réservation de Un senior pour Jardinage — ouais le 18/05/2026 à 10h00.',
        0,
        '2026-05-08 00:14:56'
    ),
    (
        27,
        19,
        24,
        'Nouvelle réservation de Un senior pour Jardinage — ouais le 25/05/2026 à 10h00.',
        0,
        '2026-05-08 00:15:29'
    ),
    (
        28,
        19,
        24,
        'Nouvelle réservation de Un senior pour Jardinage — ouais le 18/05/2026 à 10h00.',
        0,
        '2026-05-08 04:30:09'
    ),
    (
        29,
        19,
        24,
        'Nouvelle réservation de Un senior pour Jardinage — ouais le 25/05/2026 à 10h00.',
        0,
        '2026-05-08 05:01:14'
    ),
    (
        30,
        24,
        19,
        'Votre réservation a été acceptée par le prestataire.',
        1,
        '2026-05-08 05:01:46'
    ),
    (
        31,
        24,
        19,
        'Votre réservation a été acceptée par le prestataire.',
        1,
        '2026-05-08 05:01:48'
    ),
    (
        32,
        19,
        24,
        'Nouvelle réservation de Un senior pour Jardinage — ouais le 18/05/2026 à 10h00.',
        0,
        '2026-05-08 17:57:14'
    ),
    (
        33,
        24,
        19,
        'Votre réservation a été acceptée par le prestataire.',
        0,
        '2026-05-08 17:57:31'
    ),
    (
        34,
        19,
        24,
        'Nouvelle réservation de Un senior pour Jardinage — ouais le 18/05/2026 à 10h00.',
        0,
        '2026-05-08 18:07:34'
    ),
    (
        35,
        24,
        19,
        'Votre réservation a été acceptée par le prestataire.',
        0,
        '2026-05-08 18:07:52'
    );

-- --------------------------------------------------------

--
-- Structure de la table `participate`
--

DROP TABLE IF EXISTS `participate`;

CREATE TABLE IF NOT EXISTS `participate` (
    `Id_USER` int NOT NULL,
    `Id_EVENT` int NOT NULL,
    `Registration_Date` datetime DEFAULT CURRENT_TIMESTAMP,
    `Has_Attended` tinyint(1) DEFAULT '0',
    PRIMARY KEY (`Id_USER`, `Id_EVENT`),
    KEY `Id_EVENT` (`Id_EVENT`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

-- --------------------------------------------------------

--
-- Structure de la table `payment`
--

DROP TABLE IF EXISTS `payment`;

CREATE TABLE IF NOT EXISTS `payment` (
    `Id_PAYMENT` int NOT NULL AUTO_INCREMENT,
    `Id_USER` int NOT NULL,
    `Stripe_Payment_Intent_ID` varchar(100) DEFAULT NULL,
    `Amount_Cents` int NOT NULL,
    `Currency` varchar(10) DEFAULT 'eur',
    `Type` enum(
        'subscription',
        'shop',
        'event'
    ) NOT NULL,
    `Ref_ID` int DEFAULT NULL,
    `Status` enum(
        'pending',
        'paid',
        'failed',
        'refunded'
    ) DEFAULT 'pending',
    `Created_At` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id_PAYMENT`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `personal_task`
--

DROP TABLE IF EXISTS `personal_task`;

CREATE TABLE IF NOT EXISTS `personal_task` (
    `Id_PERSONAL_TASK` int NOT NULL AUTO_INCREMENT,
    `Title` varchar(50) NOT NULL,
    `Start_DateTime` datetime NOT NULL,
    `End_DateTime` datetime NOT NULL,
    `Id_USER` int NOT NULL,
    PRIMARY KEY (`Id_PERSONAL_TASK`),
    KEY `Id_USER` (`Id_USER`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `planning_item`
--

DROP TABLE IF EXISTS `planning_item`;

CREATE TABLE IF NOT EXISTS `planning_item` (
    `Id_ITEM` int NOT NULL AUTO_INCREMENT,
    `Id_USER` int NOT NULL,
    `Item_Type` varchar(20) NOT NULL,
    `Ref_ID` int NOT NULL,
    `Title` varchar(120) NOT NULL,
    `Start_At` datetime NOT NULL,
    `Location` varchar(120) NOT NULL,
    `Details` text,
    `Created_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id_ITEM`),
    UNIQUE KEY `uniq_user_item` (
        `Id_USER`,
        `Item_Type`,
        `Ref_ID`
    )
) ENGINE = MyISAM AUTO_INCREMENT = 78 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `planning_item`
--

INSERT INTO
    `planning_item` (
        `Id_ITEM`,
        `Id_USER`,
        `Item_Type`,
        `Ref_ID`,
        `Title`,
        `Start_At`,
        `Location`,
        `Details`,
        `Created_At`
    )
VALUES (
        72,
        19,
        'medical',
        7,
        'RDV médical — Cabinet Dentaire Paris',
        '2026-05-28 18:00:00',
        '2, 92110 clichy',
        '',
        '2026-05-08 04:56:49'
    ),
    (
        75,
        19,
        'service',
        57,
        'Jardinage — ouais',
        '2026-05-18 10:00:00',
        'À domicile',
        '',
        '2026-05-08 18:07:34'
    ),
    (
        71,
        19,
        'medical',
        6,
        'RDV médical — Cabinet Dentaire Paris',
        '2026-05-29 20:00:00',
        '2, 92110 clichy',
        '',
        '2026-05-08 04:55:56'
    );

-- --------------------------------------------------------

--
-- Structure de la table `practices`
--

DROP TABLE IF EXISTS `practices`;

CREATE TABLE IF NOT EXISTS `practices` (
    `Id_USER` int NOT NULL,
    `Id_CATEGORY` int NOT NULL,
    PRIMARY KEY (`Id_USER`, `Id_CATEGORY`),
    KEY `Id_CATEGORY` (`Id_CATEGORY`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `product`
--

DROP TABLE IF EXISTS `product`;

CREATE TABLE IF NOT EXISTS `product` (
    `Id_PRODUCT` int NOT NULL AUTO_INCREMENT,
    `Name` varchar(120) NOT NULL,
    `Category` varchar(60) DEFAULT NULL,
    `Price` decimal(10, 2) NOT NULL,
    `link_img` varchar(255) DEFAULT NULL,
    PRIMARY KEY (`Id_PRODUCT`)
) ENGINE = MyISAM AUTO_INCREMENT = 4 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `product`
--

INSERT INTO
    `product` (
        `Id_PRODUCT`,
        `Name`,
        `Category`,
        `Price`,
        `link_img`
    )
VALUES (
        1,
        'Coussin lombaire',
        'Confort',
        '29.90',
        NULL
    ),
    (
        2,
        'Pilulier hebdo',
        'Santé',
        '12.50',
        NULL
    ),
    (
        3,
        'Loupe LED',
        'Accessibilité',
        '19.90',
        NULL
    );

-- --------------------------------------------------------

--
-- Structure de la table `provider`
--

DROP TABLE IF EXISTS `provider`;

CREATE TABLE IF NOT EXISTS `provider` (
    `Id_USER` int NOT NULL,
    `Company_Name` varchar(50) NOT NULL,
    `SIRET_Number` varchar(50) DEFAULT NULL,
    `IBAN` varchar(34) DEFAULT NULL,
    `Provider_Description` text,
    `Validation_Status` tinyint(1) DEFAULT '0',
    `Commission_Rate` decimal(5, 2) DEFAULT '1.00',
    PRIMARY KEY (`Id_USER`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- Déchargement des données de la table `provider`
--

INSERT INTO
    `provider` (
        `Id_USER`,
        `Company_Name`,
        `SIRET_Number`,
        `IBAN`,
        `Provider_Description`,
        `Validation_Status`,
        `Commission_Rate`
    )
VALUES (
        1,
        'Jean Nettoyage Express',
        '12345678901234',
        NULL,
        NULL,
        1,
        '1.00'
    ),
    (
        2,
        'Marc Fitness Pro',
        '98765432109876',
        NULL,
        NULL,
        1,
        '1.00'
    ),
    (
        3,
        'Sophie Détente',
        '11111111111111',
        NULL,
        NULL,
        1,
        '1.00'
    ),
    (
        4,
        'Lucas Yoga Zen',
        '22222222222222',
        NULL,
        NULL,
        1,
        '1.00'
    ),
    (
        5,
        'Emma Esprit Clair',
        '55555555555555',
        NULL,
        NULL,
        1,
        '1.00'
    ),
    (
        6,
        'Cabinet Dentaire Paris',
        '44444444444444',
        NULL,
        NULL,
        1,
        '1.00'
    ),
    (
        7,
        'Cabinet Dr Smith',
        '33333333333333',
        NULL,
        NULL,
        1,
        '1.00'
    ),
    (
        10,
        'Mat la classe',
        '12345678901234',
        NULL,
        NULL,
        1,
        '1.00'
    ),
    (
        11,
        'JCPAS',
        '12345678901234',
        NULL,
        NULL,
        1,
        '1.00'
    ),
    (
        23,
        'testt',
        'IUHIUEZOIVZEOI',
        NULL,
        NULL,
        1,
        '1.00'
    ),
    (
        24,
        'ouais',
        '121212121212121',
        NULL,
        NULL,
        1,
        '1.00'
    );

-- --------------------------------------------------------

--
-- Structure de la table `provider_absence`
--

DROP TABLE IF EXISTS `provider_absence`;

CREATE TABLE IF NOT EXISTS `provider_absence` (
    `Id_PROVIDER_ABSENCE` int NOT NULL AUTO_INCREMENT,
    `Start_DateTime` datetime NOT NULL,
    `End_DateTime` datetime NOT NULL,
    `Id_USER` int NOT NULL,
    PRIMARY KEY (`Id_PROVIDER_ABSENCE`),
    KEY `Id_USER` (`Id_USER`)
) ENGINE = MyISAM AUTO_INCREMENT = 4 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `provider_absence`
--

INSERT INTO
    `provider_absence` (
        `Id_PROVIDER_ABSENCE`,
        `Start_DateTime`,
        `End_DateTime`,
        `Id_USER`
    )
VALUES (
        3,
        '2026-05-11 10:00:00',
        '2026-05-12 12:00:00',
        24
    );

-- --------------------------------------------------------

--
-- Structure de la table `provider_authorized_service_type`
--

DROP TABLE IF EXISTS `provider_authorized_service_type`;

CREATE TABLE IF NOT EXISTS `provider_authorized_service_type` (
    `Id_USER` int NOT NULL,
    `Id_SERVICE_TYPE` int NOT NULL,
    PRIMARY KEY (`Id_USER`, `Id_SERVICE_TYPE`),
    KEY `Id_SERVICE_TYPE` (`Id_SERVICE_TYPE`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `provider_authorized_service_type`
--

INSERT INTO
    `provider_authorized_service_type` (`Id_USER`, `Id_SERVICE_TYPE`)
VALUES (24, 2);

-- --------------------------------------------------------

--
-- Structure de la table `provider_document`
--

DROP TABLE IF EXISTS `provider_document`;

CREATE TABLE IF NOT EXISTS `provider_document` (
    `Id_DOCUMENT` int NOT NULL AUTO_INCREMENT,
    `Id_USER` int NOT NULL,
    `File_Data` longblob NOT NULL,
    `Original_Filename` varchar(255) NOT NULL,
    `File_Size` int NOT NULL,
    `Uploaded_At` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id_DOCUMENT`),
    KEY `idx_user_uploaded` (`Id_USER`, `Uploaded_At`)
) ENGINE = MyISAM AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `provider_document`
--

INSERT INTO
    `provider_document` (
        `Id_DOCUMENT`,
        `Id_USER`,
        `File_Data`,
        `Original_Filename`,
        `File_Size`,
        `Uploaded_At`
    )
VALUES (
        1,
        24,
        0x255044462d312e370d0a25b5b5b5b50d0a312030206f626a0d0a3c3c2f547970652f436174616c6f672f50616765732032203020522f4c616e6728667229202f53747275637454726565526f6f74203737203020522f4d61726b496e666f3c3c2f4d61726b656420747275653e3e2f4d657461646174612031363930203020522f566965776572507265666572656e6365732031363931203020523e3e0d0a656e646f626a0d0a322030206f626a0d0a3c3c2f547970652f50616765732f436f756e742032322f4b6964735b2033203020522032332030205220323720302052203331203020522033332030205220333520302052203337203020522033392030205220343120302052203433203020522034352030205220343720302052203439203020522035312030205220353320302052203535203020522035372030205220353920302052203631203020522036382030205220373220302052203734203020525d203e3e0d0a656e646f626a0d0a332030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f46322039203020522f4633203131203020522f4634203136203020522f4635203138203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e74732034203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e747320303e3e0d0a656e646f626a0d0a342030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820333639383e3e0d0a73747265616d0d0a789ccd5c6d6fdb4612fe6ec0ff81d72b6031a857dc37be04bd024d9af67268ee9a4b0ef7c12d5046966db516e5e8c5d7fedb7ebbfa7ec5cdcc922b52bbb2a9981bb4685d915a72666767669f79598dbf5cae6717e5641d7dfef9f8cbf5ba9c5c4dcfa3b3f1b3c57abd98ff307efbebcd74fc5d7939abcaf56c518ddf6cdeadf1d6d78bc57abafce28be8d957cfa3f7c747094bf09f3ccf789444bad04c8a28579c15225a4e8f8ffefd24aa8e8f9ebd3d3e1a7fcd239e309d466f2f8e8f707412f1284b582e542473a6a2b77318f5cd9b2cba5cc18ba34bbacaebab6f8e8fce4651fc43f4f66fc7472fe07daf8f8f7ad3376345a1989691d44ce451ca641a71cef2bc35aed7a0fd93699e6d264373a859e70eeb8fa12413905be1a7e40ae935fd1bbd78f53c8ac66f6eca0a17fdd5f3975f45c9f8dbb2ba8c4617cbd3afff197fd8b28a882b9628dfb2663a6349bac361042fd77916bd9d9c8d5e7ee88a1ad2d2433ae72c537b489f7d9e24cff8178f21e99b6d91dc43f28395f61e7a6abf74cf46dfc5d96879179fead12ae67c348d4fe5a88af3d1ba8cd3111a7314cbd1d3c199e28564b9ee2904faca2a8962591e712159022f46b248efe2895f65f9002aabf67ba24c49968a9a7f1feb3e9e44609e2447d1b478fa072c21ac23acecf5092c6d19c19fdbcd67b0f270538daea7314fcdc7d555ac400760e035fca15b78b55ac7bca8079fc4a76234abd6f0343ca7474b7c2fec0d702160483a3ac71b537a3c1d4df099455c8ce6f3120754e7f538b87d630636ef98c73ca1e7d6c003fe5756f5058ddef75a7c6a53cd60d87b98d6660a1f96f0819e296f91183e440fecceb68ab91c2d7ec517971be4833d4acf7d6ba2c0dab56f4d7ae8890cac273c67b2cdd2ab72b68af5233d908f60e381ba04c9b3f39c3cfbe46470a23c11287267963bfa0c0b0fd72bd0a9196a03dddb806234da52823e5597a069e565a39f8f76d12e14800d3a295c5e67b5966a30835afb9737c02a386c9e997b77830b4e68c9b87499195e2f84062093b994c831944b94b759045c9993c619fd821fee502864d49b35caa27c77ddf80672141bbb985d9736bc85cb0c3621fda0b87c06ae021b78a299cedb3c3dbf2adf93bf9c365e7535bcdd71891bb44bfc0a89c22270bd5d26723837e0ae172bc3527dff043e3856884b7a49aa7139b5cb5bde4e8d2a343bd8143ead2230d85a8bd6c3ab2d3c9170cf0cc98318a5bc46decbe56c0df3bb430fc322f8f477dc3b71dbdaac9a05b8abf7385258239369ac690b5b542bb369d73b561a60b5944c592aef59ad5accef48982b64e42ac02e09309cfb74a68711e9b0469416821587f29406e6294f9848db3cfd0b150b205e46c644700ad58cac85ae4ad4c7f97c6b3777048a602b19de0100a62f7c4c8231a45b4c59b53d3458701775ae4e082e920ddf347b1f7d3d1dde9e956639f7301c60c75305e3998754cbd9adf01379115a39722a24027413c3db9e000517fae1d9fbf43c0bace76986e0f9309ef2c03c41fc597478fa0e83e7c506f7d53af0e085b14373f37661979116b41ef03f72fc3c35370d78a12f60b30373a82606ddd16e79caf34e5c45d717e57fc1c417550d93f05102b3a82668fcd502bf994fe93b6dd46ab38c0b4b07392aeb6faf674889fc45d5044838e8dcc66835d53d01dd67db99d34e56d1457abf32d70f04d8d5b28c09e159abceaed611ea2d4c69eb2987b7fc467d9440ceda5eb13a9fb991eb6ad3b92a6dcc6afd3b323d9ffd6ec3e769e33abb4b6940d57bc2c434f9addb9dc66967cadbe89e5610bd35451cc607d7641bbc82df6cda3aad46bfd9d76cf0d9198a99009e794b0eceebf4b1d1931781a78061328f687b788b22b0b710c5e1f9213e449ef53ea678ca8afb3dd816f0e9d115aef267cdfd89d9bf8d43f02bd153a36283e30a58e6c2c37d1f89864a038a0c9318519a28c6759ba93fff09747e8c727967fd5e350621b6e53ab821088d6cb8dcf41151e0aca42e38d30733153805a6b39ce59da8fddb29855c0f6d5b362d9a917bdd5418705ecc26e83daf2080e379cb2f1a770916f30ba6d46bdfc9ecd72faf31f14e1f2f4c1af2bc0bdb6d546cf67a1bea5e4f63134a5bff5fd92012edd8ee08feac496a92268d259b5c6937e74a62c01280ae3780bcde763a7b9589ce271629cca7559dc11d1ead6ab89579d6ad8f32054eb768f04fe260a60287af5a4ba6f9a14c0d11bfde53e8d3326392ef64829b1adf238b7c3eb279ce74ee923d1b9d8628b6f94905a8ebe52c4d7da45eda1a1e2138f2061890806fc20f77e4c7eaf21e3a942a3a3f81f8b31e1b5d83b5cf2e2baaefe0f5b9fd847e6ab2988361cff16525d238277c87df3e1d7e8ab2c858221f96a6d52b8dc3a5a088f6e1da60e0f0550bc950ab0fb3bdc0f1abe69c890e53af11c997b87b9c9be0501570a39ad6db0c5cb811c5a9ca792720c56bdc98403bf2d1bca4a85036cfb7f64a7beddb8fee62f35d03360bb9536e34fbda8ddd1ef707238589e84afacc47d79b59ac1b3e2f508fcb59acba81133cb2a2edd720b6258d6e72b2f8f2dbe972f8505583d62be12c4b740a2f962a259f380d405680a3f22843b0c05781bbeae2bf75b300843956170bc41fa6125c52fcb8c075aa56417004571033a61eaefa9868e0a051e59a1587322502078d2a933be8e6cd626681a2c95935e9072cd3e45b57d10484f8e5ca24321eb39cdabb9c9a81b1384c3ebe83c79fe1e698697045728d9d159ffe155c0db65cbc7a81f09982c027c3a76d938415d2c343800c31c49310e4baa4260148e5d816e4920a908ae78012b887d48fff01bdbd9ad908f0ca6aeffc67023c9d6cee8fc33396152ced2103af1708dcefa4d2e4f07042044e2d2895b18277a3785b5fddd96570552f164daed7d968da51efda22913afcdebea1c995e6a3c5326ec7ebdb70fa712d73fbfa3212ee996d9f25089c485180bcf9a15057840ac87992927f863840ef62aa44670654f100194a0e4f2887ee63e34c3fa9021b275d5201660534942b4d0000014861138d4b89b03dc1720a23a8906c6a0c9812133b0d825b13bd2d2da69c6192ea1d582c65cd5618ad9eeafae29ef1a6fda23d664538b5b2b5ecadddcf6fb65068d2d4d889a1563bcab6a9095fdb0e5a52206f6ed645ba104e44a588fb1f541bafb9864a5535e69a14b8f71fc85493aa9a56a7df3c1b32b30fdc00bec20c04ef623c4f8fa497b36c00ce7c58578804bbe61cce3c58d7cb571e4a6222458676f922afcb73414ef7ba8fe08a0118f476594ace328fe046e3ab058625f3e9d8b80f05f10bd830755f8e7bf4e9268124da9cdb70187e822e882a08931eecf150ec71855ec465af4f6fb308c654e6b75b80f5b0a657b3c9952db750eff8cfe7b811ec05f45ee66528e621f297be05ef235115caae811b8847644e07900e642af09e81cdb739df07f144088887d5e75db241109ec073421e5221109ec664984bea0dfa99cdbb1576b1fa4017d7a205bbf086cc5b1d42d47f84b9e055d35104e39fd2ff930687ed3e63bb8a564dd3913627380871757aa514afabe91378f0e7f7c8de62f86e5f2514cbb44738c337222a99603ad62545625245177b868186be7952e9daf68cee66eb1be6a64d435bb01cb2d4051e9368f1b6ed84425d23884dd5e82efcb6d8fdc6d6d4b7c5eb2ee2b665056ac0ba5e6325bf6c4a172182fa2433c73a7767d6c7b9866a336e9cab4a993a98a95045b506f64a8920ee01403e04cc0663044370e88549290b9912967267872965ca21531e72311f5e05b17daef09026c31f5bf77e3943e753a7b3f7e0cf41009c60c2c7cef0c7ae24d7846c1c52637007ef30d160cf5f8da9e20d5891a7e6eef07df33253d8d4f2e0c4bd5617aa6adc803fc10fcfefc9c07532096e2aeff8273a5ff3cc664f22bc7c814b4647239c96c63aed625ba8d5f6a8813955b67352a293f8b7dd559fa2317c3f425aed0a38ee32161b7d1f37fbcd6fdd434d48bfd9b6ea634cf6c5eddeebc1954d6aa60b8f0887af6748182aa487541bf46d3bd7868755124f38f81808305730973cf390fad01584812936b183b6f39c2918ca544e7f9244d9ee963e433453c20e41aca732679016054637f6355951b86fea35a8e12891e8ccef65fabe2135d366c8fd4cdbd7dcc7f4fd835a1c65860ef624a5beb798efe92ddd21aff79ff60c5ca1c7833cd9c1475043150c6b0c29f284ed8dcf65b012cc0ed98015188752b0028c43e92b7b42c87ad2cd4d89d9adcb9d5a246d84dd1e0da7a1cb8cb76d5ac619b7debeb1115613576d9f323f2e51d500b55532ddfe5e83af35ccfeda8369403671d9a9e91ed9cc91310a75039c0fd20a0f967d84b5537818d22514a2b0c3217a7f68465e1710b83c2fd28cc9434fd0aa50056b91e6acc822617e46a6c554b9bcc412dc19aa628290ee07349abf7c122b13617e12e0b806358cbbacf4914fa8dab9480ba6409194d8fe308f231fde96cff001a0c69488cbc1f03e5c820f978543aa5bb20ab1f01a51a23bc33e0b1f2aa32e2465a204401ca9f62dbc682f7c931db8aa0f9a8e4dce96b6951986d04f585ca77603c8101c6b5678d8ed23c3508933a172321e9e62ea7e8f0ca54f86a6e7b8b20d83a634053234ed66cb00025429e6b55d5efb083070e73c751c1e7a6c5285ca81d45096179cedd6b52d9455c1a0ec0ed98050d6a1140cca3a945ec02efb4b930a317d7633ccdbb452339ef61e3292c51a3bf92f56d1535bd7fdd6168f60cc1d22da324097a6c0f4f047581d91a5e8981d4ae458cb25d5cb264dabe3ef712b3dd56e5aaa86af8c499531ee1141806c95c660dba5f440ef55abefcac6164eef55deb47e796e0680e999ee636a5eff162a9d5a43629ee52cfb43206287933e3f03142abb5203629eea9ddf01fad880d8e5201820de25f59100b13bc33e0b1fec6cbfa0dfc1e35aee84af1f088857db9fbac4a369546558b2580743c8b043259987ff3e420d95131022c7b3245c25d871720842de1b654ceca923938bc294515d9b0c23d734c39f5770a7d047aec1d21ae03933505691edfce24d5baeea20b9de34bf23b0f8a93e7c698ef487946c8e452977127d241b2c2162623a42e3629f64f51f2aa67379ed23c06089055342c6df633dd85c0277b814c9a10c850a7c6b86f077ab1ef4d5ff077f9853fc0d0a656e6473747265616d0d0a656e646f626a0d0a352030206f626a0d0a3c3c2f547970652f466f6e742f537562747970652f54727565547970652f4e616d652f46312f42617365466f6e742f4243444545452b436f75726965724e657750532d426f6c644d542f456e636f64696e672f57696e416e7369456e636f64696e672f466f6e7444657363726970746f722036203020522f4669727374436861722033322f4c617374436861722035372f5769647468732031363732203020523e3e0d0a656e646f626a0d0a362030206f626a0d0a3c3c2f547970652f466f6e7444657363726970746f722f466f6e744e616d652f4243444545452b436f75726965724e657750532d426f6c644d542f466c6167732033322f4974616c6963416e676c6520302f417363656e74203833332f44657363656e74202d3230392f436170486569676874203633332f4176675769647468203630302f4d61785769647468203839342f466f6e74576569676874203730302f58486569676874203235302f5374656d562036302f466f6e7442426f785b202d313932202d32303920373032203633335d202f466f6e7446696c65322031363733203020523e3e0d0a656e646f626a0d0a372030206f626a0d0a3c3c2f547970652f4578744753746174652f424d2f4e6f726d616c2f636120313e3e0d0a656e646f626a0d0a382030206f626a0d0a3c3c2f547970652f4578744753746174652f424d2f4e6f726d616c2f434120313e3e0d0a656e646f626a0d0a392030206f626a0d0a3c3c2f547970652f466f6e742f537562747970652f54727565547970652f4e616d652f46322f42617365466f6e742f4243444645452b5461686f6d612d426f6c642f456e636f64696e672f57696e416e7369456e636f64696e672f466f6e7444657363726970746f72203130203020522f4669727374436861722033322f4c61737443686172203234342f5769647468732031363737203020523e3e0d0a656e646f626a0d0a31302030206f626a0d0a3c3c2f547970652f466f6e7444657363726970746f722f466f6e744e616d652f4243444645452b5461686f6d612d426f6c642f466c6167732033322f4974616c6963416e676c6520302f417363656e7420313030302f44657363656e74202d3230372f436170486569676874203736352f4176675769647468203530362f4d6178576964746820323839342f466f6e74576569676874203730302f58486569676874203235302f5374656d562035302f466f6e7442426f785b202d363938202d3230372032313936203736355d202f466f6e7446696c65322031363735203020523e3e0d0a656e646f626a0d0a31312030206f626a0d0a3c3c2f547970652f466f6e742f537562747970652f54797065302f42617365466f6e742f4243444745452b5461686f6d612d426f6c642f456e636f64696e672f4964656e746974792d482f44657363656e64616e74466f6e7473203132203020522f546f556e69636f64652031363734203020523e3e0d0a656e646f626a0d0a31322030206f626a0d0a5b203133203020525d200d0a656e646f626a0d0a31332030206f626a0d0a3c3c2f42617365466f6e742f4243444745452b5461686f6d612d426f6c642f537562747970652f434944466f6e7454797065322f547970652f466f6e742f434944546f4749444d61702f4964656e746974792f445720313030302f43494453797374656d496e666f203134203020522f466f6e7444657363726970746f72203135203020522f572031363736203020523e3e0d0a656e646f626a0d0a31342030206f626a0d0a3c3c2f4f72646572696e67284964656e7469747929202f52656769737472792841646f626529202f537570706c656d656e7420303e3e0d0a656e646f626a0d0a31352030206f626a0d0a3c3c2f547970652f466f6e7444657363726970746f722f466f6e744e616d652f4243444745452b5461686f6d612d426f6c642f466c6167732033322f4974616c6963416e676c6520302f417363656e7420313030302f44657363656e74202d3230372f436170486569676874203736352f4176675769647468203530362f4d6178576964746820323839342f466f6e74576569676874203730302f58486569676874203235302f5374656d562035302f466f6e7442426f785b202d363938202d3230372032313936203736355d202f466f6e7446696c65322031363735203020523e3e0d0a656e646f626a0d0a31362030206f626a0d0a3c3c2f547970652f466f6e742f537562747970652f54727565547970652f4e616d652f46342f42617365466f6e742f4243444845452b5461686f6d612f456e636f64696e672f57696e416e7369456e636f64696e672f466f6e7444657363726970746f72203137203020522f4669727374436861722033322f4c61737443686172203234392f5769647468732031363831203020523e3e0d0a656e646f626a0d0a31372030206f626a0d0a3c3c2f547970652f466f6e7444657363726970746f722f466f6e744e616d652f4243444845452b5461686f6d612f466c6167732033322f4974616c6963416e676c6520302f417363656e7420313030302f44657363656e74202d3230372f436170486569676874203736352f4176675769647468203434342f4d6178576964746820323435322f466f6e74576569676874203430302f58486569676874203235302f5374656d562034342f466f6e7442426f785b202d363030202d3230372031383532203736355d202f466f6e7446696c65322031363739203020523e3e0d0a656e646f626a0d0a31382030206f626a0d0a3c3c2f547970652f466f6e742f537562747970652f54797065302f42617365466f6e742f4243444945452b5461686f6d612f456e636f64696e672f4964656e746974792d482f44657363656e64616e74466f6e7473203139203020522f546f556e69636f64652031363738203020523e3e0d0a656e646f626a0d0a31392030206f626a0d0a5b203230203020525d200d0a656e646f626a0d0a32302030206f626a0d0a3c3c2f42617365466f6e742f4243444945452b5461686f6d612f537562747970652f434944466f6e7454797065322f547970652f466f6e742f434944546f4749444d61702f4964656e746974792f445720313030302f43494453797374656d496e666f203231203020522f466f6e7444657363726970746f72203232203020522f572031363830203020523e3e0d0a656e646f626a0d0a32312030206f626a0d0a3c3c2f4f72646572696e67284964656e7469747929202f52656769737472792841646f626529202f537570706c656d656e7420303e3e0d0a656e646f626a0d0a32322030206f626a0d0a3c3c2f547970652f466f6e7444657363726970746f722f466f6e744e616d652f4243444945452b5461686f6d612f466c6167732033322f4974616c6963416e676c6520302f417363656e7420313030302f44657363656e74202d3230372f436170486569676874203736352f4176675769647468203434342f4d6178576964746820323435322f466f6e74576569676874203430302f58486569676874203235302f5374656d562034342f466f6e7442426f785b202d363030202d3230372031383532203736355d202f466f6e7446696c65322031363739203020523e3e0d0a656e646f626a0d0a32332030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f46322039203020522f4635203138203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203234203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e747320313e3e0d0a656e646f626a0d0a32342030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820323436383e3e0d0a73747265616d0d0a789cbd1bdb4ee4c8f51d897f288d468abd0ad5aebb3d1a46d999654613cd2ad9809407348a4c63a093c60dee36c9bee47b97977c43cea9b2dd17db6068d72264daed2a9ffbbd98fc58ac6657e97445debf9ffcb85aa5d39bec929c4f3e2e56abc5edf7c9d9af77d9e4afe9f52c4f57b3453e392d2f56f8d5e7c56295151f3e908f3f7d22f78707118df0278e0d23115189a2829358329a70526487077fff81e487071fcf0e0f269f196111559a9c5d1d1ee0ea883062221a7349444c2539bb85555f4e0db95ec28bc9b5bd8babbb2f8707e70109bf93b33f1f1e9cc0fb7e393c180cdfade589a44a10a1288f89a64213c6681c6fac1bb4a89f987a6f4d8ca5a1429db750df079288806f4937a436937eb1bfe4e4e74f844c4eefd21c85fef3a7af3f9168f22dcdaf4970551c7dfe5bf83ab1ca0efc58a429e7c46878b28b2139c2b72b033ba6e7817aad4c9f00ce6087ec067e1e1c798097d048f7c1f3401fe754f630f73c382d432682bbf1a18a8426bd5cbd0be3a0088f44908522582e431d80d7081907f27570d93c2061125ce35d399b872a986721d3c16db60a0d3c833fcaaebfb72b16ab10778d4d078f810ed347c7727c78cecc7f37ede08941d7d003efdde8f044c4a8ec85b7435f970f629e7c50155a8c047ef0d720c63d23869ebf8dd8492883fc6a96c39f3f825191f04806f3f1ad391294f5a19012003c45c00bb0d7dbdb9045419a83355686cc9443cb9a34daae4332c507f914d73c86cee0ed03f85e060fd9b4a6667c1de4525226fac819206ae159d4e0b1d56bf0929ef18ac017b6c55f5c83137e38475945e8c3bf87473c387e031a395f828b7ee321a2c5368276a233804dca2f9b34b854163fc927b6c9a7f1130c0d7ce9c1c2433ec3236a7aa8b6c91b437f0ab9dbdc87261834e11e5a07a882f6ac0ab1a4523fa90a7c5315c0234ed021de2cd089de66936c89dfd91c6836595a5f6af3a607f0b4e831cb82828959e73b3e773964aac6f4113180bbc633770d54404f73570ce72e70d4f2713e0baba895afe03d149ffa62307a30d147c70006c79e19ac12cada59da2683e58b187c879f0a88ec8b7f421e800abc8230e195c58c539df4513280c58967164b8dd5d9532c565d2cbeb03ccd3157b2f736ebfa17b0d8265db3c283afd5c0c23e7c8724eebeba073527857865e6ce3cd7149a33e0dc6b101ba3a6e084491ac94ec4224963d3c2ec2baad057304cfb61bf9ab30b3a6e887aa1ef97a174c16350738a3e70e393c722d811f7c1fb96a14d2f0984ed87149c60314b2fe6d883c980e1fbf5133a91493435bf23f11c5b8dac0fde7eb55c373c85fd9961f4d9478dee439195100645200406866011ded50f3da6e8b9e65309a3aa2efa06fb87910a3eded58d55c65091ac3122f05219db4c9eeda737aa05112a16255b10cfdf47d147f661cf40b6038a0b94770bd4feadb55d381a73ba369c2f18c81fd1b1e69007d90f45eaf2ced5237cb3774b71078f58d3a82dccf1e98d13ac02db70f66edfecc04904dafbb3f4344aac2880890d20274183cd3356eeb935a0b4a482bdd4ca3d17a94a31e4d10652df206f97aefb06310ab24f5b73ce6cc7ce269ef30cc2976dcfdb74d3ce103c4c2e644c4d077ae377dd991218b2dba06e302acfe7b637a9833cabd9b2c4c47b91afaa07b6ae499761d5e95ce19ce257f85235ad4dbbc1f533097a00fccebe77fb616e471cf6e314deeb20cc90db393cd2ae245d0f3dd6abd74313f72eed0aaa9b14befa1fbe153c0bb9448cd60d5984901656c05387b60c7e0bc5c664868ece6915393fd1e2f41043f0dc4f5022a6c9965339a9a55f8da38eb86c94809b207f44fe4f9be6b61d64a184f0ae12d511db510f8613aeb8ee77c35b2e5d0b9c557d9c790aefb72248b1593e43db5ae4b8d1d4f573d5324fe7b809d2472b52ea92757ca3451bf7d5768a782f173546bc7a6b8e568e42b7dd7a0b7cf618aa2d9584b573a8e69983babc2f515bfe609bfd39969cd512845316e00fdc7d7a75053899b55aada9b5bea256f3b1b5ab162404dfede8f090ae511c5fa919e4925c77801da2d49e7b388a09aacdb677073638d1811072d7ab7137d5888625d5c332b7627437cb1204d9a8f7a6d761b5624f9b018e53e0e9ea3714f4daa1e0b25a71ad325b079597b8e5f6b198a176dd837594b61a72abedfd8cdc39e7055eaf5263b91e3ae58dd1cd0a5456878d15f9a6a7b3c3a61d2fd7e05eda664ae3479dbee3570d94860c3769f3a5bc5041255b9540dd27dba6f9f636b3a634dd9eb2e1683dade52b2baad63b3784d3d0d6f2fb6e0eb725a43af23f56b8ccee4b0fc376c8d6a4eae08087b9b789b12fd806b528b1342f734c6ecafc322b962e3e42302e9c068e3e12d7f006d381caf88e4a68a87ebaa81ee2a83c7742651c53f152a4b8e7a6a2048dd46213a9bfa09721680a688417b54771395ae399dc74db65d0b00c6c4956f31a172337d33b376b28b32ab3b31ec846e4755ab8f6c39891179840da085ec7fe66be9ebb4c5c0757e90c3d68ba855573ece6b18ef736edd8f079f1567a8b96d0c4876a9d8dfd2e885b2ebc45f3185f5325544a9a77f07f885278eee74ab0a2e8c548793e1f2255b4535a7e0351e9762ae6b2cafab8150a3babf5e30a63a7559c26dca40f99cb4c6bc576ad4ad11d5276e33d6aa255986397368eeec595a611eba0dd43c0500915a6050a27dc4cb8b6d83b0f50b5a67c00819d1ae7b9652985a1cabc14292f6754a8801fcb2e86a7e72497d824dacaff9dd3dc6a61f8384b674c07f4e37141d5d48ac8a64b5dd4ceadcd43b4193d8310b69c68c31c227bcfdd35c9a00c7b7106e1b9bb2692045572cb614452ba233127ff195d4031ac8cdb605d1561a7c4774d07cfc7616a81e3e12ea23d7a493c8204f5779be61d508d480c2aaf04d7fa7c4b987b6e3a8958e31990172aed184d03fd0452c6c6d50da4caa54b31a10a66903ffce912cf6f5c60268143ccdcc0e5dd7fe1f296c0253d868bd94bcc5dc8e12c13e4d6466e08c7eaea255b1e9d9c7ae098b6674a5fcbb16c0a979b05eec0c2f36d3ae0106ae48922ce3965a683a2212763996736ab5d176f0620c57d2185c70ebb901ac229e1995332da41ea450a7981263c480da52f358c04a6be6d3a86305779662e8fb11818cbda2f0650a43d5b7b8ba2216c369ed9cc34feb3c80bad3df66ced2da48670ca77f88924d5af0fd8d5492457cd27c1c51c17ff032ef7257ec2dbe902b7ddc3a5cce072fc065538732d810467442620ff86cba280cb1ca1bd799e2dd2570c13b1c2515e9b2d43fe8bc2730ce309c7235963398f074cb88a7af153a2b38dbb64b783ddc9025f11530885a7aeda2c182217cf1193c7d1fa00693dfdefd5efe7d1f515181944441677a03b84876394e04ff150c7f86f9fafd1edf1cb05c3b085dc4669089f3c7705b85258b13e83d4ff0142aeed520d0a656e6473747265616d0d0a656e646f626a0d0a32352030206f626a0d0a3c3c2f547970652f466f6e742f537562747970652f54727565547970652f4e616d652f46362f42617365466f6e742f4243444a45452b436f75726965724e657750534d542f456e636f64696e672f57696e416e7369456e636f64696e672f466f6e7444657363726970746f72203236203020522f4669727374436861722033322f4c61737443686172203233342f5769647468732031363832203020523e3e0d0a656e646f626a0d0a32362030206f626a0d0a3c3c2f547970652f466f6e7444657363726970746f722f466f6e744e616d652f4243444a45452b436f75726965724e657750534d542f466c6167732033322f4974616c6963416e676c6520302f417363656e74203833332f44657363656e74202d3138382f436170486569676874203631332f4176675769647468203630302f4d61785769647468203734342f466f6e74576569676874203430302f58486569676874203235302f5374656d562036302f466f6e7442426f785b202d313232202d31383820363233203631335d202f466f6e7446696c65322031363833203020523e3e0d0a656e646f626a0d0a32372030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f46322039203020522f4637203239203020522f4635203138203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203238203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e747320323e3e0d0a656e646f626a0d0a32382030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820333139383e3e0d0a73747265616d0d0a789ced5d5b6fdcba117e37e0ff20b4062205362ddea9200d10e78653e4b4e7346efb109c07c5d9380b78779dbda4c9bf3d8ff1bf2887baac56e4aeb531c7298a1304d91ba5190e879c996f6694d3a7f3e5f84379b14c1e3f3e7dba5c96171f47ef93b7a767b3e57236f9edf4fcebf5e8f497f2723c2d97e3d9f4f4cdeadd12be7a399b2d47f3274f92b3e7cf924f870739c9e18f319a2679220b49384b8ca0a460c97c7478f0ef87c9f4f0e0ecfcf0e0f4254d684ea44ace3f1c1ec0e83ca189ce896122e18688e47c6247bd7aa393cb85bd7172e93e99fad3abc383b76992fd969cfff5f0e085bddfaf870783e95763592188e4099784994411ae124a89319d7183066d9f4c736d331937879a75eeb17e174a3cb7722bc2947c21fdeafe262f7e7e9624a76faecb292cfacfcf7e7a9ee4a7afcbe965927e989fbcfc47f67dcb2a12ca3698a3b9228c255a1684f6b84bec8d8549ce2fdea6ec7b17731b55aa881441aa6fd393c8b49815bfda422bf6bc985513b385d6bfb2139696d98948e763fb22d37757a3cca48bec84a7c9e2fae602be55e95556a423f86e119737c638d1fc7ee4c098267c1bad479169710a5b73d0bcdc4fadca6b2298bd9ba566555dd3a2281cb50f0fc3fb8fc6d97fdb8e552d14c9593d8310f3219e18324f9c838c3a3cbd9e816ace2bfda422fd04ef5619e5e903d0ecd934a3b965fc84b1dc6a3195e917f8fa26e3e945a6d2d5d2fe33b21fea11ab29dca3fee0ee77e1f687dd16e3ebe55df5c43ff37349280fccea188194214c0648dd79a7f9a42807fbe2931a5fd592ce8bf42bbc529a96eeb34adfc3bac14a2c3a2bf0b99cc3193586e52ce174eafc6cef51adf5b8bb64b3e932a3baf958aeec15cbccaa813dc326252cf6f8d36a04174cdcbf53f8aa1e7c6d1779b6182f339d5aa7657a93c92e3fb18524f382701310d2354ccacedba96d6caacd36b2264877895e3d70729ec2e461d2a0f0d7edc6baa9a508bface65694c7ce4444e78e72458a00776edf4e13206a7580aa6a530247abb9fdcc600545b5508e453b28be4ee7846a9f359cdd03e6a34fe9ce562a4049bbd3e79639858e798e7ccce79a14664f9e04064fd66bb07e83554d3b5eb144c1d51dc692137b77cb30f8a465645d68494bfbbd4739825bba8d9c006fc4a787363d0d2eaa4fef1770494bd8d4ee102a27dfec89bc84ed3f6f6d45620fa3d67224f62c778756738a83d9681d00913e429a01d3024cebad120b29adc4dd48ca30a2d49e3c29649eec6bbec1d34ff1ed9c20da84485d2dac12812591b5ae54d6cebe998c40671a33d7380630aea360ee736b139d07796d55f0a6b9497bb7eea5e5b4e3b77065c088c9e67dd7c9b4639dce3ac68093ee5d1e547eabb5849f5d4056f368bd19b19e95bd61e53a5c3ad76852594e18b7886fa9847561140f08193ca912585adc54942d63f6c32aab3ce9460a65b696c81818754c4f9d85afbfaf45cf149e2fa4ecf9c345977db71ace639cd8a5b3ebd12a0071dc47777b9821d40418793602d7b45211706c79758e39f569f4495827195ca04a7b40a4ef6a3f49c6705d59c86f608a88c2e3d7d9c25c69e6ace1511edf5fe1053134202704274c7070f74253a4a232f7bf230856daa13c30c123045286281920358d2f4b65aff065f9d6eea6f8a44c483307593d8d6cf5840007b2c3d3d3cfd5b1620f3e77e2543e4a74991405d122447f804c0c924c6ac44b71d643984e6ee7a988c0930ef1449d19f379c238f04578fa47b90b721f81d171eae0cccf6c52194dd118222a6b4350b66fc11571e39cc96a47c63f17edc2151185b4659169a4dcc256cda305e17b2a1e8d81b7eed2bc3e4f788ad7a774447b7a071e5cebd04ec64ee56abf56f53d4c87a2455734667d4b1a4f26dbd6140baf6ef4ccbec85d517b90a918e8ca2e45f398c2d3348fd411eba9dafa4c5b7d713eec37f0ff27a3c41e6eb452ba4bab8d789ac68dd3b46842d9b6aa31f029b95dd564c149213b13789ce74fcf9e445f582a207be9511be24e502cb4a31181a184ed7dacc7803b76ec369f29b4dde693ba5be01026550034eb938a1f38502e9daadd87006d681910a08bf7785572101b3d74a0b282c03fbe2c15297a9424ab7451104dbb94c6994cbf65273a9dc0591cdf61a44ad9f0e77ed6d0465a416976fd15303b93d13483f451fc7c8a8082867873dd76622187aad246d16ad704824c61c58a0d5352926243755fd845fc5269ad5d5358e2eb16f9428aa529d510f7f8bcf404d4f22c089709c44c50d0c1765773c4086c77091020ad62df720eac38ac618adb5f36987a331bd7c8b7a8766b95f7bd0d261755a6e8bac95b834e5cdd349a10bedab88b89bbfd47fbeeb809b33b39a32a31de2d1c69e09a4ee948f4834433003a7de1b8397e1e5da0c0d0acd08079fa54e3ef23a840d42152435412b9ec49da3d6ef6cd8733ac3812e26051243297846d30e5d4f6f4d6add1687783137d74e922a8c3810487fbea3ff0e36c0ed9d6ab36db0171be4b247c1dc177cddbe88aa0ac8bc703d31b2273ac2204d808ca1edb052372df1087a15421acb553e80204d661ea793fc5181d400630dda7ecd23dd454d91e848a1b0a3aa1021346f01c7303d8b84f6ae7d63ac649060a17357ad2863a13382badb06708a196a4807edc8bb0ad536442c26eedf6aacabd7b89f61b94aa2e560485cd4d95e69b63d4921550e1e54b608e00a372c8bdddc7ba4256588766d54b576f8bc68457cd03ee97abfc4caec600014e47ced7539b153feb6c3ddc77524edf8f2a6c317ab9039584cac004e3fb47821aa243a4865820e49222a1f4eef036c85403b28da627ff7c131ff913f650911b11599d4afb4b5b1efaa7ba7e63b8cf04d7dc3e338d3533a39cfdf3663644dc0689a94607ec157a6f7fad40d6018fa93aadb5a9038d070c4eef80f5e53916d78ab9f5fd1e51728abcbe36eaa07b33c590d7d763aace256dae6f309c19b2d01c6da125d1df2b53812c53aa88d888718eb827532b4f3f141c225189c5bc764d133ef343248a65899aad937362f6660a19d1e505854aff8dd2c245038e6dd60f368b5d796dc974d4266a173318376d9cf3aa4fa5ba8b4a27b3acaed61c7f1867fd6e9dda651bcfdddddaee0d07dcb6ee5ffc72306e43484303b31fb224c87836d786887ded3a47c6881d1cb38ba978270f3aa95ee7469f9e6b26ceb98bf1dedd8db49794ef766ee880541fe7f9198d9b995f935444dea37065119c61fa3780cd5d54f62ed3eb52a2ea28305531fbae4830724cd5b66a2841f201f209f61721e742b8e424df170d17c868381739e0cf9b3814a56edbbc2ea31f0e06f6aa4f15e31c32d62bcb43a476d8436b07354b8fe0f73fdbf72aafd107579b3f86114ddf881d76d53432d8f7d39903277a7be144d14e6fc7bad569a3dea96aa090a635b8f6a66d5f85ce9bb68aaae704c83645a1f01e4c71073a6909aee9779a1d8045072477fa1da2231bd2107a3f0b2c20c0620152af1b9f66bd30200bb6219a4a924ce3359e70a67b91dfb6c6932679337dd036be2d335a34a59aad5af870d8ba87775c8f682aee9cb64d1735a276d1e4d193ca37b343674b6826b94228d2d714dae5fce90f39ee909f2fc0a904fbb02753c8ddb03c67bd38e7c7953ef8bc844b1fea67cc34a50fb428f4ceea07819c3763a600747acf8545865299d664c30bf9a3f8a12d7ef064731fb50f1e51b4d2078fd21075446ecc05e778ef066681055dd4950fd013b7d9c1fc7f55f9e04f6f88cc91b10968b4ccf7660a199b80fce26653dfdfb3e6802c576d834afc9804aa03a84fdfd53f686bd620143a46c049a8b091bc3feb4e4b7972356ad3aa3fa254c13080617d169b00293ac1a20020cf2778d3768f97578d49fc1d21c3ad2140f7c923d8239e839be593f29f047877522a3c2b04cf1faaece9ed020c1d2f12197d81c7eeecdd1f2b91d1179653fc66d40a8f4527d5c363fbf4005892b46ab5b840235d90223053b427e9f0d04c11c15805fd323ebdd748f4147386d1a3375eb827f5880ee4db3eb0a7dbd517067eedef580fea51d5a97adb8204b73a32f2408dd9d9e91ae4091978a05a6e3e192cb222012545681ea05426d665691effe7a1b02a3d7ad826a85debbb8fc06eb4c73bf7bea796ebded3fa4152a1be66d5a95ceb3fd666e19e85e791aa30d7ce936cb616ac7511578305b8daa152fa021ea25ec8980c9c1f7b3fe54d22633290b3631bb1cf8f03db7c5ec2601b15c62eee60ac4d22e30894ebfd635a895c02012db2c586d3f907d8d6826dbe70ee036df3a9a2c16d3ea9212a890cb350cae0c23d99ea5451be3a8b8fb7d910fb7f0d6d0b8941e54862a871b9be18863c369122b154ab8b51f080ff3d79c2aac96c9f110effffc0ad98dc7175caa958e05570aa68f59b15cce54dd5a15c0f1dffe10ae3efd3fd0185950aab2a94e7d5b387fb53250378c22af6e4b9826e3c8fa7904afc17bc1e22960d0a656e6473747265616d0d0a656e646f626a0d0a32392030206f626a0d0a3c3c2f547970652f466f6e742f537562747970652f54727565547970652f4e616d652f46372f42617365466f6e742f417269616c4d542f456e636f64696e672f57696e416e7369456e636f64696e672f466f6e7444657363726970746f72203330203020522f4669727374436861722033322f4c617374436861722033322f5769647468732031363834203020523e3e0d0a656e646f626a0d0a33302030206f626a0d0a3c3c2f547970652f466f6e7444657363726970746f722f466f6e744e616d652f417269616c4d542f466c6167732033322f4974616c6963416e676c6520302f417363656e74203930352f44657363656e74202d3231302f436170486569676874203732382f4176675769647468203434312f4d6178576964746820323636352f466f6e74576569676874203430302f58486569676874203235302f4c656164696e672033332f5374656d562034342f466f6e7442426f785b202d363635202d3231302032303030203732385d203e3e0d0a656e646f626a0d0a33312030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203332203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e747320333e3e0d0a656e646f626a0d0a33322030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820323731303e3e0d0a73747265616d0d0a789cbd5c5b93dbb6157edf99fd0facbb332b662c88b8100077d2a459c7ce659226ee6ed307270f5c2d65b32391aa2e3bc9789adf9ab776ff45cf012fa2444a86b4843d1e5914219d0fe782f31de0d0a32f16ab74128f57dea79f8ebe58ade2f1bbe4de7b33bace57ab7cf6cbe8f6b77932fa317e9b66f12acdb3d1cdfa6e851fbdcaf355b2f8ec33effacb17debfcfcf0212e01fad15f5022f8c42c299a7052511f316c9f9d93f3ff1b2f3b3ebdbf3b3d12bead18084d2bb9d9c9fe1e8c0a39e0a8866c2e39a08ef7606a3beba51dedb25fcb0f7d65ce9f2eaabf3b33703cfffc5bbfdf6fcec25fcdeebf3336bf9c558160912728f8784694f122e3d4a89d68d715683f64fa6fa6e3519338712ba68417f8a241e80dea26e496d25bd367fbd97dfbff0bcd1cd3cced0e8dfbff8e64b2f187d17676fbdc164317cf577ff34b38a5d7c84c31f004961bc649e92707b17268c0a44c0bddbf19bc1fda966fd90fc109424bbe5bf190c5d0905abea7d429dcd544118ed13fa22f7f5e0de1ff241e27380208b8b4b7f28e0131a0e1678b9a806ac7d8a571a46c2802b479019a724082df5d4e5bad485eb6e5624258c4a4f00c61c03c305a30decbb18cc45033978887dca0a6ba6b12f0677f86e0a76968372c4c5e77e54bd1ff76b5d13f5122dba07669eadc0c5d2c40f07f0ae86b4856f8c7e9703c686cf0ea3708fd7f68d9f094ea8da87bf1120c32d5c254c331954fbce2d333cc32fa6fff3c34db0d55396837c0631378b619068fd24befd1567fe8833370a5aaf7a9fbaa011617cdfd41f7d5e28bec4f4f3c01fb241505e5d997fc3c10a0d99af57067bef00554422bd0fe0f2325982e657b5f68deb17be869aef1f4f15928c91b005c7d8f0d12fd6d27c3d7dec3fd48210e4764bef7fb234d0269d768a5ba6959673780d5c88e7d224d64ef1e9b4cc6cbf154b9b18c45eb22e8c8eb162822a71e293345284d13db8ead02f031ea267bd00883ffbfdaf5b2c225cd9794357dae28ed35600a17b0a2ed10f2eb6e3cb12571009df529dd4541b66ca9fec2e3b62a9c98d9d627b60a43bc298a1bf7b84f53d336668ef1e613f61a688311221d1633c2ebc39acd2e69385073172ff38f15571fdf4bcb68d8c81ce95fa486a60a07311ed1376d5b73041e45e613b3333b76ab71724c07213ca4709eeae0a61934fba233074bb3248cd8894257edb55413ac604ff065b985e23f18be125bb2f520c93b2608259c55df193c3ec1b476c868762c303ff8b04302da90bde99e39d78d918dbe48478fd104f91da6cd8e8f3a2664321e6ce12935ef901d2e97941482aea1caf20e4d23c5b969cce4c688a1f3e56592b2d04f44ee3c00d55d8a1e45a1d4de8739896a1dd0f49b6a177854680586559e2d7f5ea969e963e93ee489f849a9b8b26fadd640f90174b7487e755319de5c88b639cdc6c96400144cb1b85bd3c30525dfccce686c6e0d8c25c294c7c69cc2507c441d913613dde9e9545302ac7c12804ee231d87493bc6c41909b6307d33f58ad2141c0f8308d9a889b87cb9c49217c3746b35e89f202ba27407b2fb9a7b1a841b2a5ab81894aba6a6941b072e49330c52c5fb0770c878911a6fac2651fedc33fcf6435a47ddb35a50b184150eac1d4c98c34792764c1891cb12382e92300bc3ba3b510dc5a6529bc4682527953564d92ea80e6a640ac95d75887a32fbe810a588ec1265119f91a3f864508e4958c72854434742a24e76c3cbbd4e01d60f4c05db0075f11e9cee215e203d4e4d186e82ab7f7331205a5475c0e8792bdc889224e89ab15948a6be28d363c54a400534e8884339f84fffcb86e424eac266e322ae769d4bb70d23c0161e0bcaf18e73a8296e0b3640dda48e4e05c04323d125719b573702a5f72c0a0b0790d2360207099b314cd86d51d9659da3203f715d17036179bd95d1c3a091e5f09a6184c1bd1cd4b5a9026018c6dc74bad9c6ed3dea4386279aed092d311f2f9a9302340d1e82c16fe668b6ce918a149bcdbc1cdaccd9bd2f0782114e3f8ac1b99084861da2aa1303306d55d5957ca536fea2d855adad5f2c936b541f5644cf0bdad67b86176137e21994231c2b96a1502dbf4293d5652ebc6f9a9fb970bc6aa1929ac82d985b815356539349325e3d96741759fa1fded4ac2e168471d8383fad2cc0cb92b43803616d6d34ca7c5319d434bb0a06900ae5016d843571634ecee0a3a8434f3659c6f10671188698968f0455ed0e27cbe1cb1b07a0f030306a827a09b6feb52af41a0b575d0f5d59a00e1da1a640c88189b75177abf2c70d225982a8e74dd14360bd621fde1fa4cab111b8f1da233d43f7004a1e00053c016a9f66d5b92cdc221a2c2844f95fef31d4ef708f2d86974cc1cbd5eff07261013e72049e2a8a7bc56df0367d0d8133500a4f75dba09231a8eb5d8e6ac5adb18b073c23585820a58e90322ef02ce134f531c70e1928a28e8d12c6dd8212d1eea2de6394b03e16ff0351d2066fa3d13ed6f60351d206b51b25efe1f20195b9b048454cba0a15a1f038ba0d776801aa8f84d2092ae444f10e50d7a0b83c039dfd2bf70df753bb1b0f9d385de5181e08dc3e39cd015de58e2aa435df559ef1bd0c545869efc3cd06ce720915264a5a206d3a205ca58d4a738a91809fb4187a78e3c46cc85d259e321bb6a765a36bd789470658b81e09ca5542a940094d982bcec8dd259e221bb6c0db68d4557aa9b2610b5491f9fe826afd1ad49a4ce1729a5b20759673ca2839497d8e8b18c1252669470ee9b8886983b7e926735cc4b4413d899e0967954c49cf5a702de8997096504a7ad602751a3d13ae724c45cf4e72c02ac76477c3bffde020a499c00eb406a8af4dcbdd145468b30e8ad0113e1a30c275073e1ba549c74aa30c3b093e363313cad1b4aa9cd39a968daeb5635d070106f9e90e1a3976d0163e0ba5857db40e1c501ad77a07d4110efa94538403a9ae8dc946517d1ca01f529492441fcbfbc39e0ed03b7bccb9a45b881aede5c24d7bf9ae44579de56d396e9acadb726eea7ef2d484416a56106fec17cb485c1ea999c3b83e1e12db811531ecd5703ffdc8f08bb69cbefbc861c51316f3a91d3ac036a248c085b0e81e777c6ec8a1b052c7b2b0b0a7a74af682026a186ce9f2076c1d47b230af9b83575593e234ad9bb2cb9e0751b7969707c4f839f60bab6258a33da23cd55e636f40d13d3cc5afc60fa679bbe871945bcde3e588cbf2690b593c3d95e229795c9d4f6f8ebf93c601f7f4d204de64823f6d64adfce6d398e60b7fd4a7da5b1da4fb1a789a47f3d81d86f2c605956a9fa6f6d1d21006f8d443db42366ee3f85108ce3846e291a05c3d0bc14265d605ba4b886a4f8defcbae146c6dc7b7333433fd187d5a9c2ba25507381b8d396e586791c6faf048508e3bd6990eb109f5b85606274fcd227d60b203d08ea81a38c7bc54f72204013f9c705cb5165778d429cf2b392e1098a49b87c00ca83fff094d388215f52ec58a60042f77581b2cdff55f1108a004ba03848d661c5704f8608b3eda5c7d540487407153426d6f1382b9dee14617b284673fc14b8ed97891e0c324b8f995cff0dde778b77f0b6aa4731db86c9455efb365c37f38d8a5664c92ad756291148c21c2ff3aa6d4d0dc02a7708493326a94b78bd34677a163dd51b1f9af12ac4149c7a070a7451cf2fe6b74f7ed0d5fef025edee3bb648e9b1b16d350aeec0d8559a43aa661b1792eb523502ce084f30e502968351b570acdd6b879fecc0268e40a6818756bcfe649c3a0075007723bd5da22b7ff1f8ba9bd5b0d0a656e6473747265616d0d0a656e646f626a0d0a33332030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f4635203138203020522f46322039203020522f4637203239203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203334203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e747320343e3e0d0a656e646f626a0d0a33342030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820343335353e3e0d0a73747265616d0d0a789ccd5d4b6fdc4612be1bf07fe02180678ca8c57eb2196405d87294ec22d94d622f72888360228fa459481c791e42f26f735cff84bd6d57f5834db26734b2d88183389e1936bbaaabbbaabe7a90397eb1da2c2e66e79be2cb2f8f5f6c36b3f3abf9bbe2e7e397cbcd6679f3cbf19b3f6ee7c7dfcf2e17cd6cb35836c7afb7bf6de0a7b3e572335f9d9c142f5f9d16ef9f3e294909ff685dd1a22c642d0967851694d4ac58cd9f3ef9e979d13c7df2f2cdd327c767b4a02591aa7873f1f4098c2e0b5a5425d14c145c1351bcb931a3be7e5d15976b33717189dfb4fbf6f5d3273f4f8ae92fc59b7f3c7df29599ef87a74f0ea66fc7b25a10c90b2e09d385225c159412ada371070ddabd187faf5f0caec1b12e07ac3f86122f8ddcea34a5a1907ec07f8bafbe3b2d8ae3d7b7b30636fdbbd3bfbf2acae36f67cd6531b9581d9dfd38fdb86d15bbb7b59235a10730f84072ac438b968a3096a4559889852ede9c1bf93f8eaa1c50a58ac81d2bfcb22c5fd2937117c938a17f954099225aeda0f5ed7c7a2427ebe9119f1477534a27b3e99198ac1633f8f9b7eb296593395cb423de4dd5e4d9bc812177533d59ac964d8313dce0a066534ce5e48b71d96766389387890a2f85035411c10aaa6b523273722a5ad73592bb789ed61e9a597b84024eec1252dca7786223f024f7f0c439e1114be6a8b3b3d22859594a7522ccd7929f1c51c9cc27599b0bc2fc2d4f8ee0bb3885ef2754c267f31b87bff1e613f8c9dc4fc3040a2f56271a74499d1cc105330e7e95d44d7d7a42918c9b4ab293da5fa6389a56f0bd74ec51644f56275d229eac64eedeca7268463cf2580efd831084f2810c27ef4017e653501a2acc26036793bb19e8d20a2e19e5a246b9e0e3f5dc28cc1a8688dadeb79d52eeef59ffb19e8ac9c6fcf9af99cde8583bdd0c3e9f8322e27f90dada68e7026e8fa68e6ef933fa0c732eb7eb885677b864935b9804f95d4eeb1e15b8533ede4eed3c9554934ac722bd9e19869b73e0e6033051ac419adb95e1ac8884804c994f29c11163b0f0e2f760b0507eb8bac2ac076f5f36535a4eeee6cd665a4d16f08d4d3ef737c1d2afafa76e5f2df9a519c933488197949434218506f60b760356f6213033bb9b9f7b3eb78ddb42e146dfc42b68dc868bc9cd0c3efec7ccb50551a100b6e60c2827a7b1d72494245227d674800de4996d6029c017778c2067c136816941eb654c9fa8dd9f5367f6bc297b690d9472a64878532882750a3f9dda99159aa6cada416fa1eca8ca1174f631b2a32298e1aead047e028f3298614fc8dc5a471347061809b7161867ac63eb49a361bb2caf8ae696da7212b855209d93c8de236f6727f120584e589a46b1ea3c269b2b46b81c6e3918186f3cce8d12a0dadccc50998239074bf1687033d40c4e09e309960ed00c9117b128839dd443118bccc113e1e61f70b986235e15aa12a4ee9811b46e77194cb124354fd03b40102af3e6a89208b587a731480952aa0348a5965fe5b5da4a989dd96bb5abc82c55a5b53ddeca51b4993d002922fbe50c5f64e11e007fbb7e60807a0f34ba3cd85c671d2d9aedcced2174d7e8021b525bb7d0191ebb3087a7bd0b7372c015523b6b5f325d20def5475de8ef8528c737e09a91920f773f070cd3e68e7a40aa382a0deab759882f3250ad19b8837b179852399dd9e2184fc51fc8529dd51b288dde80aa1ea8fce7f4884dfe655cc27700e9ff763743648ba1d56afc1d83fc0a4f7071807868e68c9d2a19a1f4a14c654e84485d1159c74c7d654290df7d9072037b761b45c7e3632eca28a9127cf48413f85560736409e9dc92546c7f16698c940ddb75e43d4b1523b5ccecfcb9b14007904a0a618c986da7de7b21484d44c7207d63ce0baafd57a34ba336c053a7683e3a113d3c9d4669ab0429e351e9ab5e78c5115c385c42cb441819431fe1fcb28e91848a51409b35e31ee3383c93821fadcbefcde30262e1218ccfed75e2690b6b3c76c28898616c1898eca1b8417029c3122da6e2ddc8d9cf6c810c4e6e18a171e0ac7d20aaf6dcdf4f29b6f8cc339b88ddbb31bd1be75160b40328e33387234f919af45b1a120461d7a49d33feb90ffe945d0bb3f22a3b0b3127e8d1958cc1799526482ad5fdaa9134145942d8bea1109c541d438f39c0176fbe19df4c2813c5a728e63013140a1c03526826ec79a07a6fdac91f1b5ac9eed9ed5d4864b9ac563b7d506d9841b5daa106eeca99550216a77dbc324a34667872cd4f323ae34e0345bf74e0d25edd9f5b6ab05c300e55acdc91ad74b6d1e5c8cc4dbc33b0cb5e3bed8bfa447624d495f78b1719f2561a9cf0f058b9acb6e16b720ab8e959c8d343161bae54d266b0664d5c91d02a4ae9473fae6c8a9d4a8bc0e032fe84058305140857a1ba81b3b3c97b2c5bcc475725c904492d797c4df26682d584555d4dc2fca5b6163514a60695a523caead6f4c6cecf1ee95883cc9913d1918eeede513bb317dd897f6927f21ecf1bfbc89da452c083d976a798298d19f645b8d269bc68fdb8a84a5f27ec890104e359911c98ddb3b084b6e981585eda84f0d06b7a90728fd31c5d1f05a544cae189c95139317125e309526f2710e5ae8d522ad45eaa6dc0e43ea37a5fcd8ddede2c7cdd077e6f46571fa135a4ae53ea63366e7479d425babd813c9cd5a3b55f295ab0d9daca2753a95252415407f4b4755334a3b80d8bb5d91728d8bd9d8e1fcb96d8e73064848c4f0a7e4aadf910a097b52ee077a32c7be90e047a3f192578353ed4e384a914cdf10f9b41952ab9bc2f424117ab5658905e8011309f94bd606c022a40f0ed7ce0dacdf59e6f6f8be25b4015ab00200007c0455714f335b3eb67608bb640740155723cf0338020309b4bbc993bc63f93dcfc54d2fb77217926b394687a6752684944c750fd1b64f51a725e3fe6382965926886436933224352eda1bc5ec2a9bac4a697b631a17f766038e2d69de7676506567107c3f074aec73f5a4c3022e4fdb24c1ead31ca5f7bfc8e415f1f91951ba340b007400ba906192bce6d24d7cb47788c17672c643761159230f1d8188fb79d0d1e44ca2882e41670ca1ed26def69eb79da034adbae916c660bf7e5e9a238ebaeb2ed7df3e9b2fbb1afeef6549cb5e5c94192af07eaa3487a57fe2a841f2e4fd60fd47bc542fa6a7cdc273974100dced841073f6f194a52681210e6b66a8048b1ac716ba2f4e50aa0c8c6a175e16b54c60a7e37aee5f26c71030c799560eb6f99e8195898140396df2474ebe5a12b38440243ba87b4d7e6aabfb1ba22caf80e5641f3f20399ca5c7f139411d5c14adfcec687075a10ad52c4ee662b38fadd2ed81c153e9a203efe3a291384a7d61929b8517835591bc85339285d1883f00e8c02f69c22966941cdb49e34cd761a37b4f62053b77d578436e27a7281f0093fc2fcdb02b1d1d53474b0fa2996ff03ca45e89bdd69a7665b1f28cc0282fbe022810f2e5408860e7e380f500e03e0f17199a88ca8d5fd9b9bd4ad31aab37b748bd79a94fbd29549a6b2544be3c7b13800d958e1e7eba9dbcbfd8de9ae2bfd593827cddd02baaef1c10f0a0f7e34aed33a448570062e16cd62dacd2e0b978fe9345e6f1b20710fee6f428010ce198edb7815b15dea26e4f587dba7a4692f0676aa835d06b7d828be332869fb41d7d03b629beb6d5378b6641266f9d38f121c1c291971122b5d33ecf5c2874bcb061ecdb99b6f6d5940f90d46650f81d5bb90bb6a25711bbeda386b01f7c12c211f80bbfc793027c81690b840d3b1f1072d8395e7c208ae4ac86d9d8194848cef9054861630a1a1e4b1e33404f5a2caeb11586938c8d6dadba36b1f96b03a0a5b837b1c9242c3d32e06871d1f1f68c2b6c6b7e43aff5210d6319ef7e4955619729cc69dd304278798f1ccedd89cd71f8170b3e45d23a6988487a0fa29579f99d19de773786c57172d1849d975de7a94c5c5c58770dc83b18261ebe262710ef4ae16e6686a67a232748c31185a25567bc81664ee0487146876946b1faa1c927ab105c7d22ceea0d2640cbedfd2bd1e0a4764d82413f11a05b9571ec94dca95b07392639099ed5894a303981a236157eda8e4942ac1d4c827c7c7e860559342f8ac6dd93bf6d005a2100be94c34932134ac055175feb5e3813451689520e553e44cebc9e91c3f18bc04a68c4daee01a1671c6ef5566b22232c55086b52b414a9920d5a9d3f2b28ca3475f306dc34737264049888e6f66685cde6fe737aed6452b2f4d1b64ac1c6c815b03f8872f97a17b059ff2b418a7c107df2160890a60389b033dece32bc8e3a112d01f8d2d5f9130a327579bb9efa2ee42b78ab93a8c738ec65deaeeb3c68ab6d0d23e18bab281809ecc2ee1744a9b4db0a1473377e2361327622398ed32c411884b714fae16f0f13d242580d1cf1d7435a36f8ce8db38d1cc8a9bdd82d0e11adaa13bd601a877069ec6327139b7233e852d548ad403506f250b4ce22e0ee24e587a5374e00fa0a39be554779f4f6c334810e02fafe7c5068fffef71ec9ba1545657f00293c1e21e21f2a43fcc92c78f9cb46484a9073a693e460e799f931e3095d9490fe8a59cf46f6d73cdd5afb75ed396210539bedf668c414c965d1c484ac2bb7c86a46c589349fe4c9444d094fcc1b2eed9036931c3afdd72fbe869094e894cb1972103c205e47586a4c68f1938d7f010d05fb22a3354a74ed5eb05c08d38bd879e00ed7d9c76897b764de00b9b6dbbfc3ac1ef1c4ecb309a0eafb208f9397430be1ef129b8465ec1732fa9026aa2ae304829bbe5bd340ac1ad4214bea6113a9f2e3e4ce30467c82320dc0eeff78893da66863f73bce2035f1d335cf167191f6182a3ce6582e8b16dcdd2be775163e465dffdd4e9e4f10832540514c241d52f5ec14f09246a30cd761a6d5580929fc2e183377225903516d90c8e22610d6f2786fffe29eba53b42739dab998deea08c810457d167bae7293204751a522b03bac726984abaa45e2cefcc5807b28643d757501e27b1ad26e691267473d729696694a4100a1a16139274ba1849f25710e5f5f212350afbe8de4ec1613ce6553de32a4fa9a137275ac6e9fc76debe3d25948aac133acc8f35f679161555a0e31a1f9cac10e78ba8368201ec36943a6c4ef2bc636f8caa3617d7861f0c45fba76cbd0dd5aee2b0b8ccf5267e127b416bde7b73c0304adc179f87ca698628b16444cb04872387893c57038d0b136955f7d23087848963741eec0913874ce50d1387f4ee0b1357f81eb9f1d3b90a5aacb22f1f49d5e0fd86a4729432386129523992d40aba4386a44ec727458d0148ad2ae0cc0b448c036fd01a5e4c4a46318e8d0c940f0c780728f8ca236291d9fbed3cfc8c649a3bb08c386216bdf4af8750ccd5e7f073e4909f07dc875963ccb52dc26f83ee1384902bfba2d547009871dd8412bdd795f47a4d669d98d3f7fbc4a81e12c391a4dbf0d5be8c6b11fa8adaa0a0db2e7419b2ccb7573867c7fb1c6579b722af09a789d58fed8272b574f9ed93e5fe7c4592a95c0d0ade2f72d98b2c77558777bcd9344f51183c5782b7430496ab79c20bcca0fff2c140628c76827d4062c054662031a077ec2dd1c6bf9a14e2cb4e72224359b89284e65f3c52d2807f87a432bce848337862f32f599556609186a44e5df1ed489658e2d6e8d9954f03c9b26d1375293779404d580767217ce2ce5e31378722a3fd8a532f179b7600baaa194c635cd20770fd574b88243b6d71b2f79deb03525c66502f15e4dfd36b67fce293294482b677ec613f9317525f6d6b675bfbf50f9ca650817be144c83e771a45adf987e8194159c84afbca4a8a4a52e085ed5c852c2e04e03b83dc185db86391095bc033a8c6c50c043b36b4c8dca9044faee887faa4cc8d4a039ef2baa401b9b447ea253bffa280179a8aaa2abb48305cc3ff2dc980520690460511094a394abb1c62f801a5d367be133ef42649f014ae331a3edfcd436b0c76c107a30f173149099f8d07e8e35db8de47bc38d4c5995bfc528506b06ee00b776f43a16a6747e527e052b420f5aec681f1f186d4006d063407a58856138f44a6b7db436253d1212f8fb5fcff0767cc6cec0d0a656e6473747265616d0d0a656e646f626a0d0a33352030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f46322039203020522f4633203131203020522f4634203136203020522f4635203138203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203336203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e747320353e3e0d0a656e646f626a0d0a33362030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820323535323e3e0d0a73747265616d0d0a789ccd5c596fdc38127e37e0ffc087002b65d66cf1a6826cb049c619cc22b3988c8ddd87781ee44edb69a00fa70fc37999df1befafd82aeae883745bed168318816c4914ebab2ad6292abdd7b3c5f0aae82fc8cb97bdd78b45d1ff3cf8443ef6de4c178be9f8cfdef9d79b41eff7e27a382916c3e9a477b6bc5ce0a577d3e962307bf58abcf9f92df9727c94d10c7fac358c6444e58a0a4eac6434e76436383efaef7332393e7a737e7cd47bc708cba8d2e4fceaf808476784119351cb2511964a723e8651bf9c19723d8789c9b53bb3d5d92fc7471f1392fe49ceff757c740af37d383e6a4dbf1ccb7349952042516e89a64213c6a8b56be35a0d7a9899fad99a19c743055d7bd00fa12432905b1ea6e40be983fb474e7f7b4b48efeca698a0d27f7bfbebcf24ebbd2f26d724b99a9dbcfb237d9a5a3961926632a456a30ccdb487f0d7f44424ff79aa324baa22403567943f48f56596bd61af0e211962948122387f88d1c3580cd393543c44ee6d314a194ffa4b94ef689eaa844c96699e8ce1af7bbc361b7e4975b24c6d32c0d339811b2f3ac7c855468569291377ab592e921a4b98c9a992842159a477f53cbc7859078b573eec938c1454f30a7f087a08138f8c49309a6d607a3f20e909532c59a432f90acabe41cd0e5291b8eb3c8115c06432be9f0d716d7cc1bbcb018cad6fa74c247f4b4f243cc35472877f0de729d36ec26202132d56a3dde4855b59e50524e4a6a8cee79f53e92e8e4670f83b0eafee0c47387f7572552cd726966c6de2f90096e8ac7eb0b9354b59563ffda966718eacd5534e81f9491f6fe1bcc369ca5832996f91982e719ed91a2e9ce7ea6a8033f591797cd809680666f200c1432c6697769905e35e53ae0304468dd0c06ec1a4354292a5c897e37b0713b00df17ca5db79e70899b2689a1e42da3d250d437d422d6c4f44b6bd4c5165f7c424e362d210f294dc81697f527c2bde688c6fdb74084c2a4116fd8f093b8ca2f228328da43cce0e8fdf3e735c50f63d84c835b53a40e76de122757f394a4fc077965e8989323a4f16c3c16c75fdb038ed61e2cc65908ff25e2f009b230b987e680dda37bb43b38abcec0d24be7a4f53d491316945cd8624cfbe4e5c0cbd1b60e4757efb6025faee12f22f1520be259006a4a4cc12cc6cece35a349125a69cf9eda7451b1993cca8dc48b006dd477b28f66488944bbe6e20eda8f2934e0953013f582449309d10f5db623480fc6b39833c8a75bf4eb9756edd231b894d069932242c3ebd29e481580e4132eac45c2c52e3723b60bc73a641d54110b198b6990b6821dd967105d9e49df3c9c10931f1389f2183ce231b3437f07b4f4cac8bbec82e504c5116b43d06c647ca6aacae8ff486657202cbb5a9f196b7ae7071e540554dc9e47fd5a3b35525a8d74a1802b3dc162eb318166806972e09410aee5e5922b999bc424b365890e2ac6a221cd840f0bb5b4ad2ccf852aa8a4d95a0c90e11cd37b83273c83b5fd322d734673e08eaca421da10a94906a69e1538c4109b2b98080db9846e4ae8bce38156a5f5091db2eca5acaf27550ff46f379531beb0b028be2f5a28e2490f6e964389d34695f654765ff03cc7580fd155246fbb2efe1ce35d8de255e1d0dd36a7cdda99095813676e8acf2062db5e80fe6cdd4c56d3149b189514db8722378f366561bcd6aa251d3009ad6dda3fb546cc7c6c6dcbb2ff865c6a83401193f75ddc34048737348b1549e531c4aa575872c634dc2db66888270d60c81ac09716e0f523ca7f9da3426cffd995a0daa11594d335122622e51df9aa5b9ef66d91cf270ab9f456e8f28a3a8dad0df7b58557a7d5505522e58823c5fc5193815361915d57a86bfc7b8c49723e7f16f46aecf85bd303705985839e82201fb7b7e9196f608173ec1f974582d7c380f84c4136e56b9f674710fd6750da7f70d8ad234d14e6a23848bcb499c0ea0509c1a1510e2c545045a1a97a14f2b025b1a96a9089042c96ff66241b88d5f6ca43f5f5d08a9102e0f27f562c27ead7b6a56fb301c7edf28bb5ffbb8f17890f2a72b71cdbd1881dc9596caa9de36d4e67669a8eb233e74dc3a569a63445f93f07282c9dcf81ec553f421dfc35f8b6fa9aa25e84cac4a0c97c4a572b8b63f6303d975ef23f476a1f88442c507db812e544e99daedea770da95c7d3964b7ab6fa6d9e5ea770f5a43a457aedef3f4cdeddad3b772f4917bce4a5a741f51fd86810240b72015e43f72f3510945f30d67760a16735727652e60dd342555b4b69fc117813e9670df4f0989ae486aca1f6ffbb1c89d52c50515bb40074175d18cd43b40817b969b0e745eaa344fa02a37c93f3f619cb9c4b4a380c3c4c0e1c55f70e8cde1005ed3a0d784279e1da4ec10440ee59a32018887195e90149484b908904239dcdd0093336c40083cfc8487c39a494108c652cb1ee736b84aeaf6f0fcf6e4ec34c22ac9b22d50aa05a83c162843990d816ab351218b2b2909e5dc66caf7747b82acfe16d317cc61fe215bf0c622f1c6a5c19d2d3e6f6d04ce230bdce8ad587990c0f17465efcf1af9b7e154c4123f7806704e3ea7272d40c958a0aca2cc0440b591948a050a5feb8624c55a80d2d140196a9e2a2913d97a2023b71b1b4e440b50d1a24de9d87d506d24152dda5492529ce6aa333f33449fde626f4fac70c5f1bda40870d5c2a788687106d275b4140f146f012a569ce130144a581f549bad59b14242bd28115b778bf280e027a2c5992af8799c6e770883a8a2059a2afa79a89e3bc90d5b408b156e0473db907d686db4183bdcf01cc5b6a7bb891d6e3c50b605a858e1c60ad791f341b5d97519bbb86186f2ee8a9b07dd4d0f0fcfdccbeec7798e158c44269ddff7786ea3882e5eccee5244a6a8dc550a74681d1ea9ee5b1ff59af748b5117517eff776885ae4620bd40fd720f321b6915be476b93039b5fbc61f19b9872db4c10d5bdbdf91888def37dc0ba2ce1bd7a02a16a07f99daf2fb8fcfa479ef3afe3649e5dabe8925be20f4b2b02e40d91cf7cdf9a8e65fdd5e0edcc2dbf99e392ea9ce0334bb670f6b1c48817c52e56b0ab063275590f07c882f5cc737d58693ce81802de81090083c832fcd420badfb7731dc6aaa43a4da187ae4772db8956e7f97186be337c70f2140fff084dd00f5ec02f77044d913cb65e6d69c4733ee7e676ea0841701b291b6fe7248537213a0f73df73b0bcef175e477635ac07a120fea169c5a8ccdced59e966da2e40426b652b98fa22ed28b3402611be6b68d4947fe6e42409996ed5d1d44defb2d98a632df5291c41deaa0a2d3bbce156461a4f5c97ef4f70574bf1d20c36fad7dca11722586454a50b64c949f04be8840956794b760b0d1bc74cdb26abf03cbc135eefc5e2df2867f91096ce8ee671eaa8badd63b2a3a9ef3adcae487abe87c88d1b63cf8a4500efdcfc0e4d4b56520413190a5603be616c531faa9ec709ac3bd7db0ed52c6d24725105c3991db2edc6634dff8724f74ce7fd576f149b5e13f722f84eb7cf55f5bfca096e3416c23b7c8bd10aee0c17d3fa157917b215c72fca6f91150ff07aba2ca810d0a656e6473747265616d0d0a656e646f626a0d0a33372030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f4635203138203020522f4637203239203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203338203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e747320363e3e0d0a656e646f626a0d0a33382030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820313734353e3e0d0a73747265616d0d0a789cbd5adb6edb46107d17a07f5818014a06d18a7b5f2671d0d87182160d90d406fa902600a550b600599245ca4880a0df5af42d7fd1195e7423a5d0d5b246b0e66577e7eccc991b9dfecb453a1e45c3943c7fde7f99a6d1f026fe4c3ef4cf66693abbfdd8bffa3a8ffbefa2ebf1344ac7b369ff723948f1d1ebd92c8d172f5e90b357e7e4aedb0968803fd61a4602a24245052756321a72b288bb9d3f1e9369b77376d5edf45f33c202aa34b91a753b383b208c98805a2e89b05492ab5b98f5e6d290eb043626d7d99d2deede743b1f3ce27f2457bf763b17b0dffb6ea7b1fc7c2e0f2555820845b9259a0a4d18a3d66ecc6b3469ff61cab5e561b23314d04d05fa319244007a0beb255595f43efb472ede9e13d2bf9c475334fadbf35f5e91a0ff5b34bd26de68d17bfdbbffdfcc2af79bd5a890b206001f288e6fc96281a69cd7ca22b0b1b4e46af8c1e3c7495515a94c53b5e784cf83e08cbd707b482e28fbbf14ca35b57a8facf3c8ef096f325c4efc1ef712bc21239f316f324b7deda5bef46086f4a669429ebac5c599a53a6ca683ecd58a19864a0e16e3546aa08461611866e2468febdd82b5ec1652d3801747a8435f8789b78c490854d206a6777e4f79b3a5cf026fe15b80d8b3d28b7de18d46f1305dfa78c314bc430af83dc3bdcf788933129fc962c110c9104d706676b99cc04b53bc1c2169644e9a29acc38be4094accdfcffcd09be2decc9be3de51e22b2f898167b9c0e5b4b8b605982f28620e68172b2809cc800ce6335e4c8c1628608c6cbdb9fd5e881fdf2de335e8bfd797801ce4e2358303686f760bbbdf025a98b13a6f8e66006fb2331e1d6a2a4652106d80bb152339893455699c677eb3238df402ca441e4e2747c79cbd44e4e0a19b3cbc462d67f6fc07959e69b850fada52402c341490c5e45419cf637c4033e6ba86ca6448451569032f162d7b7160686837310d5019c3dc4b80e6d3141484da43979eaf34fbbd70befc0d7ada4aafb9efce16180d92d5d3c94f18fe0b9fd3e54e76cbe54869a9d46785fc3de123229338c927e92262a0a4c9108560c4d06048d74614c2d040d4a8ac811965bb66d4b8f0a19854cb982ca75a6f62bafc3acd22f797b808aed23b3ae3575d8d41955c237c47212b900c6a0329a8b698e8f9c12caf5b5618fc0e0e61aec3645ac604a590909b98d023338fbb991579577a276ead4805fc64857a80c2eb316c4491adcc8d411cb2771b115cd56139c1a09469e19b6ff28b3cafeb16d23a3316136d05453b699d598191ae7ae6897bf55aa8bc758da8062e605b760129a97e68f11db68c49f09d86e0559616a71bb5f44ece3d54e73e294af222c5ae8ba2c9b22cbe65b558979e5cc5712cbce7656190a7682c1c0a6f84123d5ccf5b6f8fbb2dd39584e81ef79b8d17a523b9cf0e422a1ab21afd35b0296bebe347d1766a8645e206a65e034c2e3a4f539b46b36454c1d4426dcc65ede957bd9acc0ac568389ec679ac2d4bbe45de6a16ac5b95f84f9174d95572b79a8185c79f1eec730f0c841215ee7cf40ef76522c71826dc696e9fe5dbeaef4b36c22f651f4a4717edca213a5640b5c7c78aa8929045ddb11c63044d221f0226326ebbcf2c48a8f3c8fbe92b12b105ae7146a572a8967d766dab7f29c8a642a834d443c9e6a2813940b62aa8d6c85615b5265bc62bccd381771f2f9231665fec95559991cbfa73b0fae2b58a935889b29def1e93c897c5cb9df9e51e7ca33d2b43e9788071339f2cbcd36ce36719940136faeb37b836df257b7d1fb92f1625b75485354a73ef6052300a4bdd51611f975bee2d15f4b97c2b1d5d000bbe9421eb16d995577cb1afda6bcd0d565d552cf5bdb93221d5864888103feecd59cb8db0d296ea43a06b41b9684df40150506a18b6153692dca4a1b7605045fffc19bfde0db0128f60981a189efe05433f81e126866132c1158fb040c7dbe10d0c33acd04fc6300c7059822f4e390ccf66f933acad60457c0ab72f9fc1c00218021479826bbfe130181ec5a0ba734b60905235e76e620c173dd92163406b61b718123a3fbf3194d93a514dfe1ee4a27d39747e217640b924234eb9c3c630852ade781caaf735d7b2c4157ac3e3f273ddd9044e553567ebb520ca52c16a441d97406b452999b9514554131ab9e8380fd188b39d54cb68fead21f49844d32397848241634812482381e127c467014eb1165704cef5c683902a5303b189de5cf46b87f48645ab71e67ef7701ba1bf9d6af76a94d0219b1ac44dd458769871d2bbb874af46195acac2b6a2d82318ee71d9e213b2f6043f74659f8d07b862d8e0f8b2a5e30b1e52a16a8edfc4262e1ab14336b11a23e3faefcab02f3ccefe970e734f4f1b5263ab529ba9c2451d7f48154652e928c9b6141dab109be8ade5f25d6ae8201e1cb25bfecb82848c1ffc5053ff02efed68d50d0a656e6473747265616d0d0a656e646f626a0d0a33392030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f46322039203020522f4634203136203020522f4635203138203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203430203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e747320373e3e0d0a656e646f626a0d0a34302030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820333634343e3e0d0a73747265616d0d0a789cc55c5f6fdc36127f37e0efa006014e2aceb4f89f2c62f79ab4097a487bc9c5b87b48fbb071d6ce02f6dad93f46db87fbac7d4ceee13ec3cd9092562bd26bad2d6e8a66bd2b8d34bf190e87c3218787dfcd1693b3d1e9227bf2e4f0bbc56274fa61fc3e7b7bf8f46ab1b8bafcf5f0e4f7ebf1e1abd1f9643a5a4caea6876f96ef1678e9f9d5d5623c3b3ece9e7eff2cfbb8bf579212ff3346d3accca49584b3cc084a2ccb66e3fdbd7f7f9d4df7f79e9eecef1d3ea7192d8954d9c9d9fe1e529719cd74490c1319374464279740f5e28dcecee7f0e2ecdcfd32d5af17fb7b6ff3acf8353bf9fbfede0ff0bed7fb7bbdf97b5a6605913ce392309329c255462931a645d78be87661ea676b619c0c157413407f08275e82de6c9c53a8a4d7eeffec879f9e65d9e19bebd1141bfda7673f7e9f95872f47d3f32c3f9b1d3cff6771bf66651915a414b166d5529352751066f8729e9d9cbecdff75df06bd9db311849b5b38bfcd0f06e767cb4dfc86970f8c46a85bf9bd1c170722cf1685c9e11bcfe78bc10150c10863bb13980a45a8b98ddf37c3f393b4bf7cee5663ec8268939912fa2445a6c8edeceb78c7a303743c71bb3fd58213c52af431e0314c6c004c7203264e49d9c6f4a42cd9f3b214025ece8f15fc14eaf840c05fc98e2dfe29fd3f218e29c3df14be6bf867fc6f78ca93eb63fc039739fe52ee8a6e13c05fee29a8c4dfd2ff762f378e9c9a16bdd0c7f8f369054797fec5d68315005a7a5ead17b69f97a6020bb7db38403ee5c4ab65a92e3f73109c069e1d53de22a1d45d86173cc4ce6396c2e15249c356e963293cb1f55243f89690446248a524d2b431bdb99a16b4046807cc987c86def673011e775988fc6251a87cb428a8a9ef8f0be78c75fd7b5450919fa2b3761feef61c1e9a1494e7eff06517e3423a6aadf39bc908af57cf5e8c80457d67049c598ef765f3dcd0a6028c8891111d3cccdb4759c1f8cd6884d54718d2961327b5006d7b8d2e401157cb196a703a2ea86a3454eb0ebe3bad8ff063090dd234c07bd4d518b5b6d22a6d145edde5be5da7934fd894b3fa6245e45aeeaab0f9e5255ac2680ab7daaf1d5a3795292acb885dd30d62fa0dc1a0013a544b3440fc554b28f26f10753e9f546a12f9e382b2fc5bbc9801f1cdc83d835fcbbf16c693343a413355b9b77827e20489277881f9fb6d0317f9cd67b457a7b0c9d9a4e015169e93e12dc67252da88567a380d99d66928880598da12931a06135b0f6a4a85418d52104badf060242e8c8bc4e983cdb5c3902a224597e14303f0900d034dab90cdd0d23081ee28607352882acec60ff446ee4b365fceb20b178afbdfa770e7c3a83850f9ffa6d045c6d077e6c322641ce60534b92218cc38290fd93c2c0c0fd9c01c8347d874a469ac1a6487509e237549f4e6c85b27eef392132ab6ecf326312651a2825a9816c59ac77e48e3c5227e0bf31f11e18b31351d3c92b59ad03226e51f19f6be47830f39b4b4205f84e1e36159411f805e80ce54e0d816f2db49f4574d8843ee8f7c2804a145159cc2b80fd1901bf54793267268851c55e4aa7c90021e11c2030cdc4c8a4812f02a1981edc3b6e9a28a48a6cbb10f0b958f6c5c1837c7f07c604c756b724a89b25faa35b9d0c4c6d4327c0b70301c4e23ac2acf436d65346020b48e9c0707613429f5ddf2c6dcb24dec96194cabbe845beef24deb960329a7a9dc325e8a314ce6965d6632e43778478e3526950c2d3ad698a574c9a93aeb44bff739a5263b657d76ad4a82b994d6339fc76a48d431ad3353780db36dc2e5ea5ca6ad93ae134fdd1d5ea7b2aaccd75a468c7a0c754a2d9aab53ed549d702864eb8ef5afc7ac59957b1bdc599412b30f618bf670167488b5944dde82caf560b8e32cc0910edfa5e0012922bc53f5a8123c54c86d37610ed7ce7b7499fb2847e54709022b46940a39268a3ba894c4c694ebb265cbd9f0f2612e8f2597cf71d26e7edee5140f4cc57a5c9a44d98c01141dd33666cc7c622c6dce5641d41e69ee0481364cbf31d0ee725af74d9f51d873d70217ce71b9e981caff1c3ee2032065044fb270deb8cccb6dfdca2742d3b0168ae888a4c32759b9b0c444ccb9cfb89878a953958c70f9a506c68079da913160b7d3a131e0de6400bec2f9f251b281cb126ea2c2a71bba34d1118e09862e5b121b63e5d76bbae3569ac10a5c1886bd5fc6ba98142ed9bb036533a95dea2560b5ee2efc0a173aeeb3b3cfb3f11434bf687258c956f81aafcea9f3ea7173a73a85bd73e86236c6334156487197150a582518b59422a287654587ad2176c36c18b6a4b1d8ca5b824abcf1426a49846e83fa19fbffd3c2366bc826ff6eb1706b583c9f761781ffc4fbd37195e4bd767e6b5ef8400f17ca97ef2e267877d62c30a3ff9e67e339f6274fdf6c8c707d321b616ef06634f58bd3d5e5556f1c5de392b4f3909f1cfd05beabeac7c8f2bade98e1bd680d7dd9ac4fcf33a03acaeab5fdd5abbf3a8a74f268abd47b4fae2f0e5ebd1cb05504445d32d228a40726990a134e5a5904544c51bdf9016176f86a855e5580616a6105761645ac0517298cfb284bdaacf1f52101acac2111b85ca80322c9c005b65ea3ad0ddfd48ba846a429c6cc1b416f22a9407b92cda09bd76c02bd99a841e47ca54344615e2782b7d4f7dd5bd6495edf6e8e3a9139d68e4bb9a5862dbda9490c4a18a2d740fd00beefb7da89b94d43d7edad5ea2bb8e1e456d13a1a654e34ec010755c95abdecaca0a4423b7265482c91276f7723ca3891b814becab5bee84650380521b4031898b522d50cbb9370b88f6290c517f7b8fe3d43bf880d85be7530d1fdffc073e1e9fc2c78723bc3bf7fb4b2c4e0dee9688279288318689ae50a23e6a1e62e0dca466ca09b5f752f3c26b58e78b3e720c31d846955b729c1a85721cf400a5928182a8444740fd9181be1e3d868fd30ff8ad07c62186852846c989a2118c7d5ab319161607af4e125865d91dab7a5be5b8d6ed55b583d3e6dff610c826128851490c8d08d4670b799956cb02e657626d1339ed018aa6020523a28981eaa329965853004ecaf45e92f35466e8bd6428470f2fc9453250ce4b86a0a65b7b492e5361f45e32c4d8a735ebe165b238f8318555c2fc47dd2f44ba9f97e43a914095970c05eaa3659358cb68016ba0ca1ea06c2a5095970c40f5a9ff29136b0a9ed0f7b3c7b697748b51b60ae31f61c21963f90c4d768e247d6279415359aa718bd6a1a87df4cf12eb9f59ac78de9d3f103cb13f0804eaa3659158cbd46051e076fe40c8c4fe2000d54753a9c7a7526125c4f0fee02bf838ca6a92393edbc727241bbd2cc5ed0da1b87dda20f1e8c5ad20ec7e91eb3d7d42aa91aff209a1407d8ad8128f7cdc30c2f5963329996a8caa7c4208aa8fa6128f511cfe8afb8d513dc0a71a8fa8a6b8a21382efa3d121c6a30dd95b2e15f68b2d410d54d6192da1e482e16eb7580d254b5343d9e598aa8832e493a68a32e4d3b78cf266e4564ba03739ea252e23fb3bd3e5e567a49b4d3e2e5354575a57f6985c43bca458681ff271f24e17934f6e3f8e9710e51e98bdd044da08fb81cb3bb13048c7f8c4eb3bb9705ba498909851b97345490e54417dab4f82c05d6ded2813979d72f015766d3c7cf3fb147bd2e8b771b33de3c1cd185933842e1d61ded1480352ba5812a6f7c6b5239e03b5b1291317c6f2f23ef156e2b2308cb8d51d1b5a9b9d8fb4de9ad3daeb426577b3cbaca682e770e38bbfc886df5f4729ced44209fa9c7b90b87e866943b6edb52af1de65a6d4fa4137dd7635ebfb9d8c686d02649e4433dfeeae4d6fc6b87daade2c05e4ffad4e4999b58f3b81479a034ee6f8bb6c767aa2758cde5d8c5735b048fd4b8e37af8be69c1b78cf697de0c8fb7a8755e7a1b5135600cae35f8a06f1d5b23a3b270aa596705e792e7878bac4175f7e9e4df0da4737fc8f5da0e0f901098034cd9eb3e12b3b5aad2679e7709af9041aed72e98ffd9956c79d5c561b47015901c886dfde8827a3f1089a3e869d787723165f9bad4f3e49bcbb9131d3398ee51fd04c9b37080e3f606a9c6c85501e1cb186ac1843f3083825d8c3ce2416b285ac12041c107cb118ab78c4c198221ac2082204061cd44298b229e050898f11c33c8fdcf6741095f8982256b24eb9eb832798212b01161263857dede320739980a7b10402bc084f3f9ce166bcd7d8d3f1180a1716819f76a7610d6fb4ae9e380472e7c119b23a9babae73b1393d3aba5955d02509e284c1f94d88b68fa9269e7b61b50cdb8da986acaa8ded89cc34e4e7cdf467881dae1699b758086b7cece36c16ecd54551c3071612bc6608a857396d75b7b2519c6750dc49cfd7ac3881d52a97100e41f7b1dac493738a1b2c7663b45d4e177e2a30b8cd7262cb083b30d9c15981ef8c49f6723cc7f81f736169c2346e42a629c606884b22e29d606f7227244dab7953a2739d7621a37489df80d3765ee4093abbd44ea4c4e586bb5412f521895355140b3476e343ba9caaf284c13bb67415271d76d901bcd708e956547ec95fa6a8dcc605c4185b2e94633b9e27988dc1a55285caf587cc9a55126fe68361f8d51dee9386a8ca4da80278f789509fec62b887a8a9a421de3e3d3571fe168f75a166375d3560755eafa025e8af1a2c24c6d3c7a92f8ad609c94d1aa531ed9342a41ece2c1e9218c2db1cb562fe70e24bedd70eec002a7abc033bd61cb7dc85a87b18b24e9c31a7dc12a17663c801abf3d561dba9265c014f97417e81b6b0c190bfa08fd60a9c5d08bb3270f0c233cc3fb763a988773ede8577b61a178042a87dac3af19a0b656afbd4b44e9c2fa794b93bf72dbc5f5b6b691d862fd61744547eb57ce7eaee27f5d9f02b53f6b5f8d57a4ab5e0e8aaeb47a7be3edf17dcdf8c5ae761a8e618feaa1adf9dc5ffa9b510247c9ff84bef7afce1d7494449b1763ad4f17dbbe8c7a65c1ab7b4d0a67edb9544770aaa3751f80a6f4fb12af05ea3f155d7cd4bead2edad696a34a52156b50bcec5562415624fb25693de2d145fbda6556ebe255183c8fafc7d55931e14a5af089aa2f45e55e93af182933544de998bfa3fce1b01020d0a656e6473747265616d0d0a656e646f626a0d0a34312030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203432203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e747320383e3e0d0a656e646f626a0d0a34322030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820333337383e3e0d0a73747265616d0d0a789ccd5d5b6f1b37167e37e0ff406003542a207a480e6f46dbed2d29ba48b1e9c6c03ea47d506c3911204b8e243be9cbfedeedfe8a3d8733234b222d51e3394a8380c948a339df393c3c375ee6ecbbf9727c3dbc5cb2afbe3afb6eb91c5ebe1f5db13767dfcf96cbd9cdef67177fdc8ece5e0ddf8da7c3e578363d7b7df776891fbd98cd96a3f937dfb0ef7ffc817d383d2978817f9cb382154c7bcd9564ae14dc4b361f9d9efcfb4b363d3df9fee2f4e4ec8560a2e0dab08bebd313bcbb6082d9823b5932e578c92e6ee0ae9f5e5bf66e010f66efc295abaf7e3a3d79d363fddfd9c53f4e4f9ec3f37e3d3dc9a65fdd2b7dc9b5624a73e998e1ca3021b8736bf765ddf43833cd6f1b66020f35741f417f0a255580dc7c9a522ca45fc35ff6fc971f183b7b7d3b9c62a7fff2c3cf3fb2e2ece570fa8ef516f783d7cffbedbab57cbc5bad816f6284cffb65ef537f50f6467dd5bbe98ba277db1fa8de64d4d7801e3e3fdf6421855c102117c2f2423e869c2581bd5aa1923590f09b4608da71ef5869b86405b7158ceb2fd36c29e20e292dfc5bb3b583a30d4c650798cc0e4cca70bf0ee96e51e986efcd45dff6bebd8266f4169af1109aa985e6fc3fd03cbb87663881e66bbd9f0b4dc4852c149722e62243b08658b052a32ab791ec12bf5840b30ce3f119fce21e6f99647065a904ad4a6e6d82abc17e4c8e0a13dc2a540213caf80303896568a6a702674cd0cc085c46278a2e3cc32edd148a8bb2956e8ea0b97c0fcd6ca59b7fcf60a80b879194b2d0dc890443395296c4522e0497661d549101aa0b1f940465b97029503992227642c679ae5c2b7d9c42f3f66b68448e7089dd50cc478e70891d91819ed747f74382d811455c65f82141ec88224cef40624bb652d31cb191b923a7b948882d03936cbcd1f57cf0e25f040a6a3437ed22a5fddea83b1f13c3cc919d20969d56dc6e383ed139ffb5e78849e5f02f89f9875fd87691cc967513f00bd1b6c4b14379a40ce32ec2392020e5b0a411939a6c9aa1ee0957a16e4c38474114b18248cf9df9eb1b9708668eec4a62d9098bb593a3189788540eff9a98ffc270d14a753a1793b0029d4f8428474aa60329eda86a692fb93ab4f8226d37a0e4a694403c52326d1d576b510e838796a05c976f7aea69163ea6280c562ab7293ed5bcc7746481f621a6d3353fb2e4da25e85cf451f107aab7c0660957e13f6c71376793110e8beafa7a7cf97e0cd7ba37c7d2f2a25b785281ae597a31486578e11374ce3ba653165ca6e86cf1b3526cc38d650252a0c2ec2f674b473cf2212296f6d091ef894169c9f5862c5fff31457d1d7e1af5854c4e71743273010327417c4b222b9005f79e958a1b97312dd14502b64b64ca737f6856a8bac86c768192964bb50e6ad9afe6ac1618b93f79c06fd2e50afe00712fb82a53c467b768d3feec0b346c60e886217d003477f3ee7509ac8f4a8120625a40ffdb04b9e90c4df8cd5515f400e760dcfb03d97b3fee8baa2b0878f79e1bb19ff7a44a76916cee524918e3e660505d24388f765d83ac809f89cdbebb8130f50a55153bea1aba4cf52eb127d13d1b8a9e53056a5184a463a50d9482ff8b49dd56ec82a6de2d81c760eaffd7afc295f9eabbf0f1ddb4d1e170793f44df10ee8158be8424b99a1217f5537eebf55df5f8704fb003419ae17f57d567aa7e9e79903b5e3cfbad0f5d111e33bbc311550380a7db7043d52d43b87d8c1fbaea86ab35c0f53dc3798019fe8f3cfdb7af1abec02cf2ce055da29b4a69578ede77919cee188ca5f35cec4a3bba20857a96412ac97f17c9e92efe2116d41ba0fe094a70db68e29693c2d14f30e4216b87ac3486f2e4b03f262521f24f5022b02e52736312a4088246e971326e2f57ab2ed7bc504c3b0e21cafea89138ef2f8de2eed0e85f7594f73f0a4a0b2eba4dc45356c19814a9eb3ab7108d53c1425118876330d6e1a3c5b8722934719c7068ae636053840401815b0f082ee1922c168084d62680108c56273116380e29cd4b9920159c749d9504cfde3d6d099656a524ba0ac943e010b40dc3852a740f9737c349f7701c0c379d80d37d0c225d89a5986374b0742064b59f54d2b011d75a4a1526778e62d82252578d5a9d33301af7734c85c1a635b13418354d66d32466e4094c9bc96994e184c1d0bd051058868bc150189b9297e648a4c2b2d498d451ec9ac7d51c31ed7913c83ee474f3a6f23c83ae164de2d33922a3712d478c88c0b419c7a5dedfc7497bd39451c7cbc1cf1704f6468679c9c316d8940515a8da3245a05609fc5ad495304f71cc95842f28e0af5b329160a13664d86c4467eb5e7d3f74492479e1c2c4d3366c9c52d3a50d736a2c47b48a0c9fc509ab946640ff877d0ee305b8a7aa78bc1f674984538a320470114e9e014a9381b2bcf40950393d4a9d5e8ab0a4f228014f44aa8ea31fcde68e12f9806bc474230297cce6e8cbbbd673e112706872ba24e734399d4d7135c4f270e8e37a6354e7cebf00ca2a41f9aaaa323b0873964dd900fb78bad2c4aa2ebdaa02dfcd09a2206b7062fa185d2041b18c4e90ba4519dccd9b42fe04f9ff02ae426d7f3cc172395af6b5993806d2f880e2bb1bb309c688c369bf1e160f95ffb5aafee2b219d361fcdc36012641251d6e2d53bd9d6369a96b6645815ee028963622f53111c01dbb6c2615aeda8fb11dbf6ce6c23696180985e1335c1f8992c765a131a9219b8c28ecaac7602626b7dfae3eccea553601ed4c3d7342936a428e2f5350694a5b65aabf83cdaba625513658e4997c81b9c7e356b699ccac2ded83a3c489d3e92a1059a566eb06176fae25ec7ae3db2585a5f5e9d19c6369898b780a7ac1daa358da98d4a7c6917e8e225e812620c6f4798a78054e5ac660284c9fc2e4f938a42c962663524708642dee708829ef37b80f39fa9f4d9c56999de078a7dd43f505fa8663f4079e2f51e804a9eda876b7b15d791f34cc6d0cee43844b626c35ae47df2bcfa4ad255e07aa6cd8f076145b1b917a09c2379fb376502d178f817da6da416d7223383426d7bb04a9a34c669830e623da9371bf9ec300aa610d3d0ce13fb017c23ab3197c2f643dbc29c24ccb8d4fc02298d1a80decbe8e4e19044dbcca59198921f0510c42446ac1ceb11ed1bdce417295a698370dd2a5c1912601e3e0d98d8ecc4d21136068cc0d641bc7216542101d91da3fd3d1896d53e1bcac23308a66148fd74a305a95e7823a4fab72e060634f80a9f2d9e1621500dd87b9e295ea51983c8d0bd6f70a2669f288f75028c885ddc1a08857d12b6571827d0dd4a12792753198aa83c6622ce995974a69aeedea1431e1bdddb9f652932cfa5f93a12c7979681d59136f17566022364b2ef35958f48edbcfbf85f179853baadf8ef1dc30dc886ecfa1390b1bac6f30df3983666b87ed19eecf7f8f3f9b4ca0f91b6e629f2c9ebcfd27b911db8b60e022260836eafb902fc5a49eb6502f454a1590868a04a91c7d69a69d6f9783576da79d77e94b21d072aeeff09a55735abe3a588e651ce9a30d1148dcd087894404324772965672124beabb16032641392a50d516fe6d50b84404b0e20a91f9c70c789e081ec24ac0cb929929884079c345990295b1d6c7082a952f2406b33b3a72902333493b22dbc94c5181aad6a746321bc083bdc9175a49854f29dc13100b2de7844c2a0720ca02d792c4a0043a78881a202408017d7dd90411ac720ad05c43f3279e403ae77889b142f8adc46fcf05fec2e03c15de07d9e6c343f7334de55094056e75cb9ea0762876fb64da1c9da576285ba00e742886daa1b49199a5762811a80ce368a91dcae31d99631b2db5436925336a87b22db3031d8aa5762891d0720e27a6762811a8e014ee30631ccd1b1fb19563261d4a062f2b3f3119bc7ad9e5498dd671af52bc5427d4ed70726b8c6630608918504ee3e126ed34c411816a1c9dd1a8bdd4358a255ea6ce2949f2eca93a02927fa1123ce79cd95d5081828f944d80fa184a7dd720d6c375d9092ab456e1e16631da8c7e75925897753806835a9747d81bef317c66cfa0c938eddb2932dd31183bc78ce7f44649dc1ba54417b4062aa37ae53415a83a848e40e5488acab3359252c516a8cf6f831d9933ac6d70c4738e0da672868d0d8e406dd9e0b54c3c032d991bab6d70843603946fdcd8683178fe9a409785e3ea2f6882bd20e2bb31c1db7ce7f405b53f2c0c6e1b3acc027b2a5fd558e008548ea4887d95c0975fd147c1a34f989864d4dc3c951bac67da627e733a81d80de22e37b311c5e41e2fbc21eb7032f57e66a8fc1b6eb7d036c14c8e84a9fc1b1eaa0d29740c0aa7169b33dff7c3a37268b20c87b9c4f072de615150256612cff74f09ed63fb1a8328c812b3ca0fb5d23b51107b2201ffda56efb36931b44541e5c29ab11d719325632a1fd60cee08154ab739afdff69ee5bc96aa20733cda73df5a74d49e07df8978609c240a2a0f52074a11a82c4911970b45695bbec4afd540267338f5408eb8c991b1207338f5408e501de4a585a072318d9b8ef0e5b86941e5621a371da1fa989cefce4add8520aed8b5d4bc92367917aaed2b3adb8ceed5cbe7bae6a619dd113759323654a8ead11da16ae1a6572f93eb1c64eda6db89ce11aba7dc7ea9654ec4bd7a835ce7a86a3f1da1ca7ad526711d0ebc0097adde03d666284baaea5a3394236eb2642c3b40b563d1b9b7e18bdda0fe0f4588c3e20d0a656e6473747265616d0d0a656e646f626a0d0a34332030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203434203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e747320393e3e0d0a656e646f626a0d0a34342030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820313932343e3e0d0a73747265616d0d0a789ccd5acd6edb4610be1bf03b6c810025836ac5fde3ee06e94fe2d8418a264d6a153d1839d0326d0b9045479482f6d267edb17e8bce2c4999162999b2b9468d9831c9d99d6f66676786e4377c355f4cce93f182bc7c397cb55824e3cbf48c9c0c5f678b4576f57938faeb3a1d7e4c2e26b36431c966c3e3e5e9022f1d65d9229dfff00379fde6807cd9df8b68843fc6684622a2aca282132319b59cccd3fdbd3f9e93d9fedeebd1fedef0881116511593d1f9fe1e4a4784111d51c32511864a32ba02a9b7c79a5ce43031b97067a63c7bbbbf771290f03319fdbcbf7708f37ddadfebacbf90e59651c98850941bc2388d0963d4989a5c27a1cdc654632b639c0d0e3a019c60e6687c12b0a861c463748a48d2a855679bbb3eb97fe4f0fd0121c3e3eb6486cbfffee0dd1b120d7f49661724389f0f8e7e0b1fb6c012c0df01c7a298724eb4b294b578441ae711f9d065dda495c554c956ad27c1a0675d1c0238dea0ab6fbbb8a4ca6cd075908532b83a85fd1a0e6430c9f198cd085c3c4bc9228c83341c8820c7c3022ee6fd42e342d3583d8d1b38c809bd41d78bbe75291adb6e76b95bab88d75472c284a5328650d7cc5aebd49d3f6fdf7fac9ffdb729c16a1943062a4d6843df86897bc624043aa986e9dd9460dca62144ea22d480310eae3164b33c876b939089e014cfa769c8e2c0099f8526f816ff48be868c07d964ee06c20537728a63963984bc1b8d532fe739019931cacc516682fbe35fb8e3ce9cf69049a7fdacbae266c49db302973f3aae5b0a88a09cb5380695ce10bf8331ad2cc9497e1396862608d91990ccc262933b6177fd6b3a06371583d35021761b64f0eb86de38d34d90a0592b0f558ab28b70a00aef7d41e965eaf2072be77ff48e6b784145cae5ef86173a84acf01cb290eef58e90a4674891a6d6d4313dbac43555491ac76daa3208010d215045e6af2153c1efe180d70215c3ecc26db32f103a7d436320aadba0755819e57765621cf8342bd35495105895a8588643d8b0a32a1f6cdad3bd2f0cd43ea8844d641d1626f6bc30067aecb88ee91bf282405afc8091eb62f8c35a0c3f81bf2407702dd83af84b7bf617fc1fed8ac978c6041d9690754c18e57f56edc31506ff75d92a285f958a318d5d55134bffad01e6b9b883aa957b14d58640d7c7b1fde45b7b4feb79a9a444e8bb850febe38134de020aba8b3b957c9917b16383398336e8a733ec854ee13049e030d37078f1371c86391c2e53384ca738e2198c205fe134c1c6f37b1cdb7cc27f2c68ae048d5913741747564f16d78bc1c7910747728679ab2f4fba16146f2cb0477fb6726c174bb9274bb936d48a164b071d40095fa08ca24cb7809aba272717875d9c263de1135c50c61ee834e50d94a5423540d55ecf255d7c16fb8287a24d78dd7ca6bd813254b42d24ee70728efb7a0c87256eda14b72aeb00d678022b19a3ccb680edb2acd673a68c2cb5b2b74c89a7e34b38642e53fed8e17d4ee42b1729b04cb718d8e52593e7faa4aca191a883ea109fdc5729d19a32d306aa8ba77c9592ca5326a64cfd1f2a39f75594ca4adeb4b44382e5be8a5259c99ba076abe4dc5b552a2af9c39ce6ad2a15957c1d54ad92675d7ce6ab0e9595fc613ef35587ca4ade04f5884a2e7cd594b29237c176790b5cd594341f1c1e7bc8945a52dedfd3e3ee955c704f069695bc696017af0bcf5e8f3915b60e2aea004afa025556f206a82e9e529e3da5a235500f8fcffb8d897dc522b4934ab718d3c5c3ba07505bde69291153b36b03278c2f509246f1434159cf9ee212bb871dbf99f9a4a3287c4c59eb194a2a8af2434559d7e88b86d2d4e38782d2d47384f493f995239990e4747e83df4f2e6e1efd99648d8e1149aab57f337964a8b42d7afaa69720d9ab4dcf9a3dabc0355895f1ac60956c7fad2f3d734aa48da9dd35314bcfa41269d63b978ff8e92e5be207a179458248a610aed39b50155fa653fce4e7b813b79ffc1ca7049911e330aed14496f3146926df15c27190cd8acfac2551c5b127508e14c361de1acf04e79ddf324a7aa78f48418d6d71418d2e7387c2e2aee4193407d5ed25429c55fc92c257cb924e325fb9ca5d3fc70ffbee1a6c7b2603dabb3d027a2cd8174d7bbac499672688d48cc63b83f2cc0591caac2592b5e5ee7585a8801f506e1915b24df9b82021e206395b6da0095ce89f6b203023361178f80e8b3d166f51e518512d49639e60bef00044f336206400131ba95c3b73e269c599c1d72c1b571cf2c2ec6c82a1e763b139e7f8baec29169b7345956851f5d9832a8b2d475355ff69950b8e1f93ef75606b06f3cc9992c858d8f511467ae60b49c1f0ad710d94a307bdc677378e5842a0af78b5a8d893b32acdb19242f40fde9fa5a1bced1392dcb15262b75996a7d349ea0aacf111c44c235fba6944c9044d732ce9b71cd2f18a824b523085997acb82dd51b26a01c6ab06e86e7eaf0c4feb44d442dd8a37baca90e801a7f3127de0c8e9fdc7bce41a7b88a6131eea6f108c25b558f7a0eb827c1b517886c44314b1555bde454451c95722124648dd1052901d6c6d1a6d6d73a64e4215226eee05bd4da4045d886c07bd9a661be8ed423544b07a0e11830751de324b71dfcd7257e4d3e6f4e1993e2761039a9d9f933cf3e764a428df199467a698b01cdff8dd03ea3f79631ede0d0a656e6473747265616d0d0a656e646f626a0d0a34352030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f46322039203020522f4633203131203020522f4634203136203020522f4635203138203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203436203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e74732031303e3e0d0a656e646f626a0d0a34362030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820313831333e3e0d0a73747265616d0d0a789ccd5a5d6fdb36147d37e0ffc0757d900a84e637c5a208d6b44dd16105da25db1ed23e3889e20870e4cc9687f665bfb5affd17bb5796b2d8921d5a1181062dfd21caf7f0dc7b0f2f298e5ece8bec6a7c5190172f462f8b627c719d5e92b3d1d1ac2866379f47a75f6fd3d187f124cbc74536cb4727cbf302bf3a9ecd8a747e78488e5ebf227f0f078c32fc4b12cb0923da692a054914a74e90793a1cfcf58ce4c3c1d1e970303ae68433aa0d39bd1a0eb037239c584613a1884ca822a737d0ebed89259305fc3099949f92ead3dbe1e02c22f16772faeb70f0067eefe370e06d7fd557384e1527525391102ea8219cd324b9d7cfabd3f6c1d4f7d68329c7504227801386797a711671de18c4636c4aa6286bb5d946d7c7f21f79f3fe1521a393db718eee7fffeadd6bc246bf8df30989aee607c7bfc7dd1c2c080730aacdc1565bca4c03e19f1d1dbadd5ec22850b2cddebbfeed59cad5567b5d0376654fb6d88350115bf97cc1d8113fec7b889c31b0196688edf61495dbcc9dc42e2ae6b18a9617b18e8a657c20a3796ca314df2c087c77119b68965f66a85bd039872b2a9a4e63aeee757ade3b6ae12c4d9c274be5a5bbd450d4264488f2468e66d1ded5b3f644e53d24aadaaec456496a4485bf0d7a1b26d10f26b11106a60c3be1a832ff03422955c94a4a1f177bba61911baa55c3620f69d51c9c90a01b4d538f4ca7e69084a189691d92368707125ed52bc65e1e1d1a7cab0e0f14be1ec36501ff35762b2f97dfc32da6ba43f3aa0bbc32c9187fdd2f41826b9af08709ba8b128b49c499a33a8110b1dc39b7338f64e03cc258da338d540529cd0ffe3809008949e4e81ea693af7901523afe92c65c004210cae70fc3d48160721055dd82b29db90f77784c05e16e9802230275cc2f126c58da0d4cd9dc63406b9892c0986cb29156d995072a17021595f087d01c75aa0d1a86681ac3c45d3c8c90b340c4c1ec0e75490b3a0fda380f95312bf1eb064a8402055d4d57503214280bd5555750a17459c05a4fe98ea0eea9f0dba3000a6134b56a330daf5368721f782604bc5a2a9c5a4945036359fbdfc4497433ceb1e0bfc4821fb5e353141f886881df7d8a3de0db40ec720dbe162dc87d384d4281aa92a313281708549d1c5d40091638397459bdafad491887dfc055c955e601908702085567d204e8c79a08155fd534d509940c05aa9aa63a81528133b113a85033429d899d40059907ee65a262a8a77b820aa5ee3528588c2662efea5a04d1f7cdf2ba816d9ff25a8452fbbabc6ea0f3e04d8652fb5ab73a810aa5f0b56e7502154ce12bddea042a94c2d7bad509542885af25826bca3b57d73288d46f56d79b10fb2aae65d0b50156d8ba053df70016acea370ab7801a987c5c5d4f0a81f6290d1354ae6d54a247a78b58976f1eb71dbd3dc444f994ae69fca11883f8e23c12fda22a3dc4cba86900f271910beb229d386ab5e76aa3bf35c4a659bf2dec3e9e23efe202271ab92fa8c0cfcc34a4b75c4bec3720e45f703b1d43f726e62cbac5409ea690566ddbecbdec9e97537013cb06417798057a574185839be4bb9f39aa9e1ef06d2550736af7554615f8098e9609756eed71c92cc369ba7420b8929bd5dbc545eca239fa37bb2d50b456df66e0ebf114facfeacb8b05a85b96cff0614b4e17f8724dca0b4be896fd338eb98cf22236a1624440d744b78ccc876e15986e61a8dc1b94ee0194d9010a666c65ef83faf92774cd085c7a9ec536ca47d09c8fa1595c3fca5d6d20382c6ea16c6882f061c6046686c90ea06c5850cac12ceed617dee82e02ee3a23e0a4a71c9ac7d534ad8e129cca36f307014c597cc2dd34352970681a9bcffd5b3570479b551fa7f751c1ee72ba751b934771bd9a7a1d2ea66c945e40733d43669e4033c6e34293253437296670c9db02ef58c21db7dfe1e31c533bc52e73fc816fd8e827bdb32a12580fd89601f8b0da47d1b98b5503abe6b5422b9d96d31a7094fab29ae11d7808ebaa85d519be23786182fa39ad98863b34dcd13fdb526a0cdee6c03cd8d67d94b5bbd8d69aba8d12bf3a2ffac802bfcd6802d2dd62d48f89c0b5b452828abd4105ae4f9570d4e8f55230c7aa9ed4357e59ec7f8f391e3f4425c1220ecf1f96c76acc6a19bbba25c74d9eb21c1cdfd58a015603892a0fc13480fbb019b8b056dc50b77706f6517eeeca4066f01cf53d50cb453d8bccb16af8e512d5eb1c9a0ce52ab7d03cff179ad1028510456f5a2ae4d3fee7093cd5665b20f65fc9e0b13bf04dd314051eca9196a39fa2eecff1e3a2ac82f1634e575570556f71d6bf826357fd300fadf11378a5209da27c2da86146042a2640c5f206432787a6c0496e8113df963aa39cfd02c54f13a20f6f81d71132d9d4fb1f2eef9a1083e55dd3d4de79d77ff85485d38334b4864fe0159f845769bdd22ec3775b0ad18abbef13ac64a758977e5bada67af7b376d4d916d83e5c065e48493c9be47eec546c40f4e12df0febc540a8faaef07ca04de28975250f62053ff015aad65cc0d0a656e6473747265616d0d0a656e646f626a0d0a34372030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f4635203138203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203438203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e74732031313e3e0d0a656e646f626a0d0a34382030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820323530383e3e0d0a73747265616d0d0a789cd55c6d6fdb3812fe1e20ff81d75ba05270a1c537bd6c8bf6fabab8c32e70bb0d701fdafda03a4a22c096bdb65c64bfecefbdfc8b9ba1244736695b6948170d0a419648cdf099998733a4d4d1ab455d5ee5e39a3c7f3e7a55d7f9f8a6b8241f47af67753d9bfe3ebaf8735e8cfe935f97555e97b36af461f5b9c64bef67b3ba58bc78415ebf7d43fe383d8968847f699a30121195292a384925a319278be2f4e4bf67a43a3d797d717a327acf088ba88ac9c5d5e909b68e08234944532e8948a924175368f5d387845c2fe1c1e45aff4adb5f3f9d9e7c0c48f83bb9f8f7e9c93b78deafa72783e5376d79c6a8644428ca53c2388d0963344d7bed0635da3d98ae6f37183d06ad3a013d619817e38f01e3c6201e2353449246569936b87ed5ffc8bb5fde1032fa30cf2b34ff2f6ffef59644a39ff3ea9a04578bf3f7bf855f676009ca6f28c7a298724e129551664144a61a11feb566dd2595c55449abd48fc1b963591c1c38de21cbf5b8b8a42add21ebcdcdacbc0dcf4540a6a1085693ba9c4f0ac70af04850ce7628f0a36b5909c6c42060f5adb5af413f0e9ec7284bc1c91296659916777566f77ce6c6f377515b226388fd760836ed6d3a71cf3a098120f574faf067558732c86f8b9071d0f05c3edea08674c6c0812dc2b700592bc930b4a4a0b13624df6b45e1193188f3e48146949e558208c9d2be4e63345bbe0c555000073c3af8370553017f203d9334896cd2bfe4930244af16eefd860b0c2153a4e3216a513115a9218a9cc38359caf57c5556eec50aa9a7ac4323b4b999f2eb663176f4897ae7582d819bf2a6b3f09c07484fe515f300bda289394ccc4f8452dae09f425f4306728b62cb907524cfc22c984e7324e4ea52f3f2a70091587e0afda8c3c1022933a100e787b868b257f721c799da25751d72cf9eb9170ba4c2c461f7b6855cec39e452a80162cf44d7469b21aa1f6d3c6402bc1f2f788e00438d6f1b01863a66d1f678b7e754aaa3d8ba8bb02d51c78ab04323b44558e220c2d41eb787488bfa3a3d8fa257af5ff84878218535a40d4120f5c131db732d144b42ee8a7e1f698ed2786c893dda5c0b15a139e46fc73499b0a8e31e75649a38b388f2c13450ec2ad3c047601a911c1ea12dce32cf73b99434dea876b1365be650298d9de3903118bf4de6001c98a315c09d4008fef07510e66571a68bc14e339651719c4a36cb289316897ef23b6191b404724b8205ae1402db495cea11710abe1807b3699806737d677187991fde537190af42a6825b68d136bec43625b6b8baba5b1415cc1638632c7bcf9b862c0a66750997affad72f41445e6104f42e4ef0514f3b1ad6ba613b7d52a0ecbedcfe85c64cd87b01eddb8b77d84093ba7e405983e2ab85e6747adfea2ddefb5f5f1118e91f7871b5d66655f5eef567c6061cd726ebdc112ca7ecd5a01e500b4babb9b6d7ac42b82fd777b565ffd10c5636282d49592da1130e00c15a8db1a11e0e8e66562d49980e9004f7aacbbcaadb45a60e3d898e15eb27eb2675e32d5237bac5937bb3acf0e65dd83e9a14357aa46edc8ca379dc0c0db6582bb9c89b85c9b819e6ca39fa12f2039559d0776f6829a1ca10bb0cdd2ee0015ad4bd64f03175788c562af6bc26ad324133d557eae78284490f1334fe7ceddeda35d6fe80ee74054485dec2e20d8fec319dd4bca21d74dc746fc243f7883b7e691dbf2ae1467a2fc72480d6bdf15227709b5be1f14fb19b1e0036bceb1e5f2e516cc338c55ae7b386a25cdb5d24300d64168c8718def3d2ba4a19e5fb6643ab529e17d7559cd2586c65b0523619ecbb5be706020cb2d414db648b7a32d59e0fbeeabe46d5c5a929d9434ec2f4ce8f29cac7565382d9e6c151adcd0dcd1302bccc0f6f3531cf2bee4a299ab1870684e7354985e573b6b165382bd7cc37b967b0e5b84b1fca79bd6641636683fbcb9b3695834e2ba4d52f39f2ea7deee0de2d7894d2445806330461176b52fb10161126200f54cac53251bc4729a81fe28d8dcfbfff0d4d3302237f2e617aae4670f89cc301ccf91873d9946032c2351b538921c8b828ecf721132534d93057a19dfc06909961e2f2e40b1c66351ca0f88004b7c29f5338bc7ce21ea8446f1c9a3a0d79d7c045e1bf0728996dd319e0816c00405d2250d50c0e53f79870866b9ca6f82198b85877d887492abe42291719f83ea5124ea38dc9729c6b720643e954fc87b50b131dfa1ee23dc604c15464083a2ed2d47de8c4c045fb726717e36f96e54d51f9191ae2530896204826e31bb4c45e9621bd756df859e08db16e328743bec033a4ed27cfe0f0b82559db5084c8a8148751b39ad24572bfcf9432a57cdf7ce2d09486a8972fd12e2fc12e7096e8fd8e04a78e24b8411e244fe0f005cf6a3451d112247499a2f19debc915a34258f4cc3d884aa84a8e823e8f05eeae98a21482384160eb35c44bff517068c8d628705166ec8b0211e3a6c951a2c01075a6679633b0c6c000800ca12d24325c2684bb65c76a353659551da111a4bb1cef2e758faa9bbec6fa2936325cf668f11c2b962cc8518d476e55d910515186af1b1d04dfea112e6abc7d1ec12595fbd247871e61883ac3f74c1aec8739039c155d0f6dda0a43ba2cbab39e692fbbbe79bb6897354e533d6dae25c13c6ffc2509141e26f894ba9d55db14c81345a848e00b4807b1b73a848b92749f43e0cef1469a0a64d9a6ee8fdbbdb409cd62fd9184297408125e5e97e87da092a538a13c5029cf7bcb228df17dfc9e52bf756be17a4165822b2979ad3ddbc3121bc78f5a2c4a0c404678de6c168978b80f09cf459f88f57b183da556cb8e8e160cacf44fcd539f91c5908eaa040e3ffe058711b2d80d72d264823d7e801e14175ec69ab6f006d54d3c6452508b41d266ea3e0450cf05ab5011bed7d6dfb9d799728d806eadb9b89fc88400252c3a0c01c673ad2ac4365b35bc7d0dc094be78db143a0409cfa59ee0f196523b5d449fdd278a1bd9449b66dc670997c53add2cba1474239b689306a2b089517038af33324e85b28c7688093cd71982297c27ecfba43d43f721807a4ed305648c2cf9c6b467e8300418cfe92a7e47cb7b9354efabdbf9dcfd7a460a955c6a4a1d0685e77d1b8e1bfee930dec36a6b4749dd15c3f8738a41572e4da6dc28a90da6d4670b5d7cb9a7bd54d12cb30c7688053cef0ff138a1df29eb19aa0ff9d8d1f32e12576aeb9dd6e3939ea9c310603c57155c0a5c50b23b9afb4c83451c63cd943a040acff500176c4ba9dda4e7c547329b0eee69afdd163745791895d4ff978229cabe90ee9c909aff71e0e048addee6b9c8e22cc38f59be4f8637741f02a8e75a8d9b9f941f9fe2bfe60b6ce9b9826250616f2c31e4ab2ecfd2b8e805f2f2715f2bd8dfa048f03d6143fc10483cd7402c95b88d303cbfc5b3a9aee6c75df2da54e90b24320f9b9d9c638164ea39043ccf7512031210bb52860732977bc6cf90a04c1587e0e6b9a8627144e541d6fc3f731d30a10d0a656e6473747265616d0d0a656e646f626a0d0a34392030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f46322039203020522f4634203136203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203530203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e74732031323e3e0d0a656e646f626a0d0a35302030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820323733303e3e0d0a73747265616d0d0a789cbd5c5b6f1b37167e37e0ffc0ed06582988a9e19d5314059a3409b2488174edee3ea405762c4bb6025b727431d27f9bd7bcf707f41cce8c2c89944cc9a48d642c8d46733e9eebc7438e7b3f4de7a361d59f931f7ee8fd349f57fdabc105f9d87b3999cf27377ff4cefebc1df43e5497a371351f4dc6bdd3c5f91c4fbd994ce683e98f3f92973fbf229f8f8f0a5ae08fb5869182a85251c189958c969c4c07c747ff7b4ec6c7472fcf8e8f7a6f186105559a9c0d8f8ff0ea8230620a6ab924c25249ce6ee0aab7a7865ccee0c6e4d2bdb3cdbbb7c7471f3ba4fb0739fbf7f1d16bb8dfafc747d1f2eb6b79c9a8644428ca2d619c6ac218b576e5baa88bb60fa6fd6e3b183706079d004e18e659ff6387096f108f91290a498ba0cc90ba7e75ffc8eb5f5e11d23bbdadc668fe5f5ebdfb9914bdf7d5f8927486d39337ffe91e66604e18809121031b6568a13d84ff3dd0a0dbe5d982824ac2f2d00aca1a678677ef928b2e052dedd6a11eeabb3be45990b355de4972790c5d4d6f9377da2d3bf369f74476165ddbe9cf1753f835e89e88ce8c7455e702febb77a43f192f2ffdebbacb049c4f0d95eb8296e2e94cc1b5c228dc22effbf4f20cba72e4f8dc47cb3894d44092294bcae1c62816e50d9f87b3024b9015e4f6b46fa4a09a37f843d04398788369303ef9edf4704c7cc3b7352ac4f0924a7d0f083386b475de8e8026b240639a2ae941f3223c04486601c4c17a3a002842432a0f2049950d007a3959f4afebac339a7775e71bbe9c569879e65dd919dd754f789395be7f18bbce819d3357bf0f52a6c903c85023a2017d58a2b10d8065281997690af7aba006724eb933d9946986b335d9601ceda96156dc637afb3203a642a07656409dfe3946d7acbe0cba8c034470d508d7642c134e06eea902301f7206c61b0ccb8172740accf771cec0445ecd6be0dc2c6248eba0646650c66e04dd703205e214034de5804605fc20ab366efee2e3bbabd04da798424715f8ed39beba1e44e0d5b93c960bca4250639468b281c2dce3631a8dbb4c4621b339cdcb60fa58f000beeb5117f8fbbc6b36397a1063994b7b2aacbd18b29839816b20fe46ee0b2a5bb6ae4bef2628c7620be168ecc524021fcf564d0c023b4c69b90b827279634f50b90a426bc98340a91cb3b665ae80eb7508591fb9ca04a6f63737d518a7f517580b0690407eef20cf9e61aafbbdfba8b9f05654bc5094ab03f5a5f3ce72b52ca8dc35cb4de82f9e286784c9f8712d9670492b5d9d7d6870418d9bcc1a87b987dd1b94cd19362d32a6285b235079e2c168ca8a80b86a0a348d6de16949fcd075a43cb9193c1e4e95017d5638672a3bb738c06ada65052426dd992c5cbf718479c9b1d5c48096d9d130c7a436616d25522934614ba4474fa0f25250617c4998e371d20a9ad7acd6fcb4cefd4c75c6175012a66d29a82fb9aef093faf55d056ea83a8b15cb9ca802f296edfccb75931b8a5c9f5cbbcd6c00969d351fc3fb6ff0c9f537b8d9cd60dcad5b3c33fca2ed7cbdbf872b53570ec067bcdd0250eae606f80df4141d90076f5dd060855bf433858f2a2c66534fc32f1ac500c65ad90e726ae96d8e82b9ba505e6947c12fc02aae27f169314383d51ac457ce565fc975b56c5b0cdbc98d5ed3a3bcb7be5c86052bddc73483cb1a2a5560483105a1cc5ba514c4add9179448b150b70b9481042e5641bdafd64c651a43ea3ad0f1cd020c686a83567768ffc968da6d4eb88bdc2a0f780c246017eb5388a119194ee0262ee46f06b3e51d1eb758121a191725d565606431eacebc02a2b4a46257da0e82e29940352c522946cd1aa8c72d266e2bdf40147c51399882c0a4ea8bfa0db21930e33a47dd01598059cac825a7961ed59541e20cc6ae520ad226c42ff50bf8ca0d9ebf85cb5c397b918163a02b4b4e8b323094671876cf97b05c9cd6618ba15791ebd1ac29d26df42e73725b406533b6cb654e5f29a3c947228ca2520446927a86e8640141620159e9eb8db09cead0b062c25a640e6b6169593e4d587ba2f285b5276a25ac37ea564b3beac86d2a98bbc0311cb74698819f9790e3c5d3e804e80e963a4fd4c5928f3b0500e9ae375e40a44fd3073797eaa946cca50d8f78f60d294593b3bf614ebe4f74f5597c3b6d096d201dba77b79812abfe204306d4867213409e212b01db102125c5642599392b718dd89e242b79a2f265254fd4fb01469c732cc77971b23a5b4096bac6ac5301855e7ae2e6cc57d6e462321fc1e5c395e2dd86f370d4872f5d8d068e50270f3165292f03434aefa85cbb9d900f1a2ae8a859dade2b8e0a96d5e6691cd51395cf513d518ebf92766ae6b9a909cde86b9289fbfe5616019092ae2f04b88b67034cccae73405df64def446e33de834a0c3a51aeb580d6898a82966b73fe66710443f7735b8c9c2acfdb77cbe6996b4f61fb693abe4f26ce5c3302a75d270d540b159d809956b40e86235fbb8cb997e7f5d4447bf399ba5fd35fc950ac6ea5c1af794ba736320fcb42d7152d59405531f6cbb5b2d0d84f5abb7f2349645959b86f224850985ee96c90135cf0c55599fec7ceeb2fc90d6499dbe8bc29b66e0437f3e04ccb0b757ef42567cb8fbea8f40d2a5c162f42a23646b534b7a48521121c12b752eddec12b323731a516fb77d564e626a654c54657ed74325aa6b095beceacdf2e4e8c6ee74bb6359cb467a9dbbf8e1f5c11f7122ba15b44baabd7b89737cdd0b62c18eef1f6c712a3e0cc6d4b290c55fbd65699625b89de010a58a35ecbcdfffc079aa607d63c1f41451cf7e0705ec16176150137c58693105c260bdc7ae8c38dd1618a0d27bb74c824357b1b36c5dec35da00a4eedda740022d4b194b243d0b0ee3046d2733ec1579fe03059c0618ae798c14b347e0369d2142f0656f3f0b0526c510c0d8b0ba7647f5831ba4eb1457187ae45c9903caf8222ade6086ab33e44006d49cfedfce4c359caf0e18c0a1fa8233da58edee426cb5cf884c0cd270145463c1e516402d55ad794948904d6552cb3753da00380d8bfc2c04688cf461118792e8c30c11436a4cc085022b385b1aba852585866b6b00714378a4cc6717b8d95ca850e6835d0fe801a2340e9ccb6550af7dfac0645bd9b05151701cf6482576af774800f2f4667b9ca44ab33293640ad7007a482d3cb3502f1ec7904e66ca543717ccec6c71ca1489dbb740846659920b1e8dca56303e8bec440672b1b0d31f01519012a77d96025d529689fce5d363ca0ebc4e0bb654c2f6e6a9eef1ef62cf1094f18c0333854b839e9f2bb88b1e42a325c95b43421a54780ca5d640af7fc67024fc83553693dc103ba0f81d0291ea8da45207c3546804af104d50edb72f8a25507130893e261aa1d04c28717f310748a87a976e9cc0a8cd530811882b38dfa6b04e2398dec2f995cedb0667ae2038fd166aea657ab4dc3efff62c563b28bc9d5086bb2cb26d07d5984c9d5136b5844409111a07275b45aebea62f3a1ea03ad9bb976f8403758c40c0e7de409a35b38cc9b167f59138821067b3f8240985c45864b83338480be2340e52e32d2a671029babdcb44ee001dd8740d85c75a7211001354680cabcc4c285a6e260fe60731597963f6ca28bd158e60515cee5c6f3912bf4e1d31a73f83f269dc1673cc7f1a0f05cc408b2551a2b71cb833f8218b5e6ae348ce31f454a9064526c18d995643680eee21109d981af9e0855a4d8a6b2cb664541f5bedc2fa1253cf11b4b0a9fd24b6e98b83ff0086ba4d8b8b1c31accdacdbfe9f394d6f0c56f2bbee94a6a60c80fdba1ccbc578599ddcfed3a4c7f038b8c54450d0a656e6473747265616d0d0a656e646f626a0d0a35312030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203532203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e74732031333e3e0d0a656e646f626a0d0a35322030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820313033373e3e0d0a73747265616d0d0a789cb599cd6edb3810c7ef06fc0e3cec412e104afc2683a2d8266d822e5a60db78b187a007c5951d1789944af2a197beefbe45878a854a2b2566524d108c6189147ff31f8ac3a1e3d765bd5da7ab9abc7c19bfaeeb74759d7d2197f14951d7c5ede778f9fd2e8bff4e37db3cadb7451e5fecae6a7fe9ac28eaac7cf58a9cbc3925dfe6b38426fecf5ac34842945354706225a38e93329bcffe7d41f2f9ec64399fc5678cb0842a4d96ebf9ccb74e082326a1964b222c9564790badce2f0cd954f060b269bed9fdb7f3f9ec32228bcf64f9d77cf6169ef7713e0b1effbe2d778c4a4684a2dc12c6a9268c516b3bed821a3dec4cdbb775a6f1a14127c0096e2e5797119303277e674c91489a8c8e3926d7c7e69fbcfd704a487c7197e63efc1f4edfbd2149fc3ecd37245a9747679f16cf0bb07c38c046c39d21e1a7c59188fe5b88a8da2d6474532f7494d60b1355e4f899a17e9884711f848748fea75573ab6557963a4ba4a31ce268ee475bbf18d79121eb280d7ceee9c7c0c798f8044cfa1126a1a9eb22edaac5918cb2858b4a06c1fcf30b98ec0acc3605931b30c73fc0c41598eb0ccccd8deff107f420373efcbf15fc3154cead7fc506a801ea0964f5b8f2d3b2c3b44abd18158891512fc6351842c0acb760562598a20053fb6b64ed755df91e3be85179351bd5ef7bf87665ff29957f4ada085ef81055edb5dc37cef78da70e80709c0a35e26d4004e43e02597e747e821001262893d34ce083be28245f78e2a83223be04e8abb19898a24e8c30515036f613b7f09399362afaa96948474fb84bbca8fcb00306c901c15d33699f23aafdc5f4cf05c2a44d18e5bacb745578b57290f6ab7f9177e5614687c4c898f41973c818a01b4b7085d316626a7f4175b76626008f21e15941e5085e98661c593363a8ea32e9002681c56428b3234c213a49649db4a2ba97ddca6d9b49f2003c8584e77433c78778219a6964cd94a0e6a98b2b33c850d0a30f95963e901b08e4eed6ef06f2760376dc24ae0064ac84c0a486956304394447ac0cd0ea0809d4ea701d3bb93fa0acc1ca14cc30ff9e0ce1436a2dacfcd02aca8c4fadc18a06ec9e3856f66867e600394447b4f4b1d731d1943d9509b910514e52d62b4faba6b02b21b6dbbb5e5857be10698abdfbdd73003c56e5b17f5b86f0218a62951eada216aa4e16a468af543e0c8e557230c8d1b0ff1b8287a86991d5844f2982d46c0f19f6255ee527e9d6af4c45ee7bf80230486687559a724e9919f128e4402841965959aa9ebab515531c3c3e06056b791f8a4f7e46b4dfd90f870af11ff990530949b5e9420934ff074385f88f7c4ca9e08531bde57df83bc654fe0f860af15f22fb0f775c6f415668fe0f860af15fe1fa2f9da3496fa59ce89074bab3cf2162886e7a02dd1ef9c1465ae58f109f086590a10cbc6107a17e02971d36cd0d0a656e6473747265616d0d0a656e646f626a0d0a35332030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f4635203138203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203534203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e74732031343e3e0d0a656e646f626a0d0a35342030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820313538373e3e0d0a73747265616d0d0a789cc59ad96e1b371486ef05e81dd8b417330144715f8220699c0d2d1a208955f4c2c9852cc9960079c691c7597ad1f7ed5bf490966ccb43c9944dd646404b9a91cfc7f39367e1a4ff62d1cc8e86a3063d7dda7fd134c3d174324607fdbdba69ea93cffdc18fd349fffdf078560d9b595df5f7cf0f1bf7d19bba6e268b67cfd0deab97e84bb74330713fc6688a08925662ce9011145b8616936ee7afc7a8ea76f606dd4eff0d459460a9d0e0a8db717713449126d83081b8c1020d4ee0aeb7fb1a1d9fc11f46c7fe9d59be7bdbed1c14a8fc8c06bf773bafe1ef7de876a2ed5fdccb2cc582222e31338832ac10a5d8986bf745ddb47932abefae26e3e7e0d11170c23407a38382cad624ee6393138149d066c85d1ffc3ff4fadd4b84fafba7c3cac9ffeee56faf10e9ff31ac8e5171b4e8bdf958de4d6001f06b709428cc18d2d2621af08830de23ecaeb26eb24a15962268f5a0e825b6c56001ab0db652cf8b092ccd065b7bf5f9683e297bbc3873031a95a2a8ab318c33d8c0a52caaca7deeef98bb1be5f2c62769219914d8d03887f84b976b4463c11015c6cd91604dadb5dedcd1e3f08aa56956eca690a485823dbb9c42883ec4c4323371ee9cb4992981a9951eb94d610e3fce1edcafdaf650ef2a640eef675a6e342de1f3f64c9f12b2479fe599ac5498fe0f3a5ed9b3a1191603880bc3aae445032f50a98a2f2e169c4f4aaae06d4f14f78e0a611e463436f6f6f987f616cfbcb72092eb1d91446624f09635d799f67f544eb1e177508a6551cae74fe1164dcbf80d875c422aa7a5e058f9b8cdb6066d99d763ca7d711b74884965663250d1a9eb4cdf60e34d677348ca13789569eb5b83a909591fc176afab929262ec36fdac81f750e2a75f46820041002042129d5912f84d7665324ba6d3a6f77e90906999706f32f90299709f00c7f5ed7836171ed558dfd1659464825ae908452317bb42d1cc42de098ae580ba5163b5c9462e83d4a52d4e4ea01ca01c42c2eda83c2baad1d038b449271160222b9885382603649f8ab2c7a099a2a2f8544650ca9c948c48cc4294316b5065dead42b855b82394cebc5b5b503e2bd655cc82cb961298756dc2dd1c962b11ac54e4ec0e7d71ee44402de6379a47e13a0c489eafbf47f0e5ca0906ee342dbe035ff89db81aecd41fc8442c36962543f804ef337b0b3146d62ca9c033f906b1c5f42482294b1658164224c014f6d3fb2b20b964b85cabbea012107e6eef9758ee980c5150eeda30b1cce5b9b41c5bb9d6f7d6b38b930a2857e657a7146723285d16be8b396d5c02f69faeb757f8e24c142e4e917f79eece445dadf315be7ced10244b2fcd28444b1b98518c9b4d66374370623b6f799b004a6d8182df9c5e87faf927274d1fc43a9c95baa8fa301c0e61389bde4bae10c4b2676d43c49c4fa57884b2cd33d260b1ab5c3cc529f936280863726d617f9b3ab96620176c545da00337a4178a5157e0b6cddfeff94ed8947621b26dea6f04537bf48b5b93350c278fdc4c3fa7b76f095634603f46fe140f24b6c9cfa1425d3f35f5811481fcc8b9e762c826ff0df3beeeb32a786692c22ae730ebd0a4239448717cbd4d09c6b0b60fa744cbfc040c8fa660b3f6dbe4ab7bd5c0b0f051a1ba3c7878eeae26c762ccb847ea01af444895e2587f9b5470c5d21da50a82ae8e122655efed5e42d095a82dd005204e5cee1da3cbb017c1a972716a7fae1570680494ce04b55459588b094fa1b2b902fd733fbdca6dd03120d615d045b4a5dce6a21317cf95da6e8c782e4712406da99c85812faee5e28faeb5f8b75cb61773f74c65d8787ddb6d4590986622a6547a915bc4b7b5ad82adb7adc270174a85c032a26f153cb3029a61b5f3b21099d6ea0a4a51acd7e2d0f999d3dfa5c20585d5f0ebd86daa4318662e88561a8627ffc0d03f8361ea32e37ceebef18b0b12d85df8e62eb8bec757d3d8df1733559969aa0c1612d581a9c640a578d2bacdffc262b3b628bed6ce9b8df3ffb2ec802ae40486e7b98ac336438c63521ca86c730cd7d8ee0c95e2f8611b145398c80756abc510e398cc4720820ab7c5768392994f1f046198d90756abc510e398cc27201cdaf3dda132f7e55cfbf6e741d56a33c43826739bcc95c272fd498c4fd1c7e09859724f58e5ff0f63db688c273277a15c0af73c3b49b192bc7b27164b1d408cf15be6ff62c605349bb746e7ff007c36fc2a0d0a656e6473747265616d0d0a656e646f626a0d0a35352030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f4635203138203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203536203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e74732031353e3e0d0a656e646f626a0d0a35362030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820313531303e3e0d0a73747265616d0d0a789cd55adb6edb46107d17a07fd8b6014a06d06a6fdc4b10048d133b68d1004eaca20f4e1e6499b655c894225141d2a2fdd6bcfa2f3a434aaa6552f24ae6a68860ac4991cb39336776e742759f4ff3e1457f9093a74fbbcff3bc3fb84acfc969f7609ce7e3ebf7dddee749da3dee5f0eb37e3e1c67dd93f9598e5f1d8dc7793a7df68c1cbc7c413eb45b8c32fc586b3861247109958258c5a913649ab65bbf3f2659bb75d06bb7ba479c7046134d7a17ed16decd082786512b1491962ad2bb86bb5e9d187239830793cbe2cc2ece5eb55ba71189df93de2fedd6213cef4dbbe52dbfbc57384e152732a1c2122ea8269c536b6fdde775d36665967397ca143a14d009e004357b83d388eb8a120f912999a2ac56669db9de147fe4f0f50b42ba27937e86f4bf7ef1f34bc2babff6b34b125d4c3b476fe3fd08569b09361aaef8207ca83cce3415e22bc9a3123e2814eed71b8422f58ac982fbb387c94f36ca4f18359b8cfc94b103fe2c8cde89a6c9d7b675e236eb1abd8d3b32ba896534591ee4b18ad29827d114bf21b18efe98cf3ecc63cea31fe38e8abec45cc1d770f4240c60211d65ced34a754b93075e9acac0ff7d8089c0c07043ac023bf99c21a7fd4fc0aa08c21c7a1957e8d9f508ee98a6b8b4c22ca9d644c168c1054c29ede271bd016560030a014a94e87d395581213147dd6d487320d344c3512c436d184e0187359207b0158cb398b3e81c7786610ee790ea34ef4ab28c4877e57b90918425433b43b9dd11935e609ae49de35e83981681fb2ea6dbe1f37c7c3f3c130a1e371876f632990d846949a35554e91d31b9109856317ac16505d80077eb71eca2ebeb3e2c3d592ebd1416ffbb28ee886886c1f85dec11135950fcda6148dccbb09c0766db406db033281178d5564015c48eb3d4039b0c854d38caf735980acc625260db1154121894d25489dba00e21d1fa846b1697e835c6ca22af1ea571529b79d5a20e1631604b66a20675bd298fff43641620567a2bf410788eb83f67e3a17773c820ad873aeba05ce04c4170ca6f633a190f31092f7c00bc81ebf2703680bdbd28b486937c5558ddcaf1285e2b76f92b521ccee129438c041ffb98ce67988505cae905b394cbaa2e3e954ee0f6880668bb66eaa289ba506fc69440aa93ac81fae13b24a60b149f0d81d0ac0bc3591f86d9d583c8aa03c115c344ab0ac2c7324d14a6db2c63933d403551ec6d0365a0e634eba515d295035db0f44c444e717804c35f5318d2090c0f5b64b5bc9581ad8aa6d3bc280d336c8d28f6376adabc3c4807e55752cd31aa798da8cb1c3925c02967a8e4fbc6450ba9a83135a27d7cbc89eec1361fd79c9af5229a2ced01476631344f07840c59154f3af060a76b6bd326a49699408dd21e4c34d13ad8c68472d4f1ff8f898af814040fae40e618057f7f88f109b38e690ac39f651a02b764784a3ec2d0c73d319de32d38638647931b3c1d961760c61466a478f50b0ee58a7b828f6f5c2f0921c5b93ab37a70ad03732d2dc50ecc4e5cd7025d3667d2acf3db498340975e51015a108819ca3959fac2c403a70d85d314ef896a0cea01ca0502b5645968ca930658962c30cb15a0e700719ce1aaf540c743a12bcbd01a337a80120d80da525e245c50b56b3097322c28e51cb56ba0562fef8aaa7084a5603f2f9cceafd3205520c49c27e87955c4f7751a64b2de6950ce52c9895234f16835481d98016bf6f0d5509bf81294d154ac6d8ef359d98172d1948337fc748e2bfd0c3b0ab8b36706eb987f60e8ce60b8c23d7e34c2198f6006c51a758e7b438e617d44cb6ad56f230b150684b1d4f21a4d7d4035d1e9d9667e0d45ce9a4f1caecac8652eb5b06891197d440e4678618e5525410ee6139c71833386ab24ab48bcbee080243212a4fa5cfc92a6aa84cf9bcf267a3cdb2c9bdcdd8493c6f537f876aa4e948ffe81fb494ac115f3ad7b5645091fcb06ee472961ef80aafec6ac29cfaa88f2d13f70eb4b714db5fbd63daba2848f6503375c145318a9d6dec62f7fc7281ab7849590415785fa592270c3433a415d436949e31ec41c2eca2a441fbb35d13cd892634ae3a8d839149bc0a034acb57b41fd0b69282b0b0d0a656e6473747265616d0d0a656e646f626a0d0a35372030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f4635203138203020522f46322039203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203538203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e74732031363e3e0d0a656e646f626a0d0a35382030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820323838313e3e0d0a73747265616d0d0a789ccd5cdd73db36127ff78cff07d6d7994a9d1a22be083097ea6abb71e63ae95d537b720f6e1e68478e95b3289f3e3c4d1ffab7deabff8bdb05498512208a9200cf6532b44882d81f76178bfd00d93b99cc86b7d9cd2c7af9b277329b653777830fd155ef743c9b8d47ef7b979f1f06bd5fb28fc33c9b0dc779ef627e3dc34be7e3f16c30e9f7a3d31fcfa2ff1c1ec424c67f5a2b1ac5914c25e12cd28292944593c1e1c1bfbe8df2c383d3cbc383de398d684c64125dde1e1e60eb38a2918a896622e29a88e87204ad5e5fa8e8e3143a8e3e9a335d9ebd3e3cb8ea44ddf7d1e54f8707afa0bfb78707ade9176d594a89a0119784e9883292449412ad6bed5a355a3f98ead96a30660c067a043861989737571daaac41ec4393c782c44e9a2e76bd35ffa3573f9f4551efe221cb51fc3f9ffdfdc728eebdc9f28f51e776727cfe6b7737010b00bf048ec609612c523225d4c111a10d47f8ae622da84a8b2a4d88144eaa572fe3f894f6f721670f927142d790db5963d7d24a884ed632b454b137d95e54994595a7ebc4e87f848211b586d4f5b89b74e637f783eeb1ec4453cf8435e8aa9bb5571da0c83bf7ddb4f87133f34b9ac174a7fc79f8cba8205aaea1f5c237ad94c4eb68ad8ccbdc5ad80b450468219842cd40af154dd3d490bbfdd66dbda81febb56e79522281c9550ec185de858905c6c43932a986e9ec1b9c17832eef4c675d05108f4567dea5bc930fba024e93ce356aef18d4787e63147ad0a549d1ee01cfe1547626f86b34c01e66f058d6a5a293cfba65bb0f8b76e6f406ae9b079ebadc509e74b5a154b6032811901b0d72e86a3e85c377a6c171d9f1a3995230a3f08ab93c7d82a70b60e622620007a44b590da8797652f594cf474fd87e528d8eecabc616cf05530454d0e6790b3de081f580c104a9437a93158cccbab2339ce2e18b98a7834a90b7d9b08bdcadee64f39a50e1709fe1f9e3b02ed4c72176cd96f5467fe1fbe8a190185d288bee8cf3fca9e839296537e9d2b8b85fd0303f1f3394b0e9699801b0ebba7e96eaf40d36443c392af5e370022a0adde395d1c0a8a97fb973682a6d1eefbd0038284922b84d696ff3efa0a4894a6d4abf009f2fb87f723201ebbf695cae8923024f9c18e6b4ae63ba1816ea5d574bd041595851a39ceba7d6b2dd1de6a890681ec7936e695417860e6d1a9e1413ef1ea9412bb0dd537ca8981a5f3a2e8d274228a863233317b2dbdb213e8c64ee0a1b0f57ffbbe8241fc353b4f338c8aa0efc5b46ae34899583992d042cc30a38c107b7c59404c6a421bc4b9694ee736ed6d9df078b35ee45216bdfa2a25411e582b0426a0115bc52b01624d1e883b146074c05661bfc8d9b30bb30e9c098c04be5a28ec9acaec6602ca6b96729120eff4c608de6d446b06e19f5ae4a3c41d7dc0610406b454ca876902a4c6c28064bea64f0fdb032f383d2e335be317a484f8190a4027e3aa07896ea177a2906880eedf62e5a160b225d436b31b9d3c0935b08923479fa3e34bb8876574999cc58cc4d26e7c338d82ab06980ce30db5396702dd7396b8eb33d723d34a9c57c82f6898b9e59234cd834ca4c44b388997feba01b6afcbcdfba6150b15812263773c1a90581b32d094d097f1e2558a5644430ce032c982cc524f1a6a139d91d389194002fe4b66e320d9cd59029c7c07b25380b321534273c76515cbbd6d7f25dfe174574ad40356d38615c2be12255c6b234c5784443183cc438b2b44fde51288553c346f19d7f523ac61cbf6fde4a2729814e8d45ea651c8ba49fe01fdde7f027e67d6031fc9089b986b7a4ec1fe33dc9fa29fe01775f2a7367d15a9c9bd6d23cd8a762a9a714ee893e65b5aec499b9661ead2e357411ab38a66517f1795fd7ef9d9cf6695c5c3fae46a058f5d059798162b7a21c874600ab2897c6abcd7017635dea171f2fc76f8671deaf4604b811be8af72de93932be8c50ea9c1b2192cb097790f26f5c04acf7dc35aa10694658565ca44c526c0401d36880d68516e504876985bb2a2eacce3c4c46a45a6c34256c69592e736efed36518b85307c1364b6ee07ca84c34aae196a002e7f0a49424a5b5e0e818a323acc14074f4ea77eff201c1a4da265b2c8923ac5c3c844aa95093e2b2298748049a32964d6aeffaaf33da8c5da4dc39472961d5949100176873ce9106ced54ac1094db79d108133a192c39d255017e3e1ac6b970da637105a1699c087d9a224309d633d15d384bcaaea7a1779a270fb8d0db49e1e4d4c769420bce95d85debffae16e07c51d58da483270fe58c2d4d0dbd6c4a88fbc57d2000a82c1e5e5fa2f5f15b5f9b4d3bb86506898c3c1fccaa670b8db4b642e2014263f1a270b489b2d173ef2530ddc11f060bc5c34bd40ee70e0cef747c08e7763dc36818569f06d5467f2048707bc964fab6b2f8caa1f79e71b8b53229503621bbef9c8e834f14daf5ad281c97edd01dfc6c894a3b770980fb07a7a835a852c1b4eabc3146ffce15fd3525031e500771c40381c93f83629dc00339ee318910d7ff34f5898ad6536e1000a2814e12e76b651401f39ae26055414e39ee5c508d74bdc7f841a3733d315f5ec21aaac5c845a381fe2afdc6c35a90ce1a70c4e4759a59e11a6888c103f9927269538af3f171b037c739ab3d47849d6a0da70da47e2ae89d332c57d2cdefc57e7c42db2b7aba46a3b60f7ac9b3889528d25cf8de37332dd47e8d6c474987ad2633cdfc4f4e72055944c6c52ababc66335f1cc74cbf074f0c7ea2282bb71e089e8ebc50cf76ffb382807559b99e3540e1f21749372708955d667518e4da49ce3afc2b8417efcfad4e3f82b35b2400d6f2b4b7ed5029e0a052f01f7a385789ca07428508ae36e0b1bd4517dfac00cfb1e0f47c52207b3eea805e63410669698d7677662248f838152442907a8f72d40d150a094795968374eb140a02a33c53849b6b59d9c879a07a541db0994086cd02c50b3bbc2d14c3bb9f13b4d008afee9bfffda02ae0ca56d941a6ddb8987a116854adb009bda364ce6c1968252db7602e5234dd5a46d2ba06a5ef6edd0bf2321c5ee9c089c1be3b833ae29b2f5a709362988687047b7795fc63b514e31e5b6717cce4dfa81536e5c6b34225b820a9ccfe22ac1ac4a436472828980454ee1d184226895fd871e5499696a436ac3a7c05b8b78c288d8d6f48bc05b8bb8301b5c6ba07eadcacea63a728f65916cf12647889a98c4ad21360e774d8c0b4d580ab125912d8a622270959873b5839e050e713903abb96424e6d3ca239a5090e40f1fd02332f50b748b728589f83fb192618a183847efeff189af43e5e56d88a487890bcc544c30c7f830ab32ddf778b8c15312a6c4c2698255311b521b51fa28ba3689929aedee35506fe795289fb33620cd7e4d1b8dffda004dcc6b4a3629b36acc4d8639406120e6287c9b6a1b1df051e36ed2817879d9a87f3d63cf0dd12eaa1a7743d85443ba77eb07f8cf7900a79a494cea6c1ca053d6a1c28b52d62c8dd13cba58c1c2c97a956a4059370cf01fe3fdde586e90f5c6013a651d3880624ae3ce10172b784059af500d296b8bd44f9979851716af0c17f9fd7674baa374811bac360ed2256f1938766349b2f4a6694dde22a0bc57a88694b745ea725c7c7523add78203782709c67c1b47ea147ae0d898494194760a5d0614fa0ad590425f3fc0d3cf019233a541df3440a7ac036fab608291a584d1bb71f1e2735ae43d2254ffa78762f344e9ab472ff04003e441cc17082c486dd814784f04e374e52dbb770b33d154b98643b963cc94b94d213b50786a436cc3b7c0db1af0fb5154eca45ffb7dc7a449bf2c4c6d181538ffc16285ef35eda5609f427b2a8c692cd3da58db303070d681a672e553216d354d864ae8da90daf02970644ef16549079fb651b450bbe24a4b66436cc3b7c0512eca7429f23e99575b50960a04fe9d0785eff65ae4dbb02470308819b6e50f10fcdfe56c6d886d3e2014f81b095448dc36b425281f4e3fd82488358513144bf1bba41b40fd0fd5d3b0f20d0a656e6473747265616d0d0a656e646f626a0d0a35392030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f46322039203020522f4634203136203020522f4635203138203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203630203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e74732031373e3e0d0a656e646f626a0d0a36302030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820323930363e3e0d0a73747265616d0d0a789cc55c5b6fdbc8157e37e0ffc0a601564ca031e73e5c245ac4d924489145776bb77d70f220cb92ad42b7eae26efe557f521fbbfd153d6748ca92389646314f1bc494450e79be739b7399a1cfdecc97c341b7b74c5ebd3a7bb35c767b77fd9be4eaec7cba5c4ec75fce2ebfcefa673f776f8793ee72389d9c5dacae9778eafd74baeccf3b9de4fcc7b7c9df4f4f3296e13fe72c4fb244e79a499138c5592e9279fff4e4af2f92c9e9c9f9e5e9c9d97b9ef08c69935c0e4e4f707496f0c466cc099548c754723986511f2e6c72bb800727b7fe9b2bbf7d383db96a25e997e4f20fa727efe079bf9c9e44d32fc68a9c33c513a999700917cc249c33e736c6450d7a9c99eade8a19cf83879e004e60f3b277d5e2aec6c45368ca4cb12c483324ae5ffcffe4dd4f6f93e4ec62d69da0fa7f7afbf1c7243bfbd49ddc26adc1bcfdfe4fe9b72958241cc0a89082adb62c3335847ff998b665eb63aa5afe976fd5efe3e43988c7bac7c8b79ba7071a7a9c1e017f70ca99c7e87deaa76dd55a242997adc174d203398337a73c6b4d168d4311996546ffef5817e024563e46ef7b027a86591bc99fbfb4b67d6f835c6996ab842359a4377811f644de8027aac7a75aab2433a2c41f821ec2248831490ef3e326a63fa6b2354952dbbac179e137f8d643531e7553ae5b733cd74f71be80732bb4ee491f6cdb7f1da49cb7a61334727fcb122e0cf1bb28aec31354ebbedf4b5df1fd698612624a70c9b80d30152168492c68ee983c1292a280c424fcdbc09569a6dd26b0c9743c48f390229b561717103b4500c2d3a6ac202930098c0e3ba492363cd829edf383cfadcf2901e19cd9c32c86d4af692dd2e482e55b983eb71a67dfe2041ca215c1bf21e6df654c1842b3ab3c8d67860911a0f796881e24b2606c757ad3314cbde3ee04e7e19b6226a701a01d332600000cac2d5a0ba4dfb4abad695b8e440f2a37647096d8e08c655a6dc9a3f9f9a672b81aad08fe1d31ff908de5c762ca89312981be59cf7fc03b46df81bb746718066755de331aa51b09d06e46b39862b2e3b3a7894ff6c778282ead3088de0f31654a5253f8df77780553acfbbe4fa596706185f9d46891ea0d123eedbac5834fb9c67d3ce9472f58e31624055413362099086df1268a59bd475d22df4ea15f6599141d091f9ac3f365a7ed7fd7c5a7cd3a5cc3a7329db6c2f3aec3fdf5729ce59dcde1ca15c3f131385cbdf7e7f09436781abeaa0ee7c52d0e47bc29093af8c9fc685562d1b6c3ede69db6d3f658e009eb31c60fdfa2a77630e4304c74f2f20ee4c413b4fe4ef5b66448ac05e0d1e678a97898dccf90ce3bd6a3429eaabbe047af477bb0a6005d3d08249b7178b8c0dfdf1790e09a818f37e7fe94d91add69dc4821a1e0bc6e0fade6b354995be66c80548c3f109794062ae37c13d3a72e4e2e3e6b9f42123f1e77fd8c74d35f5761eb120eb37a3f9df8337ed22aa7395fe841a6d05fc2397fd3bf70c249ca3a30b2dcbb593f0c216d919daef0ae822e4e77f36a025dc1575ed2bcef8efa300b96101bd7aab54cd9ba0009e6534845745ea714633ec4d5bfc914e3fa5850c495b2ce39d33a149285510f9178b52c2d4558dbea8ed2c2e0bd4d2d4a6bc52bf3a28b0156d85bb72c665567636d94a5010a53fa4e65a8f853467b7c983749a0ba9a03a972bc3773c8a9b7c916ed92f56de8149ed810dde7da6717f024538df0b7ceb61a2e7ee4c320a0f4fc87922adcf037f875b5d8410863bab339defcef5d38c8b6cf3676f399221f79e06483db512acafca3f97abcd2b575cc6db5457cb3b4ad8bd904c14d272c35141d01ae980e0088f10092c6cc86540c148c4783226e17682d99e6c14ee1a64f9a62f21efa22b3e81caed629ec3a71f633fb621d5406e8baa8775946110c2d934515692a6f0cddfa986f6d8ee901aa29a4cb0580095a95cfb217c90d9a9a37f1076a4557d35700fe8a676a03be690d863dac63ef86e09daeb884a7bbf7f8d05e25828748e9917c9d200bdd5f1f2271f3fd4f9d196643aa8ab11fe2768b5619b3470740e2925c0bc7f806285c2d5499f4ed4046d40ec2c42340faaa304cdfa3d935b0e61baf1abba17508312a21ee1268ae31313b1214719b40678259bdd337564a784379f76be30a7230d2d5c95ef92968bc8ee0a3861b78e5326a6602942922b0c4f67f9d54f31323e71657840e72b5563747c7501086c16fedfe5543d144cf638feda93c3b3e4917c485a7c2596c2b45b9980e3763342fa3e0a25765e5c3d9922697c4b51dee0290bca34cbf56a17b522e57364edf4a6c77d7e9335f8cdc552570d902f4b5c25a54048ba03263260fc089311be2825319757cba2d9a2838cd1e50902ee55be9d2ef7f87aa3903cbbd1e622ff70c0ed75d3880329fa2ae10080e79115a6f0d448c649a2844f64906ee70c72608a28942641f28b0ef6c4b52e329aaeb2ba8ab3f4175f5b16df5b905c7272eb004f52525c008a088114d1339f63ed17048e8b6dceb894bba415a16ec35442b46004de4f3fb04804baddbb1d2cfb209764eb0542d0ecd1b85e04c86c82fb04f33069aafb3e6896a81597c80e708453491c5ef5184cc1593f6ffa6883a794c43664b524504788e50441395cb3e4538c1547ea42282fba3aa3477b66cff7cd920d04a6535a07e17d21cd10dab836f373d7f11819653a1856cdcf09058234009225095aeadc77648d7a1430478492551cbb169b50bde97d8b9f115f6cd34029fa2c2e7142e8407841b014a136b5c3bdc89fb2d1adf3c3cdc71982343c4911002f76ed63982b2c9b6c6afd1f18b9c0e82aa2d82eacba1cff176b3bc206e4b845bc22919c21d234c476c1eca3077381d6ad23caa70d69fb43f9c1398478da3de0c402e37cda3874b1218ea5ff268f3501911eeca3cea9a8800c5894055e621d5b79a4704784104be8a1735f037c5ae65bbbbad31884e52a1cb0dcb6d48b411a014b1bec187f26393f220504d25bd3217ac011da36ebf62fafedcfbb877f522326073062601bf03258f7577433c4dd5251d01ca12ab9f73c8a89a50bf23567f0d28eeb7f0bb9156f3751580090098c461b45421a92a05ea628dd8db4f156f4a5d8b3c67622b5b8d710b4d16708a9e511d558ca8a80249252a67993c3673d354f1a3026535ae8d6dba807fa370068eb0dbc108e2a30a253c134cba00be18a151858d4a6846ee6c7a9f5ca3d05e83d078043caaa00029411684172333e2a02034c7c5ab23415105800a94cc7740fde3ceef2a02458e7c77ff0a0f980accf1eb2c0633591828ba7f75ccedc3a00c5518e03a673c24c85b8ca4183f333c7c8980481513ca4cb90e31e6d530ea98202ceaf4e9a99221ab338a546917e8b15d334316278a65b2802023406dc4893f5f1068976bd6441e6c0c11ce4ab9bb38fb80b07787792f227c769ffa9dcf50f0622134f74c4c60c83f716284d057ac821e66c312b12194c5de478d8d9889d15161d212fb74354c1c958fada469294b102dd61af3ff5495657feebb49cf22c0e744e0a556b835be6ebf11ef3666c43e857f0d4534e054962cde944e5503ea8b4bdcdd7193ac138a089c94fd2d2342028d00455c96707ced4a35a165b2b85368b90e1473c701a2bbf2dd0374e6fe2c122c59bbcba930d88819d252552b655ba30eeab65fa93a3677b454c58bc0bf1c11c218a34de2e285d75f3dff461fa9c2c8e2be7df18ec0476a4031ccddf5ab0edb3dce89235c5979f6bcf88a5b3b918b87c22b221aba8c888d32bd08c83b0214270255198171d82679ba1138416c043b40370b88c130029fa4c25714100141468052c4dad5861dbbcb2c8853132b7717275607d79b6ba5b85c76fd120efc731ad82f19046da840170d81ba7023305962852bd58cc2a9b6dd550adfc5f9d89a68132495c116705d34116220def4c6a538fe5dfdbc89f738f68112fe559243fb969faf232f99c66a4062a4d3c40b25fba49339e68efee3304dbcaeb007144e485b9945dfbfd17a874ee53b305845fce6b723611b66896a5be285ef7d8df1030e695e8bc53459c316232fe257f79dc4bfa37a00d37f01c158a1ed0d0a656e6473747265616d0d0a656e646f626a0d0a36312030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f46322039203020522f4633203131203020522f4634203136203020522f4635203138203020522f4638203633203020522f4637203239203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203632203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e74732031383e3e0d0a656e646f626a0d0a36322030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820333337353e3e0d0a73747265616d0d0a789ccd1c5d6fdb46f2dd80ff0381062855546beef76e90132e6ee22077d7437a09ee1edae240dbb22340965c4936d297fbad7d8cffc5cd2c3f447229898cb841839616c9e1ceec7cedcceeec9ebd5c6d6637e9d5267af1e2ece566935e7d9c5e473f9f9d2f379be5ddaf671f7ebf9f9ebd4b6f678b74335b2ecede3f5c6ef0d1c572b999ae2693e8fcd50fd16fa7270949f09f319a464924ad249c4546506259b49a9e9efce7bb68717a72fee1f4e4ec8246342152451f6e4e4f103a8968a413629888b82122fa7007506fdeebe8760d0d47b7eecee4776f4e4f7e8ea3d1afd187bf9d9ebc86f67e3a3de98c3f8365961241232e0933116544459412632a709d807677a6f8b6e88ceb83233d023aa19b1fae7e8ea9f53a710c4e9e0892b4e26c63d74feebfe8f58f3f44d1d9fbfb7481e2fff187b7afa2e4ec1fe9e2368a6f56e38b7f8dbe4cc02ca2408c6813b0969a24caa3f0df6f47631ebf1d89d8fdf852f966e8790b7a0aec516a07fa1749724e27c7a06ceb31a57c37ca23bbd88e4f13bd93c36fa6eb9189d186a3118fd3c7918ed3c5d548c64fc8f069c6754ae3ebd19865b76bb8e7f163bac227b37444597c399faea3e78353ce416b0defc829f7aad42641b4899832a8fb14d122be9befda759b0ea0db62b7f3d20204ce72fadb486fa38905a6895922d41e9afaa3620dc35284310f0f3a3a613247771c46e961a48ac8969e1d6fc57ee71827f46b30912962540b9e77295ae20aae22be1bd124fe8cf71bf093abcc469ddd5e8f546ec1f7f06bb99e819903c8e24853f5c8645211610fb3a3d4098dd6496542980285d0d45abbd74079606340cde9699f6200924c0b49c66424251c7954d3626d2607c9920390a55bc8b2e8c25ac83a5ee33d54a82586b5a07a3bc781281a8da9a0a0d7a0e51b18adf09ed9f81ef57cb95ec3e3198e4f97783f9f8ea82a20aef1c9b76831e90d42dc601357788f7683372b1809abc00ec7888a02e7630a0dcaf801bf5e6566b67d99c263197f1aa91a45e9ca0d90779f91546cdfb5e9205481043ecbdbb807003453808501193facb5b506e4eb27c050c5bb76780bd2e1c13cadb4389fe1cd2d7ebef09891a33e26661e48d80a22dca4e63a9c6096231bdfdda50b64782911e2baaae277a3b174100f2bb84408ef3e42988c07df67d10bb8be05fa48fcf5b081cb6c8e5a82dc4458f7257c201c40152f0a60713dcde520e2f51400360e10ee8e76a27eac2e04e1b2851947c8a8cd49a8b0ee5469b37f1c68a34907a28941f0a86ca494c420b84253459883ca9170f8878835c4a0bc0531789123312a62db101a4d6c8690d5b84f037510d454c9960e8662287c06d1fcd763284f0c61b485a1ecd8c0b5bd831cb27adba23130f4bf3c4f1269276306bf8580ff2f8e0c6877f498c3986b5b7abc082352ce35916d22ede0304c6027263949fa266d36304d2221a246d36f38c23dcc2218afd29b1b0c4e2a014d160554c6362f7ec91f0e6a3d38a86b8b0398e2965811d013212ac3304af43913202e350a933e1fd51f793426e267146385ef03b2964146884ed063ed713ea975e484740e07b08159ebb93f44057e27b13e2af076ea2534cc27067e263a4920694c928b897de19e8e05fa4333e1f047ea89bb5313e51ce6b119bf4f24a81ad587f9d13ac334c4f4e93ecf8029755f9a024f7b29ca713ea642d43f71c6f03c0bd63109798e8e28ff5d8dadf1def9a7a7229b5b6439113a32c86878069d43e247cb8775a5ad39feae265a59fa8466ea9a4def3e831bdc603ab42af33c04058f59a619eeded45332cc3f17aecd2c912be805b8c7593d9b83476536e21cee27bccbdfe46ebbc8e280e45a72b65ebacc63d3cc25d715988c0d48d653a5a3aee7cb156646658e08f88ecff60050097039a86a129d3b1881c92ec5c4cdc1f712eca67c2f005ce83a84048f632b0d686b4d5f88820a88a578fe0ae7dbbd26caf7ae893ac84f43b98cc2129204c3aa8a25ccbf455348ef312dbd2f346e1e81aefd11adb79aa5022499147c2d632d341daf1ad21aa278ce741897e1519deb5b808ceb7598dd8b4fb4980d9f2ec66fcebfd055a9dd0292c61253f39fe04f9cf18223a260637fbd86cbf432f3413a5e68b83cff1f5c9e45700189e978e3228014bd1bc2455778b9eee08679a0be31a109d72d7d6b1b1bfa483b3a7bb7a55ee404172a00419296b90a948b94150d28df671a5003d9a300c5bce6743d7efd3e800268c89ded172bc01485fd719979788b61e061b1ab403d62cc85297e8f0615bb6e885d0b54b2dd622fdff713bb092c7605213dad3229ed20391b8a284da869236a48c9b1a42139c5504f764bae7cdf4b728c06969c1484f1c10c9677589065810dd6ebd1a062e70db14b8a4ab65bece5fb7e622f96c5aed3f1abbf0710bb6038435e5b27382c39198aa8dc603da206959c6a480e527fc6f748ae7cdf4f723ab0e43852344488a53b48dc04ea0c4b2c91baa533834adc36240ec93ddf175395ef7b499c2781254e0d915f35a6e23494d87317edf56848b173d6103b956586dc2af6f27d3fb1f3c0237302117e2d7ce960b05c048ea93ca206959c6c482ee15bc9b1a6d8ca97790edc4566a192855c66c28a067b4247535c878da6fc1e0d2a705317b8b0141dc34e53ddbeef67aac1328d5cec86617d6520268946a6017d4791ec6652f9be179344e04c43c05f2bbfc8363a5491854a2aa8a65873ea133fa8841b498580cc55d272ead789b1312fbb17249b20ce41b613c435a05c57ca668a19e0fe40158aca049811ddf4d7dbf7e59c6517972d8618d1f6cc290b293bd86e93a821ca03f71125dc3adeb6da778cfb1a6c56efbb9e6e069fcc3682c8c4c71b62f9d76862541baaf1e0a860b4d0adbd0a804a1229be0e03ad21b6a557a82394672af23c4435a9c4126abf838fb37c5b03af944ad4d71245ecea25d618d4e4d59cb860e316128b8aceedf2a1adae1daa462d27197e795e8377e38725d7ea070257000acc8f7b13354409e09e926a81fb60aa497bc7926a3144a5d19e9a6a8fae7035d53eaab7f3a858a5ceaba9d581526ad1b499eb6ca59ee6b547e9bc5e4d2daacbf1f7b832ed2fc48b8a2165cbd6aa694c8ea4ea327c69a3e9e3b4445ed43b39dad4ce22e282f4f547403dbbc917da4394f40aa5b1946e3819ef52d2c0a56702dc68d2778f840c5cf5c22d23bc1603d5041aa464118cd69a36d49f861f302da1a20d5508ffc0b01cc247f54b8c850a9f0a03a9f989a5b366b4dedc2417589533ff65343c79da107d9811ad3a18b8ca896b5725d793a8c0bbfb38789da436fbf17e165504099e7cf16de97137236af3a7f53a2391ddafea0ede6d9cc0a2a3eff33d270a7d3ebc5daeb260694c79113875f6f7db61851798abe113369a97342d179ba2c64ab58e3d4fd55d3bcd4d362aa6e5768e8ca40580df963dc1b1a4d8dc93f7242d870bb78d26dbe7e3d07d2c8bb6d4b6964de154353b765b415b9564215c297037782d8e917c3276459032fb5bd444d20975b73a7b5c964c5e6019f984caca33698bd272f739be9226fbbc68154055a5b51c49d140569e39a158a39e5cd411263a7beeca37f944ff9948561ec92aafb8c74762fb08a1937347e2e03b7f98264afba20d90f1714e7156c447e50c039cf7986d43aed24cb7d1532dc4829fad45e5b5e0edd922ca368ff3ede6297c66722794962ec0e19c63fea56b3e810d3e9c57cc09be50f5cc30ef116e2b2365979f217bbe893caf997b1d8c320bb7619b7e69eb41efa68b5196663e8d3c5601a41342806451289c15f7fbda65b00abcfb9633436cdfe26539c4fedb7d445185c573de08aa4459c8cb94aaed4265f2e07899e91202663a532bd4c5f6ca5429bfbf2eaaa0b7c39bb396db8ad2205c510f8d4ddf64c9171a967bc26a2a86107914801f166360b14974ed9ef3e638888ff26d24ae859691b0ec03848c2663d224c1463297422a9d7ff64dceca1afb54258ed8b22594d5271c37af55e45b61b5da569f57edb596f06e9348e4e6f0164b25c58cdda7b38b71049ee66536c18d6a3d890a3ce784f361e62b9c68e1e3397aeb4df31c0b86921fba3fbbcecbf0f0843b2f23bc88b2f3327c3cefd1053ddcdfd70fc87017cc2eb607653c62229b6663364d70450f5cd1e57c3af891192ac142a2831c29954e128a476608c2051e99c120282d57a15acd2dd486eac2dcd48193205a890abc699361d5a219787e333b60c17d8449a91b1a667718a79503ad837bc03d3c79dcfa881b325733375617cde7cdb9678fd3ab7276741b4ae3c8b367b632c0810352622ee0b3ad8b2c03cf3832fe05a708a850338e10466100cd5873a7f2c3a2384722e4590226c110d9c7be58a297bafb2f7aadca895cb254bae18fa8004f2e5b28e9229cc053718cba51a6275181a7e2c05137b68bbe1ee539042acd5db9036ceb2102ecf9a21a37b3fbb4341894d34cad716ba630f4741a6b54e00c919afebb5bd51009e29eb2200a23777dfceb553277f9172c999b66cb63369e2f8f92f99e42389fce2ecc1b2281d8c73cacbd19acdcf03218ef9a647661dd1069ce3ed679e75204d5a27c61c8c7da85154384a0fb58015fd4fd7d2f357a5864fb0a5cd987dbb5194a8d3c3abb306f8850791ff3986d9cf1f227b5418fce2ecc1b2236ddc73c184f79ef13ae86884df7119548ac613cbe507508b791959ffa2475e153e030d152d29ba4d0a7b15a921ca4e9ff5e9e88310d0a656e6473747265616d0d0a656e646f626a0d0a36332030206f626a0d0a3c3c2f547970652f466f6e742f537562747970652f54797065302f42617365466f6e742f53796d626f6c4d542f456e636f64696e672f4964656e746974792d482f44657363656e64616e74466f6e7473203634203020522f546f556e69636f64652031363835203020523e3e0d0a656e646f626a0d0a36342030206f626a0d0a5b203635203020525d200d0a656e646f626a0d0a36352030206f626a0d0a3c3c2f42617365466f6e742f53796d626f6c4d542f537562747970652f434944466f6e7454797065322f547970652f466f6e742f434944546f4749444d61702f4964656e746974792f445720313030302f43494453797374656d496e666f203636203020522f466f6e7444657363726970746f72203637203020522f572031363837203020523e3e0d0a656e646f626a0d0a36362030206f626a0d0a3c3c2f4f72646572696e67284964656e7469747929202f52656769737472792841646f626529202f537570706c656d656e7420303e3e0d0a656e646f626a0d0a36372030206f626a0d0a3c3c2f547970652f466f6e7444657363726970746f722f466f6e744e616d652f53796d626f6c4d542f466c6167732033322f4974616c6963416e676c6520302f417363656e7420313030352f44657363656e74202d3231362f436170486569676874203639332f4176675769647468203630302f4d6178576964746820313131332f466f6e74576569676874203430302f58486569676874203235302f5374656d562036302f466f6e7442426f785b2030202d3231362031313133203639335d202f466f6e7446696c65322031363836203020523e3e0d0a656e646f626a0d0a36382030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f4635203138203020522f4636203235203020522f4639203730203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203639203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e74732031393e3e0d0a656e646f626a0d0a36392030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820313438323e3e0d0a73747265616d0d0a789ccd59dd6edb3614be37e077205603938a9a16ff24b1688a356d5a6c68b17609b08bb6178aada4066cd9952523b9d9fbfa66cfb07328d1952725516b695810283479c8ef3bbf3c91272fd26c7e154d33f2ecd9e4459645d32ff18c7c9c9caeb26cb5fc3cb9b85dc793f7d1f53c89b2f92a999ce797194ebd5eadb2387dfe9c9cbe7a49be0e071ef5f0270c03463ca2b4a282935032aa3949e3e1e0cfc724190e4e2f8683c96b469847954f2eae860394f608238147432e8908a924174b907a731e90eb0d1c4caecda7b0fcf46638f8e810f733b9f86d383883f33e0c07adf10b59ae19958c0845794818a73e618c866145ae95d0ddcad8bd5619a383a14e8027a87931fde870afa6c43198c293d46bc46c32d707f34bcedebd246472be8e1274ffbb97bfbe22dee46d945c13e72a1dbffec3fd3107cbbb1d1c284d590b82df09c70fb098e753ceefc0121d63819fc2bbb08ed34bd5b17caaeeb0e133cf3b65cfbb558d0bcafe2b97719f86fe1d5867dbc81d2b6791bb810323e964ae74a01a9199eb3bb13b160e4109e1a4f308562e173179da2d3dae1815a29d29ccd23e04032a396152c13e8f064c6b6dd0ae1e37a71feb39fda40f05a8d4a0897c1327de332721d046154e6f23028e9da2a757ae7696cbc865dc496631fe21381dbbc2d9460b9789e303b1c68bf98c7a7e032f44dd64108486439e01c9397050ce7ce32a6707ab286116d76ee8acf214244abe20758323949aeeb7a37c0aa2466813c3ccc665b2f818a52ef39c6b58cd97318475821b36040c52b14c5c9800cf4b608cd4aa96c3139691b15c29f676ee32e62439c21842b473fb49b8c67893fd5ac49ae839d638246195d2efe080040cc395704c38fd5c75ad283c6bbc6784c00b28b4cab0ce94d6377ec155290edd8e13607c30b80f0b509ef2057ab8f437aece70d64455e97544d882e322ac6430758902b04b1d48cc100560bfb10211e61f525c96304adab865da4ecc133c6dd6bde785a45cd4ad1cf780a469a0ea48658e9596311e010b16a954ceec13c59822cac138195a2f2d9c61b6764dd7869f17501d56f96e81da983be86d55f1f6937d4d88e053b2291592a53a18941ba385218d397fa8a72c82d9389e9860fd7636686c8b51f7b9cf65407dd6a0688bdc97fde6be8f1bbf97932a396db6e3f3b31e3885d0e5fb554e676e5997d177a67eaff79e338e7dfa3069bf27d28c05d83dd449371bf2fd9e505072d86bcda01d825684634fc4ef6d88c29e1d007fbd16ba1c70d21d70f2efe1845da6ac72ca374544682765d07efc3283477c090fa81b819304f078fa173c46041e5b9c5b9ce00e063bbc87f5615e4f0a71a668c81a146a6164c67ab63254aa23ac7c735298da94da8795e17d59d8d354050dcab4b17017cdd67d16c61719fe0f5bf8f6e4a8dba98918d31ede4e75629f3ef580e5531d34608d46183e9de3d95cabe11dd7cd68a2a90c6b777ca81a901ec11db570c7e0d3e2b20ae0ee52d8a214334b1ccc4d3f3dc6cea59419d941d1e6c220b3333fc16086831d3eb0eb8970308541660fdb16eb0a84bb36a96402dbd9074dda985c5d7433f7251717ffea66be2bb9e2293cbeac7007fe4739baed3e1e39a72c68e0d95b3cd690301e47181e3736a0223bd8d910dad999d406e612066b1c2caaf1662290d8a5e82082f781496c3c46d54cc8adf0132bb338e082c77fb1337fe3203948a2ad3d7e71a4936a96535033a04d7fd0478d01ae7a0e70c6a83aa89b5bf35604a2f5583bd431b56fdecbd730dbd8c1efd70e4ac30daf7f30d1c75c3027dee27bd34591eb63ce751f572be701e5ac816d0f572b17029b9e3ad6084b590f57abe2f8bd4c1defb85206097908e333ca7503cca3d10d3a2ed04ebcc9cad16e1b2df29d9db6b369bc5c2fa2a99d5f47693902e92776329f6fba25ae3c4e9b78c780da2d92cd8950534f1c40ddeca6791693db9311be17ee1293c13faa923760b6290e41cfc52108a862ffff2ea0ceb38df1c29e8de72bea573c5af97296d5bf9c3d1634849a25eba0c7179106284d83b00554a3d175bf6fe194821d0fdeb1ff000777a3330d0a656e6473747265616d0d0a656e646f626a0d0a37302030206f626a0d0a3c3c2f547970652f466f6e742f537562747970652f54727565547970652f4e616d652f46392f42617365466f6e742f4243444b45452b436f75726965724e657750532d4974616c69634d542f456e636f64696e672f57696e416e7369456e636f64696e672f466f6e7444657363726970746f72203731203020522f4669727374436861722033322f4c61737443686172203233382f5769647468732031363838203020523e3e0d0a656e646f626a0d0a37312030206f626a0d0a3c3c2f547970652f466f6e7444657363726970746f722f466f6e744e616d652f4243444b45452b436f75726965724e657750532d4974616c69634d542f466c6167732033322f4974616c6963416e676c65202d31322f417363656e74203833332f44657363656e74202d3138382f436170486569676874203631332f4176675769647468203630302f4d61785769647468203836382f466f6e74576569676874203430302f58486569676874203235302f5374656d562036302f466f6e7442426f785b202d3637202d31383820383030203631335d202f466f6e7446696c65322031363839203020523e3e0d0a656e646f626a0d0a37322030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f46322039203020522f4633203131203020522f4634203136203020522f4635203138203020522f4637203239203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203733203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e74732032303e3e0d0a656e646f626a0d0a37332030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820323930343e3e0d0a73747265616d0d0a789ccd5c5b8fdbb8157e1f60fe033728106b0173c4bb1424417772438a2cbadb4cd102491068663c8917b63ceb4b927de96fed5b9b7fd1734849964d8e478ec54983c0b1254ae73be790e74ae6e4a7f9727c555c2cc9c387273f2d97c5c5c7d1257973723a5b2e67d37727677f5c8f4e7e293e8ccb62399e9527af57e74bbcf47c365b8ee68f1f93d3a74fc8efc747294df14f96194652a272450527996434e7643e3a3efac78fa43c3e3a3d3b3e3a79ce084ba9d2e4eceaf80847a7841193d28c4b22322ac9d91446bd786dc88705bc987cb0bfb2ead78be3a3370392bc23677f393e7a06effbf5f8a8337d3796e78c4a4684a23c238c534d18a359d61ad769d0cdccd4cfd6cc581e2c74023881cdb38b3703ce3c260ea1295249d320cd90b87eb57fc9b39f9f1072f2faba2851fd3f3f79f994a427af8af203195ccd87cfff967c9b823961004686146c94a1a9f610be4c8662f0cf6f55aba32a025441a042de44f5619a9eb2c787900c31cad21468dec4e8612c86e9492af94df45e25d96084c25d90440d9645a207e793519198c1ea0b5c200f7ac7c35398b8ac23fff6563335243530ef05b3ff2059a477f56378a2b21e26aabcd9121929a8e615fe10f410261e19138826ddc0747e90fa82a43435698854b180f9f2316102043194836b9c54a384a9c11cbf4d474b985304a6d76573c38e9b16e53861da8d5f4de046064f64ee6635166667c2a4bbb44ce4a080290a178b15bee50bbcd3def977336655c26b4ceb156384351de18072012f004f457b978c10862a16904c878921224f0c9651b127241919129825267760da9f14dfb27b9a72eed1410f2b33eb61d9611495479169aa029c1dee477ce6b8401af185c835cd7480ced3afc9500d2e2605aeb179c2d24151af4e585c07ba0d1f460e3e4cddce6ea3734ea52659063f2428dcecf6142aee4cd71064b06ccfd5a7236332194aa885e9af60504b0236da1accaff0eb02150a0aae4d389a5c675ed19ac258b866ad319ad573fc0556595556d90e2c3e593b6f5f642f1c3c2dfc501aa68456017e3ac8d84496b156d4ec9aad214c59244c5c08ca19d14a6cada0c6c586d57da081f471e89ce6c2c7d18b8df4a9194575ee5123c3759a551c6c3137a952017f907426a932018197b87a66530871de5fc2c7eafd1202181bd130bb787a0f4b34a72ca4f90eb3318fbc42648aa9c97e98581f19e82e50dcc0bf6d50b3154167b7b071eaf4daae9391fd3e2a13e7f3ac75b31a7476b1b8422d5f35ebaab193e5b20e57db41eaa7c29a4e6b58ede2bb29a0d5ebf56a6f2cecf5050122da45e09bd172ff06574843e1515f4a5d54173927d34c51b62fa62839596d0530704173070189501b5660367d8f5193556765033c3fdabf39e4d6267968de44b281902ca273f6e88dcb4b584cdcad0d9cb1eff1d7a5ad45c00ff0426af0fec22e2437a7fb378a60797cbd60722094b28ee1dda3384211a004960784628d00ace6d5bc777625d69c4234bb2c90c8b9a9ca726af60615393b55c6c04c08c4c743c6b34179df4ecdcaca329ebbea05cc55668d3b93ac31decdddb98babeb78785c1bebaad881cf38af523d041622c99d3d98b74b26786fa386824f5e246df36f4755ae6255556470d456b48e77aa3a4a33e4416bb80b063d1e2cdde9f8bf89f48159d62a206b749ea4662bb47d2dcec7250e71b51a7807df783c45e3507d47bccb96986b8cbd97b9aa79a025152c182f5bde4b10832d58b59d722337d95ed3795d8f82980ff32c2b88c96a513bf60f8d808b129fbfac8b60f85e1b368cd12d34b5b1b5ecdbd34b6048a0ddf880aad72f44084f2214c124a7da04e4d66551474ec4956218baec092a7226aeb06ab8cbfcf55407dba6d3aa83f13875308fb37875b0f8427475309fcecb726c6b5e05660893f1c25ad89885b08c66f9edfc364a573433248735a93b14c258e48a88e29013e7fb2ec05825911a14f650cd864e27d64cfe519bec62a3f9600ded0c345d773aae0afcfa1ffc3a83476c83a1c9d4ee5b5f6f0b6663ec80c044010731aeedf43ad95b959b2d0e2f1910d14a689a53230272e8a29cc8150299e794ed1b1cf25815826a55c94c6fadbe6107507de4be26040a2ea53a00aaffa088c1fa0df27fc7454406d95b2e7d1c718a884c6b6a3c627751436446519505e47dd735448ec5431196416ab40b231ebd1d442a234030697c0dd88cf9408a9ae6c1ba85a1b923986e58c4b47fc966607559fcd5bb2e4b2b9aaabb9425442c5c0564e96f6f3ad42c8894d56adb360b3f9df66b169a620e5cd721f5c512a780803713017196fda772dc602ae7f3f63689b0778251ed1b988376f205bd70ac1d38756860ac7af60c0dfaa8b0ed0a0d3c50b1fc55151f78f4be4fb53be5b8e3711b0d3a2dc663bb2c26b0f2ed4b229a99850415827824b859e18de0b2448a5d843b9b55d8bace7c3d4694a5d49864fbb2ecdf657195d66adbe02da2cbe22aa722a4be78d114afe7cb560f2c42834be306699fb7082e8b6769588e7dbbac58ad8eda656986fb03f674597d946a77b92c0f546497e5d1fbae2ecb43f3085b20e0ac863c5aaf96196b893cd2ae7885fddab4eed7c631bad22e2748edb5886c2564867ba1b659bd8be62f1a5f4c513c29c733be90b9f72fd6a02fc39e6958ac8c5bb15aaf06249ef4bfd12bcb6d1e16db6cd8942fb3a15d6fa46e32b1911b4f125681dab71bc6237708a45058ea69817a559064a85d87db56bca6c5ba575cb534e176536d2c9a9bee86fdfd6974e1daa670c1f642efd7d5faeb7a172b366bfa5f1290424be5731569b7a3dbe3e9cb1045a8f29b8e640c55ba214d95aea53945abef3ad5e364bd374d33e70271a781acb60c8fafaebe6263be79d6f6a0ebfd082af3f728d44fdedfd854ac53ff8c872359f5ad71841b3db29d9648ad7fc9ade56c89d1766cf0884ab5836f81db94ec3e0edb99afda33b62da49dabfc5800e4dfb1423baa37092ebe62c3ffbad940e23afea80964afbd4fa0eae75f8dcbb1dd65c8b4d7297275e0d527b763a2eaf3db3b5feb5ff865bd4f3146c35f6258ef4bab8b3589dcda937047eedd3daa5b5aa372f8f7d7fd8312b90db45aa09e8162bed41b335a2bae35a96e3f40944642cd202e4c7900755894bfac11b10a44c3b7769108e5b777a2058fac844c614363cf435a620deac5e93782d23b401989f6bb056ab570d3221fcc1958883f5fa29938776d6433280d7c3cf8177cfc0977f3cc47f0515cbac316b733232331c3d31cd37d9f990e69a550b1403185fb707d5005da5bb4bec57907783a163c6930f9f1e17551641f21d9ae59a93924136d501f47b6cb0b929bcc3082f80c1fb3397c4c707e921f0ef23121244c713cf2eb23e9229e3e7ccc2ef1a86d1fd379d1f62f27c3f04cb20fa98b9c22efe410426f45a55dcea0463eeb21b8c46e680bd4a4a803357f2bab6c76a236db386f3d02e74259f4e9d54b218b81c058b890b1bcc45962234072ef235e994cf0d1d9bd08bb7c0ccadfe7b88b1a229fdb108c6d4dd8dd6a6031d5f0d92a606ef7f361006d03f108fa80b58a26df63bd8b3e22ff3f02d8b3df0cf676eb83c7d4c70f11642f736c13f86c76917de4e3101c3bfbfbc60052f6102eef7072788eb2f9cf3a6247a6524562a68a4c7d663a44a652c702e522531fd45e91a934b1e0b9c8d487d7459159e459a9c5d6c1fa8dc8f4767c7d64fac1380ccf5965017c6fdfde8e4af591c9875165781edd47d541958ac502c524cd43a2fa8ca9c57c82ff21019a9073fc59fe8699c60a6f7480dc4709210839d7d8c3f936398ab8750df46cfb46132af2593a0e917ffe7f1863d795d6cf3072568f995cde6b6aa80f08d65537cf4ef51f8c08cef16ca627a56d5bd10b294da5f149dd6b44b93e58f8a9581f555fb74c6ce9feda1e78b8688ebcbb523456b8574b2c6e3b614f92d621c7a6226eabd4ab71ff275c8d3d8feeb136ec9f52c6f0749347c99deaecbfc02e73662de436bd2e2b3bf2813a0ec9e4a609fc8e791bbedbbec31ec2f96d8614e611720754bf09b0de451f915bba1c9249752ba8ff01a5cde43a0d0a656e6473747265616d0d0a656e646f626a0d0a37342030206f626a0d0a3c3c2f547970652f506167652f506172656e742032203020522f5265736f75726365733c3c2f466f6e743c3c2f46312035203020522f4634203136203020522f4635203138203020522f4636203235203020523e3e2f4578744753746174653c3c2f4753372037203020522f4753382038203020523e3e2f50726f635365745b2f5044462f546578742f496d616765422f496d616765432f496d616765495d203e3e2f4d65646961426f785b20302030203539352e3332203834312e39325d202f436f6e74656e7473203735203020522f47726f75703c3c2f547970652f47726f75702f532f5472616e73706172656e63792f43532f4465766963655247423e3e2f546162732f532f537472756374506172656e74732032313e3e0d0a656e646f626a0d0a37352030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820323835343e3e0d0a73747265616d0d0a789ccd5c6d8fdbb811febec0fe07163d205270cb15df4429488326b924687187de357be8874db0906d2551e095377ed9dce170fdbd97fe8ace5092255b5c87b6c56d1781624994e6e170389c37eafce97c59bccbc64bf2f8f1f9d3e5321b7fc827e4f2fcd96cb99c5dbf3dbff8f5263fff317b5f94d9b29895e7af57a3255e7a399b2df3f99327e4d977cfc9a7d3938846f897249a9188a85451c14922194d3999e7a727ff7a48cad3936717a727e72f1961115531b978777a82ad23c2888e68c225110995e4e21a5abd7aadc9fb05bc98bc3767497df6eaf4e43220e15b72f1f7d39317f0be9f4e4f9ce9576d79caa8644428ca13c2388d096334493aed9c1adddd99e6d9a633a60f063a019cd0cd8bf165c079af13c7d01491a49195a68d5d3f997fe4c50fcf09397f7d939538fc3f3cffdb77243aff3e2bdf93e0ddfcece53fc3c30658de3dc05aa5943900dc931cdfa0c5a298726ea5850320133300e238aaaa4795c554ddd1c3c751f48c3d19b6935c50765f0ce5314de23b683d1d8fff5884672a20d92a8c835fc2331990db2c3c13c1344c831c7face6558b90896092957869810732cdc9325441860f8da67998543f57e4d1b03d104c50aedcb8656ead654853c9098f344c5c101ecdd23435e4de3db44f20e67902c91891545db0a1b761e29e3109814cea60fa3e23200ab7198ca882c10731c0f3090ef90333be2808651e4a737d8c97b20534cd4351b74cea8665c8aa464b689ca1888800e40c9bc1ed05de350d67406384efc77605922d97f094699561abdb7c0c2f35e747cb9645e3a734611646380c8ef03c381ca4764f48d213240e8b549202324dd3a4c544cef0c54ac7462f7ff3dbb0c34305fc2171a668dc277e1994b36b109e2b904e5e09e69551496b591b5e580460b200b9f4d4f154a359d1a75798c965666531c6dee721533523b0ef57d30c18711532be314587e6874818157d7cb8540ba58c4cbcfd7d78aa6964a3ea343f94df291be383fb628a6b4c7979f6f36b0f9812b047e32ea617a068cd628fa2721db228b8316b3eea5e9b9ab581d69e403366d6eb3e683b237f5c034a6a0ceb5e33b01760c9356b3fdfb9f0a79e0700fe8f1cfab2698c442da857cf0e0415ef0085f694ec825a2d2a914883390b75f0d7091cf2111c8a0c0ea586c3a37fc3e11b0287790e876c622c4687ce304f9de1514a95b674e6cc0114f7050a96ab54584065684d2d9171230778c2173ca9a9b0f1cc6520a567a9046c9ba03ee42863e88e4c670ef894277c2ce2a8d8fbf8debc7140157b4395506de39acb506a5fa098c475b90feaf30c15c7140e135421233c2d3fc261b6c21b0e90135f90d398a6fa403ea69ea7040695e2831535f84e3af830ab14758a26ba0e96d86e740987e82d1c7e7770437dad463c86159a593ae9e21baf5795c5d98b43d7ed5d9ce762cb98db50463a209f5178e770984e1ce0724f70998c284b2c705d78283cf39031aa3c092f73155ee9a98f8df06ef7d185ef4338223bf8ae52308cd22ea8916163096cfc88b2bb9a1fe597ed50fc7dd22efc883df323d154b3830471783e6946636e81e4c227edd781555a82efbe2fa8c433a8d88419ba51ca07e1597c471404438ec69f45ef76b50e25fe27ac228cf3ea16ab5dddf6f4fa061579064dc6f0cc972650695e65e290a629be7d55e6cd5bcd93bf3414e70dd9c5022e15b390b1a0249b2f2810d1070c565d7f415fa0f8b4f21098912915a9857147a717faa414a75a59488155c7a28a4bc830a6abdfb71946a52a5664c8bd511d7b181a98e492726d01463d90d24eecb64e9ed4f3e491c9fe6a46784e262ab0f7d28d35e2754170066332a09a3166e61653984c4515bc6c666c1da68a83728602764de0b4ce4fe0d404071be6561b036e1e5b6044b45cd4898b76ba7ec11626485a34798cb9493774b31e5d4d83af1f37d1b36f9bcc04ea8c07cdd5054eec0a6cd6a8a4ed54099c451e42a39c4a6d61af87790f4fc0a37d529fcce81524475ec360c495cedc1c4e54afc8070f73315654255f678155ec3da700159ae87b83e27ec3930aeec41b79a621e2c342f80d10f7517f2d402ce4668458452965ae2162a1fc0e824c354df7752284afb852030a2cd44d63f028efcd35f2297c45a6b890546b4bb75c78ed2bf6d4f05a2bcad460c106e12b2a55071bfa705d92d3435815bb78180bb4f8fe9f9cbc3e24173e795e86a43cc043979e4b51a43031d80ea89fd12044cfc1f85a2cde721de4da7360b53356ce4af4b8ccef4965db89e05d5116a1ecd88f68a9cdaec16ebbcec9aa79806d96a9a0b5670a0aaa5b5d77b2f263e06287f0a4b97f9b0331b85a5990d8ea51fb16b0403b5da90a6cf06edb18a1aaaa0e06fb37f5e0a8c4e8a1f479ddb00740d4062c4b2db0bb466cc3cfb5ed5d9493625d7150df1fba038db0a06fb7a17ea26f515a4863b52cd7638332117940c258a5087b486e3c908a3181dc2735bcd3cc3843ebb94faa0da44c57c59ab966a27c344bbc69b0e93d25952c9131066bd6aecfa2aa0bab07aaace747f55ed5fa5dc6132cb3aa1cac091eb4efbc3551956958bda59e47589c4816e6e4065a5656eb1778c5755e1a6704101728986da086e4e5d2649f36a2425b411f03d4c46dfe80572c30fab318de7341ef20b60db38b76f65c8b26192c677b83f2558dd6d49ca70926da8ff05c86f347fa58b618b4c66cb2ef6e5e87f45cae241293c0d873543d87ea0598963c3dd8ebb8c56bd3bcaa558527fe824e0856ab4c31f33c1bdcd0e30a662db3a07661e510d1fc5dac04eb531e96f5b82bfdd6b0d76490747019c1e1c81a3f2b5713f02fb4a5032e5c1d221db18bab0ad64871a7ab36b82751959ef4a9bab06288e0f22e5688746b59387aaebe01674c07bfdd62b000676c6e8a43da62057ceef3ac4adda4e80bc323e1e04c1732a12cb5f4cfa5c634f29b53175c6318c3e7ac6696596dedaaaf128c66fef7baeac27f5f85160dff99c25af8cdcaa6561ebf8ecf57cd45a3297af85c98e6ab48a2615ab5cbedf8d88c15bcf2c5d12a8ad307efc2d17800503b8c378e65f0fb2e084a7b06a5e3fd4be8d440f503d6bd84db883afb08a59f7d843d1ef8db43f855761f4fc7ec1fecd3796eb609cecd9ebff1d264f4f0bc3093da44b0b0ae21ae370b4e303b6a72b372bd6330c3a8c0e0db057992d0487d9d316be99054c2cc4f18886fbd4b50eff4c994e77c3d079397edbd85c473be9eab08d9d401f50f0c8990265073d7febd6e7016a33226ee3aea94ca6c0411f33657de8d1781f4a8cd3d85b588f593fcfef70be25210330b435c46c9735c9f0b8de5e07b82f215d7e79829d28473b53513c1e214c19f3ded9853091aec7da275b1c815c6fb8db0adae504a3703fe830b8b30e1f63e9a4b0c563fc460f95bfce5618f9c5298e3ec53769108cfb144cef8fe7b6d63cfb14486fb80f9011a2e6b0b938aa6f4a7dd0cdd8499d77a0b53525b21e905ba61db3bac4943cf88e6681dc5ec2abbdb7c5dbbe44ddba5b89af699e332629e83972cd1745f9b3c1e2276695776c64360604e88fbdf1fad24ee61df267efffba38530e5677d20f7a0ef18c66bfa945d84c2734d358b19d57b83f25c53cd64bab529d58fbedb4a0a8b8eb65b9f6d9646b6cf66bf66655b43b85d470c0fb6f9bf390977e5fc7b5fa5682cc89e72ad3a82aab5aa14f0a45825ca846d145c44c3b307c2d06ad9d768d0be3c102e39e6a8d0e1eddab67e356b9dd789fa742f833ff952e23195a985defd2b7189a55d7d20f7a0c439d6ecf629bbc89f67df8ab17d6d0dedb9602a6d3f1876a0fe361e79f91eabb351ddd55ffbd95097ad2dda335cdbe2a73b746bd7b56a37c1dc9a2f4b09bf66ab305f08d9e690cba079f67d1245e37d4d01edcbf561588b204050691adf9b838ec909d6a7f93ff1cff17b3e52f5c10cfc399ffa4b3ecac2eafec692aa88aafb299ff597b27a5370f8eff92434d1db28bd7fce475b88da67c67f0187c909c30d0a656e6473747265616d0d0a656e646f626a0d0a37362030206f626a0d0a3c3c2f5469746c6528feff00490020201300200050007200e900730065006e0074006100740069006f006e0020003a29202f417574686f72286e69636f29202f43726561746f7228feff004d006900630072006f0073006f0066007400ae00200057006f0072006400200070006f007500720020004d006900630072006f0073006f0066007400a000330036003529202f4372656174696f6e4461746528443a32303234303431383135303532332b30322730302729202f4d6f644461746528443a32303234303431383135303532332b30322730302729202f50726f647563657228feff004d006900630072006f0073006f0066007400ae00200057006f0072006400200070006f007500720020004d006900630072006f0073006f0066007400a000330036003529203e3e0d0a656e646f626a0d0a38342030206f626a0d0a3c3c2f547970652f4f626a53746d2f4e203530302f466972737420343738372f46696c7465722f466c6174654465636f64652f4c656e67746820343935323e3e0d0a73747265616d0d0a789ca55d4d8f2cb971bc1bf07fa8a37c7a4566263f0041800cf820680f0baf6f860f92bd100cacd70bef4a80febd23b239bd33fd8a55c59cc3bcae37ac0c26c988cc24bbbaa7e56ddf9a6d96b656b6b4e7add52d996cad6d79d7adf52d9b6d7ddf642f5b4f9b58dd7ade746f5b974dad6f5d61bd6f1d20256fbd6c25e9d6eb560a0cda5613eeec5bad3be0d157ce78456f55bdbb9ed9adc0a0e195bf13de68f869bc13ad49f86bb895dc45dc978537775cc0b194d2865b7073c20f1d83052ed8013c49a6bc0780c5c1f0532a6f0660250efc4b8d3d6310a9d1cd8c9fde80913a2781fda42dbb2ff03e277317b69c699115171878cab6656187185196c29beb9695f01993a98ecce9e40c6090d9e8a100b9700e04c885932040ae9c040c3b574e8200b9711204c88d932040ee741e3fb97312a46385d42700175893a458aca4b819bf158c0717b24936dcacba89ecbcb9e0c27873dd4439406db8e000316ce1ba26180857368123527c4601c8d5254f84eb8b39c6050708ae882fb101b955cc3af8223df31e20f786b5026774e770ca4e1e611d4ada948e2774a309bc4a05dcca74be282ec09f546c5341cf091dab9220a5e282ae960622920505c8068b0457b4f80a03b9d0312cb9562c1ad61c1715c8704e1b1624e13fda3a7f83be7ae13d6db3dd9b3a2ebca982e46cc200b08068c2c2586653db37136f8210d49b2005f526d9ccbca9521c6c0272f1a6b259651316cfdc0d88cbdc0d68cedc0d4c447137b09cc5dd80f28abb4199b91b149abb01fd1577032b5ddc0dcc5ac10841e17d2b461261c98bc1970cc19522ce6e5ca0e78c092d1504c92041a99d3703b9296f0660035886be4a374a41b6bae3c68c49af3b3a852620747219faaa1c6e06516a56e0801f5512ef411490429cba55a53820e1aaec0b8aab86c9ce501366053e434db5300861cd6a0513a0b6adb6e46ac305c70588da392ed0ab76bfb96f9032dc807e1a5500456e8decce006d9c890c7db50ce66650b031aa41acb8002b3364d5d4e56bb8e8bc0780c626b0b351a710342ebca9218881c259192d295665bc446ce3b0b192143d02dc4e0fe14167c4cad05727e348ee4e530ab28b3721960a9b30c55d0908ba77e564c2ddce389621b46eec9d41b9705a20b45eb83a0ccc15161992e80deb99199c1bfe97e165ef899106c830db3c60ed3b16229332fb0e89640a67f7c056187eddcbe24981610b6ac315a7bd30f80a4785c5c41527dea3bb72e6a1385c71ea196577e3dc7bac2f9c7c4684bd14fe8efd568f71446edeeaf1dd5b89dc19521b913b889f193b00085f181493c75906cc44a1648fd7c4cf901f3200f9d53c7b90578c32887f89f193578d169d7981e3f02ce2c2e8ecc395d1d9874b83f128b9361856938ba3b38fa68cbeecc357bdb30f2cd3e6f10a5c43e4db3d9d54fe8e79c0833203afe70e8115ae2aef63dee09c0a231bd8963de1e2aa30b057a617d054205c8c1bff8aa7bfd2684164aebc3006629a80cc5488410399b9108eebe6b9095d322d18af3077c2748806a030d40b252ec99390a3745e394a653e224a66b6656210cf63c656264c29deca3eaab70aafbc957d348e2d13a5736c4c08d23936462aa483c2d4c4a4c5b1619d70c5b10993147520c29c4e8f84a943a579ea622e631612a62e831fc2cca95c4b617e549f21611f3e435038169f28ca3e1a5b3d6b76b6aaa73b6f659adbbd9539cc531e1880576f65eecbdeead592306932c5092b24160ce673c55c8b4c509949991b3d957a72e4288d7885899219d8eace8ceb1913ea44ca65cac44ab1e2c21554274c76d633f330913b78858ccc444a5e19b324eb234f0325792b1326639650d385ccf4d2a4f05fa1a68b6266859a2e06b60aa3009c82cfd47429ac03a8f352c115a1ba4b2532f55b5ae6ef68d1c826aa1bb111285472e9d029d983742cb468bce2ba51dd95b58b50dd953950a8eeca80295477a5d6a479be666dd298d495fe51ddd5d7bc7912dfbdd0e015c6cf5884b8451637cfec18b550dd95650a570757188350dda8add047f77c4f9e52ddd5bda7ba2b2b40792478b293ea6e3b50854a6eacaaa8525ce16ea52e1b03b752d38deaf41aa571fc5e5835ceb352e7c82cc90be8e4a945a9e4561251d847a9ec97bfabcaba885529a0714564ceb352bfad0b5bbd5ec0f895eaeebbf2bec66202bad7e46505ab22eab733612a234367fc522f73b9a24a2577cdacb95840284b232a19a2800575d9999d991a5179b05f2a19198e16ecad0a2dbc1ca12ff228a0614125f7c6f152c99d7188f380abcefb94c50954a15e9d50fbca1a7767f9a82c7277d608ca2a7767ce52e6c09df1cb73cd4eaee8a38e014fd5eb17f356221b5b950550f15622576f2572f55622376f250a260b1524fbe0eaab972fee1ff36a62894ae6658674969cbc62d168bc4fbc9545917aabd740deda581f712d991b2056ac20eb062c8c97a92c8870b716f6414eaa57543e6bcc76987c5a7899c43e8a1743ec8399327bd9ca9c9ea973e60bd44c1c25737af6196229927d86b0da28adbcd58b2c96ce557c0703dbead515f1984791c0d107ab00a4d99d55332b2db2b8128f1b11f59aad73a51b7b639e467865fda55e5ef30a7af17c2bdc41686351c6ba531b374c2c5bbcc411d70c6b09614c53ee3c11a4d15b67d1c6f1533728cdc065653d8010090b2fc5dc7b2ff7a81e2f29a55233ddab3a56ef5efab9f79d7d707651e3b3c23316f9c2120ff3625ebfa130c115eb36666cc6185c75a2b0cc63f1c5fa1ee55be67ddce671cd91307885b535afe70cde3353e20a6bc61d0ad2393469d020aeb002bc03b561e606dcab44ee3c12919bf277ecad27dec73ebab736968cd09571778a2eb1ebc8ac0cb929346e54cdf714ace38cf1d4b25792dca6b39e32662f63ed648c645438aa4aa305913927e6db54035bcdf7a9dc381b6b27642b58b03c37e678e356d57731e6d56a4bbc8fc8a8907145e42efc1d6bc57de77dac2477b0cba8e9c2284a65807e581fa3560b2b4daf750b33bd51c985f1d5a8ee42561b955ce8af5797c578f640ad62534a3caf56d94a25fb66c6a8d5d2d84a25170440dc470f500e6f1c292a58ce2e955c590f19755e590f19955cb3b7b2d2156f65edc9586a5472a5228c4aaef483bbe5ec59889b3f5c711b4925fb46c6a864041f5a7805eb2727f4a0d33f6ab5eddecaba75f756d6b2dc1c1bf5dbb8df31eab7318e1b75dec45b81d2d45b5907abb7b2d2356ff58ad85bd947f1569e28b0de30eab7b957cdab646fa507ee15f5dbdd2beab7bb57547777af1009502f7b2b6b68f78aeaeeee1595dcdd2b2ab9bb57d47977afa8e4ee5e79aded5e51d3d8cb60cdbb57cee49f57dd0db3f8dbdf7ef9167bba6ddffef5cb775fbefdf26f7fffe9fb2fdffdf27f7ffdcf5ffee587efffe7cb1fff7ddbff63fbf2ed5f36e13dbffbdd3ffec30d93b46e92d74d64dd44d74d6cdda4ac9bd47593b66ed2034b1959fec0faa7000152800129408114e0400a9020055890023448011ee4000f72240e047890033cc8011ee4431ef0a8fb61f4dd4f7ffaf12bbb6ffef4e35f7ef3fd8fffb439c2212b96100e39b28470c898258443feac20c8219b96100eb9b58470c8b4258448fc49deecefaf3c5e65bcea78b5f15ac66b1daf8dafc72ef7fb2e47c25fde675d5f24e840dc9440dc9440dc9440dc9440dcd440dcd440dcd440dcd448051520900678a0011e6880071ae081067860011e58800716e08105786091523ac0030bf0c0023c18cb9303db9c259b1cb091808d066c2c605302363560d302363db2a62122449890225448112ea4081952840d29428714e1438a1022451891238cc8a1d81061448e3022471891238cc81146e40823f2312378a27f591dfffc7163f3090809c58f3a8afe5a7eadb4bf72a2de77e2987d4b10a1e854db18479f8fa3ddd860fdfc7183f5198850ec6b6393d6f2c938e4be13c7ca59820845d6363695cd4ec651ee3b71accb258850dc6e6313dcdac9386eec82df9c98e87c0142433aeffb631c3dcdc7d1f37d27263a5f8108e9bc8f438bae27e3b0fb4e4c74be0211d2791f872cbd4ec7716f6bbb6614d1f21bdf6a6083b26293033612b0d1808d056c4ac0a61edae4f466f4cd9f7f38dba34ccdfef97fffebef671b9517c3fd2d1c7df387e31af37184981f478893cef5dce774ccab777633a7d331bbaebdb6e17539f1ba5e787dccd2777653af8fb97aed751b5ef7a9d74f4e7df3e5f77cd4c5ff77889506968ed77a8d79beb17b194c968be93b16d23bbbe9f41dcb89cf139f4e5f1e43cd7673fa729e4e5f9ed3fde64673c9e858d537379a4b913712e27328c647827c8e44f91c09f379424fb9510ebcbcd1f61988085bf8f8bb135de69ae6c3eeb79d98e494158849765980901033a53fa642f7f19ae653a2372ad69777fe3e0331491f2b103135c8988a110e751e0ef99986dbce4cf2c00a44a4b6e227311ee36827e35878773252acf1331fb17c2011854b241f48241f6844751ac9071ac9071aaafa23f94023dcd4089734c2088d3042238cb008232cc2088b30c2228cb0d04630c2088b30c2228cb049d6ae37cefb4628b449d65e8028a1ac5d476aaa27a9a9decf2b25549fd693eaa9deaf5bca24cfaf404cf68b2b1093ecbc0211cace7514606d1460e3543b7f38d55e417c7b86212dd8a4804d0ed848c046033616b029019b1ab069019b1e59d31011224c48112aa4632ef053a397821bc7c9e9981a4b1011a6f03385d4283febcad7744c1d7ed8f5b61f1126f173b5cf18f155e7f7dfb64ac7945c823866e80a443ee6eb124484bdfc24f263356dbc96f15a4f66f73ec5722850ee7ddef99da75fdf3a3f56d912c4b1ca96208e55b60431d1d80ac4b1c6962022c15bc651b28cb702643c4d2ce36859c661bbbc3f6cffcac9fb4f05e48916172024923b641cbf4b3ae16e5e782ae058cd4b1021ede5b15ef924bce685a70222558f643de9fcfe5bae3251ef0ac444bd2b1013f5ae408432641eb1fc5141fbb7303c5e4f282a0bfc9a64ce1588895a17207492395720265a5b8138d6da1244482932e42a23bcca08af32c2ab8cf02a27e155ae63e38f7ffef810c367202255a7c8e0ae9c7057af27fbe9c444932b10214dea582f3d09af7a1d5e9f4e4c34b80211d95fc9787f40debf3fb0b64b8d64598bd4b816c9831651a385b6eb113d5864c36e11c65aa4eab308a74a841125c2883289d676ff8da032d95bac4044d8c2af0272e195340f20e5febb8425148d8b9c747ee351e4b7ce2751780562b2af598198c4d01588500c2d23379751a79551a7957632bbf7f95543fb98ba4f3bbf77f41af87cd2924d0ed848c046033616b029019b1ab069019b1e59d31011224c48112aa4081752840c29c28614a1438af021450891228cc81146e4506c883022471891238cc81146e46346e8f3807df208653e26c53bbbd92394f99819d2cf9f40d5c789bc7f3bdeaf29e4b5f78ba77df331c1ded9cdbc9663965d7b6dc3eb72e2f5c5d3be724cd6777653af8f197bed751b5ef7a9d71f1e57e59729f27f87586960e978add798935d7ac4e858497af55cb81c8b49af9f0b9789a2523e9ff37154ade9842957cf85cb4495d7cf85cbb12aafbd1e4c497799f238a13fc61a0c495186bc69d40245e28a4d0ed848c046033616b029019b1ab069019b1e59d31011224c48112aa4081752840c29c28614a1433ae683caf58ef2e7bfbdbc57fe0988085b743ca0adef1fd07e75e2c6a3d16f4ee463f62d4144b8a8e3e96a553d19c7f5db424f278eb9bd0471ccf4258863de2f411cab600922a2097d3c7fee5f11fc781dc9f2f148b87f39f074a12cdd776ea2bd15884868e617193fc62127e3b83ee77a3a71acde150899686f05e2587b4b1091acc02f7e7ecce6608d0dd6583b99ddfbb151265a5c819868710562a2c515889016c7c9b696b11d2983bbe584bb37ce689f4e4d34b80231c97f2b10a1fc374e8a759c146ba9275372fd74d69b333ad1e20a44280f96115eeb3cbcdefb3cc89a51a8c28f54751aa9ea34a49a4895afa15c1261ae45ea7c8b70ca228cb008232cb4e98b30e26df202dfa8b06493033612b0d1808d056c4ac0a6066c5ac0a61fdae8f3b1ed8b6f4198db5d7d0bc257966f1f91999c1b8de7bcf997147e8dd11f31ecea0c3a1d33cbaecfa0d331bfaebcb671066d1fcea05f7bbffac689639edaf519743a66ebb5d736bc2e53af3f9ed13dbe0ee678dddac04ae355af31cf4f1922df60b0661411523a56d2cdb7a222df60b06634a17ebaf154c1ebf3eb9f800885dc71d06de9061dcfdfe85a328af02d47f896237c7b634e0f24e3159b1cb091808d066c2c605302363560d302363db2a621224498908ea96037be22e4a71f5e3e25f60988c8a2f34f218d2f1ab187ca7e4d27afae5c6f369fae4478611f1e197ee9fcc6f3becfce8f09b60411e19b8d47864dc797691df3cf6e3cf2fbe6478eb0d13e1c5abf767e9f4f79c2ea158848bcb371d66b5a4fc6719f8c7922ad158863692d414c54b5021152d53821b7c709b9ffc9adc76b9ecfaedda0e82f2fc7dd9f8008a9ed7188ec7f1a6c3e8eeb6f17787342266a5d8108a9759c4ddb87b3e95727ae8f749f4e4c54bb0271acda258889e6562022e9ccc6d9b48db3691b67d3f6e16cfac5a91ba7c2fffdcbcb81f92720422a1e07cb56cac938ae3fdbf37462a2da1588906acbd8f496935c5faf13f59b133a51ed0a4448b575f0ab9e44d11b5fb0f27462a2da158850ae1ddfd162f5248adef88e96a71313ddaf4084745f4714ad2751b45e079fa713139daf4084743ebe60c55a9a8fa35d3ffdf07462a2f3158890ce1fdf47ee7f96723e8eeb42f2cd099be87c0522a4f3366ad176528bb6eb12eee9c444e72b10219db75105f67d3e8e7efd90c3d389d0a1449f07cb9b6fcaace59a50207935fa7f53504a550d0a656e6473747265616d0d0a656e646f626a0d0a3231302030206f626a0d0a3c3c2f4f2f4c6973742f4c6973744e756d626572696e672f4e6f6e653e3e0d0a656e646f626a0d0a3232322030206f626a0d0a3c3c2f4f2f4c6973742f4c6973744e756d626572696e672f4e6f6e653e3e0d0a656e646f626a0d0a3430302030206f626a0d0a3c3c2f4f2f4c6973742f4c6973744e756d626572696e672f4e6f6e653e3e0d0a656e646f626a0d0a3431332030206f626a0d0a3c3c2f4f2f4c6973742f4c6973744e756d626572696e672f4e6f6e653e3e0d0a656e646f626a0d0a3439372030206f626a0d0a3c3c2f4f2f4c6973742f4c6973744e756d626572696e672f4e6f6e653e3e0d0a656e646f626a0d0a3539372030206f626a0d0a3c3c2f547970652f4f626a53746d2f4e203530302f466972737420343932362f46696c7465722f466c6174654465636f64652f4c656e67746820353235383e3e0d0a73747265616d0d0a789ca55d4dafe4b611bc07c87fd03139adf8dd0d18bee5941c8c38b7200723308200cec2883701f2ef53d5433defbe1535ea1e03c6f43e8ac52659d56c8a9a51d3beed5b53d95ac1876e69ef5bdff72d35c567da72caf8cc5bee0d9f652b49f059b732123edb5673c567dfea18f81c80d9f1093829f80446015ec2df04764adba8c003e650e0a5ba49055eea9bc2eea96c2ab8166da4dd0ac696124b323c4a035573da522e2c82af6567518131500b9ea4cae67283fb3b2fee303a2ece794bbdf062208fc46b507dd0c78c26a4a17a01b2b2a8e0626511ba92772baa18072b6a30aca86c395bd1d872b122816145bae5caa28aea0d3de010e42668bd623c7bc7c518843cd0835e8133d8af8a26048ef78a2664c0e78a5a0aa77a45136ad5652b3b1aec5561289a4033057d869160602e7bcb5bc928ef98cf5238080d93551a90f17fa9989ade3a8c0ee436b6d238bc0dc8ad0319b35e38d81dc5a50f2077008ecabf005030c3bd0350066a811245d12776a9ee440644dd07daeafb5613a71aa30f8ab048b75a40a88ea9aa054e7530a85602a2ffb5a206dbab0d24e840af8d0305accaa9ee034df0c28ea1a98303350038947f41a342ba0a00954502406511e6a3ed5654b79640872e0d86a209e95bcb6c54485ab0a00b45a0d5a8da6c7c30c4ad81325d6890b1006dd63a209ab58e0acd5a4771533681698092d08452126c42c95736a114016a8c9d7c4513832352d0c4e054156b82538e511f2437a538760e288676509ba3b03adddd59dd7ac2eae6012e4eac907831ff8a7e0faa2d5951d94666117598ada86da358518732ad08ff572b42f5065a0df063509103b418741c1830e80f26061a42393438d48af00f65111427bb15f54d92150d1856d436c956a49b14164168525804ba4b6511340851a21d084d2861765ba82438be09c766e01f2218b6014908fe0403455a78b16e70a7b37330c026740e21a6758b3f9ae92638ad193338203d2d50c080f4b4665e837854394d909e36ce0518ac8c0703d252cee780ea7480a20363a4024d0c480fd38e8b213df4981d03cd61d17d0c72da13fd871369cf36bc8396f06f88583b45311a4370e550f7dd8220af63386c741eae2040636c3123b494d7b1353a383a5184ed76b6218dd7b10de57075a2a8a1a08d44bd623a69754e6c62a42555203218ec10e488bf901a184158ec077498523106303617fa07492248a30f6310b9d13f2172131284c88c3943b205f142d2d0a2f7107842fcc5dc0b2d851f032392f2ce790411e100f83fd00e2c2b451b395be9e05ac052b55581a598d0942b4ba1c08410cd52a240b6b6e8a01b6007480a8b821a4a14f67528db10f0829ea50ce26c1c4d2c33e82fe5068bfde5325912fa0b86c3ca565a69a1948c4c167005e8a9542b1db4ac141ea090a544e17a0679d0b252e15ac6d24414b152b62b2c4d6c4d2b05c5d6147e08149cea8e9986b66071ac84ab66c5e0c3021e1c208ad2c2ac0a97d25a700dd1618103c2f5b156cc8c7035ad15b3ccc508934ab57119ad4d781d91b9400ad7cfcab00a05c322bf858b6ba51fc22514dd6529db6060629c4014420fa5d8fa3c58ca051afec30272cb1c71cc1d2c2b451bad54c6042624d5ea165a608d40c89803b188c1651e0a90ca3618d5a4b20d324e2adb10e8568084b486fee1dad41920f877588351066d74f3058a4edd7c69cc1bcc176aba3f7c81a7dd7ca16ab10403853ac76a4a1496329710aab63354707540e0833a859aee1c1da17eb1d0c02b6a1a6b466778434eb23f221ed314704fa869445e96f26f996d50d388872c653ac335940108163da5ba07a30543621a4cc284ea1e5cca85ea1e364254f76054e05a8e5c885ca31a07ff2dd439c40464ea7c302d635692c4fca3ce41560bc0b0c045588916f427d4b92007825568710ca8644c3cdaa0ce31a168833ac74459f46612061d90e7b03012429d0b5343a11a85098450e7626b0b752e8c1e42750b992954b7d037a1ba85c99350ddc26c4ea86e4590dd38eab0d026972ce47cb65a58f6077ca57e3533bc53dd5822b884a00d2d5c04a85fad3bafebb430f38c130914271edb689865a5bad5125aaa5b99222995ac5c3495ea56465aa5a6955a63020c0b63acd4b4d27b721516c64ea1d7bc33f953681a16c604eec262faa799992af33fc52ce69d0920163958cc00159a8605b6a25bb0c85da649b0c042a62cc872d13a671b16d8a5996d300f44f769812b6ad93097737a060be3ccd52eefe4b33221de39b7ca6479e72aaccc9677e5983203c662c68576d0c2acf00a4426a84e993133e063d1dd69352ebfdc7a20c9e58a4c0bdc55e6c8086c40616e8cf0c3eb88d7e841251e773258ba61314d65dcc1a201cfb5118f515fabe5f0c483a633068d16dac0b0a12e46091698c99532131a16dac57f44115a60a682b55884e829661bf904bdc268c2820e8889edc1236980d531a3da89c2d4543bdbb04c02910170dcfe74e2a9a1b00d35149496dd503a771944819261d103b027171b2be83c97929990145ad08642c3c8b198d14023b0382e8328cce9403d58dcc6e9e0b6851b011d6c8de923b50eab7333c6d6cc3f616b8c2dd4522e641779090bf88a79cfd5c60f23078bde435f1816b041a16958d41b589bb11d401b60053446cd08f74bd86230798255ad34db1e8a3588dc3062aa44e6daa3503c2ca818d28035ac9428b6ee30f18269c574412d19e216b6ed5c01a022eecb28d01d23c02d1a7324ee751b8316133698251bd6a0c900c4950b536ab9188240c6c680b8899b3c6e8c611281bb1a5c006f1ab350e67cdcfc314440aa341963f74477b45a35b4d65939316d8739ac1a5ac36a64d5d01af20456a3ce3b93566690308b2589543ab694f48c2101db434b312b37ed8cf23bc5debb759e6aefc33acfb0d02d8de3cc819a96ad52f05dadf38c075dadf3943cf6216ca2d8ded53acf9030b89f494cf5338243b63c16662956add354abc69d6eb5b9a0f2911ad3334a7f74eb3cb53fba759e41620cebbced94855bfbddf6ca16f81949f2d047860ccf64b7ce332a0833209883a675de36d4d93acfc020c53acfc880a4633c6e3420ebb399671c10ee40611297e9054c342cddfc6528906ee3db6ca35e0d8c0d5be2c72182692349718b2d13ccb061daf03134286903b3d0341f181ca07e566374d06c43c28082a86cd57813a074bb004d803a7601ef11541b5f06016d36be8c11ca9b16dc21c01ce61963835ac6cfd40b11a65835baf37092e1411938127dc2c6ac5a356cf2c14eabc6db0ec9dc19bc1591ab6d3312ef4ad8a82348f00645b16d08cc6aa38e3081621b752158b31e238c94bddba80b5b1b36ea425cdb32300623ddb6f155827109c45fedd60773881d4c28460598bc31c5dd0b4cde09494c4bb0d981c99b0f300196789f0666a529564d78fba45935e03201dd6c7182c944047a82c9bd0bf74b30b9bf85c986b987f9e69b0fdf21b5def6edcf1fbefff0dd87bffcefe71f3f7cffe9dffff9fba73ffcf4e3bf3efcf1af5b93bf6d1fbefbc706a2e3aa6fbffded6fee54d240a5be472aa548a51ca95422956aa4528b54ea914a235229c2881e61c4883062441831228c18e78c60d2fca8f5fdcf3f7cfcaae29f7ef8f88fdffdf2dfdf6f84981dac298c904e119e89a6b2d8ee5bf3332fbc18b7bd28212f84c58bb6f576dbf5658416f11ea1d6c630a7752f9085dcf5a1bf8c305e46909711343492658ee46425b2bdc767bf18d9fbdc4c0b917920422acb32fba1eb7e94fdbe130b997a20423a2de9d18f922ffae188580bc17a20428a2d935fa55df4a3df776221590fc442b31e8885683d1021d596314773b2fcb10adaa9e16a74af11f3b94e9f548a28339f2be949a58876f239d79f548ab03b9fb3f149a573fe3da974ceb82795221c2b11469408234a841125c2881261448930a2441851228c288b18d49faf4cfffc3413c8737e7820ea629df7409c73c705b158a53d10e7bc72412cd6580f44688ded3357e8797ecedcaecfb5b7cfdcaef7f93982ab458db0bb46d85d23f1ae46e25d8bc4bb1689772d12ef5a24deb50513c7f3ecfbe7c9c476ce441744842d7c54c7483a2e127879aea8372716d99e076211693d108b48eb80e88b48eb8158445a0fc422d27a201691d603b1e0b70762c16f0f4488df3283b5cc602d3358cb0cd63283b5cc602d33e597a90b9929bfae537e3e0d76bb130b7d782016faf0402cf4e180180b7d782016faf0402cf4e18158e8c303b1d0870762a18f3b103f4d88c55edd0311c91df8bce54322535a3aa5a5535a3aa5a5535a3aa5a50f69f171c5c7679a9feb7b307c96f27667ce75e28238d7890742ce75e28288643f7cfaf2319a6d7ef6f9b9ce46f938ea6da7ce95e78288e45a3c16b77ea47540e6b3b3b79d38d7ae0b22b28be013bf8f7e948b7ed4fb4e9cabdf0571ae7e17c442731e88c8ae820fcb3d4673b2fc71ae634f48af47f7f9e9c98fbfcc7bfe0b157b20422a9e2730e3e20466dc38bb38065717aaf54084543bcf3fc6e3fc63e144bbefc442b51e88906af3e457be88a2f97e08d4856a3d100bd57a2016aaf5402c564a0744da17227361c45436d79432d5364f83469931ba4cf6960bf696fbd44bfb42862e8c731dfa3016327261847454a68ee609cb98272ca3ac6f438c7a63aff8e6d542582e8c48363ceae44ebdc862ebfde42fed0b71ba3016eaf4602c8e987d18e7eaf4612cb4e3c208ad617566d475e61a7572b84e0ed7c9e17ac1e1f69c7f47c2901687c83e8c7375fa30165a726184b4d4a696da8cc36dc6e1761187dbf3d8f5ab570b6db93042f96a9bdc691779447bbeeebd79b13858f66184d6ce36d7ce7eb11febcf3753bf7a11b96d3ffa3ada5ed73cc6ad38eaa4409d1ca85302756aa04e0bd4e9813a23504702753432a7e744e0b7979e2e2b9fde3d41f502c4394d5c10e7ac71419c93c80571ce2917c439c55c10e78c73414408c86fe05a501c333598a76c63cc602973a3314f27c63c9d18f2f9cda0774ecb8d7b2887d3e70af040e448601cf3346548bfe8c7fd23cdbc509407221278c73cfd19a2eb7ee8fda3abbcd0a40762a1490fc442931e8885263d100b4d7a20ce35e9825828c40151420ad1a9f8796832e6a1c9988726631e9a8c796832e6a1c950b960e2fdbb9065a1280f444451fc8e3efb217b5af643f6e77721df9c58e4461e8848aa248f731bfb2d81753fee6f1fca22f7f24044523199c741f2c571d07b27ee6f1eca22b7f34044565a99c741f2c571d07b84fbdb8f12c91d25e58bc62fb3f5480ca991fd478da8b6867620115dd5c81ea446985f23bb901ae1668d70e9204473d449813a3950a79cd7b9717ffec78f5f7e8f298ed0027ecbbcbf2ff3fe7e3fc72837c2c4c72fbf87e4f2e28bef96bc6ffbf9ddcba36d7919415f46480b9a7a2016acf5402c48ec815870da03b120f51332d449c9363fe77a3c0f44641e88c8fcca897cf19593772dd5fbc44d0bfd782016f2f1402cf4e38158c8c003b1d0c1f5c43dce75ec078d1e9f7322e7a980d47e3151cff7ad877379a1300fc442611e8885c23c100b857920160af34084d68d79a223758ab0cd4dcc3c9790792e21adace7bc3dbfe7f2e6e44259d74eb676d1f8f36fc8bd35bed0a40762a1490fc442930e88b2508e0762a11c0fc442391e8885729ed0612e206d72779ecf489fdc9ddf5e91f9ed15e917dcedf7b95b161af5402c34ea815828c80311caede6777e647ee747fa9c852eebd1bdceb5175abaae1459d16a64cb51237b8e1ad974d4880a6a2427ab9135a24662768d70ac461851238c681146b408235a84112dc2881661448b30a24518d1228c681146b408237a8411479de1a893027572a04e09d4a9813a2d50a707ea8c401d09d4d1c89c86881061428a502145b8902264481136a4081d52840f2942881461448e3022876243841139c2881c61448e3022471891238cc81146e408234a841125c288125a2e228c2811469408234a841125c2881261448930a2461851238ca81146d450061161448d30a2461851238ca811461c73ebf929c2745a47eb8d93f2e3e6d2cb08e56584fa32427b19a1bf8c3002f3a7f379799dcfcbebbcbbaaf3eeaacebbab7adc5d3df7b2dd78c2e3dd3997cbcb2feee5be6ffbfe6da4744e7117c439e39ff9dfe6283e463b2d48dfeedf3b4fe7ac7fe6875c8ce38da78dde9faebd00b1508c076221190fc4b9665c102b493820429a98f78e75de3bd679ef58e72f1fe9fce523ed6d3de7dd7108b0d08e0762b15a7820ce95f36ca86670eb33b8755d0fc9b8f1059af7a7682f409c2be9497fc69cf2f198f27caea59b1b1657a5c81a93cf157273c3e2a95422294c8944f412e16189c4ec1261488930a2441851228c2811469408236a84117511a7e47e48af8b15de03115ae175ae0a8f479acf9dd0fbd95a0dc527bd48d7f47eae551739820722c2699dcf7babf68b7edccfd5ea22cbb801713cd75e17598607229465ccdf05d2f9bb40f69298d598d8bb60eebad3ce95e9c33817aa0f2312c9edb538733cca61d4ab81b9ffe5a676ae7b1fc6b96c7d189135c4de0134c7631cc67ad3612ffcb9edd0b9967d1891e5ca5e56f4e84b5a87557b37d16d3fcef5ecc38808dadeab34fb7245d8749f287da5640fc64ac91e8c9892d341d87410365d11f6c6af0b7df52b8faf60ac94ecc18829391fa47ffcced1e37d59eb81c9377eebe1fdaf460630deee979d2bd98711c943ed0561733cda61ac13057b1bd86d87ce25edc218a1fbb8fb7c6984bdc76cdd971bef7c78f36325690f464cd2e5206cb922ace371f2b152b20763a5640f464cc9e5206c39085bae085b1c645b29d983b152b20723a6e47290be1ce96dbd4a6f1dcfb18f95921d18b25a583d1891bb1bf6f6c0391e47b650afb205c729859c4bda8711d91adb6b0e675fc6555fee7fef495692f660c4245d0fc2b62bc2360751223b657bf123fd90485e2d11d14a681b1b5913679dc718face435d7572a04e39ad632fbebc3be1f57588f63a447f1d6244e669ef4784eb4784ebc72af9f989c9d78edd3fac90d72134d6b76327f3f993ee5fbbe138a13ad7820f23a20d7b3deba32f235df465dcbfa599cef5e6c338d7dfd3be1c541bf5aa2ff717c2b412b107e35cc54ffb722ca6635cf5e5fe4298ce43c1533ff4a2f91b6f32787f14fc12c6b9e29f75418eed8ae4abbe38befd7a1e365c1839b4fced720451b90aa2e23f347e0923b2c4daeb95675faec2a8e34827c7c2c6e7afb9f8aaf91b6f12787fd8fc12462c5ae8b1da7e7e34f4b51ffeaf65be8411cb1cf4d8447f7e3cf4b51f8eefc1ae12050f462c53d06303ac176194aff0beeb4709858df4f92f10f912e1afc2c3ff01848b7d7f0d0a656e6473747265616d0d0a656e646f626a0d0a313130342030206f626a0d0a3c3c2f547970652f4f626a53746d2f4e203530302f466972737420353331362f46696c7465722f466c6174654465636f64652f4c656e67746820353231383e3e0d0a73747265616d0d0a789cad5d4d8f2d376edd07c87fa8e564f52451d407301860026411c40b23ce2ec8c293316633718cd80930ff3e3c47573dfddca5aa127b166ef37517298a3c3ca2aa74ebc618e408478c410f15fcbf1cfc2f867a44ed10da916282d08f54d484180e890d423aa4423bca9113ae89f9c83543307b09766239b4f2e27a14e1c5fd280d17a770d48c21cc588bb8d86cb446418eaeb093ec47a0e96443870e03b4abb099ccc9c47fa66852a78659948ebf62b45cf057b1bfaaf0aff68712604f6cbaa56278b17fd65c21d9188dd317fbd13813b13ff44c0d8b4488f0402c1481b332a3c9063129c723a50c8d1c8e240c99a925a911921c2927fed53472c568598fa40c891948da107f732315a13d1bad34f8a766afd203b5311a3db0b8a5460f2c6d36715e970f091196554d6ac8955a8a2233abf590c4d12c749218212d870823542ca759a8db0fd100dd62ba5ae07391430ac2144b44ca61c5fe20b5c08a81421a1210cd948ca8151bad233dd12eb17450a31f3920ecd1409303136dc1c908a749c9a48e312ad094e18199cac3d35a8e6c6e41aa47cecca04d3f67a2c4d29895796b664f890d83582e008d65d4245a6e8067a1a4476e804a343772ebd4b5713be7dbdaa1216346960005f20db5c124e6ad55c336fd33a32a44678f26119d0642cdcc47b71a50e6a38b49cc4737dda218ada33088089ba09508e2d26db486ec270bb13664df107728f1976cd2dacda8497294600031291f250680dfa65f000193acd252a2869a04af924dc16085eb0c3e2563e62946933a4ac86adc9c8265abe452389a01b854602d592d975aa8616334a0c4307f941ea861babdc2679b6a0da88084ca06b398144daa1cb71f3521d370ad4a60e98a4905635820aa0101929a044ca2b0ab466a98650b16a476546635d9146a410500d4b5a2c4adea4c6af0c060564724ad426b6bbcce2cf78cd1ec0fb50311569d471b3e5b75b7d0a9d18d8e185dbbb82115264593141a169c26011a56d34d14f330032d3356068b960be66135dd14ac66d56e12e367465b61660c20ad54ccc340dd2a682959755b49631e0a1e045f193f98d43086a5b60defadba5bef18c380d403d8c7d8c3a48e31ac7e3bcacf68321c1d9336291e5d980f037f272319cb1c3d331f3685aecc8741a09788712d019d2c9dcc54afa83c63a3a337107fb222e924ea6495dc3b3303a321d041cc3560e1b0df2688a0d964656d542ebc96ac8e824888819102afc5da231dcea1ce2c2df004290e03a6301394be805042e19410b1c09a4a703854946b423d05d67a0220428b180d431af16034b81f3ad70dc4377438950014730da3b5b1fa61b43e16398c06f7481a2672596208918df18bb10809e821a156c75a94fa207c1a23f3065e4bda46d1cae0547098045229484c06cf01594c5fe484883e633aaa91e00ad5c82a916a241d6444988590782de904a19551d7580d24b238112eae5909c561224b112110e241c009c2180aa62503d9a812898427bc665b90c68458b8059e48222850e7c2785758276f5ace315a1a79c4688959006c248d20633426849817fe3b80ca844b3d976fe15458aa22fc13722c282b114e08c913328ca0b024033682ea10055b0bcd14cc45c070529048025346d49168691c88161b12295825a403c50c510e9903d98f1c115a4145645600419151b426da8fccc90a3a0f2b440c01c0e7cc40c1a7acf444d9c704ba1a21560e61a35baf8521b0be6756a620f499a52960abcc2e4a30a4b28d12230f13016801c23472f2e8f43471f2203465a170bd505a17444033b247bed64c6860b1545586cbae5232331b0a2da83a010f69558616a3354041c00f4a4e162c3ada1912c0d556355c8bf49748d863ae054b7d64ab59c0ab269a5a216c04ac51c81a0268978cb908148a023682d017256851e2a5c05541fa8d806117ac615cc79c62b4c6cca3f04b67e6118c1a46feedaacae658c01ab6b6c12ea65213338fb8541695200295c3d3bdcace9889aeca6902cfb5709a48c858ce585eb5224f82e5a8364e1304521ba709f76ae73441202d008e19d8b7de10f94729b6c81a02465b220641208dc5caf6a9715a190a2d13834058d3c06bd1fe2a7185b93612530697b4828133b8a4551046c65c5b051432feddd8cab3d21a993663c8d613eb0016d82d645cd58350cd7e746c414cec102b0bc5143a96fe48dc75d23fb7199d359e1197ce94b1b3b6d50c7691c74e7866e876c23303989df064efd34b67016288e13aa8a2379040c68fde11ae0cd6e824d26c431abf0004d688622380bc61481391b78cad4048a3b0b15318a1e6566184da8ad9fa3506159b85a089e59e200215191b87409ec4d26754cd69629b102a329db18bb0e50b76b151081df40412b6ae8e19c246c2d009bbd835708f61ff456ce12207ee10017e38925e2c613fd208b835cf101b7f0b635c6ed1655bf387ec65c568dc98648bac7106e3abb03b325f3070438de702b58e94e502bb9d29b4fa4b8809446c9ad85fa3e533715c6076133b856c003291e1338bf64baa1913988862c8756cbb306303bc8928945c31c470dd82619d24b369b032116463bb0013d929602f66220a3d578cc64e21578c36f0db301a3b052c1a2632be0d7b3b760ad920682208235bcd5b172a24648508c2c8f6c3a643ec186b98c8741b6bd87c98210ba78928d6dcb17bcc24fa8e2194ae770ca12085dc310417566377882cc85eb9d5a41aec5662b263e096c9f9b0db39b78ed13a728c36c4d801ab08c6b13617358eb5dcc4ca5543b97105d11bc28ce322d5b0892545a27144fca966036736028a9b05998d806d9f4ca4bf1a619700d78881d90868c4c06c046c3532918d005a6713517ad843595e13afc5105c6eb133b0ae2371b90a10eb58c44c1c1b7ec39d89e007355d6baab1daa3e84c6c54e3065ca8861d38b9198b8635db8c99918289488b268ca6ca1511a31510a782146ce3046382d1d8aa9949885c11410acaba509082b22e14a46025cfdf62b40e802b48c196f9c295d6c4c8e880140ac95c410a85cb8c82140a9b46052994b18283980a594dc10405e13211f7149491e44d8592b86cc36ec1928959599bcf19831f4ae3c0e087d21aaf853b1d5401085add00670a7ea823ea60828a9b17119b6febfa8133a4df442600fc50c7c25fc6ed0c1843f9d7cc6c5afdd95e002cace0075b99310408c402091f4020b5306fe0875ab1a829f8a1368216fc501b410b7eb0ad1ed5ccc916085af0836df1702df8a145420efcd01287003f34f6dc0a7e68ec381038db4208d56cb486f49a683ed8b2082741156da01a54d106aa41156da01a54d106aac10f6da01afcd006aac10f6da01afcd007aac10f7dc417a4d007aa8df54ce42cc01a3d8d160a7781d8ce6229b14d0867017ee8996d1c98a003c5266208fc3411439461c13ceb9577c540159dfe62822622eab86b662d3828086c6ad84bbc16379d42e7101df79f946ac5446c59230adff62e48375a5813d1ea94806bb19644f43fb68d413114cba389e86f0aee2dda5ac84610a355a0da4a0262a71a06c6cee7b7bffdf2ad6dd88f70fceb97efbe7cfbe5dffef2d30f5fbefbe57ffef73f7ff9a73ffff05f5ffee5df0f49ff717cf9f64f87f2aadffdeeefffee89927894b247493d4ac5a3541d4ae1a5231b3ad1a1931c3ae2d0c90e1d75e894531ddeee1e5adffdf4fd8f1f14bff9fec73ffde6a75ffee18089f67913dde1791db7e9ed8a719bde848523293e76249ee368cfc639aef66c9ce36ccfc639eef66c9ce370cf8607977ccef2caad4c214f41a750a650aff2ff1c8871550f3b36eadfc0c67951ddc66cd6838429c48bc0487aee90a744793bf262f8fc78f8b4aacb1d1babbadcb1b1aacb1d1babbadcb1e1591ff8ecf0058b593852a7d0a6303094ceab964f0e1f7b795e4d775ee635666f16e7f3cabb51f2945af29483789a14f17429e26a5356b8ccfd36e33ffc38322e4bd46cd8f0a0860fce75b29e5eb19edeb3de9b2b2b2adfb1b1ea8f766cf8d857e7caa973e554bd0a4c79ec505ef1f18e0d0fb27946e03597c1587945c9fa1c72d9d3a2f340c23a9ae5be437a1b7ed565edd8f0755965765965bd52dfec543ce59a3d4c9d3d4c9d3da5a31ea6560f9ed5c3d4ea81abbab6941e54cde0e90e121d3ac9a1230e9d7caac3333b4f3ba1f27913d5e1b98ed346a3c25b7a57e11f1c91c78eb4cf9be89f37115d28c3e9aa5734662bdcca5558ea7387ce21bc67e31cd27b363c10e771b2573ce61eb2878bc074c73d843d87fa155cfb0650f46f60e3bc7e6fa730c1d65f603baf619eb37becca79f9ddba5297d1bc513dafd51b66f6146772ad019e4520794a2479609c16e0c3a9c7a79d5d5aa066cb8607353cdb145e770a706273598f389cf9d89505f9efd890737cedd9f0c08d8754473c629842bc084cdcd8e479a0cc231317c3dfdf527a1bfebc28f66cb8a81e0f625fa11c609355d5c4fb65f0c35d844d57da5534376e62ac8a76c7868bea539ac04c6b60de34c91ececf1ececf9e22cc9e42c9aecedf83e77c8ede87bbe82d25cf9e60a6a9ee80caa1931c3ae2d0c90e1d75e814874e75e834874ef7e4d405040f12a2070ad18385e80143f4a0217ae0103d78881e40440f22920711c9c50d1e44240f22d23922f88192c71deb79aef76c9ca77ecfc63912f66c9c0363cb869ce364cf860b363a3e4534da1b9d9d78990d4f8953485378df1cffdaddb2d1d89e0376cfc6397ef76cace0bc63c3c57738c2f78ae9dc11963a85761565c793bfcfd870712c3e2336e6520786c4c3bae261ddec61ddec299fec61ddeceac93ceb70f6e0327bd6e1ecc148f620227b10a11e44a80711ea41847a10a1ae36dd8308f520423d88500f22d48388e24144f120620ed477d8d3a1931c3ae2d0c90e1d75e814874e75e834874ef7e4d405040f12a2070ad18385e80143f4a0217ae0103d78881e40440f22920711c9c50d1e44240f22920711c98388e44144f220229d23821f4abf6ba2e7434639cff59e0d57eafbf84c3d7b71f9ea54f707579e9fa6967340edd938c7d79e0d1701c93cd52df354b77c75aafbd70e6d9cea967328efd93847f69e0d17f589c88c479e825e05e6f953765915d1031b1f0e6d7ec246762dc3324f75cb3cd52de354f7c2a10747ba3f1cdafc8c8d5539eed8703500925f7788f01e8c97205781797e57259fd7f69e8d5539eed870b51ef884f72b1e937cf315f9e6e7cfd9f3796defd95895e38e0d571b2c7992ef3c5c2e7a45be1b87ba75b5c8eed87075dc320f86cb3818bef2e3f9f912f535f15aae867f7e3759578bf38e0ddfe23c6f478b5e316c79ce6cba22811d1b3e1298f7cfa5a4abb9dc9f9b7bf3c3b7ae972b54960d54ae6863c7c66a15dfb0515695be63c357e9f366bdcc9bf5522660cb1560eb73b095d572be636355c03b367c055c27e8eb6c09ea554b509f2fc56555c93b3656ddf58e8dd50abc6363554a3b367c2b709dad499d58ae13cb7562b95e61f9c121fbe9625d55ea8e8d558bbc63c3b79eceb3fed22696db1596dbf3dcd55581eed858b5c83b365635b5636355533b367c2bdbfcd481b489e536b13c0fe04bbbc272dfc0d0aa641fd8f8f9ff5e3656abdf868de6dbc3f689e53eb1dcafb0dcef73f7e6d0aa40776cac16bd1d1bbe3decfc3081f489a17eb555ebf75ba437875605ba636355a03b367ced6b7f6dd5f09ac19770b155c3db871e3be4aaf61cc636ab79eed137cf62d93da5d63d9d65f72c50dd03f8d794c6de64ef89e4964e72e8c8a90edf1b39b4bef9c39f2f9e4a5ee8fde37ffff12f17cf263f6a4edaf9e69fcfb1185feb4c7e7fc27d35d96fbefc1e578eddc9b9b9726fe5ea41e9964e75e834874ef740cd85cf7380f215a04f97f7780ed83d1be700bee3b5f98026a709aa952b0f6ecffdfcf5c7f43e65c3032ebe6c75cc623e5f39c71b5faffad89573fcedd970e1314b9ad319cb4f3a47285f06fbd495b402ec8e0d0fc3f245b6afe90cd4a515e9cafdbdbe3f7efff5eb733e65e31cb0b7d369733a0375e91cb37cd1ee63575680ddb1e1214cbe24784ce7f540259d6396af057eea8aac00bb63c3d302f095c6afe90cd4c98a64f38367783f7ffde4f85336ce017b3b9dc9cfe339c9dbf3de8fae3c38603b5d590276c3866745e7eba2c774c62398b7a7b41f5c79f20465bae223d9d71394bc82aa3ee7c5bce2d61d1b3e6ed5c9ade341ccdb53d58fae3c788e325df141551fb4a597c786f79456207e7bb8b1eadc5754fb57c555eb9e57687d7bcbcfaa772f93958ade0769f4eee309cec29c7843eda915f534c8eaa16ff514817a5a60f5605c3d40554f4bab1e7a554f03a01e44140f228a0711c58388e24144f120a27810513c88281e44140f228a0711d58388ea4144f520627ad7765634874e72e88843279feaf09b18ee56f97947543f6fa278a29afb6c69c7fde4b77b431f1cb9ef46dfeeee7a1cc17755fc7515fdd5e81aee77f973f4fe7913d105500daf1b051ae46a2acf1f68c473d0efd9f01401bf02e43597b29ccbb38f146ce2d1e5ad47c9552ee7d5f1ec23057b4ae7307ec4abe3e0c51eaf6ee924878e3874b243471d3ac5a1531d3acda1d33d397501c18384e88142f460217ac0103d68881e38440f1ea20710f11c11fc56a170b5d54ee7a878afb8da6aa7736cf0cb87c2d5565be7ed597d7f60fe8399b7fbaa2bd7cf61f65e71e9fa39d81eb83e6fc56a4e57aedfdce048e7b87dafb874fd1cbd4f5ccfd3755dbafef50d0e7d7d88e23c89759a0b53907bbb979fdbda53f214573a2f2e7eddd55df3f4ebb77b7cc686b8c858e7bd599df7665725b8f3da73175babae93cdeffb7a3cfcaa14776cacca69c7c6aaae766cb816099d3788f5758398dfa2f612da32ca379d95a73ac4b3f488a719c91efc674f33923df0ce2b50968d4f95ad40b9636305ca1d1be7a0dcb3e16a64741e87d7791c5ecbeb1480d6b00436bf68efb1672b42dfb1b122f40d1bbaeaa3766cacd87cc7868fcde7b17cad3285d92dcc93e15acb55caf63f47b4eba2970ad5b563f46c12d4c3ff133879271a0e9de4d011874e76e8e8a90ebfd7f229aacae74d544f26b4cf9eec7596ba2d1ce9cf5bb2ee73e47d47f661f4e75d4c3c47e49e8d7384eed93847ec9e0d0f82f975a9af9cce8e6cde11d7deaea2fc1c6cf1bc4ef66cacea66c7c6aa70766c9c57ce9e8df3bab9bb2b135ed557429c429a824c21af535636deef1ecfeb72cb4672d17d992f882fef5f10ffd18fe7a738d3a240b76c7896147ee3ef984b0c1773890f7a9ee9c77991efd9f02c5bfc72e2d75cd6e47bb32c7fa8e1ff0770b2a7af0d0a656e6473747265616d0d0a656e646f626a0d0a313431352030206f626a0d0a3c3c2f4f2f4c6973742f4c6973744e756d626572696e672f446973633e3e0d0a656e646f626a0d0a313436322030206f626a0d0a3c3c2f4f2f4c6973742f4c6973744e756d626572696e672f446973633e3e0d0a656e646f626a0d0a313533362030206f626a0d0a3c3c2f4f2f4c6973742f4c6973744e756d626572696e672f4e6f6e653e3e0d0a656e646f626a0d0a313631362030206f626a0d0a3c3c2f547970652f4f626a53746d2f4e2038332f4669727374203831322f46696c7465722f466c6174654465636f64652f4c656e67746820353132393e3e0d0a73747265616d0d0a789ced9cdd8f1d4711c5df91f81fe6119eb6abbf5b4248880f8180288a23f110e561712e8e85bd1b6d3612fcf7f4ccfc4edd4dbcb6d7e34d70020fdee9eb3b5dd3d3e774f5d4a99a6bd5ca1216abd69692d6635f2cd4b531162bf35f8d618916d7862db196b59196b49e57635e525f4f8e71c925af8dba94b89d5396325683b12fb56cddc7d2e27aa9d896d6d7eec9965ed6ee292e23aedd5358c6584f4e691dc67a769aff6fb65a4ad3aed5edfcf927ae03aca9cd56db7a4c8b69bb749a5fa4b65e204f03795e65b6e69fdcd74be4797259bbd59cd73b5caf91d76e65eb312fd4e27a8d3c4f6963eb31bfe875bd469e5f8cb4f628f3cf186b8f3267256ca3ca634ed43adc3a6732c6b0f698771e63db7a9425a6b88e794e544c631dc1bcf998b7492e6d89659be5398c58b6699e5fc40d8f3a2722d6b6de479d576bdb54cd01c5d6562b755ead6fa3aad372efeb5c4d0371acd354e7d0e2e8eb356a5b52586fbfd63e5b63bd461d13caf506eb1c648a61bdc6bcd09cc8bcf4794c6182352f32cfaecb3aa716e6d96d9ab33487dbe755adcc4bac17b5d2d7599e666398d3b0198b79f22bae131fc7ec9856a852994ccaf39fa53e51cb2b83721c369913d7fe2b63662f9bf3519656d79b359bc3d96ebb4cd8fb4aac16e6f5c786570e733c614ea175eb1b5da6ed5e56e0ad4d4323ac4498b33f9b79bd9b38e6a484ed7fb3cdb90d7dac239f7fa29575199475d4d6564e95be823921597ef5ab8b8fd74909cb27174f2e3ebef8f4df5f9d2e9edcde7cf3f4f6f72f4e2f2ffefcd944e9f3e5e2e3674bcbeb59bffef5cf7ff6904eed48a77ea4d338d02985239decde4e9ba7d8bb3df9eaf2ea959e7fb9bc7af68bd3d52f97cd467c041be9c0e0370f37bfdf3ddcda48f97543290f1f4a393694ba7effbacbb7875ffe7e6abe9b8d234cddb6006673bce15ea6077bf038ee27ffbbd938b216b63d6bbf97145f7b2f6fb6918faca77cff7a7a4ba7fb17d05b3a1d5931f9fef5f1964e4716443ee261f311dee6231e36dfcfaaedc1e2adccfc7a6766b99f20ef66e3085fb647a29dddb9bc61a5e6faf071bcce87bf8b8d633e3c37dd4b7fd3bd8c878fe3759bc0bbd838b60994c0bd147bc3bd9407ec8b1ac79165b43dd8bee1f2f9e1973fb691948d954b39b232cb117f5f8ff8ea7a64edd523beba1e5919f588afae47785b8f90ac1ea1463dc2887a8411ed0823da1146b4238c684718d1ee6744d383e1efae9f7ef3f274757b5fdfbef99c19c7ef87ba1f76d7dbf7e7bebeb9c765ec3e6cec0f5063ef37f607edb1ef3b63b732762b63b732762b63b76201571878100b91238fec812d2c148e9523db41e0613460cfb0677c8ed88dd8552840246011bb11bb11bb7ac88dd849d8d50363c25ec25ec25ec25ec25ec25ec25ec25ec65ec65ec65ec69eb6ee8c1d6d7f193b193bda4a0a760a760a760a76f0b533bae788bd82bd82bdaaad490fc6d8ab0aa1f44881bd8abdaaed59c101f61af61af61af61af61af61afd3be777be878206eb0ca219dc32e864f029c2a7088f223c8af028c2a3088f223c8af028c2a318b1037f22fc88f023c28f083f22fc88f023c28f083f22fc88f023c28708ee119c23b846f08ce019c133826704cf089e113c237846f08ce019c133826704cf089e113c237846f08ce019c133826704cf089e113c63a37fa31f38463c4a04cf884f895de7611fb712f12b11bc239e25e25a22f8479c4bc4bb44f890f02709fc13f826fc43b2fdfc04ce09bf90f007093c13eb37b15e13eb338157cafa1efbe0975897091c133826704ce098c031816302c7048e091c13b825f04ae091c02131ff89f5941a76c123b1be12b8a4467fd65bead8610348e0963af6c02f815f02bf047e09fc12f825f04be097c02f815f02bf047e09fc92f0633d67f0ca661c777b19dc72d4e7c431732c1c2bc7c6b173c43e3867d66d66dd66d66d66dd66d66dc6af67789159c719bf9e59cf39733ef867f0cee099c131b3be323866d65306cf0c9e193c337866f0cc4dfdb10b9e193c337866f0cce099c133836306c70c8e191c33386670cce098c131836306c7823f2dacb7823f2de058c0b18063b1c43173a4bfd19f7dbc8077c11f17f02ee05dc0bb807701ef02de05bc0b7817f02ee05dc0bb807701ef02be85f55f58ff057c0bebbeb0ae0bebb8807301e7823f2df8cf02be053c0bf815f02a5db111f6c1a130ff85f92fcc7fd1fc0f9dbfdbab2170348e9163e29839168e9563e3d839620f1c2b385670ace058c1af821be2ee822cb920e92d95f9aeaca7ca735065fd208e2c923050301684864572006ac042d0be28b426b25e08a21742dd85a87651ec59c1abe2772b7eb7825f65ffacacd38adfade05859b795755bc1b5b26e2bebb6827365dd56d66905d7061e8df96ecc6f635d34e6b3319f0dbe37f8dde06b83a78df96bcc47e37e1bf7d7781e683c0734f6ffc6fedfe06bab3a9feb73df8dfb6edc77e3be1bf7ddb8ef86bf69f899865f69f0b3c3c70eff3af7dfb9ff0eaf3af3d08df38cd004be75533fece22f3afea2336f1dbfd199bf8ebfe8f0b3339f1dffd0e169879f1dde7578d4e14f679d77e6a9334f9d79eacc53679e3af3d499a7de146a611fbfdef10b1dbe74fc7a57a0865fefcc7357e4a6d0cd6337ece1df3b3874f8d7f1ef1dbfd2f12b1dbfd2d99ffb5010a828903010ff32c073c0e7817f19e03bf02f03ff32c07be05f8629acc41efe65c083010f063c18f060c083010f063c18f06044c5a9d8830783fd63c087011f067c18f061b07f0cfcd7801f2329f0c51efbc7603d0efcdbe07961b09f0c9e1706eb75c0af81ff1bf8bd81df1bf8b151145a630f3f35aa826cecc1b301cf063c1b4de7d11f9e0d7836e0d98067039e0d7836e0d98067039e8daee81e7b5209240c4812188adb3de0f7c85e217c306900a6af14cd0785ef41717a50601e14890785dc41b175c8b2a3e839285c0e8a938302e5a0483928540ec57b69188a9283c2e4a0383828f00d8a744393c1263b0a7283a2dca0303728ce0d43968706a6a973cdc4c512574b5c26719dc48512574ace52896b259a7033d96199cd860c9a0c9a0c9a0c4a6371d1c4d51197455cef70a1c3950e973a4c30b9e8e1aa87cb1eae7bb8d0e18a864b18ae5db858e16a85cb15ae57b860e18a854b16ae59b868e1aa85cb16d66450028609656b3228b85dd4b0ae9385b20d7d356450ca86a40d93b661516b472a8749e630e91c26a1c3a46c5814ca51e04641195d2d7399cc753217ca5c2973a9ccb53217cba496490e31e9212621c4a48498a490d99041ad5ca923b32183e24fd4a29672321b2ee9c9b2882455653664594492d062510a9a241793e662125d4caa8b497631e92e26e1c5a4a498a41293366212476643e7c827482f990dd9117fa2f813c59fd835c22ecb6254ecb2dc65592e45528b496b31892d26b5c524b798f41693e062525c4c928b496b31892db3e12aa96452513489a25262664352a9289ae4ac929c95e49ad9906539ab64b22c3e2779ad24622779ad24af25bdc792bc5612e72501cd866bbbb2ac5590b40aa40fcd86ec245782752d7135899052874c329049f731093e96b4a72449ad495e2bc92349dd31c936267dc624bc9814169394325dafb465cd7cd6cc67cd7cd6cce7e0bda4546bc2a5bdcc86446a4d78d6644a97b1acc994426392684c1a8d49a431a9322619c6a4bb988496b94bc8f25922d7e0b596b3a65772cb6ca8bb7687ac79ceda26b23685ac4d41aacc6ca89720905063526a4c528d49ab31893526b5c624d798f41a936063526c4c928d49b331893626d5c624db58d6ea96806352704c128e49c331893726f5c624df98f41b9380331b9e59504a41b491b86352774cf28e49df31093c2685c724f198349ed9501242ab52728f49ef31093e26c5c78a8824edc724fe98d41f93fc63d27f4c02904901324940260dc82402995420930c64d281ac886c455b89a49fd990654fbe9cb32efa4aac2b625d5166a568bd4b2bb2a2855fc4cc22d6151149829115f1a7883fd290664306459b22da14d14602d36cc8a0d8228dc92426995422932c64d28166438921f95e49415b11320dd911b855e04a2752099e17b27915d85e454c43d7123a9291b60a621abaa81e21aa1c88b42693d8a4521caf63f12210afc2f07a88bdcc9786aea500a17a16cdd3689e47f3449a67d23c9576cea5c9b267d33c9d264724e1c9509e3e5f48f0de49e67e7a733a7d727d7d7bf1c9f58bd35f2fbf5a76a773f1f1e5cde96afb76d9d9b3657cbd04c5bffde8f4afdb3f9ffebdc488ed3f4c6357d7b7a78b8fd63fbfbffae2fce1d379eedfafff75f1e4f4f4f6e28fa7cb2f4e377b7beda3f69fae5e3cbf3a3df9f2721de2fa1fbfb99a162e6f9f5f5ff1f9e6f6f93f2e6763fbf4b7eb9b7ffefdfafa9fe74cf5fa3f5f7f793addaea3bcbdf8ebe5d39beb3b9f7ffbe5fc7be7f3ef9e5fbeb87e76e73f9ebc78fec5e9ceb9fb75e669cf6e2e5f5efce1f9b36f6ee6ad3cbf7d71baf8a35dfcf6fae57ad5df5c3dfdf2fa662b7f611e3efae6e5d79fcde9925f5e14b2c445cfe469d1a358decaa3d75659b41bd6458ebb2df2677b79f4da1a5b79f466396cf5d15bd3b602e9adb957486fcdb49748ef2e7baf91ded7ea5e24bd5364af92deda94496fedbed7496fedb1174a6f3711f64ae9ad6d7ba9f45d867d74f9f2f4f567fbc79f42a58047ad1c3d1ee5e8312347c56c7ae8d5b3f38fb2c2e0f36505f17fa7cc003b7a20d363987651ed9dda3ab5736ae3d476a9dd528f568a9bb442b5656aa92954fa7699c23ef9ef5dab007323cc8dbe7639df74de776b1ab00f331fafb6013b3052c1bb627785ee0ad815af2b5c5790ae185d91f98faf16023b904ea1bd027ac5f30ae789e621c50f5e3041e25e64f4020a12f79051c1ba627585ea0ad015962b2a5750ae985c21b92272c5e10ac3157c2bf656c49d20678a2ad8a01fe44c9052617882940952a6a4820eece02613e44c9032e11e15b32748f983157a40ce0439a502480448903141c65455c811cee4f9a9568348c1c87848e917922f245a48b378b56a84f3215f867cc816fbe47d702525b8cd0c43a57b64182af923c3cc9cd58f71c04c89221946e6a2d214fac3c40c132590481fc9b8c90c23338c946c22d5445a89a4921fb8a405101fbdae85ba8c40dd064c2c30b1c0c412deb7fe053b30f42d7530fbcdfef0c530d883a9e7ffc71e4c2df8d273d10c7660ac2414092705a6167ca87414c928452f0ac0d4025325aa485391a42245453a8a649452d58febc2d0a2380d66169829b1a5c048492d525a089016e92c525724ae485229904ecaca075ac4b3934a424e8589e7ca1e8ce02625dde8e54abd5b290187371d17bd2ec8db828b5eb9e38dbb45628eb41c29381270a4df48bef9702b85b00309a5f348e691ca2391471acfe355166107b7592169c55d56c85a216bc55356485bbb2a93b00379eb50a51276206f85bc15f256c85bd9bb2b24ae90b841e21654f144e510e46d90b741de06791ba46d90b6e1391bbc6c78ce065f1b9eb3c1d7065f1b7c6df0b5c1d7064f1b4eb2c1d386736cf0b5c1d786736cf0b6e1141bbc6d491559d881af0dbe3678dab22ab6e80f4f1b3c6df0b4c1cf063f5b51651776e06583970d3e369c63ab7716f7f757ee851d3c66838c0d32363c6783940d523648d9bacac5b003091b246c2a9383840d123648d8206183846da8dc0c250af275c8d7f19c1df27548d7215d87741dd27548f7c8e5683b286faf49c3489211d5a8312898d8f1a01d467618d993cec70e9eb4c3c89e55e3861d98d9616687911d46763c678799bd480ac40e1eb317d5cad11f667698d9f1981d8fd92167afd214555b871dc8f923adb103ecff17da71fcaf16daed60bc5a6d87117cf180f903e60f983f8aaaf5549dc7a08a3e63c7abf5b003f307cc1f307fc0fcc1b3c2a8d2c31947557fc601e3078cff60aafe24f54beb97ca2f7d5f02bf4bfbaeed4bdc7755df657dd7f55dd07745df257d65338244fd20353f48ce0fd2f18384fc20253f48ca0fd2f283c4fc20153f48c60fd2f143f4eeba0b49f721796e42dda5da07c9f6417a7d90601fa4d80749f541d99e209d3e48a80f52ea8324fa208d3e489c7f7b9523598087953acaaa34fae0c92aa9f441f27c903e1f24cc0729f341927c50b94490281f94dc0e92e58374f920613e48990f92e683b4f920713e489d0f4a6507e9f341f50e410a7d18de4b89216598deabbe92a97db4224be5ce3defe40927cf3879cac9734e9e74f2ac93a79b3cdfe40927cf34798ac9734c9e64f22c93a799ee9478cacea395786a84e2b1a79b3cdfe40927cf3479aae95c182a0a7b96c9d34cdf5785a8c03f58262aab22bda7a33c1fe5efc57a46cadf90f5dc94bf2beb59297f6bf64eb9a957a23e56b9a9d29c5a187aa5d6a29642949756e6ca94ba32e5aeee16a97a71a9ba9f33ae8f5aad0a68ff4325ab5a2aca90995264a61c99294966ca9299d263a6fc98294166ca90995263a6dcd84fb42a5694f97f69ecb74a6365594b2e798d8317397895839737787d8317387865839736686d296b674adb59f2c218ad2465ee4ca93b53cece94b43365ed4ce93a53bece94a83365e84cef629b7274a6b7b24daf659bd274a63c9d2951677a65db94a533d50799f275a6449d2953674ad5997275a6649d294b674ad399f274a6049d2943674ad1997274a6249d293b674acf99f273a6c49c2933674acd99ded0b62c6267115b69ba4395c72a4c7950f9b1ba8ab947eb90351611f64e65b20c2637a86b252fa891c173f5b2ba6b9fb853cfecddddb22eea953a5eaa73ae795677b1fb4e15b47797652fe611cdf516fadd4a69753f974ccb72f1eebaa856c07d45d45e40a4ee3fc96a6ab1f2dd4aaa65cc2bf1b58a944e34e5134d09455346d194527cbfb26b06fee3acbd56772d1525184d1946536ad1f442fe1b0bb5bd8acdcbd8cea5dbbaba57b079099bd7b07911dbfb5675cba016861292a69f0730a5244d3f14604a4e9ab293a6df0e30e5275f5f142e161cab0c17e9f52304776bc5353a91be38c5c57e65334d694c531ed394c83465324da94c530ed394c434652f4de94bd38f0f987294ef5f852e3b62f79dba748de73b3f7ffaea8f887ebf95ea3228be7ff787115ffd7941ffa1bff34fee7db8d5ec3fffd97f0026589b870d0a656e6473747265616d0d0a656e646f626a0d0a313637322030206f626a0d0a5b20363030203020302030203020302030203020302030203020302030203020302030203630302036303020363030203630302036303020363030203630302036303020363030203630305d200d0a656e646f626a0d0a313637332030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e6774682031383737362f4c656e677468312034343834303e3e0d0a73747265616d0d0a789cb47b0b7c54c5f5ff397377f380846c02844020bb9b250990848d80082190cd8ba01112920009af6c80f0506091a7202f5b5148b1c42a5aa996a054b128dc047f6db0a858ad45252df210f1b5686df15940a1a8c8dedf776677f312fefaf9fcfabf93efccdc799c3373e69c333377819888ba203291abb8cc39a8dbd33f2f25e2b92875cf5c50bde8e0d78746115987a0eccf33972fb5edbc75631ed1281b515897d98be62cc87aef371144b66ff01e3367fecad979b7afaf241a9d41d46bfedc9aea591f1f48fb14b4be0086ce4541a783bc0db4fae2bdefdc054b6fffa3fe9b29783f44d467fe7ccfcceae6e8a37560fd08dee72ea8be7d518f7f757f19f563d0deb6a06669b5566fae26da73488e6f61354a764ed840b4d64494f1f822cf92a5be64fa1bea77c9f68b16d72c7abffeb7e8db1f63ec1e4372ae219f6f18b3f7a398aaa8ac8b61e161249fc727787264fa967353946fc577e3cd8f86ff056dc3557bf9200d79eacac31052b36f8591617eb4a526f868b2a4cb3e5a4f16f52e903a099208db0fbeaa85a9591c20338599b7990783641f7faa55d36c1163368bd0907021ccc2643a4d038d83743ba48c11e0291f9b672384a4c3e6685fb91c8998e322360c03bd379b0ec89952775333cd91ad91ca011fe0305a454fd06fe943fe50f4a1af902fe51d7480ff4e4fd12e6021dd430fd35df436fd1a6f27b9991f30fe45fda99c8ed2b3c6518a2717f5a1049a4539948e1e0b51926fbc639c439b55d40f75eba894628d378dcf289652e921f6d1efe90a3d69ece59d54697c4e8b6914e5d256a017e4a25301dd697c408369a27196c6d07c7a881e007d32be47ef546ae00ac13c9ed61847c1dd45098a532c64d81a1683963fac0f04506b090981f03ca76024a368265f4f6ba8a7f11dc26ede099deb6f9c00c529548a999683671f9a4e79144737522847731425a27e20ede203c629da442bd0bb800a692ecd5663ea6fbc65bc85be2fd36374847ddc0ff3ff8d1a3bb4952dbc0ad2799b5e8024fbd111ea871e091208bb02a1bf0ab12aac672b4770223bf89ffc183fcc76dec356cac79cd641320f518360e33d8c55d25f058995d2612ee3ebd865ec8076915a975cd094ad5d908cc42863af78053c2b2530bb51a090805612f974671090ec60098c65225acd5790744ab12212b1e8218151288cc27a17d37868ca9bb49c5ea4c9c65efa0dc7601c82d704216368497f9a629c1209ccc679d147f491b11fc1c06b441fd9daff76adfcb5839803fe4825778a0a600fada664b9d218490e35418a0273da8e359d4c11c649e3a4e82c3ac31a0ea13e8dd3680f5faf6414945c504a12396d900edd4da7ce90f3fa7658087d8e87765c179427b4689c926750a67e79ae6e916500c667017ddfaad6e984d2c881dc2ccb8390f5b0a67f81ff64d8d7bf8d2f8c6ff812efe6ed740cef575a031d54961aa1d64a5a693c284a1b9d8771f4839dde8831a4c24abfa5dea84dc51abe498bb989c6d2191ac04331f3cdf0bd6b280363ce631bc6be1bde602c6452486ed6909b08b8316e0333756156bb942f10b0e44ea0dd9952d408e01bc02f81c28dffa8552825b3f10e46d41f58857eb2651a661a011bfbcc38669c86a5407ec67b987f25a425fb1760be91e01b8d504d61f0a9e9e09e02dd5f8cfe0360aba9e8ef92fdb1a6dfa14faef10f1aa2fc4b3eda3ca43c826e5c82d6f70285019482f27c4ac2dc2a45c50f42778574cc739320ed49fa191fa63a9a06ff578a7c261998b99d6fa0325a0a9b48a39b398e5ea7eeb4815ea09769332da19fc337cca3dbe04b46d2487e18b2cd44bf322a339e319e41bb798150a7425bcaad746f56349fa5fdadf4d0621aea5ea659228f37b39bfbf20bfc023d09101fe3b9c031de006ce113bc9dc7b085fe86d84a9f83c351fa8c96f1abb44b0ce13fc317c5d379fa88235ab72af43aa7c24b7c901b7802b48040ed16be112bea7fcc81f4037a5ca51b69769b9dceffdc80393f85f13e853007e11984a7e95bd8dbe440f95c5e0d5e5b78266f09f4d40269aac27fe9e16dfc24b4f98ccabf80f97ec8f7f04afa2bbdc18ff21b6a9cb2e634f281f9f1421ed132d760fa01d55f2de5659c24a164d0560eadf2d0daa51d9fbdf46ebb3428db05e4974a18f90f21b594acf84de6c9ea7d3d745fbe3763acf2c17cd45c6e8066cb672476ae05b0c705f0ca007f8ed5865ec09a5660354f40eef1d0800d38c92d87a5905a09ff6aac864e79d8835e0bf838b4e025ec751b7909bf0cef1b2e12919b482be149bee7b58150cab706fafc1ae159fa0bfd8517f002ec907fc58e1289fd6e054de6dba18157f0ee0f13682177a22fe94bacc2a36ca3cb5cd246da4129484d9913909f9c6d31c234d88797dfc07add8722e94fe137b98ea703db10ea6001757c3790ca5de1cda7f3746d05ce2c3b8c1dfc4b7e5ad5de821089904adf702c70a625d4715dbbf7d650cc3d80d4e0fef953d16eefb81a827b467077f8a9e8b073b4436a6b506308d2bf4a5b78870fe838207d61383c6c293448221d2148459ee012e1a7e57e978d3183165fc09af7e57ebc1fa15f20482b929a18d4c68e56f453d36b58db8f59610bc604d21b5acb5a2cf45ab8d6732d0bee68b13f964a8b0ec2dc52ea7f8256de310d72fcb134e01dae9906bcc58fa64179c2ab7035fbef0a48792a2f6c59d76b8131a780370dacbfdf13c974b23f60376aa6a9f43ed6670decf0efd85bba51277e5784c23bddcd43792b6ac6c0730c923b1abfcb77b7482828fd80d451ebf7838cb0007b7bc0cfb505563f9587d3481123e2318689d87fbf820e4f2007767c97f101ce4184db4929ceae8479afc29d84e0d73e57705117ea8e9302eea538dffe1afd17221f65bc8959ca338e3cdddd491938e7903a2977527795b3a07c07fcd28de4c39929419d977bc37ae46aca93b2bca1aca17b412b07611c75c29d6608f5e7032df3ecd46203b9d272d9d2720e0c9e3925e7a00f58cc0370d2f43fb20efdd5e9bda3efe9e86382a7faa01f089eee5720481b1f0ccfbb538eb8858ab4784b3bff23fdc2f5904d04a4254fc2fd10666204cb704623d467e24c944b1eac4f3fb2e3b6ebc49de610bdaabcff518cf3b07198702fc76ac4a0b51da7c889340c211ee37a04f742d93f0d6390639a07c97555f7c1253875c93b6106e8de8bf722accc72d42ec729ab3ffa2e03c774fa03ce7df9582959d3f1e924fd219b71a3bb135ee13ff41fee465f71b4e8ccc3f97ef8309f0811213c9247aa5ba0831c62286e873b1127ca14d6d0ac5afc5a85449ec25d40230fbb603428583911b73fc4b8e7cabb5b5fdcdeec6c45ef13481d083ec9434b56b424852cfe7d2b35395bd5e712ee7c7bd02b4bf646903d2314d5447f8a13f353e887de9cc04d82e4bd1a2102bbed3191c659d0aa13a018a1c22dfcc7c0ec5340ab3fe7f200eec2e9acb199de837fec475f63f4729669f41a6e4cf9c621c86f2259a844adf574c871168203fbb18bde84ed1c861d4f85a44741dfefa02cd8fd7c5a84740f7acc476b1dfd76e3cc978093782e4eec9d69384edc03e4106043845bc879e35b84778cf7d1ef36dc40fcdad5f6e98ef7ce08cfaadef21e360dd288e58b7c49da3d2847abbb85bcff76a25ec67fa07936aa367c6d688cc21dcca56e08a5ea462877b1e0b34bed77436884fceea2f63b19d00277138d1d2dbbb8b43e690372e7430fc5e72e2a92fcd5188216216f289d611541484a6fa3c5507543ee67fc13b69940152dfc73a0ab1817e4be8bdf13b1dcc80ff25b3cd038afbd8edc835a2617e02455cf7fe4e7f83d9414e004f720de77e2ed392d1377e53f8bee6c414801dec34947798b161fe6f7638be54dff07b8da496416acaef556db1e410f22bd4f106dbe19a87bee3bd08b2002df10da7d4b680bb966ab94bf9cdf0ed2137544f0bb43c7ef0f6defcd6f06f42a78478e0d9c5a64087ea790e8450fa81b7425e63abe7d309e351a8d81469a116e84fa5ef3bd86fda22518f5c66f8d5e469cefa2ef6b48b45d308e1a478c142349c277c67706f7a617607185127402810c9ff1aaf18ac26a63759b6f52138d7dc632dfabbe5714ddb1ed83b1c7d00ccdf71778c676c1d86ab87d0dbebd0abff7ad50a397a3c458b0abee5494c7aa7bb9fb47e7f82373f949bc5ba91f0d06be041f7449fa9e36b4ff61bc8ebbbd4ee9d8e7b7a2e6327d27b76ffa18017b2a6ee65e78e0fb511394c16e0499ca73ec79c8ef753a06efd6a7cd78f61b9f183b8d9dd45bc4f1457a986e6db12ef94d310a3b8dfc16260f0a8f217c8cf018ecc78e10014ffe69206421dcc81fc39f3af879d52a4e8460ddf6c2cf4a2d95f933d0f9c53409210ff6ff33fa0776f23c9c4aa221ed5c603d0d344ee39e2ea5ef845719025d1d8b7b3dc9ef7fd0b9065a45bf801fc8975e182d22e1734ed153f0c11ac7b3e0c1f0c891d84dc6b1c03df93d3a87f22eb0f9243649d0a7f0dc76ec589fd13ba8e98fd003a11f7cb9033e3c161e3d1d1880d3553ff4bb19e7a4af91de0bcf301eb72007da2561a7fa5a950c9525ad4e9217d35edcfc6278025de45cdc0bb7f0d7d88582a7e6e0b318feb31f2c28138bd6857ac073a5cb007b7e0c279ee093215b4a0f8a3d6220647254f9a07c4843dadf38ed97588148ae57feddaf19b87960e7e90e5f56252ae805eec96f63159ee7c318c70bd080fffb2d427da7687713083e1defdfd73ad55fe309dec73bdecb7f90064fe21d6e1bc6dfe18bb7426f08729a0f9f1443ab21a5708ec29993705ada677c014ff0053c79226a497d25ff103ef5acfa422eeffea938a51948fb29828598fd01e8e30ae48b305fb9c767404fc6aabb5a77ac6e02af4070e0049e87f3c6fb4a4f62e97be84e7f9c615c4a7b86e3ad075d824ecc849df4e49bd0ee7dfe025ad6acce0f03705ae84f39d2e362750f74f432f49d3f40cf54e8e8d9e81384ef1182eff2c42ebfcef5c469d2bfd7ca2fa87da06566ccd38e39e6aab3f39dea961af4ed0b71dac3cecd93fc815ea297b856da2e46f552cb37ed55f2fb1edda47631b96b492dac543bfd647e1537d65b95f567511cf6a9389ee0ff8a8e3407b638011299023fd58fc6a85dc5414fc076fd2bdf4ce7f9438435080754b05206f21ff0fbbc1854fec6cff0a3d0fa55b412a113ec228abf43fbbff19b18e389407897bd68ff2e76f6b7710ed4903ff3835b6ef0917a132c7b179ecd4bcd2d37ae8e69f056e6c4bd4ba223ade013bc69f6854dc71817b9043ad517165d082fb38dcff1d37caee526d7f1b9066fbe1de7e661987909cef76190b9fc356e38ee0aad4f2794ae69794b874ce5ea6c45905a9f404fc3a3903a251e557784e1b0a2c7f84efa5a9d07fcf26fe487f898fc2d12b6774ce536c8ef9ff25b16805d17921e8eb09637f3277c01b21ec123702368a6ed148a10de21cc55374c7fdcd183049f8e5fe73a7e956b7be7f5b7ab54abf0017dc02ff22b08f761e7db86bd6a2f3fe18ff90178f507507aafd2874b81b0858b793feebff21e8bbbb0f1ef8e019ef16f3c91df14ddfddf8de936f8cf8760173790c5d80fafb20d16138b1db03774be1c7beb57d8718a69b9f13b4a818d2d31dea0fb515f67dc0f7c43b1c676789e81b85f3d41c5c605684057dc541ee4d59ccdabb13f2f30fe4ac9d8c12f91f4db73e1815e00e564f8a627b0e72660f51e81dd8f454e37eea23fe1c4f72e76cc7729092559d80992b186ab91f6c64a5e6f9c84f5c8d377b8f135f6d6702004ebbcd42f3becf241f9ef54febac397171e2d06495be023b4d0d8020af2098595c31760dfc1291f31615f2675cf0e7af480a6434be2afb963480b0bae5dc7b50e7e715dc6f793953ee20590befcca295b0af90b9c6160f77d923e22ff771989de815f82e7fb7f01c63e6b825510ee3a16559f08a98cc5f96431d5271d565edc063fd1a604120f86991fffee07bf2bcbf18450eb0fd14290faf5af5d03f9e372fb6dac6bb7eeb13de27af68aeffd437a6affbeca53d8ee6dc2d51bfd9f9fab7f24ffd1e7bf2e55d7cd1593264e282f2b1d5f523ceea61bb3478dcc1a91397cd80dd70f193ce8ba0ce7c0f4b4d401fdfba52427f57524da6dd6843ebde37bf58ceb11dbbd5bd798684b5497c888ce9dc2c34243cc264d30a5153846bb6d7ab25b37253bc68c4997ef8e6a1454b72970eb36148d6edf46b7b955335bfb962eb49cdda1a5cbdfd2d5d2922db62cca4a4fb315386c7a73bec3d6c493c757207f6fbea3d2a67fa9f26355de94ac5e22f162b7a387ad206e6ebe4d67b7ad401fbd7c6e6d813b1ff41a3a77ca73e4d5744a4fa3864e9d91ed8c9cdec3b1a8817b8c6295113d0a321b04854562547a2f477e81ded3912f87a06b4905d5b3f492f11505f9f1767b657a9ace79331d337472e4ea51a9aa09e529367a489e1eaad8d8e6c9e9d02f6c0d69076b37375968863b3562966356f5d40a5dabae943ca253c1375fefb1eae3b8d657108fc9abb8a76d6dbc565b1037cf265f6b6befb1e9f5e32bdad6da655c59091ae82b9246bb6b4783f56629c538270622872fa7e29f548da34096b86fb1e9e18e5cc7dcda5bdc58905eb53a95aeb437f6eae5da8f135daf025b6d7985c3ae67c73b2aabf37b3774a3dad295fb7aba6c3ddbd7a4a73558a2fdd26ce81215c84444b6cdd4b4d4a99c6a2e7345a52de2643922c78d5003dd36d38691543830916132aa1946b53387a1199e4a462f7d1696619e1e9ee7aeb564ca72d95f3727591cb6da8b8465777cf945fb92ea40494892e522c9ac548e1605437d30afa7a6ea030648bd08cdc342628ca3d4fbf5e969cb9b44b36391c58604e2a3920a74abcc7442e676bb5cd55f34b968065ef4f5e32bfcef369a11df482e676aa52edcb2e660b0a6fb0459b33e58d3d2dded80fa3eab2cbabb1e96dcf2176589ed5a303753e7d8ff47758dbfbea8cc51347e7285ada0d61d906d5179bb377ffdb096ba404eef9a57a1c58b404ec46baa169a38b5a5b17ca988d04d49f80b519a3cab29340caaa84ad8365ab7b8c7f8e3ca4e76fb4fecd4649c93bd54d2da2d304c3d33b5fdfb8876efed861751ab61c0a66451543eb9b6b653fba18f4bd52392f4f02468851e99a47751f9ae498db15d26a4daf42eee243890a89658466c9950713cde5e69abb0e9e503e059b2e2ce39cf65e9253077bd7312f455c666452b4ac5918a68f724bd47521c5bb2becf1a3ed21977fa9c6cd62949b28f527158926e49d2a3553e36a9b167b41c41b4e21dd312cb887e300239004bd68f8f214afdf548d27b26c591252bec7b0a8c45f9079dfdc22fa970c757574acb937fe6a409157a8812af5dbad180bcba281616f5e7275b0ebbd58b53f1072badbcd36f99767fb7360f2868c96cb971447a9a033952395bb2037f28914a6973c30c936a87c53bec954d86e1965e550940b8936cb2bad68dac432f1b206b936df17007eee44a74d3d07634b692dadad10edbe85a776d7593b17e86c36671d4eed762b5d8da4505eea0913619cffd225e1fbdb9127a399733e18004e5363878e3f806176f2c9b5cb1df822d76637945a36091e7cead6ce88bba8afd36eca3aa54c85259285f6cf2057753c8a05184a9f6f1fb5d385fa95a932a50ef339b98545958b08c696693f09759fc8c921523170e3d339b4cfe1a57b0b5096561feb2f5fed6fd02adc350639135cf1176675295fe47ae6e5e79455b1357ab53994ed430c99a33d2c4e40432004de5b28162a00a70037f07bcc059208c6c81b65b80ed811a335935839c4006a05136e22ac0dbf2b605d80ed403e70033b934dfbece5d0659730a351fbafa6811b01d30a16bebdb5955b225f0560f681485c39f1cb41943356320660ccd8c5636ed7b945bb4cbe401eaf1761a3081fa771884c4652a46ea56b80c7c4f2f223d029c033a1907b56ff68d2f1b443959dab720f42d46f92d95008b80f5800e9c062007c44eed0a66fc2d085f51addc401df022de0f223d1268dd1974648b2b687185f6027a9b56b2c539201cecbf6d1cf1e0a0fd2a1319ad3217f765660d3a92d34dbb88b9d5a9380ab113c8068a812dc05e20046c2e348647a87e171a87670eca9153ba4059b8dcac475a8614effbc69742ee0928c8068a015979043083ee050cf202385d20d9d5046e17c0e102e47f01ab811290f8aa7168a6e2f255e3b8f24139e3648e8e2bea5fd1b140fa8740fa5820bd3b906e08a40b03e9dc403a31909605d25181746420cd0aa48302e975813429902606525b20b5aaf47c63d9e0ba9cfeda7908cead7d8a95fc14d3fd146a5482b86d491d500fe8c041e008104e752613b1711031c6a55d12937053b082ee3945375e3ba7e87e022a9f80ca278aee27ed4aea807a40070e0247b44f1ac3636c392eed2e68cf5d24d312c0845edbd06b1b7a6d43af6df24301620b60033200175002e08aa49d44cd49f889d3da31e8cf31794d426c016c4006e002ccedde34ed6551856b8355db29a635ceb23aa1068d508346a84123c67e5a3b0e5ac715ade3a0751cbd8fa3f771f43eae68b5be69dae4466d96b549fb73639e4c5eda679f658dcab94ecb03f93c68521e2694a7ec3217423a88f83420a051b9a8cd05915cb4c8c59473c9ac156aa9b8535bb52c81fb34d2115aaa4a33b534950e0fa4c3b4d4c6ebc12751cb00950ce86686f4095a0ade52f096a2defae2ad2fdefa62981988fba2670ad2c148fb6a0ef98e45b43576eda9f4d8d6684f0a64060e1af4bc66171368846a62df575038c89dd359eb8d71f6c6e853b4783a090854c6375e3748758b6f1c5d18c8c07fe4446b3dc47cc5abbbb80845b46add90f647da35905a1b1372adfb3947546015087a14016947405411906f04441381758e807822c036021a11018d88801e45408f2220cc08e851c4be2e3131ae26f15a63dfc1db9f1387e8ac38e49a206c76de6e3e6b16db4d674d62bb765613dbc559215e0c7931545843b243aa423c215b42ccd6d0ecd0aa504fe8965073b6c8d68a45b166b225d8126d29b6345ba1d99260b15b122d2996344b614855ce3c712b16b14abc873bf97bc2134698d67af12eca6ce214e20cc42e40901bf122955b8fb84ee5ea11eb2a7750b5967dd6ab774b4b3fd9f208701ad054b9ea2b4e89f98a9b4dbc0d2e6fa3f5dba489b7c52e556a11275123ed40c619800b28014ce2a4d8a6daec126f5113f036a089b7c4ad302cab38d13824ca9a73459c1013d5fb618437105e47780de110041aa5f0ba9ad56b18fb6b6400d8d350ee06160175c041c00ce9bc8eb9d58bc3727b42ec02dc806cff3a6d015e04b0cba2b513b96c45ab0a31d33ab19a568906705a276e075602ab803b6040ebc4526019b01c58a14a1601b7018b8125aa643eb00058087854c95c601e700b702b4a3ce051a37878c0c3031e1ef0f0281e1ef0f08087073c3c8a87073c3ce0e1010f8fe2e1010f0f7878c0c3a37878c0c3031e1ef0f0281e37810723be1d5809ac02ee50e54b8165c07260852a5904dc062c0696a892f9c0026021e05125738179c02d80a49fa9e867827e26e867827ea6a29f09fa99a09f09fa998a7e26e867827e26e8672afa99a09f09fa99a09f293c0da6cc1c030c32c120130c321503a762e00403271838c1c0a91838c1c009064e30702a064e30708281130c9c8a81130c9c60e00403a79a8013f49da0ef047da7a2ef55f4bda0ef057d2fe87b157d2fe87b41df0bfa5e45df0bfa5ed0f782be57d1f782be17f4bda0ef55f4bda0ef057d2fe87b15fd75620e146937b007cab54ecc04660135c06c555f05b8816a60862a99024c05a601d355c924a002a80426ab9232a01c98004c544b3f876e019f1ac5c7033e1ef0f1808f47f1f1808f077c3ce0e3517c3ce0e3011f0ff878141f0ff878c0c7033e1ec5c7033e1ef0f1808f47f1a9029f2af1144d062f692c338159400d305bd557016ea01a98a14aa600538169c074553289e42f7155e053a5f854814f9528cfc141159caa14a762702a06a79b14a762702a06a762702a569c8ac1a9189c8ac1a958712a06a762702a06a762c5a9189c8ac1a9189c8a15a762702ac68c8ac1a758f1c9069f4cf010c8cd04660135c06c555705b8816a60862a99024c05a601d355c924a002a80426ab9232a01c98004c547a378706281e4ef0708287133c9c8a87133c9ce0e1040fa7e2e1040f277838c1c3a97838c1c3091e4ef0702a1e4ef0708287133c9c8a87173cde513cbce0e1050f2f7878150f2f7878c1c30b1e5ec5c30b1e5ef0f0828757f1f08287173cbce0e1553cbce0e1050f2f7878250fb19a9f1077702f58c96558cb77b09a1db08d7ad8c876d8ca2cd8cc245846212c240f9692058bc9805da4c33ed2602729b09724584522acc30e2bb1c15a12c41cd09c0d9a357439c781517f87d1efc018eb31d6ed18f32c8c7d1246588891e661c459187906c6978e71a661bc2918771246978851da315a9b2873f54c78f09b59d64dc062e036e03a6020d0c4bd5cd7e3647419a8070a812c20034801928044c0062400141b4b4431d161ae9c1e62a4c0398022f979156f51f12f55bc42c537abb850c599ae1e2591cf9744d696447a4a22ab4a222b4b22479744669644fe897db4162dceb8faac8ddcba36f2eeb59153d746deb43632776d64cedac8e16b2387ae8d74226fe32f380b0d1f53f1832abe4fc67459c5dfa8f8b48aa7ab384bc5361527705663248537f1c546fb48ccfb42a3bd18c9978df619489e6ab40fb11ee027c88e1ba3957736daa7a3f4f1467b2992398df6eb91cc6eb45f8724b7d19e8724e7597b86f53b7b93895d51d60fed8bad47ed375975fb70eb0e59d668ddaeaa3a5b17db53ad35f601d659fee249fe244f267fb08eb4efb6a6fb4bd2fc2513ba86770daf6be2fdaec1a1757f0dad7387d66584d6a586d60d08ad4b0eadeb1b5a670dadeb13da2d2c26cc12d6252c22ac535858584898294c845158b726e3b42b4dfe06d12dc4229310938c4d2a6f1132963f57c83b388709ba89dccf899138268c6c1037e85db522515496cb45fac1995434c3a6ffa7ccd1c49dc64fd6cd8e5cd6638aa8a83c3775495c91deb3ac482fc37dbd498cd4d7e717d9f0e83d4bd5ebc1fc4a3d59659b98901f14c8bb90cf0ce4d7235f18c8a37da57e436a5153a851aa0f4b2dd2c34ba6543430ffb2126fbad8082ae5154d6cc8a20df1f233f37e62b66eb8375ea6c6867b2b2b297679765c76cca8e8e1a3f3af12b903716aeb13d79a95bc4b56ba22ac7b42ad05a1d6c1a15647a82c2f2a4361dd9ed0ba82d03a2c84bf30ae8ffe605159856ef4c1c4029922ac5a996d6ac57e912d4616e4ef17a3645259b1bf67bdc82e2895e53deb31c9967630ce6cb4836d6607da51926c47491dda258a51b25d8a4cfced1255bbc476ed1a0aed05f90d767bb04da16a53d8be4d7dfb36f5aa4d7da08de66f636fd3a6eb30b2ab36f6aec37ed026f127b449b96a9bd46b3d35b9d7ac6afbf07e2a656fc388e5f21701b7a3a00670ebbf583e374e5f3fc366db4f23d81bf8b120d93d63e65c9956d734b1d75193af8f70e4db1a4a97ffb05e5f2eab4b1df90db4bca0bca261b9ab26bfb1d4555ae0a8ceafdc573c277b7e3b769b82ec1ab2e75c85d81c492c5bf22a9e7f95eaf9b2ba58f29a2f79cd97bc8a5dc58a57c13c697d25150d61945b9937d59fee139d3b41ebddf1f6cadc58cba251ca0446d8e3d6c63f87abff2eea9c5aa9473872f5484056a5e7a4e7c82a18beacea227fee0954c5ad1d618f7f8e7705aa2c288e76e4124ce0074f41fe7f3f2c55cf929ff0fc949614ac5f1a57302fbfed9f32ead4a5a94bf097baac8510de409896040a962e4925c8d815e14e71a7b90b357782db2e962ca99485cfe356256f3df27ec528e3a504e50b88061d030fa8f83324c9912c016df627728820f51c91b616442a79c9d26568b18cfce9559e60853f953100c2c1ccb25422d319e057148f34419ba1fe0dbc37808f7c6b557d77df15b8f79370f3cd01f89fd9d4cc297897e141fa3de24ae01eba87efe69eaaf47e7a0af12aba8b1e9093a775f232c815f434f547f9294aa589eaffc27e8bb7187a15f5cdc679caa56354aedaf743d943787f45fe9f5261c556d36c4aa2636c983ee718ed77b49cd7f1d75a15e83f040a3ef1a221ff3fe4067a242ccdd843c9e4a205b49aeea347398a138d85c6290aa158f02e307e671ca26ad43650133fa39598d618dbd1b38c16d2afe8591e68729b5ebbf20fdfcf0d8f71942268133dc19dd92efff9b1798031897ad330caa6a9f4867ff66c33f5bf62f8de371a403f957240691db8de477fa623749ef3f99829d94c3e36acc61bc63b144aa3d077abfa7783164ee4d1bc5bf4d0feae7d872b751c15a2f754aaa139e4a1c5f424c2d318e5591ec2d773bec817d3c446b155bcacdd6f5a635a8b9559477f6262130f6017177119efe6a37c14d25aa9adf111c663c37cf3a8806ea669ea5f423c4887d4a84fd115668c60367b780dff86ebb9993f14af68e5a631a6cf8dd9c65dea5f5bc7405e764aa191f2dfa0607df7d03eda8fde1f82634f8c7d3067637e3f13378be5da10ad449ba2add6eab4df69c74d934c7b7c437cff3636183b8c03c65bc6bbc697a0174d89944e4590743955d01d58b9fbe831507d894ed257eadf382ee49ff10338913dc37bf800bfc53e1129766b43b5fbb53f98d8e4326d35bdea8bf63dee6bf29d350a8c4ae37bcc6f06fd9c3642db1ea727a071cf829a970bf9661ecf93d90d8a77f3267e925fe62f84494c15ffa3256bb769abb43bb4adda4553926995e98479b96f9aef7edf7e23c35882116f343e53ffefb827dd80234d394da779d08c45b49c6ec7985743e63fc3c837a8702f66f00c78fe91fe04b99ca62fe82287732477e13e9c81308c47615615bc9437f3c3bc933fe2337c493046922a868a71620ed6738778451c131f6ae5dad3da01ed9876cc146b1a6b9a002d7cd2b4c74ce6e8909161872f9ffa7eef955f5fd9e613befebe6946a8116ff4360a8dbdc6cbc629e3dfb05c1ba5412fc7c1a656531db4a6092bf50634f008d6fa9f74063a6486be45735f4ee6b13c95ef84a4ef86ac1fe1c7119e82e6ece52604f92fe10ef25ff808a47f924ff33ff932437945b27062c453c56c7187d8259e172f0b9fd6598bd71c906796560399aed1eed19ec01c8e6ae7b54ba62ea6aea664d308538de957a6dda6974ca74c97cd85e6b1e61521d1219b43b6043c47ab3f91e7c8023104f40557c2fe2320f1ff11af8a745844f3ff87b0892fd121cea57ff21568f926843be913d8d12491c7ff82263dc637f0af7887d07073dac407a99e76684ff35be2e7b419d63f903e47cc622e0fe48da237bce17d621ffd039ad10c7b392f0a916fc64ac751b3d6cc8b7097f88aef25f9fffcdda23bcde1a3348c37723ecd17fdc9414bb959fdff2432bb4c6c9e027f3b47fa5ed356f199d8ca677137dbaec6bc99aba99efb43df9a790aed155ed350d3f3d0d2d1b0d25e685d2a42782574f31161a227c5abd0dd06d8d93858c543b0de7ad8490e46dd8f96521e8fc779f7128753346f82b64f87656ec27876d3ffb6f72de06d1567a2731e7a58cf2347b62559b28f2c3f25d97a584e62c78e8fe238b61cbf6a3b09a19844b66447896329928d098f4bb8b084965b02054a81ed96de3e20a5e595409d343c7a97bb4b7b97255b0aa4a5a550525aca7a9b76d3b4dbc4f2fe33e748961dccb6fdbeddefeef73913cdfc33f3cf3ffffcaf9939d6e3316a9e49c35c5b164e92d72f692fd8b9f8cebe13a81c7d7de14ef43c35027e7c9c52a1bf46efa26ee63c5b003bc639d6266b5fa0d323e8ccc227d0f7206271ccdba813bd45dd0171a313fd882a440f2d4c2c04c01a5f59d8097cde8af6a06db2a0ac04a271186eafdf513c2c7f5bde2cf7c929d975b2886c40b655d6265b27f3c96a64769959a697a9d85fb33f614fb3cfb35f61ff27f86e1d5bc06a98b7217e3ec53cc0dcc1c4991ea695a9039bb4312cfd6ff4bfd01fd03fa6cfd02fd247e99ba82781cbb7165e5e7860a17fa16561ddc29a743afdbbf4dfa61f4f3f94be2f7d67fa503a91de3dffd2a59f5c7aedd25397be4a5d983f03f1eb3bd4f7d217610f985eb872a17be102f89b71e19e8596f49bd4115863059a07fffa0788abf7805ebe02b2bd02229c40e3cf6da7d1efd01c48e80de83f811e25df3ab11b6d970fa13ed0772578e62d92354621d63e02350674950f3b402b48bc1b747215dcac18aa0a76da97d03716bec46c031a4f116779847e95e2d35f4655106526617fda8adea336a25f413a8e8ecf3f88df912f7f04663d213f8a7e27ff027311289e4077d0ed3203eb019b9fa7e3d467163e99fe24f904d009f6e7e44d6134febc2e3b2ec36fe552a00d42895c718ea6908c3dc720955c768e61684b9e823d4721b372ebf526572f77beb967beb997bbd0dcc3cd37a3d6e6f966fcf279eb0d764385dd601f67d1259e79f19220431711cfbe88ef8aa7167ec6b0322fec0736b44350e7a9f3f4b44c4d69113b4bcf0925c56d05eafcfd9c693fe24a390fd7cab11c97e04e73ef70e73819374b4d1cf3aa28d5295a0597f05eaa0e995cdc85e1b9e10367b9b3a875fefd569f17250f508c5cee28abac622a1b026bebfd850546c6881bc41abdd0c8ae773ad7b34decd55bda77556e6a6ada14dcb021c8b6cf7fcedbd0e0a5f77af4bdbb7687f4175f73b7b4b85d2dcde21df711e6dbeceb48099c6f12ca74b23348959747c12d587554ed331ccd7b953a4afb94473da05f1a99f35327280f22421aee393f7ffec2f97960b099c3098b88b24b3c2e024a4a1994d92dc5bc8c8a60902f06907d3d5d58595252417d289640fbd1859fc1a9c203bb941d7d5e50858c1d1a99ad83d5dabf4d5f4deee6573f03f1d4e230e17a1e32435da9cc3397dd7382da8524b57173dc9ca8380050eb5ceb9ccfbbf5493d5c5fd7d27c6185ae22bfb2b8525e515a51a036b9d01a2de7a2ac32b30b4e8a761755a432ba28831e328bc2e6423c0d19b9532d1e406fa60a8c34ac8a6e6808e483ccf31581aa4a4799425e50602c2aacf7af5bdbc056fee2cd1b1e7be0fd37af7feca17f1c6ed83dbc61e7d581f0551b76d2fff6eecbe9cfeea72abef2eedf53f189f45b5f7de4c6f6eed4d7df7df4065cc0128f829d5681042ce88913c8b2f0a2c099edad459631cb8c8529b0545868cbecc2b9a70bcd8159e8d31452ca3c955aa3d5e939c349fa41fa21faaf056d49082dbec92fd35a501232dc64a48c4247835128ab0818058f3f609ca5f63f8364794a4dd1f3f456fc2d40f408d800458f0879867eee2eee618ee14ed15da818dd43fd5034c866902a36c8e6d63910c670a3cb0576e93a300c6223e62877d8456bac372824c35c47bffa6a576b6bd7fc7d387ff55beec2aa46679bcc73f16f1aeb6a1bf18bd9e1d56cacadf1e06f3b821d833582042a28b8d6ab6095c18e8683fc4d8e9bca6fa8602bd4350e577947f96de57fa77a49add8aada862650b47ca4e208ba50a1c82fe31c5c395771baecb4e374f9e90aa5cac9719bae40b30bbf3a8e012d08edd8c6d6002e057d53c317ed2f6a4f6b99432a4a4e31b3d4d96314c3c059e19f8fcb1de5a86896561fe73a4a647978d4a68e0029bb0749f9f45043de2cddf32c853a144a8df624ec6c764af76c424ec92d55c6597a5cc8b3fc468984aa600049c349191a84127ac1bf4a954794b4d25c79124e2b574bee848d16a4ca9dc7160cce354722cfcfa1a9756eced0d84871f32d8d1e13e27ec7bd840e245daea7e4f88d21584e6f1ccfe3022a0e71f5ae9d14560a756018815a2aec244c14d81b1058668058aa422e69468c20508793e4772aec9e7597aea49da9a65bf64f862a8b74be72674bfcf51bffcf1f3a0eef7da564e3d6911f52dfbda5ad796b4a286b73963757371f9ff8f0916d771f8a82d60e83e70aa0b516740a221fc451fa0fd4efcd345eb4b0c5e30bfc00bd65a6154da6bca2a69879acf6a0ec60c1b58d075af2f29479ba002aeb28b57aadb4d5ba5ea113d4da804e67ec5068f5be521fedf3b93ad6cb4a4bb1fcde39e6a820723c6e2a0ea0ea59faeaa7376c283a09b1808169f2b88200c3b406026ac078963306909a527b865df51e43bdc73557ef99ab77b90c8d1e08a67ecf30ce5c86fc46cf81b94610966bf8800b0d1fa00ab13c403a5562442d2ac42e8de55605496c5bb791ceca9188719d2446e68e4f5e39f3b36ffdcbb56d1b9cb652775573ecd8c3c3bdb5fbead735d78d29aafb7da9d4bdbd45ba028bb3f9aadbbefbfcfb9be96f6efc7274ff895d5dce26778bb144a51bded63acde72b9846a7bb9962dd3d35c15ddbcd0a75b3bb3db8ebcce7fb3e857732fc8d5ef9321d44081b3d2c586eb21db17dc1c6345bb79bfbad63e61366d95a3365139a1a6cb30b878eb9b6b5dab0dd19abc5b2da88cb43c2d095b5ad4a8bcc66b1d4581cb6464b9745b0edb24d5beeb57dd5f6aced0d9baedce6b37dcfc6e4e75bcb2cc501ab50d9602d533758bb4039375829dee6b55d6f61d4362a1f29a450b3186b7004c211299fbca33bb735f31664a5426a7db6246436596db6597a46d0982d46b3d962b1159a6cc5d86e0c5c716b710955a23015152984e2ca80e2797a007f6e9dfa1ad2212b7dbba085f3a15ea731f7999e34d1b0297c027a59fa3641a5a4140a6571515121fa3684342b524248b35851215fe82d140afb0b1385870a1f2e3c5d9887ab74e129ba1fee1af7103fe42e1c10835cb394ce62c7c4010f5ae79bd32edc3637ef6aa6c07a1a0fd7b9d81bc119f31bf1e352d11d8f5b9de08bc8b513ecaa0d3fa3b481e49b4b880684bc75d6569b60d4e0dadbc740b6b87cb6b2c102222608ba62aed5224087a54cad0b10ada90c22365740caa7f48db94f447682a30f63003fa871580f81cead0228dc2a80b6ad6741d3d64330bbf510cc6c158056661c79b2a3b209c58e4031cea0098286f8ace6c03095a40c62402f581ad71bec0dd41a03c5dc13dcd82ac0ab2b3d87e37afffc6bd4879bd26fca7497de6eacad6d1a68aa1583fbc063cce64b6f537f482b214edc4ae2840e39d11f05bd594d29cdc86a022364cb9414597d812940fda6b8e32e868a33147392fa232aa56d4f3b9c2492e82c8e5624e88d908180d02cf5b563e50e16ce4ef7089a828e3cedaeaa78d54d554cd549ea2e64a2af16f277cb13f243f2bbe4ec6e2868b9c54d7d1b427519be8a0879b05bf00eaf8371e0f16b4ab51eed21ed5d5ad6ab15b4bbb58cd6ec3a49b552b78ba1f90044636216bdd83e7ae6ce0e4318390bd1198405c79ef903c3736721e8b61d144c85165669614d2eaa50099959560cc70a45814b7c3876f3cd2062aa0022463ec8d49e8933d93083c30a0e2a06bb2874ea6472f8b93fcea72fbe7f5b6f8bd331502b444ede7ecb78fc4edee4de40a7b0e0d9e0f9f274fa1fbeffeb1dfe604d4b9b76cdccf5073fdd6910eae97e2c7e1c33ce80d4b74174c6b7e96f0a1bd912634947e936f50efd8ed219fda7d8fb2b1ea95005786a8b7a0735ab9ad5bfacfa9efe0df54fdd67d5bf769f57cfbb35797ab3beaba4ab94b53bcb61ffea150cce0e86c933987e63ed30c8ca41f255380a1750ba63f239adfd24dd43245c9420127d58fba4f69c568eb458b220d7da93d466ead359b9ceff9c9b3f4b4e6af3677140869d2e1f42323641f8bf561215397105f2cb714c26557ce88208bca6302b3939f5b5aedbbabff4db77bff3a5d37bbf4f59ffe6c6f6da66a7a9b6d83cf2fd9e0639bf3f1add7f63efc6cfd0a736362ea0ef1cfbc9e7a8f52fbe4ff91ef5d9eb6b5b4cba78aa3fbdf5da2bf67e72cfa7afc37ffef9fc429a44da35e83e418d94cbe3dc33255d48a556cfd23f167c06643418907a8d4e85507e29e5a168eae13c25abd3180c0a5522efc53c3acf52a0448a84e24505a3301be1c09addf3f1a18a6c4bad70e738003e799c122c0dd81bbe05e64e6173c7de0a61074e00877575aec3b21b5f32e11dde2eeee30df6024adad1d7314d6917bbd65dd7c85c973e5e505fee6ae1d86073c3c6ae675fb954beb1a6b9aa10bfd3ea28d8033e659a5105f2a1b4d0a26095aabc6ab9b3baaacad5a1dd57adbcb67ac6f960f5679dec61d9ad794f543de13a2b3b9b774176214fb9b37aa7739f8be950ea84424b40e73610cfe4014645954857d3d1e7a0f48e52c711702c87c7d6016739d8cb2da7c03e8a281daaa4af3ec658ea795c3740dd0d75b5d9bf7882ef9923a71f5c109b00d10cc31edd88c32ddeb0452f0bd4fa8a4bf30b59555e85acb2640def42d6028b8baa53ba5dc82baf7451a5f93617555c0859adcae3423e16b2dca3fccdf00f9b58ce9e4ff6f77595d99b95bc8a585581115bd89a1c98f9545f5ff4ccadb7fe20dad7d7bee5dca953e7da3f33131d9b99198bce98ee181fbfe3daebae9fa18fb43c343cfecd48e4f1b1e1875a84bbfabff0de7b5ff8c45d3fe9deb7afbb67dfbef9df7ee2965b06855dbbb07fbe09fad80efa2885b8f89e30ac2db356067ea5f985fe43e71f64173517f4179d8ac3cadb359fd37f4d7f467646f3bafe9732a5b6c456d2597a45e9b87ebcfab04c31ab79867f59f363cd3ff13fb2cf69fea851366aba343ba9ab347bab1e303c6a50e890564bf38e1ae2be65351d1ee626e605e655e6d7cc02232f65e20ccd30f98e0e95ccfc1b5b47be96977cf869dd5c2576ed424a27142379a9dc2b17209ecac4b0fab0fc49f939b95c8e4365d6a5870ff49c9d9b9fff39099073f88435bce8d220f061b82b6071d3d2c929bf8053e49eb8eafde56b2ab3c2660ef71ceaf8eaefb74dbd76ffcff6feeba9776ed85cb7c1652aa9723d44c969fbcd833baebbbeef0edab2691da57ce9811bbff14cfab113e9bf7bfeb37efb5af706bdf135eaad3b67fe6a327527f833fefc1d3bcf3e87fcccdbcf201307270672247207fcb30bbf7cb6a9c1676a6a00f059e17eb3bed52740b6c3ffb2ff8c9f9115a9cd0545c566d652546076165598d97caf50dd144038f3e2eb14c29957b0f00041a6479449efe54cbc49309d36298ea023de3b7c77f8bf88bee87dc0f780ff71f4b8f71bbe6ff85f402f78df319d337151df5eff5f01c23dbe07fd5ff67dddff86ef877ed50f8a7e6c7acbfc23df4ffd32b353a3df7445d1ecc21b821e432873edd373b9c72bfcd9395b4929cfdb73ae7d429ea01274829eadaaae71badcb5751eef0b622f1c79420b2f221dbe49eae9cbef8c9864e6c3639c3eb735f319333b9f69cd83839cd7d7e1a37cf8985eed0ff8b06c034d62d93a0825fd966035998d2693b908f93bfd949f0734bf00387e0110fc18c16f2a028422b3cfeb2fa2bcc260c317bd9417e112e27191cfafd49b4a416f266551a030600998691f0cfbada0a6dc4a085d709b50824edf797a77032906c5a25f2cb6884533298e6d6a0be05258b7be31c09a8ca688e95ed371d359d37993c2682a370d996e250d2f997e6052969b02d0803170556102dd7ac8a95ad3ea2167ba7c75abc7d3eaa13db3f476c1c81fb29fb6d3c8ced979bbd7ceda859a06fb2cf54b01ce843c4551f8f047093084c2d8664e2f6c6a0fe805a73b70444f95ea3d7a5a6faeffeed7245f82e3450f1c32f036017794e679389f359bc1a992d2490dce6aa6ccc3970bcdade7cf9fc501134ea6f98d4917fca70888cfa9f0efc0e11b5f3a5c67ca80d25ff8339748132c45ab2e063b860c910c6f3c99cb24e6453a6612dc638e2dad267c99d0d983ad5e013284331339a8d516411364086762139c46bdf8488a70465c4f6f16bb6c1adca5c15d90f94dea7c8020f3e28c6068c9994f8fd1c4edf0b27ff8e89a24e2700d2f7f146110637a11451589f75dc3b227158c83aaecc267a9f4bf76b56e0cae5dd7daf52e5544e5bfd7d5babe811c717f1b6a6d0d6dfdf069c63bff85ec538b32d97a675d23357f3fbd975a5fe75c2fbbf476e6d04b8fce9fc3917de3c24fd90f640670352795103c2ab552272b60ceeb284e5d5a50ca734e5eed29f0f0bcf3adcab79c1f567ee8bc6498e72f95eb7941a50e38897101c00b79fa56523301502cac292b16aab50e65ce839ee7727d1a3f1942d98f7f667cd4541252dda62c5c5382caec6b144a55b55dab2e2a2c2ccd9ba577087a14a71214fd22f50e9c5d2cee8a597a9b6029e5fab85d5c9c4b703fe57ecd2d70ca17388a33bb4247326737f29c62183f2b0503c4db35fc373472ff9c31aa6754829a0b14e227266a7c25c277227c467654e9f21df915a5a84a0759b9a1ac94aad45797a2cc211985860e0a5c8d53ad71aaab1d6c8da6d441a95514d70ceacdf4f27663015f50e690d98dd05b5098edc55600fb0c3a90b5034703de70504300e1a37683f4bc34774b675b1c21a1b5ebdc9607067e917e9faa7ebdffc1ad0e6c118ea76f3ef4f4c39fbdfb7fcb0c174f61cdfa6b9c94faef4f53953edf42636d5de3a5076f7af2c91b0edc7d3744a809d861ee631e4135d4b5df0257ffbc9cca27b79a0a4b838aebe2e827b8270c74a9c0ea4850560b1a412bcb046d7b5950b3242eabe1a5819796e8935dfc246f6e2446d9cffb665acd25218d56996fe06b3d018310ec80cc5e1130e82c9893635e7f80942595a47cd6680e50353af52c6513ec3a3baba8915bcc2aa4e4955e65bf72b732a194dfa5a49470b242c8908fedc450864858ebb7efb627ec72bbd9394b514fdd90797e450ca1977b3f398c6fccad3d64e7077d8839b932e7441c0adbc51af1aa4c949aafe76886a3750e999e3138106780f3368e6da2622102e12bab91c37bb301671c0ea6069c89375a38cd15ac5d9bbd23902b42e62a95f57649fd74f3cdf70523570b2daeca21bbebb14354f9e243caeb483460fed7a1e18d5dfe80bba57b6222fdff327e4ffd56bc5771681fba92ddcdf62205d2a32238bde16fd059875a5107ea433bd02ef2f7ee1974137a5918dd33d13f3474d515d7deb0be393155edde1d29efeed428370b2cf90a002b5fdeec2e2f7737335758035e23c799acbd5dd7249323635b36fd8febd6fa27f7e6170e6ca7e54d1bb7432abbfaca12cb95d7edbdf2cabdd73163652a9db3aeaeb26c0c79de7ea5d1f3cae9570cf9458d1e8f873bfd0af70adc19007a0583b92f824779c492fb47117f19f265f8b00f181d65f8d3e65552b9462a8ba432d3af58565f5e2eef5f5eaf58463f331ff3436f20e0bd1767bfaff7d5fbca31945ee7877fdfacf7f9eae9019ccf5b70037d4b1677fe716fc0ef27c8d4cbb82f7d15ce7f8f91efc510f339c8bc504bbf595f0f272ebf9fba1f80ed98d8f59051cff93d0df39d00dde7f506685e424a2b00f8251ef6c38037500700fe1b965f4a77e2ef855a295143d4ebf4934c947d497693dc223face853d27f5a5235ff39495dbf72d2b856d36a5a4dab6935ada6d5b49a56d36a5a4dab6935ada6d5b49a56d36a5a4dab6969d2ae5d4dab6935ada6d5b49a56d36afaaf4f08a141e65748fa7276da423e3dc890af6d292435867cee4f493f8d32df7cdf45df2ec12ce2e9072558864cf4f725588e2ae90c4d059accd251222f5322c179c82aab9360ad4e2eebca7c533ba55dd32fc114521b87259846acf1a80433a8c278af04b38833667e935d8634c613122c476b8cff578215685d968e1299d6ec90e03ca4339e9160ad8231be8fbfc99f65602e9d9592601655167f406019b4abac5512cca232ab9ec07268975b4312cca212ab8fc00a2c37ebb80483acac7d045642bbc67a588259546e8d13380f1659c270122cca5f8445f98bb0287f1116e52fc2a2fc455894bf088bf2176151fe222cca5f84b53a93f51e02abf0da9d7f2bc1b076e7630456e3cffb3b3f906016399dff44600de6cdb54682811fe74502ebf0d719ba5a249845d5ae0a0273988e84cf113a22fe1a2c435754824186ae1e021b313fae5b2418f871ed237001b41b5d472598456ed7dd042e24f8af4b30c67f8ec066827f518231fe7b042ec63a75574930e8d42dead446743a2ec158a7a2ee4a097e488231bea8eb72ac53f73e09069dba0709ecc4f2711f9160908f7b86c0b584ce13128ce9dc8f61658efc9539f257e6ac4b99b32e4d0ebe26075f93a3174d462f47118ffcc88b7c681d4043680f8a42d983e268125e53e8204a909636f2ed12099287a13d4630eaa027882620f16800dac661fc144a915a14ca28f99dc6288a104c2da44ea88d406b14cd404b1fa13e09f366e6e906ea0781f634d0e1816e1c68c6d028c0a30027a02f999d87cf72ef45f50055666beb909bf01026bf51b807e04ef27b9e98c628da27e176416d0fb4e2de69e031955dd310f9dded14e160257ec6882c78b409ea23d0835bc344124bd728d2894b2be5c92cd3d03b4ad68b6b63407b06c62649cb34604588e47868cfe823043c61e9c4c8b84922db0d647c946044d17e98334a7eb311e7bcc451069727ed2968c1f24b6435b8b80edc3f055cc460640aa4d026f1199378e95db29e30e10edb4284cc8db9df47d639f617d9d172cca615e7c7bf303a4156580da3626445f1ac1cf12f0d62fc54767d6b817a23d8c5527a22b57e34886ab3147b80efff5a7f5091d7aa4ffc77f1894ef29ec330f96d541e6d25bd53f853d2d072b92d624ea6816e82cc2b72304666982212dd4956cd13ef394856297235959574061bb7c589beb13cb0bd45893623042f2169c44dfc7292cc93206b12c78e4a54a2523d4c682708d7fb016b8af4e15123848f8c84974b6b4a1a21ea2e7959cb58760dee6c7d515b974b2741ea1118330a75b7a439ec21e2bceeec3ccb5710235a9a21721a25b6fc51329b91561a23563e41ec39e37bcb658fc74c10a81af06b9658cf47531779f84b659b6b9b98d238b42589354e11cd8d66adf1a3569099fd72be36e4d8005e89b89629325f265a25893d1f24f683ed7992f87078c5958ab6175e6255a22fc6a55c5c9508e3a890906203e636a3cd0c1d8c8923d0c7d9a818472725cd2c52cf78484c927292442b1c6b62929cebc8292313b7c748649f20abcc4879a955bb8966c2048e487670798c59ee09d524d6e2753691dfb98e921889e7d84722499468350c6d5842e38091e9f34834772d8b5b3592f72e468b545662196efe9c9de14f8cc4bc75198dee0c0dde96b5e6bdd026ea29633551b28b4d48117cd1ba3f6e77c958e5ca3b0cd65c7fd67352397bb8a86fd10aa2d25ce3c4962725bdbbc99a9352e417630f8e0c61227f51cf193b16ed2a219d13c419e240558cf493594b09a3c51d76793cfb4fd045564261b2762cb79814eb2392af8e02f5fd928f2c9e3af00c31b20ba5886d4a3caeac5b800797eeb1a0ed9a1c1945c82e33b124ce5cbec68fa147a26f8c8ccb607f7474732f8b6e19d92f1f8da526c6d3dc7567f85a3cff2c7acde24e94d1a19bc4fb3899652c5b8fe658088e5ba28652406d718715b91e21bc44a59d6a3aabcbdc5822ead023693c45bc6422cb43c6af97dad29f2ed5dc1d5e5c65ee4eb3d4a617253143e4b8ff2fd4636637c0e7b3494932d11c0e2224c7732eca652f608ce6ec1d531f138fc5c81f212bc8ec784d4ba2781828c649c4f9e813af7832cfec328bf2c9ec648b32ca8d294b47a548ac10753522adfba3f7dcf00a1a4d66579f22563a49a88b5e24eebcb93bfa5f6a0199fdad13b593de3eb4056a3bc87748e29610b4f1104507a0673bd436935f6de75115600c4afd5544533bc83ed40978dbc81e27d21880bc977c73234f68f3a48e6b5b01bf1768e1b1ede80a32473b501b24980384760fb47643d92ee1e1116dd0b20dea18ee2051509caf174689e7f790b4278a9ce26f3ae3b32b5cca5588cc98e1ac076a0340bf53eac5bf641f22f430ff78fe2d04eecdf2b945e23448648429639a6dc05137a9e1d66de4776cfb00bf5d5afd6689db5eb2862dd02faea59d708067ae93d62ae261f96c977ab08e307fdd901657152432e824dc2ccaaf0dca7ee01cd3ef80de21b243f4c1c8cd64a583447aed92ccf06abb496d7155a2a6dac86ab054b10c3603dc03af8eacec06482ef23290436da9ec7690fe452c717d41296f2392eb2335511b6da4364474857bdd922e07c83a96cfba8358623bc10a92150f662d640bb15e91fb8c758a73f4e57022ce87759bcb4bc6aaf98ff111914aa67f9ba4e9cbe582a51e2432c17c0d66675e8932f8e651deeff5ade387f644f99ef8647cea6022cab7c5938978323c158b4fd6f1c189097e2036be672ac50f4453d1e435d1481dafd576464792d119be2f119d1cc263bac307e3d353fc447c3c36ca8fc6130793780c8fc97bebf94a5cac73f303e189c41ebe333c391a1fdd07ad5df13d937ce7742485671ada134bf113b974c6e2497e536c6422361a9ee0a51901270e93f2a9f87472340ac5d8d44c3819e5a72723d1243f85d7111ae2bb63a3d1c95474039f8a46f9e8fe916824128df013622b1f89a64693b1045e209923129d0ac72652756d403306547ac579c2fc54321c89ee0f27f7f1f1b1956594696cca1dbf293e11e1ab7b62a3c938e6b1667b3499c2f3adad6bf44b7880d63f588b117b863ae3b08a08bf353a3535114d6687f1a9e944622206bc8fc527a7eaf89df1697e7ff8203f0dab98c2f2c2cdfc549c1f4d46c35351371f89a5122043371f9e8cf089640c7a4701250a6538c527a2c9fdb1a92920377290c82a239129e800c12633c0189ec18d4b22d12c3b89643c323d3ae5e6b125c058371e93992036c9cfec898deec9e16c06268d4d8e4e4c47b0d964b88f4f4e1ce4ab6335a26672d081c2c7712b2a323639ce27a3a9a9646c148b7f71023c3c4b6b039140750c66998aeec7ba4ac660d6487c6672221e8e2c955e581415a80e961387a9209f9e4a802146a2789918674f7422b154a2e01c93072574ac102008f2d9131b8901cf755a2d3698b1f8c4447c06b32c89dacd8f8453c06b7c326bac192554ef999a4a34793cd1c9ba99d8be58221a8985ebe2c9710fae7900739764d635a05e621629cc1826f3d17ef851fef37d09a31b63bc86c5bc370e6bc2a2895e139d00df22e25eeaa958944b7c55abedc7ca49119386758308a2306a3c1906c944dcfc5812fc0eac67744f38390e6bc6320659814661381f1f017f9bc44209935891b1b33f7d1598a1702a151f8d85b17d44e2a3d3fb412361d1a5631320996a4c71c96af9412958bc5643388a4481604cd4c347e2f133b1a93db839c7dcdc92b961ee33dd1331b053716e4c2b29864b988138115ea19bdf1f8fc4c670192502494cc382527b88c302e99169ecbc29dc285909acd0030b4f4521fe0205ac6b494a1fc9aae8f030a5e83492a40913337be2fb3f668dd80da69393c04c941088c421a8125ef64647a73206b668c760fc911871bc26d1c4c323f16ba239311f82217619c20f76b2c4a2a5485da93d6158d5487489e78673169ac4d3a7a6c09862a022705ed1d13f4e00d8df3adbf9c1be2d433b8203ed7c6890ef1fe8db1edadcbe99af0a0e42bdcacdef080d75f66d1be2016320d83bb493efdbc2077b77f25b43bd9bdd7cfb15fd03ed83837cdf001feae9ef0eb5435ba8b7ad7bdbe6506f07bf09c6f5f6c1d612024f04a2437d3c9e5022156a1fc4c47ada07da3aa11adc14ea0e0ded74f35b4243bd98e616201ae4fb830343a1b66dddc101be7fdb407fdf603b4cbf19c8f6867ab70cc02ced3dedbd4375302bb4f1eddba1c20f7606bbbbc954c16dc0fd00e1afadaf7fe740a8a37388efecebdedc0e8d9bda81b3e0a6ee76712a58545b7730d4e3e637077b821ded64541f5019206812773b3adb4913cc1784ff6d43a1be5ebc8cb6bedea101a8ba61950343d9a13b4283ed6e3e38101ac402d932d007e4b13861441f2102e37adb452a58d4fc128d000aae6f1b6c5fe465737bb01b680de2c1b9c875da15ff9c82cb7172b5c0979695b0a6d034a585abcb072b628c914bd24abd5ba447e52bf433b733cf312f312f40fed4ea83f4d507e97f866c571fa4ffe73d4817ff3cb9fa30fdbfe7c374517bab0fd4571fa8af3e505f7da0be3c9aaf3e545ffa503d239dd507ebab0fd6571facff7ff7601d7cf33fbac1c63ef6068b4f88381a5d43ce5f709f5d11b3839c835264af9922f176e55bed071089f6a10b40f503e859096f3ba1b4526f278967d7901bf4ca58fd247e25492c1423dec13f49222b72cf96b21bd90d6c1bbb965dcf0a6c0bbb956d5c91e2d07f78ffdf8a5741f90067650c1c6b1320af1579a20ce8678c03769595b518976e03e26713104a3bc82f8251e8f27f99b66afc4981c8c4e4b80417a6447823bcca82c9fd936ebeed6072c2cd7724a3fbdc7c77786a32980c8fb8f9cbfbf0f35211e3df01bdda00230d0a656e6473747265616d0d0a656e646f626a0d0a313637342030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e677468203232343e3e0d0a73747265616d0d0a789c5d90c16ac3300c86ef7e0a1ddb4371d25d43606b19e4b06e2cdb0338b6921916d928ce216f3fd90b1d4c6083fcff9ff82d7de9ae1df904fa8d83ed31c1e8c9312e61658b30e0e449d515386fd3de95dbce262a2d70bf2d09e78ec6a09a06f4bb884be20d0e8f2e0c7854fa951db2a7090e9f975efa7e8df11b67a404956a5b7038caa017136f6646d0053b754e749fb693307f8e8f2d229c4b5fff86b1c1e1128d453634a16a2aa9169a67a95621b97ffa4e0da3fd329cdd4fb5b8cf55fd50dcfb7be6f2f7eea1ecca2c79ca0e4a901cc113ded71443cc543e3f09496f2b0d0a656e6473747265616d0d0a656e646f626a0d0a313637352030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e6774682031323833312f4c656e677468312034373030343e3e0d0a73747265616d0d0a789cec7c0b7854d5b5ffdae73573e6fd9ec94c9233939949422661f27e90c01cf2424880188226402021090450088208141a5a153460e56a6badad16ac7fdbdbeb6392f880aad7586d7ddc5b85d2d2fad66aad52517b4bbdfd0b39f35ffbcc2482f55ffbefd7efdfef7edfac99bdcfdaefbdd75e7baddf3ec9374000c08411073d8b97444b5fded879030019c4dc9ebecb7b87e62eb8b908a0be1ff35c7ddbb6fa1f39f4bd76808befc106da35436b2f5f3bd2763f40c32e008d6fed653bd6e41cb4fc0960e90300f98d8303bdfd1fdd70d3bbd8d7fb182a0731c341322ec1be42980e0d5ebe75bbbbcbfe0ea69f01906fbb6c535fefaa5deb8a0176ff1920e799cb7bb70fb96ed28a587e11d6f75f3eb0b577ec3b13dd000fd3f6db37f65e3e60ebccfb6f80431300aec6a14d5bb626b6c0b358ced1fa43570c0cdd79ad290b60c1ad383f07d0b56a00e6e530b7ac32d7fd097c5aa074dfcfdfd84e9f27f70d367fb2e1dcddd69bb47bb1ae080c2409db6989d20560fdf5271b3e9965bd49ede93c329da239d63ed8031688008b2d2d20c35294d2031a1fa608b09c81791478d0f2b7f165d86538f9640fc1b3cca81618bd9663798e63b837616662027a9663b73368df0b97f8fd809fb382908d73a8d512f27d3f21097f3ef6dec71fa72b058f363525a63315fe1d6e654fc130cde33dd0333553a61cae82cf21760b6ca44fee0ed886f5177d5e9dcf12f32e3cf94575f84ba1e182f4c7c934fb1aac9ccae3be0eb769c270db749dfaf3782bcc9fe6d7243e529f3b1367feda98dc4a62e29e8352de047bb96a28e745a8e426a09c358393f2bc047b99f5b04badfb7395dfab390c7b693ef7915a7f2fadc76ec77436d4b24bb09d04bbb9c3a9fe4f26ce7dd1baff5f89ce8f86bfa9ee477f5bbd2fec672559fa8fe8e71f45bce7ef932bbf01f7672738ffd1f3a17ac1ad84917f74bf694a539ad294a634a5294d694a539ad294a634a5294d694a539ad294a634a5294d694a539ad294a634a5294d694a539ad294a634fd4f24ee0958f3cf9e439ad2f43f91c86d5f5c274d694a539ad294a634a5294d694a539ad2f4ff8ff833e0d4b66158054e21064e4d3fd4feb3e794a634a5294dff0422c0aa3f5060008ee8f0390bfcc08117722004795004c598d300f3603e2c84365802974027ac836db01d0ec1bdf000bc07674809f353bfe8b787fff3ac904800fdd58364dbe874dbd6e9b63db061baedbb17b4854422f1d6177efaf0f32240625fe22ec5f2fbcd6fdcf1f6ebea2afe56b25d90a23f33b119864c6fc3e33061faade91dd3ef4cef02c8733b5a5b2eaaab9d55535d5559515e565a521c9d5954182998919f971b0e0573027e293b2bd3e7cdf0b85d4e87dd66b5984d46835e276a3502cfb10c814212f734748e666822be4020d055944a7b2f4cc7d9b0e5bf0271b05d50c9f79946999f49677d269d3d9d5e140747bc39d8d0483b1e85e677e2608f13471ce828c4be10474a356aea5f1f6c5a17cf68e8efe9c1168d418b3fdefc51343515b5ef51bdae21d830a02b2a84519d1e593d725877689434cf212ac33437cd1a65406b2c2a8cdb227126dc44c3fab8bcbf07996023f68425f64f4b8e24260e9c5f04d86c8ab3273912171ae21a755cffbab8dc1b87fdfed1c2899103472cb0ba2762e80ff6f7ae40c9f5e21c47810d370d76503936d1d033e88f73d8b91af930c7df34e81f095271340df6601c6cc4569f9b8fd9ae86ce7d81095fdc86cfa6b835129f8735e6ed7cdbc78e3479d6f9697264649f3f7ee8e2cef34b0334eeeaeaf2e084479a82d82176d6b4be1e97e289161526d79412407fcf7a3ae6fa5e3acfa6f5fe91fd03ea5c0fa87350ab360de2c6f47e51ad9191a6fe60537f6f7f7db2f786b8dca13ea06359a7ba40145d63572a2b55014b38b5a4a7b12b9014764b7b67039d58b0b7d197dcf6e99c9e540e66344d15fae90ce66307717f9f3f0eed9d41ac5a4da3816a18e9ab569527d045b055dba7ade27cd812f48ffc09e2a42778fafd0b737a533942d8f227a06c73b0b96764a439e86f1ee919e93d92d8b33ae8b70447465b5a46869a7a70d4b64e6c7524f1a3fdbe78f381aeb8a56790cc42d9530d686eef8cf902d6aea964db541250a550b1f4ea72500af89d9f7aa094a1a333e047412dedecf2a19c3a29df817cf249150915b71af73825362aa381ea69f134a4d840806ae7fe2332acc6447ccfc59dc9b41f56fbc6408e46703f7a68c9c4548973292dd9335532ddbc2788a33ca0da35675c9b3bfd355b5cf6a6c15971e2fa2bc503c9f2b8bda193f5315d498ef1b194d345f0a4d7c5dd11e4f32323b809c782714b24ce774ef8eabafc162b5a00ba7b4b822d172febf4378d4c6b413227b552aa07a8eac1dec191d451a24afff9b92d4ba6044e35168ff47e94f89ed5eb5169f0db7b809a9fc08825defc71c01718b1066dfe9a685752ab2dc782cf12345c68d62c7152a72e8ba8360d479a1f67ddd558f8d9b9c599868ecef3b3a62c1a16b47d6e019ab0fad120b9eee251995cb76459e7510b3ab1eb3a3ac718c234f4d4778d86b0acf3a81f3d839acbd05c9a49137e9a80167a6ec618ad5adf775406d8a396726a869aee3b4240cdd34ee511e83bc224f32cc98172d5816460b0844b96c853b539ccd326f3f6a8792a8d025daeace365ad2cca06c6c8f84609cd1ac39c1fa1868804c60dc4487ca3d8aa5dcd3e42f68c8ab22f59630fd6909333bc6ee9a7432f5dd6396e006ca6c638503da52218ed5835d78d0e0e7b2693185b3096311cc4c0428cfc0956a9e1633886814b4c90c898c158791499c2b1f08c14e308249971d152291f21f9635eaf9a913f6e34d28cf07873b3fa1c93fc6a4178cc9799629cae1463b6a6189d416572c6f2f2524c76769219d7e9683739e306037d06c6dd19f4c98eb9dd6a05762c830efc63e21ccb96528ccea132f6316c7b34f104718d2d599a62162d4e314d4d29a6a121c5cc989164c643b97404d75846863a826bcce54a31566b8a1193f2c8182b294932e38585b451c6981448956465a798d4446de3d80d56b18d7992fddac6162d4a314df3524c3837c5a446b24d495e1ad3eb538c712a2755471ab3db534c6aa2922a469247c858a984430a63369b5ac08ce527f78f8ce7cda09361c67176f82453b30c8d793c29c66ca97c8c98080f5690502efcb851dd696e1cc7a5cf3151a7d6e4a604c58dd5cd4e310b162499f14bbb68dde898a85785ab1d13bd2a238ec90d29466d449999c52926af20c5e484528c77aa95c3a9328eb15028c5e4e625997183bdd23cd744ca5085cb507dcb5099256205422cc40ce5c89bc7b836894e0b6449efa94cbc2749a77eef958a7f4fde7378a50fdfb7481f60808fe58f19f459b2e763bda1f263e2954ebfaf972c1fddf81123bf3ff4fee3efb3e849c63fb1382af12977fd6f9ba3f277ef78a5772abc52fc4572e84572f04572ec4532f122c164fc043974821c3c418e9d2013276832f66b72fc5731e9e4afbcd29e5f925fe2a3e75743bf629e7bb6407aeed99aeae788fe99c66798f82b047b7fe8153c5c433fa7ac7cedcf75f6cad0818e035b0f5c73e0ae03f1034f1dd0c84f92aaa356691d8627303c8ee1df313c86e1510c8f5c62957e74d4273d88fc4347bdd2c3188e60388a53ad8b59a5d918e66068c4d080a13ee694e66290918f5558a5d232875456e1902aca1d52393e0f55a8330954e8511136cf9a55f9fa66226f16ed95370ec58798d7371179130ae3d846b5966b239dfb9a836be26b5879ad68aefcee0089f7ab45b5fdd4661c22fe6fc4bfc1c46e22ab6e1cbe91f1df307103e3df206f606090a8dfb6c19e4176b897142f97970f2fdfb39cabfe8e55a2edfff81d03b6ff0991c7c9286e5cdce194ee7758a5fb30dc8be11e875efa378749fa21864881551a2a20854526a9c86194eef0374892235b42a820f91d75d203de90f45def80e4f3964ac3de1bbd8cd791233d6dbf48723aa292dde1978a6db2adcd76d0c60dd9f6d88ed9589bc32359318083b4397a1c430eb6d84440206682df2889914d6498dc4f1e272f900f4982e8cc80ba1785186c8261b81fef282fc08790009d4eac92cc8c99655e605e60134c82e5688ea82d9038be4062d85cc960ace1b91a96a92150d3c69323d85bdcd6022d1df5713bc1e792fa515769a425dedf5e7fed0d3764c56fa1a8684f56173a981684d3e873bfd615d752cfadb21049d196adf8ddb235ce36c585a6c1deb8106cdc4213269a30d184a9296ea60973b091c41d4d837107e66e8d44b65e49db5f1999eee9536e0b0d5bb05f95687a0b56bc9246705ebdbfa42d5b08966f01b587c854375bb7266342aba86591a980d3f86bfdfd1d44a71d11b20507ff117f9cdbcbf5b10f03a287c46f12af2adb957ea58bfd3678d0555e427ac87ab28d7c75fae2bd92ac5599bb482fd9402efcedbf56781077fb25780bfe309d97201cdaa20ce47e4becb05b6d7d025e83d7e10c9c253cb1122f097ee1fdf736b82fc59d2447188dcae9e000f35d789a28587a1bded81b7036a7985decb52c2ddf0bbbd1fefd5dbf6bc71a991bc90ae62a38440e330d4c27f32af3c3f3cb89165a71ed57909bfeb22d711109cfc42cd24cdac96a32423e64cac85c780ffe089328093b91e047f00abc0def13866889832c20d7330b99b34421eb8511decafdd705bdad2317e1da2e235bc82019848f29af4ae3eb186f040378419a1e37024fe05e951003bb9a19635bd99dec7ff13a760c803f0e5ec1c29c61d6e0691c869bf1d30578d9811eb81abe023f43f97f44cec10c558eb7638d0df8799debe376b04f9331580397c01a7c9e8065e420f4c1f5b8be852483f90f70c038f35b380c2f9215ec5cb899dd41107fa04dd884f3f93ab67a05c6e146eef8dfb30769fa4712f7922653f33edc0bd761f82179987b88ff25fc1eee8617e172f80930c91f321550f5f191259b0586030cc520431be645bb7ff6eacf208a514971c01ab086314207009fece1e12c7d023288c06fc52817b58df61295b318866585095eeb1763e26291c56c6e9405dec2fb79968f76974d9646a3dd103b1dab8996141336c012ec97c99da13c35831c50b69111fef8d957b8d027513c70d8fb30fb34bb5e70a8bd37c8f98c20808658c4a838847de31a2d60e138b82fcac6d855ec267698e55996bb4f43818b68add24423a7cba2dda7bb71c4b2b268191d31a87ed8f575cfd7adc2203826c7998534e0183dca37b9e7847c884029d420e28050e21ab9d86ca9321dc4881490525b81ad3458102c8db98b0bca2272e9c28a1596766f5b788d776de0aac095a5bbcaed81238937e452d154a5f7635425645b41b4887eb14d8c8b13a220e665678b45abb248568e2c5aaa720c869c2c36a34c02eaf0ada2b10aa0d65c2bd532c5d29e0c924157a2b7546544239b4f775bcb704136774d341a4151525952818e0aeab5ca5669cb2fe424b128ef8859225295f58808d1c9ba68f7649d15dbf8e4e6b6c255951b6cabf357175e5eb9357fa870b852ccb015e65782204a45c168562c6b71169b95991564535d98359266936658c369da8cc4681434acdae969370a35da8da327b952da7f7757497124d28d9e8c38048d2068ac416b6e28cf5ae672b9ad79b9b9f8ad28afacaa2873d28c206638dd2e17a91004a7c345ca73f3ac9595dc73cd73620f5d71d765ca9f17fa8b3fd9d5b5f0407555ecec1b772d7b6f8e7ffe3d9b3b8f3d33b9bbbabd987c69dea2d825e4de8e5baa6b5a04e5163240caf3488e74314f9c2e7b6574e6d56b6f39e17aef776cd4a7bc51542e28f6a27b099ce2ab2b22d54aa054362740a8c50be15568eb1e53b52b249b51738985c7536141bdbb4fc5bea2a18a4589abea134d2a0f796c5a69e8bbdc8d8c802a97893d64c9227982594c2f9b0c6dab335731d1088a07e5854d51cb597e721df34d46202eda729bf228fb8e3a764c76d7b08445fc5ecdb00e9c064e043ca81bd8cfbb0fe233d523ea86da23228518ce661f3f33b26ff753a49b900061df99bc5f7993592438fefc030dfde95e589478937b8eff10dc10848be40cdfd159b605b61d08ec98c0d10aa149d826b0822e1850d5cea4aa5dd81c96c24c76c0400733daaa0c74e9aaca41acfb347e71190e06b7369883bbc95494dbaa2a2bcb4a5d6e978db7e4067304abc555568a9b38a7b1f1a53b6e7fa9a971ceec79cdafdc7af8574d8db395eb975fb661c58a0d1b5630ef3da1bcd6dbdbd7d7b79a48133f259e81bede81fed5ca1b8f10c7ebaf2ba7948fde7a0be7ff242e22ccf5a9273f5fce204f32bcf024afa52709b1405c0044187ec212f508a816252566fa61c2ca1d64350dcc4be4fab3b793eb51e20d89b77827ff0114c19d7280d3e90a1c3a5fc16c4f49e6428f9cd9e9ba347b07b755bf6b86313868b2e0e9495c336e52f7e0215944f9700b30caa2d22a44c62d631435faf31835da448f87a362a74004a6278fe4e5f92baec41175c67cdac0269aabf2f3a3e6a81c5d1565bd4e76cd4ccb99a468eba8685149927177373d4394ba793f582d10a0d24d1d975c2a628d7a5c300f058dd2af2ab30a348fcd5446d178ee278bbbbe36b76c7b38d7d75e5ebebbf1e27db3abe72da89b75e3bc057b6796b666e6ccb8aca6796716f906a2f7d5e47f396ce672bb72bba7c1ef2f2a8bd5fcf89afd8fcdaa2e2dc996e40ce54e7b89d5e952a5f626bf0da516826fca399cdea9aff12cf0b459bb5c4b32d7f2eb343d96b5d6217eb766c8b2c336e4b3f074bd545c1a2a2edf91c43d721d1557074639154341120c8a6cd4b8c9386cc4872a3491c92a6775c660503006ec00b9722e29c688f13a853561cbc778fa5050a7cb6c68f5d45da672b2628aeaa32aaab0c005a7a575a1a82c1c9513d5087edb6ae5e95b95c3ca2a7298ac7fe4d4ee1cdf4071f5cded3d77cca96d22c25b8e4a87f23ab37f697e2b4a672b22debbe7cd56bee75ce8f3cfac9b537764a772f6cf0c4342c44dcfee4a749a7bd0e7e941961d225726b03ab68c68b5fa653a07cb33cba8f1902db86496351accc662a36c1c3272eaac23674a2d93674a2136598a5f74ad016b195aca00863276cfb9d74e9e64734e9e241cfb2ce19473e7aa70b4dbd0cfedc2d17898f110c37215e8199387965a068d59433807e917a8a4a8465119a9dde287db752e9b6c632e439fda02c99e84fdd89301fe28b7e3ad8c071dbb9859cc3334ba42773f733f7f4827b4b32bb855fa1e7613b75eb7493fc40e733b75c37abd5e27ea7dba0c7da1be989dcdd5e866eb657631b7589caf33ea649385b45223f50065f8294697f2695826d3985763ccbd4faec3b3c56fa7078c46bc8e61451de7e5a25c8c93b91e6e88d3709c462fb244a315757a14aa03064c66936c6a33b1b4ff8771f5bc4dd36fc47547ba31b2ba6b205617aba39a81ee88dea7924709ad021af0eeeecd28131224542e683185fdca01e50f09e50fca21bcc62e20f3c9fdeccb935733bbcf85f9e39301e6756a43515ebc03e56587302c92fd157c45b0896f0a5ec96fcb11322b743a83afc2c81ab497c25a601cce9407b7e2aee499f3e43cc6a77318fa732d1fa37d52cd285aa9d8699c1f2a6e77ca49a231a59b9f3ce77cb9aabaa809c9c35d59c93beae7e42eafaafa4adb53ca0853ff95475a3b56287bea0a2a7a9754782b5606b31b6cb93ef6ece0a3b1bc7ab7dbab64f0c7a365d58f8cc4965bdd1aa59e11f82c5bb80d777e7ee2b7dcfbfcfb50062f1c0529b1426ea752bf8b46569d5317e1a34eabd7e98d38a31542cc526babf1544ab3fc6588712a4b9b84c59616db7c4fb3b4c0df50d010692e5d66586e59eeea28e828beccbea6e84bd6ad91adc5a14c8a7b665227e51775557e9ef8f9683623ba893bbfc4c481373b3ba7dccb0cf184e7b5e5a0cbce36394b92e724b3aaa4a482e3f29d07dd7137e356dd8fa5ca1d8d50a3a84aae8c1e7d6a266906eeeee6a4a5a46883cf514106979459852a42156ba039e0547370bed9c4afd301cc9a7f532637e50c11d3b07f9d3fafb27376ebbd2df7de823651bc966806034b3efc72c9a248b0ece2ad2dfb177ffb9bcaf77cf52564f5aa3526b375766975b3c511f2ce7efedbc7095b3953b967de6a93c312cbab69f059fd99d58f7dfb3505af7384feca3cdacde38894ffe528f0b8ce4b443bb472a84f3222618e176c588be7ece8ed81670a9830322ca3cd27794c039e178e21ac0e78d60b4e360221b616cad956686057c012f632e86377c116d6721077968ad0a09a02ad59bb4acbb05155d9d046d6d45085ebb6d5d4e011d867999cc0a09d806e8850c4808780dfa680b25301720d69248dfcf14fa2fcf17366f60f38fb3338fbbdaa85fbe4286813277197ec38ab5c359633565569e9b80b90b98869d6ced3b15aad862e8a13d14aea757aa039a21ef43ad020a2e1059e1388a863d9a739d1c17122018de669010f8140b43a6038e148e2cfb26432410ba74dc60242228dc809ba62ba381a619d63e3f8e4f0893ec652a5d34d0920690b8d66a3df8857042e5a961202054b91888d9a865824e2ae99464dfb667ad487d6f294f67362e8a6ed02d450a4befc5e6591f21be5156535794b2926a3c480b7deef2a45e46525cc7cc0bca5c4c813938588e14c7803c9170e206ec9390a4c62e221546594099de6832615cb45a995a6116e4b9004d8fc0f945f90169e45908236a734f11b6e217735dae822d8253b98027bc1327e59c67a7e7dc656ed1539571688b94712271f34e07da42e93aebdca60accaccb4e74ba16868387463880b85fcb17cae48ab8bd9755950e42ddc84d083b82ca2be4a4578e1b0c6eb1a9a893613c5446de7646929f51aea09537d14f5acdd149a27cf0d1e2d77d256e5a818be325485e78c1eab2082f6323fe744c4f587ae8d1533cb962e99d99317aa298e76b57de327fd2b5711edadd75f3fe7eec5d9e5ef6e23394454ee22e153a2d16e995bb9b8b6e0baec628fdbf3ccadbb6f2b9a19d209ddf38a82c46c9ef1c44f273994c4dec429ee0422640364e1dd2f5ace971bca4d0d7c83a1c1b484bf24734de6b076d8a667eb7d9c8b38b53ad9a2039f71b3e4d1d8bdce8dd9eab2708deaca62aac94dced9aa82a7b005288cd5503f4951ac8dbd7ccdfa687751705e70783759a37cf46cc7ae66b3324a562e3cb4eea95f32b37e70303b7bf23f4dba1fdcaf9c511ecccdafc64bc04bf5edcaf3a882e5b8671eeeab500003b27b863d14a8b597051ad9c5624b46934f9b57802a60a2d6d18c8c057d6595c5e2960d5c886e9f1e93a150960ca2399916fd982ef4fa84a108a244aac665aaf18ba8916af6f89ca9eb5412807f0a7a92bb751e3264eeddffbba51d2bd75cdaf1d697ba7fb4b2c8393b94db53bbf7e6dbbf5adf1f0a96da8ab217cf28ebca6e9e3fffd55b0eff667e734324aafcc251ec70663d72c7bfde9ded7416d9945f1873f42633ee4825de29aec61d71e19da2412eaa35d666b51a5bb386ec7cb0001592a591137c73ad1cd106eab53a879b78615338dba71f0ae1565826a7352da6ae2310a848e91563fd743101623d6f2ddcd5ca9d3997060ada6b26de686d987d5f6fe7e616b252b9d3db91fde5e181cd33575e99295b1c0e3287e86efe75dbfca5e13cf2dad91c26cf688ddf71f7d743386bba3b37717b211bbdf85a391836961be7328bb9b9c625a12dcc4ea7d64ba71daed3eb21678ec01df2100ff540b82df42967e0b1f178acb83f19199257b7195d3b09ebbdec50d2b1e316a59c13ae67cabb4fc3778c9d01d75fe2757bd22b313f517eacdc4bea482661083749f8ea9945dbe7cdde561299ef0e47e6cda9d991c5f6f6afd922649362928106e722bc1e4d7e79d13a49f2f95cf642abf2ba35cb6cb6326f6cdaba731d45784e44a61d423678a04bae43dc283b416f8a69adbc516b06b35702bf582ccaa2208a60d26ac16c96cc51336bb69a81d57bc16431f94d874c71136f9abedb4755ac8df6b34c45acf41a9cf4a94e67c0494f4fb0a20c3591ee1cdbe1732ccd5dbf90b8948f953b0f1cf8f5cbadd714f306c1be688378e6dcbfb09bce48cf3faf17a995ab54bab8abf1c498a10686e48beb841641b6378486981d593bb3872ab533e89e780c6e4f95879e1e334dd6f0dcdc72ce581fd158bc7e6fb177c87bcccb7bbd81b92ebcbde67b2d9b6af19a9891a1f1cd1c9a95346e53a64d450e29a5a3a8615abf921bc33b52c62df9b6626ab32a2a3ea399550136ec6dcdfdf2b0dd9b71712cba9cec5bb668d14bd70e3dbb6086775e28d21ee9ba2a3bdb53fbedf6974ecf9f3b27beea92ebaa8d6409a28a4983e57b37cd1fc8cbcdf33ff99d9766cfa9cab2930c9d47a737857382ab2e7296c7500372aef9f982790b0bc3a5741ff7e2dedda99eb41a39c438ec8e725d936ec8c95b8cda463b6722c4a8a547cbd3e32116bdd7b8d19d54466aeeea549089f60ef16ef9d45dc83a65e75c4eee4ee590de6c6bac8974962a779295977cafef9e8798a2c67dfedc803f78ee6db46b27e6b7bff83ceed22e9cca07a9b76fb5b24390712b847a9e6778a2e5becbaf022f497a5f531521a2966a569bc8a67cc899d35469a2a723c9db4815c5dd6fd30175cad7c8155cdf21629d5ae9291c430fff2a07b40cafe335884cb4217db9be51dfae5fa3dfa617f44c8f6e48c7e874aab3b74f397b09ef55ac96f5f21b0dd3201bb75ac53d2805043ec9576314c1bc3126daab00e7e2930be89b9e7cec0425a807ad572462be18aa121f60199d5e27e81dfae4e04bf502f51afb2c13dc04ffa7c815dc04455111ed44170283a444111870a7941ee558255d186925b72b5791f7e62b3d82e3dcade4612533b542f2b62ac5bc871882b7b7f3a5c673c50808dbf829a9a1cc92f24aca0a9b257bd084f0b44460b51c15fc429ed3efcce334f6465f200406de93cd65f01e6dc40bbd01b7de6bf0b9bd9ede3d86b8e19881354c5d450d86a2424b51b4482eea294a5d45bbcf4c965a4e5b6bd49d8a214aa217d2ee0bb5e6020d7226cf41eaad8fcb69e59f12cce6584dfea299ca210d72d591f63c55a76e5db5f63b3306c6572cda15894699922557844281a0ffdcdb4c49fb1664f37de7dee6fa76cd6f5fddbb72a0b4b4f21bdb27c3535a8febfcbf683dfff768bdf36fd37a7536a8f4aabf78957b14fd851ebd5c5876da6491cb9659bcecc1e6702c4c3ce899a937a3a67feab553d2d4ab3129fffc5735dca3ca71e5f7ca69e505528296dc418a956f05b2a445a5d1567f7628c797d9515670a957f2332558eb0912234ee221b395279477fbafcd2f0864cdc8bb6eeddae1dcbc502814d941d191d2cf9d405959101d5d22db2a48451682f8aca5e63ef36e7e7786d68580631cad262ac029391b19bdc03aea4d9cc8fbe6b2a2d660c5e5487ab7c6ab45ac74660a2ba9ce59bd31503b99c448d352b45d80a0b813ca87cf2048a2d2448cf4e449e5b6810d88a0321b66eed9c5cc55fea83c949baf14f2892b11253da77c70d7d71140fd8741f7fda4fdef57ed3f45122d72e9a748624750402c61ae62fd18b9f0daaf55e18401e184e8703317c08933d37002679c44142460fd4b4451f5978822dc162a5a107bfc4d15512cf95223dae9f32085d2cfe8b26b2c4eeb34aa28c82b3d77e2535091d455763bb7163d6edf8306112f73dcd44d8c6bb4a11513b5e7bd0f709bdd929b3168bce246d7b4a9a2876e32a23ad8293b65484c4cdba9a360a2564b5f850beb4af9dc298d4e2d8cdd9ee5689d59b5a386ee8167693077a0c85a60653d1a8ddf3569e1fa0ebb1a1cee00c3d0f9d626de642751e23570bbec353ba154725a4a6739cb4a1b4b079cebbd3bbd5754df2d19240a5383061b5ee20dd6aa808cc3bb23a6720eb2360586034c20901fcbe20e71844b412475d166acc571fa18887ebfdbe42ba7790ed155555e5ecbb211df90fba0fb10deec397774fa428fe6e753d0a45e3bdc359f62db4fddf079f7f9cf05bb53577abae7e4955daf5e949521d7947ce9a2059bcb5bf27746afb9b6a9a1e127bbb6fdb431d3b6285c78794debbaf24b8baeacdcb17b41e3454f4a9521926f9f99e10ecc2ccdcbb7e9dce61987af6eb9b6bcac2e1a50de3645ad0e6f7924b7d0a977daf2beb97bf18d2515b3548c9538c52ee0ef021f74ca4e3dc56e5aad918be934bcc7e3402178f454007ed404bd5efd9b0a23e88c5e8d5990043fcb0ac05ad8fb5916efe965ea9fc3ba53101f598ab1e81f1aa8102a28b052b73b609d3623654e44f4e5279fdcbb17bdcdc5cafd8cd934af3173b92dbb668f2bfe0c633c43e62a8f9f51aea8ed0c06677874ff6db6e27c77236aff16d78767ad560eeb852c61b786b5fbd122304e5e444f6e6de4758e29bbaa431575abd60dd5543d5c496b90c4eaf402683d6f3ed600f72de5cee5b7aefbfe23a447b45a1aeac20311b27257ebe213bf605e9e3c71e9c6dc602824b199a9ff7be70ee33c04b897be1179e361d102adc033ec91c4bba8433a686179c68330bc85d15ef85a233afd5a03629158e43cc7ced323e24839f6fcbde47ae617e46586be6b605c2483196478fa56c28ba3f39c97be6ac947088303fe5a7620a3078ef581832d80305b0b15ac96be2b8c44a6df9590eecd5da9b725763b7758b95cf9aa324486de798beb3b7b3bd7f77fda3bd6d836abebfd5e8e133b891fa953a76ef39177522771e2b469689a38cda3094d932c49d3105a8a13e7e1d6b533c7691a40a0690c5156266d03364d6c4c087ea031a64980f603c424266d6c0ba0d116c626186812eb44d9262610637577eeb9f7b33f3b4e17d0a64d9b7be4ef3bf7de73cf3daf7beec3497ac529be4b04faffcdc96f805e26c1e99bdaec3dc853c97b90a7d83d88a8988c321124d998979b63508c2645c4db8f427afb51c86f3f0af1f6e36978f3cd50e2e6c39772f3a1bbf8686f6fa79fe2b6cd5d7d30cb3e2daa6056e38f34f352fb3e2dfa8a2ad9c54f3520b9a262748a0e639d58659c3086c48031d7a0e49a1c8ad354a9d499a6959326b427bd4b811d9324d17b14bb1d764c6fc4e72efe361e86cdd209e15bbf7a55f87a3c2874c79f139bc4e6f80bc2be2baf91ab57d9a9cd704eac22fd103c06725f8010abcf2caa359e1a91d4544b79953b8fedca44d95d4b48a12f4f3c5e2d90ea2a3d1daceb48378a7417c708c97b0678551848e5ce5d44100e2b9214d1ee6e24767723491bdddd08e57629123ffffecb8673b0eb3b4b2341b4282ec906fdadcf08cf43da55449aee12df002aaebffd4e51458b20d23510ce6af2fb70562b8193e9295faf6c12b6d30df6f6fd2e57aed5bac5974f2443a71366a86274956cf359162da2c522946c2311f5b82a380b8da5303124a3532e31e6e9be61c79c02679f2bcd88c0a2eed5ce6e56b61d3fc6be1dd09ddcb6248e74749b2ec3d633be4a4f70e72f0edc595b621fa80a1c143fc88b3f218c4ba7ff7e2f3dc8adbd6c367e62b08e2ee4f27d3cd5e603d04625a33eaf6cba69876887a4d269a14a905cc5a118455176946c8994114d729251727a974f570726f5e54e2fdd84eb8f9adaaa0e15898d96f08176e8ece9ebfae53d9f7bbbea37f1474a6fae6f1aacad689067d8e9737bf49b2d1e8f4b767cfc9ee25272cc45b61eafb63fc76f1a617fae7cbafd3974030ef742dc5c80b831907dbe5cb3e882b92fe2b714be3c70a8a24877caba20c2b5932e99384d8f613861920535ab73ca05af74217ee5b147af0af57f51a40b1720b22c648e4cc937c943700e2b24c5a494549346d24a3ac901324c8e90e3649e44c80ab993fccc37b3101a191f3f3a79e6f63ded8bb11af72d818ac17eb3b1c7271323804bad68775754b8dba549578ba7c862d9ea1abae174343a3dd7b7ff8e5b7737874fd81ca313a2e1fa8e0980b29ba776944cdd7a626aeac4add25c595e415d434355d91c697c73adad71ed95352bfe3042a3e59535cb9ab50d50cb1a45f51fa4131ad9dbf212a34f235e474fbf692e2fa3bfce54cddf76fe2ee66fad3d27ad9cfe4e6fcf71a4962bd3f86be349e73d2d2d9efbe9e3236f93b7a98262f1d666f8f77d6f5393571ca5cf2b25b442fc6282f6ca939e96e6e60aa1a9a5a549f8296d8c1fa5cf8f28f5fd14931e8487074af1d7bcdea6b7a0207c039009caed367808cf3537eebad20fd8031e4f8ba872a2780e207fa0dd7edde269690024f537c99af81c34b4c11cac27653eab7c9dafce496ca6c2ceaadc2d4abec58853ca7bb9b9b9131e9ea6b46b9c8d1202af30b4e9ef76d66507e18175973df059f844972712773f2065ceab206523f1923a9fa3a9d32bd4397d6556582b733a1b76e42b46c878f4077692d2765ef6345da749794d39533359ce8b4cd60cf26e94dad6899d29d3e5bc0ef2ef22553e7ba3d3575bc944df21e42b3b8da9a2334bff530b674a69f2eb1bda7ae31c972e7dc694c7f6b086dda08387eab06347b1af90941995ce5297a9d60741447568bcdcc89480fdb9a749613bbfcc1a64daa62aeac517e267d2457f30f3be355d6cc1197f37751bcb4e30393781ccb7c13eb6f4cc4ce72db729273a9788727c8aa8ad07bb765a1c9d238507654f6be7ce5cd8b932eb5bdb206f777ad79a1b2ff3b067878702114f0f709a689058a938e530515e56ad3b87d05fad8432021c453a44bc00294e2de96dd0ca8c40b9e0465e7e22df56585b52d7555f5c642eb0b9aa87c7a7bcceced6aa12e7249e47067afb5fb8e7f648583bc00cb4b595941cacdbdbd1f0a5bb8e3ef0ecf1d2dd45c576bac1f285bf3636f99df6be7ddc8e7dbdaefa462b18f2d86b7effdd772b9f97245176baf795d7eddbe2b4c67fbfadfe3abbd151e9aa2c76e80f32dbb669679f6287b7baa8c866ca3317d63d7c97ffbea99d8a24cb16bbb57efb70f4867247bec51eff3238a3fd0838c36ca6de989ca4670d9a76ca398c92b3e4acf005844774f03cc09fe88f17ac8333e920d9397c1be03cc2c7f257113ea4a0fc8082a100e07b69f08b9c919cc78c4e63ccf8c7dc8edc97f2ac79dd004fe55d300d98ce99de3277981f367f94ff50fe5f0bf6143c5af068e1f0a621507826039cdd043cfe2f821f6f0c966acb5d9b86c72c17b390852c64210b59c84216b290852c64210b59c84216b290852cfce7c1fa7616fe8be15216b290852c64210bff1b606bb73d648bdb278bcab290852c64e1ff0908211de2fbf4afcbcb1211490100c365e222047105eaf3481dc765b295b8103740bd81ece7b84c8a480be239506f24131c978983f4236e847a3309719cfef5fa9b11a73f18e72067382e10b3f8158e031fa982e312a993448e034fc9c171856c95dc1c37407d0fc773482cc1c708d2dfcdf15ce292a6386e227dd2698ee7176c959e453c8fdac1fa0ec7c10ed6f3889ba0de668d735c26aaf5cf889ba99cb61d1c07d96c16c40ba0de62ebe0b84c76d83c88d3bfb164e3f416ca87d3dba93d6d47390ef6b40d215e44e5b12d721ce4b14d23be05ea8b6ce7382e9332db1d883b90fe498e53faef22ee44fa9f739cd2337db751ffdadee338f8d7f626e2dbd1bf131ca7fe657e2ca5f47699e394fe43c4e9ef1b9bed2e8e837fed2c96eaa87decbb390ef6b1d7205e8f7c06390e7cec682ba3cefe469dfd8d3abd8c3abdcc3a7ab38edeacf38b59f3cb38f193051221a7e0ad9221324be649149e3128a7b6c5c8b2904fc2e4525afd1c5007d2eafa90432cb556ba477a4efa89f43c3c7f481e07aa66e2214d640f60874890ccc0b811b2049f39e8a9926ec0a264119f7ea8090216260dd0d205732604ef28d4cd03ff18f45251ea25f844c96994a881e4c32ca59f7e284f63fb0ad00d03cf59e0344e561153c920f05f05eecb386e08b0799447854f0468567523a909c93dc40b5855a2d44adcf4e7dd815708fa2c00de0f781879cc90939cf606282d402d6d5d062997125a8d437d1035096d28cf1c5a43851c13048d4258eb475ba4eac8f844b8a62a8eb20cad33a8af66e315e81bc59a65a00aa0eda89f17b0ee10190099a87582d82f8cd6dd8bfd67916216fc3a8db60ee053e51269b42ad62fa16783208be6c3a41e011e6941e8b90456488d22a6058b3d1a03011c91ca7c12b59b4b91767d04cd63791946d6a86790f722fa2588b23564ec992ac77ec04230fa045a6829a1452bf4a69ed753d727a80f61d432f956309ea9e431e4b1802d8be47ad208b082d000fdd32569e0123702be8a73611e2d41e36b35a3e44ba8ef227a82f9640ea58d618cdd88f65051d255f43bf3532c117b1a35ad8ba0c56884f8516e377a8cd22df21875a37fc238ce227a99f59de15c6679d98fbc175177aa650cdb68af699443f3627afcc4780f16cdd1753573091ddc9b8a88452c07a0cf0c94dd3c9669c660e3ba13e3a46b10448fafa09d66707667b2d90ad73488f33e84339ce5a2f5b6a77d4288d5007d6dca7ccacc9dc9f0596dab9fad94d37c2267c6d0733389f99949036df4f572edd5c500d584e912c3f1b4ec1dc519be8af1437f37258c59cdbfa1a62cf6fc2951c5b253843f99560c5fc6b9c4b2259556f3a6c6875286300b6c1ca36c5d0973cf24b96b3324c8ad1cc5fc4db36f90db39b9ce8c734bcf610608a1a69aa55323db8ddef1231ee0b1b03ef3a6cf869ab4bc318b2b071de324e6d759f4ac1feaa895e631b3b0b646cef3785a36afe533389931961256d3a4f934ebe526d727d595c66350e3a16e4f44f409a863bed222671657f6105fd792117ead35578bcc8dd75dcd7b238919b4a4cbf1ccef2c1a66f9782c0787b9ffdda87794af89da3ab380513fcf7dadc5338baf45be8eb01122c095ad81e144b4f84972ef919ed7fe0dfe4858c98fba53db0579ce0ff0393b03dc4ff1b992dc8dd111e8cc667153a3c9b8b17f011f4bdd7d80c76b75360ae06a134ac937eb75bc063fccc241eca75167ce72eeb42ca7d93ebd37b51acbab7abd35b952f7a04c87e48aa4f9d08d793f82a3cc25cab3ba08a1f98b796809b825575a26f534ca32cb57ace5842ff5f984f9b0917b7c09674a28218336b7536369f356d5aff44c4bfd8a931ad3494bacf07dd167f3a3b62ad09d6b985b66562741009f74cca45d4e00c58c6e0d895d2327b31520801a682bdff5ebb2b91fb84630f3643e0f8471bdd0569ca48db4552d69277d5e49edb584f982f96b9aeb9e79fdf56fe0d568c2024b18a961e4ce66125b85f5abfb678d02fd5ad74f7a9162184e7be3e408ac9ea3583300752a64d351689980520fd4f6404d35508cf1f66af4d8115c93fa81ee30ae778cc7283c87a07c23e6ba3ea26299960e02fd10f0a27d7bc9248ed10bdcc690721479d3ffed6f10debd9c8ef6e8869ac350a6f801cc866cbc21e8c54e38037c7d64928e43bd9ad03055aa011c5193ec109446817f3f6fed02de03c88fca4fc7ef437c2821671f97b40b6d4439539edd20d1209668ed61788f00dd188edf853a33698750873e6867baf4a20474e406ae2ba3a3f699e02dd44754be4180a4565d68837e942669bf6e788f80e494ff01681dc79562187af6a0a66368bd5e6e33aaed2096925a314f75a336d4aad4063d801f82cf8184ed46f1c96419d5714bb5dd116c4f5231fdbaf8b31b2d378c25e68d6e2c8da3af68ab9bfb7214f5481ff50846622f5275a1c6638908e9c3e865d26bd1c9c618d649c2c6a3bed5cba245b57a8d39c2b868ed87b9a7d7db855abd0b6d42e51a4b8cbc11e7063e3733dde9b0152cb58dee0669e6398d7bad186480d4f603b8d359c2d524861935fd9ee712649893e443e0700968535b27b0576a5d3fe6a4d3786b94de36c2cfb7cbb8bb8ee06e69635dd264914be50e79afdc2def96f7c83e799f7c506e4beb3dbec10dd6412a93d0847baad47a9af31641bfb4b1042b79472a073cdd9a11be0397d8ef615f5d242f6ef01f3208fc5d031f31100acf73bc6689e12314ef8afaa7dd6a57f454d8ad76af46436ef54074f6a45bed9f9d8ebad5417f0ceac717fcc1cdd2fd038b91ae0f0d0a656e6473747265616d0d0a656e646f626a0d0a313637362030206f626a0d0a5b20305b20313030305d2020335b203239335d2020375b203633375d202031305b203237355d202031365b203433315d202031385b20353737203633375d202032395b203336335d202033385b203636375d202034325b203734355d202034345b203438335d202034375b203537325d202035315b203635375d202035345b203633335d202035375b203637355d202035395b203638355d202036385b2035393920363332203532372036323920353934203338322036323920363430203330325d202037385b2036303320333032203935342036343020363137203632392036323920343334203531352034313620363430203537395d202039315b203630345d20203131325b20353934203539345d20203132335b203631375d20203137375b203633375d205d200d0a656e646f626a0d0a313637372030206f626a0d0a5b20323933203020302030203633372030203020323735203020302030203020302034333120302035373720363337203020302030203020302030203020302030203336332030203020302030203020302030203020363637203020302030203734352030203438332030203020353732203020302030203635372030203020363333203020302036373520302036383520302030203020302030203020302030203539392036333220353237203632392035393420333832203632392036343020333032203020363033203330322039353420363430203631372036323920363239203433342035313520343136203634302035373920302036303420302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020353934203539342030203020302030203020302030203020302030203631375d200d0a656e646f626a0d0a313637382030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e677468203338343e3e0d0a73747265616d0d0a789c7d53cb6e833010bcf3153ea68708db1042a40809482271e843a53d553d10d8a448c520430efc7dedddbc9a48b104abf1ceecacadb59b66ab4cd50373df745be630b05dad2a0d7d7bd025b02dec6be588905575391c11fecba6e81cd788f3b11fa0c9d4ae75964be6be9b643fe8914de2aaddc293e3beea0a74adf66cf299e606e787aefb8506d4c0b81345ac829d29f45c742f4503cc45d934ab4cbe1ec6a9d15c181f63074c2216d44cd956d0774509ba507b7096dcac882d3766450ea8ea26ef916abb2b7f0a8d6ccfb039973c4234232409cd09f958e9a811a70a17c304693c25767864535ede196e8896a2851084d6d716f2ce42f8481301064f90960cc58a3617ff7cc5adaf245f3fbd76f2ee9c3c49d5e85afc0d3af9fe496b4340f63e159c2d68337d7cec195dd23c446d10235af3c7c79e7312994bfab274b25a87d1b7cdc604e384b231392436482e03437ad4502290273c6c2809082dae1bb2e363a7fc3c9be5416b3396f814701eed24d60aceafa56b3babb2df1febfaf5c40d0a656e6473747265616d0d0a656e646f626a0d0a313637392030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e6774682032363131362f4c656e677468312037303732303e3e0d0a73747265616d0d0a789cec7d0b785bc595f099fbd2d39664497ec9b6a4dcc8712c27b22dbfed44f2332fc0791acb89417e052738c4795108a471bbcb3a08364d0b054abb34df2e85d296726d07628794b8db342d34104228144adb90069a7609b094524a62e93f3357721c9abfedd76fffbfdf7e9f8eeedc397366e6cc993367ce9cb9e433400020155f020cb6aef295bedeb0e60c00e9476ab86753d7609fe1e04a80865ea4e97b6edeeebaf317f7dd0b10fa67005ebb7ef0864daf6ea87f11a07110c09c73c3c0adebdf786e5002587737c0d067fbfbba7adffdfcc012e4f50ea68a7e24a4e9d27f8abc66637976ffa6edb71ccf9f9b82e51f03041f1cd8dcd395f2ae6f1bc02f8c00b37ebca9eb9641fb27965cac5f8ced5d9bfab6778d7e6db2138815dbc32d37756deafb71d65d4f00c45e06b0be34b879dbf658083e8ff5dfa4ed07b7f60d6e98784303b00ae511ff0874ae58ea58b26ddff5a6ba3f80430b14be3b792887e6af0cf7375e28bbf848ea496d0b1675c0810ad84f4ba2210053c685b24f76a69e649c6640eaef28c5d20343608685c0634f3304e15f504bff65cec112019edf4bf681085af141d18f2c3d6aceef87cf73235ae00c92c08b82c0096fc2fcd82484d722dbb994f7d5ab5c2ee4e5ba2049792843ad9690475d84c45c05b8689de2493a53c8d4c645e286e2e99b7096af80ade24bb057b80e362624250a6ce0cd30806929d207599f0158ca9d830ecc9fe14db173485f85e90ca64d98ba301560ba7de68cb1dcc8bd0cbfc7b413c77816d324a657f9e76013ab3f1efb483808f70b2f4083b809f35d988ae07ef15a2cdf00f77317a133c18bbf00f74b85acee7ef131681036c4f33f629f1d70b5f09d584c0cc01dc2b1d8c79a4ac89e2907cee311de04659877e3f87708d7c5de47d93e16fc50230cc01e7e046a31af152aa096bb1b72197e33ec212fc36eae3ef6087f91e1774be3b087d28576a8a6fd683bee0cf6ff12cef371b063dd10b695c4f7218fff08f414e7f74209ff33a8e34da40cf36ef81b80c985e9b2398ca8f225d2cc3af272ecb9bfca1365fb5bc6feb37ed791efff3dfdfe5e10ee831b30fd931481912bcb13bbf8691ada6bd75fe5db84ebba1072ff2764bc6c6cb40bb4a5d7ffa7f926210949484212929084242421094948421292908424242109494842129290842424210949484212929084242421094948421292f0bf1184efc3fa2bd1e9bfc7fcff2d4b1292f0bf09c883ff680992908424242109494842129290842424210933413807b9d29731fd1be48a16cc0ba1f11f2d531292908424fc038000cffe4081110488625e012ec4d261361442390460095c0bbb603f7c1b1e8703f0349c8633f03b7817fe444ab863fc675d3a97d595e5caf71cbf20c56240ffe2c11c28826aa887ab60eda7fafde68afd20168bfdfab25f4f2c8ae9b5d87bb148ec4e80d89ed8bfc41e8e9a2feeffaf2da71f3afd6fa7ef38fb2b26f95f82ec2b528d9836c3161884ada967e1084ca6be95fa76ea6f52cf0104fbeed8be6deb96c1cd376d1ab871e386fe1bd6f7755f7f5de7bab51da1f635ab57ad5cb1bcf59af66bdbd6ac5e5c575b535d5559515ee62f2d29f6cd9f57e42d9c5b3027df335b9ee57639f372731cd9599919e9769b35cd6236a5a6180d7a9d56238902cf1128224a6663fb4896c6eb70bbdda179f172f6e56585f7983f702b90765923c7a73ae57caa9cfba972de74f91a056c4a8bdcd844198f40cbdb0a58156253808e42ac57e348f14ecdbd1be5e60d4a56636f388c3d9a64b34b6979df171785f11e31e81be5c63efdbc2218d11b103520866d074748cb42c210aea5b96684036dcabc2225cdab709e669a362ac1bbc288c84dc8096bac976ac6639377cfac02ec96c0ac2a4614a951d1b0715d1b9460970277b9468a2623778f9ba13bec35f6cabd5deb50735d28e308f09ee6fed5548fcd3485fb5d8a80ccd9cb81145773bf2b22537534f787f12d3761af2bd2919cded83eec9e74286998372b16afb2085b2cda79d6c1479a3337b8683112197629fb57b4cfac75d3772814ca448123cd32324466cd1b1b702a99be7945ea9ce20ae80d6fa4636eeca272366f7445eeea63b2decd64604d9bfb7161bafe5aab48a4b9576eeeedea6d50b9372ac1d52c83d51ded6c82a8baa6509c146f803502ab093785dcaab297ad6c6fa482c95d4d0e75d9a729e1380509cd894a1795600932505c3d2e0556b6cbd8b48abefaaa20d253c58cc71d22d86bf9a55e8ae831cbaec81f402161f9fc3b9753bae214c963fe0350b4456e0947222db2ab25128e748dc786ba6597598e8c2c5b16196c0ee3a8cbdbb1d778ecd05d0ea5e5ee90620ef7931ad43db5809695ed0187db124a1497278a802685866560d3412de0b3249ea1966175bbdb858a5ad31e72a09eda29be1a7135a78684865b856b1c571bd5515fd5b47a1ae3a8db4dadf3aef120746341195ad1ae965dd0ed1885a0cf8beb11a63593891afb1a5a3394a899ee1e96719403ccf7d9156dfef46332a75b9bfb6b1492fe17aafbd47ac5dad8ce3bb8908a710e9e627a2feef43a25c38b788137828bf0a2ac98bd8ad83ee9a80bb9cc16f40074f556c9cb5674b4bb9a23d356a052e233a57680a62e77f547e25b891afd95a9cb5625144e2d16b7f45da8f1a1ee8d6834f874dd4ddd8f3b62565a3e723bdc118b9ce6aaf65151b9c6d5ed33474d3826ac587ec58acb4544bfd43022933d2b468264cfaa8ef609339e5a7b56b78f72846b0c37844666635dfb840b8f0446e528951269c1450bb08c6e86514ecbda3b26820043ac56600456ee1927c068da048d40cf38a7d2ccea40f96ca020705823a835c1446b01695a9536a4b62e88b7d6628d99d61c023c4f8055aa3002543541bd18d40675412397c2394608258d22e510b6d51118339214e218419e2b19799c0c8de8820eb5c510b608aaf2ef597349b0351ded6346c06eec8d03355088af84918b2c5ba508f954c3fa2a877ee6825cebfd4bd52eda5f21b272bd7c8b9bcaaeb4c9b7ba91282b2ed7ba766c34028b724291880b7f32ceb9a7ad5d7dd32a5294839c42683089b68e9c903ca368c4aecc1f8ce5d04d333dda6d89d1b6e26814892486537aae381a4aaf90b5f4cd1e26fe4805c8eaf8427e7cd0c8ba4887ec96dd4a2e1d382e07165373428c034af2009344a6ae2a12e9a587141e51415c2486888d778594562f4ea2db8b8cdafba8b16ac1e85e1d6e444748dd9fdcd2853e0f1d20737f91916090babe7eeae522f292de88bcaabdce11773ebb1c3be91aa4516b5ddd90b4fb2bdafd04e3b4b27d86fd236d689a86925fda1e8c118ef7376f90e6cc7ef43cedb2abd9d5ab0497b7df1eea8f844334a48074d5cb11b4c885a070f2429458322a7ab9af4131c80d941ea0f4804a97285d2337a003472feca22747242ce369a2683cede02068621e337a5964e91a8fc5f0d87ade713ee4c6c3731d263cdf75de900b0fd7a5d86e114d61242f52867abaa81c78bed1be1acf929e90a29d66884d96283ae4a08b73c0162dac0fc611b4530fda5a97cc502463c0331452425e3a68fb06cac0e5322bb058ae51a47c95a7984f07f285226972298bee248fa2f70cd34c87b2019e088ce2c0220e165295a431a2e43d3256f5845daa8dac6a77c737a4dea152fa56d08ddac792de11af043a2dde6348d12bbaf9c8101f8a1be623437c34a1902a3c2b0dc71be0d866c58012e5cf5065bc036a07ab965059f019465169d3ef53362bc661a57c0bee732a34e3a4c16a25050309f4066a7f0352e4aa4467e4a56524cae3a84ad5d0991b51efe812c6638fa28b9a01e83b68dc41ed0f1c13b851013dcda708ca5a3cc2b59fa6a6307224a24db97207555fda94e99c11394f8fe20aafc79c1a1cb33779e908778d97e584e591a57878630b9aba7a151e378edbd51ba2ad641a92512ff67f6d446634a24102631e31d7264a245e529731a2dc7079b17fbad84253184d6ebe1a52e0245840e856363a9401b4c94413ba16e8e1cd720d0d1e6b58e74534857179a637041a3eda1bdd2e433daef66ed5cf63f4d91269a1116e575c61f191949bbc97b1c41d41d06c90119d8e32b4dc150eb9c218a19215782438701f62ee5adfa504e52e7a082c57e7b31ce32accba22d4b8811e2e0e458331e7faae3e1923204a0b8554ed531985f88601472422e34947375c0b3646f6f9b8e196d00c9f41afdcd587ab48c77375f5b1be2d282ed30ee5e668967117f72199e91215874eaf9bbe7a223272eb0c6314e8b144d222aeea083adf4e3c3784fc9eb6301e52f42c72b1a5ee72600995b0849642c8486da8f3d086aaf153693679473a359e4b14f66cf6aa8db58c2bbb3e28cb134dd84ea2c816bc2d665461259d3c59c9ee2ccc43f1b47a09aa378856e5a0bdf1ac5f1d8f2dd5fe4b68574762c1d46e4809252277dc59231eb267f9cc53699d92b66ce55a072a76dec86aa84f23bbf02833e33b88691f261e0264075ccfd2cd580a92cd6305f32a82e364f36886a3629c6c19e36bdcfbeab3c916ec598cefe59806317d1dd3114cbfc2248109df014cd763da8d49884d9255a339b9151388f48ca6591972cda8bf2c8eccce47e6d78cd5a53b4ddf236be13d4c1c8ede3196954d47ef18b3db593e6a36b31ea1319d9e1206e3e20d52f16845e7a85d45ba476df638121f776502b961d457114752f319b27e5497c290ae04d237eaaf882305857124d78542f68d666739d5a6ad2be27d1606e248963a40d7989589db356648a1f9f5a305a5aca275b4ad4345c6aa6b2b8aebd3492bceb215b5d88ada1ec4f710260e80f4e2baf422f622be4f538cf48e0ef6b2815b46adb60a15494f8f23a80d8a348c5aa86a8f22a24f659485a319990c59306a408414135fd050eafccdb95ee7b9978a9daec3a41ad7b11af9578ff299ce7a3da925a5600627a9c43c05f372523a6a73faea8d5826a482f82115a96598db302f21fe51b333788854a1015505afe14cbff6fd9a535e23fb5f23fb5e232fbe46265f2358544e91fda7c8be53e4c55364f2142d9e7c35e07ce5d56ce7d04fc94f3173be4a065f25cf3d5be87ceed9eaaae788e1c74d3fe6f02afad41b3a4b45eb4b04d1a073746e698579d4351a1c5d3e3a383a34ba7f54197d71f4f4a87e72f4fd51ee8ef1d8bb63073c8b2bc663a7c70e9865ccdf0da61ed0992a0e642f76be781339bd85b1d13d408d670bf21d8f7d3fa81b4cc3c5da8c2b46ebb26fd2a5550c7e85046fc06e83eb87d6ef5fafac179ee83bd247850916f662afcdf7ecbe87dbbc8f0cee25bbeffefadddcd07e02ddcbbb27bbf960d76017675eeb5abb6f2d3f4eb607276ca5ce7edb62e718a679368bb3c8e6717a6dd5ce429bd5f9ab82f70ab8130534e30b6c66e743ae46a7d396e7c4dbb9d365ab737e3d7ba533dbb1c8e9c8ae7366231f3bf6b3daea9d69b66ca705d3a08d046df58d15201113c1c747026433d94d9e2047c809f21e8911bd0988097c1080cdb01b9e80237002de8318e8f5ba4aa78933f1dc09ee041fe362bc604ca916856a9eab2650cd2f5f2e9271ec8fde0230ce56ac04f3550d23e9a5de654aefca863bfef55f731b94fb68e0cc0f0de5368430bc5d86de0923bcbd186cd14b3043c18bb06d3b3edbb62b7cb32235f77761d8d7b48d16526921556e42443151dc243711c5d6dcafd8e426ef36ef4c401e71240e5efacca8026f3b5d9da627d1d89d4dc4d4e66ce35ad75cbf86ab3a52e8dc7c847cfdc81347b8ca09bbd3f73439fc4c86f37bcfa43b9ff99edd796862a5f3a989b9ce8313a5ce714c13e5d5ce71b22d58132875d6615a1058e05c18703b1b03b9ce86c04a673da620a64079a9b3d4dfebf4979739cbcb563bcbcaf39c2f969d2e7bbf8cdfe1bd126c677ac0e4c0609eaf750a62ad53afad75625508a964bb17704aac119be5f6eddb136f3a496fe235ad90ed571e47ad658af7a2b76eeec7172a9cb5a6c3839427d9c4f7c593c2ed4227ff126e7488fd26f666f496686f34c47f15e66010751f7c0b26e018bc30fd8df930fc27cb6f865198849f5cf6fdf973702f3c02c7e17534ad043c000fc1b74141ec7ec47691f5e476d8c7a80fc363f05d188343f083bff8ad9bc22992f82bab3fe06c4495e0b760e44e926d642f72be1f1af0776c468f3d3004d5f8fb3b80c4b8257c80ebe08e7377729bb94a95caedc4d94df22ff18fc255f89b8457e0992b74fe1cf913f9136c87b7506fcf912f73c7e03bf028dc81f27c1167fd0d2c6d8661f8027c15f67fbaab14112dc2079791c6e171781006e0e7a8e9a3d883e254935fc4f72ed0433638c570bcedb7e0dfff9ed9febf00e13aee49d4d6bddcf37c03779853781f27f087c917d1de3ee10508e32f84f25f857a580fcb501f8fc037d1b276b1ce77a3658dc25eb40f0a5bf0f7207c0cffc47d0bdbef801dfcd7f812ac3b0c0ba09bdc46b4d8bb1a9e220fc119e8c0df203ab733e407a87dec291c867eb4b6c3c2eb9a4ccd3b703dacc0f42d7250784afc297c1636613a8a6f4efd03dd12e0c1ab01db4189138026dff3bf789ebd4a8add16b7c5832f82ad3e1912e102cd0111340c388b3673543cc97aef50eef0b6074d3ccf71d21a510b61c1cb874576d4a4982b41348b1c967e79202545aa45e4cc01a391216f3c693020a2c3960753b1a1ceace33abd3edcab9ddeb353672170deef0b94143b823a957510796706b229b5b824447899b7cae57e7234e791bc578e1f174f5e7856a8fcc4770aa5dbca9fe48e4a36265d0d93cec64912680814f1bc50041ab3c6a5e135be4ee4751e02757e5f1d8ef364bc4d66e0a8df77343e04fd7147bdffec7d0893649bfa1ed74813d5c15e00b10975e000277cc046592f916b75d7a6f7e7081aad332723b340e448765696a4d7e5e5a6db0bac6693d166b0e571a24e301e36a567935cc17cd81a3005acada656ab6035d9248336cbc63b78a99b7798b2c8d7b34856963b2dc5d69d960206b361d070da2018685c60b655ba0cc4e0ebf46ef1fbcffa7c16bfaf53c5703e81bab4eaea4edff98c6a9a4a8ac9b07912618abe2667e2a4d3117431794cc6c303aa4456f3e1012b8a6290a830280d2a0455eef75990a9cf9bc112d58e9b77dbddbc6c65a9dccd929f6749c43ab129faf375c4183db9e1731ba21fd0579478d6453f243ec4492a7d71d1cee8bbd79134fee1e89ee1e85af20d9a86c92dc3e49168074d7744e99fbf878dd1fbd13c0b602e144325a966ba7ec06885821cabb9c063acd1d658cb73fd058dc625d65677634148bb26778d2f54ba41db9bdb57b061de4eedb6dc9df3b65566a599cafc7eebecc2e28282e2e24aabdf66b5faadc5fe824253d96cad94e9f4a1ba9d5999f27dde838efb3233a57283c88b063ef5a0a4b5fa8b0b04b03b6697098f67159a82221145b0e7e595585d781730553bab39a8d6e9e65bed74757486caa09dd87175d0c22cfe4e6669a83f5f675d5ddd14264b5a46351a7886dfe72bc5a54373b7f871057d943e9c3adf9bbacb7c7458387a74d85c7734f5684931e042e5cf1495c999e93d38e0b824a7947a7040a27bc49be0fb43ef0f295fc6962e994dd258644b7efe9c727f7a7a0645f2f3cbcb2a2a2d7e0b96ed321228929eeeb14892dd964eca90505121c09bdfde3af0f315a6d663dbb31667ddf7b95f8e6d5dfb8385a69647c3ee6afb9e2f47b98e9d217238bc79fd0672fb3da7ecd1fb481f292e78ae76a99e2892453bf7915bf7be6421e6e807fc3cc7b1e2c5dae84a8d49743d748e3ca4edeb087545d75ed79111ed32f6a02a37f027c922b677cbe93a3fc5713cddb6a8d531bda112f3970e50b7c1a39fc0adebf7e1c61d636da895c6372d59e4dd13dfacc87120dacb1d438e76e8609653ae09a25f22f4a531ebf49584be300a1517f38bc5cfa47cc6226908316a8bd1b1e25dc4e4340b2e8113d81276d641005d12e9a41186638cb6c371993b92f3398b39add26f97248dc4d96d69a8c50ceed85bdffdd10f95b756dc13a85bb66461dd8357477b4f9017f09651467e7a42bfe4c8eedba23f7bf8dbd1b343b7fda899fe17f0a528ebc34cd64d54d609b0e2bc51503affa017118997ac76de6ecd27f97cbe35dfbe882cb2dfa2bb25c5984604635a40d88da20a06278cc75e08eaa9a2d87f57cfa0eec17bf9041c63b44b427c33a791cb2b2a2a2bd2cacbb839aa85a4710f1f7be2adabbf56b370c9d2050b1ebc0ae7c2d5457f122d3aa16f7ef6d6cf11e7a3df20f9b7df7eac597f223a9f8e33c8ddccbf87d25be0a02a7d2a5e45d0b5a3c73a1d4c474474e18ba3af562bb10475e64a2d9d5835224432e90da95a8bc84946a955588ef3d09b8c282131599d560e2c2966adc6a833a772bc201aa494029dcb488cbe4e3f7ab8521f754dd4e7a14574e22cfd68ef3ebfcf8f33c5d38405848e60da6543087a644d8d069bc55b533d683c56d92acef1782a45decf7b3244febdfae8846697147dba8174471f6a202d9a5d5ab2b83efa10ff999b5e8bde4b065ebfe9c4899b7e4e3645ef79fda6e7d91aee251f62f4c6c362666f9e42e2e5caa19a6b86c5dc1a0871bd182ce9d166db049f888ba3e7b2398ef351b9c1fc61a98f2e0fb3690132cdc74a995113d94a3e8c9efb924272a7b6705fc0513ab8126e2ff7368ee263a3e84803b79bae35bda98d192d959ccf4b39facee30e39c09186010e327d5ee6b8cbdddcdea9e35c1957f224f6c0988e3ccee4ad629cf45c1bd152c9e6e17df18c6a45f46ac5116a43a86295635b90a8e731b274cb163f79fcbdf7900b899d8b1ee67ec67670857af6f27873aee2781b4e0937aa8b09e9a3b20570aec3e27ceff0aea38e51750fc7674bb89f4d4d3cc63549b68fbfa969a7a7edaad89b82417c0f0c209300e36b2f23b58666b2d4b0d322d6d8cbdd4bedcd6e01a389f783d65413d4f266fab64fe838f704af373d1dfb10fb1a4830a86b33b9cd7825e47093bc8c5109578bc8fb189530e415742f0c39cde21486d0c805918bccf340bd39760e52208504a10d2f10ef82118c71fc9c3ac453883b8c06c3388e666c73b8f74b9312da5c4a0a120eb44946a3318ea84d5c6d92998a2199a90c523a1580b6966a69537cd3a0890e2dd1a54db1544abe4bd79dcef3b8cc334bb83e81f3889514e39961d4d92706741cef9e18e0f5f4640878d5dd2ecfa2eeca5f9a462a2acacbe83920cf42c7459d3e3a2e7f698560f8edef3f7a9ba618e46666e6e56d58bdea46675ebad5957b63dbaa1bb9df463747ef249f257bc83d6447f4b3179f5a7ae6c1af9c5976556beb35579dfbd2d75e5a75f5aa56ea13cee0013e2ebe824a3acc562d5b7c4a9274bc811f472303f204364153d319b8b8760c09ed18e2da31b719b4542f061771f1436841e3b177d9aa21120d1a68156fa42ac3f2876ccd28124ca5faa315f8e65353e8e11b5791ff3ccdd069d09009025375787050930e9a24f1a901261ce1c70798757b8f622555991b378dc55d5e5a51e9b7b8f9f1a942921afde02b5fd47d95681fe0dfde73edad9ffc279ded26bc0908e2fb900f8fb1d9fab3677932bc4eafbb4eacc8a896af125b3296c8ab333adc6b67f565841ddb333ee3b8cdb57b96d5664b3d94c5719e43444bff05c2930673657ebef692cd3adab4ee404e6b0e97934d279c93ee49cfc12b0699e408dbeffa14badf3bb7d0833f6e1238b3521a42333b30d96c59a987067008e239149f5a69c0cb4e4c9c1a75fc9799013b0cfca5e9761b2be1e316848b1b7a94d5dfba7dce2c795d65f9a6d2c26b320d0b7fd1f3e23b73677bfa6baefb4d33f7c6c9ebbed3f9f49bb72cbcce9997e7b0598a2d2f3b6b7ff1bd6bef0dd40f2d5cff46906aa82bf626ff3bd45090989886d6a6a7e6ebe6dae7ca15bad2b41ab96c5e794db3ae296da9dc34afa9668dae23bd435e53b4ae64554d8f2e9cda63eacdda20efd00da66e31dd2ae7da6d15e513e12a5255e536683470c8c0793c730fb9f515b55abafab597f4a76fab755b2a6c167eb6ef12d1d4e673071c430ece914e95eaa0f6430d09918f836cff39b40e6d7836994d556c48a99c8dbaa5e194bad1e8a981a6e4532f2a8900ef3c1e434ce50e94aeaa7c624015ce008706a878eeb98706dc6c27621fafdac78b5de8aebc4cf3b80ba9f2ede9094c92e4596ae086bbf3d272e115a8348e9358c54059f1a21c63fdaffafaee5fd0d0f8ef5b7c37ce9f5fd31ca81fdf31f8c6b2d4c0cb1b17dc36b7a0d05758b8ad714dc3f06345b3f2d7898dd9765b91f5945c3dd75bbc67ed6d87b25275455eef7057df63f54d2d15f9a7e6af9e5354b471c58afebcbc8c47867656adc8ccb6518f4cffaf485ebcffe8d119be4dd7f2301851b7cc1b1e684b51f77130af0d355929696c3835a3a4d1a54c102208bc86e7b520688cf5d6441774a0c6c4d2303c3aed648d743de812195d045c5aa255af935c2d221f30c7ad4df86b44de3e48974eab4d917c7ed53576faeba6d89eafc3c50aa0c6ebcc537596ea6a7af608186997148b5e012304331590a44c0c4c4b98c99a1ff51e8d2f918ce1b3bb9cf82d7eb78508de91c9a99bb807c747a25f88ea3988a2525ee262174f702d5387a8addf8eb6fe7bd4d03cf823b3f57985da1a6d85ad3a6ba9b6d1b634ab43bbdad691b551bb536b74b972270a0aa4d987dcbc5e6f3924e9653963da509f6acb7007901d3dda0cecbc32c60fab0f1387d587411d3b9b3c42dc7b7a54ef8988ea58c7da3c2e57c273baa88133cfe902575847e8157c4c9752a953ed1b236b54966ffa74891b382a62aa547527192e5741eec4004aec9e8df68c324b964303d2b45d53a3560397cb0c37e353b68b066fc13ba42561f0fcef9b17069ede7ee389ab5233daca6abb17d46d9deb99e39debdd75f58a874bf892a97db35b72b73eb464692b797d60bcb1e91a5ffe298bd76acff01617ddbcbc75bd3bdf9965e0624f44b70b427e65d537a99536c67e2de8306eb0410d59cd56a15628d157a5976457cdf52ce01668cb0d5773cbb4cd86d519ed9e8eaab5d537560d54efe40667594b1da689f2f239d28483436d1c9aa32f4d83196b026eb39bb8d17edf9fb65f77ec9d69fb75cf0812dc185550bdbb1371863b11672072fa496aaeee421a231b285ae82ed44d9f7d3af7a07dc8bedf3e6917ec8993d19e585bbb1a52046d6df674cadfcefc989d0510780f3d1b3450a3b09b2957bb6f66c4808b9c28774e794b4be961a12e312675894b1de5a689015480439a18a02a98e33b3430872d71697c89d3d89e48ace574e8800bec29a36fb6aa69761b7799f34aab544bf9f97cb0aaa4a8a3e2b62f1557e4872b83f756127e8a5f56bf706cdd0d8f2eb87acdaa156dff3d52d031479fb5b1f2e869d3f22fae59b5a779f94a7ed30347ca8a672b8f5eb7b3c8699fe731953cb4ed99e686a5cdf52ba31ffd6422fae4a6ed3b75c623a9d9847bbfa27476d982a7a91dfc1e37e419a1937d135ac8ec2085b471a2d4266a35304f2289188bf8bc7843674114fbf6a4364a7c7b0a9c57bd80df4223de33ef21f041927be13f30f2e56067742f373b3ec67a364651915024ced39409359a466189668dd0a1e916b60a0674866d5aca5a10f452b644bf3ccd9b2902bdaab18d377d2108eab00f76097222932471334039acf47680b234d00b0215e7e224bb24a0cb78165a850bc2b320c1ed4c1e9f44637151b289a224f01c57250a88e25d4be479897ed2088b83220712fd5fe4f122e17c75f4bcabab33d7e14dc29fe5abaef667d28bd6300bda87e767d28ceac9106701c803ef19d8342dd116a5f490726247bf7fe1c20b42e9c5237c7d2b476ee1c86874477407ea6d926c14d3f8ef32bda9b1bd553c2249e408a7e125e0cc9c8be379bc3274d6f9eaf042130fd70c927804c3358e1c51af36fee9db0dba68b79876e1bbc24a9af8d4fd5387f7536dbc0aada26ea636e867d02a9eb321774194a42a5e4054a0934725109e279bf9dd1871a210804a22a808faad905dab66cef0cfb53183c59f6b83a036f01175175ee0eb2f1e114ab9e553b1517217b96b742a466d15a3487e1ffaac1c70c18f98a4f9a2deaef7f265990dfaa6ccd5991bcc7d99dbf4db32b7e518259d569bed4c4f4f2bcbe69cf4326da2bbddb9264f9b9beb744a85e8db3f661718445e572f733a5d86c93bf362f34a30859d1ed7a38e863248068b284d9519f438e8a4c7010b9e51efa5d424bd8958271ee858132264a7950da0106b8279f1cde24db49b3e093476d9920836a9fb8f073b04a3187e5f7d45c59d578d557db9b0a26eefd6de914a43e3f1b5cfbf13dd7bfcb8b0adfb2b3535ddf3cf929259d7cff5df7af596cd8db38f3bbc273f39730ab8d8471889bc82e7ac06f46490ea6b4ce0e2be52af4f5cb6128806917a2bf3cbdad8c7d3fe5a9c810b091cfb6be3be564a201a442668b31189fe93b4091cffc3a0936a92b09851ab17f565788bc0c517b4a0e5051d6850f7bf3ca8aade686021dfcbcf9b5f7e1e839100fd72717ed23cc93e5538824b45d0f31e28c46e3abd561c16089a24c7ebf4d2b0866830ee2222d1737692cde593b95c332c25cddc527e07ece48d5259b11e2fef7a9d1ecd0e07a6c660d7592a79de68323a8d01e36ee3178ca2c948c0d7d969613784ba40350d59a98319364f75b2afc334d34e92ced0a53ba62398a297ca06903330d6f41339139c6e3899f889ccbb79acd1938f3e241f9d1c9efad13077e7db6f89273ff191fdd130b7847b66aa0177f7fdb84e77e23ad96136f8c9379865bb44a3dd38c7585db2d4b6b4640dd766df20efccd217a4526da5598acaf2e834cc2693549b97a7c92dd3f2f3ca34daf47a3d86878963377d3aa20fb6a54b740dd2ed6945600a9a969b7853bad92cd59ad22907138b9b4c467a569a241a2e9a5873131bcd64d2782ee3eb49f0c5e0c90e2c464aafc4fc770728b3f82702167e7d90f88c7036f1d1e09789bdf55cd0aa7e862b379507cb4f94f3794509db2c4adc798bd4037dacadc8a6198f7d72804aaca1fb968ea361d75cca5f93427962f9e85394a5a6b7ccfc115b1f1adc96b2255501c3b7e9ebaeb733ad9a8673ec44a3d4f374db7ae989624fb3e415950da05eb5b96503ff87b62f816fa33af79d33bb96d1685f46b625d98e3779b764d98913c94e9ccd0e49217130a024846c809a8542083434400bb4a5bda54081dee611e8e5d296024d9b109698e047d3fc289750b6cbd642819bb2e412caaf049a1b62f99df3cd9cd1c881fbfadefbbd3651c6f26834e75bfedfff5bce2073524baa20c97a95809c69f1db1a8ca9d69cc408fa38f840b8f795ffc87f67e9bca5e3771497a11b77ed5ab064e1a6d5d7dd5cfcb0b6a17deb86036fe7cf6e6ba99bdbbea06dd3bab7efbef6b6de9e14fafda6fb320319e1f9407df2c61517dedb26d73ec12add8b43516771d85755b962e2eea55fad8bb8265e0fd7d7931af1c0e45ff8fb850fb10d85c1867a655ef2c8ed615e0bfa9b92c1daa6e9c1aea6b99ef96de7b0e7f0cbedcb3dee8dbe1d3ed6e7d3524e7655cbe616b6a5a52ec5d87dada0d4aa0cfef7999c9708b5b515eb09a9e9587a659ac33cf924241371aab2b841ccec23f1c0e5221229131383b4b8e3d7d39e66fc165473e250cd017a26ba88624517d12af9ad08ef4359e72dd0a8b82ee53e6e6965e789e2745f4df6010bcfc30bc0aedbe7736aa98213af85a94b15184b5289d5261082c5a6535e4ac38cf2fe69751efc7ba3682db26fdcfce9e8e8ea95e78e1ebf7de89b3ded6b3bdcda99337aaf3f7be57db9ecdc85b9593f5f3172736f664948ed583eab7f5374f5f9e7a3eab1fd28b87ecd85418fda12fd6b784e22d670c6f0f0bb37fdf88de185434df1587fe8c350933f10c4510d7bbfd082bddfc5543227f55a502c47a4d3e3ed8ecef7ce8dae67852076f0107670b5cc11556bed2eb081b91c6a77a6f71da7de77947adf51ea7dafe6dce07deb636a2c176343548f21ea7a21ea7a21e27a45b892442e497d30e70027a4aef794e17a5586a24043861b127519c4318fc8ac831c04b70a95dc0a1c8ab53894572a771da1e55f6fdcf2c143c55fa0b35ef8ebd29bee7cf692cd8bf75e7ffbeddf3a74e6fa0dec7bcf141f396f5ebbf07c36b3b2f8bb57eeff644e7bd3e7df6cea9dfb01f60a82aed3b17c1dcc7e906e584e6332c6a711674b63cc16dd625ce430d5846abc4a96e158afa80ae6215418362a1e1b958acdcf50a930542aa4124ab2477c2419627e12a4c2ac71960112fea1b393947975e401d2e613e47401df16e2d305c431b67481b1200e164f176484fadfdbb97f99a8617f39b18c7d43787e7771c3ee89577633c64abd78a536e6d7b0528f90665909a5b1ac658604221dac3d04ac9fc97974fc75a88e98836505ba58812e56a08b15ca4ce074187ed2d0bd5d5fa50575a1985d5aa4ca0ae902be2319a50b704fe1acb93ea42faec693e0bd1343ec1d131b0e715f1712c5f3764f7491ffc43441b7ffe03fc5e8d68e2e82d5cdec042fb173a2a792d3824dc18c27d53ccf43b06dc47e71e0e290d290ce35a2c64627b3c3877490ab21e8d6d828faeacb1ca9dee248f57ea6c9ddc4e2bcf3a85e0b6862c9ca9ba81b35e9d50238784177a3a6a64eb533d7c95652d15562d1ed872b57624f011fa90c5c8671710a1c966addff202ebaa7e062c717e0228d77e4a72e2cdd363034ac0abd0e673861b0b1215d20b2a170c9d450b034eb6f8097b5142f6ba7e225e331c19264161e004b4ebcb37872c58a356b579c8bec770e7d37dbf9f53acfb4c5f3fb769ef34af1ef7307720f6d597a6f6ff1e76c45dd8ecc82ad95ab565f806a0fec45956b575f14f4a969df5f1333aaab1a8a63c54f6e7beb8c455f0987d1350f4e6cf5a4d46090daf873c49bd1f789153ca48011e89cf3375c5a3669912c0b768943384125751cdd456d041dc92f6da46b41248a0f26691a7014848a092a3d1d324f723a22664f4e47e473c0691f997c572f2320a438654ea09f114c6c147863b2e320505c41509cb4dafec6b85977771f36fe61b2e3d9712022c45514bc14ba001bdbefb654fd588be1b2964a2eeb679c66d92b0431c00500b516a3594e61658e75ead6c751cfe6fcf8f68afbc8590280d484814f86171b3313c47b4789d12832873dd7142ca1bb070d434960cf25c93f7eede29f3b3471d6a143ec0387d8d726ea85e7271e61e713dde57112b70b74e7826cc4261a34c18e0ffa3523c720abd357ca598ef9c993661ec2958e75c5e79c36be53e4ec5c27924923e46fa00ae87778882a3837f43f2aa0f7f1c8e44b0febed8f92429258fc13e3f80f917d77e962b2e32ebb5f60efba89bb8bdbcd719c0b1a2a2234570016c845887497285cdeb858fe58e7c4312cba639df80f08ce48165c3691ef2ce02b23aeb3d46be8d45b0d5d9e9a740267815decae8903070eb003070edcc1df7dc71d9faf34ac9efb0c4b4e6076e8dd7f0ec72f19e0dc0e707e403746869178aa659e6a99f7238adfc4b4730eb06d8761c67ae4466b441dbd3168008010d0c0c27898e52024e9c1086e95e898fbecd4dd87d81fe34ce6cffadd09b7e0bb73a21b0099432376d4c3f608ddf64dec2661957d07bb43d86cb78162c897f1f820972147cb6c23f6731cdc561b12ec389b63792fdfc8a7f939fc52fe625ee2e3e49e795e72d83824c936bb8313882f9cb4f8c2df4ef7853dc4151e99fc30e7012710c129582356bf4f63b599ad9c3482b6d308daef1adc68ad4b752d71b1824803a3ab3c30e6dc23829d7c0379c5feedb3f223335c9ed02d5012c8391237852e29063100be54624cc61b1e320ca37b204e576062297f09834fbb041b1308cc948de98bfa440bf64654834834452821dc72a8b87d5b71c7a3c8852e45eb914fe04eddce5d78724278fed46fb9991455c7097340d78206cf7000ac6e9590538a4ab5524a1a94964817b2e74b57b05b24bb8a1831863c621d4a8973c4b3c48bd12a713bda8cfd02f1227b0e5a26b248543c24f577e88d5aec880efc336623b2882d4a16112be9186cf04a100f0eca257d4a166c937c4cdc50d7c754819f19fa059f6482867e8b94eb16f79afaacd0f589994e0e331d9e7c8abce2dba12a65a9afb03e9e7e054fb5c89b5a24e513fc0a9682df3d045ae429f131b468512274573cbd548bbd50cc485eb225cfe42108db4c7950fde9cad335878174fccd898d8fa208bbfc51813f794a78fef3b5fc4f48256c60f26d61bdf03113621a515e9f290960d376b91852e07e3f17b3d99919b630f9d91626c755a9005b9fb2d9c390d887cbd84fb854bc0f07b6619ed8afe0771413848f5b80f7e85ea3a5fc16ed357f487bcb1fee35e0f54fb910e0ebfaa49a8c6136b123c9ab49544bc951ad498e6ab15c53e443b581cb55a4820a55a0412ad0201508900a0448f543450268908abf1e205ca57c4aa57c4aa58a54d73595f450ca19cdf7f266f24f7e22b0ef0c54a50a01d6569f2ad82c3301d642bd2573f4598703606280dfbb6cc579cbcffde4e6dbffb67ce4bcfcc8c827b7dd71bc37377dc6cf3614ee9e3523fbd91ffef0a950b7baf8e6630f15ff74c1860bd6adbd00553f3c862ad65db0fea289d5b71e195ab46868f1f0bb3f2cfeb1f87b94d133437e36f64ab2f102815fd64ef74faf1cf20f552e712d55d7aadb2ae4488a8c6d2e963849b2855376ce267bca94ebb1789107e8a3276049038e97e63b0cbf7926170077815631c324d4048a4834a64854bc92df46ddc346d01c628a4d349894c9ad740fb1ad891b3c75c25a90d13500e9815e6bc3198214c149a184ed3455206b29cb10f48a0bb41a81894e4911f9d98333173db7ebe787d0d66f3d36efac15cfa6bbdbaecadf73c3b65b3b9a1b78f7f90fcc1c3e63e2df85e79b3b7a7f75cda24b6a63dac403f59d2d17813f15b70905ec4f0dcc74b453cf9d9626d6262e4b700d0db529ce5125da0204170c07fb38570b0ee606077393e336ec603dd8c1aa7c22c33482201acb14d1682a4219690c446d6225a75e1145d132678b5a9c2d6a385b943a5b943a5b9414d4a00f4f9ccd4f441c5ddfa7f6c530caece8e3d53e94c69005159a34f5bab411b43a46d2e06c56d7b2ba9ce984f87de04bff98b3cdf842677b97fe8c23999bbcd7d546068b0da7c36897353ba70d0d5c6daaa04bba0dfcb0a7e487e44ca371aa3b627575cdd4428e37e06625b397dac59de69f42a1fbf2193f7bdeae846db77f32627ae8d2652bde39285486a28b663714c2d117cb1db678abcb35f6e0fa0b2caeba8ab870f1cfc56fcfee19d56295113b775799ef3e857a8caa4ed8f0dd26b0a8c14175b092b5a3086a46d3999968182df49f8346fda39517a38bfc57a0cbdd5ff7ab7aad9c457bf007dd929662734443383d0fa7448e1164cf7e8b197902aa82b30fa2378584d828d1a30233530a4c4829703545710b16977f2ae7d4a96222f2651901989b6072c5522603ee2c507726de0cce0c356f43f124d6e90555af3e627de544781c25f36454d7eb96589c6ce2e588d8c1614110f84a5dd34402951c9c1455a79450857071b2d8f0ce2174f5d50f9c71c6b9f7fe605d6b7bd3e6b30e3eb8ecdbedc94676c9c46ee1f98aaece3b2fbbe74f69746fffda784568e2d9aab6a64b09cb5934f9177e00eaa3cf8046e6b6298dfe64b297ed55ba2bd2f50bd941fb42e760c582da39f5e7b023f651f59cf0b28a15b56bc58b7c85c0baf0da8a750dab9a37b46fada8b8d2756903db90f4b87846834a3cc64cd417ab6aabda51c5555555a734768b800410ba230343ff9aaaa23e2147ce130439c5d8e1e3ada1aa2a47194e383005a280ed00fd3902ad07268f9ab8d08a2f66b7f933ada0f8563aacd74ab82d31965652a020dac707ef024ce083e72c65dcc56996e7a7b1968988fdb4ae9f6b27e74f0bdc15da1d62436ef20521680e84a0391002bc08816d85e0de42188180d393e6d83ea72713f28225fd7a24d4560e07a400519ac8d3df31c6bde16dbd849b246fe50d4830e45ba55593069a203072793dd718df164af33ffa0045bd31c00d150b52ae30bbf0e6cc10dbfdd3ff58e35a7de26bf7fcfcec5583978c2cbab2adb50b697fbceacf2bd5796f5ef9ddfbd6accceeebfbe77f9a979bff507476c789f3d67e67f3e8e6a85f0bfa6775765cb7fca14f3b5b8ff59f7fcd852b376b9ea4b7edc08dcbef9bd13f976c199ac451fb01d27533b25c9166b95229cb4596cc96b11c234b96cb9c96e53a4494267d264162ad55c7e37abd81891b11fc03ca7cf53c97613027a079eea1370ee190abe7b915c6e5545bd6c60ae74a7ef65c3713676e62ee62785acc2443354651e12352c862e1729b6c3b6cac99ef1e993842ca7c1365c9ae0dd3da74c1e88a19592ea91205121ef449d1c93f58740a89ddbb217fbc6ef26dfe312cb14a7416f8a553af7f4f67164241fb7de0284ebda00d0b7b5f1f630c495c3d0e65611a97c260d2381ca5181c55adc3a8ef5b8751f7819cecb459a69437cbf68c04fd21b27ac82e42905d8434b07ee25844e6215a460ad1cc051f7cbed7f087b7f4fc3114d26beb32c5589962ac4ceaa9c4873d1909925389243380b492abbc95255559c8d214ff61b2c6dbd9be24ccb542468165c2a84fd04ade41daf2a84be3b4ddd2db801fc111767df3e0e019b9435a5dc3772ec8dfd4302d7a28bb78dee3b1c13967bcb68bbbfbd4caf5dfefe99b35abaff7bb6bb87b4fadfcc99b8b06e7102b3f81adfc59ac33112d263aeb7730c2e42953cae2e46774e08de44c078c37cdf6313fb5592c4cbeb9d7e98182c4715a603b990b1321b022041d8e15398e636546e4785201d57bf3221f871c4ca02c0563ab04867918ffdf7dd80dcd648fd748bd182ca299022f4862465c2e5e2ff222b48e253ec32fe7afe779682a0f3373d1027636378246599111c88c857c05b39563590415f45cc2e9cf08d0addd853d053b901c97b332a7ca88e37c5c2dbecdb63cb4a7f224f9cbc36c5dafd94c262ff2b8e129d17dc617e82375bdc698771742fcb345e6e522f312da8976928e314efe9af997b0b7680c235542b5652be08b039b7d7fc418089cb00c07960608050bac38b16a0c2d4876b0c8874738b71dcbde41182e399009c3bd931c099c97abe632dcb9dcc5dc764e9279c91161837c92ade5ebec3d6cb77d3e3bdf36d7ee549003c71456e0b1916b7c0357cf37daeaec7d6c8acfd8e7f3f3ec0b1c67b31bd8f5f236febbecf5fcabfc2bc22bf6f784f7e4bfa3bf3baa1cb253cd38ec0ed6e9c3cb936df85bfca2203632f5a841a813173243688e3028ca32e7e00486008b00a5af9c0d7bd05dcc6e7d625d6fdd308c2be6caba56ba386223fa74789bee3979a0267d7d462105ab81f4f38d7f92f92d0cd9bda26b85812e95f5eb203d3f686c17c20ad27584ff4895c5effeb9f87cf1d5d78bdffc37ccec9a7e8f5a50135118ffd2e7cd58694dfccb9f57f1ef10fe716f711bfb20b6388919d0eb64c2e32c121f470e8e61c41883dc288e96201ec19e9ad2ac9593151e2fb0089f59408e52626a7483d807274eb072f16768b4b84ddaf983ffba967c53aa38c6d5c25e837ef8a6ca79dc7aee4ac42186e37a58e4c7a6ccb028cecc275b794edb748033b1df90ad90c6b603bc54aef617138fde5f1c237b0e10b31aafe32258c702b8ba8b7f5c421c59470cb35eecb963fa400d590dec8ee8eb32683f2c47e21f2f48087fa07c39fa7c127bd1c409bc949fe1256dfb81f80d98d6ba8ebd4f5844b086b954ef6b9f2de2ebb21c26dac47f4596c39ed9c30b7e9e17102ba85c8ccb728bb995dc260e6386c0917da864b712c7ebd36378b9e09064b932d95126b486e1002f7c1fbe007c86ec9ba2d3ada06e61d1a1e2f9c5d5bf63a77d83bd9fdd32f17dae1ee3e0c7c597f88d932358d235509945f761890a2cd97868ee31b9af6c8f09bff1f36bf96f145fba16afec841064ef14bf873fdd012bf3cec79873217b05cbb3ec2a848c1d210cb96d48907f4314176eeba27a61effc51f1af9f0841b49564b1d327dfe6f6f0dbb0db77b321723d8aaece52e7f7a83ec1cd20c5ee8bcd84271f549208e6c65f86bf10f9eab2adbcbddfd72dfbece9ee18d30dfc829cd1ed24218f3c4621574db4dbdddd9391224e12b622f0ab08f0c208f4ee239817021e47223d995295dd387a6e1c70d9ad3740f3f9e431fc0b0fd6084310b12767c4fba3406c157ac0d083668c4f7b8211329ef0f11e9b3d93245b035c9e0c9a09935e154e25138bf95a1737a1a626b21cc6859783d76487e59c003ad18da37f29d7eea635e55ccb48b796c65c9d9d91862d0569917c637a534fc4ed7267226e4ce79339f29294e89083a4b74e73b111291a09928f4620978ec005225e728148d0a0db119a454782061d886cce985d3cd2b22302325b307d00039eae2eb38347cee9684f02568d4673d1189a5920ab6d6a6aadcb168cc5faecfd059f4e01c8672d0d3da4b7e9301dc6442024d231647dbf63776da634826c19b8f7d4b027661fce0ead2e6c18bd291b5a54db995f3ab8bdada57bf5452b10736b436ded864cffeeb31da927577eedceecccbefdc887bac5802fb472d9aad58bd678667ab58a545beb0d4397fe4b7b3221d70e7c251852eba73da1d6d6b6b5de7ce1044facf7db980576607f76621ef862c97a735e31cc0d44f9200ac892cf9e73db19859668159af3e083d78188c1af20e925dd59e889284aac2a2cf930a57b889c4176a21a8c3900352efcf3d360aa8140acca30d03792e3e3d6ded0312cc42c79ed68dfed18d25dea780f167f7b2c47146e1056d4e5ec760da101e7a06ba4625dc56592edb47bc7c4b46821a6c40429313d91f301e18e2a60444ad048ecf5517ee511635a5ae9775b2c57b18479056789ba15db47942d31bc68a743b73a9fdec4c845467cb069c8a705807906a02d12a0190a1108d864606355a999dfd767b5cf649934f238606231f8c570941b28d095baedb9825b4fd4c899f8551f8886c9769d82ba19627612e9181233f3729baebc61d1ffc8cddb3870d33d4f163f7beadc6bb2cedd63f3eebdf0f1d7d9cea7fe303f3371754de533ff59fca8f89b96ba94e89f7829b7b40873013326dfe3fe89bf1cb385f32d56d3dde6ceba59b71aca3af9eaca78a23dc1262ab38c4dadae6e6cd0442fb4d661fa4dac281f39025b10c5c68672d832f45e3d79b467741ccbe0308e21d963bd87f324a6f967443aa28b22b9e828bbcc2e56e75c6e86ccb0638ae25032ee1c7e51c94f7e978799e1d66f2a91a8d6ef87fc42b15566f08dad6c441a45158d0e6468fade857d235a94dcea94b92a1d4572152322188da8c1fc00208f08598bb8b9a14c7dc085606a0a76e7e8290556e42829cfb85567285b809b632ab305c6a6ebb00d5e4ab98439c55e9a9dd201c51c999af3b5f1c1c1e1c50303bfdb72de2f673bfcd996fa8b3a6efef52fef38efde9ca3626975fb7064defcf97fbcf59697172c589caa7ed1d31cf257bdf1f4a13786fb5e54a6d95c2a418419389e1dc1881061ead08316ddfab55a560e85fc61a66ac0cf238c27b21d1a427ec8ec421a72438b53347af7c769efde885c0835d4275c708ecb4fce71c1075d60022e1ab95cae86fad32217c685c3d0360054eec4d6db45f4dfd4a0030037339eaa9e5eb7383ea7fa8a0a4963e528dc653fbd4b7c6b50efa54e8f2cbd4c440100690cc40fc66ed4e63f32b6b76c6a4850eb4850eb4850eb48445dd43a5cd43a5ca675b8c03a5c705d1758870bacc3b5b9deacdc1e3b3df0e8b1c763783a3691205d93bfaabf405685975590f548a3071b0f387ba2263d35b680c178ba388fc55eb82363cdb964c348efb93fe9cef40dcf9ef9c0caa5db07c7c6e66eeaffe13ddfb871e16d974c6bf7fb02c30b16bef6fd5b5e59b2e0ac69f5e8c8c953ecb7aab5d70effeef9d9ba95bccb33fc76a68a49a2098b9504927d2e17336d264e11c3281cf660678bc4145a3751680758a163710add2b45905627b08ad2d29c7491f65f1598090736c3016c705e68775519ddaf3f1933052dcda6cde02052b29f43744e910e43255a80e64c535bb4943aa88e56ff98bf8f97a685317989b43b558660d1897d2a0612bc0e525cf3fa32643dfb31c843d122e71d218b0b87236469eb9d28128961525332a81835b43d2331cd79800607c8018f602100c77a970cc6e3a32d2dd916947451fb7251fb7219fbd59411975b371b8e9a1947cd8c33ccac1a1f91cb72606c1c181807c6c681e1719b9ba7f446fbf486dc3163544cc7a4a4c17292bad131d8ea5cc9be025ebc386d660156cc78cac0890e2bc5198f9b31384b20e19f32c7e9b3cc794aec578b9f165f4355ef6db8abaf2f77eae4c107665ddede3537e448acaecf8cdec1c6ab12eb87872e4c36358b1acee802c88366f7e5728f5ebfeeb7cf56044349df61a5dea1bad9df0d6fac6b6a6e49365f3c0fc7a24a6c902f89554c18d5582c31110ee00c241b601cae591e59f0088a6cb3312ef93607a332aac7a1b9a09b0d78540b86064cdaa56f64c3076043c7c6c99e13f75f884d91a2064e5cb3c73adb086dc60024fb7bfdacf92d72d977a831b54de5e0ab2821701884204477116b8ccbed8abb381768d045069e0031c8010085de5a678d9b81926e1f3c9bc37dc4b8a3be893ebd9f83704c24e18461027cb6806fc8e39a55805b22558e83c983b49963946603fae45f4dba0b0305511ffb923db262dae56b51a6f887b11d3b9e7c28b5a6515865f35cfcbdba9da7b2dcffdc39ede9171c12f1fde2287704fbbe93e9421f59245ed324a0463e57c7339abdbf52eaeaf2e5da94464603ffd55822638d94116b8878352d9dea94e2f0bb38c48338344ae31015e2985a826fc7e3e954c99f0f9aa90cdde7da057f89323ad3100d668929b9cfd9171d1607e505ceabd0551db65c176a0bbbd4cc824a64b943afc1baf0adee9ffcc8a070ea08bd6fb513e15b2f8b1b9ac5cd350c1344319ad6bc9fbefdf048b346f4d84c8247047226185a6a063f6cde94eeec94a8874b746fa491d0ecc3694c9cfa789cfa78dcf4f13858481c7c3c0e3e1e071f8fc3b5e39b2db3da7a95bfd4fbc55125af8b2b4936db81c0f2b0251f828b466452c7e70a442a953885211268f3e50a6d8a59f4ef82bf90c858e208b26ea24c93b0c37acc9893e9f2908dfd75f569ae61eee5337e70cf55df5bf0938943be856da9b353cbafa88e6bc3376f7ce29d3306b2f79fb77c47cef1eb139367fe72216a63d75657be70f0b127a717cf94a34ec5dddad858185c3d904515c87ee32b43f3cf68ac6b3f555d3c52fc4c0b1e244cf4db644a0bf395201ab7d8a2e270cb033ede8590ac90bad5094843c894e15b74caf0042d799a4ce5881e80100a87dc4efa19a762a62e8a68842c3d75519470a894ba502b254c8510f5de4e1831e602c1c0d600e7568cdb516416b619d35482b5a4126cd990d5899c0243331a03ba87e91aa27ea827e8dc4434b88adeb366ca0291d9c9c8d946984d6177e95906a2f97403ba7f80c2914220116c58811c45812f5058c88968be42ded40f68e2a26c0c9921468f3065e4174a80597d2f273638c5adf8e48182210d28f2658d3e648da7b417972629c100f7d9981a089d396fee8fe68d8d2dbde7dc7f7d8cddbee8ba86a6c6a1be53077052727868c96bcf625cda81cd6199f047b2730fbda77781a89709f480a35220db96fb95d3c46e7243bd73a4cff4d1038e1e30a5a69268a9f25a2bbeace5189dd654b20973448e1590cc93a6471d54d3198185beafdd32c70afb82041e6aecb0b5c798c72a99f3f15c08ec5906dacdeb5bbf0c7b7ee161dd9c2dada8c3c9e42138701f023bd5f7955aee064720374c5f9dccd511e5f3bb0496bc23c00497b08a015361b4c568371a47cf211e41bf55cdc0942e311d32f748a81b3e022342604488274644ee65b1bec7fb370e3593cc9b374682db71a3c502b745bb5af47fd19c5d14e614f41b25212d6b4cc07665c893d7e68f8d292fbfcce7f7ff168bfedee2287a0c5b42808920a8c9e53251207e0e144549c485e68439df2cbf20498e2ca7f863529bc44a2191dcbdd161854d58a15d41a21e00856050f2735e1c0f4ab6e2b5c406af51e1f2eab3ca70702207338a5eed5701142002f5902f08b82cbba3a9eb06c0a78922497100ca233a2dc607af43572ab0295a82f8bc3eb918ead2291be603c69e6973bb873f1c9a5308737edfac025926e7c81638856e9706c909fea9cf7020c3b020cb470fef8d2daa7304d3e1a1f3c341f569743d7af9e5f8134f89e2cf05dbb486da8d8bb95b776241ebe8cbd761f475a0ab2de8ebe258d9c10b76414248901d381e3e0ca34a76c4d0291a9801d59f13c008647fa06ed264a6fba431ca2d1a03104f4f1de526684b52e8c32f13b01dcf66a1bb10cd451ad857d11f6d9c0dc550251b535ad07c7405da6a237730be87f43be8fe1c9938ce7428323a061d2c796697867529dbf6b20e3b679759f3ded925f65576d66edf4c9eaca6204691394ae73883ce29231c3805a7091420040c8dfb0d4cf838e7237a17c01904700361a3d31a9fe1a16c98d5e9338b46df8a3c1aefca4fc33c744be471264fda24f92d18402db7a7a3a739c1a8a326ea427cdddf8b2b178e8da1c78e16d36c747eb145f49fda825e2db6e0657c0f2b6e3ee95320a87fef29c3c42f05ba2f01b42f464f0a747b590413d3ff97c025f056e082a785e1bc04aef94530b40fc3d06201952351f4cb904820fd4b1d86cc6fc9ebc334592bfc44f7c017eacf2683874b61ac811626b17eb10733e156f6168bf587ab12f6daa034501f1c48d4f309be4224ddcaa8dc8aef0bdae0ad8c8b1eba548d1e6a5168b2030a30b221afa2fe1806a6c9183378c1982e685361bc17e6c94076a40f0f7363cfe973636a5b9410067242d41cc98f824b4559639eed1938351a6d6f3305e0d1fff594364ae87f80d390e681fb98a7abcbaba73fed80a9428dd014a80934d5d5d435f5c6247b6d7da44a0a0ed4e3850b8c1a955ba8bfb418fe621f6901edb5680cf4034a5302c72991668206d33935e521234749071a1fdd6eafd55cf4c22ef3c22e594f975582222162032a5c4905fd1319e157cb7333d42a8d5e4433bd599375661fa55e10a57e8109a9e1d651a868c0786031d74cbe220a3d8b287c360a75dee8ed8cea56e3ea4dea6e5550d5f6b678fb8e767d82236f42396cf9709b5cc9d3db7bbcc49c301cf4418a57560ef28388135222385030a54c90e020e479a57250894d413ba19c5c05749e5e6a3708db9d3effc2ecf4ebe6216e0c0e675e9f1d1b5bf8c3e517fcb861d94f57cedfdadcd2c15ebfe89bd31aeae6cdf6b4c52712c64fc3334e1de0f3db177ee59cf52b57b77476ddf1b5890465e6d83bbe98998b5fcecc4ffe9f3373f9ff95990b988ba232668e2ca639b564a81825c3ffcfcc5c293173d9f855897d8b74844cc1a43df225a47d2a33effcc798b9f0bf61e6817f8099638b00628e9979efe4db7c0c5b828309a143565b08643959cdda7827e315addb0c3ea4f1e26373fa888e4abf908beb101816a1782042f14084c2a018361e5147fb0991f0546433c6538cb6785d043a4911281dcc70a5dc29ff8ce0906b8e7b8e7f28087786efd0ee2c6bfe943f0cca18bfc9b9479c51460673a8366ce12dda403d690c75b9755bb05e8c29c33fda49728c305b22b108f2d2728197e62f5ec332a68d78a322581f6d4140db41b36c67fcb2b6c59e117173b87ccfcb942d308678c8833947c963fbd46cc1c673816cf963fb18b2199154fe182e552a0af0b1e2c7ef7c50fc14f9de7e07b99fbcf3e65b76edbae587bbd8d6e2bbc5c3682672a330ea2efe5bf1bdd75e7cf1b5175efb77d2832caee13bb075b8994af481c53a3c0e91f30fb8789b10cd7136d9e9b15ac8fba75988f98cc437e9b6ac5895232451b49064132d64400b99a2852c7f690b12aaf1c0c7a2b9166bd7318d66783b2a67a3216fae72b9ba4e95a7de6bd9b3c43c1693f158b4efa150e2899a11ef757383b36135ae92d59c6629663b531f5d65b6c4f08a299c48144e2433d197001b240d868d20d197013364785f86b025d3b027d3fc5ea68d490a229d65ed8ba4554e466fd287e5e1f20f148844b868ae40640233898028bdd480eaea4d34f172d65625df51fcf499b3ae9e3d3636f7976bc75f79f2caef2cf9d1ec8517ceb9f9a7ec70f183e243750dc566e1bf2ecb2e2b3e57fccf275e9cd7337143adf63274268a6ba03ae963e26805e47e8dd5ba7b7333b5f68a99f1616e489b5b311497bd02ebe1c339178f9c550382cde367cbca7d5f568dd10cccff28e7014de94c346e0c6c1ea106fa31354763cb2ab3a93a4a0bfd51ead751da488a46e520153b755c5977dc5c0f3e02558189c8e0e93278ba0cdf2a030eca61306dd83e20078dc7cfbd0fb9a3bc3951b665d9d275322948274375983552481fc8c715ce15888484aa818260335a4ee42cfd794fa755fda6769acedcb9f2c03b8bfb67dd9f1ff9c600692e6fcedd7ad7d5372cbeadb8860d0e0da20ee4bee98da1054b1aeadb4fed67b7d754bcfcfb832fced1d903fb2a9f67bcc807598add7c1e807e90abc091cfadc4957685c710c5303bf81ff02c3fc7ae0a366393a63703136bc6e4bddf591a1e7195bbc8c323926c6c8a3ba927ed9266ee932d3d88c04cea6cd87b2099b781f7d820a3b0e969076cc129ea4063731a5b729ed6b7e46cf459776c802f91ec0f767e629a97ef6c83a1c93c3c7dc705ab52f939057d4950c587334a557c2b93635fb507da12c3b7619f59ffe3f995955eee16911be83ff51e9fbff7dc218efc9798674ffe85bb98dfc674b37d169cade8f0680d7c2593484c9b55c9f3bc6316638b7b6028d6d341280c5954071832595407fca683f4eba092dfd1d193e11a341eaafc3093a4414f5783c56b34186b9a7526e96089941db43cb352cfe3b7e9c3483dfaa306c2629b160eb4d5498d35dd526fcd42763036ca8e8697c696b45dc8ae8dad6db9a0ed0a766bec5bb16fd50423fe48a8d1df189ae19f1112fda1d0de64ab3f996cbd2c7963f2c6562ed91af2f34ce54d09645d2a1727ef737151f39481ec1782f69e114fb4c378fa4e8701173a96774c7e6c9ede015c9625423a0eccb0c3848b0e98ecc6326ba018d040f1ba81ce2a37443592cdba0299d260825bc7026d44f3920b6a30e0a4411549f3924b6a9607ee24cb1ebf030f072d3d19340fd3fef4c1eecc1613b343867c1289ca69b30a443c8c6316edf87dd1ecff944728ea3de72f1fff47fb36ff36670ff777b77f6d56cbba484d6c41bef6d28eab2f3df2787e2c679fffeb73f2570f2f6d5adfbbfdaade4cdfedd1beea177dad916075c01d4aa566cf09d9c2ae693fd978fb81d69adff70e9cb178ee60d01170c56eda3eff9ad6ce14c9c6039347d9fb843b99a8f184cb699539a802c46d8e0c8e65fc2cbb2484c3fe2c63cb56a230f94f18c41d9c836619f02412c8321c8e4abb22925cdc067452a129a2620ef42800178a26a9624c8c739cc8d5410f9666021cddcfc3c13e3d685d3b8d9d9a45c002ee8e0a8ac99df93efd19976e1d0bf2a45f43ca7924f16b23f37900c7b22c29123fab00ab60fcb4178bcf83a4cf98142155bc2e8ffee01273f49cf462d1ebff7cff8e1d63e89ce2bda2df33dcdf3ae273a4bf1afcd5e3ecc53b517ff1899d13c7969dd7505313b5fd42f59067af4dbecd7d84f13782f65ba71a19435c114250bce4282c3805248758ff80600fe98f68803c8e3506418aa765736fd16c2eaab91c66bdcfd877435999c311d50c9030e74092e3740e4a7f42d9a3380f1fcf550212cb57c957d82e0df28f08286cbda1ff6ef4639f91c64159b744c94f58c8d59b7b4f4bf1ccb94812d8c98448b4d4c1174fefe01b2509078d270eb388e0a0899b036a070e28b13b808439366a65fb9ba9ad40bdd010429fd9c3538c150b987109e608d8413a125273fa66044f17f7d1d8f29dab165cd3defebfda7b16e838aaebde9bdfceec4fbbfa6bf55b4bd6c7dab556d24a5ecb96a535b2fcb7e5c8b66c1964a3bf252f9222c93f0c211f929e129273da0249803609c909f9014d6348708509ad49521ce7104e4262529ab60162d2b8244d4f428bb5ee7df7bdd99d95d686704e4f7bdad5d3cedc9979f3defdbd7bdfccbcfb5ecbbcaba0a07b6bd783ebe76fdbdeddd0dcfc17ef957eb47067dfd160a07667ab7c036b5b1a3ecbf7138d6ec5c88302a25dbd9a60936219022f59d8ad99304e8ce05c147c7029eae6c3dd254d95554967efed78f40195f09387a4fa495453fd7254f1abe6ac7522d6a02814f0bdec2bbce02bf2881d8b3dc0ef02e843a1c594ab8aaaf900f98755aa2a3e59920b49815c4b6ae44fd22f5236cbe62fa3065b0380ad0620b32336da94b023161f001861f7a1ccc88b60bc01cdd2cbf5907e489fd2d537642ae350413914e83767b0eb48449b0770a47b3fbeb94d093a50d3041dc8bf8bdff8a5f8c1f3b4898694feb73ea7f45f79483ec8b85e4688fa0270dd497f825cf76220417286e22b09aedb4c69f03905cfa64e61cc1f012cec7f422e14c10797cce0834bd1650839c09a418b36540d705575e2746836fc1a62d32d236e5c0ed3af3b1c2ec59ccfc50e007f616938c523d6bf9d16c00be259cb32fd397b24673fcfcb810b9e97ad633c2ff0f78dbc4310c0966ebffa26be4bc157c7c7b08d50c0d1a61986a398e66979b602a3c811a475529552ad2ed7038e66ba56dd40b7a9fb689fbacf314e46e98434ac1c5687f50963d87ec4719b34ab9c508fe9b71a73f6938e1a227be41a5976328db1f93455d30d079180191aa89c6167136fe23c37a80eee2c0c79b8d9ad683cc40e83ea3abc62859b05f827fdf800cddb2d0b6db014873a9012d790039a90a3be107ff5d1f81bf1df3c12ffe773cf52e301ea39c33442eebfc2b4e2d3f200fb31cdb0437bfc15688683dec867bbd6931f2e25b02656594b4e8747e39f3caa1924a90e5dd1142661aa2bbadd90349b44a0cdc9ba94eb6691af90159d94e4c2ef14cfbe0ce211ffc42a97e2e82ef04aac992986245187dd41ecb2ce0875d8894d0275d75445a38c79a7152357510c60adedb44673c11f211a3831a5ddb069aaee502585d8b16f9517b1b307542ff6ffecae90eb906bca256bf729e62cd34a28f08a988a0ea7eb68633126008a580a31fbe91fe99e363dcdb6b1a14f61c87b38279238e04b54167372ce9cd103c5834127f2af7e11ff4dfcf51fd13be3efff0575d1dc17e3ef63cb02497552387e903eb4f012da4978fa6476d246f3448bb559eca46ab193b6e4f4e4aa701675bdf95aab769316d39422b99a4ab2c2d445b2d9b3a061b6dafa6ce336d9c6d45353f1433d3bbd4aed5547c17cfa145901f3a6ac20d58a92306db21b360a3b2a304d1ba8319b605672b2f80d85087e63304f91885ccc326896516e848c43c694a1bea15045845605849af3681ed3cef507bec5b73aced549fa29d7782351558abae7709bb7f0f0df7d373e711e1e001b94feffb4d117949a2bcfca6b81ba46d0ed51e0a1413ecbbf4f292ed7593147aab078d00f1eb751d9a6eba7c55a1e7a3bd56d72bbca96f07a8d87a9198a018295d99c27af3dce23fb58cc82911bb139241656882a0e26281cc0f6cb26d307d7dadab160ea91589c26ea96a8de1e830a54b99d4d18070eb615fef924422cbc248f2e9347af9c97362f3c2f672f3c2ef57e548e3cf0912bdf066adae227e4635a2e89904ff139430aa0ffb315baa412eb97faf45c6f9d5ee55da3377bbbbc7dfa5eefb83eea3d5c36163e51762c9cb5a2d679d6e5a2bef9221a99a70ee2c735b842e5796a2d3ca7466ad55a27ce2b1fc2ae627f5b627a3b7c15c350cf5b51eb729e8d412145bef958118572121140c97935a187d0629dc31f47f4405f3e9c2782f9c5da0b620500316163583e36f7f5f3beaaaae3fbf3f2f61fafaaf29dfffadcaeb5bde5fef2eaaa6513adade31555d5e5feb27d6b77c54f3c7bf6deaebb9b9ac20f869b9aeeeebaf7ecb3771596964dec78ac67ba31b8a5a0b0604bb071bae7b11d1365a58584d2e6f809fa538ca5e2313ace2cb55b051303a89753b1fe129b9a5aac2084dfe81c89e58fbc61fad3871f66a15922724a7e1025f00897c04a90401b30dfce249013ae0ab78437846f52f6842794d1ecf1ea91f06cf6896a67493139bb6a95b36e3e405df34e4720e4a44e67655e7983ad983d9dd95d91625b31ae6dc4a72e222c8e374a6e262a09f507d2496521299592e255e46c0c8a0fd4cdc702d4e99a8f39d348c5e47d8a54d8e8ca16feb8659199452a0fa615c6c432268cf2deb5bb1242a36fbebd30ee320507760c639db4bba5558485a3e693ce38218e2724b266755173150db49034795efc05cfd3da2af2b0e881781f460face5d1dad19c9491fc757586338223f4a13fa6adcd8abac1ceb1e1fd9134a3fbabdcde8818dcdf5a452ac400ff50287c36e0aaaf5f55579b554bb40a1694cf8484a52ec771ffeb0eada3be62adc8f20dc1976e1ad4697330d3e57e73da853636edb7187111e66bd12506f5639c507f71b42c31ac5fa0c587f68389099f8d05124331ccdbffa0a1fef8405d991a805ff176c3ffb79653e5f37f52355c6b14eeac3db89f5257ce75a201fc764f73e9bd4f3a9d9f711474efcb5e512431d9e2a86f94ed6694edc7b209c98e3aa586fa68bd44ea57ca2e90707f4b9a9c9d595c0b56ae949da6a62ccef3a29be7a9af1779e059e239d81818ab67278fa1ae94dc6e4cdb25fd24782545cb32a2866418387649d171a4019f8830ddc800277dbb61077c400a651368a51f1ac0671d67b18c6c146e1b9f3fc70e756b1c096681c2cc229f4b8c4d92e5ca1c1c32f0cc273e7ad79f3dfa73a5ff34b5c5ff839e020ee0333672603fe79297718092e2626791682bf419355f1eb3462b6ea2bd64941c238a2ca78d5614d3bc9b4b75c963f137ee850619bf8bc72b8e9187941ce5183cd1b9089f77ccd327f7d92525eaf4441c6c832b3bc1dec51a8b1f00990da9b3db6d73ea9c13fc39292758afd3a1dbd857155cf1476773deb389e5433cd093cd4a8f2ba18578dc5c7ff137cc62103bbc949c8d5f1593f2e7c40be9a5f8dfd275f19eb844e3f1c7e9b6a7e9e7f6d287e6a15bfcc6457ab68f3e752efe52fc25a0e44340494850722752e24812210922d850b3682d004edda9ab2a3d259f025a65ba8bf451b6bab7dda197d3725b9f2edb680a319c0c2b3549628abfc14aa3505c0a2de65cfa7ca78480826d40413cde0654ad03aa2e4937c76f3847ab69f5b978e7be78ff3cf552ef7cfc205b57f26bf0ac7791fc0cd71d7090285fad4ca592a6d8f71a3a09007302f0e4103070cd011edbcb5f973a309761df1b33f8828bbcebda1256cddfc5ef7d6fe105fefb19fb6373095c91da9441e9ef9331b44f2f8da17d3a358676f0adfb9551a9ed336ce524f955fa6bf4cf1bb94f25f00059c096322c04e32d15b245f49896802e0ea1281c1eb628145b25b13fc4fb8ec55fc7cbe65289ac63f8ebf85b77fdb996bbf0032904f22d05b69cd1ca880f9e837f84fca839e5b8bd001e6f68c98652d9ebcdeb7011f93eadbdc880077cdde35168e9a7cba8af8c47efe07718b7f84a98980bfd129f278d107fe17d0a7fa0872716c56757598f308b4f266a7e33503daa1ffad6e0ce036deccda9e715f162b58d8d83c101f8f0e0b1f00a77057c06155f69c98618c3ce95d71163f8195a7b8c63c803da03af72d39f9cbf3339063f2f3138bf85ad4270663e7e800dc5ff54f3de12bb676bddf86ee9f073cfc9e7aeb4c9cf3cd8fac40b0ee5ab9af796636bf8583cc6afd3c0af52f23c72abf188ed944db215516756bb91ad96949694aaeb8aa0fbacc33315f591420b8724f111d5c2a732f111d5b8cf95e529f7843cb2c7e3f2e598210b6c0035064f20dfb210f8563272a23f956181052fe716f393f86693732bd7999dd51e4b601745f4904f3e9ef35c409852c118e8912638667e74924fcf1777173ef4c1df5e066645d7441e1b6efb78eda07a9bac1cb93bc463171ac7ee093734b915dd1cff862ba3e0ca1ba7d1705fd773a8efd8735c7f50197453d52543c900134a5e52bdf287c1ca6b7c9682278906cfbfb96c954af64e0a1e0555f56699ca8428a6b137df35153f8e5765d31261c7119d8efce14f3ff9cd075ef9b9eaa5e42aa1a7580f75941c506e5476828dc9220560c86b4808fac51d6413e926fbc821f00e53e438b9837c373a7438b66bcf9e9bf69fb86d75dbf45c6df0e6e1e5db373bf50d5185e8904afccbdb82cb9707dbe4fd25cd0db91e4f61c9ceadc76666064737def0be5b57354d4e64e7f7f44ada9af65e4815070f94f90edc3a71e0c0c4adf26885dd5d575f5f5d314a42ff70a13574e1f90b5efc4411f23c7fc173c1cbaca9e70203ad3fcc47437ceff93ecfbf28f392fcc0a1dcca8a96e670538dd8e7887d81d89bd76d8b8e17ef175fb7e5a71e572d2adfac4ffe61437373c33d6cf3fb7063b8713983e29126f87b24dcd818967ad876c1c74e481f4ae45d78b4a1b9a969396d6c6e6ea4df6117e337b1edef59ee7b1824df079b06388aff381c6efc191cd04f00d0cb4a3b051bfa5453a865613340f73634344b7e91296e03e012bbed627343733d00e00bd878e927410fbd241a5d512d513e4cfa01fa15aa66b57b544d333a6497a75c0b6992e6d1dcbec7c06d4de5787ed77f198391d8b4bb213ef4f8bd38ac98754cc34d113ea4983ef99d331bb73bdaabee0d553d473fe2ffebef39bfe8deb1eef3f23df87466f96b14564c6d002bb6925444bdd90e777b9e5ea52acb3aeac0347874f01f1de1cb4d1d61d800f58b8299ae694cf909b5c112e114bfd90c721227bfb024e22919f5f4553cc903a0b867d2f201c7100993ba687e637b98da35b9bdde55a6d61575547889ceac3d2099c4952dd624ccfddb6099ea03b47ce603d220bbc8273c930ee1541781bcd5bc807733a98ee6e4805bc8376a55b5b2a3b9c147bc6cc817a26ce1ef62bbbb04f51ab86a13c89be658f326cc71fc10e0fdcc13cd4375f69260a8ea38b49787d31a688ef9f91f00e6769bb1aae5ee6aabc52ebdfa4bd50d7847484d34b7daaeb557bacad58a8ae28e1c52df4188ce100f5d462d1488ab15f5524b12dd762995b3e607b202fe3da45dc2072ba57dc7c93d41e475c34d77ee6eee06ac77944f1ca45fc0cf66b29cebdd7643417ded32c3b12a961fe8fbe343d2118ef8c8fd875b1440dd98fb5035b5c77fc73ea6d507eb2a2b758753e5dfd33aafbeaad568a5e476686315b70eb61fba5d2572fbc13e52dab2b36b8533bbfd3d8e9dca44fbdc5c7d4bc7ca150661aa13f65c4682bcade04cb82e5d665a9ffcbaca65c085905b26253fb7ba65688696cfb491559176b9a5194e253ed546505c0ce2ecc92f48c7944ae4247051f1ba5b2b6f1cf5d81d59f6cafa9ac9aefe6834bb665d9df8625b7643777feb7b0706f817de998e5063932fbbc863ab5ade5fbdbab4a5e8fd7333b3f3fe2d3eddd9d4776a6bebf88a86baa54cad6702b8e30ef563b2fdc6e1bab6dcc2ac2fe77adc053535dd95e1aa6247e2836f51b5cf5556263e10dbed5e67416995afb3a2a2c0eed05c36f699f8d021432de8f2771fdd519deb747be3772c160917df836878ca459a249fa5bdd2764c47a5f3729dfc08a47f545465a5b25f6d56bfa2b5d996d9fe4a9fe3c938617cd9f8ad7da3fd56fbf71da38e51e71ad74177abfbf5ac8359e08bbc8f666fc3747fcea9dcdd791bf3de2a585ef0af45cb8acef8ee297e4f49bd4843257f5af25c696169a4f460d953e517fddf5e76b1b2bcf2c75565d59535b5352fd77e63c54d75ff12f875f06a7d75c81e3add58d9f85cd30fc277377faa6564956dd564c48884223f4c935e8bbcc9d3ea1fae7e7df55bad2e916e5b923e7e9df4c4bb4b6b8ad77c70cd194bba68a6b58e25e9736d91779c3ed0f67826655226655226655226655226655226655226655226655226655226fdcfa775dfb2a47826fdef4aed5a2665522665522665d2ff91b4bffd7487a76326da914999944999f4ff291142aae8df109950452612711282b00ab0071283353cef47d886e78308eb08b7216c1022e593ed02a6c4290d0a58226ee94d01cba4417a51c08a258f4a0a59d41fc29ae5bc8dcc25609dd49103023648895c266007d928af11b0cb5d28bf1f61bb851607c3d3fb49849d96f36e067bbf88b087e1e9fd26c23900677bbf8d70ae257f1ed2cbe17ccbf922bcf7270817635dbccc524b9e720bbc1cf3bf86701dc2ff8ef04a06674b0cd62df8eb96ba9c96f34e93969d648acc905bc80089914972128e06c949ea222364028e5f875ff2fa6e3207fb49320cdb19322cdf2f7f4d7e4a7e1a7e4fca67e4af922f819c9b48036924ab01da41c6c910e49b22b3f01b857bfda4134b9bc6ed009c19076892d4c395f5507e0cf633706e8c1c866bb3783402fb11d81f83ed30e474113bfe36c3f1205e3f0ef9baa1cc1128690f50c0203f68d300527314eb8d013486f8f8e13705794e5a6af227306f206180aa134711d0563fe941eaa7212f5b498d71809531448e88bc5be1e8309c65578f0296b309aaf6c0f971a424764d7c46911b7e72031c0fc21576760079914a232f674a50eac75a8ec2d521a4d7e4f171940d3b731425358265cf011e2328932d8013e3ce38de3789dc5d8bf78f608e1190f520f27a18b77e819199d78fe76751b2e3808b29c3241dec3ad39371b87316b8b007e0c3708de99049c500e2c47460186b64381f41ea4653b05daa4163787c146a36730f61d9d3289771c4ad3eed9da978f440ce3128278675f7229f6613b444a00c26ff1da8a51c9fe3a8bf2cf71ce63e8c57a6c91a1282741c533d94beb8e67a816108e093a8fb634839d3a79369319d45faa691f35c06a388d71cea541fd2ef473a4ea29cb95ce612ba66e666e7a690434c230610ef204a88e59b163a1944794c623dd328557eef902865441c0f60d9d3483ba3720eafb1bb06110f536a8bf5654edcc1b57766c999d1040dc177a401d3783c0cf70cc17150e82eb310bcde60a29ec5148ca36c8f239f86b035a7e3d97141e938b6f318b6686e7b96f29edd1343a816f2af48693fe94be738bc5bde5a5b272b692c6123e750724389f6988e02b3f6a578adb5e800a384d33287f599d67a065bf449d41f16b13189566ce09a9472dd1b48d12a6e8da6c49653c5e1a3d896b87564d89ad234cb613963d8eaafada3dc8f4c0ac9244b375bc8b8e0f20cda6b666dc7059f937e658fe034a32386141e4f703a55b383289d018487852e2cb5b48b5b43ed22bb31829e82d57104ede9084a7600ce312e8da165e1d742a2cc438bacf70ad18293166336c135139b3fc43fbe437fe42f5954c676b30c7f6942a327e01c9795a93923e8c963c28f2535fc7a3ed6d4cc6bfb59537abb122d68d662cdb9dcb9368c88fab80d9e14f20f22dd33c2079a7ee5306afd9890b5a9cf5cbfa685c7e035b05e13f77993096d1920c9bec662bbf6df208f0497069076c6bb7161f387459b1d82d26f116d25d9fb6235b096cdf5a6d6c4f1daf20578776a6f0324bec2c2a361f436b1147bb394c6eb948756781cef3373a7b772c14556cee4fde2bb19d7b85db5d26de295dae7e434243d9229c320dafd29ac6534713c62d11066bfb88466a1b4a4a7e5580f222e23c2631d4dc8d26a4fb80c4342e2b3d85262091cccb69daa4bef9cab564fcfa9b47a9c549d4e72e2b8e835bd3b399a5e81f554270567462c180ce396d599e4cb04e418b2f890b9ebd864ee01869102d3f3ad5962cd07a0d429b43ce9fbff93e82f4c8f93e491e9d5927cb2da95d4bb66d15e70790d0adad3fbdf816b487526c18159f1a435876d3886184c61cf33e9dddfad16587ddd66d28539bac94638da07deb307cf6c81737eb0a63d70a5178e36c0d90d70a60672ec16d76b5062fbd0276d867c7bd1dff1327a60bb138efbd0d66d247e3c6647db20ff4e288bdddb45f6631d5d50da6eccd98365ef80b3db61df25f2b13b3ae1cc5e3866f026b486bcbe9d70177fa2d922fc23c7740f9cf727284cc56a0bd66862b6038e7aa0fccde2ea7a287b0b96c7f067f56f44786702cf8d02d3f5c82356322bb31330da8e47ecec5ed8ef827cbbb1fef54833c77627d2b011ae735aba10035673bda095e763fce91557988c187edb2125a95a8f3cd88cd824f9d709fb5d80392b7f135cdd839ea21beedc8094ee46ee75099e316ab7e351922a2ea94ea4867195f16003c03be0b729c1bb1edc725c7a2ca5a5f26e1f5e4fe6e2f4ad17db4ee45c371e716974e2d11e9415bb1a14b2ec413a16d7ba0f35b10b73ad478a77273464236a2fc7ded44e5e47b705135e1f93ad151753abfdd76923bc14f3fa5e21e9a57c615c5f8f3c6178ed4ed47cad9279fb4cbe9719403f611eff13bea71949796f3392f26606dfcd28654aa3b24dd9a4ac836d2be41e00ebc7faeadc661da67f493f2b13b4a1eb21ff0cbe2d6065b0b743f877b5977c90a4ffa3625f0b3f6938363926e0da590eef62f0fa9981c1a07ffdcc2d93417fe7c99958d0bf6966e448d0bf79647026e8df3e3007e7f71c1e187fa7f9fe0bbc7ab0930d0a656e6473747265616d0d0a656e646f626a0d0a313638302030206f626a0d0a5b20305b20313030305d2020335b20333133203333322034303120373238203534365d202031305b203231312033383320333833203534365d202031355b203330332033363320333033203338322035343620353436203534362035343620353436203534365d202032385b203534362033353420333534203732382037323820373238203437345d202033365b2036303020353839203630312036373820353631203532312036363720363735203337335d202034375b2034393820373731203636372037303820353531203730382036323120353537203538342036353620353937203930325d202036325b20333833203338322033383320373238203534362035343620353235203535332034363120353533203532362033313820353533203535382032323920323832203439382032323920383430203535382035343320353533203535332033363020343436203333342035353820343938203734322034393520343938203434342034383020333832203438305d20203130365b20353235203532355d20203131315b203436312035323620353236203532365d20203131385b203232395d20203132375b203535385d20203136395b2035373320353733203831375d20203137375b203534365d20203138325b203231315d205d200d0a656e646f626a0d0a313638312030206f626a0d0a5b20333133203333322034303120373238203534362030203020323131203338332033383320353436203020333033203336332033303320333832203534362035343620353436203534362035343620353436203020302030203020333534203335342037323820373238203732382034373420302036303020353839203630312036373820353631203532312036363720363735203337332030203020343938203737312036363720373038203535312037303820363231203535372035383420363536203539372039303220302030203020333833203338322033383320373238203534362035343620353235203535332034363120353533203532362033313820353533203535382032323920323832203439382032323920383430203535382035343320353533203535332033363020343436203333342035353820343938203734322034393520343938203434342034383020333832203438302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020353235203020353235203020302030203020343631203532362035323620353236203020302030203232392030203020302030203020302030203020302030203535385d200d0a656e646f626a0d0a313638322030206f626a0d0a5b203630302036303020363030203630302036303020302030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020363030203020363030203020363030203630302036303020363030203020302036303020302030203630302030203630302030203020302036303020363030203630302036303020302036303020363030203020363030203020302030203020363030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020363030203630302036303020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302036303020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203630302030203020302030203020302030203020363030203630305d200d0a656e646f626a0d0a313638332030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e6774682033383133392f4c656e677468312037323332383e3e0d0a73747265616d0d0a789cd47b79409565f6ff39cffb5eb882c0659155e45e2e9b5c70c705ae70117081545454104d1051ca1c2997d446a5c516b4d416b3749296692a332f68854b6a93edda9e4de54c9bd64c454da54d93c2fbfb3ccfbd17116bea8fef3fbff7709e7d3dcf39e739e77d2fc444148c4027d7c429fd078567345c45c47528adaa59585d7ff79ef016a2842144e2de9a654bac8f05d746100dae22f25f3faf7efec2990f540713d9de20f27b65fe152be68df8e94fa144d95f132dbbaeaeb67aeec915414f602ce469681d0a029ee023183f09f9a4ba854b96bf71e7d32b917f8928fe8a2b16d5542f3ab87e1551733df2750bab97d787f70e7c06f563d1debab07649b5d664aa263ab744aeef0fd50b6bb36f987c25d16b7f23ca5c59bf68f1928e149a8afa32d9befeaadafa5d87a36612a56d230a788ee45efdbe5a4b2317d4ce0e719e31f730937c1e4c9e542de3e3fd6f0931fc7fdea89f353b90eda1dacb07b1dfa3edf78048c70c7f63867eb6b3c6f768b2247837359085c6222710f7a70a547c8979056a35fd186f2413994df79a0663c8784fac55d33c116632097fad871026a1eb1f533fe3302d2f502bc05336bec04a2eb2261fd5bfe8582d5722e6bb880dc340ef39faed72a7d44b3f46f3656bc472c15f7100eda793c00efe44cce24cfa9436b283f6f131fa9c4ea166073d47c7e90887d1dbf40587f3311e4e73a896eee4707a8f42693aada1fba89cb6634f0bd0630776d340d1d48fea6837b09cf6d2069a827d265329d5d0bb62247dc64e8c4c7c803652267aac468ff768154ee419da4387b09a5e74056d425d036a5fa7dba99272683866bd8bdaf82ee1e43bd12614b006e3cb99a660a4f3b003fd3cb0cf0b72341f547ae11c4fc22afe481b78915ab5220befe73ccc1386b52ec44873e84ee00c72938386d25fe8134ee3141a89ddd4d3e7fc15f6790b35632d53b0b335e827d754070ca34dc677d8ff87dccec918672b565e03cafbd3025146c1144e674149077d8cb142b10789e5a09e07ea144c51b08f9d98d3c9d9608e66dec739fc0ea8370d73ee0565dea536e134dae95a8c7e17e6cbc4e905f3329eca355e8e93e7b20a63cad66bb04f89ab8d53e208e6dca8f03ee4db317b83c2068cecc37ea09bc43a50ad1cfd24ca7136e044244e01152562150ad760873340af27398eb6d01b748d718ac3900e26c1ab7c28437a14b4ba87368a782920225ec4cbd083be8757a156b656cfafa57ffd11f37d094088179fc079a740ee20799c4fadd8a5c0feb67308d6dd03a782629cd77ed409be8c2fa327c01b92463ecaf9a8e4a1d4aa4e5c00de5d40b9a0f3fe2ef80c7aec01671d02ad7cf46cf0d2d347530f3d5776d2d287c9e07779a6efa9f9c3c071a5540fa994e53e443df8cb493763f53dd12e90e28419fcb19fcde432ce613ff9c68f946ebc43df2b49adc58cef2a29ad0035a48cde8175cc05df1cc11a6a30433c39515b4373706aeb783f4d679d46f3345a47bb450838259fcaa8988bb0f657b0eee938c3225aca69486d022e559cbc06b057f1f10eb283fea17435656016b902a92d8aa9dc384b57511ae06ab488c68a3cab58835564a87554505fdc34ba3abbe9e0ee48ac772368770df86a06e208e4b201cb693025a0ff26a0d4240f63fd57639fe36934d9002518fd61ba8e92e87af4ba0dbda53e79061a610f0d36bec1892d478f0598790b247c20d589f28b20526126b8fa16e1d4aea3c7f82878fb3eee450f52135fcde370ba75bc1867b5870e436bac85fcf5a689487f4f3fd33fe8017a9e1ea7a3d484535e8bda43f41faae4abd1fe2ea3cd6843bba3a097c43714f8469ecfd95dc65dabc69423768e8731ee43ddcff4b828e0f55cc549fc22bf486705848a4ff0ddc013fc20f015fe90dfe7b9d06ca7790d97f13036b33fa7d266fe8e3e17c5fc26ffc0419ccaa138d9f3f2f78ad0040b8d1fe08778072fe4c928dbc673b80abc97ac9a04929f6a69c13ae4b3119497b2259f00807c1e83a6fc37dd0dfc375add0759006025524f7bcaefe6ebf95dacfc117e05ede3710e8eced897fe3f78b0f66d1cc072551190f2007a1514ba1b9c7f980ff04f6a9d4a5920eddd1fbfc43774eed557e6ddeb45f17d3c49a2a281443f0f6d3ae3ee4f4f2f7dbc31c7e27cbbc43eda827b8fab780fe45dd69be94a15b7708b2aef0057cbfc0f58ab7cb01fb597c76899cacf878c5e47f7d3366812a088c169832fa89a2e013d3e046f0481031e042566c13e30e11c5e01bc8bd3b81eb572966db48dbfe4337c06f2bd809fe4d3fc19a7881a50cd0db9c9a714fe18259ff137fc2c467c1154b80f73bd07bbe1353ac697f312acf0181dc01a9de0e55bc081a1f40db8fd00e045ba17fae3469e05380838c0f7f247e7a9dd4905c92992cef18a1f88c700cae907fa807fc279bd8622a94fa137b1867b780b1fe157f930f4e0f3e0dcbdec806444f3a55ca8ada29754ffedfc0cff999fe3a7010e05690a8c4e38020a74cd9f8751680decbc3f7f2f76bd3b7e094f412bc93bc3773bfc5eec7e7374c51a65777850ae41cef12b7db83f47d019207421f47304f4e872850b0073d05f622938bb2f74abbcef4661cd180bfcb09e2b792c1f028c5570b59222c9893e6eec2645bf37fe5569fb0d29fc45bc1bb8b58b84fe1a7697dcdf90e08b24f6b76229d13e3401e4e3d39a5e29bf28f669d3df883bb5c3afc43e6df15b71273da1556075fea0d288812f759eebaf6108a4d4ab4dbde7efd144329ee10179e3c09b28c7ad72989b20c38bc16f01fc8d8880a639cc8bf9282f01eca4814a2b7cc387bb9f828fead0e42d8a7a1a6efa6df4b44fcf75458ce7802db756848938ace136fa2f07295be46e65abf4821d14067e9b04eb43074a2b3a12b5990a658b1db08f6549033d094985df8b540efa9da2cf9475b71f5ab0174aa565e7847445a2df6e65d91d81ed743b34abb4979d90b29168252de5fb157c086be40878ee76ca844ff305d5c2a3300302b01e33e4d51f1080b920b9dcbfd30ef4d99c72669f0eb89fd683573c7d655d005620adcdeebac7a363f65d60814af4e9019f75bf03e0b1696fa42fd48a7da348894fbb40ff48dd52071f2e5d5960972325fdb909ea86afa39b00ab003be821b49d8afb683e3d035b525ac8fbe155868272bdbcd4cb468b09b86536d162053b40a113086f03bc0e3f4bc29b589df4075b711ed227cc47ae0d9ed97ada090edb03dc8159afc1ac72077be90fb0ec1a544d8017e674a61e8537190658c8999c0ec8a47fe23664d846f0dab85d048b60f85b2ee505aea49562286e9403089db8a70ec8bb40b5d8a2c0093e0ee6c13c9e2b388b5dc83be1fd21840f247db73cc84e0e3bd1fb5dc4d9003947b216a3c6f28cf0c5f9d1e45e651fd8f3fbf81d35a74d8ea67ac21f94b7a927c6de3f473f273fc67df8394198ef00d69986d1cdb21fb8ea5d8ce8b9df2ee7a7bd02948adc002ee5148ee211ace124de0415727003647976090e1e036b96809b6810ee6a79d6eb710edb012e7804eb712bcb93f3f0ca52d07a2f3c91e794cf7e2db8e6804aed41bf1df45ff04e1af2d990f3cdb0cb4728fd192a3d2e68c0beb85764bc0212190f8f42ce148bd395d807f6bd8b66a35f04762a7bafc1987b4065a7081241c480348c3b9de629c94da62190d08deae68a82dd2f3df200c8d174c8b7f4e03640eff604c85bcc045d25f154e77d67873fb1c00bb2453425c00af74991943e2903b8f9540f39cf73a0839c5fa24f22ae85c59501a9f0a11c4960ac25900c0b7624a57a12f4608092d7084527ac0b76f6237c4244c2eadaccc7b99ff19df60a529bb56cd8e5cf83bf9e062f9c404911bf8db009ed4ff03e2ddbf88eff8a5efd01f28cffced778b5854f8779f4d80ee9e95f84bf64896c87de3cefd55e88d242911a446a1f1f767d6720311a5ce143df3b84aeef12bae26ea52b333b3551d7f70cddd1f7dea1fbfb87ae6801cf48f4f9c8d2629128b594ef3d85c4a9e83f1c651bb1d739dda0cb63c41971dc05bad641062e846efd44109fc2296d5618d0ed55a0e4db4d5d40f6d90638621c51775357206309200e32762190f1b5310db01a1067f8cbb5ab35622ddcc03bd4b8d3955fbef4b7f6f85b7bf93d7377012975d2770f858c0e051dc0975dc6165e58a06ef73468e008455df97254be37409da7a69302af00645c03903d61d140bba575598f6f4ca7488356b807bcea7be43bc514e8b76cfa5cbe13803ffb009f0434434fe600d2f818ffcb0b52c38ee393d0a7d9f01064ab6811ec1d4772690efc8f6470a27c8b2061233dcd0c397a1d5a4ade5ed7017780dbec9ca4a8ff305d0f7898a66145d1b885e48dd5865e6ed46d416e01eae2a1733ea1e3f0be433912da384a79e7f360899fe5287a87be83a514c6257c090f653b07d2df95946bf41675406f0f80be1e08d0a0cbd3a0c373a0d19dc014d4e660ac4bc0df67d0b382da61995b71cb9542cf47a14c960c94255d987223ecaa1bf9765e81beb3e0171e14b1b0ed7d7eadefc9a620e8ad3eb8f1e361ebf48175922901b4d94d799dad22806ba40685e53b0610aa74500324f775d060b9b60ee710c74d6865575696842dfc908814bde04194d309f8829f2aafe21878e103acf3ffca8be8eaab7bedcaeefef7af5af53e4bbd5becf3c7bbfbe51759d63e4bbcbbb741b8f70e229437fa56dc7715e0f6369ac031b0390976e64970df341a8a70354e34a4f32d79a6e2c566f0522ddacfc099acc6190cc7d8feeafd63337aaf07778ce01078c103792e4083a5502a06f052c01c58c74efa0876e89bf42eca23c03b115cc61314f78ce57078eb67f84a0543b84072167f0d0e3ba6ec8714705f96fa9a518ed3dbd75dcb60240ff4f44077cdc62640d77269b13f03e948872e0f517791b420ca1087202575f80e05fbd51b3b9f6e97f7306e6e9eee017a969ec5f94276b17729ab4bd0be1eb649b9b2b5e52d266f2d790b78bcdb6bf805fe983394f43b31573f6ae0359eb7e8bc9ceba04b97031a3819375683ba5596d2a748e7c07a88052532f913c02ac0570a9c14c12ff253dc8a5ef378276eed7d98f924ec9b15d483065008fc9c9fe0e39c81c6790bd6d99b800ff873fe10b7fefb089f1461b02e7feeceb79dbc02bee9ac8b6018acf46da7c7d53df67965fdc11bc08bc6f2c53e4f730c243a97a2b894c6c37649a72250e106fe0f1fe1ff747a72dd65e057e6e62de0bed990f7269a0c9d51c1d2da7b9ae642967a407304230ec649dc87b3f5872514889a05ea74e4dba32769a0a2f2a7b03d75689150e89130f8049ba0c116d219d803ef7ac406d66a139f407c37cf576fb6881f94ef3fe51b4ce087c0fff22605ebf99f7c1a34afe77a7a84ce012a4093188abb00ef56ef983c61370da22cc79e74d1dbb98bdeca75f579e5732d66926f1a35c00b38f157f941fe2b3f2e12c1273b3d21746f29f0286fe37ff03f047b80ef81a5fb1c3fa4fc58f976f7a207a566ecfddfd09aeabd3135c116dc02f95906bf330637d22ee0644aa542f83bb78367c7419e5e828d17036ba917ce230a634fc14a43e1a10d432a066557d21df4b5fa265247f7f0b318ff7ecee503e0e185d0eb775201fcaa894a5eaf84755e4157703c7ce49b31e354fa3b2ce2cde8fb1fe313fa1935a37082dfe3d6af84b4454063ad82844750166ec0b558bd7c3328fdd661d021122281bbd5dd31cc78a55393ef56fadaf7f8746ebd4857b2f0063cf47df23ba73ab10265c5077b2104ab0cc3ceffdaa9d17d6f521f44cdafdd1c5233fbceaefb9b589f269fcb7f024dbfe705bc08a7b753f5945f70775212e7d22b1caf56eac1dede2fc17ff37c01e67f80a70f209f4e56a402e0a7e4d048f8154534968ae11b9441d7afc659ee842edc431fd397e2056d75f251b5472bce722474bca7ed789cd834d0f67cdb7ff9da1a9ffd22d400de36de371ab115cbb9a6937fbee82bf5c54f4067aa5ebeff603f3affd15b08b9ef6e4c896deb263f7ff40cec19141c62090d0b8fe81519151d131bd73bbe0ff690684f02c1d2086296493460e0a0c14368e830e518526e9e2b7f544161d1e83163c715975c327ec2c4d24993a7944d9d36bdbc6246e5cc5997ceaeaaee9ceaf2f3cbbaf0b9be3375ebffde9cf69bdb3fff1c3f9ffcfffa045d05e553cb5c79b9239d39d923860fcb1a3278d0c001fdfb656638d2fba6a5a62427d9136dd6843ef1bde36263a2a3227b458487855a4282837a0606f430fbfb99744d306514d9475759dd29556e3dc53e766ca6ccdbab5150dda5a0ca6d45d1e80bdbb8ad55aa99f5c2962eb49cd7ada5cbd3d2d5d9922d5627393333ac4576abfb58a1dddaca332695237d6ba1bdc2ea6e53e9f12abd51a58390b6d9d0c15a145d5768757395b5c83d7a595d63515521866b0e0c28b017d406646650734020928148b9a3ecf5cd1c95cb2a21a28ab29b059983b02877acbdb0c81d632f942b706bc945d573dda593ca8b0ae36cb68acc0c3717d4d8e7b8c93eca1de2504da8404de3f62b70fbab69ac97c9ddd03a6b73c6e1c6f5ad169a53e5e839d73eb77a66b95babae9073843a306fa13b6ae5c9e8f3590c1e56507e53d7da38adb128fa32abcc3636de6475374d2aef5a6b93614505c6405f913cbaaa7134a65e0f22964cb16236b1b6a2dccd6b31a555ee44eecab3bf5a7b912ca9badceaee611f65af6bbcbc0a4713dbe8a6c92b6c2db1b1aebdc6c7145b646d2c2bb7dbdc7971f68aeac2decd11d43879c5ee189735e6c29acc8c664ba887b0cdc121de44cfa0ae89dace3a9552cd65aa6472276559aec83e0e0ce1b6d658b192723bf6345c06b5c3a9b166389ae1a960f472cfc5895ce6ee5150d568c996e5b2bfdb946cb15b1bcf1038c0def6f58525d5de12bf64cb199249c9279dac867a5fdaed70b8d3d3258bf817e04cb1c65c95cfcacc58d62a2eb3d75bac88403e2a056dab2bb2fb83fc369b3ce075ad2e9a838cbb6152b9276fa539712de4eaefa8708b2a5973d857d36baaac69f0d57476afb28393f72881efe536a774fe855822c38beab2dd1cf93faa6b3df52553ec259366945b8b1aabbcb42d29bb20e7a91fde59e74db9c30bcab538e14d89384dd582296776369699f29e6e3d197f7e8aa9e7b6fa9bc195aa84ada3dd96aab19eb022c066fb9d9d5a8d7fcb5e2a3adfcdbb4c77b6e3c27cce05f90b96d7b351c382f514515236a3b131e082bad1d0408d8da3edd6d18d558dd5ad46c31cbbd5626fdcaba568298df54555be136d35f6ad8b738f5e5f814dd47136b855d0a8663bdf3ca9d9c5374f9951bed702157f7359790b0cb882aa5115cd49a82bdf6b85d655a54296ca4299b1ca0c953018bd459855fbb8bd2ea20655abab0295af69655265665f19534dabf094593c13a5a8895cb88e6b5a754f8dcbd75a4799d953d6e0699de66d6d468d45d6ec23f9d30155e979a4d628282befca0f4ac894c2408d9bedee6beccb6dcde8e4becabe42251add56e816b472d7f4ae686cb402ec18bf665ab92704f9dd5c2943f5a7066c1e4af6de18bb422a7977c31c0cd038b37186dd061d128f513c4536990dee5da146c0396ce90d6120b89d65c661ed70cbd4c1ae5644d92ada1d9c34a841c681412a6ee931382fbfbf7698ea81bb80af03759a8d708db744a30484794059ba41d53769fbc90d3c0c7c03284bf6a1641f4af6a1641f4af2b45662ed69eda996a4044cbd67774cd2a06ff363b5dd640085b6495b47368c7da9379eed8d37204e47bcd11bdfaaad6bc94908c9ef813c5c3a840650606fdb5ac64c1cb4572586395562abaf64eb6e9424e4c768dbb0aa6d58d536ac6a1b56f52d42c6a85b51be15e55b51be55956f255643d9fa7a87f226b6b584447a4b90c80fd02ab469b0dd13b4726f3c5d9bd63228e1507e95361543ef526193568670830a67ab70a20ad7a8da352abd48a517a9749e4ae779d332ecdf254c5061880cb5c9da14ea8b92495ab18a4bb522d8d809da44e4653c411ba7e2f1da18155f82f268c425681786b85853efefb571c817221e8bbc8cc768a35b0a1306e4d7233f1b7502f3c9f242aca1106b2a049164c9066013f02355321be11ae0eb404db564ad105000c8d7f2d1c385315ca87191a6b90079805c2d173523d176244297e6547b74a295133339412b274676e2789c381e27f96b4e84562d8b06005dc0526015d0847132d02f03ebcac00c195a266cce04cd26d6c35b4ad0acde3841ac93df4cb43e625d4b9f04577e0fb1874a8155c07a6083d8d3620a0bc98f403bd9b63f70227036700d703b7017d04c799e1a57a0c81379da443151d3c1dd7d773b9d83543c78a827ee1def897bc60e0ac9bf4aeb0b32f5a5ed400d4bee8b25f7c5567db904a000eba4d221e0ebc08f8092e0a920462a88918a0da6a27faa6ae5a7da7d0b34801a982815e35fd8c6a47a2700fb77194596a6a1240db934f44943db34947e8490550f595f0adc003ce4ad4b54cc9ca8983311632562b5fd11e6a95408c2042db145f40869057d393b243f0f749f0844a5b815d4bc1574bb55aa122185384485fdbde9f548ad275f8f0dc05d403f6d2fa02f201590064804d80056004e54eb83d3dc08d800b80d702b603d601d4e276297e39043ccce5a94b5266b43d6f6ac5d5987b2fcf78b6a4095a872055064246c81b050736cbe45e8349382f86715ee54e1552a74a930ca153b33e8e4cca0976606dd3333e8ae9941e5338326cc0c1a3d33a8ffcca0569ee38a72047de808dae8089ae6081aea08ca72040d7604f57504e58772054fa7203aa8c2512a1ca4c24415c6f3f49620ea71802bc966860470ea1edbb509a76cad3ab7245c6f6b3523bace93abf44439b2f0a98401b6f909199e92144f94647b46c70834951f277f76b832fc5ff69fedeff21fe1dfcf3fd33fcd3fd5dfee9fe01f610e335bccc1e69ee600b3d9ec67d6cdc24ce68856e36397437aa7117e1619f9e932d455da22bf2a284756de816c1670cddce15a892899328a4bdc876ba8648ed5fde3147b2b07c0aa30d947b13bac844aca4645bb87394a5afd8dc9eee18e12778fd2caf266e6db2a90738b9b716b9795b7b2218bd6c649037e2f3167acbd35ce1b5754c83ee5cd3adf7a6b05452ecb8bce0bcb0d1d31baf017822a6fe838ff443bba66b09278f7e69229e5eec7e22bdc8364c288af2801e5a4bdbf570c17438b0af78a6132aa28df1bd02086174d96e5010d8515e7db9115e5857bc92623d58eacb21d59bbb5eb2386c976c932f2b4eba3daf5b9a05df3485b5161b3cde66b3352b51979619bf917b699afdaccf7b6d13c6d6c5ddaf87f4c36d5c6e6fff1456dfafc8e36c9bfd8a60b356b4739fec7c37ba9988f3717ac94ce5295bda81658e55eb7ac2e5a1a2bd6bd54c0c7bd7e544ad59c9a3a1957d7b6f2717b6da1bbc05e686d2e5e7971bd7ba5ac2eb61736d3caa2b2f2e695aedac29662577191bdbab062f798eaf49d174c778b6fbae6f4ea5f18ac5a0e962ee71ab3f317aa77caea3172ae9d72ae9d72ae31ae316a2ec5f5604b338daa8075aee2dd2230000c5c053b6d54a4a53e5771738e2d7a75dc3e9df8110a84b3d2138e6f10505665e667e6cb2a4899ac0a963eb1b72a7a758e2d6e1f3fe2adb2a038d43e8aa28b2e2bc4dfe2c5dec4effc5b2c9f25972ebe54c5ea6ff192a5407950f2a7244b087bc8efa9b47202f4b3509a596a64a9b5b5c58b2b96903ad5c54b498eb74406e787ef4c2dc5c8bcb82b1bd0e2ee8fe40d077910c32d5eca68251b2ef5328efc399203c3905ca47714fd0b22fd768a43dc479b831b9c8c8fbcf8a9fc6f0e59dfd16e18e23d28a8322f7a9e32c05d2a2ce3f19e98e6d23bea771b77a36c30bf468f928b4250fe0e694c5c4e4eba83aea67769aaf11d4a6df4207d4b193482ea8c0ef59dae8357d183ecf9e5fc707a5b7eab124ecda17f05e598ce03b41d7c1d65629432da4c51f43a464c370290df2de28513bdcae8556db639c318607ccf87f5978d39f4003bc571fd093a4a6d9ca853c7f5c63a63abb18d82e9b416dffe9c31d058885e53a98a96d21fb18206ba8f8e718518290e19b7a8ff8fa845e9d3f42a3bc05055b0f026a3f50db485f6d2417a9dfe46a7983984d3b881dfe6774cd47ea4e38831ce98632ca2229a40a5d480da784ee67c31439ba1edd4de6bfface363a30fc62ea365b49caea10dea7f47dea3f7e943d64480281353b59d144723d57f356c02cdee03255fa68fd8cc43389b5d7c233f2e96e95afb11dcf83af50205c72aea6fa2ada0e99f69171da137e84d8cf99dfa5a1b83a39fca337915afe5dbf84efe333fce4ff057c224fea669dab5fa0bfa571dc78d00e35ee351cc1b47bdc90adb3703677009cef3187d89fda57306e7f15bc2213234d67bb677740c36c6186b8ce78df7c84ea9683b12766e118da7e958f50aba9ef6d30be87b8c5ea3cfe93fa092c6011c065a58d9ce93790a2fc52a76f2b7dc2e22717ec3c515a245bca339b463fa74fd89f63d1dbd3a5a3abeed308c1d86db78ce38aace7728e629c009cca27a08983cb12731cff37492fe456730871f2760ad63b904fbdd82f13fe2736027b3582d1e1706ace18ddacb7a8cbea56342c7c28e2d1dbb8d21c678f9df4f30c2626808201bdc24bfd32d56dfd41f54bfebda0dee394edf7034f7e1013c8ea7713957711d2fe27abe92afe13f82aa8ff21edecfc7f943fe06deb39fe8053a39448db84edc21f68823e2b838a99136053ecd95da35da1dda1eed0ded9fba45cfd007e8e3f52a7d85bed24426cd2fd27cf45cd4b985ed73daef6d7faea35f4761c7828e751dcf761ceff8d408340e19a7609a0ec01a2b683ed6b80afbbf916ea3ede08fc7b0c64fe80bfa0a67fe3d68a1710f8ec58a13d4b91560dde3b1f2e93099e601eaf872d0bf8177700b1fe0c3fc2cbfccaff25b7c82bf158cd5f703e4400aa68a79d8c3bd6287708bf70167c47fb514780183b4c1f032aab09b9bb49bb19fbbb513da295de8bdf481fa147d8dfea24933cd356d366d351d31bd64fad2cfe257e9d511e735081eeda87856cfd5aea026780b9af6a5784b38799538cb7f11f1fc2c668b87ff552a0a440e6ca3fde0f28514e1bfd5cfe667131164f1af9263887b44a6365d4fd17ad212f98b2e3143dc28aae8613e4067c55870da32ed986812b3b5adfaed7a2ebf077fe3599d4410ff48f994cfb938bbb7e94a9c50a6b64b97bfe92693593b675a28828c9bf42f4c427b0b7a70240bed159ec16d5c2a2241ad1c711bd991b7701be27190c0f7c1f97b61760ed73fd6d68b62f121caaea03bf859ec713f5d21f6f3033897e190c7abb894b7690369355f096a8ca0cbc59d9428ea4522f8792afdc0d7712f48ee599c4d929847ba16246ae81d5181537f83c3443f5e0d3e5d48ebb89132b89d0fd351b1898672ad76f05c4c7b9ae0736ddcac8da5663eabbfacbf0ce3fb2c28190fce35c3e0fe043cbd15b3bc40362d055c339c4c027e1de4a90ab21e2acef01fc51574196fd1fec57f16f934916ab5c562346fee38a3e76b8341b17dd026057e23cc64729ae2f52138f12f2857fdbe92fceaf48f4cd7c9b4f6b676daa8306c1db34dc11d276825a83316da6d1d64692c7dc0917c294fd20d51a21bc634da2176e9278c28eec9367ad38084753cc94e4e32ac7ca511c893c0e197caff6fd4d7e96bf5a5fa1f71379d85d6bc916ea77be9afb84d1ec2bd950a3a5e026ace84eeb90c77c4001a4459d85d2e8d82561a87ba529a067d5a052d398ffe405742f3fe891ea766dc5025a0c7a5e8378f2e47f962dc50d7d06ac8ff4db41e3a60333d4c6f8ac7c476f8bc378be7c53271197d401f682f6a2e9e46efe8b7e86b680a7ce2491c8e9987e19412d06fbdf13666eb4b71d0fe4320a5e07be32be3b8f148fbeb18ef61f96b52bf51f4955f01a5d144fe518f6513f41b68a8cf37c94f43fe34bad9cfbf957bee114c265d26340af03321f194a689d81efeb2ec29a618f3c46ba21d132ca79de3db9d132c3f3ac75bdae1e43bdb9d12070e181c6a0b4db685dae6eb74ceaa1d3ee732d159b2ea87214f5f199f8a4f4d26f58d7ba22be478e0a94061f60f200b872f89c5f04fbbc283283630f2094b2e07e4c63f0137ca9ffd0f8871b81d3a7802453b2c3fce6a3b79d272f224e5e5b559da38346c04fe060e805ad4fcfcec8929a95a4ad690a1830745f68ad054e86747298ac4d329222a342c4a248bfe767bbfda54c7c8dc7419e8b7b7cfb0c6c65ac5c3d18189fdfad903ce99473a329c23d3339dd23f0a107fd19ed5df52bf53ae6a0e36b58a1b5d011cd043fe376cc07b3df6898728501c74f5b4861e0a7d3df4a3d06f434da1fb38928438b8db0cd96f150f3d39c0bc087ed901710f6ef3efb8d4b38fd36d9676ece6741b68e7b438414f6cc3e6ddc5f904e61aed678d89b1faf17c958c8eb59af4b73a6253121252f8734f8c93dc6facd6434da3688c7cc7ea1a5c1a5eda7b7bc4f6b85d11bb6277c5f98fa1b129c9e3f25dc3323287568e7385678d7b6a60ce40c125f6a462738fb0f8dee195c5adc6e196c42c152579a278153d159555fc54545054b39f7c471ae71a696ae2c22657dfa64c6b5312579650e55857e5b0bccae1b9c3868c1d5232242ca032b44765686e982b7df39030576256982b321b8990acd9611cd62a4a5d99e3fb556665560e4dae1c9754599c953b74c8b821a5c55c3c243cae3262637453b4e85d591ab131a229428bc80dc7125c8118ca12be31bc295c0b3f20be83747d0739051d4fcf727c3dab6d96a50da9d3a7bf46ec0194e3f95a254f9f3ee72b3ee9810aeadfdfd22e5bb43be56351a12aeb5a800399c59d6c244f2435252b2bdc971a16ee61adc183cf27860e1d1c15d9cb5feb92f274b7d9718159c3eeef131bdbe72f36b062688ceda055445bc262d8ba4b963e19b62d213636e1019bb7f019d52a966dbb656dc70fcf841f14273b7e8a0a0f8feac8e813ad87c486f06be753b29ccd2a7c273e46b7445b3a069d4fa95e3f81674f1af9da3f4d93602f5fee1a9498d8d392576c2f4e5a6e5f9174883e8cf59b9a7843e293894f26e9e566ab4d7ebb4ef14f4d289d3861fc2525c5fee326e7b58a575b867f32ba952b5b060d4acfef29aea57ed44bbc4cc11c041921fe0cf6616faedc633e84c90eaa6c34e4388c02d1253434ac958376a70e9a9fde2a5e7b2a67dcc8d4d86943f203d0a000988331e47fdf5592595cdb923072f233621154e5fdec8731e6ae85d4b4436a4eb7b541ed8c87f820ed94c74afd4fcf72cac33dddd65f969c6e83a08f90387040c10a97734c597cdfe4e49294f8b20417d94a115c9234cec563fa22e833a5b78bcbc83a29115589a5138b53c6bb38c97ec9f8b169a35dd437dde27440383b037834eab9f65a2e71074e2971274f9a51be674c9f9288a283063c6ce36b8a07f631be1eae9effc7d9970048519c6d5775f7cc74cfd5e7f474cf7d5f3dc7eeceecc90ed3b8208a22ab828aebb86a3ca2a2b062e291031505410d46d4445141051113342e82c32a6a8cc67825c6fb5313d10f114d506290a07167bfaa9ed9054cf2ffdfffaf6c75754dcf6e6dbdeffbbccff356ed3a170c55913e6a62924b96dd1d8d9e648437fa2f1a31bb24b74cb965ec2796c60beded89a4646ef4f05bdd327ab9d8d6d15e32de9334106d1236ead4937aa1c28b8a22723265ee3a6efed0ca29ad705257fface1f5f8f5dbcfb5c80e41718b828321ccabafbde19e5e3db3e4e9a38e5e4b3d781ef6b7f3ccc194aa78023f0a785c6a21d171f5f1c76723933cd14be75cb491ff077ee21fd693b322eb09ac0d781d4cb07dfe92b993667b7935d1db7bf1bc0790b9e007c40ae22f282bd320ad73a62d68e841e226f0e00a7acc80bd99803900df3b461176ef3e18ea3ec0b0165610c2511f8ffe3d130e67f0618b6afd1bc48e3e46daa05f4fa6ed198e30b99da25590cd6613e79645d764d1349361c435ce18001c0240d5f7c208ca690a54afc1d9a93a73d4700ef4dd50624249a21b278b6e23a44b82d0d9c81116449c25c16d44682499201244b5f781a4dd29a8960b4f3df5428b2a38edf1fb75f8c54248c0e3a23685b7da5fa8d7d6aeabd79eb75b79d5168133ea680572f56f8845cdd9a61982f1a884eaa1f08c19c1ec96399319cdd66a459346f36551fa2380c7bf7604e9d8e67cf7e1f9ee401336a67bc86c2582b0189e50eaec10da4b4432d17409412616fddbd9fe6d617dacbe316257d16c9f8747ac5d078f7801cd16e5b7fa16345bf0216121ff1bcd36074bfa62c9c74575df979efd31539fba54bc422283de60ece81899899de63853bc20f692fbefc25eef9e189dcd444890b24a4e5a0a0bd94c92b59aa838c8e562f198148fc762082da2319f57f2f9bc5e8fd7e7898982248a0243d33181970481cfc563519f09a43ca2c03326271d030293a340bc4692bac05b84019a0696d84c6f48d886f0c45983b7eb2cad7b670a210b7a96fa2a05410d9675dbacd4fc149152f3cf3daed460ac696ec3daa3bd1e95dbed51b8ddd5ddb8a7a0e5c497ca8e4a37660a701c18a8a579cdf923ee99a5cebca2d1ffd2a1500718cf168b86251a6002ab5514cf906f44331f6f3891d9621af7a0e4b8a53ae389a699882e451414c88b564ee13df5cf37702a2fbb366c70b90495df50ff4ce515d626922b6010c75afd83b9669567657aee2eb74350fd9f7ce25705877bd7c9b48be555e338d28da08f2a533391130de8adea403008002dade706a8f5343bc030b4ef3d3040bb07785e19e0381a0e582cf47b2d7668574374ff958a060af0c07aa14f63d97600ce0896d11d18e7381c9f7c0388f87023b585c77fe870239f113fc53f56fd7a9c9be0c5c68f7831ee13c1fa29c6d85a2315dd63e4ae53711f2385567f9df823cc234028eacad3e055b01dec4119620b05ff4efc1abcca5a8216c2f238fc39b0820ba0ff006214761ba11086cde5450292afbfe54da85112e647df6e8baa563b5e9b11c24289c422c4673dba1d3c85a2cc44a8d4777e8109eb0e6e2728ccc45fc8156ea7c46fd6138b2ebd14cde9e5b10f498834ac03f810b31ba66dd4db36d579c156180006cf9db9db00acf8a174724eacabffd84edcfc6d5657cf31f8137dff9d6327929f9a2e40807481dec330325419b20b743387c3239901e67ce6fbf0526619bd8cb915dec6ac831b982d600b7c0e3ecfbc0977c24f987d703fe3b631d05683bfdb4cda268301a60687d1a406e86d0512926ff135f8d8c38f1bb4671465b9e6ba0c55ab7062613a9ae477fbe8293c02692b71af4d72f2aa29f6f5497195b5bb4cf7bb9d2a6b4300f411fab97799701da200376e12086b7464ec0b408eed1dced1e9290ceaa7c6f682e4d83f808c3e5d63ffd8e273324eda498c8ced07dcd817c37e670ebf2333f6851e4d9b7ccea033225c40077c02c8c3a4c911893ac365215b36092693c353464cf8a52dadb1b2536db97bc4c8e8d96b1acbcbed432b5cc189dc08b46ebebb817d28759f4ce4b984a2ba555975a9926a32fbbc7e6fc01bf452e664229548273209ca6cb35bed8c9db65bec26339988f0311d84448f0e35735c0739aaa0c3281bd6a157454dc29ed5419e408d51a2347279067d685782aee607ec3af8a3ef949374171f10d58a14e0dd151e377220205422b5b17fea3aea24251f8f1a2f871a95458ddb5989e22629c90ed4430d29a1e7c88060abe4aca89171cf2fa961fc45feaabb518795dc41fcae6085b072fc64376ee0bfa9c6e369cf852eced2a00f9809b47346324304c12d5b4a4d4e4120862163d6506c13dac95d579e75fb8cc579ff34d68d7a475d950f4ce5e4d97d1935d53dfd86357d9a92ea3ee2fa35c4bbafd4ff76d70f27b5876f2a9fb0f015c8e17ee4a6de13165df27239aa46ebdb9fda7ac9efcb113506c34fe168db8184e32e6a3fca7a0f0f0bb4b736b65f677933a019afeeed17fabd14c38e101b801daed219ce6e67b927189ac023263422409389804fd0cd637716c12b8d106f019e38e751606268bb4a488f2176c90337f17bdd0acee179780e528adc366201f0214ef8fb86076145d86b50412375eede6d403ce046cb42774181dc977b9f39e4a6b505540d2b8f03d904be99c6936c2771230c61dc1a9d672059a8fe99c4b0aa9556a9fdff3c05312945114437d57202466a078d95e02fd04abc856249839d0f13276927e95cdac1c7a988d5eb95ca1193cd04b622566b0585d1978a95ddc5029e634bab772b0aad3feb596fac74047bb9734972496a49fabed47de9c7ec8f6418876095dbed5d192a1dcd043429194845ed920d3b8cfaa9b05bfe5a1895a9149dca08ca617334a31d5fdcf71e6daead691bdc81b0d6867835449c9c61ac764f0d7ef5089e13780ccd08e100e6ea1ff0e5f8140722db39e046a301f4bc8db80064e14fc70395dbb717c7e95eccb6d12257d092ef40fabbb9b200af2c7257b4b828687dc198a0c8f150c21556742046791dba83920e85186a9a4177e5950d33a00f300487b4b99de1718e1c6e8f754e2610d345ccd8626e26d426ac99cd16601925aec1f9e69bd721f8626876f0c11f5cf8806a66ec1cef3e77ebe9777e9818f87efded91d9616cbbeffd70e767f3bf3b2b35efbe1f57158bd5cdb5ac3df59de53da72fbcb8fededdc86ebf19fb90426b05903b6c9ad785e805c2b2625b5b3bdf133b323623ded77511302f0a2fe9ba855ad97e6bd7baf6fbbab68a23ee17c517a597ddef8a7f72ff55fcda3d56e0f1fb364b116447be860cea439d34cddab4144f16d03c14608afa801a08a512591549a74da19090adc11b3625ca45c4726ed82c94cdd172079246bad555267dbe6ed2d353184156f011573e6a53bb8b26b3e3af23f08a862d1058e2143e73c78e63b89d68f96762c503b0414677a05b247eba31881a8180294c034a7da5f6585c942853bc14d5a168722199d39ed0a144093a008659ae441fe8d2551dea025d435096c7554a9370360448a22976ddc69d61a4f1c869d888142fbefccbdabc5d79d6cd71d2aa8d373d7bfa966ac0a3aa470cadbcfd8727de94e5781baf9c78d9edab5f3a83f84569f3193ffbf894164ee01476e1a30b8ebaf1781c6170f9c0a937f69624c6cda5ca739ebc7af6ad2863bd89a30cf1563f08833fea0e94e54344206cf2077d325ad69d5bfcfe2764d68524e669bae0743ee10a85c3e71024e2cf24110e86d0c23f4a9294291c7004b07e054e94925016f3fb7024c8804563b28bac118b75169a9ce7f8fd41c006208a86c008712108c301dd86c208aa118a72d9510e7b15992336618ea199a3fbaa43b87630dacb613e85d928f799c1b08c02cf682fdf6d42b413514b14302876be7cbd77fccab6b60cc1703b2cf2e32c63bcd384a722cf4721498ebe065f7be8704c140f37dafaef707b67b67e221c3c9d4c7ef3125ebbfa97e318050789f747c3c8cf9fc17e8e562e0bfeac476c5ec61761d26a8f62caa58f4e0fa62f4cff3cfdbcfaaef2178556b113cbd88945d4f186a2b4c4856272d00383fe30d806f11f6c82f87803dca133fe32455941222ed6e07feb8cbb6cf594390bb48c10d78034316f337af29c78ac06fff428a7e6e29475dc850fac1922a1688d768f561bee8b655a6137c2f2dd0daade6df8b1e1bd8ae233313e13caea0a831aafd9af4395761ff05c14c29a561d82fc3852603df72dcf8d462c4d4edb78022e9a716df9ae37f63c72c985c7e80985e3c59f0daf7ceabe2b162f0e3990b89a811184baa97e5630f8e7cdbfdbdf1eef0ccb822adcf0fcfa9f6c9cc6293291c33084105440abeb412812052df001dd9e8f48b15224a005c281c4c8d83ebcb5a93bdba949741f75143d873a9936c7d1026f42eb1b6a5e23c6355a8ad5c65ed7ad183dd0bb63b4a386deb988a2285aa2243a4125e88cd8231e250e88e7899789d78ad7c41e1337c7deb1bd23fcc521daa089b684cc09958d85e2e1b342df095f16be2cb5b0b0a06553e4b1cc9bf60fad3bedc2c934a2421c2f844429e80ac87eb7ca298e088839ec715bc20a5b0a443e8b924adaa2654c6eb3d3116b4531b26e73ae4c928cb706ffaccbc1b2644a961987f281b90c325c269469c950996dc4cba00dc4600cd889fb1e8d945b907c535b1f835df0ca09a2579d89d3c768d52800a01c826dbda351c13da858e38b6743614ae4589e1558d26c77d81c84394b657418122335f84bdd051256c4f0e2b1148d0635534e876136885fb1c1b823a983b42569b805760caed7e07718d7868c7c6370a846e6d1e00157313c05651dec2b4ddf894600aecb1ce43a70de31ebce5af2ca13eb2fd8d6d1576959f3c60f67772932ef10d2e5dfd49f5413f7ce5fb07acd59a79fdc4b880b2f7c7fedad5f2db96ee3ab775d7beeeab322ac2ab8ad52fde18fc37fdc72c743d72ffee5f19d282a5f1bab936fa2a874812b1e66489cbbcd08ba3284d94c124f307687e31c17905c2ee04214c3eeb6b9ec80e420718ecdcab39c95e2ecb611148990b8ff1137a3ca7f3d8854ef9869d0a18a013c0877dc4634e16042ead6d0bdca21a91b8988f6f078e529ec82e3804e5e397a1fc61292ac3f48cb4e413153f3124658ac5ef2cfdf797885b30a08853f464ae2634349c4412b5caa4f15d6475e009f81cfec9487f2bbb4dc89da5984c9e6a414af5352962b37c3dbe9db6d2b93abb53b721be0bdc9cdc493d611fb88f6b2f5054dbc0cae0b13ad520e119d615f34501bfbd3704b343f32f6272441f63fc2d3a9540c8f65529191b1bf82f8d8a7c3c94818b322414be974b49c4e9bfd65d154289b1dd11afc2fc4c4d2329728931f78ca1579964cc835b85bb7154365ee836c9951dbbe25467081b16a5410bb0b3b0d47c57e6ab8664baed51be45d141d10423af0490887f216a4245a4c288d067984485e176a72744107ad48761c901838b1feabbe0055581d02437df8809136b66b13d208e807d9b50949077cd55b90723029e8cea4a01ec43da8186392bde252d0e32e3ce6c2632e3c768860983b91bf1106768e43a151f3ea2c35aa8ed8b7c583faa478eef9dbd7acd97efe79a7647adeb8f567aff7a41d777fefe2bb577fff92d5ee5f5e71c52f372e5ab491b8aeb8feb45bde79e796c1f5a5f6ee63cf58fe873f2c3fa3bfe79379abee38ef8c952beb96f96bd75e78d1fdf7235c14112eba915fc44111f6eb390b4d652c1ac83f101b8999131824a359d43815d4389c81b6923d829a36b9984d665d9889b103ad1f095f45ff9ed99b373d09602b4649fcae1a36ba8cecff296843eb9443ef324b9b5b9f697dad953a9576c440c2694fda524c066942d47324d080836263e9b2d584f14cb71610a059c365d991184198e520eed3adb132eb69f77c602967b711f783d201e8e2f68eee300ace7b3f020d6fd851d9dd2c24751f00ae64321f89522e87d3ee24cc3ca23322277194d914cf30c8475236e423c944c415c34825c23c8525289d46834ed444b9301adf0c72e6c204761d045ea0aa61c01a82131886fa469036adea36ec6a90e583721e682f251307ccdbd9413e3965d3a927de7bda936b2e7abcd4d79d5879ca8faf3db9dba3f07677b2f8066c93daef3cf7fc7bee397bd2c26298f8edc28bcffcf579b78ffe64e9c68f86bfdf7f6ba112e114de6d1361f1e3ccdb2fae7ce486659b745d4376362a28e419c0819460abceb0c3b28d1e0666e13128234ca0a0bcd9665355df81924aef4cae21248c4af0218515f13f95590e34e419fd9d938ec19fa32b266a2f04ec1acb90c09885024ed2f9a79caf38dfe6b63b3fe1f638bfe22c6e44521ed8d4c242b6063d3a83e6c7fe9dfbb54cd5a0ac3b6c25e7abac0ce57754606ece1254a0b1a5d4288eed46dd4635f690e991e109a82466c7bb66f577a2e6d853205dffc8a5f24ac87cd0545faab7448480cb8efff826380b2ea7ce25edc68a750e5b62b046ecd7bdae186b533d7e6a9600d13f562808158114545f73c3b58ae825b7af171410d3342ae84de5da20dd87dc51addf18da95bc19b707f589473167314a77afe1a29c5198332295fc0bf52bc4605ac113fa94a934bcd379174f389cabadab1c64928947af8a3ee4a472340da2643fa292828795e317676df21a36cb060a01224051d9001ce847fccf42a76a70922e16aea6e9b6a23d1bf614c501456dbb17976bcf6ce2ac11511864f7e22a242280b85f40e4a0b2db207ed5665805bc2107ef4b707e21891ef17a9c417b0af25e36091d2136051b491e470a4af1184dab703c8f217f6fea9383461ae63bd48ac4cd882b2beff6e7eebdeab0efcdc6f9ee8efc31c7ac7ff1b2fa4bb3b3e54a66b6569e4c1073f01ade70ecb1b9a90b5607d2271877d3ece2ef6e3bf5a7f5e30eda31066f8dfd987ccbc48332980eab5b0137f6d4265fa024e06d4c4608941c3a6a2ae86e13ba8acdab625c95521f7eca8d3a23f4e33a217005479423bf4b87fcb0dcd15d834edddad1d15686d4f4c953fd35d2a4336a6bd6f9dee4016b19d7d0792a3b75aa6a35c7b2aa2df460f7e40ea4790ed71db275727b476cf2f418e8804864ae1e9e92b5d46041b7c9ae584e8ee5fab330fb38fc181c019ec31b28b8a4d28b374bf78deead8e6282de8bb7d60cd6866c846526b2d90e835018f285eb0555c356c755fae2259392d1d25a4a4b6a09cd64162541e2254ea2cc8544315e61a6a48012970701dbe21a048e365b0af699d0984e4f4e41b7a60e0229ef1c84f69233050f334f4d35b0707cd36d82c98d1f4d6d6f465f47b149d11006ba784928b64decef4c94c9f846994c76f1465e34e35ddc262e92036a46f8c19dbf79e0dab3a757345fcbb44d3fbff5289ee395ded356f55f93f31dc3b9af9d77d771cbcf932487a84cbdfa960bcee0e312ccdb28eae7f37ef0f0e9175e1f5363958717d7373f5dffc7744ee14289f2a452f0d69e6317c07e08eeb96adadde78e3e4520aae862e07678d5eca3cf36e1bff9ca03403d49dd0432200fb7e85a078f56d43b39db999b2e1ce9393a7b78ae5fe897073d83d9fedcfe0cab814c269b870491b3723562ad2e3b5638563b88f71dd091e61d0e8ef75b79219ac62f3913896226914867fcd14c96218d21b3b968104b3f43e454d11892e51304591605bf2af0111f1e3a22088257046f0c92af046130ed0d067d5e7fc4ebf164339980d72379bd1e81e703440e69ea5c2c1ab5323480018dcd07f3443ecfa8b96cc223263c2ae1198127812c9cac4b99845767990ae021eb0d7ab77bf778292424b25b5a88049f4b08237032e091eff3d60a8f7d9f43cfb23c04fc2cfe737e8ca778f4eca6c2b47908391ac5be21e40b7b0defc4dd51a3ea879536868faa710805f9eb529321b397e6156de98f90daa6272a807fab0e15f63e73f0c0ffd3adf16e0ba2d5f8b3b125417e4ba8c3a64786e1b75e20c92849fe60f4ed21e30c40fdb7b89d0217ee376a8cebe1ed538ce1e7b0a05fb37257f003b8b4fef2b890273fc540fdcfa72784fd52e23ba377e2733b27221f9a8b7cc80792a00d9ead6f7b28f30bedb7d6676d6f594d2b32cbb53b43abe2abb507e3e61fc416c5176adfcbadb0ae90ae8bad88d373b8b3b845d605dc027e81b040b4cc08cd0c1f193b4a5be234b5b193423de19e782533499bc64ee768a6a0867c616fdc9bf116a26c46a32fe31e8f3d57200f0f1d19ff7e68496879cb2da175a1cd213a4bfb645503c02f13b44983d04fb7849c6434e56c0b25fde9849c4cd0017fa0b5ad4da609998ec6597bd05eb057ecb3ec83f6f9768bbd0617ebe95c1ca0e02358fe46fe29fe157e3bbf8737f39e52321580c656ef1e249dd4e28ccb1a3e8113e350f32c52d528c260e583ec659416b84635ac59143eb4e8d2c82fb1ac20596d62428b67a45c0ec6add11ccc0ae91c88d91239080e30789c5b868686aae823ce470fcab69626a0340d2d8611fa18a927cc87db3a1a25b3300443c6f61877e7b3eb165fdebfeef45163ebec59981e9c559e7af325f54d70c3b1974e9e7bd775f5576737ccbdf9f2db070b779c3afbba33b0c9898ea8efbcce59d77c231f715eb77ee964b4082721db1790eddba1a07b0683f3cd8bcc246f736a82e0b7457cc1f668d4ef231933ce2d6ca082af7a96552be61308840292c7ad89a2df53cab3adc156a2556b6ff7e79339ace9898c9648f8734854cfd37b3d044cd8a2b184a71d24e201006c1ec2464712ac0f7eee1bf311be29640230b09f59c3bcc26c67f63026a63d91c8831c972372358400723c1e4320c11c271684cf853d98d074cc98df2034bd3377e3f336b8878c551d42346ba869bdd146c90cff43d6da8d646af5f5de894ed382c6ada68dbf30318e8bfc901faf28f31335b471abf1e352f7c033cd1138875882d7fe9bd3b175860c9b910bf1c8e87dd0a8f760ae40b4d78346dcd61f39109df5f7f1c8cbf5a3068d573ec3ed20b2d2f9c84af39195fae0d3ba5db85b7eb0b0497eb2403540dce6d09ad8ed091998ccf9a15f0bfbfda1b0df936d3386400116d2c542a1ade8cff61e868738b612ac1015adaf5239accfdfdb40789b596b027c03de6d72ba89ee5adcf83a882ea5b4582a158ff9b549ed78a80f2035aa95babada4bfe49d1480040881471229bd542094f3ca1690d34ef9d34c98aa0be18889502b13edd172cadee7ba88f58d1f77e1fd157231ed3bdd3844038cc075a089db891206711af10044b0c12f30992789c780c4cc5bf42d238ae850cdc6b9ccf1ad27a0d0d80eddc8b31dc8856dcf2cde09dd8b5a91eb28753fdd68ece7fbaf93fbdebdb5fc38072438817304d63a58aaca3a68042e651a7886e50d310d5e17f29cc8e9ffd1a2fdc86ff65e4db8960f1e86b8663d5df337ca48421ff2bc3df88dc8280470d7e85474a83e3cfa8c10544473d706832305cee68f8c878ff1b79fc75bc1f35f63ef510f2b904f842ffe18fc945e2e5d232e27a7285b85cda2fd30c61936c2ef276e24ecb03968fb98fa48f6433c59dcd6de1b648541b9d0845db118487d4a0ef5d45f1072dac60b351a12021c4294671072004ba83af00ddce55b6037805fa7e9e147bb63340d316fc8205bf700512026af2ceadf08d86e4ab2218c54745771cd34ce2cd73a3bbf169970262fcff0e9c239c4c985db2845adec4220067cd169174e7206716ba814c08b946fdd75000992644579b471792cd130b24aee16144e60f914851f2a11d770d3e3a0fc7339cf9b319c71dd939507f142f3c71b651f89d3ceab96dfb89df811d8619be983e3d15f8c9b1c4ce09d50491ce04d4536895bb882ebdf2a17f6780381ccce87a0abc025e836ffbfee8df07f6c17d7e6b1c24fdc940a26bbaef44dffd81ad81d7c1ebf075ffa77097df71125a4c3b2f1c3607d4c6b66fc61dbb8003535c8d842a1b6409362db2ac20faed4123863910e98f10917422128927fcc18211c5b6b662475b5b7b87bf603319f77491a26913e5b7795d8d2fa64056092a84929614c525f9bdf9540358b47e8dd0d2494d4b25fdf9dad875bacf0f41c8e7f707202141dc06ba0040195b4243a046f8755b209e080603019f3f01f1fd0c9fcfdbd54990ae8497c817921d8942c166b35362c24e27925d5dfe40c0dfd91148eae00f30981c4cce4f3e947c32694aeac97429a90bed6c7245f295e4f6e41e3456233ed05dfe201c84c40af807fc37a1289f8f2208ca5f232ed36531445212159825fe417c5ffc5ca444b5fbe9661a9989b7588ce33e7c77a1f1af3a846e914e1852b89d1e63eb058f22a55231128b91577a2ba38db39e78fbb8b7813f983922cab89446d4d18428a4a6fc670c19faff0322f436bc530a2f1aaa82211885ffbad5338e1f10fec7dda02871d769f56ddc2ac3375fc0edf476dcfe1e4e86ddbf37e0a3b141f422e2edc15502de093a80100d0419cd12af1f8a1ce4a7c8abf3c8abaf445e9d85f37544d320e3537dc47304b441b3d70b652f65e30d2f73a605a793475423ae35bc09a597743695d2b2feb895321eb114498b85225172938c7bc438dc6e09918e5800df47c2457f381cf0fb635e020a30d0383b06bd40d412f17820118b1135e2f22d5e29e1f510489f5cae5ba1cd6a85b4df178088fce95e00b27abc9dcdceca0e66e7675764dfcf9ab39e3c4106042f7e5c1406c5f9e20a718f48b12214d55ccff913a47108b30fae411b3118ed344eb1632fc0c96877e36494b109b534afe153202ca4a554054abc0f359cd7a8b6ce35e4c5ffc609fe2fe9a73a04aa43e128fccfbe7008e5442e4111f3466f59d5b0b1b12168a494f78879ab70c268a0d674cafd4df95b1ae263f2d90908431af4bb28537c97da081c4085dfe863cfb3cfaa84b053dea97cc57d25ec95f7aae6e7e4ffe2fe4b78537e4bf984fb44b078388fe09265857a4ef89add27927732b7d8d7121b4c1b98b5f617cc2fd0f462e27ad30df415f665e232d7cdc42a13dd69eea48b4cafbd872b0a45b947a13384662f7071212e17944984e571f6496e581816875dbf929f5446547a23fb20b74eb847bcd7b5567e487940a54f148f95abca6aee1671a57c87729b4a4f13a7b9a6c93394a3d593d993b9e3043aadf4b01d62a7ab5b39869dc14d13689bd94a7bcd5e3acd26c5a4cb6276a990a245d641018b1ba5313e6e259d712c2742a005ac0126708914b7a89b3c7d97370f7de14d495ca034a48371f86fc8f8c0fc1f9f02ac229fd82c5b7d7c45a88deddb84ae5c6d6cff2641a9c8f8208c53f2566445f65714dc3008de3721ea8d5efa145f4db5b13727ee6d02be7f1a5f99e655c457944a5df87d8deb5edd89d2aa2be410268b01d440bc5520aa1547f34ae02be7aad89b570557d01dbc38193a51638fe0debf3f4f84fd18e073a6286b22e505900b0a9612810f1149e846a0be7bede7cb5eacbf08db5f5cf6d9b2399f6d7bf89fd0b26edb67c4e1f7d73f5803e7422764e1496bea1f6e78191e5e7ffebd4feb6fe1ffc10a01362124194048120539b04757280fe5b5044050f40ac1b8b7dd3bcdbb55b36684646dec339dfb9ee76a0f91a433f44acf2d41e3ef0e20bcb06bc6b1213f4313c6bda9c338d8e2a715234bb6ba34dee51278bf921512aa424441202eb0b14a8c88c51486a6d371a4527c9e420e06784ecdef3ba018c7f5223edb87f9471518111ed3d1dac710ff438d8dc58c6f6ef3f75afe77218e69243ed0d2d50587be7dc0a87868001b275be24d7d88e4e1af1a478eeade03ba03eedaf8eef4b6a3fa7b4ea87f05edd57b8f7ae0aafa1b707bfde24323faa565c75e15eff288b38fbf74f277ee6ac4346fc4741ef4c0e7f5c1a5da9296e5a59f69b795ee4fdd97599ba785f35acf2d12d624a979939226e51260464b5fa9afe3c8eea37aaab193e32724ab2dc717e7944eec1ce83ea5e74cedccd6734aa7753ed8726f694de7b6962dc5e1d2af3ab7f6fc56fb6d4ba4c5de89bc7d4b8fb5858ee1eedee156ba889d75ae664fd2e95cbabb3d55c9f4e47aba8f8c4dd76e885d975cac5d9dbfba6559c7aad8aae44aedc6fc2d2db775ac03f769af699f747fddb2afb4afe3eb1e5f4767770f552ab690d9440489fe40342245a311ffd9284611f09f306c3bdb5283cb74918cbbbb90fc6c8ba7dd6932ca38cfce821aac0ec3dd219c1e94f6421c64b96c28db925d9335652f698f27d44928c26b13db7d28cab97da33bf031f14a01413f2ef7377ed1652bb08c3d35cc70256dee0ef523058d1bdcc0f9a3670e20c2f81126bcabd7d8c9d30f8ff6aa6c257f6640a86829d4e4314274045053c24d073e2758c24d47003dd781cf099670d381cf099670a34928e0e1b7a2742eac9a2ccd6d9d89daa651dd6c943d9ba78e13443b8e5f1cc5e241114c5cb4e0f88e93e6f4867ba6fbec82dbea9ad1d591b9795aeb116795258657dc8fadff1c05370af0fa2bef4e847778361f721704b7c8da9490da61e779932249dcd2349cb10b077cfdfefadfea5fd6d713671e1cf6106c45194542de37157ca867cac5a3bdb38ad5e225f21279a96799f7faeedb0eb31e193a7c0af1d3e03dc10d53ee3fec0df74ef7976e8b1781e8b0a874e0a327839a9e2e4ff228ac4902b0d3d9d61225f325d60148de867feba0c4c7fb6ca1ffe1ec5b00a3a8aefeef9dc7eeceec6b76767676679f33fbca6e36c9e6b179b1213b101e2a429042012182e003511bf051eba312ffb6a2450545547cd47c9f5aab20202112404baba8586ca115ad5a5ba25fc43e4ca5fea9f51377f3dd3bb39b2cb1f8eff727ecbdf3da4d76ee39e7feceb9bf73866126cf33afa36ad65564624a074921e3a130b6b86969736c49b03b4804bdd384985a178fc4d549ddc935c9f5c9c792db9374529afae85e182a63250c0da3e95e67e0e771f041a7a272c3292eefd0d8543a3b41e7a3b8f57c33bc980b352e7889b5566411e8ab6d41424bd8d09904a5d587e242ddf8348e867a72a33e21f36e483ffe83754fd49cbbf4922d93e62f3cfef2ef6fc5aaae9fd9f7e31fef9e36b5f6c1df2c5efce6b33ba8763f36116f07bd1edfdcdbd65f583fa721e4f0072a7e74c1864377d4e2537f0aa1538b1ff8f115932f0dbabc91b3cefae10f7e868bbe209bdca6d9e4bbd54a3b6369e490790dfb434d38584498e8461cb4734a6213cf07a4088fd023812ca93400bb9fe738471000a47fddaaccf9d3fea5fec37ecaeecff93bfd4bfcabfcebfddbfdc7fc26ff9f631897632fef64910b95d34ce8b818cdf888cdd7a18f324a412f6d101bded37899ffc4ed7b859f6adc8467f1dda3dacb516ce10f1811c1eb0a77687d04973d41dffb67e87ba7e08d6a8511183db5e05ccf39a9a5817bb92381fff6fc778afd29f869804879180e79635a8b67d45d8c63f23c3cd5f6e30d8ba0c768b80617c709ae80c525862bf1213f88af8a1320cec597c68fc4a9783c998ac72b5381700a98b5e08ca7db0831bbbddb88107192301a49226026a022e1936707020d9e4040f204148fdb851c9f20ba11487c3c2964fadc1ec1edf6b8c5ca78588a2b42dc42c6cd6145b158cc04aec78bbcdf78ad67b66787e78487f2e0809bd94dc4d3ae25aefd2ed285f6fb46dcd0bd17de8adce5237d555a241da7529d3cde75b24be33a7469e3537280f04f3a5d7283fe45007d7c805c7383bef100f677348f67751742b8c5456b6d1ed4e3a611d8f0af8e124f5e5b5838c92d58ad821bb67a9c569bd3fd1ff03603bca5d723a01d0f6cd17b956a675c168b8bd1dbaf44f22fe5fb389b6862214f6ea23e060e304d8d3bccb6cf00a8372369ff0cc27a9399e54c3c805186636bd9d92cc94afcc54f970294d82bc8b57d2d383126ad6309116f6813f8a03e9153f77eb91f0b26fd178d248624f0bf46ce233fa62f0576706e3f93304b192456efa856b4c13012f31d789989b20dc083bb0c33e12213e6fd5bc022e6c5b40dda7ec7195edb030f012d79a3c8fdcf032d25229582b06867a06e4de004e2715672f81df92ed4f9e8c95f2e10594e8ad14fbbcc9c0740d856c813f769f7a25d95c7df0bcecc336c14e67088bd7817be2add85f1f7801e8ba7167596c81d2a32a60771bf9d9e84a32b5f6a9a89f9e2c420f9676a04fde65bd58615a6ef996e37918c99319a177140e038c01819b371110104023f2f166d1306d2cea18eb230bf00aa612f49020b9454970c769030477693eb4992f43aed12ffda0bc5140fe4484969efccbc67c8cb0debc427b7c67a3a2dc947cb181ebd71a5e409e212b89a9778412cfcb6f05b978036a991429ddbc67bbcb0a7d0e393789b5b2b9b943f4cfdaa10413e93759771113453e9b49e8971fa1afca6538f6b92d01592a4fce1b1b8117c81cc933c5d87bea38206d9c819971a57197b8cb4f105f819120f0afe1358d2c3e823bbd067ba47738bf4f125ac9f88a4c4dbdd9f48a8a5036f48b49997843744272f21ecb701cdbedf267b400234c165ea79cf189f083d5343c68db15096bac6799df7bbbe1ee187de7b854dde2dc65ee109efb674bff105db73c22eef9ee021dbc93a170b255809c9871cf779891b6b7e54f370cd33b62d35afd4bd55f7519d29111e20b6a9de585a89c5c24a38c1079cee6493029a92906cb030554d0370503d1fde9e006c83429a1905c3af55556455326bb1248447382560c427ac409615d52ae6ec0a4c2b39a55359a23ca66c57f62bc71493e26d71afaf550cf87cb7e131c37ec3310365909a2bf78dadf8c0d4ccfcf162285117cf12a530dd358c838a1a836b74da6e75b48ecf0298b143fad68c1dd1f3ce5fb01f21bd2f4066e40468442f69e4641f6faa3195f2379140e9999e02ba741f08a24b9c233fd7333b6197d2585a8146737b19c514a711e80b0b453b41c6b573a515e705bb8f3cf0cce0ef26dcded9d3b3ec3999e1dcac6df923b31fdbb90acf58af647f70f6ee4b675d77d595fb965fffd0e6ee1b9eb773b74fbda495f5f00ed6eead7c7479fea8c692fe4f07d7999d73ee8af94b30eeaf46633f1f69b61f2460f439ab138f95994b23d5720a61ab5fc4fb4e29ed9224d115f6078d2434cb714b9779002eef8f2b8caca0b97db95a49fa0120912a06143bbaf384c15b19990b2cb24bc00bb976a15b3826908294bce0eef2e1c083305472a97238eb6ec883a61269c833a4d3a45abf292563c60e4b7130d4b92b19586bae8d4e4f7c3b7151e2e9f093d1dd708ff985e0f31507e843a6a3d4fba621fa2f268748d5c17a7aa2b903769acf0e7e1bcea3bb8c5de68be025f415e66b891bd91b83d787ee08ee0dbd18ee8f89c8d29ed869e612c8db7e2e28ea49075d70f542e84063041046c6302d32ce4f8365cc3858f9e0ef06a0a1f0cffef737be52b632f4e3f7eebdf73dfca23ecebff96ae11f2f1d289c78f5492d3da45dcb5138f8d81ffef0187a1563f2339066568213fd0a8bdc4be4d47fae56a18dd75cefc7dead180c0d2a7f8dfda5c21875558853e499b19915f3e4aed8f9152bed2ba5cb6277481611bbf4573b8585ce6fbb2e8f5d52f1b997367825cee54d72493ee6fd11f73077bf6793f749d793e8da489c77d825c1070169b2497eb78e9fc1ed0e256934f75106ff7fba9588d996352dec0dc10da19f878890b74a50e278907be3d01e0fc537c4c9b8943a5036ce48db34ea4ed7ea9927f54410f43354e4c2e90907ad7afe161a54ccb8c5e1f8d458feb3a11c25eb9cb4519e0668cc205f857c450bc8bb9d0e3761d87edfbe97de7e66d9a1392ecee1bef8f183870aa7a0f9d02f48ab1f6bc9cf425eb76f7acf5f1e78fce859b305b72335f97248be76085ab02edc8ceef6165c650addef0f9e3fbb724525818308db541ba0219dd6e2086153d0830f71beb4dbe7f3b8c341560c27982e16a9415f4241f71ba9831c568420b09805232e99e70e31720faebf04a1b72aa6f470901b8077f6a52a7b4a0c85d5c5fb93c79165ac0a18570da1ff27b11e9c392058573b63875854823e9b8937611333a6177b40e5c8273b65a10267dfc5473eee8b98a2d2a88d1a85239146c32894aa779744b99ce44911ba89b9f783ab7e73fdf5bfb9fafdfbb5fd55ef6cbaff9d77eedff40ef5f1a92bb16d79eae0f583d77defd80d07e17bba24f7beff7e2f966402f4a07b9b46922c01191c512f63c5cd2ea29e984ccc219613af12af3a7f29bdc7bf27bdeffb2fcf47a12f45abe4aff4678896e039be73438b7de787ba7d57846ef6dde9dbecdf1cdc4ddbaf15f7fa0f9007f8d7fdaf070da6571c5e594673a423a0b88d94e2305be67ab3bd00ae0238f9f723d51d96b330db2bc06e61bf701899224a9094caad65223a735823870c0f95d8bb1a11e03423b353140cc824ecf209a12042f99f8c9a7a88fe2be26982392a99c0a8c9ad91aafeeaa7e2474f5ff0eb494e1be7e16aff71cb3b8563d07ef0d7909d2fbdb571e3512f7cf4f1d7da1bec92c3c1d5cf87bed77723cbf17f6f59b76deb5d183dfc0e7922e723c9cc80436a4cb5cca67be85b2db7d4f55a765a76a55e4a1d4db16e1372cc0e725c98c9d4803a58374050cf0310ae41206d00aaaa1722c98d26c220d695540200f0b25453ed313026368c6451659b401594bd8735d1dca45ad32ed5b5ca75c445b9a4c66bf7c0378aeb7133b545f736eeb806ffdb709c2bafd1f1c7f124bac6adc9d92a533e34a0552190f22543103b20987a77c6705743918e3ac6ab37b85c25cc9c869a1dcd77e3f6d0f3b87d7eebddd7ad6d70790493f38115dfb90edea1195a6b7e7ac9bd23f660795cb3f211d124f2bc9b745f31758d8eb109f0fdc2cdd4cd48322b40030caa7553855502f1bef266ec136528764a3919355c9ebcb27a797a79c30dd69b92ab1bee4cf6343c9abca7614bb2b7616fd04698b03558a6190886a64d4c9800c1549d47e6dc321a4b5b70639d22b329056c8c1b4d59c2000d301190a1ccb21cd3cbec60483bd3c92c61b63387199af136d6283d910d91dec88e08b53f723832183911a12252a6f2c2d38455b31698108b060383ecdc1036a9b91277a5759c912893e27dc037721278474eeeac34d50f8c7cb133680238025765aac55dd2d2800f568b6934ed95a7b4eac805368e2e2e09461b1119cbea6a6e6ac4568468ccf00df5a7f1c36fd1e7bea867d5e2991abfe1efe75c5721ae7debd953a79e7d6beda1bbeefae52fefbaeb1071f021cd62ec993bb9ea8204c2bc1e78eed99593beda03617f3f048519f7bdf1ab8df7fdea574817e6215db812e9420bbc4aaddeec3d25131474c18b0cd71a36c0fb885ef804b103f611ec93869f1877d1fdc6578def188f798d5e93c3add96dbb10120861b14710dc9eb02399d6004fd5e2daaaaa746d38c9b1babdb742eb62c66a659930a7e357736c7111bfb6d4e3fd4863baaeb1b1be2edc02e5a45fa19289041aee16401939d6c4c8d2310f44f3c4e3aa790250e4bafdb5876b89da01f8d7bed6e9178ef2d2b091d134aa68f23577da714683ffef321ad0a95238128efc1ce70a212c33b8d3e1cd80546aa1a6909cd7471b0d311f2d85a0d7e8d755126744cdd8c18f4e1e869193fdb22524e8e867a11ebbd273a5c630eaa8ea16c994675a8c8273666f5cb4ec8ec51720c72654f8144f1f17dc7aede249e92bcaa92f9a66235c746afef4a9eb3bf3ff1cd55f72d10dd5f275f94f463369dbf53c2af02292069176001221d8356a6558aa9754698eb45cba46fa8164745ab90502c2b1060bb380a6c316d12f6d72211c4bbe420cc0fb9ef71bac16163f2569097a3f81dc101b45d1b2ab53808214386fcd983fcfe5b5516acb7d3e3ccead2f73efbba02bd2e8fc5a8e70f106101b6e5a03cfc1df3befd11cde73fe81975969c7bbef16cefbeab3324b85b00cb64bbb0a37932dda370b80c7d414871399098e5c645fe847e8ce7f8dbd07f4c01ea287dc64b7cd32ad373d66dae2dfeba7fd26df5ea4e27ea4cdb4d934009f7d9ea2c266fd0bab36b3c13b579279a74ddc18c461b925aa8320483218b258e540a093829414dc0bfbe16f40e9cb177992a361b9fc50eef3fc18670ae7a6a009107ff3d16f8c572a4adf9fae6f6a248edd744bc18a971889e90b164c9c5bf887760398cb7f80bf7dfe2b4df3975fbea13aa429fe9d97222ddf8fc67523d2f24662600f48223116adb92466a50916ad573b7973ee52e74f9cc4810cac142a6335c9ca4ca2b1359a8b4d4ce6322b859511f3254e187136398994d0997c37f66ee693d8279953b15319d384d884cccae8cac62dc2968821da188900dd8c9b476db81f2bfd2e1082a110fea5162e17d2a8a6087987164742a17024ec8f80ea06cd5ad4d64ecbd4d63664c2d599468759fb205b9ab5d9cc6cd881e914c883d2b9149ecd1a9922ec139c55717c7c7a32b938964cc663e1aa5834168dca8d19a1b13113119cbc530611013fffcfd91815e8080c67fd7e57d6678867ab1ab2d5d555558439cb3b80290b0956c02e34d31d81918762d1798d7b612f88a123d655999e0c21676a334b3364065ba340b313cdfd68f659c5f43004c7c84c2ddac0f39081919af6c147418f5e36699421a99519c32c3b2dee8789b33aef4a9b6b72c5f56e77eb5a4a5bf0de83fcdca37dc136bc1879b4cfdfacf752bddebbabb57ea790c88162bed15afafb7a8485d6525cbf296638dee09df95a64cabe76b9d1c6b5b595cca27364b0cf1bcd08da0aab0333ea0777a25e2b948014b91c41471082164c315cb42233f2b96e08577761d887ae4057cd2e5ef5455f4ccac8ba9d5c0db003931a5d7e1fc3350e386e451e8e67fc42f84299b3f80abc38a5e98a151b8e0b0b03f0b10bb5e5fb13f868b6f000fc6ee14765aee397b00a9b0f2d57e36f8585a3d4dfab9146ed431a25208df2802e35b3cc75b5eb5617021f960518332294b8002344dee3dae470843d000143006507c77572fb399293a4726ba8154d38b3153ca305bce774fbf719b67f25d7a1cca8a3bfd58559ee08934d232ad5367bb3bdc5d66a9f606fb34fb4abf60efb54868f5b9a2cbb7c3baba80ad8048979fe65c665fe6b8cd7f8e92663bd7faa71aa7f9e91ae35354fd4f4f3d80438615afb840913dbc3cd2e3b3e149479389b3fc20ff227780af01caff2243fcdc6f3765bd8150b69400184b930119e160c8743c170aca9563fd8c035100dd3d20d0db5e970d334151fbcf85807ec9896ebe85073e1eab42118afa94e04fc0668ac6c56b3609aa15221bd0ac390c6e6a6a658ccc55a6db25b54438db5628f48885fc50341b9228ef7e33d7122fe553b48cbb9761cc802edfbdb0fb793edd2f4ca673d6531135ca9ae6db41ba5436a1ad9365c5a78e25bc1ff07afb16b1c45a90c4c18b015d6c0c478505144157222e991580b459b6349aa22046983c4ba4330415786a0c7e20d4150caafd5921bbbba10dcf015356d120bd891bf010abd8c23efa1dff51e022f6f96b027d4331e8df82ff0b66bec64d4e3bf6427eaf502275d4e971651d3bcd831801271e8093da7ef972195f14afaa7cbaf98b44c69b97ac2a2a6e9d3b1a43e3caba1e69249d3b4cdcebaeaaa891ddae10f35b68cb6492e9b77f5d469d3a666cf3d3fdf8fa59978409d3bf5e2fc9bdaf63d1df303c98bf49d31670449f91548cae723296f816bd5e6b70c6f998803860326e271d34ec34e13b9dad86324961b2f325de4231ff63d69206e0cf5c15d04e90fad0c110052041144faaa635a57c845b8a6492e97470af3e331ad3e25d97079ac69c55949c7b41c887131621cb0b5364ed3816d7db6c500f7c24120c3e5aa33a05046847179dec132acec3d2641094f289c066f37d4f622782b616c3b06998ac85617cefc493459fcef39b7ff5b5c2bf8fcb4c968329808839f4602e73305746c5ba961db92b0ed0c09e8ad7f7cce27e8e2b55aa3e977752104d754743cbf261da74bd1d7e0edfc05772f5cdad9b24893870f3472d5ffb9f25b37ac2e47b7455959b3704a32b8eeecfca763e876e18d1d3fccff7d9c80200c78cfc831aa0d498819b8e1596a0b2f52a2e016c9d7e1ebe6b788dfd37f30be65365c6ebccc415c4c5c4c5d66ba8c5d69bdc271b1f312b7c9a590768521cd8cd1a2008dcd2fe5b4dee6d67ad5ea6adc811fde590b9622883940ac553dbc625031d75f45d7741bf61b0e1b060d270cb461007ed8e74126a8e4b7a0c96d38dfb51abb0ca52a4c9a93691e7532458440859193bb38c126b8f78e7c8866dc0ffbac414770cc9fc4ac5b9dfe601631354ec08d0387379df660ce2ca0c6c4a2c6881b074ed60e20c46714cc3c3a891a5170b8db05dc3805bb80af38a0f2688365115833e18620eda13658a22b952539e3d86d293e531ee56a2b0cbf74a0f037c81f78093ae77dd0dbfb017ec1ed3f2f9c808efdb87cd8895ffcf88fc71e7d64f0188e9c176ed6b417e7af57abb93ad6de5a815e8dd5e7c1794497f52288c6c470b9f51a7863e55535e6970d3f67df35becbbc57f16edd71c347ac4922abc81b8d77929bc9ada441f46b2a2ba50392e40f84457d9632f3074f9b922685d3c5d9085a93697bd6e5cf2249b5a515339b54e046ca0842d99821aed84dd0e46da8023639680f74069604ba035440aa2f0fbe6bd0ae147a1f6ed30208ff2a7ef0cdcca5f2f058c2528bfd8e6a34ea29e44c403cea75237f78ae22323ae6da88e3d0aeabe8446a41f433aad469b1f4195bafbde9b75717f22f7e70a7be66da5d16527ff4cd07371f3dbaf981a3e4b2cd8b165f73f8aafec2c8ee82412742205c91d500d165f71c3eb2e19e23877134128ddd3368ec22200dcfc599f49fefb4b726b1f0b5d85bb781a77cdb62e41cb0c47b11f88e77a57235b8c9fbdd9a5bc15ddedb6a36c71fa97aa0e6e9f8d6aa9fd4389e88c087935be42d4952f71f6ce56120dd369b5d078b665937c373b0192e3907c05b51edc9f218c8dbaa153fcbe00851850236868d51283192dcc3423b3bc89e6049d65b57a9e034bbded08e10753834183a112243526d29885c1e19d2b8cdc8f4a241cdb7e5746eead7c242df60654f1f58af0070d5843402c231a10a97584808a90134b2c97123ab47edcf483fd683a2d171e1a1adaf6891642d9e5c58a585f4d67df842210fc99f0dae3bfae08347f18b787d331ec153af9446147eb91bc2fee7470a33ee397cf89e7b8e1cd1eb6951e793d7216bef52859b6cb08ae96457f2d7f377f0f71b1e751afd7a182774b0e8bdf95c7b896dc8d95155a6e894e194976d6a67629696ef124e996d82f6484fda68854e20d838361acb829481cd71683244be1876c97cacdd78c24818bdd54090a3f6c8ec881ec03b113144a4aafcdd6313e22cee38a64dccd41da7614c6fd14b5117a942addf5081ecb49d6f9c04d1c8398a23d7ef146c22ef2f21a8a2d695b38e8c670ac012c4138f4f9d718be4646dce48466a7e783fbc4683ee57622ffe90461726971dbd6fdec55ea7647446bc0bb61432dae0f00e37f14211df1c1e39461690964d817f576f1772fe49047f2e58082e9bb255dedafc1f2d6f385f9ffc47e7dbe2dbedbf9ffc57e750e64f93bf729ecc7c3199373b0d22ddce4c0e395da2abdd37795d7853669fdd3cdf797ecb652d2bb337b4dc9cbda3e58eec93c24e81bd3bdb1f22ce33a59291789d3ab12de3f5d86d4697a51564ea6b23544d93dd662159403aa4ecc4898a43e9600760e32e52ae813503f07ed51f6f52149035ce6b553a8398024606bdd3eae646b24997a2e2595244f3a1bab03b0993d2d40e236988b38af982a2ca69bcaf62614c981a2ee6a9688c303cc6b8c074910dd65ac6072bd680e0f554f596e6c9bcec8f3963ee765708647dad21d82ca3869f8c76c59c2704dc9ef68913026d08cb78b36d2da1a61010263934283d566378b4c070d9e8efca0a19d6ffc2c8c7c08db4770a52db76a119696f5f586cf38fc575f504780d5db7a03996416e4756404d0b9e713d9c0beda1660a9e62a70868529d2298ed393ffe1c7467f045bb31b010705336c5a2d9fd748e5b457125db2d96b1dccaab158b6385732ae2d1628d0af226dd9bc5eb7a2d73d6de352b3badf6b6ed532e5cf2ebd75e5b6372e9358a25776473f713bde7cd29bc76fbb947376e23530124a91b825e516aab68694d35b625fc76a72772d359973f757158b07983cf22f175d5846a73374c99954ecb99156d57acc15ee7bd086d65711603785d8d9ef241abcfeb239e60fbd997d837d92196feaeed36db26db4f6caf9adf361bdc265cb56a1ba0e055aacb44514653187202e372e0073a0bb464490ec0c75547301b8d1ab31002834591ccc2edd4007c5a15aaaa4c8c1c575e057ece2ffb57f9f7fb6984003eeaabc68e1eae5faa2db3e8f9f35a56417e585f28c512346e12c6eb2b5e1f6b367b9910607d9610d0d7578a894d250d7708e397a8e28da7afb7882e04f70f6a936bcbb5abe7bdda2c58398f55fee7ea8ddbb49c9187f16090cbb072e77f73f6b206d98a6b192a337f742d91c607b5ec467c1f17a1fbb8905c062a9025b6b054bf482444e835d919cd025bd2268b853185edfa42aad937abb8905aa1e0fd6a5c126a9a1c8d2a72b8028a764156b2a082757bb2a160d06e62b29cdd2028a4599601708bd80761929c43361d3642230eb027c607d8dbdaf4b2217a55822237fbdf9e0e4be65665a18a8dad7c5a189d77e26a2d4eca1102bc41d0efbcae86cea21abe085c48fd440486f8910f8b2b861a01a4a2ecf66b63d33cb65be27fdcb6f5e08deab7f448d08a59bfdaa20dc3a79a1b71e3231d0bae2582da60dc3567e50bfaa61e47c66390c5cf4c42631081b7a86d5be0167eab939459d92c5b64ab6c93ed32f2dcb2b0859fe0bc84b8d471997059643bbae81927af8660e46b8446ae4468441b3809759beab2022b674d5b49eb2c2d1935cc3a787d8a45f72204cb82a438d3741bae25b0584b350d3304d483a2398f1e159d351a14751010ca7add67210280ec1404a75370f210b0c5f0a78fcbb26496650c91ac300057aa6627914d3b728eed0ed2b117ae044ec8a8569587b57c37dfcb1fe129fe45b81d49540c2ac57af008261dd7588c7a158062d24eaeed1b098c5dff8f14ff7fb13fca5f044506e36961bf86f147881d77179ed22a84c02c6ed7c14c0cd6e8a592dbf09ac93cd25a2ac3929fae7b88a56859cbc808751f1aeb04394bdd91102bdcb791cf884fba07883de22eb709101cb1465c2f6e177f261e130ba2a997d8411c264813657279288f2b4124a984abc2dd42b5b8cea2ce72cda7e60b0b5c0ba405894be0e5d40ad7a5ee4ba54b133752df733d28deeffe09b185faa9abd7dd4feca3065c3bdcbba5dd89d7c5d7dcbf178fbaff2c0eb95366d127a688949872af95d626b68afbc457e95785f7c53fc13fb9bf204e895fb81d090f26c602ada54b8459aa4498d53948366e948424b8940a7ca86a551482a81c55a3e409bcd51b3d122557457ba204179d8df3373627a2d18a445849008b01bf21b98459c3acc74bac21a693213f65e076663f730c1f800cb3996618031db6d094ecd5e43610484b8180570acb92671321bae5819173d47a1745ca024d51b24b10d074964062e99190c44a042448287bdc681b79f00424659788ae1089fd7010b9ebd720791bc4a14c38a84628301742722ec55664156f567666ad86ac459165abd562e8f640cfcb12c4cbf071b051526b1b253591ca486aac023581206a242f6aec8e8c9455972660621f7c0af9306eb84e758bf308b5ae3543e0eb087c1da1728e0c31009f52adb4bcd4055d2f0bd446214be350596d23eefa5a5a33da6e4adf45bf46ebd127683d7abfd6a30fc3bdca8bee0cadba1ad7d0eb6902d09d3441bf083f04c9329dfabcab6b74ee1f1e92b8a12e6ff151199ee31297eff27a86f593278fe393c0733a77387712578b411b792d9752635dd2a5d2ea7863ac2e472af5cd8b045d5dabbfc62dfe570747f5732c6ad19f3049268a1b0345f02ac5489215e4b8d46ca7b3c1e91c778cbc7dc59e8115db92585d3fc6cde59bfa2e1a58bf1247b88f63e09c80843f3f04cb74f81242c87f423c54aec717239bbd12e9710771afba29e408f104dfe298ef207c384e130a2f8557f2dd4a776469c7cbf065eed7fcaf9537226fd4bf9479a9c36e021ef0609804f590ef70f01d112e1ce1944c433d5432f5118ee764582f40589fe9e0795e563282a264882cccdab3c89c3ab37c56c9ca596f5db63e1bcd46b29593b31dd9c66c269b553b3a722d2db948a4a2a6a622b790ce0cc09a5d72c743390e2f38f920a42d8a225a2c3410a12806e04376ba1b8987776a3d3adf1779a882d7ae531eaa58680fa48ba1083a204d61592f5b69c81a8eef85c6d102b525303d249df40c4b1c6a309e96660e7970b61542d212cec8c52388ce0e79873ddc103e880f147b2ff070c3c33837e3b4865e5b5c9ce2477e8917a3f8e26214eab7f609093d198f8fe0fe431c1f43fd1f77fadada8b60b63827e05055846b42efe7aad09b3915bd9363d1dbb8207a0f1744a0990b8fbe4b7b9b1dfdd3e143bfc363b5671a908ddb897a1d40e8eb48da1fd630f2a1caf0e69c2368e6730db884e73968c3c18aee76079a58db3b2605f91cc44d47b3df9183b8e968f671680b351db88638c48dc206e4f68c1d35f582e46be73076afc7601df57cb1ef181839d0c709387a7e40b5a28d481b6a14dc9c31d90f037aa8b3eccb56aa4ef3f09bd081626db986d1c5add3d4c410217ae12d71c18e3cfdcfb052ac2bec29ecd3a6b8c2a741afdd1987b7149e893ad1f98ff08c7711f4c1c04558853ec267a3f095c27aedc124da92566be1353d5e6a158dc8b93dcba49dc1719e4fa143d72a8b68425ab5a97033f520d2aa7a248a933cc0c37bc229abe26e848d8e4eabea3ee5fcefb09971ce709e135e015738bee7fc5ef876e7ede13d8e179d7bc3af867f17b6853d8c7df2bc88d6026dbab2e97048b56b8700e4eb7947bd53074641ab353d8a887ce1604f1006378783c170d8178ea4eaf0b2724dade67eba55737d4d4d5d7d3855ef64749e214d6fd659860c0438ff19cd4aee5a3774a7b51ce8b0d7595f19c547afaca848472a2aa291706524ecacaf97f5643707d26e0005c03b01ac4727780704a620cd33183ff97c42d6eb450a4f60fc14cd56d66553a94a1b08ce0e12ab8283c113d8f9cdcca621a0395aa657d183f409da404b0d957b3543af5709ed5aadf1e54b718c3204552473ae35d5688bb96b75bbfd4de6fadf4555a55d6efcd54613d7666a8363a922b054f8fb8c22386ebd5521ae28dc2005bd5697785c0b28c2f9708e06b83f0a7939a126ffc9ad9a7c6a9953d088ec376f75319a01ef249ed3c50c09e058640adbf16100c8bf218973833fabac0d87a2a1c9c6122f8e7c0eac235f001650d8ef31a6b544f7302b6a7233c599b63b9d9c3d2cda20c113b2d52658ad36ab85b041d14a58a0cd2e0337c2cfb2d9c2c22e2a6b67736c378e0b4a6257377e5487e7dab250e0cc22af7a68f4296bad63f5919139d40b9710fae23c81a77b64d2b41e5935d4bfb313d9b492193bbdf0ebf82ab05a26630aba60a92e8e516984a39561c9b7f3eb88168dd79107c455f9cf752772467ea2f6e88f83338897aec21baf01083715f2e404ea6350071eec7f8b7f2b4c189121de1d6c14c3fe702688b3fc04b41109476b1c3c47dae9aa456a0e398b0384a71fc8a645aa1d6da90a90bda0e2688de528454791f770d49bae892a8a7c1478392fe195eabfdc03bf3fca67d4682d5a8bf339a5741a01178f7758425d17ea474b76d6d56a6b97ab212e9be9d01f93502427363a70669e563115170c19ad98aad79533104df5bc7b725d88b57aa5cec6e9931bfca2e8cf4cfade5c8fd7cac8f59312f0b378b8babdb0b9f56c9a642cc8b4d54f5d0e5734cfa04851708a2435a319aeb8e0fb1e9eb7b0247d4e73e1c1dc4c00099c91730fba5756a0ec41f2d4a05acd006640d468926cc54ca4b699a5e72691c55c38ed6f23ee81c585260fb5edcbb5f8e6d3d723738c9fb5725fe12bb2551b81ff61ef39c09a48dade347a6f0252965e0cb0a148b3d002446926141b6248024420894910414f01157b3d3b16b09cbdd7b36139cf72ea594f3dcfdebba77876fd6766372160f9eefb9ee7feefff9f074776df9979e7edf3ceee6c36391763edef4eab743feafec09db1d29de6c4f60a805f397836c60c00ceeee0e00a0fedd0256440a82dfca2557046df03ee060017388069656345470e3367b9a4daa562b83ef019fc424de4b30e7d62a0f7629c499f518e72d4ba0eac04c065bbe85bb110da4ef43213fc113cd25be4e9739781f363cd8ffc41b769af4cc1459d92e6adf197f62b4f496f92af57eb69bed309bd8a819c499f1d6209dc871b9a3a38648426c587b46fd7ae7d68dc608183838991c67dec2eb4a2886e4c86a1a995957d4882f8e36ce43e6b1be4be8fb381fbacad4c0c192ce0cbc2ae693047eca4ad675ad3af625e58454c372f036f433f17462fe70116b32d7ef4641a38d08c0c9c5d2d580c3be7f626067a46ae266eaecece7d8c0c6c8c8c0cb0d36e7df4d65a9f36e9d35ecea09933e40c3ac3d1c7cec15bfb9b35204107a57e686afa700bbec544fe2e117aa385cad1f0631af0432a2d7683f575be945ffbda2900190f2decd7f202fa664546db3b3b7a7476065724ed1ce38a387e195d251cfba40c671bfa3c7b0b8f86908c8eee1636496e46ed2c2ddcf85d7d22739d0bbc4c3e7d22df2f6211746f2c01a8ae87c5639f30f71890e3a289e898e88c6866b4f3d6e40e745a971df409e0be823d0a6ea3e4868191e853e32c0e18998c464ea481dbaf6df4469f4f3e741f107ae2cd709ce757c6b968c7fd8661987d8c21bd433bac080c08d41d1086d1693d18cb19435967e073562c25c6d822c6b65da8353ca0f006673370de02cee66cc3ed34872db66c86155b6f3b6ded161336e660fff2475abae6877f3ec097b03ec05987822eb479cf3ddc46fbc5e07ab41e8b95ea458b55cac5a5a244ae48c44d1431f7a8162d52a9162f52278a4489e00fccc79d8c0f0c4b1607b3446f7d312c18fd190a461583c5806f7d9960e6b457989ef6ad2fcdcf5e846bbeb294fefab19d85a583a1c5a376f0c4bc7cccc6c1cac8c21c9d2ce17cefc478cf98ca72c1acb07e319d4c8c6a69b5560ca37dfd4d15a655a60cb8c143371d44be68c680ef9cd1f507c518315f602f700b076b234c8e0dc726630c6ce04af89661ae032d28c81ed8c0d101249e4ee05afc716e2efc0f5feba0b1349bbeda9fbba217d0ccad8c1cc0f5dbe53feccc2c1d9c582e27cc2c8dadec2d57acb074b0b4b5c52cb062ac37b33f330dd3c7cc81675c311f2c080bc7ba6249583a9683e5618540867220c5e118515149466666df9e8387467452a87dd9fdc59e29c9260609314ccc001427dcb313dbd393dd89d1d32994b0b1b0b0774aeb3648a9cc2f488c1b56d9315836c0ca8e9f4dd78bea920d8a7bbfde2e8ebd2b07f4ee3da09251e06e64e61f18e8ed5e80055d391e1974fce47138878282822c4e1eb7386e1909408be310d4fd4378b420f26c7182c46f85fc193e70a28d877b18b871f3a1ced6d4b91d75d6f4ebb7aab73eb7ee6f5df76a455fc38f7191080d25a6c3c3ab104e08c713421fc383c1bf35211c4e089d0f8f1f1c61037d8416f7c35a2234381821d30ec3be8f7de1f115449e0e21c64c702040ede3f99010ce5550a1cd0240362436041c68bb8383c23e240368064184d2710ae9a33e00eec161174389d04000903fc91c4e95a9d86dda1b86072aa98c258c77ccdf5911ac22560d6b39eba3beabfe12832ac31cc326a3c5c68d261ea641661e660566bbcc769933415969d16879ddea2a2cd61b61b17964f3c876212ced8cec690e410e0fdbfb83f2c6a9cca9cc59ad2d5b9ddfba84bbd4b9ec74b9ef7a17dfea560a2eec77781479c67825796df60ef1f9c337d86fa9ffd60e23d9f9012981b641a5842571867324644d58cf8e53c303c20f843f89581ce9f059e9a853f8a00cf89765eb17ca9dff6b25aa635b692b6da5adb495b6d256da4a5b692b6da5adb495b6d256da4a5b692b6da565898e6d2b6da5adb495b6d256da4a5bf9df2f188645d1f760f01703c13fba237af20a611a66876a10a66366f43114ccc062e8332998a983c3c2ece9bf51b01ee6447f42c1fa984c8b6380110c7b0a36c49c58be146c6aa6c74a80df9f0bffd14cadbb51300d33b6c9a1603aa66f33898219186e338382993a382cccc4660b05eb616636fb28581f0bd7e21860f6d63d28d810e0fc4ac1a6fa0c9bcb80328dc900bc4cda5f43300bc016ed9f21580fb6c3af4005b03e6c773241b001829d106c08047581ef222298b4210993362461d28624ccd4c1216d48c2a40d4998b4210993362461d286246c6a66efc446b0918efcc65036ff04049be8b49b41d83f13c11650367f3182ad016ce5af44b08d0ebe2db20309dbe9b43ba0b12311dc1ef122693aebe0b8eac09e087f1a82fd115c8fe00004af85b0818efc063abc4c74da4d34baacc0702c1823300e160ea04cac089380732a26c764e04f8d55600ad4120f6a4a00c3a310b44b114620e889c54a40c1313e682b04e3d5980ad524e02c01d883c0518c304d414906b57cd02ac1ca414b3aa22e037c357c5200f50a40bb0cd0c1015d39a029c5440016015801fa945a3eb8567a020b0190b7b6168eb1910c424041017071c05708f8401a22ac98c2ed066a45a015f6960119555a9da01da4488f92afca53806c816371a09e0f7a60ab1059a2a58e241d39a5298eb894815e11d217d60a00ed723056895aca009618590e07ed1a7ff0804cd03a52344e866c1b8dc64b1086042b053ca1a5c5e8885312697071d4ae022dd07e0aad079bf580fd6a2085148c54012bc453724a2959d25ae82344d2c1581023de50fa62a467c17f1447305e0a01bf1244a9f5b8a8af4ae30b70a5482bb9d6967e5836c2526975ec08384482d8684985a4918109008dccffe5996084feda66c3ff97d9908c3e4307a582d4baa35e35e893a0686d1d81509232405781f8921214200e6a64d15e486b1ccd9b0aa42529955a6b690d366c93237f437bc07893206f8a119e82f2081bcd4819e2a3403a916345141509551722da0a247529c052a33e382a1fc9a1b1706b6ba9a911a4ef949fb5146875606bebcddefadc3a0a54178331225067539e833384e4cbd6f269ad811479a91cd9498462f94b362ba73495a2282f41f1ac997bad6d0fc79420c817e0fbb5889e2f532765f84f6dab1b9b9052216853a2685423cf89b4d1f8250d34dc3f972b5a2706a026a42e6ac44f93ad94289e2b50fcc07896a1392cfcaaa664ec095b44153917e5d491d48a8461565050b9014aabf1a6860ec48419e85b314ae65119e59966ea9a1922a5acac44d90ae61a2965e740747da1c9db508712a45db9d6ca2da39a8d3c2344b0988a83cf734ceb99e08b722dd4330a0b0245827224e4518c328904795508daa0850a0186a62f88a299d72a6ff951b3b7395ba8b416d348f3efac0c7f3313e34ead68a46868e0ceda681e00da483f69a2468256b1122a833747f7b756174d547e7d85819ecbd0ce1c95ceca4dfa9b8c0209c5ab10c5b28cf23b1be9aca4323f997b60661022fb937ed6c43119570aeaea80e4200754c94c2fd3468a106b5e615be7b37fc0175a0b0991eed06e522ad78ba9b92a02d44ba939d27cd5013948d12aa442b149c9f875df0258d0728d05def6d3b19118ad32252df2cce73a7e831ecabe52344e83fde5ecc66e95dd34b66f3d1a5a8dcca7ba7a6be46abefe699e35cd2b91c6876c94efe5884b81b62ed1891098b7480fa900b5e61596943a1fc922a156aa32ad2f757309e9c320cae32a344b4ab43268e675cb58fafb56d55de1492d75579a9631dd6c897264c7d2ffd08f9ad5005e9fc928cb48742410a323e4d96c97010043a4b376a8bf918fc9cc2f461a6856bca816595c0828ca51c6f9f2152f7965ae59659aeda359c99a6da49b535a8e52a15c41fa2a9fd2fbcb6baef02b1e556ab557a1289521eae42c22575edd15fd3f8d00cdfa968c71516f3a96086a3960b5e4a3161e68c34116e5839e6c504b00ad09a0c5076008a87e1fe4a91cb40e2503bc2cb4c69134f8e09806eabd508e4bc4705487b5ee003f0dd08263b9584fc4830ba80910261fd14e05ad29e0cca5f0e08878d09205ea104e425990e497064691d7ef3c6a4d2425cd04edb856c39652f110478d64a9a0c607f493a9de58409b87e841f921ff4404a769e54ca4248d4536829421cd7820510aaac1d62c70ce007802c43f16e94c4a9b86744804fda42e5c2401e41c48e94ae241fb64533dd04750be14509ab58a45364846d234db2f1e9c3380e4907e12e8cd442b443a189980341520eb71299b416d5350ad592bd253f1481b685568830400a782bf24adedf8e848cac2d7a1d6d27639a8bf198bd42f963ac623cba5a31ae98d7854cb44be82bd6cca977ca4476bae392812b9082b16692cd04648228a5e527a4d74923cd2752421f941dfeacaa2896afc1b7384a4a2e9cfa23cfdb95da0d563914da05c022de7af51067373051e4c70c2f1cc22099e2a97c9d5150a091e2f572ae44aa15a2a9705e2b12525385f5a58a456e17c894aa21c241107e2a6a6c9927ca5a41c4f57486499704c8ab0425ea6c64be48552112e922b2a94700c0ec91321b8373c85b371beb0445184270b6522b9a818b4769317c9f0e432b10a72ca2c92aaf0125d3a0572251e27cd2f918a842538c511e0c801535c252f538a24e054a02e172a2578994c2c51e26aa8072f134f918a243295241a574924b8a4345f22164bc47809d98a8b252a9152aa800a221e62895a282d5105c6039a5240258de423c4d54aa158522a5416e3f282afdb882f292c2b112a357d51ba647c53a522a51c4ae9972d51aa20c78e8191c1140ac0c810a46626cb810a62bcbb44ad2e9128b523705599425122058217c865ea40bc97bc0c2f1556e06540053534166cc6d5725ca49408d512362e96aa14c0806c5c2813e30aa514f48a008a049c852a5c2151964ad56a402ebf02194a630e35e80056556a8002c8810dcfc89c5a71144ab9b84ca466e3300cc058361ca3612095e1e5455251918e64e580a954262a2913c398d1482f979554e0be523fd22d3ae880c2b7a425bd289515e24a894aad948aa0ed9b19c0e15a5ad1c802be52c0452d29858e524a0157b1bc5c5622178a5b5a4f489a0a380ca82307acc0b14cad005128964035214e91a444d1d2a26066c82a2874e8104010d8a7489a2f0532079a9ac26829909794c8cba1c894a9d978be50056495cbb491aa71826f915aad880a0a92c802cba5c55285442c1506ca958541b0160430f3a898f603ee4561a1828241325f9e845f9a3ca7298c148871069a79801ce8044d2319242901130b99bbe53485a66c31514d4d33a07354289a81dec0041230aa5029049611b3f102259874207a4445426521d019da18d80a78140cc7e5f960b2c9a05184285168e2ecef6b010512aa5472915408e3432c179595028f08c9f92c2d0196f185145b688b0ba84c71c60f492496008252d20f5fc4c3cba5ea22d8ac136e6c2adca0f49aee122988539237a4a5247325e0802611d4908d97cac5d2027896208328ca8042aa22346101e9fc32387955b0918a12a06110505c2501c9175080bea6acf44551c9090f58929386b23412a2bc485efa0d1de1342853ca80301244402c071915c9324022526b02ac398e41f08ba568e24591212ecc970f92e8247c9002e19441f2c049a6688e14aa4b5524045ae54b5acc5ca18ea24ac85ea506c124052e0293979ce8df32009c6fc95c5c909e989913cbe7e23c019ec14fcfe6257013709f5801a8fbb0f11c5e66727a56260e30f8b16999bdf0f4443c36ad17de9d9796c0c6b93d33f85c81004fe7e3bcd48c141e17b4f1d2e253b212786949781c1897960ed6151e98898068663a0e1952a4785c012496cae5c727836a6c1c2f8597d98b8d27f232d320cd44403416cf88e567f2e2b35262f97846163f235dc005ec1300d9345e5a221f70e1a672d332030157d08673b341051724c7a6a42056b159407a3e922f3e3da3179f97949c8927a7a7247041631c1748161b97c2255901a5e2536279a96c3c21363536898b46a5032a7c8446499793cc454d805f2cf81f9fc94b4f836ac4a7a765f241950db4e4676a87e6f0045c361ecbe709a04112f9e9803c342718918e888071695c920a3435dec2230005d6b304dc665912b8b1298096000ed6450e3405572d72740704ef4664e84e231faba09982fb8901a07e1fdd0b69fa05d4dd8b98dce766cc656c60ec663482bf1f193b18abdbf6b9dbf6b9ff0ddbb6ed73ff73fbdce4d3c3b6bdeeff9f7bdda4f7daf6bbdbf6bbdbf6bbdbf6bb5b67f3b63def967bde1aebb4ed7bb7ed7bb7ed7bff9fdbf70673b3f91e5388d6094dfd3abae794b4b80795b4b8cb44f7994c172687d99d99c4ec0c8e91005b08b21fbc56277356116d3dad8181a11c1a0bf095e833619006f5996b0cfbe80164c2349f7f6ef14fd3063f294d1797c80a29d84e45c25dc09f7bacb254c6c6e32b94256c3c49292966e32942b52c5629cc07f7e99ff5c1cd331203d1a7211ee0cf793e38db90ec9c671035ce53f50cfd6b936b5f99d2f4e9f535ce35a069189d46e31813867aac0e660cba230b23847a461df4684c5a4d389dc6ac17103d08b64e8bd322972a27ac132ae928d9ca9111e1e2dc0516c24d8718d3c6f7d309a6f4c7263787823fee3c4a34e88ccfcd2ba9afb1171035ccfd440d63653d834ea3d3ade11784fdb8cb3c2de76681240209fc2361aa9596c6027295233119594c3d6b7a9680634d58c28a81b5518e5055249515aae5328e0561061bf5adf5f91271a95c26e6b8104eb0c5c8dab679b75b67879fe346b8c27e86b57d737fa6b4541220500b4b1578467c2ce1d2ce94d3918824c239e16111a11d7b836a844e95a8def88f48664218c17e636b466c7a3cc787f0226b2eb278a9026e4d2708b838579016d5312eb16340704258704064703c87e34578900a397d512101b9c14fd4d0dc750d4c63618c1a9a3906da8de835341a36bf6f4854b839fdfb454b9ea71dcd5dbb60f865dbdd7f5ad397ebcfbd182bd9d4e1d2c25027bf9b15dd66cc3b5adaffeeebe467c7cddaf31eeb8777f28bb25f30f6c33bf6bc75859fd4b6f30cc7b0dc4d0fad3a1bb9ca02b70a1abe7baefd87bd87e2271c4a0d770a7759e0e073f78ee11fd5269efb263619df3b383775cf8bbfca165dcf74bfbe75e7f34e931c4ac577c6f5358d3d1ded2b9b1eb7cf29c75cf87af89598353f6754f69f1463e14ebf7df0e220879427472c861ca8dce5b6ffaf6995ee79de63173c7d2f1e5b4d4bf934e4b7d0518746e7b2c7ef2f7d6ebecddae343aa7bd5b650efed9e2737cfae79756dcce4b9f3d2366eed302fc8f4eeb2eacb762bb322fcbac67ecf787b61eac07d740698468b6b6886c0222cc21998d4d98c69c7b4b1087bbfa229a3ae5fcfa4806e27ce5fdb66b9cff90d0a21670fa63d615765e311fafa223f5161f438e6dda0779b3aac3f10b6c99cc88408aecc54a23bc1ab4faae7d6c653cf0444ca92c0528d9f0245f2d22045b114b606518f6454415a37422f222782a00c0428444f3d03302f592c7d1a8d99427423923575825edb8962505e5efe250612e53728ab096b28af17138620459261d06a3e326094f418776c6fddcfb4bd558e432ef4ac77b7af8cac78d27479c74bc58d3b15699d4acecd9d6f32437feab0a6f3327b7c76d2b5e71f4e4cf93506737a70d56f7a4addb973059d4e9df2b29cb62bb41f4bef6d96a3b2b16efb9cce1bc74cc95ec3e3ba65fd12ed111661d3cb3669e4f8a75d4f5eb09733d7ccbc7baa31aefde85b6ba5bfbe5eb3add7ef21f75e844d8e1c1f3d3fc8f16554ef8ce4ac93d7aa8cecfa8ceb3460ec0449bbfeb34bba753e1093659bfba0eee2afbb7f9e1f3ed93a616df9d013192f8cebcb87996dea231f92b677769c411cfbc2cda078ef218c55561fc60a365c4bba3d7a6154d7e83773f2b953d68d9a363c2ea760a8e9298f69ec0b359b6eced9fc83e46cc8259f096bfcee13357a60ca30eee964b1036675cb2e6cfce3151b65b103ba563306596cd83f922b7c096f72d2bbeaf68b25b8405a881ec800c7c2c7c11c94ccc289080e27980025944c66cd5542fd8fc847f533bed2ff2fb3d1ce9cf311a736e80de705ac28dd245a58b9636b945b9fcdb3d74e3cbba4bafe60d941f6d39a18ff6dd582f217229ad1ae13e1231931f13935dd4f3c76ddfaa1aaf4c8fea9b9ac437f64f7c2ae9b3cccb9f2e1cfed537c1acbbabd2fdba8ecb9f560725d483eebd48ce94b1b23ddd74cb44a4dccff3dd8e1c44af7bed9c91be4dc238583f27389318b837c0fba66f85facbde468e955bdbfe96561e0dd0ae797379cca9ad28e1d7a7fb7d1b82ac9efd3afc7a51b4c8cfb3f2cbc33b27d5dea87d2a4a84317f70985cf67583598eaaf15b95d689ae3f4697056f593a515f7f09a3ca3dfb7081c326939a6a3a74edc3ff4cfccdaaaebf9976a545dbcfb3d8bb13a1d79ce9b613a6a0c27cfc878bc261b0d07161942a61b2f986eb40b738a014d3b53193ae96a9975aeabdbd8ac7b8c270bda757cf03c734c98c33aa207ecb6648284b124914868b5d08412c1b0c6b2ee101c42109ce00ea20822343f4c220c088dcc0f0d080d0e89088808e9181c208e08e314088383c3420b442d3260b24c7c3b8375a66665bbf070f72da5cb8f96d1677c3d037e3141c9152a940441b4803006410ce217866f1e3c0410e1014404ca80429d0c9845806b159d0cc8fd970c3449f01b2cd4840914dc9a46fbc4a41358abd9cca8a1d3b0d459e9a1c3fe547c3fefe639c7eef32c87157bffb4d4b3e96ac259cf1d9b06188c9d33f717ce5d45dd271be7f5fa91c36f11d1d6ee57cc0ecf28dc291bf67ae88c25536ac2bfff61c4191e7ddfea35bd9e4eddb6ac00335b94e275f68fbbb9faf4a3bea192e8c8116b66f84f3a5a7fcf20cae963972131bce9a99332bd8c6e6f3864f46460f8cf75fd3abe5c1697f06ed7e8f5a67bc32e7a8fcefb54f8d457fd6a1cc1b41c5778ac7b58ff016e770f4cd41fd1af6ed5fc81ae7ede8696675fd69c39dd51df6fedbd69a55386634796f77972922979d760962338f67cf6d8170b6dbf3facf793882fa4a7e7243bbd7c57667574cb9ba6fdd2bc9d0df34da5237c1e8ee8e25ccc39f0c4eccf9f46c68f7ec299a787050fdd868ffbd1c0e341f67afbb31b77db3e0a7f2c3e536c4bf7f8795cc8e8a853755bf7ceecc5aea70946d2f29e0fd957b9fed1d90bfcbff2caaa137ad945f8087666bce837f0eaabf33dfee09c731485f9cf1ab6b0203cefd7ac90a71b8fee627bac4c7079f2ae3079f3bdb803e6e37af45c9448177af77668ec3bfdfef218c5dd3e44cad0aab319858b963e317bd879cb9fb72b5caebfece920df39b674f00dbca7d7a75bc99beeacfb73630cb35d62c6599392a936df3d397ae32fef2beda399853d02cd97b47b15f7a9ebd4b19cd7cb766dba1dc5ffc33f647837f154c90589e5d64b03b66d2ee1bf6f1c3fd0ee27f609d5dcfafbb906fbb8dca57eb58f689cd27eea9fb341baacd1d3076bc053720d3012da1585a2d4efd4fa02360f655323c369de63bf7fce16d31cec18201a390e44bb168d86da600561d8814c9b9ecd69932f9783dc0942575a201509d5123cb64c5d24574ad51530b713e1442811c2090e0b2122416e0fe6a06a0801abffbd2be87f95de1736946cb87a29799affd0e24087ebbb6fdc3c38a78747c69a1397edd33ccd9f9c5a762a658d9ac02d1fea9fcb9c61cb9bde3e6edadad97d09efdfb1e27b43763f1aab6ffeca8c39fbd9d863aebf84788e9effbca9d089fd7ec8dd31ce0feea62d6ed8e721383af12df757c393fdd69d5c1fc75cf4e68792ef0bcffbfe9128585f7bf2b66f62a0cfeadaf42cbec92d06fbdd80295308d9e817bd88f96f87fd366bd33db759c35e9fb67e61b04d50cadfcc9db23019eb965460e9e357b07cd6ad337ad5dd16bd19b9cc32c9c6b066e1c8c759833fd2e63a67188cc22c88c4c7dbae7824eefc292073e13a97c1b19cf2637557a3477cdf20a46f7136ddf0fe55dd46da09f7ee999fdeb00eecc78d35e97d15b0c832c25c9b715804039c74d2f9172f2e8d61b7399309e2af96b0d033a496045b1a6cc188ead9646eae9e42544facb2315b5dd33f26db67d66d2febf7fed78d04337add5ad2205a22fcc7c3b3c6a2628d5d43b7faa56b52543d9bf4ad03254406b928f08824825b1f5f1f5bdbf5ef5f166bbb9580234ce56841c8d459109209b0bae92c0811ffce2531d4239ea4fa372f8781ad2d668d3bd09791d0f1f2fdcd6bca2f9da8e8914adb10a81ed8a7d4c47ad5893d43266f0f3c6bb5684269fef61cfa2f69b875c69ccb9531377276aeeb39d7e9ba33ad76f5cec1cfc79f7c144d7b7263cf6423d6e189c9379e096c2fa7af9a76ebeec401e7aaf6dd99fe5c2f6814e3fe547f4f77c5bbbfdedf1a3c27d0f495fe0dc52efbb4f9938a8d9433b63744ce2b0c38d8c3ec417edfae76b3c7e35d6fe83b06bf39c6e93688d3b983d2f8f00345e74fa38cacafee37124e7a767e7bbb8769e3871f0cebd06f71e3c35ddf19c70d392b50ba3d218eee1c2ce9db87d6cec8c6ecf4ef36b35f76fab1a0e7a680a0bb6f46d51eeb917d6fbe627ac9eac894b37f5534aeb4afccf77bbaa8ce2f54afdc31ff48679752d79a67c687d83b7f8ddf74fbcda3efb6dc5cb25c1db63dede0400f2bef41c69df81306f64e8cb7d9b569d3fad4c2c30be33e5555b8552db0250aeec559f5733cbcc0dded64fcfd0ef77736251f639fbd105c95e2ed9fec99d7fb41f6d31faecc997f344abebbda47ad67f964905b635dcd3e9fccad1b06741edb3048b859d660fd43e3caa46756f20fe3824b367ebcdae3f0048f2305bbe73b8fb612d33b07aceb3579fb2db7db5bd61f156d1e9cc93a1b1b98b17afafaa583576daa9f59e67871da68eb32f7a0e0e506b2fa3e13bc1aeb9f8e3ceaf6db4397f423739ff0aebda249e4638dbf3b2c3d7c47f660d9ac131cbf4f6607fbf4bd90dabee1c2dba0055d03b3ec8a8f582ffe40d4e8571235ac7ccd526036e534f9767bebbb80ea31ff482a0e26087242fafd9d09d97c43c001cb4644301116492e1a1d519543c0ea7ffd86a586fef9da41876b071dac1d60cead7af65669e114b8e6826c658d456ae88ee75b7bba2d8c6bef5f7cbf77c6caed7a118e4cde8ee1074c5c2e8717ff6c75c1f859c4fe397aeb0f479ea3d970e2ce8c35ad108f1e36bdbf67c9ba05bc79f78bfa9dbe5a27d868c43eb0eee28a0e6b2b0dd79d9fd9eb687f47d6fd8241f782f9de564177571964fcba29615bee859f021965ab8a5efc52fa22aa6f835d53e28e6b11e2d53271d8e01fea45e6016762be7f7df38abee9b9be154b797e774df7d45b97ef99def9e9bb9b1d7a5bb8a666fb2eaa545eb38adac6eb77e1f1e3f8a9232e0ed938a4b6fdc52e1b26e4de1b9b3ed2f1794350af5b53a203d686f43cb8adcbc7e0339b189d376c5c372d62d8e9f955ec9769d953ddc2bc0e44cac4c3053be699af71f018f94bd30e46edc45779cf4ef21b274c1fbd6baf9bda2bcfde77eb311fdf08afd991dd3afe3a74c3b4b54e1ecb56143c12ba0eb8eecb9b9f37e68657ee19b7ee5df83f6dc9e9eac97876aab24fd0398f9b8a5cf31e89e59b5e63d777ada6d7e45dda6bbb6977fbb359ddef463698dff7e0edb2df9e30947b6bdf0165e535e55dcfab8d89730e3eddef947369c4c447a93c62d9aa49571ff559b8eefde5f50537f6cdaa1ef2f8b7c7ddeff2fc9659fbfeb0ecbbc2aa3be3f207e76d0c1a793e675edfc6725fdf3f1f971ef09dcc9e1c139ebeeffaa884b13f19a61c3cbb343e483de395ecf560bc27db3ab7ff8cb95dd24346febe7e4cbb2b0bd29a66aedf95585f32fbf4b5dfc64cd0ae9d8fc1da79ff0bcb5ff3e2f9c5fb1207ed001b3ad3c4c50813a06748f1586ccb75f5b34559f78e47191045e74c89ffd1869576fdc1b2439c531e634389dee4e2063750d3eb53ebbbd7f2fead3d1f306fc1ac0593557b53924784e40507a365ae9fce32c7273288349d652eeeef2d73dfa0af26aa1742e17166f52ca27a3a513d556ba44006513d82e8aa6147a7d985fcabdb2cb15ca4029a494b85ca0a91421558a42e2562b404e844a84b30ee8ca560f0757bb8219f871ed7918f772b404d453d7896681fbf07e2ce5fba112b7c5ebb74f6b5cc0ac7c03317d485ee75c6332daf8ba6cd899bf9dde90a9329fb247981ec2eaf0f284f958ef8b8a7eb3da3a3d18d492b16bf905e1235ba872d9d952b1939e5bbf1891959174ca60d3dedd8dde945a7b8f1fc93eb3f14dfeca21fe85777a773fba567b738974f8fbc715f7c24a1f3e04a8f17d6dffd30453d6262d32fdef444fffde32c762e59c132a97b5cf4b6287046bd7f57ffe29e3c91aba154d67bf6cc5b239af64e7e91d8e1cafbe893bbc39ecabcd6de5ee7f3f8e4e51766ebe6f8ce9a9d6ad6d9f8b9c1d8df5c0f04dbdf787630e0449f059b7991463f1bedff79cddadb1b2f5eb21dd383db332278a08fe3f00d4d3eafafb0a370e9ec8dbdc616c9e4cbb6a90fc4b0f47ea0f9fb76a9e96a9d5a60bc7753eacbeb93873bc96dbfe32e1b743bc65fb2f8402e3fbff680b3a8e3acdaabbfbf78fddcae61aecff5e34b679d7c922b8abdd9477fdee82e7ae57aa7f43694b9daec110ab73cfbe3e7f6cc3d57630f99f93eb922097a34ebaf86be332f60bf3524eeeef562d652c3eec91673aa5c4f627e0737d42dedca2d7709fbf9f4a2450b2b2bdddf26cf705df52ec9a3eae582d78dc5dbbacfbaf1b06cb0e3a307e1732aecbb7ffa6d934751d99d756fdf8f7f685cf5401abdee3df1989932e9ead5b252d1d4cea7e667a7a53756e5b8370cb60c76ab7c1a6bb4a1ebbbe5c796e4ee6b18539733303b2d99bb37ee48dda03e4655c9c51f2a16eedb5d5a3ae0085f656d5a99719c53c35c4fd43057d36934a27ac67f7be1faf26e60f3a391faea9f60f2a182d890c131d17dee02a468ae1973cc08dd5e5bc2a37920930352dbe2cabdcb264ebbc27a9ad7b37207e3c8489fec0fe709b1ce10134e369159ef5ff5a56fa7c0a94fd2c8a9cff5c0cf1155347857797e7566675628e4854aa1a2a8026fb536336b68587efaf1e20fb34e9c591a3760cffd450d47efb8043a9fb78d5f3eb57094287072edc024266b4fd02f09fd960bb2cef53e515624ce74dfe134c9cef763446a48d2a9fcc32bde3ec859dae1cff8dbf7bb70bbfeca2bcccbad7e577b237d433076df60fce651fd2b89b4e45e99cee3aeb957fb6d0b3fb1d3d947102f9c217cbee4b4bae2fcfb6d833be78eaf90ad506ef13e7879ff9e178a72d9fb1e656e66577f9bb7d4c7ad2c6cb3d389b9557d1ebe18b5e4bbcb03137f7837d822fe52e2743783a2bbd5c76f7b3e5524d62f28dfc93dd8ae5d87ca3382d7920cb3fb8b5e5e18b8f79119d1b7be3aba6bc2ee72e6f5efbfb7c8593d7a016dfb9b1ebfe8350cb8f732d267c88494f299f72645d8ffd5d45043f70597279ecd3ed2e3d4d06d4193250acd49ffb51bf12f3f67d389c95cc25e37248d9b9f17d200736d0f8b630eb791391c4e28111a1aca09edfd5944a662a3ce8b9afc7f7adeedc7f8c7fcbb6faf89e93ead6e9960ac84dd3f5566f9ddb9ed5e389d7d687361f074e9899acab1ed5d03d6597a3f5fdede60f59fdb79bfec1257bfcc79cef9b8f07a70d9293bafc2c55b36f400597255dcf3db2adab0ff09c0003fffbf6c64e19479ea53f1a163a29e4f77923714575e1c70d57fe8d8ffe0b569a260ae6295585aae07e90719cbfc73b6d67d9c08c09b8d26c9a33aeb2a674ba5027840b2d0c14b8668b2a93ed6106f41a373fa72f901f4b70e4fcc5ebda644165face3bd59d45d6afbbf071937ad2f7dc8be959ab8d89eef11a1394241b79098820d3b5e75436b6aa2b92e274e7dcbb4cca7df98ee84cab876366c98175b96f9187d77619ce92e05f35c37bd4691282758e323d2e7ca6ea8d68035dd40b1a3000000d20b701f0d0a656e6473747265616d0d0a656e646f626a0d0a313638342030206f626a0d0a5b203237385d200d0a656e646f626a0d0a313638352030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e677468203232363e3e0d0a73747265616d0d0a789c5d90c16ac3300c86ef7e0a1ddb43719acb760881d132c861dd58b607706c25332cb2519c43de7eb2173a98c006f9ff3ff15bfad25d3bf209f41b07db6382d193635cc2ca1661c0c9933a57e0bc4d7b576e3b9ba8b4c0fdb6249c3b1a836a1ad0ef222e8937383cb930e051e95776c89e26387c5e7ae9fb35c66f9c911254aa6dc1e128835e4cbc99194117ecd439d17dda4ec2fc393eb6885097fefc1bc606874b3416d9d084aaa9a45a689ea55a85e4fee93b358cf6cb70763f3c8abbaeeabab8f7f7cce5efdd43d99559f2941d9420398227bcaf298698a97c7e0007fb6f270d0a656e6473747265616d0d0a656e646f626a0d0a313638362030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e67746820363033332f4c656e677468312031313038383e3e0d0a73747265616d0d0a789ccd3a0b7854d599ffb98f99c9242193907708b9939bf7632609cf8448262f4003212401338092c9cc4d66609299ce4c1253d4228a62449a563f71d5aab5d68a58bd0191a155a16a6d7757b76e1fecb6dad607eba32b2ddf2eea5a4c66ff73e6e605e8e7fad96f7b4fee39ffff9ffffcef73eebd034000601e760254acefb056d91fff8b0180b891bac9d9eff0977dbb6c022717236db373282495bc787e0f2e781840147afd7dfd57d5bcc7233c86f7037dde915e88397927c0fc47117fd1ad385cef35e857a0ac0ff05eea4642c283fc65282b0ff13c777fe81af31aee7dc44f027021afcfe978e5cccb5b0132bc48dbddefb8c6cfa5eaa83d6b905fea57428e7d275eb502944a88570c38fa95b147eebf0920f32c8029deef0b862279e0c279a0fcfe80e2df74f0fb7500b115007c10a8af22f7cda2ebefabda9650fba121db40f9e07b6b9ea136c2afff305114894cae34bc6b88453496f1d30b4743ece44aec374d1efad46278777a66eafa3aa39c84e5c0319c0313586123427f161f88ca105e2163208241bc475c84687e74e41f845e2e298e1745c211bd8e13f5174886ce758d12d8ce4a678f89fb265791458658f2fcaee959e115e863c05fa338f7189c169f02c78552fe5e2f7d36e4ffad64f3e7a0f9cbac135ce0f9aa6df9b217ff046cffffb6e11217a7ed8064e0e94032f1d6c1ec0d0317ed118a0be217d7517169f2ea39d8c62f2eefb3af6bbe0a21ec12c0867d1c183042c2d9dcb3ebcebace06ce1e8b4400ce9a67b084b7b5f6930ba364b375d6adbcac76454df5f2654b162faaaaacb05acacb4a4b8a8b0a0bf2f3e45cb394b3307b415666467a5a6a4af2fca44453c2bcf8b858638c41af13059e2350d62cafea96d4826e552890d7ac29a7b8ec40826316a15b9590b46a2e8f2a753336692ea70d397b2fe0b445396dd39cc424d5426d7999d42c4bea2b4db214269b3774217c7b936c97d4330c5ec760a18021f18898cdb8426a4e7737492ae9969ad55543eed1e6ee2694371e6b6c941b156379198c1b63118c45484d93fde3246d25610097d65c33ce81211ead5233e5a66635436ea226a87c7eb3c3a5b66de86a6eca329bede5652a6974ca3d2ac80d6a4229638146a646d535aa7aa646f25077e03669bcece4e8beb0097aba4be35cb2cbb1b54be51d76aa23b114f536a9695f3f9d3e83a2f0a4c6ae5b66cf66f1a3cde91e89a2a3a3b748ea831bba66cf9a696fb7a30c5ccbe5afea1e5d85aaf761145b3a24d4c6edb177a9640faa94a827d4aba87f8adc4c29dddb2535466e90dda3dbbb313799a32ab48f980f6766da8e47de80cc6669b4b34b36ab7559b2ddd1b4603c1946db478e64d8a48cb933e565e3a6c46860c7e72568405cfc6c40999e631063a7504bfb746409b548be1c2b42959c125ad225a34fcb69a72c8751e77264c3cb4e7095eac28c78d498c6ee51530da5d3f5aa986f92a5d10f012b403ef3c15c8a43a3e8f24d1f0205699d4cd71ace4fc16a69a95a52424b44df8839451b57327c4979d95098ab97fd2609070c1fb4616c1df61a2b86df6ca609be2d6c831e44d45d1bbaa2b8043d5987c1662db5ab5c379d39393593b291ceec9a9a995ede2d63253fc536738a6a2898fe4b30a5ce6f76d7a824f573a695e87c4b87dcb2617397d43cdaadc5b6a5730e169d5f3e3da741eafcc62e3e8bd3202e8b67b358945ba79929d215a70af9f8a76345ed0aeb0d58958c42a455aaa97b4db4b71bcde62fb8281c394b57b161669966a65a533a175f31079f635edc288f060b055c4be7e6d151e39c39dce00de332d9bb61dc46f6766cee3a6ec237bbbd9d5d8739c2357637d8c7f370aeebb8844727a372d3548a4914831682057b9833b0a9ace37844ef62b3022330dc1926c06886291a0167988bd24c8c8657398c7726d5277385d80ab802f09154e4dbc6faf5acaf63bd95f69cf5b0352727cc590e3f4887b2c3d9c538e4d962dfcccca92c4ccaa92da4789a6d85b738e78dc73272dec4fb506155cededaaa9c1bf1b6e23d8438e52b7cac38c757e8ebf7ddecbb455806a9a958494989065b98bcfdf4c6e498e49865636172c256ad1f7b563f76443fd6a71f73e9c7aed48fadd28f2dd58f59f463a5fab17cfd589e3ed990643019e619e20c4683c1a0330806ce0086e470e40d5b297d4627eb4c74d009b417186ce2684f5f6cb1803962e0e00a50e7f32d5c4b470369514f3aa1a547523fea90c3c4889915e506a226b5404b6743bababcb425ac8fb4abcb4a5b547ddb96ae7142f6db91aa727b31e29d5d6112a1a43d59f4103d0e8444f6dc9ea58d763ba40ed5a5d725ad4cac5ed57489ae5beb4b67aef4d2d9574bdbc833904306418f7de8883ee70e3da57620758c51c728758c51d3b3d5bb5a3abad4c7b2ed6a150522d97672a4fea86d273d77bbe56605ef6ef5b62177babaab4792c66d47b503b9a0bbc7e9a6a343518fca4a936a939ba4f1fa9d9798de49a7ebe5a671d8d9dcd935bed3a6341daeb7d537cb8e26fb7168253de325fbe7a8bb754add7128213d174b0c931e2ab2846a6cdd7f098dfbe9742bd5b89f6adc4f35b6da5a99c6660f4d605bd7b8011aecb8d9d978848b35622ebab3ccf68654937f254bcc0a73faf5593f12803c0ab178f6c5e173341e6f3a555e5f5e4fa7b060e8d43cfa88d5a6d2af5f61cefa1179549b322139516e80d2c1d20bae20bd20bdd9d3446fb4e478e424b7eb70524e55a9bd14c4aba0525c0b39782fe0ef842c80c89bda7d7ad21e3923ee0079727be4f5c2042cd1a7b43b7a39f0ebe26a28c6827d1ecec273a404dae064e455704217370ce548ff261cc3efb63f40137e37729049ae0529721fec8302b8111e846a21337214d6c27b860448853ca8213ed0410a7e73dd4f5e87cba10565acc057d25b2180fd06a47f4c96e30c01235c85daef847be139f817f82364a0440b9c227af271e4c7d0081d68c34e380e7f101bc4db603e7c0b7e0007e127f01fc4421e267fe2ff1c391a7939f29fb8aa182a61296c811e6cdf86ef22df0fe09f3999ff5e2433b233f268e4e7b000ad3f845eff047e8aba3e2212d9449cdc23fcc8e45f23039143ec8d34855a8fad1ebd6985107c1f394fc17912836d379e93759c7332319246770a48f801dd81afd6fd703dec85dbd18b7be0017812de2375c44d5e217fe6e2b95ddc09b14ddfaa6f8d3931f19bc8eac847a8230ecc68ed95b003dfa8af475bef80bb70e57751d78bd8cec204594a569095e472d24ebe496e26df27ffc39572af71e7f9797c025fc6dbf96efe5afe2dfe138338b17ef2c0e4ab91b6c835184b3c8e309ef918b526e884ade087200cc3b5b00baddb8f6d0ca377089b8af13c81ed05f83dbc8ded1d780f3ec0ef6a117d3492126c15d856101bb9826c24db481f099203e4691226cf919f923f9173dc626e2957cdade7dab93ececf85b8314ee5c6b913dc69eebfd1ca1abe990ff2dfe00ff1cff33fe77fc9ff0eabfe0ac121788441e14e41157e239c15ce0993228832368be8101f9c7868b265724ba420b222d213b93d3286ed3d8cf142f4a6000ad19f36ccaa137ab172fcd8be866d0463b7073dba0beec7d8d1e83d0d617806abf479ccef4bf02afc0efdfb3dbc051fc327181cea5f0a3193725289f1bd8cacc6b619f33444ae25bbc87e720fc6799c1cc57692bc8e5e4ea2879b383b773537c45dcbddce1de0eee58e7327b953988908afc34ca4f3abf916fe4a7e0b7f351fe2efe2efe6ff81bf9f7f800ff327f997044ea811da848070a330263c243c29fc4cf895f0ba5821ae1047b1a9e251f159f11d5d922e4bb758d7a10beb758611c3bb864938023f8371387ae12713d94b4c641c7e48dee5057e17f732d7c5c572a7c86ee117a41033504b40dc0f03f05f686136f925b78c5cc93bc9668cdf6ed24bb6c077f805fc43fc15f0b238403af836e2820ee1007c2abe000e71943bcc73e2283f413ee10e811bf6733b260e46ec641e749087b947b062ae835a281632e114572d1c27f95c317742ff0409c34abd8eafe66b0c09883dccbf8d66761812c89fc0c1bf85fbe74ddc5beddc237826bc435ed7af47eb26f82791e73a58491e9e4c8483a29deb260bb887c9da891b27fe9dbf37f200c9e0de0298489ca8e71ab1e236461ee39e83bfc081c94f8437e039ee35d888a78693ed9cffc2bd378c27cd26f8948bc7fdd481e7881fcfa63efcbcecc3ef671eeb67856da14eefc4af3d5170f260d4894e9ee73263f482934086a178797a69abe95cedba89da56d347b5eb4c13b550573b514befca8a4589e6c47c73a2b94f804f25fee4a73611ce83249ca45ff578a2c25b789ec6413a2c3b06247ebe1e331426d73f955a698acd0c936c5b9c71717ca5b078feb60c655f7aa9e9a3d313a74f43ddc447b5752431a9babab262becc172c59bc7451157ea0eae727ebe45c0dbda9a04bd760ada817b97a4b797d7db9a59ef4f1a54b521ad7ae5d9b5172fe054b7dbdc562b341f43734e12c9ef77adcf7076d6b97c3726e8de016c220961b6b8d6b8d5b8d5ee3b5461d188c441f63d4e9634430707c9c108b1fc142b651976c34ea08c7f3d9468220017db62126462762c08c612ef4944de08d7127b8afe1dbcc0ff1b413b137924f8ec4d2c06598ce9dce3c73261d239679a6aeb6b6b6da8a61136fb194de72dd8bb758d2e94092aa69a37ffada5afcabac80abc85564fe22229345f34533e1df3ee89a78d63df163f721ee91899b481d7f82dcfed7a7c4b59341e7c4c2e857bfee55f4d00abfb595afb65e691db2de6c1512e48531b9b939f2c28cdcdc727961616e2e272f34e4ca2679614aae2cc90b0b72e570e45bc7d2c02aa55bacd630f1d96c69e9c96969e9a928b3302d15c1d4540ca035cd9a2ea595739634c267a4a7a670d6c282187cd3b3fe063ad22ad3d232254b79618ef47202e1a810a32921a3a2f26573fd517c836a65a5835543eba759697a072be81da0b1a8ada57d5a354d756275220d4262f59cd04cbd81555690abcc2431392d75d1a214f3924555cb962e495c5c20cb4bcc849853e45cbd2ee58259c2e74d9ccbca6fab982caad89497daba391dcfaf0fc869b2cb7a655eea82fc36ebc4c98a2be5d4890f85e0a7d75c9753929fbf580af043a1f6fcf3af090cf974749abceffcadd18a7e93df8e2748312c8341dbc2af9790e2d205786896a0c6c57c56fca2f2922c1e38b122374f4e0813b32d3eb5ca402aaae4d86a0c525c98e88f2dda2b7d58905125e2ebad2db6dc5a90b1bcfa4373899b056add9973674c13674eb7d23041ddba337567ce986a6b135988d2aa595d141416447700fdc906b703a2850572ae2e2539352d95d220ba4596a6e9286d51155a861c245c64b963d35ddf7b767b43657e6a62c6ce3cabcdbe6dfbd3efb6b74fbeffdce3ef5ffdccafeefbce7dbd3b6fb3e666f2db0ae5afed5cd23ab4a67c656e8531e1e6a4b47596b2fefe5b8786f6bd32f9c7b3aae71f77eb325f3876ecc4cfefe9f876451e8bcce42a3c3955dce945f0b8ad68a12d3b65a501b2b2f3b6c4ebb3ab526285792569d2dec48f62f83142328a84b1a25a434c467198cc1bdf8f1b1f6be4cc6974d5741afd47d799ef89f400681cb1952d2c342617e427e4e716cc2fc88f2bca8758a33c4fca270b93b12b8ccdcb276613763949d9f980d5424a4b4db5ac6e6eb8012eef1cb125a52ec82a48cbcf4ccfbe4358909a71075a499083f2deb00ccf157929aba7655a54f52cac7c72aa16bd02565fff9473284567dcbdfba5b786b6f8ee78734343d9d2cadd1dd73db1e391adc1aa9c65831fefb11535f57137fce2a61b1fbafe8123075e4a4f245b6ef5b6bc78f01bbf75db973c1dfdcdf257dc6bfc13100be6e3c093a76cf362f49019afcb888bff8b999e17a5ada74d2cf358f1b30e3beeb55307ee3e75eaee03a7b8fae8780a6555696d08defd5b3472efffa571459fd37efc95b4b7febe1a7be158cc0d4dffeaba15a67ea7a6ef988a0673f8dcd9a3c13c9e1c5b355898c523e233729f06e37308eed66003becb3fa8c131f83e7c44838d44825f6b702c5491731a1c078bb8020d8e272f72760d9e0716219bfeba2ee0e90471420b8345fa2f4bc21606eb187d0783f58c3ecc6003836f61700c4a0ae3fb50142610273a34988379e2773598877671bd060bb3784448179fd4601d98c49f69b0010ac47fd3e01868102734d8c8d974751a1c0b2ec33734380e7a0d6f6b703cbf37e6720d9e075be3fe95c1c6593ec652fbe3cb191c378b3e8fc2f19731d844ed8f5fc7e0f90827c54763923c8b3f85c5210aa7cea267b0b5fd0cce62baa232b367f1e4cc82f318ff4e069733f8560a1b66d96c98253f6e163d4eb3bf73c4aff43a9c8a7450ea742bd23adf802f8424a9d117f0fb028e90c73720f9bd4e8bd4e408393e8fa9deeb95da3d7dee50506a57824a6048714df1d5748cf4f7f8bc52cd90120852de4acbb20aa9689dc719f0057dbda1e276a56fd0eb086cd2a697582a2aa34bd6754eeb42437d7d0187df3d329ba4484d01c7b067a04f5adfdbeb41372aab975777ba3d41a9d73710929cd8393c0341a9d3d3af04a55665586af7f53b06a4d50145d921391d7e4fc8e10d4a8e0197e4f50d2b01a723a89449bd9ebec1801225f738821ea7e41f1c708606a39e867c7d4ac8ad04a4614fc82d395089d7ab38d994af57ea77e01c761ea7c32b053d7d0351317dca8012408a7f10431654a4368fe4743b020e67089db648d246a4f5fa0252500985a83b73c4500141a747190879d04969d817d8c1688e2053dfeff7a27be86ec827e12a29c862474330884c9e012918426e47c0c58212b4b843217f8dd53a3c3c6ce9d7626941295677a8df6bed0fd17fbcb6f607b745c55828f50bae1856bc4855d892e9ec4ac1413f1aa844b55b24bb6f10bd1b9106d1e3d074a6d0746740718430fa2e4fd0ef758c943117fd018f9647ea203aec5702fd9e5008c5f58c306fbd98f6012a0b2782128650037aa986323a52ae1973fc019f6bd0192a936891e2da32ba664a01066bd8ed71ba6759368c4a3d034eefa04b71cd58ef1bf08e48459e6249e9ef415b66d851c2e759cbd85d34c35860a18087d5cd8c02ba7c5ad60a1681220f6a0929fd74a7053ca8d5e51b1ef0fa1caeb9d1734443856589eef8587dfa0643fec190e452a89b94c7ad78fd73236a91ea074634769a101488f1717b7a3c68f3e7170ac5ac5af059c6a1157c10807efc28f4e287e708623d3042e2f1c1b41df1f7f19e99ef80108e03e0c23e002efe1e7e9c7f963f81f771fe47fce3d089ebfdb8b217e79d384a7010ef4efc54a6f03a9444a585342e091a996c3feb1d48f7300e09295e5c6f41a889d11d5f5a523d4af2e2d88e943e5c1d8220c3141c15e41dc2de7591bc1af474047dee411a5d5dc3f802b8664a6e255ab70c2a102ac2d51eb436803341bc7b514a31d3d00783b89a466ad305ab97e0ea0a94315bcb3af4ee62bfa211f5a1ac00fb6c7723fe595c0a8b17e51b464d03b84682f5684f2fb34f615657c372bc691c3d2c12bd4c560821a70639d8da2093ea41eb1406b7e238cc22e763b540bd588dba146c3bd86a6a9d87adf7b215d13a9110f3e14aea3fe5a1512f637a3d2c3e014dfe14770fe3a1f6d22a1844aa13650ecec96988c543c1d1cde44acc5f8a49ac529c2c9e5e9c73ce5a45332331dba3ebfa35994e66b1c4b4f6699e4f5943b50c301d511e3fb3d8cf324de3d9866ba83e37cbb283e98b669ad6ae041b35be5e569712c3424c6b343b9f6dcd940541a478981574b6578bcc3093b763169f43b33bea7d3fdb41d1ec45b34b632669baa8d499ba9baa82414d9287452b3877a7cfaa14ea9b9b79e1c77d61c536cc9a0525cead4b8b668b95f1f7a32e2bf621e47130cb2816846d73acb14cf37eb53a68057a355e6596968bf72ef57d90fd78ea65919fed3bcdaa9dc52a9abb111c07b51c872eb1a7a25177b22a77b0daa0b5ef627c7e76368c30ca5416fdc8e9b9603f4e65309a613fabaf7e56ef21cdba1e66c7546ebdda6e1f98b62bba22c8f640e0224aefb40f65d37868fa9cbd383a7e86bb700dadf632adaae9491ad55b36ade7420fa29535cce2e464bbf552311bd63cf5b0bdef453d2ee6e7a5624fd778195484fcc5382aac92a271b994f4a80d5f36b633d25dd37b387a828558e666ce9b4b7930a5fd62bb56ccaa01ea49d49710d337f54ca3f2a3bebad8893ac04e56c7677a1aad3dc79caa8a9e963ead9f393f695443ec740b31f9ca7436a7e4b8d9fef17f6e8d5ad8f37640cbcc8cf4a91de2d1a24ceb87dadbc3221dcded97dfed5373d60b2a7f668fcfbce13818cf14fe267be351e6bc012973de71d8d9272c142a851661b57019f6d5c8edc0e8d0b853cbea9123c0cece50f43f49f2d11f022266faff462f79116d2ca2bf0cb8bc037d1a2c04a370198537e37b3cbdff17623ac5f80d0a656e6473747265616d0d0a656e646f626a0d0a313638372030206f626a0d0a5b20305b203630305d20203132305b203436305d205d200d0a656e646f626a0d0a313638382030206f626a0d0a5b203630302030203630302036303020363030203020302030203020302030203020363030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020363030203020363030203630302036303020302030203630302036303020302030203630302036303020363030203020363030203020363030203630302036303020363030203630302030203630302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203020302030203630302030203020302030203630305d200d0a656e646f626a0d0a313638392030206f626a0d0a3c3c2f46696c7465722f466c6174654465636f64652f4c656e6774682031393839392f4c656e677468312034323234303e3e0d0a73747265616d0d0a789cd47a79409455f7ff39f77986996171867d73981946c01814640751864d2c4c5131412d21dc2b2331b3c525ad54cce4b5f76d5f6c5f2c1bb412b75cb2e57dcb28cdb4de4a4b4b2b79b3325b149edfe73e038ad6bb7cfffccd9d73d773cf3df7dc73ce3d778098887a2153c93362746afa8f87bfb89b88a7a1b7b6fe9aba8695695be289c25f2612b3eae7cc762c3973471251d23022bf03531aa65ef3abf5fe9f88a2fa12991e9f7af58d531efce7804788faf7211ad0396d72dda4af6f7df00ed03a0ec89e868ec0663a01fa18a73ed3ae993d77fd9407f3d17e9b28f4f8d5d7d6d71d7ff7b7302c8df1d063d7d4cd6d085a6ebe0be34381efb866f2ecba770a67be45f4e493688f9b5977cde4d327dd9b89660712a55ddf706de3ecce181a83f1db247ec3acc90d1d718fee44f55df03b8fe45efd8e9d3a7dc5ce5b275a0a7e36994d243f4f54def3bc2c3f4afdc0a9cde978d36faa89499059c7971f947ecf75dc0f21edd6e6744ef19b4a4e3252cf8f2271cc3fd142b2523e5a02652a8dc740a4e971b4981475373793814c86070c1914c736bdac54ea688a0831188451350b6130abea21eaa579686e896f5da2aa4b4b1ca83912de558f76ce979c88a91ee26d077f01f52bd55572a7645277d354898d524efc8dbfe74836732de78a9da2853a782d07f0b5dc970fd13becc179aca12fd84947793e6fe444b6f321be993ea7edf43c7fca362aa589f42d3d40b5b4893ea3466aa77769392dc54a75b4973e06d4d14e1ec0d1a4d1af54cd19b44ff8619b41bc4c9b238a680b65d1efd4461fd141da470df406cdc0fc5d64a3d974583b4c07683d1de05236d3377494aea1386ae70e51c093b91f4563f56fb1325602fd2d3dd2efa0e74b3bbb12a87527ecd6979e17c53c19f477f30fd8699d9487b64d09177db1bb581a425fd1ddf402cde28bb1372feda0567a49fb9407f3781a4417d314fa883f00c632ba973a68146dc3f82cf0148d3ddf42751c4433f9355ea418793307d08338c90c5073f1527e087bcee2816224fd40eb3916336a75a885f47c69af4c1c2d13ed1461420887c811c7c43dbc4858449218447740463b219d7dd42e0ae80a60435768b37618a7f71cdfcca3b891e6d24cba5e3f1760e9d8df4232dfeaf2fe551904e96d2129b707d0be02ab7fa4c35250ee863ac84dc25ec8ad0e9292003a38cf521da22145804e5f42adcef936367236a47a2fedd5e67028afa008123caf1b640ead5a4df7d333eca567b51f844dd864ee83eec4f3844d62fb5affaefeef93984ae36489d50459ba602dce26117607cbe3229cd842f45d4d8fb285c69109b63843ec8445d442c7059fe013b4967fd0e5d42db96e29499072ed8646e8ae0429e773f006ac41eaf3727aedac3c1751b32ecf6e99eaf2a4efbb657956a6bfc2e6e4991ed4d78f85c60d8107b84af677831c877e1d079571348f6ea09b6911dfc70f8a1d2c675d4b13e809fa0bcaf1d05469a933c1f73edd4a97539e6ea30f838f46d8e92e9c6706ecd34a65b0b00c9c61362d1371702c3be9142fa1656c1771b081b1d4423ff1b5e0fd460ec7e80eeaa4addc81da61c056d0df01f852dfbdf4057d29103d2ba0f937e81c4cc4280304eca60869053ca4031cf8b8f81692780192ada61190803fd2364dc39cd5144ec32185bdfafc3ec0e84dcfd348a426b2ebf30f5323bcc5eff4234e741bfc44237da7cf5f89f189f428b9e812cc6ac0ecdf61076f80bf19f0bfbdd1d384198dbaf53d4b1e9cce4cc8e26b11c3eff3fb224a448b18112fe2157fd46f8025378a79a2589dc58ff3117a9f9ee618aea336314858b892fb8b3cf8862df094819c2c32b90f87531b4f65c18b780a70674156cfb2872bb84264f135542306f178cc3884d486315f7a5f4f5d94f92d7e1074cd5d7493254d9de2597af0054f634cf00c51c2774273fbb0bc0dbaf5af5bd3fe3dcca5ca73edf3b550bb5d4f1bb4dbf5764657fbbc242e13a3c452d1a06be9ff057a5ad29fc1ffb283f3ad4d87b3f623e75e00d25eba41e741cef9c3ae7d201244ae9e3c2248d70e016d59016d91d0488da0d1c923a16fd5740d56fb4eb7fe47c137e8893c9cec669cb3133ee31bdc651329177e6731b4bb143ee763f87f690932cfa4b770c79e81ffbd0ffaf701bd078bddafbd4507b92fa5eb36d488f576c1ee5ed416eb9e7825bd4a07b44398abe1fc7789042ec39997720ebc5822cee86758f877743b3cecd3b0a503748c1ea11fb55f70671ea5c9fc1b0553085d0a8f1cae7d851dc5699de019b21023cefa99cf69b2eed3a4dfda07294bb89dea6131beb9722c1ef290deecc2d3ec3e899e1e0e70f654ba6e0ff48dd025369bf6702ee61defa2b24f979fabe729eba7758636c3aab3e84378ebddb08f0751db051ff0327d42c350df8728a59653a1fa0d328a80affa1ee36f8850789b7b917a6b2f63bd11a0f834e63f04993c82bc8e97d1c7ecc699de8573a986ff9b4a777226cb533acdfef04fc5e406cfc77157d5d3121ecee9f0e43b680fa4ff24acb611f1e6dbb8630fd076c44203f5f408db693aee92deda31d8b099d7f17a7e9bffcaad482ff397bc1a9ab108b059318a03481e9101893f4f2bb944c947f451c4a7b18fbdbc1277fe0158d74c3e268258e35bc5387e4ea4f3d77c84dbc445f02101bc19b181837ed56383bee21ec40683947cf131e2855c9123230f3dfa002dacf8bb285614ac7f1be283459c8a3d6fe241fc04ee8b4522096b86711a34d6c517439be2391537b7996fe15be15def4524f82522bfb91c23ee109fd213a2087c0a503e08afa85201df0f9a6784898fe10c5ea579d0c340ea8da8aa0377e80fc22414de01395c07299ce0767e5f09c7eea2b89a5e833c5b010771f61ba0fd1f42a38f2162790771a8c27384950ae8222ee6140aa5c764cc467f83bcbfa29fe938cfc48cd5741a5ab9171eef2874a7087a3492a620663a48359400dbb2e37649418c9349a37183f841dbae0267fbb0d2610ec3fe0138d7549ce58bb0c01afebb3ebb13d42f1585225649121b70ba0ba07795743956fb1877cc7858c832c47d0bd1efa5eb403f9922e9223db63c0ebed3b0c213b400beff24eede9b7568d7bd470d226f07bcc1b534073a3a07ab9f44db2d72ce5a91b43e6945d28fc819cba017c7c06111f625a1db2a5603e30558451748ff837bd28efbb70d14c6d373741368efc29e894a60b56fd2578847f773ba7848b42966f114f711ff1229ec50e6a3b64ced2772f963719f789e877233de5c7b79927843bccc43c5cfe245f1367d2ff6e3062c45ca1705e26bf1ac28d5f9f5f9301fc8e848469217c21f7dfb3e48fde07951534ff0f9ea9dbaf7e94e3d635209528addd01da3f68c557b823c3309ddf16b8f38f642381bd7a6020c5df1ad0ae99eee119769f0e812bae330f87ffd0e905eaa3b0e96d0002f72147d5bb0d76d17a4d2ae540c70532a679f4b740ffd832e8376f507d56517a47b209b61d09e3e8886304fc49d970cfadcee71272ce0708fb4083eae18de13b499ce4ff03f0bb15a2af4e7fc5446b76a67102f4b5edcd0ce6d322e9491216243037cac7c4d911ef76dfd6f7bfc6f7bf95fd6fe13eaa562037cd00678bca41eb46ba90aba0410b7885922039ee87d5e012fb58ef777bdb0de154fc31672ce4ae046c4b3b29681735c4fd3e81efe8c0f2a193df891bd653229b98a5ceb3b0e54feca7d9565fa9bf5311e8b1577c3b37cc08ff1adfc06b7f0b3c2056ffb00c78b1ad122dee59dfc0e87207ebb58dc0bcf9ec15bb90d588a388ef53f80fde2f5461578a54ca2c7614baf21edc72b7b3a172002b81cba3e12f2dea49fe557742d4f84b7f9029897701efd88575f206eed33fa2bb91d3ab7191e427ac44660bc4f765eccb9f2cd840871317f8157ff5342150caf7d2dcf02870bf94b11ca4ff27da28fb0f3ef90d70ff0d38fe11db9033efc77bc88bee21362243f031fbe1e633ff22f8062f4994434ef01ee7bfc3a6e9f403eca9b704f2483e6dddcc86b00cff165d8d50788bf4bc0e341fa0977e407b89d7f415a8317f24c442b76ed6358f983b8654ba1c15e5a02bef7c30bf756ff861523c506ed0ce29a3660ca97ea041eaaf8f33edc86f1948d9e83f002d7e37e5f4f8f211e7895dab5937c1bedd43ec7ab2a5dfb12b2580cbcddc0bb05abbc0eec46ad9dd6d1a7b811be8545b40303e706abdd055fbb1fde723dbd0a4b9fcecdb8b9b602bee277f969ec360db05dbe0b4596588db215dcede17cc8e4114865277f8cda0970e64bd775d78491b789cbf838cefc372ec7ad3a9e27f32dd0a96c70739c632eb41df9f6d0d30f5de9027bc5a9ece0e348dddafb066e8489786de5e1cc1fd6df9c0f22ca9c485edc42bd7147ca24f73619b67435eea16bb04bdd8b8a6bc51899781bb4711e3cbe82285505f65270b60cb1553b2c74a3ee9797430ba5f51ca3594807c46e715c2cc02de9e1db7113d6d137884bfec9aba0356ff1a3d08736dec0ef090f7cf001dd4fdece87b0e637748abec66b69a9b841bc283552bc2cde174d883b26702dde962d8843d2c1fb27b49c3fe52bb11f3bf5228fb60b91670078f082eb5eb09110f025f99809dff5391be1436ec139e453857600338e2236abc7ddf9051b11cd7c06dfbe0f11f53edf9b8a9ec55d7627a43e0fd1fbfd88e05e47ec5d033ff31750bf1ffeea5568f650d8d2c390d33f71731aa077e37838c6f7d060c4076f21fe980b1bfc097b93fbdb27de114e318df78abff35a5e8eb8e462dc7cd7e31e5dcb4594a89da2a7e08df768eb691fa7e15e0843f4f02c787e01f67b8866b309dcb5d22adc2f0998ebd4f5700349efba03330ee195b10af436d35567d3017a57bb597b516b838edba9105e321bde3e444f61b09ee7e81958fd15faef8d3ee8ddf51be52edf2f90fc0f52f1de20cc74a0e6072f9c8448e6529ce36444af33657c823dae863d7d43ffe201e2cd8477e1a1e42f88dd78f5f08757036fd61ff1b4c37f9aeab58fb525da52edc94eeb17fbcefe66fa5f3fec47e77e60158210195d80802daa063f23e1bd8f8fe5bf114cfb93be521a523e94a86218d188ca910817c75c36b6ba46fe30fb279f063d9ff3e7d457fce7c595ffc6ddb9cfbe8fced5ffbf392dcff07135d5632f1b53357ad4c8ca11c38796170e1e5430303f2f37272b33237d405a6aff7e29eee48bfa262526f471c53b1df6385befd898e8a8c888f0b0d09060aba557506080bfd964f433a88a604a29730da97578136bbd6aa26be8d07eb2edaa43475d8f8e5aaf035d43cec7f13a6a7534c7f9981e604eb900d3e3c3f49cc564aba3800afaa538ca5c0eefee5297a395c78dac467d45a9abc6e16dd7eb97ea7535516f04a1e1746286a32c6a5aa9c3cbb58e32ef9039d39aca6a4b41af25c0bfc45532d9bf5f0ab5f807a01a809a37d2d5d0c2918359af88c8b2fc1641a62070e58d71959679a35da59205af92505637c95b39b2baac34d6e9ace997e2e5927ad7955e72157b2d6e1d854af465bc7e255ea3be8c63badc0e2d77b4a46c6fbab3d54a57d6ba0327b926d54da8f62a7535728d6037d62df546de7424ea5c13c4434aaa97f41c8d559acaa2a63b64b3a96989c3bb7a6475cf51a7cc6b6a40037345c290daa62158fa4e29c5a8543022d9975bf16d6ab2ab4cf6d4ce7078cdae62d7b4a619b5389098262f8dbad1b92e26c6b3513b4431658ea6aa6a97d35b18ebaaa92beddd12464da36e5c1fed71449f3fd22fa5c51aec93664b2f4b572530a86765f2d931bda6a3cb5ac5a8b3e264c991eb62a881d751ef0027d52e6c2457669373a9a93e1768f8d430667927e118a67bcd25b54dd67cd92fe77b0d095697a3e9675cb8b5aef6e3e7f7d475f5f825587f265995ca7156c130de5df7badddee464a917c6121c24781cacb7b3faa5cc69150fbb1aac0e14101f5556635a4d7e2a64ee74ca535ddeeaa12bd1f02e1c59ed6b3be8cad875e44975d77845ad1cd9de3d123e468e2cec1e393bbdd605f57d59b7f470af29f1ecd7628d082d9b96efe588ff303cd9375e31da5531725cb5a3aca9b64bb61555e7b57ce3b967c7ba6aded0926a255674d5f0f2d647a18913ce22cb4675a0574dc0d74fd7e449ad46135451ef61c710afb576a82faff1773affc749adda09394b2fce4deb62d39bef3ebf3df0bcf679ec05362960584d141555e39a9afccf675d4d70794d09503228411499ac1d500f07ea54903728354a6f1812d8ba2f55c73424e03ba6fa64acd35a23f5ce6b757fe8fc3f51f1fb03159d86f44fde009d42801cf5f64af05af43c28c16bd6ebf8462678a341df5a603ae3a37ce8846ed85ef649adb2ba36b6ae469a8cfcca35bc7eba5c7cf4037552bdf425acfad747b60a06e71de1c617e65573abcfa49cbe693d3ea0a024b2f5e281fd525ca8915e7324baf0458fd426472dec27a12937d6e5ac69d5b45ae90e6b13e082456d82430e37d5a2eaf28e4e96a3898e58d8716d620da6291277b85b9aa2d7983044b28a8d43a4a884764bc322798e4a1d53fd61acb306622b60eb89d4a1eb2cfe63dc4e90f756254b716273fefa3c8b9e9b124ef8500b0abc95ee7fb34a885e094bf086eb6209d6bf2167d72ab0fe6135fec3723ea15eb8dc105c6c4d4d435c8e214db54d75addac22b5d0eabab69a3324199d0d45056dbed325ab54dcb63bd43eec4be6aa7713edca1a0e216172f1dd9e2e1a5a3c7556fb42268585a55bd4eb028a92dae69e983b1ea8d0edceb7aaf90bdb253361cb241158c835d8787a0c48fdde8215aa88faa7a87deae6f65d2fb4cdd7d4cf5adc2d767f52d94a82fe4417057dfaafa463cddd82afa4cbebe853eecbe5dd8268c58e5c82642ac40faa0ef2355b6a4aabaa7c3d155aea61fd1ba9a104b519c32096ca4222f048c002864415e0b68066c07a86457a600cb8abc10b012a0d04265ca7a73af744fab32659de5e6f48dca44317fdd24bb65935844ac5ce1717d3ec9de666b73b6c5b7f5694b6d1bd136a1ed27535b445b5c9bbdad6f9bbbadbc6d675b2b677b824d6daeddd9bb2bdb46b68d6aab6a9b6eb414652963b1d86558762c3950a6a2349007b511a82d003c0a7849ef4d55c680a931181903a66a952a6a0008ccaba23480075009e81e59086806ac0678952a4fa07fa128544688118a1a925a5404e60b0113012b01db0006aa150b682140606c81deda0e3804502955cca705004116e4b2350230b1abf725c02180511fb57761147661d5768f8a45480b90e68bf91b526d0df66c402bd7ac8b6bb06fe46afed293dc60df59d960bf24b5c13ec0d5608fc7801d3878f7329919f1124546e24e0a0936798a7a89d12202b16e900891395face7717a1ee389a90f3a581ff4567dd08efaa015f54155f541a3eb8346d50725d707b5f2784fccd8a0636383468e0dba786c50e1d8a0dcb141596383d2c706f51b1b5414cc355c4d41b453cf2fd1f3017a1eafe776ae5e1744e6565eb1aefc6efb169e40e5620d7a7365731367934de557ed3f956fb64f77b6caea04db54fb081baaebec6ea75ef4f5152ed9b9c13e26d39c69ce69de2cfc20c166deecc936363f616cbec2d89c676cce3136f737365f646c4e3236271a9b138ccd0e639829c46435f532059afc4d26939f4935091399c25ab5431eb77c2285f95965e1a7ca5cd5eb562173f99a92a6c3264197903754a91015a38bb9c2bbbd9e2aae74784f8d76b5b23f6e3b83ab98bd21155451551ce5cd7157b41ab551de5c7785d75c39beba85f9ae1ab4bc62298cbdaaba9535d9757bac8c2637e2ac926e5f112bcb5b6f5f51534311730aa30a430607e70d29fd93acb62b779ffb44b97b7e2a2a6fdc069d8a866cecbc46cf9ff74418ed5ea3fd05a37db8d13ed4681f64b4671aed69c61eb3466356b33eab599fd5accf6af61a9b5f30360f37360f35360f3236671a9b7bce8ab279efa9185ded7dde56e34d9715cd5653e13d32da3101fb2a17a3cb4a3742eb50d4546f1443a8bc6c94de3fa4b4a6a60247a9e389313ebcaa2e3c7f8f1823f1c4187f4f4f3c8a437fe94672ca42c7a3389d5edc0578365125f1fac8c28767d3f16c5d78261dafa5d25956dae274ea38e144953a4e6538e9388a0fc7d903c778889c3a8ed378e80f38b6ff01a7cf9fe2f438b9c9c5eefff0299b2e35afb2bac544c53588dcf432c2da3058d7a2a011831f88dd44fb946f2900c1ab3f5e3f01ae622a2c8c725b0b38d52fd0eb872e2340620f7446cd8fdda4123fab6307a23ba86ba85f51bf2239045b9043bde433aa6b286afe4067ec267eb66bc88aee60ac714e1bcaa697fabe8db3af6f9cdd0826b79cf570a2b1861a19bd8db3f121772326e8ad12dc4fdb9589c4b36bdcf2317f14b08a6251c62957521c9176b00bbe94ffb925c73b3b344dec07f2a82ef07d462155d17640955e7b89c7d27e9457e1555f856b6025efa102ea83fa1eba1b23936910334f10557498fac3d6fb90858d70ec4904b6b51fe829cea4f1f401f7a53c59d73a29017447d363f40eddc037a9df691fd23af628afa94e0aa0c1b457f89385522898fa612d0b5f22ecea135811d70ccde579ca44e549ed6eed0cf9d120530a6da0dd6c866bd9abfe9dac544337731066d86816bd48ffa0f7a89de3e1589780a29d1ea5831875f112b1ad73b1b6861c94017f741fade74ca55dad3590f677f4a5d0006aa09b6921dd4677d183f406e6ccd3ecda6f30e718ec6e142da39769377dc4199ccb797ca32812d789c3ca0dca6ee5a83682a2b1520295e9b29b438bc1c5b774863a388043f8224ee6e7451aacb94919a7bca83ad58bd5d1ea14f53b83a5e370e756ed4e6d8df64f2ac2ec05b494eea135d4ca068ee6817c077788eb94624829502d541743be16ba9ca6d05cac70373d413bf5bf0c74f0001ecf7b903e15079489aaaa0e56dfd4cab5a9da27b8c5ece4864cd3298bf26918f89b4633e826ba979ea54df4291dd4ffd692c81e2ee34b781ccfe2465e8b20cd20868871e201d122b6a98bd435ea5b9dbf6a515aae7604b4f2f5bf5f8fc2c94c97ffb100c93c44eb6933bd0d6ebe84564441fa553c118fd127f9297e863f56462bcdcacf2a7534770eee5cd9f98dd6a6ffbc2c288d72416b0455d338aa83dc6ea279b49c9ea2b5f43ef6f50564788a3ad9ce57f0f57c1fefe743fc8b708b89484b449378596c156f89ef9439cabdcac3caabca51ecdcdeb95f9ba4cdd15ea430e87f22f81c4657eabf66dda0535f4c2be82ff4004ef81d7d8dcfe9187d4f27f5b352d98fcde0be842ba13d9763d5893c9567f2ed7c27bfc4aff10efe9e7f43fce987d8324cc4c2f94e15d3c50cf0b147fc53fca6242b039541d8e96ae54d658ff2899aa0e6abc56aad7a937a9fba56fdd440063f43ba61be5f84e9dd8e8d9d97764eec7c18dc2668375288fe374737b4b03f64924f9741a7a741b22bc0e71a58d4e77408d2384affa29fc0a791c3d88d334fe74c9c5b094fe3f9bc9017f312a4bb78253f0499bfc82dbc85dfe0ddfc3e7fc29f229d06e736112f5c2251648a5c3158148b72a48bc558512d268bb908951641aaf7203d221e134f88a7c42b628b784f7c208e219d5114c50fc9a8989470254149550628e94a8652a4942b9728d54853949b94f9ca4a6595b251f945bd4c9da44e56ef5657437bd6ab870df7187619bef5b3fa5da7fb9a5134b6e7af7b087632440af4718e48e65590763ca792c53f8fdee114fa8caac4025e2ecaf85be575de028efdf88808a662f112afe5193c885b543f43980c3e880ce3955c9181b8e32d6ea3629ce25f947de2201f93ffad21fa515f05ae9fcaa984a310d06ee44b71fa2e681c0927fad7f03668e1d7349463688d7229e2bb36c583f55fe19ba9515c418f5bd8ff3b9ac87b79b152038dfc8916f15cd1876d90f94e84eb6f729148e0d5224af4e34acae59fc58f7c8db803f2bc95672abb349bf80816b64ab11b866b8be0252dea77ea77a6146598522a2a3be06f7954e7cdf4bb2680bf8dcb611983e85de573ae54ae12c5dc4e8afa96f2e499fb3a7618f29455e208df4f79ead1d39f9d7e5d89d7aeea305109c5535ca7e04bb59b94d9864e2593b2d57ad8f73cea807f7b1b7b3b051d5b001fd34156e8503a7dcb2fd13f781a6c2318de45fe9d00c125ecc2c17b443534cf04db18069fe3e167c4a3e4cf1f7205b42b501d0c4ffeca999710fc67f2559ca63da6ae52568be59d33e805aa01ffd7891df4afcebf8ae562ffe90ccdacd4d28b6c875c2fe22af11b2dd46ea305da1dd0c15fe00156e27eba8f8a0c61f0bc77f9152b8f1bb2a8c8af8446f02935860dca5e788aa9b8bda61ae4cfdc46a28c6067708233d83955a5330e65fb198f814e9343dd8e1be137ed4b65b3c180ddd8297b5d90416d55823c61a1218ba36382e81eff1f79bad91cf1a62ddaf1cd461e4d51eee1d69397b6e7a5b69f6ca7c2828e82af0b07a4b1e2e7e78a4fcccacc09cdcece488f080f633df773e9bdd98af75573ef905e21e22aff9cbeb684ced7fa26a40ecf4842a6aeea18e78c0eb51883c5d38599ae28ebe95f535de9c3faf7491f469ac6df8b95eafbb88393c85fc36b11f7a53f7d0295edbd8e434dadfce286a16e4a33b129a295bf6f19ea66f7e559ee2cec29529baf6e3414d3701a85d7ddcaa7994b0b4a87084a1e5e16c049a22cc0df612e0b0873980785863bccf9117687393dae6f92488fbb2879787adc80b4f2f4b88169e5f9110569e5834287a49597058c481e3e28b43279787ec4c824911f312a490c0acd8f8870c5a587c5c5a5970504b842078585860e722425a799c5f07253459f88fc8032b52a2e2e2234203d7f5099c913ed30bb84486ae5244f40afe8f2345772f24bc37938daebb23c7ead1cb6c18e37fc8f65d307b5f2e957423d01f999a1ad5cb83e627a5c3f394a7dac7d449f1fd337f1698ad3b67bcce6fcccb867463ffd19c2ae53ee23272f3f62ed38e53ed9810aa516745c5e60ed2840298be090c83c96998425bdfabbe75977a18892a5e5820f0ef4f2cb59c9488ff49da13cdd24fd747b56e365999d9111ea3b635470f6728651e959ed22e274c1f1bd76c96a9b29d0e97ce636539cd51a6258bcf57693cd1a1ce2b7e8a5dee600a7f3954b1eea1d1eef7cfc36b3af77eb6dfab061f1fade725ae74f5b2bb68a239dbf1afdade1719d2971516aa0c53f94dfeb51350658c3e2d81422f30f6dd16a60b039a433bd47d537f75728139bb522f505c348aae508cfe0ecfe6c4af44f32f7f7abcdef6f48f5379bd3f280935b3d6ec2458906ca1b367068a12d28da6a4e4babcce5b0dc5c36a78523cb4d5333d4a15bc40c2a44f8942166ac1f559e9ad7aa6d7fc56c2e1e9717bd957f80e35802c555b9de13e42cf727b6e6e646948e294fd926ae261b9ea411781423e725af84c75c7945799f6d98330c3d653450e6bcc413501a9d5bd7574eacf3dfc48fb10986a887daee02b7753b0f3f79e991766b7b47fb70eb29bd76b23d38240f835083f623d693eda8b6eb9dba16e4756b00c9ba0f22f38c564341af02a3b55781a160401a5d8e9b20a7cb9c8dc68888c8b3759fb1e7642625bae2fdc2c32223d4c80879c8dd2399393989497ec6eeba6f9e1178911119e9d9599989497a928e212fd2cf166a0955234a4666186d21bd42d518a32d34284c6496cd58f84a5a1a87a516967dba2b0b58bdc2d4acfbc604040487f70a555c3a961a9398595af5e8ebe9b9ceb94f1716bea7ae9d618f090d3407cff073244547850499adf3e262824d49f109e98fd514d91d39a1b1e34aeff828ec171fda2ffee33202ac2141a6e027ed31218602ffb8d4b0d827a7f42b0e0f8a8aefdfff8ab91f108b9d62a5720a3ec89f9237924149f204c97febe549f488586b8a0ed804079dd6ed16759f683d0203729e7589e238fbbf6a498a0e8f61f568c74f6e47accd1400cdbab6f343a589fb939992d73f4bacc20b6c006510febb68e515af989ff1bffa1369d8926a6a81b55d9a253bb99bec5c0ee9ac4b4c88883573ff8e03e93161c1f23f2c1db8cf1fc18b26579de7b15b882d78650833a9bd8d36196f73a24812d994a3e6fa874441493d4196bc788f2d21d32d330b7ad6a38cea2aa351aeeb9715e92bf45e976fd433cc9e151228027b07c559e283726d71b6dc5491dabbaf2d25ae21ead6a85551aba3d6babf777e1fffbd4b4bd6dc5a4a8425d9e2b6a4d89df678bbcb9e6c77db53caa37e0bfba57760a039a4552cf5c4582cfd422d969010ff507b606818c533be71f6f884c4a45671c3067b79ffd4f4acec1cd45fb6971bcc01724eb0c994ae9a4c0683bf6a0f50158a62c95a60129ffb3be6268514568427c23e96dc76b7f0247a92c4b9bf7c760f0fb18f8db3d96c941b46b6de94db1b7516616c8b6391989464cbce09cb068486da54254c5595dc1c4fdf04b75d289ebee1ee588f3d2eae77ef5841bc0991804d3ae6c85e85368fd952686be5973cf600475f77ff2c77aac11d10e20ef4f44f4d0d0808346547aa91d96a9e3fb58af51e7ff62465b1276d4026b78abf796c0e8bcd614bb39db0a9365b7e5e6eee4d39e6a42477b63927c79c9d2d7799101a5d98edc9c9cfccf6b8b22cd9f6ecd46cc5926dcd7664a7657bb22bb30f659fc83665b772942729df2cc44d664551cda1a16eb33a4265522b116537a80bd566d5cf822bf684aa4001a35ecd33e7642baa751367fd3ff6be04bcade25c74e6683fda8ea4a3d55a8e362f92bccb769418acc44b9cc5514842b6621cc79613836379254d58425bf6a5815e48d9fa02b7059af6714312429d90166e2ff4b29402b7a5055edb046e089487dbd004da02b6df3f738e64d949b8dcbeefbd77dff7c563cdfcb3cffcfbcc3996718fa862b8fae876ee64fbe010769447b7bf4d63ee55ec84e41d1a934a385dd38a67c412a915a9276aa8dd3501c7f51330587d344a0404828b1b1783cbc941ed44bd235b3e11759e46f50e29bd5121daa81ba5440da9221f7044dba3ede4114cb4fe0298cb81b98fca4f479f8d46dbcf520a22b4e471c3ca258fbb2f5abf1670ae2b74d7b9656ede3d87fcacc343838d6b93eba2b2285f16ad97d5f3958eb9de0ba34b99c5b2a57cd2b1d89b8a76043aa2fd811d819dcc0df29dee9dde9d73be13d8cbec75ef0dfc84f989fbe9c02b817f0e3d137ea6f0d5c257eb4ea03f3afee4051998f3997722f0d99c58fb3a9cbbbe68bc646d52eb6e759b1a98244454a834055c03c341c48f4d9d3e00a96c6cea2449d1d8d4b103d00ad2f749de2d958bbd9c46e80511ed0529ed05296d0da95bca8bad8135190e22da1a52da1a52da1a52d23ae900204a18b8c801512d89bc9c860ef9c67eb3b6019f796394fd81732002f72128038b2f3a81fec06c4f21e71e9ed984f943e723dcebf7bb79b0f72f92b8e5f538497ef13dfc6faf1020fe7a8b870ff8275f22aec27daf9b700773f4739b09ac3a31fab20f4c26de3b11637e454af2cbc9db2a47a68eca37c8ae058f3e811f495ebc0ee31b54bb54cc0daa4fd4700279a1f2cd4a998ff125a2586624cd133ef0ed15e6c5188f56dea4625893bc669bfa56c5ad750f281ea853e94a13183308e9e50a596d02837f1a2b290c874043258dbe563d42de70880f8743ba54e9984c3850ee675942001f5fdcc0ca7c8953389cc20fc5105beb9769ed15ceaa067bd21c6cb08fe19b933a8bdfa70adbc37359dd20787e55494fa21377a253617d2af45038a93537a4c21de14c786f581e76cd7311c5cceb1a680ac4718d616bd25aed57d286ca0e65064ea1ceb9a130b7e0107e53f21cc05eb547db264e44c1727d02d0e9716ee2f4e9d3ef421dc8e8c4f168b461bca19ef81220c2d1f2894fc64114a3062a7139b741c5a9c165a0fe0208960e042b0c82f584d96b0ad68c4dfd8ecad4603b1a04663f58e930b10d1a720bae83b55a1da684073e1ac26d5a53a29283855772fac40c2e6a1f1cf4d749060fbc087b1d780fc4eb907c8bda3ac925c9b2918cd65979e267d4c9d6397ff3da0d377df5ee93c3f7786465170e77be6067f566cfc6c756edbc5379c52061a6bec13b5fd8f6958eae2dbfd8beedbeafaebf79e395be9b8cc6b9c18a7a95d968f13a4baf49b99c139497f03ffadb5bd6cf5f717127b9a5ff1438e905e0a45aac3ae8e28c9a865ab29124485987f5a2da876b0edb0fd6bc607fd6fff3883aa3cbe899a82b5619ab4a54dd54725fe5c3de0f5cffb352e30ddce27fdaff7440ae4fb2a6069f1eebf7a1317c5b92972b7dfe98967c1cfeb88a4bb1e8141c76aa0e1859cc1266d016250195454998b58890bc4088437a6dd2e6aa4145b8a12855d451b4b3e85891a2c835c7ed2f274c678736a89c2b6752e51de53bcb8f95cbcb9d7557fc96ba2da0bedb88e348d53830423bb002f831e3349c1e6f8f52e26a25e2fe180cdc8770faf81d724d7d982530e98a73d4c8b98112b594598a48f54a39adbe9081acfc729de8d19580fb67b43038b9ead6ed6fdcf0c83f6c782bed3419ccfcc2c977efd8f362fafe17aeeadc25d327b426e2b8fd04dc359dd2a05637552ed8fae1f037762fbc88371978ebe2fe7f7960eb1bbbda1320bcaf4c1d55e8c06ff3a0283e7908f1536f1c00845941811d00ec413a07f49ba681bd16229ee840e04a01d2fd86044992c3ba04526b8d0d61873ed164ed6519231bb7ce1316f04dd664b88bef0aef60af8bdcafbd9bff03ab5746ea85067f937613dec45e265c5fa41e8ddc62da6dd86b78ccbf27f483c88fd011fd11c353fec3e11785dfa05fe30fd8bfe04fc39f442c562b1f6435ac5663d3a8150c46d4d369451e17f82e448f847cad561eb15a8bce1f648bc256198a7a7d02abc0469b46e3c5880787111aea9eb4a58a3d08b163327f328d53c56a0debf5ebb43a9dce5ae8b7a870ac180e1d1a0df9533e8435257ec198342e37ca4e1a71873163dc61dc6ddc6b54189d316cc731167c500e0b38899763058268033e89e577e0c7f131026057a966c111d021db9771ef486e01a80cc246436de3e29944f20048f133c048c40720ca243a8e8e433c814e1055029a841e48e197e813aa52120918f84635576fb8fa593539844cf3dd7ed60b347b677f311f1d9bfaf0a0df2938916ece1cc970b70f121ec4d1ece3019cd50841497d9843a03eb20608575dc8c031241840c0980adddfa82af859e8c8bbf73c0f47abaffdb6af7b80189749b47ef7d7963f7cf5bec9f71e96bff7d916a2051e7dfee7dfbb1e5bee7d1ebf0566c5f7d9d225573f7ec9358f4c9e3870dda3c464fc1af4c22ed00b3e90c46b0e212d701b08373b26a6a0edde483a88b41743844884390a816da5951a005892d392dcd500f8480e4e095aa4e3349c96d309aca0130c0297d0fcad5027775e56c898238ea8335678aff5071e4550236805bd4c2157aae5acacde515fd8e658e2692b5c215b2e5fce2fb7aeb0f579b679ee0effd07942feb19cbbb81043535991e02527e290d26fd186fc052a218562066289fc0dde9477c07b87f7a857e1759514c5704ce64fd93a6c476d329bb378ee6a5185b44d9c3e4e5448dbf1d354754c9812e5e4da811e3667d0f189201fe03587a74e23f5d41ff787790550f309a793d7c9c11f99332747d1e91e87907cea8383c1805f1708ccc99914723e05674db3d3719b7367e1ed4572dcbe0e0db6e73922d8ff057ac7ca17d552dda492dff0f9f7658777b7bfb5cc6ed09bb9b2c90fbf397674c3775edef6df5f5ba558b3f6ae3b3e9d8bbfe3e36ede7f41dc68319ab9ca8eb7be9f796ee7252f7e27aebf65ed9a1fec046b308090fcaba06be6e225c98baad5a0498ca0cc8c76a30385501895a088cf610a71915a4dad6b4e604e758ba6c5d51a68adeed1f4b8fe5a6d2ba9c245ca373d931e995c61518415321c080691d10ad8b33a9c2ef1fc1389965556558bb0d964d0b21aa221f4a02e8ab822261a290a050392fe985b17afae02f8495f6b000751600cdf9974621cac4ecd45c8e797ab4c66732412655d29a3066b88cd7139532cb127e56c079b6177b27bd92956c9baea83a9aa31bc396944a7846a2c54575477543f582d8755180eccbbe2fbe474da3e08e753d185183fdd3e2eb9f744dcc79dc4f326d20f469d10a65d658023c00c6e781a05c09a3053c711868f925a9439848e406310e2da59f63de726d652f1559e5921493873697ff73faefbfaedca4c07f524ff48e28e2d8a4de95557dd3d985f766280247032ff6c6dcb753d05de89bf645d464666b32fbeb4e1fa890fb325f20b89cc83943f07f4f6294c4886dcd87a0829c073069a8315793fc903a0916bac4eb9d3fabe55a1d37316de2a524dafd3281572914672b713164e2868828c42e1e5ad3ccf5b19bc4f86c664aea4de2d57eaf42cef29b6f21c7304df09d2590567d53b939601f29280d7234f5915298eb7f31e96a78e9fb781a626b7988a66ed99a483ac2cc927f8a42581f801fe71fe182fe79d1eee30f37bd11ba4aea0f8032a3bdaf6aef357ef62073db9016db36abcbea1fe93fa897a497593b700a85fe0c849299efa609fcc46b531089f2a586791f96750c79fa58eecbb655796051fc18b09ea271c24c68beffa98e85c85e9cd37272ffafccf39221ca228872d3f0b38f7828c39d0fd497db169b1a2d524536b7446ce24627786057558cd268e60d70b198cbd9c89e738930321b08c9cb3d824e8f50bd69b387c8439864c7833e2005136c018e252dc00f720778c53704e2767e79c2ca089392a3acd22a6da8e8f47014d124e66e2a31d9f73cfdff9dbccfdbe774a643cd1aee4b117ec156cb9fc57604596ca6a92418d56ad531b342e5da9a65ad35c602870b984826841cc57ea2e73563b9b39b34a725f3061c07a63a2d8107195c423cd0943c291f027a289d2443cd1bcc8b0c8d11a6f6dee42a3e85bc8bcd0d0ec6bf1dfed7b5650e078bcaaa6065da0691c632e4dda92c6a42fc924bb9a92c9c646b62970415333a7b1912a93c5b2d268b1701c6b0cd88c86a0a684762844855c2153b8325058180cb2814049c05faba9a7550994e0124c62654d22515bcbd604ea6b508b6629a94a2c5ab4b279d1a29616b639b0b4b94950caaaaa2bb0c168f4da1dbcddeef007fcbe803712e54153353735796b100f6b5c8a9471506707f12999ff94720ccf4b4634157e99cc93d2a88c299bcd6e0fa44a4a2235a9487d53aafe02b6a6add8618f46500d673c45eeb19205e0fcd993f10be2f664458d3d59108e7376c15e61df6197dbc7982bf7074e45b2cd22a459049a4568b38810a988ec88c823d02c69ab4935112f7ca0093739dbecf688bdc65ed3c61ec6f5f87f48cc220956dbc42754baa4649cdea964656a9c23bfdc382902771b228e1cc4c6737c45ee3dd42425f72086bc2b5bc719971b33af3bdabf54d1391a89e7ba7d4af2de1e11ec63fb0da1388aae030e07db2b5e5ef80c6ad8bf83447e1245491427513389d0d8d4ab44171989eb03bc6997d2809446a4b4464a9b88bfe307c0414e827e12454954c381626b225133e74d904b8afd7c8230fa3e48ce75018155c470d8679b8fa0643754ca2f2c9a654bf083e66ff4d7afb62cfcfabcc51b9557d1db87fb6f97272265558d6bb72e24527cff6df27945a5950bd75f416bdfa6f71677d32ad9c68b875b9a5b9ad3cb79c7c44122eaccb74da69a0bdc459b267e49b377f296ea6441498f98cd537a188d801ee8043d30175f7808f945a51e20c20e3e2349f79b120c3951af244410e0f0f9a2e7b79ecf3d32adc7ed09e0524f1c5fe049e3ebf0039ebd9ec35e2d38250ee4079724e233fb1c9c9f0bc5952dca5b023755dfe73104c0aa048d569f95f98fbd0e2df13af0b97c0eff5ca4a43e8705df9de76da8fc463776136f8375a6105b0e6e868c1d63dedd4f9d8c79491d3a55517d6df51dd5af520fa33be7618c93275a13f9ce0511103cc3abc8e755679657dba94348b8041862362f7c6957c258d07ffffaab6e570c527abe43a2855b143d1d6b6ebe6520df93b84ba2f78eaf2cb8ae97774dfc69da91b05b1775b47c7de2a3d9568d99faf7c96be43f050a875125fe597280f5babc8cf92d2fb6e288ae1bce5c3fd13d5974a8f4e932759009966e2dfa6154bebbe26805632ed5957a6345a5658b3c4bbd4bcbbbd115e83a747bd16dd17f40776bee8ffe103daa7fd4f303ef0798d7449d91626fc23bb7a8d77b93f7fa0a352eafd0e9f5c86a73ba3d5e91b036abd9a0d749840c077c5e0f2172dad75a5128477abdd7e3e53d1e6f18296340cd423fabb5da0c1ebba78a2df1abaedd5083543b54cc806aaf8a51b9aaf528e5f57aa074afe769cf2b1e5983a7c393f1ecf0ecf4ecf628533443c0bd1ea5c759e5f57063b87edf1eaa30e955c460b4be8dfb985c4f7d42ef25c4eba87a7a1791d5894405127b7b23d187cf3e5b9fbbd5257ec853a872ea042a9d3a71201a2c7665cf0b8d6b9f5c8d3acc1d4e199c1286da07f1502379798f8173becd9860d4fa8487739b1abce46acac3e5dd86d2d4a6a769d200b5e6a4916f709228401e8be84d7977a128ab7c445e43c14011e1aab3b2157873b923287e47d8f0f4c8a33f9b3cf0d6b174df4b76a3160e9fd42f1d3c41cfa6f8f603d8f0f0b507263f7a58b6f1def6f5ff7cef4b93877f34a9549a586028a3d52b9f47186a428d958f8eee9efcf4a16d0f81f63800dae373d95614c50de4fee358b243c735682d725e137286a2a139a155288d32aa8c3aa37f183d677e3f64d0158382d10b101931d8796cb1acc12b2d3df813acd69abf62cee82f375fa5df61bed5fc03f34fcc2f99598bc58c1166105fe0f605822151352c440eec2e7058798ba42a8cc518458bc3a120c9077dad8c596652180d4a9d9a5561c4f3de60880f0643e114605089e825d76dc93a0e78cd9a2a08a40adc6c30561c0a72fa14a7c21b5458e52a45a950884f71417b30c672c1e54106058f81843863e0f49dd8b741726a07257fb69e7b5764a8b6696f761cecedc4f176d028e3f9b711f4714254a5e6eae9fd03d51fedd3ea835c2614158afac27f0e7d71b8f45f0f34356d116cacce5850ee98f3d8f18d78849885892d6e5ef0bf74f7fda29ef8d5ae9597b8ac82ca1274adfde1649ce8069391f7304780a0d40b7c63eaa8fc6ba01b96e33dc98be4e4d9bff9deaa3d552f54bdd02c7f61091e5e708fe3bbe8517e6fc977973f817e5cf2c4f267d08b25cf2dffb458ff61f1dbcb19637178f9d2e2e73c2f372b162f6c6e0cf8dc2e75e132dd6d3265d25fa8ad1dc38d494d296bf32f5335fa092f1fd0db284f1fd089bc7d80f238ae4a966b504a6d4e693a911a0fa89f511f539f54cbd5ae152effe224f4594c84e1e462bcf8a1ea9254557daafa30f07615f85016aea00155e14cd5b1aa9355b22ae745737feb18c345d7672f1dc93d233d7a88b78f529ef848d9db47fac09a1e186d92783f596ce36d56db8563531f3cd1626be5412e3fccde1900b5da71fb207db2e225d72aee0a885ac6c49b3f8f94fa88a36100803ed07093471bee31f100b7504a05295d40ee019d00f804d8a79744ad8231e1838f173ee86c9ec7eca7e4b91bebbc07e5948b663f20e7690bfa80bc4c0e8c440ae5254a106f8bdcabf2580c168c2b165e7bdf579ae645b1ad7ed58abedfdfda754f8d5a67e20d165958e98516ca79cb761d3852373035ba60f50b57afb95e16f5d007dd77785d669d49adaa0dc41754d6d5061c3ebea027b9f8ae0dd555253a23794efe98d765d1abbd2a382c7cb3a57051b4a064556dc3b67511722bd4047cd82fff16aac15c3212e38c892a3d8e090dc212e170e95f4b151595d5b252c46ab535b150b046abf5064b419c4bad20c54f707eafb6624ce648d646c39a14c65165b0b6b834c8c93b918373300e575df17321d4c9b25a4dac33140a6a6a6a52a51aad3615d494966a8241e28a1b88fa0d72412615dc00323ec66c7fb25603925f0bce03b32f2339dbdbb93f931b40477934ef0632771189cb8f8b3147aea906db8ee7f4003751cf1d074d40de8820f64401ce840a3ed824719e3977f16d98fa0059a64e2333bda822978e512c2a0120a55f36fbb6294bdfdc63afdcdb14cc15f8792028abf74cced9aae8ea58f7da8576bdc1ecbce0be4cc7d5372bb75205717f0d25a95cb69103295028275e73f015a92abfdec259cdb1906b6485cbc79413b5ff57a0ae5e6da26fb41c957f4bb61145f0ee6437be16f87527c6b81852670544b7606c2c30fa1d1a87a95053682a0c36c8eb826df24be55b14572a86f4b7281e507c4bffeda0b9ccd9e05ce6fc8af332a7629703e364bc2e8e93c170dce9745075ef327a71c0ef2d7039259f21cf1134717a56a3269afe625fab33084ad5ec556b78b55a130806bdc8c523e4c20f45106bf7cbb49cc9e42ff607948140caa5717692bf2371b910d03da5412849d40751301cb9f0d88976a367901c0ef8ef25ad318dc994d268346a8d19f4925a4d9aaa09af70e008736acca9057505d5524fe1dd288a34d8b3effbe4ce5a7c583dfd285bbcae9678e56c7522eb6ce73e8212e016c823f176eb78f68066901e4463c92b69178d87e8903e8185ac370ada6290bc530373a0c168eeb1568e3b24fec92bc83ed4bac1f5f24bdda3ea61ea0a3c77bd7c59e32bff364c79e44f8f509ff3ca0786d70921c64b7d80dbadb605a9236246bc4721b6e40f082916006784f1a643c0c427f71bc9218a2461f11c61151344128b9888b9241ce001ff1e14b2211f0307079bcfee735f89be6ad5f6703da66d4e590fdba3edd1f5e87b0c3d46251234dc82f51ad6603253fb6f007fc08fe1d7edf187c24872117c4acc6a9432064b2e82cf893db91b31e22260ecb59879f02fc208497763bc0514086235acdba34463f8e08fc2292b79c26925b6caed8983c2792c5992e431ffb4058f6418bc9bc14cca9c74bbe30de69479a779b7596e1ee12cb8dc5261612c87f12154889bf7ad76d08717608726da078f8372000b34711c685d5f4fb583e2c6b2bc171044ffa0bd5dbced6997aea9397a0186a6de172fbfe88f3f289328e9cfbe4867a9c6b38b98c7bf79603575f1e6d157e06e7d308c7f7a1b2da8a70517cbf484926a96d076a17870a01942d52de0e18d03555b98e793abd541548cca5039aa40955c0917e34ab932ae9cabe02ab92aaeda6866cd4670db8d5e36c0618ef3d9bc1e9fd71bf2c66be30be35b83bf41dc98692cf8bce9f9a0fc5ed3ebe837353294dc554334f0fe5d359c98d0374fb4bb6acc5013874fed6150892d531f24af332703c99422655b5a915a906aec505c6a5b55d2b1a0a331a3c8d836946416641a77d876786e8cbf173a1eff38f471c947713b6a31c7b1a9c51ce282b581105713c7b5017f2a90b2a4cc29a753634c7129358341bcd978aa685e38154a4563b1da544bea820b95ba2458655dd2ac6d30eab0ee39ae62247eaaf8297c339c6de3f8c1a4198a4e29481b056da3c00af23043c38102c43e4cbe30cd8ae0cc8ae7edaf3db500aa9e6c39556b1b31d71e66c691075a6acda7b8000e38172e101f7080e7781c6c0737717ce238f1558e0395274e9fe04896c0c4a1249738e3f043de8ae5c6e9b50efc90172a455d70d0447441cd58f6844a8fa84b1e2f04fe69210f46e28690a1f6c8d43380d0675070ea83eca32d9248e70b722f4e0f2ee6dc5d004d4bf2535081c5526a20f4aa054091a41134097280956031600591c844a28060743670c5067b037640147240d64c7c20d113a429618403206d66f22a0aa49c94a7af5ce901303960f41a874ed41dfa440dd11d067d22e4e01321ce0429472f6ca8d7748ef747880385671d98309e713007f38a71a050accb095656aea412509a304ec804f233f91111a6db263f9bdc46c56af24f6ede6c608bf12b9327039cceef3f41c52cfd0e5ed3edb6fa03efbad53ab3338c9f9bdca93069c5e33a4e4cfeab787437b894723c885b9526ad2486937f02c52fcaa4be403b35253e0154d43185c060e48de5dba7b6c3a9c67e80c195b631fcdb275a8b181c3dc4ec4025883cb0841e3f05295ea1f0428fd7e977acfcfa3d84ac49166327f7686b11c685d3ad1196596513f2071495c8845a0e221927636463cc6507c9eb03887d0abf4dfe3400bf7d90fc1d0f83480dd2701a467384f906323371bc0a89572aedf4193fa4c0838aecdb1461c911956f9bfc430167b4e8ecd8e122a9fc773fe72d06bdd52426a079c89adda0791ce8eb490b8b5853012a30ed417b4ccab3dec9131dcf59f1f4bdbc7fe6bdbc52ba97e7708a5eba734e27b9777f477cb192386b6de3d1fa33eedcdbffa34bf7d6b33e64906d3ce301036678d9e7f2cb155e6446a307359c3714d7124e8794d8c9e47c005a708b86b997c5afe1d719e6bfb17891e606ccb049a8615833cbb02cf9425d958a0352b02c429c20af90a7e4b207e58fcb1939575ede3e684e945797a3f2f6ea72f2216f56a0c1a1213c445fa013cf06c140519144903ad9c8bfeb5582556f199b422e83d152a8f0fe42a757597da63d7b4c164381032621df88243f265f46febc17d9c97367b00075a80191bf8558833ad02694415bd10ef47cb26b73dff255ab2e59fbd5abe6d40f8c14c736748796b6ead44d49395293afc91442f5b15028562f5beb8e57005d1cee658baf181adad8d3b2e09aedb555fd97996d2b5633cab917ae8610b874bdd7b57efb65ebd75fb65dd613600d91b2b2c2400f2afffdcb89f2975f7d999cdccacbcbb9575fe65e362500e45e2660fe87b6c3e562cafd426c3fabf119ed81de7c3040bec1a6484a2d526a97d26cbd6a567e763abb7e763e3c6bfcec7cf27515f178c55d24fa4b756575658840937555f0f35875656535b382c4132e52c07c23d776e29f2ae25555b4317e9ed44d5e42e2bf90c6771148b60ba20ac84dfea6babaf22864f0b701584d06bb1222fce3aaf29a895680eeaea8883382d4685205c0fba4db9bf18a781900e21f08f152d888aec17732dfa3e1d55cf8ec7f37286ef97241b957b95775adfa29cd9324b0ffa4dd4cc3eff5ef187e69f8257822987bdb1c367fcaabf83ff37fb61df9d2e1f5bcf0e17f26d8cbff8b857beca7cf87f3e17c381fce87f3e17c381fce87f3e17c381fce87ff77c131753e9c0fe7c3f9f05f37208456923f6d15bfcc9c71d19b3f19fd1e411bcd1198413a663fca7e03fd32e6260996a310739f042b9083f9b5042b5184f9a304ab507f6e1c35aa90154ab006b915b512ac3728152bb2df4b8ef596b5128c91964f4b308394fc3e0996a122fe0109962333ffb0042b908eff170956222bff8a04ab505d6e1c3572583a2458830cfc7109d6ab64fc9fc937eacbc97ff234b8f5122c4785051f535841cbab2518cadd05145612fcb8d74930e0c43d9fc22a5a7eb50493f23485d5b47c8f0493f23b29ac814d7a650e0916f12fc222fe4558c4bf088bf8176111ff222ce25f8445fc8bb0887f1116f12fc27a83c37d90c26cdeded9bcbd6ba19c97f6a285f298b4171df9afa7917725588e8a232f53d800e5eaa85e82e5488888e37064fc68a904c3f8512b852db47ca50493f27914e6f370c8e7e1d04adb6f9360d2be93c2365abe5b8249f98d14769271a2cf49308c137d8cc205b4fd1f2498b47f8dc29ebc793d79f3926762ba985182c9387fa170888c13ab9660182726f2468496af9360522ef246291d678704c338b14d0456e7e15f9d877f75debed479fbd2e5b5d7e5b5d7e5d14597a5cb1e24a02af26c1fd501b40a6d466948db5006f5c367046d4303b4a4117243009398fc17a65edaa20c6ae6a33e08025a01659ba0ff081aa6b934a469687d05c4ddb4a51e422be43642691a6d8592141dbd1fe6cdceb31446df06638fc238028c9b81317b5117c05d000f40dd506e1e21b7fa0a540d50612e578762740d9df47f226c06b815e07e3a4617ba5c6abb18729ba194d48ec21a87737b2278e8a5fbe83be77a7a282e04b400f21ba1869476524cccdca3384e46daa940671985da2eba5f92eb81b1b742df215a320aadba29e60428cfd26311ac8960a797f6eba7b89d47fba7698b34da42bf5faf9bf6eda66bcd6f2bd0f2612821f81bc851707a1fa49efc87ad5ee8390c586894d6d92bad65d98cfd74d2d5115ee8a67393d55f4ef7d9f377f1d1ec9673cf39ff22baca3e890ac5d0b397ee2a93c365095a4dfb0ce7f6580b332480c7678e298eb81cad44a533466d83f5ffdf950b967ececbc6ff2fb2d14a9f7e935591d196d0da11a8232b3b931fc94a46e9ffadeca39cd72d8ddc0f7504a3ebe8ae052a45dbe82ec5558de4309d6d4dca3294de041f84dfd2949addb4dd8044911895cf7e3acf00dd93d8b74b1a252de53be9d80374d55ba0d508ad23bd36d27564313c1b5b23520f9176436794f4e4f610cbe5a7a97526760668be1bfa74413e26518e4888386f2c37cfec1df4522a6da578eaa2bc7c369c6d9576da4bb9bc8ff27356f666e39ef4e9a35031b42f99c13d671f5d5cc3df8bdb7cde242391ff203944b9718452ae2bc78d67db4176f633d7352f8f07c84ec4bd8cd0f9b2da6a88f2f336ca3f849ffba90c779e73a722ef75cee02a511633522cee4a84895618907403596d969ad971484ba281be8847453dda2f51667af4ac84f44a581ea2da8ae89a5e09cf65d4dbc8ea6db2873ebabbad392ccfe4ea18a54c2785bb253e3853c7cc968462aa6bc93ee7a2720869aa23c91c97534d92a654ed843282a14dd0225b572e8dd9314b6f9548d23bad2d867318cbaee63f6319bea42616dcb3c6589a1d43f0e4b8f9322813e994e59a34b5627d92069fe6ee2fb22e59ae3cb78521945b9e939ce13c3b2ed25be482b434d726cacbfd12dd6374cf4392e617750fd10c9d14ff229db37c2cf2d580e42b883364605451d3f7e738a5134d5bd8d9faecff002d7218eaa47b2778eb95747db724abe48fadb7483232ed7590197aa9151aa6bc29adf1dcb40578e54c1b0bd42ec9c35137b5327d33f4cc997bfc82f1a8f6eda5fdb2adcfaedd62b3b45b16f7b37b13ac89fa347fdfd9754dfb3fd352336d89b2348c517d9fa1b3f4e4f2e93c0e217a4ba4d0308c366d61c5556fa46b494b966a3447cb7c5d22d2b05ca2f8309592bedc1ab2723d9397be3c56f32dbcb8cb7c4b3393a7a731b195e271cbdf49c7ac3518a5ff9551c44c3a6f05dd3426734ee3e53268d195673b46be401f8b9abf9bee206bf1e6ced0e29d3062866a9cb37bbca2679eb532d3f8c95ab2691ce5eb9499bd86a9ae1069b551daf7d96d6ee739283a94dbfd30e5d27e3aba2845a2e5cdb7e87f2f0764ed5b2b6aa6b529d402b935602d57d09245502680165d0135ab21d704a54d88fcbfc0f9b486d417514aada176a815da5d4c6d9c38c60a8897417e1dd5712d48a079925b02ed97c158a46f335a4be76886d156d2962be8d86d50ba14d266a91de9d1082517439ec00ba91614e75b06bd44ff7d916413c595ae827221b7c399ab5a4467ccaeac8d7edf7f23b4146bc9b7e22fa2e391f593f95b28bc2cb7ce1669a5f3298ee6d3ff16b00846b8187acda735cb015e01710ada374bbb6f9256bb8ceea105eac5bd34d3159099cba4bd8aed087e564b358446647d4b214cef6a3ec5412b5dcd34fe1a215d0e2b27e32f84da55d442a4a06713dde94a8abd660967f3e977eb37cfd89548a946ba1b825582832680dbe0b33087bb153416d7b2226fb499b85b43eba75b89fb9b2fc58d1473299a13a9d14873ab28ad486d4ca2e50aba8fd9b3aea19cd84c5bcda73b5e99e39016cabde2eab3dc29ce91ca5b89381fa16dfe5ab25c2d7c818c88a364eb2f96287d265e08d6e7539c9075adcccd7cae914136f70855159575c2aacd69a12dd39f19d93690161a33430399a1ce91de4c7f9930bfaf4f58d1bb69f3c8b0b0223d9c1eba22dd5d26e8f5ade98d43e9ad426a20ddbf8af459dab92d333a22f46536f576095d99816d43a48f4086afa8160a495217135674f60d6c165a3bfbbb325d9743e9e2cce67ea175b47b98ccb46a73efb0d0973f4e4f664858d0bbb1afb7abb34f9066843619985418ce8c0e75a521e919d9da39941646fbbbd343c208d9c7a255c2d2deae74ff707a9e309c4e0be92d1bd3dddde96ea14f2c15bad3c35d43bd036483748eeef448676fdf7059238cd90ba32c13e7e91446863abbd35b3a872e17323de7c651b6706e7eff45239d309d50dcd6db359421ab2c599d1e1a2633d696252aa596d070f9ca52b169dbaad60ceca45b58921e19e94b0fe53a0ac3a303037dbdb0fe9e4cff4899b02e332a6ce9dc268cc24e4608ce48b1309211ba86d29d23e998d0dd3b3c00788c099dfdddc2c0502fd476419334a49dc3c2407a684befc8080cb7711bc557162b235001c81dca023d64861849295673cb1918ca748f768dc404c20dd03746fa6427e8ed17b66eeeedda9cb7b2ad30696f7f57df6837619decea33fd7ddb84e2de12913a79cd61842f5aad48ccdefe4dc2507a7864a8b78b90607a02d23d37d63c8a81e25e986524bd85d06ba81766edce6cedefcb7476ffaff6aea7b771228aa74aaeb972e0341287ed4a568238a13d20a6f6a419ad639bb1b3a527e4d4d3c6dbd40e76d2aafb69f8005c567b427c0bf6137045e2c619f8bdb1d3c6d024cb0109245755e319bf797f7eeffdc69d97546da2175750217d08278729fc5caf9628c64453982433d78b6513511024bbafc5292150087ce6e92c85cf837e9f8ae6325f2cf23b72b986da62b3b884af79f650b09b241ccf57abe58be1506783bbf43a5dea248d07797135a4d11092dfd4a5fd1ce93565519263a4e6692e3ec5a19f6a099724de13ccaf73c444d0e85bbd00bf0cdc4db612940dbef6fb0125a734458db80181c6aaab22063289c52e0b700fd573318f8b2bc44c18032b6414cb593e03e732022536fbc5a6ce3e3c0a72282ecbfc228da93e92fc627d838cc415add3059039268d8d6859586f18ef9f1b8f120d8569958727e5d85dba9ad3f456b95975b991f79bdb8b14755ad9265d45b565c28221114568b19b3c492fe9551b40966b0454ce0d61a17ab626f29634595709221c22f052630f8606ca758dd293ae568487c98a3435d2c689bb797eb32746a2c1bac8e08c360a921c1babf1e5b5be586d0aecb18e51fc496a88f7a22af17896dfeaad7d1f1b2251c6f843245b3e564a7dab9cc7886aa61bcc8db7022dc87cb94231a54811c85b117d1f00c4b7b160a13f8aceb8124c862c50fe2be908873de321c6cf2c7626a3b13f8d182414f7a273e68f18f7ced94be93916135f074a8421f3159393c0950273d2b3dda923bd537682759e8fc78b0413a134f21919ac55491192b28950f618437e225d199d5b6c24238f748ea094b380ab48da53972b164c55e08702e61da8f5a43752b02226c28b06b08a39265e61c0c231775d638a4fe1bd32fed97e70aee4e9386263df7504264f043ce327aea84c2128dbe5726231874ff8a930ab7c685146acf6ee6c2ccc14ec717cdb91f43d0ac3f6bd486168214a153d2c3d93a1b0185732244046ca877a82132b7ca304eb3c516921a859232310a1f134148fbe3882bbd015d2e26de1417fe75b2bb699a5a3d12d8e19bba4aecdec9bceaf1f2055e9da25f3724b263707bff52ed9ee77dd1fbbdf77df757fe8be6d5bec6d8bfd1f60dbb6d8ffbd167bf5c665db66ff7fb6d9abecb5adf6b6d5deb6dadb56fb5f77f3b6ddde6cb76fd0695bee6dcbbd6db9ffe75aeee0e6e18f0c7e8bfb7aa79c73f415a4567bcec7f9d679f5f0295a630f3974f6bd377bcc3ecf7fae9f793b2df63eeed9bd2f7bbcf779efb303f60e9cda8f3e7d40ea7aa7a6a0931fc5e677d26c0f0a99794ea49d5fccd52e29017b6fccae1dd77f63f0c76f9dceef9f20b59dcd67ff1b5f9bb963faf47fb2c8aeeaeb8fcaeafa0bfa3faebcb8c92c66df170b8b9d16fada626ebccafe3e4b1dcfea5ea7f32776cc0b6d0d0a656e6473747265616d0d0a656e646f626a0d0a313639302030206f626a0d0a3c3c2f547970652f4d657461646174612f537562747970652f584d4c2f4c656e67746820333138333e3e0d0a73747265616d0d0a3c3f787061636b657420626567696e3d22efbbbf222069643d2257354d304d7043656869487a7265537a4e54637a6b633964223f3e3c783a786d706d65746120786d6c6e733a783d2261646f62653a6e733a6d6574612f2220783a786d70746b3d22332e312d373031223e0a3c7264663a52444620786d6c6e733a7264663d22687474703a2f2f7777772e77332e6f72672f313939392f30322f32322d7264662d73796e7461782d6e7323223e0a3c7264663a4465736372697074696f6e207264663a61626f75743d22222020786d6c6e733a7064663d22687474703a2f2f6e732e61646f62652e636f6d2f7064662f312e332f223e0a3c7064663a50726f64756365723e4d6963726f736f6674c2ae20576f726420706f7572204d6963726f736f6674c2a03336353c2f7064663a50726f64756365723e3c2f7264663a4465736372697074696f6e3e0a3c7264663a4465736372697074696f6e207264663a61626f75743d22222020786d6c6e733a64633d22687474703a2f2f7075726c2e6f72672f64632f656c656d656e74732f312e312f223e0a3c64633a7469746c653e3c7264663a416c743e3c7264663a6c6920786d6c3a6c616e673d22782d64656661756c74223e4920e28093205072c3a973656e746174696f6e203a3c2f7264663a6c693e3c2f7264663a416c743e3c2f64633a7469746c653e3c64633a63726561746f723e3c7264663a5365713e3c7264663a6c693e6e69636f3c2f7264663a6c693e3c2f7264663a5365713e3c2f64633a63726561746f723e3c2f7264663a4465736372697074696f6e3e0a3c7264663a4465736372697074696f6e207264663a61626f75743d22222020786d6c6e733a786d703d22687474703a2f2f6e732e61646f62652e636f6d2f7861702f312e302f223e0a3c786d703a43726561746f72546f6f6c3e4d6963726f736f6674c2ae20576f726420706f7572204d6963726f736f6674c2a03336353c2f786d703a43726561746f72546f6f6c3e3c786d703a437265617465446174653e323032342d30342d31385431353a30353a32332b30323a30303c2f786d703a437265617465446174653e3c786d703a4d6f64696679446174653e323032342d30342d31385431353a30353a32332b30323a30303c2f786d703a4d6f64696679446174653e3c2f7264663a4465736372697074696f6e3e0a3c7264663a4465736372697074696f6e207264663a61626f75743d22222020786d6c6e733a786d704d4d3d22687474703a2f2f6e732e61646f62652e636f6d2f7861702f312e302f6d6d2f223e0a3c786d704d4d3a446f63756d656e7449443e757569643a42443734443536382d463744332d343733332d423938362d3539444332373231353242463c2f786d704d4d3a446f63756d656e7449443e3c786d704d4d3a496e7374616e636549443e757569643a42443734443536382d463744332d343733332d423938362d3539444332373231353242463c2f786d704d4d3a496e7374616e636549443e3c2f7264663a4465736372697074696f6e3e0a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020202020200a3c2f7264663a5244463e3c2f783a786d706d6574613e3c3f787061636b657420656e643d2277223f3e0d0a656e6473747265616d0d0a656e646f626a0d0a313639312030206f626a0d0a3c3c2f446973706c6179446f635469746c6520747275653e3e0d0a656e646f626a0d0a313639322030206f626a0d0a3c3c2f547970652f585265662f53697a6520313639322f575b2031203420325d202f526f6f742031203020522f496e666f203736203020522f49445b3c36384435373442444433463733333437423938363539444332373231353242463e3c36384435373442444433463733333437423938363539444332373231353242463e5d202f46696c7465722f466c6174654465636f64652f4c656e67746820333239313e3e0d0a73747265616d0d0a789c35da77bc96e303c7f1f3ad9c0aa1bd24a489849494cc640b0d7b14a2ecccec5d7636d97b27a28c6cb2f7de7b6bf81991f47bbadecfe98ff37edda7a7fb759eebbaeefbf35c9dbba6a6f267d1a254be36ada959cc6d858c2bd4bbbdd074df42b37685e62db1254e2ab4e85968d91953f06aa19593b59a59683dadd066cf42dbedf11e7e2fb4bb149f17dabf59e8d0a8d0657ea1eb5d856e3716ba7f58e87353a1efe0c2ba3d0afdb62d6cdaab30687461f84385117f1546f62f8cf2738eb9b030765661fc7685e3fcdd847985b30dc1a46f0b17772d5c35a130797ae196d70bb72e2c4cfd5fe1813685e98715665c5f78a263e1493fe7f3271766cd28bc3da8f0ce09852f3a15be3cb630db60cd39021715e69a87b9c714e68d2cfc36b9307f6ae1efb1857fc61416949148c35d0a8d26169a2fa8cc7d4d4ded909a7e580ffd3100eb56a8195af7caf52bffaee5807254f966500ff5d1004ba0160dd1088db12496c2d2688265b02c964353344373b4404bb4426bb4415bac8c76688fe5d1012ba02356c44a58059dd0195dd015ddd01d3db02a56c3eae88935d00b6b622dac8dde58077dd017d5c9e987f5d01fd5f91be8687d548f36c086d8081b63136c8a41d80c83b139b6c096d80a5b631b6c8bed3004db6307ec88a11886e118819db02b76c62ed803bb6177ec8d3db117f6c1488cc268ec8bfd3006fbe3001c84b1381087e2601c82c37038c69987ea901f812371148ec6313816e3717ae58aebb6b0ee8a3b01c7e1789c8c1371124ec3293815676062e59cdd7bd59d7302cec459381be7e05c9c87f371012ec4245c844b71312ec195b80c97e30a5c83ab301957e37a5c8beb70236ec04db819b7e056dc86db7107eec45db81bf7e05e4cc17d988afbf100a6e1413c84e9988147f1301ec14c3c86a7f1389ec093780acf5844d50bf6593c87e7310b2fe045bc8497f10a5ec56b781d6fe06dbc89b7f02edec147780fefe3037c884ff031bec6a7f80c9fe30b7c89aff01dbec1b7f811dfe307fc8c9f3017bfe057ccc61cfc8579f80dffc3eff8037fe21fccc7df588805f8b790eae5f41f16f9a6444622239191c8486424321219898c444622239191c8486444314a19a58c364629238351ca286594324a196d8c52a69d75a60891c8486424321219898c444622a3b091c8086694324a19a58c524629a39451ca286594324a19a58c524629a39451ca2865062ebebb8daadedda29491cfc8679432f219f98c44463e33006edb71e165f0e2535f56776aa54c75b0e4334a19f98c7c6673c35a7d896e4637a39bd1cde8667433ba19dd8c6e4637a39bd1cde8667433ba19dd8c604622a39b11d348647433621a358c6e464ca39bd1cd88692432ba19318d52463723a6d1cde866b431ba19dd8c98463ea38d1907dd8c6e4622a39bd1cd0866b431da18c18c36461b2398d1c668630433a74329238a11c54c308dd5799f08a58c524629a39451ca286594324a99c98bd7d28b756b4922239fd1cd4864c434ba19898c6e4653a39451d128659432f219a58c6e4622a39bd1cd086604338219c1cc9dde7b755deb667433ba19dd8c6e4637a39bd1cde8667433ba19dd8c44463e239f91cfe8662432ba19158d524637f30c7433d21a518c6e4637a39bd1cd48647433ba19898c6e46372391d1cde866043382196d8c60463ea38d11cc086694329a1ac18c3646302398d1c608660433da18858d60461ba3a211cc2865543482196d8c604630a3a211cc286594328b4b596f58d93e76ffb7acddca51500ff5d1004ba0160dd1088db12496c2d2688265b02c9a61394b7190a3a66881e6688d966885e5d1066dd10eedd1111db00256c68a58099dd109aba007baa02bbaa13b56c56a581d3db1067a614dac85b5d11beba00ffa625df4c37ae88f01581fd5a11b880db02136c2c6d8049b62330cc6e6d8025b622b6c8d6db02db6c7761882ddb00376c4500cc3708cc04ed819bb6057ec8fddb107f6c45ed81b23310afb605fec87d1380807600cc6e2401c8a837108c6e1301c8e6370048ec451381ac7e1588cc789381e27e0149c84933101a7e2349c8e337026cec2799888b3710ecec585381f17e0724cc245b81897e0525c86ab7105aec455988ceb700daec58db81e37e066dc84c539abdc12aaebf356dc86db7107eec45db81bf7e05e4cc10cdc87a9b81f0f601a1ec443988e47f1301ec1e3780c33310b4fe0493c85a7f10c9ec573781e2fe105bc8857f1325ec11b780dafe36dbc89b7f02edec17b781f1fe0437c848ff1093ec567f81c5f98a3eacde34b7c85aff11dbec1b7f801df632e7ec44ff819bfe057ccc61cfc8979f80dd59cfd8e3fb0107f613efec63f58807fb108ff15a271d1c66863b431da186d8c36461b237cd1c66863b431da18518c284614cb36b0820c4622238311c5c8606430da18198c0c4606238351cac8606430da18198c0c461b238365c7579962618844460da38651c3a8610433a218518c284614238a11c588624431a218518c284614238a11c588624431a218518c28460da38651c3a861d4306a18358c8ac64d27d675aaef5d14238a11c588624431a218358c1a4622a38651c3a861d9e35546b77a6a518cd4451ba38dd1c66863b431421b358c364606a38dd1c6a861b43152176d8c36461ba3b7d1c66863f42fda18f98c3646062398d1c628654431a218518c284637238a11c528654431a218a58c284614a39411c5c860b431da18358c36460623a6d1c6e85fb431da18f98cfe451b2398d1c6e85fb431da186d8c0c464ca38d51ca6863b431fa176d8c364630a386d1c60866b431fa57767c15b431da18198c36461b2383d1c66863842fda18518c2846f8228a11c58862842fa2184d8d2846ffa29411c5e85f9432a218198c28460da38651c3b29dab5c1dd52b4e53238a11c5085f0433da186d8c604606a38d11ccc860b4318219358c524622a38691c8486444311219358c4446222383657357411ba37fd1c6886264304a19fd8b444614a37f11c588627433a218518c0c4614cbe6aec190b2b91b38b7a6c651500ff5d1004ba0d6c86fe5a8211aa13196c452581acba20996412b2c87a66886e66881966887d66883b6581eedb1323a600574c48a5809aba0133aa30bbaa21bbaa30756454fac86d5b116d6402fac8975b0367aa32ffa603dac8b7ee88f01581f03b10136c446d8189b60530c327f5b3bda0c83b139b640f5255ba23ae143b00db6c576188aedb10376c4700cc3ce18819db02b76c16ed81d7b604fec85bd3112fb6214f6c101d80fa3b13fc6620c0ec681380887e2108cc361381c47e0481c85a3710c8ec5781c87e37182e9a88ee789380927e3149c8ad3703acec099380b13301167e31c9c8bf3703e2ec08598848b70312ec1a5b81a97e1725c812b711526e3065c836b711daec7cdb81137e116dc8adb703beec09db80b77e31edc8b29b80f53713f1ec0343c8887301d33f0301ec1a378ccfc552f8499781c4fe0493c85a7f10c9ec573781eb3f0025ec44b7819afe055bc86d7f106dec45b781befe05dbc87f7f1013ec687f8089fe3137c8acff035bec097f80adfe31b7c8beff0337ec08ff80973f00b7ec56c54cb3517f3f01bfec4eff803f3f11716e06ffc83fff02f1616528de22247fa17898c4446222391d1bfb2c7aba08dd1c6e85fb431da186d8c284614237c11c5886244315217518c284645238a11c5085f0433a218898cf04514238a11c5e85fe433a218898c1a461b238a11c5886244316a583677b5757d88524614238ae95df900b2e3ccea0790886294322a1ac18c364629a38dd1c6086644314a19a58c284629a39411c5286594326a18a52c3bbe0a6a18898c44461ba38dd1c654dfa67b79dc122283d1cd68636430da18dd8c1a46292383d1c6086644314a196d8c3666e4e2819c573790da18c18c60461ba38d11cc6863b431da18dd8c364629a38dd1c60866b4314a196d8c364630239191c8486424321219898c4496ad5e6ddd678d2865d9f15590c8486444314a19a58c364629238a51ca286544314a19a58c444622239191c8486424321259b681b5751f78a29451ca286524321219898c4446222391d1d4486424321219898c8a46222391d1cd2865a65456c1d0ce75ab4029239f91cf2865e433f219a58c7c463e239811cc08662432ba19dd8c524637cbe6ae826e4637a39bd1cd286594324a19a58c524629a39451c3086604338219c18c0c4630239811cc086604331219c18c524629a394651b585bf729368219c18c604630a394d1c6086654341219c18c52464c239811cc086664308219c18c60464c2398d1c60866c434ba19c18c60461b239811ccb2ffabb5ff1bba734df589cfa01eeaa30196402354b7810db1241aa30996c2d2a8fe1e6f192c8ba66886e66881966885d66883b6a83ec0d201edb13c56c40ae8884e58092ba333aaff9dd9155dd00dddd103ab6235541bd7136ba017d6c45a581bbdb10efaa06f651ef67fb94cc701e581dfdcff7561da7285efce2d7cff4ae1c7f21c757ebe7b31f5766852185a5b187e4661a7f2fc75bdd93db15561cef8c5d46f381a97141a97878feb8f9854d867584dcdff01c4916c340d0a656e6473747265616d0d0a656e646f626a0d0a787265660d0a3020313639330d0a3030303030303030373720363535333520660d0a30303030303030303137203030303030206e0d0a30303030303030313637203030303030206e0d0a30303030303030333731203030303030206e0d0a30303030303030363830203030303030206e0d0a30303030303034343533203030303030206e0d0a30303030303034363334203030303030206e0d0a30303030303034383835203030303030206e0d0a30303030303034393338203030303030206e0d0a30303030303034393931203030303030206e0d0a30303030303035313636203030303030206e0d0a30303030303035343133203030303030206e0d0a30303030303035353531203030303030206e0d0a30303030303035353831203030303030206e0d0a30303030303035373437203030303030206e0d0a30303030303035383231203030303030206e0d0a30303030303036303638203030303030206e0d0a30303030303036323339203030303030206e0d0a30303030303036343831203030303030206e0d0a30303030303036363134203030303030206e0d0a30303030303036363434203030303030206e0d0a30303030303036383035203030303030206e0d0a30303030303036383739203030303030206e0d0a30303030303037313231203030303030206e0d0a30303030303037343332203030303030206e0d0a30303030303039393736203030303030206e0d0a30303030303130313535203030303030206e0d0a30303030303130343032203030303030206e0d0a30303030303130373133203030303030206e0d0a30303030303133393837203030303030206e0d0a30303030303134313531203030303030206e0d0a30303030303134333738203030303030206e0d0a30303030303134363730203030303030206e0d0a30303030303137343536203030303030206e0d0a30303030303137373637203030303030206e0d0a30303030303232313938203030303030206e0d0a30303030303232353139203030303030206e0d0a30303030303235313437203030303030206e0d0a30303030303235343539203030303030206e0d0a30303030303237323830203030303030206e0d0a30303030303237353931203030303030206e0d0a30303030303331333131203030303030206e0d0a30303030303331363033203030303030206e0d0a30303030303335303537203030303030206e0d0a30303030303335333439203030303030206e0d0a30303030303337333439203030303030206e0d0a30303030303337363731203030303030206e0d0a30303030303339353630203030303030206e0d0a30303030303339383633203030303030206e0d0a30303030303432343437203030303030206e0d0a30303030303432373439203030303030206e0d0a30303030303435353535203030303030206e0d0a30303030303435383438203030303030206e0d0a30303030303436393631203030303030206e0d0a30303030303437323634203030303030206e0d0a30303030303438393237203030303030206e0d0a30303030303439323330203030303030206e0d0a30303030303530383136203030303030206e0d0a30303030303531313238203030303030206e0d0a30303030303534303835203030303030206e0d0a30303030303534333937203030303030206e0d0a30303030303537333739203030303030206e0d0a30303030303537373231203030303030206e0d0a30303030303631313732203030303030206e0d0a30303030303631333030203030303030206e0d0a30303030303631333330203030303030206e0d0a30303030303631343836203030303030206e0d0a30303030303631353630203030303030206e0d0a30303030303631373934203030303030206e0d0a30303030303632313037203030303030206e0d0a30303030303633363635203030303030206e0d0a30303030303633383531203030303030206e0d0a30303030303634313036203030303030206e0d0a30303030303634343338203030303030206e0d0a30303030303637343138203030303030206e0d0a30303030303637373231203030303030206e0d0a30303030303730363531203030303030206e0d0a3030303030303030373820363535333520660d0a3030303030303030373920363535333520660d0a3030303030303030383020363535333520660d0a3030303030303030383120363535333520660d0a3030303030303030383220363535333520660d0a3030303030303030383320363535333520660d0a3030303030303030383420363535333520660d0a3030303030303030383520363535333520660d0a3030303030303030383620363535333520660d0a3030303030303030383720363535333520660d0a3030303030303030383820363535333520660d0a3030303030303030383920363535333520660d0a3030303030303030393020363535333520660d0a3030303030303030393120363535333520660d0a3030303030303030393220363535333520660d0a3030303030303030393320363535333520660d0a3030303030303030393420363535333520660d0a3030303030303030393520363535333520660d0a3030303030303030393620363535333520660d0a3030303030303030393720363535333520660d0a3030303030303030393820363535333520660d0a3030303030303030393920363535333520660d0a3030303030303031303020363535333520660d0a3030303030303031303120363535333520660d0a3030303030303031303220363535333520660d0a3030303030303031303320363535333520660d0a3030303030303031303420363535333520660d0a3030303030303031303520363535333520660d0a3030303030303031303620363535333520660d0a3030303030303031303720363535333520660d0a3030303030303031303820363535333520660d0a3030303030303031303920363535333520660d0a3030303030303031313020363535333520660d0a3030303030303031313120363535333520660d0a3030303030303031313220363535333520660d0a3030303030303031313320363535333520660d0a3030303030303031313420363535333520660d0a3030303030303031313520363535333520660d0a3030303030303031313620363535333520660d0a3030303030303031313720363535333520660d0a3030303030303031313820363535333520660d0a3030303030303031313920363535333520660d0a3030303030303031323020363535333520660d0a3030303030303031323120363535333520660d0a3030303030303031323220363535333520660d0a3030303030303031323320363535333520660d0a3030303030303031323420363535333520660d0a3030303030303031323520363535333520660d0a3030303030303031323620363535333520660d0a3030303030303031323720363535333520660d0a3030303030303031323820363535333520660d0a3030303030303031323920363535333520660d0a3030303030303031333020363535333520660d0a3030303030303031333120363535333520660d0a3030303030303031333220363535333520660d0a3030303030303031333320363535333520660d0a3030303030303031333420363535333520660d0a3030303030303031333520363535333520660d0a3030303030303031333620363535333520660d0a3030303030303031333720363535333520660d0a3030303030303031333820363535333520660d0a3030303030303031333920363535333520660d0a3030303030303031343020363535333520660d0a3030303030303031343120363535333520660d0a3030303030303031343220363535333520660d0a3030303030303031343320363535333520660d0a3030303030303031343420363535333520660d0a3030303030303031343520363535333520660d0a3030303030303031343620363535333520660d0a3030303030303031343720363535333520660d0a3030303030303031343820363535333520660d0a3030303030303031343920363535333520660d0a3030303030303031353020363535333520660d0a3030303030303031353120363535333520660d0a3030303030303031353220363535333520660d0a3030303030303031353320363535333520660d0a3030303030303031353420363535333520660d0a3030303030303031353520363535333520660d0a3030303030303031353620363535333520660d0a3030303030303031353720363535333520660d0a3030303030303031353820363535333520660d0a3030303030303031353920363535333520660d0a3030303030303031363020363535333520660d0a3030303030303031363120363535333520660d0a3030303030303031363220363535333520660d0a3030303030303031363320363535333520660d0a3030303030303031363420363535333520660d0a3030303030303031363520363535333520660d0a3030303030303031363620363535333520660d0a3030303030303031363720363535333520660d0a3030303030303031363820363535333520660d0a3030303030303031363920363535333520660d0a3030303030303031373020363535333520660d0a3030303030303031373120363535333520660d0a3030303030303031373220363535333520660d0a3030303030303031373320363535333520660d0a3030303030303031373420363535333520660d0a3030303030303031373520363535333520660d0a3030303030303031373620363535333520660d0a3030303030303031373720363535333520660d0a3030303030303031373820363535333520660d0a3030303030303031373920363535333520660d0a3030303030303031383020363535333520660d0a3030303030303031383120363535333520660d0a3030303030303031383220363535333520660d0a3030303030303031383320363535333520660d0a3030303030303031383420363535333520660d0a3030303030303031383520363535333520660d0a3030303030303031383620363535333520660d0a3030303030303031383720363535333520660d0a3030303030303031383820363535333520660d0a3030303030303031383920363535333520660d0a3030303030303031393020363535333520660d0a3030303030303031393120363535333520660d0a3030303030303031393220363535333520660d0a3030303030303031393320363535333520660d0a3030303030303031393420363535333520660d0a3030303030303031393520363535333520660d0a3030303030303031393620363535333520660d0a3030303030303031393720363535333520660d0a3030303030303031393820363535333520660d0a3030303030303031393920363535333520660d0a3030303030303032303020363535333520660d0a3030303030303032303120363535333520660d0a3030303030303032303220363535333520660d0a3030303030303032303320363535333520660d0a3030303030303032303420363535333520660d0a3030303030303032303520363535333520660d0a3030303030303032303620363535333520660d0a3030303030303032303720363535333520660d0a3030303030303032303820363535333520660d0a3030303030303032303920363535333520660d0a3030303030303032313120363535333520660d0a30303030303736303239203030303030206e0d0a3030303030303032313220363535333520660d0a3030303030303032313320363535333520660d0a3030303030303032313420363535333520660d0a3030303030303032313520363535333520660d0a3030303030303032313620363535333520660d0a3030303030303032313720363535333520660d0a3030303030303032313820363535333520660d0a3030303030303032313920363535333520660d0a3030303030303032323020363535333520660d0a3030303030303032323120363535333520660d0a3030303030303032323320363535333520660d0a30303030303736303830203030303030206e0d0a3030303030303032323420363535333520660d0a3030303030303032323520363535333520660d0a3030303030303032323620363535333520660d0a3030303030303032323720363535333520660d0a3030303030303032323820363535333520660d0a3030303030303032323920363535333520660d0a3030303030303032333020363535333520660d0a3030303030303032333120363535333520660d0a3030303030303032333220363535333520660d0a3030303030303032333320363535333520660d0a3030303030303032333420363535333520660d0a3030303030303032333520363535333520660d0a3030303030303032333620363535333520660d0a3030303030303032333720363535333520660d0a3030303030303032333820363535333520660d0a3030303030303032333920363535333520660d0a3030303030303032343020363535333520660d0a3030303030303032343120363535333520660d0a3030303030303032343220363535333520660d0a3030303030303032343320363535333520660d0a3030303030303032343420363535333520660d0a3030303030303032343520363535333520660d0a3030303030303032343620363535333520660d0a3030303030303032343720363535333520660d0a3030303030303032343820363535333520660d0a3030303030303032343920363535333520660d0a3030303030303032353020363535333520660d0a3030303030303032353120363535333520660d0a3030303030303032353220363535333520660d0a3030303030303032353320363535333520660d0a3030303030303032353420363535333520660d0a3030303030303032353520363535333520660d0a3030303030303032353620363535333520660d0a3030303030303032353720363535333520660d0a3030303030303032353820363535333520660d0a3030303030303032353920363535333520660d0a3030303030303032363020363535333520660d0a3030303030303032363120363535333520660d0a3030303030303032363220363535333520660d0a3030303030303032363320363535333520660d0a3030303030303032363420363535333520660d0a3030303030303032363520363535333520660d0a3030303030303032363620363535333520660d0a3030303030303032363720363535333520660d0a3030303030303032363820363535333520660d0a3030303030303032363920363535333520660d0a3030303030303032373020363535333520660d0a3030303030303032373120363535333520660d0a3030303030303032373220363535333520660d0a3030303030303032373320363535333520660d0a3030303030303032373420363535333520660d0a3030303030303032373520363535333520660d0a3030303030303032373620363535333520660d0a3030303030303032373720363535333520660d0a3030303030303032373820363535333520660d0a3030303030303032373920363535333520660d0a3030303030303032383020363535333520660d0a3030303030303032383120363535333520660d0a3030303030303032383220363535333520660d0a3030303030303032383320363535333520660d0a3030303030303032383420363535333520660d0a3030303030303032383520363535333520660d0a3030303030303032383620363535333520660d0a3030303030303032383720363535333520660d0a3030303030303032383820363535333520660d0a3030303030303032383920363535333520660d0a3030303030303032393020363535333520660d0a3030303030303032393120363535333520660d0a3030303030303032393220363535333520660d0a3030303030303032393320363535333520660d0a3030303030303032393420363535333520660d0a3030303030303032393520363535333520660d0a3030303030303032393620363535333520660d0a3030303030303032393720363535333520660d0a3030303030303032393820363535333520660d0a3030303030303032393920363535333520660d0a3030303030303033303020363535333520660d0a3030303030303033303120363535333520660d0a3030303030303033303220363535333520660d0a3030303030303033303320363535333520660d0a3030303030303033303420363535333520660d0a3030303030303033303520363535333520660d0a3030303030303033303620363535333520660d0a3030303030303033303720363535333520660d0a3030303030303033303820363535333520660d0a3030303030303033303920363535333520660d0a3030303030303033313020363535333520660d0a3030303030303033313120363535333520660d0a3030303030303033313220363535333520660d0a3030303030303033313320363535333520660d0a3030303030303033313420363535333520660d0a3030303030303033313520363535333520660d0a3030303030303033313620363535333520660d0a3030303030303033313720363535333520660d0a3030303030303033313820363535333520660d0a3030303030303033313920363535333520660d0a3030303030303033323020363535333520660d0a3030303030303033323120363535333520660d0a3030303030303033323220363535333520660d0a3030303030303033323320363535333520660d0a3030303030303033323420363535333520660d0a3030303030303033323520363535333520660d0a3030303030303033323620363535333520660d0a3030303030303033323720363535333520660d0a3030303030303033323820363535333520660d0a3030303030303033323920363535333520660d0a3030303030303033333020363535333520660d0a3030303030303033333120363535333520660d0a3030303030303033333220363535333520660d0a3030303030303033333320363535333520660d0a3030303030303033333420363535333520660d0a3030303030303033333520363535333520660d0a3030303030303033333620363535333520660d0a3030303030303033333720363535333520660d0a3030303030303033333820363535333520660d0a3030303030303033333920363535333520660d0a3030303030303033343020363535333520660d0a3030303030303033343120363535333520660d0a3030303030303033343220363535333520660d0a3030303030303033343320363535333520660d0a3030303030303033343420363535333520660d0a3030303030303033343520363535333520660d0a3030303030303033343620363535333520660d0a3030303030303033343720363535333520660d0a3030303030303033343820363535333520660d0a3030303030303033343920363535333520660d0a3030303030303033353020363535333520660d0a3030303030303033353120363535333520660d0a3030303030303033353220363535333520660d0a3030303030303033353320363535333520660d0a3030303030303033353420363535333520660d0a3030303030303033353520363535333520660d0a3030303030303033353620363535333520660d0a3030303030303033353720363535333520660d0a3030303030303033353820363535333520660d0a3030303030303033353920363535333520660d0a3030303030303033363020363535333520660d0a3030303030303033363120363535333520660d0a3030303030303033363220363535333520660d0a3030303030303033363320363535333520660d0a3030303030303033363420363535333520660d0a3030303030303033363520363535333520660d0a3030303030303033363620363535333520660d0a3030303030303033363720363535333520660d0a3030303030303033363820363535333520660d0a3030303030303033363920363535333520660d0a3030303030303033373020363535333520660d0a3030303030303033373120363535333520660d0a3030303030303033373220363535333520660d0a3030303030303033373320363535333520660d0a3030303030303033373420363535333520660d0a3030303030303033373520363535333520660d0a3030303030303033373620363535333520660d0a3030303030303033373720363535333520660d0a3030303030303033373820363535333520660d0a3030303030303033373920363535333520660d0a3030303030303033383020363535333520660d0a3030303030303033383120363535333520660d0a3030303030303033383220363535333520660d0a3030303030303033383320363535333520660d0a3030303030303033383420363535333520660d0a3030303030303033383520363535333520660d0a3030303030303033383620363535333520660d0a3030303030303033383720363535333520660d0a3030303030303033383820363535333520660d0a3030303030303033383920363535333520660d0a3030303030303033393020363535333520660d0a3030303030303033393120363535333520660d0a3030303030303033393220363535333520660d0a3030303030303033393320363535333520660d0a3030303030303033393420363535333520660d0a3030303030303033393520363535333520660d0a3030303030303033393620363535333520660d0a3030303030303033393720363535333520660d0a3030303030303033393820363535333520660d0a3030303030303033393920363535333520660d0a3030303030303034303120363535333520660d0a30303030303736313331203030303030206e0d0a3030303030303034303220363535333520660d0a3030303030303034303320363535333520660d0a3030303030303034303420363535333520660d0a3030303030303034303520363535333520660d0a3030303030303034303620363535333520660d0a3030303030303034303720363535333520660d0a3030303030303034303820363535333520660d0a3030303030303034303920363535333520660d0a3030303030303034313020363535333520660d0a3030303030303034313120363535333520660d0a3030303030303034313220363535333520660d0a3030303030303034313420363535333520660d0a30303030303736313832203030303030206e0d0a3030303030303034313520363535333520660d0a3030303030303034313620363535333520660d0a3030303030303034313720363535333520660d0a3030303030303034313820363535333520660d0a3030303030303034313920363535333520660d0a3030303030303034323020363535333520660d0a3030303030303034323120363535333520660d0a3030303030303034323220363535333520660d0a3030303030303034323320363535333520660d0a3030303030303034323420363535333520660d0a3030303030303034323520363535333520660d0a3030303030303034323620363535333520660d0a3030303030303034323720363535333520660d0a3030303030303034323820363535333520660d0a3030303030303034323920363535333520660d0a3030303030303034333020363535333520660d0a3030303030303034333120363535333520660d0a3030303030303034333220363535333520660d0a3030303030303034333320363535333520660d0a3030303030303034333420363535333520660d0a3030303030303034333520363535333520660d0a3030303030303034333620363535333520660d0a3030303030303034333720363535333520660d0a3030303030303034333820363535333520660d0a3030303030303034333920363535333520660d0a3030303030303034343020363535333520660d0a3030303030303034343120363535333520660d0a3030303030303034343220363535333520660d0a3030303030303034343320363535333520660d0a3030303030303034343420363535333520660d0a3030303030303034343520363535333520660d0a3030303030303034343620363535333520660d0a3030303030303034343720363535333520660d0a3030303030303034343820363535333520660d0a3030303030303034343920363535333520660d0a3030303030303034353020363535333520660d0a3030303030303034353120363535333520660d0a3030303030303034353220363535333520660d0a3030303030303034353320363535333520660d0a3030303030303034353420363535333520660d0a3030303030303034353520363535333520660d0a3030303030303034353620363535333520660d0a3030303030303034353720363535333520660d0a3030303030303034353820363535333520660d0a3030303030303034353920363535333520660d0a3030303030303034363020363535333520660d0a3030303030303034363120363535333520660d0a3030303030303034363220363535333520660d0a3030303030303034363320363535333520660d0a3030303030303034363420363535333520660d0a3030303030303034363520363535333520660d0a3030303030303034363620363535333520660d0a3030303030303034363720363535333520660d0a3030303030303034363820363535333520660d0a3030303030303034363920363535333520660d0a3030303030303034373020363535333520660d0a3030303030303034373120363535333520660d0a3030303030303034373220363535333520660d0a3030303030303034373320363535333520660d0a3030303030303034373420363535333520660d0a3030303030303034373520363535333520660d0a3030303030303034373620363535333520660d0a3030303030303034373720363535333520660d0a3030303030303034373820363535333520660d0a3030303030303034373920363535333520660d0a3030303030303034383020363535333520660d0a3030303030303034383120363535333520660d0a3030303030303034383220363535333520660d0a3030303030303034383320363535333520660d0a3030303030303034383420363535333520660d0a3030303030303034383520363535333520660d0a3030303030303034383620363535333520660d0a3030303030303034383720363535333520660d0a3030303030303034383820363535333520660d0a3030303030303034383920363535333520660d0a3030303030303034393020363535333520660d0a3030303030303034393120363535333520660d0a3030303030303034393220363535333520660d0a3030303030303034393320363535333520660d0a3030303030303034393420363535333520660d0a3030303030303034393520363535333520660d0a3030303030303034393620363535333520660d0a3030303030303034393820363535333520660d0a30303030303736323333203030303030206e0d0a3030303030303034393920363535333520660d0a3030303030303035303020363535333520660d0a3030303030303035303120363535333520660d0a3030303030303035303220363535333520660d0a3030303030303035303320363535333520660d0a3030303030303035303420363535333520660d0a3030303030303035303520363535333520660d0a3030303030303035303620363535333520660d0a3030303030303035303720363535333520660d0a3030303030303035303820363535333520660d0a3030303030303035303920363535333520660d0a3030303030303035313020363535333520660d0a3030303030303035313120363535333520660d0a3030303030303035313220363535333520660d0a3030303030303035313320363535333520660d0a3030303030303035313420363535333520660d0a3030303030303035313520363535333520660d0a3030303030303035313620363535333520660d0a3030303030303035313720363535333520660d0a3030303030303035313820363535333520660d0a3030303030303035313920363535333520660d0a3030303030303035323020363535333520660d0a3030303030303035323120363535333520660d0a3030303030303035323220363535333520660d0a3030303030303035323320363535333520660d0a3030303030303035323420363535333520660d0a3030303030303035323520363535333520660d0a3030303030303035323620363535333520660d0a3030303030303035323720363535333520660d0a3030303030303035323820363535333520660d0a3030303030303035323920363535333520660d0a3030303030303035333020363535333520660d0a3030303030303035333120363535333520660d0a3030303030303035333220363535333520660d0a3030303030303035333320363535333520660d0a3030303030303035333420363535333520660d0a3030303030303035333520363535333520660d0a3030303030303035333620363535333520660d0a3030303030303035333720363535333520660d0a3030303030303035333820363535333520660d0a3030303030303035333920363535333520660d0a3030303030303035343020363535333520660d0a3030303030303035343120363535333520660d0a3030303030303035343220363535333520660d0a3030303030303035343320363535333520660d0a3030303030303035343420363535333520660d0a3030303030303035343520363535333520660d0a3030303030303035343620363535333520660d0a3030303030303035343720363535333520660d0a3030303030303035343820363535333520660d0a3030303030303035343920363535333520660d0a3030303030303035353020363535333520660d0a3030303030303035353120363535333520660d0a3030303030303035353220363535333520660d0a3030303030303035353320363535333520660d0a3030303030303035353420363535333520660d0a3030303030303035353520363535333520660d0a3030303030303035353620363535333520660d0a3030303030303035353720363535333520660d0a3030303030303035353820363535333520660d0a3030303030303035353920363535333520660d0a3030303030303035363020363535333520660d0a3030303030303035363120363535333520660d0a3030303030303035363220363535333520660d0a3030303030303035363320363535333520660d0a3030303030303035363420363535333520660d0a3030303030303035363520363535333520660d0a3030303030303035363620363535333520660d0a3030303030303035363720363535333520660d0a3030303030303035363820363535333520660d0a3030303030303035363920363535333520660d0a3030303030303035373020363535333520660d0a3030303030303035373120363535333520660d0a3030303030303035373220363535333520660d0a3030303030303035373320363535333520660d0a3030303030303035373420363535333520660d0a3030303030303035373520363535333520660d0a3030303030303035373620363535333520660d0a3030303030303035373720363535333520660d0a3030303030303035373820363535333520660d0a3030303030303035373920363535333520660d0a3030303030303035383020363535333520660d0a3030303030303035383120363535333520660d0a3030303030303035383220363535333520660d0a3030303030303035383320363535333520660d0a3030303030303035383420363535333520660d0a3030303030303035383520363535333520660d0a3030303030303035383620363535333520660d0a3030303030303035383720363535333520660d0a3030303030303035383820363535333520660d0a3030303030303035383920363535333520660d0a3030303030303035393020363535333520660d0a3030303030303035393120363535333520660d0a3030303030303035393220363535333520660d0a3030303030303035393320363535333520660d0a3030303030303035393420363535333520660d0a3030303030303035393520363535333520660d0a3030303030303035393620363535333520660d0a3030303030303035393720363535333520660d0a3030303030303035393820363535333520660d0a3030303030303035393920363535333520660d0a3030303030303036303020363535333520660d0a3030303030303036303120363535333520660d0a3030303030303036303220363535333520660d0a3030303030303036303320363535333520660d0a3030303030303036303420363535333520660d0a3030303030303036303520363535333520660d0a3030303030303036303620363535333520660d0a3030303030303036303720363535333520660d0a3030303030303036303820363535333520660d0a3030303030303036303920363535333520660d0a3030303030303036313020363535333520660d0a3030303030303036313120363535333520660d0a3030303030303036313220363535333520660d0a3030303030303036313320363535333520660d0a3030303030303036313420363535333520660d0a3030303030303036313520363535333520660d0a3030303030303036313620363535333520660d0a3030303030303036313720363535333520660d0a3030303030303036313820363535333520660d0a3030303030303036313920363535333520660d0a3030303030303036323020363535333520660d0a3030303030303036323120363535333520660d0a3030303030303036323220363535333520660d0a3030303030303036323320363535333520660d0a3030303030303036323420363535333520660d0a3030303030303036323520363535333520660d0a3030303030303036323620363535333520660d0a3030303030303036323720363535333520660d0a3030303030303036323820363535333520660d0a3030303030303036323920363535333520660d0a3030303030303036333020363535333520660d0a3030303030303036333120363535333520660d0a3030303030303036333220363535333520660d0a3030303030303036333320363535333520660d0a3030303030303036333420363535333520660d0a3030303030303036333520363535333520660d0a3030303030303036333620363535333520660d0a3030303030303036333720363535333520660d0a3030303030303036333820363535333520660d0a3030303030303036333920363535333520660d0a3030303030303036343020363535333520660d0a3030303030303036343120363535333520660d0a3030303030303036343220363535333520660d0a3030303030303036343320363535333520660d0a3030303030303036343420363535333520660d0a3030303030303036343520363535333520660d0a3030303030303036343620363535333520660d0a3030303030303036343720363535333520660d0a3030303030303036343820363535333520660d0a3030303030303036343920363535333520660d0a3030303030303036353020363535333520660d0a3030303030303036353120363535333520660d0a3030303030303036353220363535333520660d0a3030303030303036353320363535333520660d0a3030303030303036353420363535333520660d0a3030303030303036353520363535333520660d0a3030303030303036353620363535333520660d0a3030303030303036353720363535333520660d0a3030303030303036353820363535333520660d0a3030303030303036353920363535333520660d0a3030303030303036363020363535333520660d0a3030303030303036363120363535333520660d0a3030303030303036363220363535333520660d0a3030303030303036363320363535333520660d0a3030303030303036363420363535333520660d0a3030303030303036363520363535333520660d0a3030303030303036363620363535333520660d0a3030303030303036363720363535333520660d0a3030303030303036363820363535333520660d0a3030303030303036363920363535333520660d0a3030303030303036373020363535333520660d0a3030303030303036373120363535333520660d0a3030303030303036373220363535333520660d0a3030303030303036373320363535333520660d0a3030303030303036373420363535333520660d0a3030303030303036373520363535333520660d0a3030303030303036373620363535333520660d0a3030303030303036373720363535333520660d0a3030303030303036373820363535333520660d0a3030303030303036373920363535333520660d0a3030303030303036383020363535333520660d0a3030303030303036383120363535333520660d0a3030303030303036383220363535333520660d0a3030303030303036383320363535333520660d0a3030303030303036383420363535333520660d0a3030303030303036383520363535333520660d0a3030303030303036383620363535333520660d0a3030303030303036383720363535333520660d0a3030303030303036383820363535333520660d0a3030303030303036383920363535333520660d0a3030303030303036393020363535333520660d0a3030303030303036393120363535333520660d0a3030303030303036393220363535333520660d0a3030303030303036393320363535333520660d0a3030303030303036393420363535333520660d0a3030303030303036393520363535333520660d0a3030303030303036393620363535333520660d0a3030303030303036393720363535333520660d0a3030303030303036393820363535333520660d0a3030303030303036393920363535333520660d0a3030303030303037303020363535333520660d0a3030303030303037303120363535333520660d0a3030303030303037303220363535333520660d0a3030303030303037303320363535333520660d0a3030303030303037303420363535333520660d0a3030303030303037303520363535333520660d0a3030303030303037303620363535333520660d0a3030303030303037303720363535333520660d0a3030303030303037303820363535333520660d0a3030303030303037303920363535333520660d0a3030303030303037313020363535333520660d0a3030303030303037313120363535333520660d0a3030303030303037313220363535333520660d0a3030303030303037313320363535333520660d0a3030303030303037313420363535333520660d0a3030303030303037313520363535333520660d0a3030303030303037313620363535333520660d0a3030303030303037313720363535333520660d0a3030303030303037313820363535333520660d0a3030303030303037313920363535333520660d0a3030303030303037323020363535333520660d0a3030303030303037323120363535333520660d0a3030303030303037323220363535333520660d0a3030303030303037323320363535333520660d0a3030303030303037323420363535333520660d0a3030303030303037323520363535333520660d0a3030303030303037323620363535333520660d0a3030303030303037323720363535333520660d0a3030303030303037323820363535333520660d0a3030303030303037323920363535333520660d0a3030303030303037333020363535333520660d0a3030303030303037333120363535333520660d0a3030303030303037333220363535333520660d0a3030303030303037333320363535333520660d0a3030303030303037333420363535333520660d0a3030303030303037333520363535333520660d0a3030303030303037333620363535333520660d0a3030303030303037333720363535333520660d0a3030303030303037333820363535333520660d0a3030303030303037333920363535333520660d0a3030303030303037343020363535333520660d0a3030303030303037343120363535333520660d0a3030303030303037343220363535333520660d0a3030303030303037343320363535333520660d0a3030303030303037343420363535333520660d0a3030303030303037343520363535333520660d0a3030303030303037343620363535333520660d0a3030303030303037343720363535333520660d0a3030303030303037343820363535333520660d0a3030303030303037343920363535333520660d0a3030303030303037353020363535333520660d0a3030303030303037353120363535333520660d0a3030303030303037353220363535333520660d0a3030303030303037353320363535333520660d0a3030303030303037353420363535333520660d0a3030303030303037353520363535333520660d0a3030303030303037353620363535333520660d0a3030303030303037353720363535333520660d0a3030303030303037353820363535333520660d0a3030303030303037353920363535333520660d0a3030303030303037363020363535333520660d0a3030303030303037363120363535333520660d0a3030303030303037363220363535333520660d0a3030303030303037363320363535333520660d0a3030303030303037363420363535333520660d0a3030303030303037363520363535333520660d0a3030303030303037363620363535333520660d0a3030303030303037363720363535333520660d0a3030303030303037363820363535333520660d0a3030303030303037363920363535333520660d0a3030303030303037373020363535333520660d0a3030303030303037373120363535333520660d0a3030303030303037373220363535333520660d0a3030303030303037373320363535333520660d0a3030303030303037373420363535333520660d0a3030303030303037373520363535333520660d0a3030303030303037373620363535333520660d0a3030303030303037373720363535333520660d0a3030303030303037373820363535333520660d0a3030303030303037373920363535333520660d0a3030303030303037383020363535333520660d0a3030303030303037383120363535333520660d0a3030303030303037383220363535333520660d0a3030303030303037383320363535333520660d0a3030303030303037383420363535333520660d0a3030303030303037383520363535333520660d0a3030303030303037383620363535333520660d0a3030303030303037383720363535333520660d0a3030303030303037383820363535333520660d0a3030303030303037383920363535333520660d0a3030303030303037393020363535333520660d0a3030303030303037393120363535333520660d0a3030303030303037393220363535333520660d0a3030303030303037393320363535333520660d0a3030303030303037393420363535333520660d0a3030303030303037393520363535333520660d0a3030303030303037393620363535333520660d0a3030303030303037393720363535333520660d0a3030303030303037393820363535333520660d0a3030303030303037393920363535333520660d0a3030303030303038303020363535333520660d0a3030303030303038303120363535333520660d0a3030303030303038303220363535333520660d0a3030303030303038303320363535333520660d0a3030303030303038303420363535333520660d0a3030303030303038303520363535333520660d0a3030303030303038303620363535333520660d0a3030303030303038303720363535333520660d0a3030303030303038303820363535333520660d0a3030303030303038303920363535333520660d0a3030303030303038313020363535333520660d0a3030303030303038313120363535333520660d0a3030303030303038313220363535333520660d0a3030303030303038313320363535333520660d0a3030303030303038313420363535333520660d0a3030303030303038313520363535333520660d0a3030303030303038313620363535333520660d0a3030303030303038313720363535333520660d0a3030303030303038313820363535333520660d0a3030303030303038313920363535333520660d0a3030303030303038323020363535333520660d0a3030303030303038323120363535333520660d0a3030303030303038323220363535333520660d0a3030303030303038323320363535333520660d0a3030303030303038323420363535333520660d0a3030303030303038323520363535333520660d0a3030303030303038323620363535333520660d0a3030303030303038323720363535333520660d0a3030303030303038323820363535333520660d0a3030303030303038323920363535333520660d0a3030303030303038333020363535333520660d0a3030303030303038333120363535333520660d0a3030303030303038333220363535333520660d0a3030303030303038333320363535333520660d0a3030303030303038333420363535333520660d0a3030303030303038333520363535333520660d0a3030303030303038333620363535333520660d0a3030303030303038333720363535333520660d0a3030303030303038333820363535333520660d0a3030303030303038333920363535333520660d0a3030303030303038343020363535333520660d0a3030303030303038343120363535333520660d0a3030303030303038343220363535333520660d0a3030303030303038343320363535333520660d0a3030303030303038343420363535333520660d0a3030303030303038343520363535333520660d0a3030303030303038343620363535333520660d0a3030303030303038343720363535333520660d0a3030303030303038343820363535333520660d0a3030303030303038343920363535333520660d0a3030303030303038353020363535333520660d0a3030303030303038353120363535333520660d0a3030303030303038353220363535333520660d0a3030303030303038353320363535333520660d0a3030303030303038353420363535333520660d0a3030303030303038353520363535333520660d0a3030303030303038353620363535333520660d0a3030303030303038353720363535333520660d0a3030303030303038353820363535333520660d0a3030303030303038353920363535333520660d0a3030303030303038363020363535333520660d0a3030303030303038363120363535333520660d0a3030303030303038363220363535333520660d0a3030303030303038363320363535333520660d0a3030303030303038363420363535333520660d0a3030303030303038363520363535333520660d0a3030303030303038363620363535333520660d0a3030303030303038363720363535333520660d0a3030303030303038363820363535333520660d0a3030303030303038363920363535333520660d0a3030303030303038373020363535333520660d0a3030303030303038373120363535333520660d0a3030303030303038373220363535333520660d0a3030303030303038373320363535333520660d0a3030303030303038373420363535333520660d0a3030303030303038373520363535333520660d0a3030303030303038373620363535333520660d0a3030303030303038373720363535333520660d0a3030303030303038373820363535333520660d0a3030303030303038373920363535333520660d0a3030303030303038383020363535333520660d0a3030303030303038383120363535333520660d0a3030303030303038383220363535333520660d0a3030303030303038383320363535333520660d0a3030303030303038383420363535333520660d0a3030303030303038383520363535333520660d0a3030303030303038383620363535333520660d0a3030303030303038383720363535333520660d0a3030303030303038383820363535333520660d0a3030303030303038383920363535333520660d0a3030303030303038393020363535333520660d0a3030303030303038393120363535333520660d0a3030303030303038393220363535333520660d0a3030303030303038393320363535333520660d0a3030303030303038393420363535333520660d0a3030303030303038393520363535333520660d0a3030303030303038393620363535333520660d0a3030303030303038393720363535333520660d0a3030303030303038393820363535333520660d0a3030303030303038393920363535333520660d0a3030303030303039303020363535333520660d0a3030303030303039303120363535333520660d0a3030303030303039303220363535333520660d0a3030303030303039303320363535333520660d0a3030303030303039303420363535333520660d0a3030303030303039303520363535333520660d0a3030303030303039303620363535333520660d0a3030303030303039303720363535333520660d0a3030303030303039303820363535333520660d0a3030303030303039303920363535333520660d0a3030303030303039313020363535333520660d0a3030303030303039313120363535333520660d0a3030303030303039313220363535333520660d0a3030303030303039313320363535333520660d0a3030303030303039313420363535333520660d0a3030303030303039313520363535333520660d0a3030303030303039313620363535333520660d0a3030303030303039313720363535333520660d0a3030303030303039313820363535333520660d0a3030303030303039313920363535333520660d0a3030303030303039323020363535333520660d0a3030303030303039323120363535333520660d0a3030303030303039323220363535333520660d0a3030303030303039323320363535333520660d0a3030303030303039323420363535333520660d0a3030303030303039323520363535333520660d0a3030303030303039323620363535333520660d0a3030303030303039323720363535333520660d0a3030303030303039323820363535333520660d0a3030303030303039323920363535333520660d0a3030303030303039333020363535333520660d0a3030303030303039333120363535333520660d0a3030303030303039333220363535333520660d0a3030303030303039333320363535333520660d0a3030303030303039333420363535333520660d0a3030303030303039333520363535333520660d0a3030303030303039333620363535333520660d0a3030303030303039333720363535333520660d0a3030303030303039333820363535333520660d0a3030303030303039333920363535333520660d0a3030303030303039343020363535333520660d0a3030303030303039343120363535333520660d0a3030303030303039343220363535333520660d0a3030303030303039343320363535333520660d0a3030303030303039343420363535333520660d0a3030303030303039343520363535333520660d0a3030303030303039343620363535333520660d0a3030303030303039343720363535333520660d0a3030303030303039343820363535333520660d0a3030303030303039343920363535333520660d0a3030303030303039353020363535333520660d0a3030303030303039353120363535333520660d0a3030303030303039353220363535333520660d0a3030303030303039353320363535333520660d0a3030303030303039353420363535333520660d0a3030303030303039353520363535333520660d0a3030303030303039353620363535333520660d0a3030303030303039353720363535333520660d0a3030303030303039353820363535333520660d0a3030303030303039353920363535333520660d0a3030303030303039363020363535333520660d0a3030303030303039363120363535333520660d0a3030303030303039363220363535333520660d0a3030303030303039363320363535333520660d0a3030303030303039363420363535333520660d0a3030303030303039363520363535333520660d0a3030303030303039363620363535333520660d0a3030303030303039363720363535333520660d0a3030303030303039363820363535333520660d0a3030303030303039363920363535333520660d0a3030303030303039373020363535333520660d0a3030303030303039373120363535333520660d0a3030303030303039373220363535333520660d0a3030303030303039373320363535333520660d0a3030303030303039373420363535333520660d0a3030303030303039373520363535333520660d0a3030303030303039373620363535333520660d0a3030303030303039373720363535333520660d0a3030303030303039373820363535333520660d0a3030303030303039373920363535333520660d0a3030303030303039383020363535333520660d0a3030303030303039383120363535333520660d0a3030303030303039383220363535333520660d0a3030303030303039383320363535333520660d0a3030303030303039383420363535333520660d0a3030303030303039383520363535333520660d0a3030303030303039383620363535333520660d0a3030303030303039383720363535333520660d0a3030303030303039383820363535333520660d0a3030303030303039383920363535333520660d0a3030303030303039393020363535333520660d0a3030303030303039393120363535333520660d0a3030303030303039393220363535333520660d0a3030303030303039393320363535333520660d0a3030303030303039393420363535333520660d0a3030303030303039393520363535333520660d0a3030303030303039393620363535333520660d0a3030303030303039393720363535333520660d0a3030303030303039393820363535333520660d0a3030303030303039393920363535333520660d0a3030303030303130303020363535333520660d0a3030303030303130303120363535333520660d0a3030303030303130303220363535333520660d0a3030303030303130303320363535333520660d0a3030303030303130303420363535333520660d0a3030303030303130303520363535333520660d0a3030303030303130303620363535333520660d0a3030303030303130303720363535333520660d0a3030303030303130303820363535333520660d0a3030303030303130303920363535333520660d0a3030303030303130313020363535333520660d0a3030303030303130313120363535333520660d0a3030303030303130313220363535333520660d0a3030303030303130313320363535333520660d0a3030303030303130313420363535333520660d0a3030303030303130313520363535333520660d0a3030303030303130313620363535333520660d0a3030303030303130313720363535333520660d0a3030303030303130313820363535333520660d0a3030303030303130313920363535333520660d0a3030303030303130323020363535333520660d0a3030303030303130323120363535333520660d0a3030303030303130323220363535333520660d0a3030303030303130323320363535333520660d0a3030303030303130323420363535333520660d0a3030303030303130323520363535333520660d0a3030303030303130323620363535333520660d0a3030303030303130323720363535333520660d0a3030303030303130323820363535333520660d0a3030303030303130323920363535333520660d0a3030303030303130333020363535333520660d0a3030303030303130333120363535333520660d0a3030303030303130333220363535333520660d0a3030303030303130333320363535333520660d0a3030303030303130333420363535333520660d0a3030303030303130333520363535333520660d0a3030303030303130333620363535333520660d0a3030303030303130333720363535333520660d0a3030303030303130333820363535333520660d0a3030303030303130333920363535333520660d0a3030303030303130343020363535333520660d0a3030303030303130343120363535333520660d0a3030303030303130343220363535333520660d0a3030303030303130343320363535333520660d0a3030303030303130343420363535333520660d0a3030303030303130343520363535333520660d0a3030303030303130343620363535333520660d0a3030303030303130343720363535333520660d0a3030303030303130343820363535333520660d0a3030303030303130343920363535333520660d0a3030303030303130353020363535333520660d0a3030303030303130353120363535333520660d0a3030303030303130353220363535333520660d0a3030303030303130353320363535333520660d0a3030303030303130353420363535333520660d0a3030303030303130353520363535333520660d0a3030303030303130353620363535333520660d0a3030303030303130353720363535333520660d0a3030303030303130353820363535333520660d0a3030303030303130353920363535333520660d0a3030303030303130363020363535333520660d0a3030303030303130363120363535333520660d0a3030303030303130363220363535333520660d0a3030303030303130363320363535333520660d0a3030303030303130363420363535333520660d0a3030303030303130363520363535333520660d0a3030303030303130363620363535333520660d0a3030303030303130363720363535333520660d0a3030303030303130363820363535333520660d0a3030303030303130363920363535333520660d0a3030303030303130373020363535333520660d0a3030303030303130373120363535333520660d0a3030303030303130373220363535333520660d0a3030303030303130373320363535333520660d0a3030303030303130373420363535333520660d0a3030303030303130373520363535333520660d0a3030303030303130373620363535333520660d0a3030303030303130373720363535333520660d0a3030303030303130373820363535333520660d0a3030303030303130373920363535333520660d0a3030303030303130383020363535333520660d0a3030303030303130383120363535333520660d0a3030303030303130383220363535333520660d0a3030303030303130383320363535333520660d0a3030303030303130383420363535333520660d0a3030303030303130383520363535333520660d0a3030303030303130383620363535333520660d0a3030303030303130383720363535333520660d0a3030303030303130383820363535333520660d0a3030303030303130383920363535333520660d0a3030303030303130393020363535333520660d0a3030303030303130393120363535333520660d0a3030303030303130393220363535333520660d0a3030303030303130393320363535333520660d0a3030303030303130393420363535333520660d0a3030303030303130393520363535333520660d0a3030303030303130393620363535333520660d0a3030303030303130393720363535333520660d0a3030303030303130393820363535333520660d0a3030303030303130393920363535333520660d0a3030303030303131303020363535333520660d0a3030303030303131303120363535333520660d0a3030303030303131303220363535333520660d0a3030303030303131303320363535333520660d0a3030303030303131303420363535333520660d0a3030303030303131303520363535333520660d0a3030303030303131303620363535333520660d0a3030303030303131303720363535333520660d0a3030303030303131303820363535333520660d0a3030303030303131303920363535333520660d0a3030303030303131313020363535333520660d0a3030303030303131313120363535333520660d0a3030303030303131313220363535333520660d0a3030303030303131313320363535333520660d0a3030303030303131313420363535333520660d0a3030303030303131313520363535333520660d0a3030303030303131313620363535333520660d0a3030303030303131313720363535333520660d0a3030303030303131313820363535333520660d0a3030303030303131313920363535333520660d0a3030303030303131323020363535333520660d0a3030303030303131323120363535333520660d0a3030303030303131323220363535333520660d0a3030303030303131323320363535333520660d0a3030303030303131323420363535333520660d0a3030303030303131323520363535333520660d0a3030303030303131323620363535333520660d0a3030303030303131323720363535333520660d0a3030303030303131323820363535333520660d0a3030303030303131323920363535333520660d0a3030303030303131333020363535333520660d0a3030303030303131333120363535333520660d0a3030303030303131333220363535333520660d0a3030303030303131333320363535333520660d0a3030303030303131333420363535333520660d0a3030303030303131333520363535333520660d0a3030303030303131333620363535333520660d0a3030303030303131333720363535333520660d0a3030303030303131333820363535333520660d0a3030303030303131333920363535333520660d0a3030303030303131343020363535333520660d0a3030303030303131343120363535333520660d0a3030303030303131343220363535333520660d0a3030303030303131343320363535333520660d0a3030303030303131343420363535333520660d0a3030303030303131343520363535333520660d0a3030303030303131343620363535333520660d0a3030303030303131343720363535333520660d0a3030303030303131343820363535333520660d0a3030303030303131343920363535333520660d0a3030303030303131353020363535333520660d0a3030303030303131353120363535333520660d0a3030303030303131353220363535333520660d0a3030303030303131353320363535333520660d0a3030303030303131353420363535333520660d0a3030303030303131353520363535333520660d0a3030303030303131353620363535333520660d0a3030303030303131353720363535333520660d0a3030303030303131353820363535333520660d0a3030303030303131353920363535333520660d0a3030303030303131363020363535333520660d0a3030303030303131363120363535333520660d0a3030303030303131363220363535333520660d0a3030303030303131363320363535333520660d0a3030303030303131363420363535333520660d0a3030303030303131363520363535333520660d0a3030303030303131363620363535333520660d0a3030303030303131363720363535333520660d0a3030303030303131363820363535333520660d0a3030303030303131363920363535333520660d0a3030303030303131373020363535333520660d0a3030303030303131373120363535333520660d0a3030303030303131373220363535333520660d0a3030303030303131373320363535333520660d0a3030303030303131373420363535333520660d0a3030303030303131373520363535333520660d0a3030303030303131373620363535333520660d0a3030303030303131373720363535333520660d0a3030303030303131373820363535333520660d0a3030303030303131373920363535333520660d0a3030303030303131383020363535333520660d0a3030303030303131383120363535333520660d0a3030303030303131383220363535333520660d0a3030303030303131383320363535333520660d0a3030303030303131383420363535333520660d0a3030303030303131383520363535333520660d0a3030303030303131383620363535333520660d0a3030303030303131383720363535333520660d0a3030303030303131383820363535333520660d0a3030303030303131383920363535333520660d0a3030303030303131393020363535333520660d0a3030303030303131393120363535333520660d0a3030303030303131393220363535333520660d0a3030303030303131393320363535333520660d0a3030303030303131393420363535333520660d0a3030303030303131393520363535333520660d0a3030303030303131393620363535333520660d0a3030303030303131393720363535333520660d0a3030303030303131393820363535333520660d0a3030303030303131393920363535333520660d0a3030303030303132303020363535333520660d0a3030303030303132303120363535333520660d0a3030303030303132303220363535333520660d0a3030303030303132303320363535333520660d0a3030303030303132303420363535333520660d0a3030303030303132303520363535333520660d0a3030303030303132303620363535333520660d0a3030303030303132303720363535333520660d0a3030303030303132303820363535333520660d0a3030303030303132303920363535333520660d0a3030303030303132313020363535333520660d0a3030303030303132313120363535333520660d0a3030303030303132313220363535333520660d0a3030303030303132313320363535333520660d0a3030303030303132313420363535333520660d0a3030303030303132313520363535333520660d0a3030303030303132313620363535333520660d0a3030303030303132313720363535333520660d0a3030303030303132313820363535333520660d0a3030303030303132313920363535333520660d0a3030303030303132323020363535333520660d0a3030303030303132323120363535333520660d0a3030303030303132323220363535333520660d0a3030303030303132323320363535333520660d0a3030303030303132323420363535333520660d0a3030303030303132323520363535333520660d0a3030303030303132323620363535333520660d0a3030303030303132323720363535333520660d0a3030303030303132323820363535333520660d0a3030303030303132323920363535333520660d0a3030303030303132333020363535333520660d0a3030303030303132333120363535333520660d0a3030303030303132333220363535333520660d0a3030303030303132333320363535333520660d0a3030303030303132333420363535333520660d0a3030303030303132333520363535333520660d0a3030303030303132333620363535333520660d0a3030303030303132333720363535333520660d0a3030303030303132333820363535333520660d0a3030303030303132333920363535333520660d0a3030303030303132343020363535333520660d0a3030303030303132343120363535333520660d0a3030303030303132343220363535333520660d0a3030303030303132343320363535333520660d0a3030303030303132343420363535333520660d0a3030303030303132343520363535333520660d0a3030303030303132343620363535333520660d0a3030303030303132343720363535333520660d0a3030303030303132343820363535333520660d0a3030303030303132343920363535333520660d0a3030303030303132353020363535333520660d0a3030303030303132353120363535333520660d0a3030303030303132353220363535333520660d0a3030303030303132353320363535333520660d0a3030303030303132353420363535333520660d0a3030303030303132353520363535333520660d0a3030303030303132353620363535333520660d0a3030303030303132353720363535333520660d0a3030303030303132353820363535333520660d0a3030303030303132353920363535333520660d0a3030303030303132363020363535333520660d0a3030303030303132363120363535333520660d0a3030303030303132363220363535333520660d0a3030303030303132363320363535333520660d0a3030303030303132363420363535333520660d0a3030303030303132363520363535333520660d0a3030303030303132363620363535333520660d0a3030303030303132363720363535333520660d0a3030303030303132363820363535333520660d0a3030303030303132363920363535333520660d0a3030303030303132373020363535333520660d0a3030303030303132373120363535333520660d0a3030303030303132373220363535333520660d0a3030303030303132373320363535333520660d0a3030303030303132373420363535333520660d0a3030303030303132373520363535333520660d0a3030303030303132373620363535333520660d0a3030303030303132373720363535333520660d0a3030303030303132373820363535333520660d0a3030303030303132373920363535333520660d0a3030303030303132383020363535333520660d0a3030303030303132383120363535333520660d0a3030303030303132383220363535333520660d0a3030303030303132383320363535333520660d0a3030303030303132383420363535333520660d0a3030303030303132383520363535333520660d0a3030303030303132383620363535333520660d0a3030303030303132383720363535333520660d0a3030303030303132383820363535333520660d0a3030303030303132383920363535333520660d0a3030303030303132393020363535333520660d0a3030303030303132393120363535333520660d0a3030303030303132393220363535333520660d0a3030303030303132393320363535333520660d0a3030303030303132393420363535333520660d0a3030303030303132393520363535333520660d0a3030303030303132393620363535333520660d0a3030303030303132393720363535333520660d0a3030303030303132393820363535333520660d0a3030303030303132393920363535333520660d0a3030303030303133303020363535333520660d0a3030303030303133303120363535333520660d0a3030303030303133303220363535333520660d0a3030303030303133303320363535333520660d0a3030303030303133303420363535333520660d0a3030303030303133303520363535333520660d0a3030303030303133303620363535333520660d0a3030303030303133303720363535333520660d0a3030303030303133303820363535333520660d0a3030303030303133303920363535333520660d0a3030303030303133313020363535333520660d0a3030303030303133313120363535333520660d0a3030303030303133313220363535333520660d0a3030303030303133313320363535333520660d0a3030303030303133313420363535333520660d0a3030303030303133313520363535333520660d0a3030303030303133313620363535333520660d0a3030303030303133313720363535333520660d0a3030303030303133313820363535333520660d0a3030303030303133313920363535333520660d0a3030303030303133323020363535333520660d0a3030303030303133323120363535333520660d0a3030303030303133323220363535333520660d0a3030303030303133323320363535333520660d0a3030303030303133323420363535333520660d0a3030303030303133323520363535333520660d0a3030303030303133323620363535333520660d0a3030303030303133323720363535333520660d0a3030303030303133323820363535333520660d0a3030303030303133323920363535333520660d0a3030303030303133333020363535333520660d0a3030303030303133333120363535333520660d0a3030303030303133333220363535333520660d0a3030303030303133333320363535333520660d0a3030303030303133333420363535333520660d0a3030303030303133333520363535333520660d0a3030303030303133333620363535333520660d0a3030303030303133333720363535333520660d0a3030303030303133333820363535333520660d0a3030303030303133333920363535333520660d0a3030303030303133343020363535333520660d0a3030303030303133343120363535333520660d0a3030303030303133343220363535333520660d0a3030303030303133343320363535333520660d0a3030303030303133343420363535333520660d0a3030303030303133343520363535333520660d0a3030303030303133343620363535333520660d0a3030303030303133343720363535333520660d0a3030303030303133343820363535333520660d0a3030303030303133343920363535333520660d0a3030303030303133353020363535333520660d0a3030303030303133353120363535333520660d0a3030303030303133353220363535333520660d0a3030303030303133353320363535333520660d0a3030303030303133353420363535333520660d0a3030303030303133353520363535333520660d0a3030303030303133353620363535333520660d0a3030303030303133353720363535333520660d0a3030303030303133353820363535333520660d0a3030303030303133353920363535333520660d0a3030303030303133363020363535333520660d0a3030303030303133363120363535333520660d0a3030303030303133363220363535333520660d0a3030303030303133363320363535333520660d0a3030303030303133363420363535333520660d0a3030303030303133363520363535333520660d0a3030303030303133363620363535333520660d0a3030303030303133363720363535333520660d0a3030303030303133363820363535333520660d0a3030303030303133363920363535333520660d0a3030303030303133373020363535333520660d0a3030303030303133373120363535333520660d0a3030303030303133373220363535333520660d0a3030303030303133373320363535333520660d0a3030303030303133373420363535333520660d0a3030303030303133373520363535333520660d0a3030303030303133373620363535333520660d0a3030303030303133373720363535333520660d0a3030303030303133373820363535333520660d0a3030303030303133373920363535333520660d0a3030303030303133383020363535333520660d0a3030303030303133383120363535333520660d0a3030303030303133383220363535333520660d0a3030303030303133383320363535333520660d0a3030303030303133383420363535333520660d0a3030303030303133383520363535333520660d0a3030303030303133383620363535333520660d0a3030303030303133383720363535333520660d0a3030303030303133383820363535333520660d0a3030303030303133383920363535333520660d0a3030303030303133393020363535333520660d0a3030303030303133393120363535333520660d0a3030303030303133393220363535333520660d0a3030303030303133393320363535333520660d0a3030303030303133393420363535333520660d0a3030303030303133393520363535333520660d0a3030303030303133393620363535333520660d0a3030303030303133393720363535333520660d0a3030303030303133393820363535333520660d0a3030303030303133393920363535333520660d0a3030303030303134303020363535333520660d0a3030303030303134303120363535333520660d0a3030303030303134303220363535333520660d0a3030303030303134303320363535333520660d0a3030303030303134303420363535333520660d0a3030303030303134303520363535333520660d0a3030303030303134303620363535333520660d0a3030303030303134303720363535333520660d0a3030303030303134303820363535333520660d0a3030303030303134303920363535333520660d0a3030303030303134313020363535333520660d0a3030303030303134313120363535333520660d0a3030303030303134313220363535333520660d0a3030303030303134313320363535333520660d0a3030303030303134313420363535333520660d0a3030303030303134313620363535333520660d0a30303030303836393733203030303030206e0d0a3030303030303134313720363535333520660d0a3030303030303134313820363535333520660d0a3030303030303134313920363535333520660d0a3030303030303134323020363535333520660d0a3030303030303134323120363535333520660d0a3030303030303134323220363535333520660d0a3030303030303134323320363535333520660d0a3030303030303134323420363535333520660d0a3030303030303134323520363535333520660d0a3030303030303134323620363535333520660d0a3030303030303134323720363535333520660d0a3030303030303134323820363535333520660d0a3030303030303134323920363535333520660d0a3030303030303134333020363535333520660d0a3030303030303134333120363535333520660d0a3030303030303134333220363535333520660d0a3030303030303134333320363535333520660d0a3030303030303134333420363535333520660d0a3030303030303134333520363535333520660d0a3030303030303134333620363535333520660d0a3030303030303134333720363535333520660d0a3030303030303134333820363535333520660d0a3030303030303134333920363535333520660d0a3030303030303134343020363535333520660d0a3030303030303134343120363535333520660d0a3030303030303134343220363535333520660d0a3030303030303134343320363535333520660d0a3030303030303134343420363535333520660d0a3030303030303134343520363535333520660d0a3030303030303134343620363535333520660d0a3030303030303134343720363535333520660d0a3030303030303134343820363535333520660d0a3030303030303134343920363535333520660d0a3030303030303134353020363535333520660d0a3030303030303134353120363535333520660d0a3030303030303134353220363535333520660d0a3030303030303134353320363535333520660d0a3030303030303134353420363535333520660d0a3030303030303134353520363535333520660d0a3030303030303134353620363535333520660d0a3030303030303134353720363535333520660d0a3030303030303134353820363535333520660d0a3030303030303134353920363535333520660d0a3030303030303134363020363535333520660d0a3030303030303134363120363535333520660d0a3030303030303134363320363535333520660d0a30303030303837303235203030303030206e0d0a3030303030303134363420363535333520660d0a3030303030303134363520363535333520660d0a3030303030303134363620363535333520660d0a3030303030303134363720363535333520660d0a3030303030303134363820363535333520660d0a3030303030303134363920363535333520660d0a3030303030303134373020363535333520660d0a3030303030303134373120363535333520660d0a3030303030303134373220363535333520660d0a3030303030303134373320363535333520660d0a3030303030303134373420363535333520660d0a3030303030303134373520363535333520660d0a3030303030303134373620363535333520660d0a3030303030303134373720363535333520660d0a3030303030303134373820363535333520660d0a3030303030303134373920363535333520660d0a3030303030303134383020363535333520660d0a3030303030303134383120363535333520660d0a3030303030303134383220363535333520660d0a3030303030303134383320363535333520660d0a3030303030303134383420363535333520660d0a3030303030303134383520363535333520660d0a3030303030303134383620363535333520660d0a3030303030303134383720363535333520660d0a3030303030303134383820363535333520660d0a3030303030303134383920363535333520660d0a3030303030303134393020363535333520660d0a3030303030303134393120363535333520660d0a3030303030303134393220363535333520660d0a3030303030303134393320363535333520660d0a3030303030303134393420363535333520660d0a3030303030303134393520363535333520660d0a3030303030303134393620363535333520660d0a3030303030303134393720363535333520660d0a3030303030303134393820363535333520660d0a3030303030303134393920363535333520660d0a3030303030303135303020363535333520660d0a3030303030303135303120363535333520660d0a3030303030303135303220363535333520660d0a3030303030303135303320363535333520660d0a3030303030303135303420363535333520660d0a3030303030303135303520363535333520660d0a3030303030303135303620363535333520660d0a3030303030303135303720363535333520660d0a3030303030303135303820363535333520660d0a3030303030303135303920363535333520660d0a3030303030303135313020363535333520660d0a3030303030303135313120363535333520660d0a3030303030303135313220363535333520660d0a3030303030303135313320363535333520660d0a3030303030303135313420363535333520660d0a3030303030303135313520363535333520660d0a3030303030303135313620363535333520660d0a3030303030303135313720363535333520660d0a3030303030303135313820363535333520660d0a3030303030303135313920363535333520660d0a3030303030303135323020363535333520660d0a3030303030303135323120363535333520660d0a3030303030303135323220363535333520660d0a3030303030303135323320363535333520660d0a3030303030303135323420363535333520660d0a3030303030303135323520363535333520660d0a3030303030303135323620363535333520660d0a3030303030303135323720363535333520660d0a3030303030303135323820363535333520660d0a3030303030303135323920363535333520660d0a3030303030303135333020363535333520660d0a3030303030303135333120363535333520660d0a3030303030303135333220363535333520660d0a3030303030303135333320363535333520660d0a3030303030303135333420363535333520660d0a3030303030303135333520363535333520660d0a3030303030303135333720363535333520660d0a30303030303837303737203030303030206e0d0a3030303030303135333820363535333520660d0a3030303030303135333920363535333520660d0a3030303030303135343020363535333520660d0a3030303030303135343120363535333520660d0a3030303030303135343220363535333520660d0a3030303030303135343320363535333520660d0a3030303030303135343420363535333520660d0a3030303030303135343520363535333520660d0a3030303030303135343620363535333520660d0a3030303030303135343720363535333520660d0a3030303030303135343820363535333520660d0a3030303030303135343920363535333520660d0a3030303030303135353020363535333520660d0a3030303030303135353120363535333520660d0a3030303030303135353220363535333520660d0a3030303030303135353320363535333520660d0a3030303030303135353420363535333520660d0a3030303030303135353520363535333520660d0a3030303030303135353620363535333520660d0a3030303030303135353720363535333520660d0a3030303030303135353820363535333520660d0a3030303030303135353920363535333520660d0a3030303030303135363020363535333520660d0a3030303030303135363120363535333520660d0a3030303030303135363220363535333520660d0a3030303030303135363320363535333520660d0a3030303030303135363420363535333520660d0a3030303030303135363520363535333520660d0a3030303030303135363620363535333520660d0a3030303030303135363720363535333520660d0a3030303030303135363820363535333520660d0a3030303030303135363920363535333520660d0a3030303030303135373020363535333520660d0a3030303030303135373120363535333520660d0a3030303030303135373220363535333520660d0a3030303030303135373320363535333520660d0a3030303030303135373420363535333520660d0a3030303030303135373520363535333520660d0a3030303030303135373620363535333520660d0a3030303030303135373720363535333520660d0a3030303030303135373820363535333520660d0a3030303030303135373920363535333520660d0a3030303030303135383020363535333520660d0a3030303030303135383120363535333520660d0a3030303030303135383220363535333520660d0a3030303030303135383320363535333520660d0a3030303030303135383420363535333520660d0a3030303030303135383520363535333520660d0a3030303030303135383620363535333520660d0a3030303030303135383720363535333520660d0a3030303030303135383820363535333520660d0a3030303030303135383920363535333520660d0a3030303030303135393020363535333520660d0a3030303030303135393120363535333520660d0a3030303030303135393220363535333520660d0a3030303030303135393320363535333520660d0a3030303030303135393420363535333520660d0a3030303030303135393520363535333520660d0a3030303030303135393620363535333520660d0a3030303030303135393720363535333520660d0a3030303030303135393820363535333520660d0a3030303030303135393920363535333520660d0a3030303030303136303020363535333520660d0a3030303030303136303120363535333520660d0a3030303030303136303220363535333520660d0a3030303030303136303320363535333520660d0a3030303030303136303420363535333520660d0a3030303030303136303520363535333520660d0a3030303030303136303620363535333520660d0a3030303030303136303720363535333520660d0a3030303030303136303820363535333520660d0a3030303030303136303920363535333520660d0a3030303030303136313020363535333520660d0a3030303030303136313120363535333520660d0a3030303030303136313220363535333520660d0a3030303030303136313320363535333520660d0a3030303030303136313420363535333520660d0a3030303030303136313520363535333520660d0a3030303030303136313620363535333520660d0a3030303030303136313720363535333520660d0a3030303030303136313820363535333520660d0a3030303030303136313920363535333520660d0a3030303030303136323020363535333520660d0a3030303030303136323120363535333520660d0a3030303030303136323220363535333520660d0a3030303030303136323320363535333520660d0a3030303030303136323420363535333520660d0a3030303030303136323520363535333520660d0a3030303030303136323620363535333520660d0a3030303030303136323720363535333520660d0a3030303030303136323820363535333520660d0a3030303030303136323920363535333520660d0a3030303030303136333020363535333520660d0a3030303030303136333120363535333520660d0a3030303030303136333220363535333520660d0a3030303030303136333320363535333520660d0a3030303030303136333420363535333520660d0a3030303030303136333520363535333520660d0a3030303030303136333620363535333520660d0a3030303030303136333720363535333520660d0a3030303030303136333820363535333520660d0a3030303030303136333920363535333520660d0a3030303030303136343020363535333520660d0a3030303030303136343120363535333520660d0a3030303030303136343220363535333520660d0a3030303030303136343320363535333520660d0a3030303030303136343420363535333520660d0a3030303030303136343520363535333520660d0a3030303030303136343620363535333520660d0a3030303030303136343720363535333520660d0a3030303030303136343820363535333520660d0a3030303030303136343920363535333520660d0a3030303030303136353020363535333520660d0a3030303030303136353120363535333520660d0a3030303030303136353220363535333520660d0a3030303030303136353320363535333520660d0a3030303030303136353420363535333520660d0a3030303030303136353520363535333520660d0a3030303030303136353620363535333520660d0a3030303030303136353720363535333520660d0a3030303030303136353820363535333520660d0a3030303030303136353920363535333520660d0a3030303030303136363020363535333520660d0a3030303030303136363120363535333520660d0a3030303030303136363220363535333520660d0a3030303030303136363320363535333520660d0a3030303030303136363420363535333520660d0a3030303030303136363520363535333520660d0a3030303030303136363620363535333520660d0a3030303030303136363720363535333520660d0a3030303030303136363820363535333520660d0a3030303030303136363920363535333520660d0a3030303030303136373020363535333520660d0a3030303030303136373120363535333520660d0a3030303030303030303020363535333520660d0a30303030303932333633203030303030206e0d0a30303030303932343632203030303030206e0d0a30303030313131333331203030303030206e0d0a30303030313131363332203030303030206e0d0a30303030313234353536203030303030206e0d0a30303030313234383736203030303030206e0d0a30303030313235343037203030303030206e0d0a30303030313235383638203030303030206e0d0a30303030313532303737203030303030206e0d0a30303030313532353832203030303030206e0d0a30303030313533323231203030303030206e0d0a30303030313533383134203030303030206e0d0a30303030313932303436203030303030206e0d0a30303030313932303735203030303030206e0d0a30303030313932333738203030303030206e0d0a30303030313938353033203030303030206e0d0a30303030313938353438203030303030206e0d0a30303030313939303333203030303030206e0d0a30303030323139303235203030303030206e0d0a30303030323232323933203030303030206e0d0a30303030323232333430203030303030206e0d0a747261696c65720d0a3c3c2f53697a6520313639332f526f6f742031203020522f496e666f203736203020522f49445b3c36384435373442444433463733333437423938363539444332373231353242463e3c36384435373442444433463733333437423938363539444332373231353242463e5d203e3e0d0a7374617274787265660d0a3232353833370d0a2525454f460d0a787265660d0a3020300d0a747261696c65720d0a3c3c2f53697a6520313639332f526f6f742031203020522f496e666f203736203020522f49445b3c36384435373442444433463733333437423938363539444332373231353242463e3c36384435373442444433463733333437423938363539444332373231353242463e5d202f50726576203232353833372f5852656653746d203232323334303e3e0d0a7374617274787265660d0a3235393835390d0a2525454f46,
        'Chapitre 2 - Programmation Shell.pdf',
        260043,
        '2026-05-05 19:20:31'
    );

-- --------------------------------------------------------

--
-- Structure de la table `provider_schedule`
--

DROP TABLE IF EXISTS `provider_schedule`;

CREATE TABLE IF NOT EXISTS `provider_schedule` (
    `Id_SCHEDULE` int NOT NULL AUTO_INCREMENT,
    `Day_Of_Week` decimal(1, 0) NOT NULL,
    `Start_Time` time NOT NULL,
    `End_Time` time NOT NULL,
    `Id_USER` int NOT NULL,
    PRIMARY KEY (`Id_SCHEDULE`),
    UNIQUE KEY `uq_provider_schedule` (
        `Id_USER`,
        `Day_Of_Week`,
        `Start_Time`,
        `End_Time`
    ),
    KEY `idx_provider_schedule_user_dow` (`Id_USER`, `Day_Of_Week`)
);

--
-- Déchargement des données de la table `provider_schedule`
--

INSERT INTO
    `provider_schedule` (
        `Id_SCHEDULE`,
        `Day_Of_Week`,
        `Start_Time`,
        `End_Time`,
        `Id_USER`
    )
VALUES (
        5,
        '1',
        '12:00:00',
        '20:00:00',
        23
    ),
    (
        6,
        '1',
        '14:00:00',
        '18:00:00',
        23
    ),
    (
        7,
        '1',
        '10:00:00',
        '12:00:00',
        24
    );

-- --------------------------------------------------------

--
-- Structure de la table `provider_service_schedule`
--

DROP TABLE IF EXISTS `provider_service_schedule`;

CREATE TABLE IF NOT EXISTS `provider_service_schedule` (
    `Id_USER` int NOT NULL,
    `Id_SERVICE_TYPE` int NOT NULL,
    `Id_SCHEDULE` int NOT NULL,
    PRIMARY KEY (
        `Id_USER`,
        `Id_SERVICE_TYPE`,
        `Id_SCHEDULE`
    ),
    UNIQUE KEY `uq_provider_service_schedule` (
        `Id_USER`,
        `Id_SERVICE_TYPE`,
        `Id_SCHEDULE`
    ),
    KEY `Id_SERVICE_TYPE` (`Id_SERVICE_TYPE`),
    KEY `Id_SCHEDULE` (`Id_SCHEDULE`),
    KEY `idx_pss_user_service` (`Id_USER`, `Id_SERVICE_TYPE`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `provider_service_schedule`
--

INSERT INTO
    `provider_service_schedule` (
        `Id_USER`,
        `Id_SERVICE_TYPE`,
        `Id_SCHEDULE`
    )
VALUES (23, 3, 5),
    (23, 5, 6),
    (24, 2, 7);

-- --------------------------------------------------------

--
-- Structure de la table `qualify`
--

DROP TABLE IF EXISTS `qualify`;

CREATE TABLE IF NOT EXISTS `qualify` (
    `Id_USER` int NOT NULL,
    `Id_SERVICE_TYPE` int NOT NULL,
    `Custom_Title` varchar(100) DEFAULT NULL,
    `Negotiated_Price` decimal(10, 2) DEFAULT NULL,
    `Experience_Years` int DEFAULT NULL,
    `Is_Active` tinyint(1) DEFAULT '1',
    `Validation_Status` tinyint(1) NOT NULL DEFAULT '1',
    `Slot_Duration_Min` int NOT NULL DEFAULT '60',
    PRIMARY KEY (`Id_USER`, `Id_SERVICE_TYPE`),
    KEY `Id_SERVICE_TYPE` (`Id_SERVICE_TYPE`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- Déchargement des données de la table `qualify`
--

INSERT INTO
    `qualify` (
        `Id_USER`,
        `Id_SERVICE_TYPE`,
        `Custom_Title`,
        `Negotiated_Price`,
        `Experience_Years`,
        `Is_Active`,
        `Validation_Status`,
        `Slot_Duration_Min`
    )
VALUES (
        1,
        1,
        NULL,
        '18.00',
        NULL,
        1,
        1,
        60
    ),
    (
        2,
        3,
        NULL,
        '35.00',
        NULL,
        1,
        1,
        60
    ),
    (
        3,
        4,
        NULL,
        '45.00',
        NULL,
        1,
        1,
        60
    ),
    (
        4,
        5,
        NULL,
        '25.00',
        NULL,
        1,
        1,
        60
    ),
    (
        5,
        6,
        NULL,
        '20.00',
        NULL,
        1,
        1,
        60
    ),
    (
        6,
        7,
        NULL,
        '70.00',
        NULL,
        1,
        1,
        60
    ),
    (
        7,
        8,
        NULL,
        '25.00',
        NULL,
        1,
        1,
        60
    ),
    (
        10,
        1,
        'M├®nager vos vous ! ha ha haha',
        '99.99',
        0,
        1,
        1,
        60
    ),
    (
        10,
        3,
        'Boxe anglaise',
        '20.00',
        3,
        1,
        1,
        60
    ),
    (
        11,
        4,
        'Un massage bien malaxant ( pas cher )',
        '9797.00',
        1,
        1,
        1,
        60
    ),
    (
        23,
        3,
        'zdevnzopùn',
        '100.00',
        1,
        1,
        1,
        60
    ),
    (
        23,
        5,
        'Yoga Sananes',
        '9823.00',
        2,
        1,
        1,
        60
    ),
    (
        24,
        2,
        'OUI',
        '4398.00',
        88,
        1,
        1,
        60
    ),
    (
        24,
        3,
        NULL,
        '50.00',
        NULL,
        1,
        1,
        60
    );

-- --------------------------------------------------------

--
-- Structure de la table `review`
--

DROP TABLE IF EXISTS `review`;

CREATE TABLE IF NOT EXISTS `review` (
    `Id_REVIEW` int NOT NULL AUTO_INCREMENT,
    `Id_SENIOR` int NOT NULL,
    `Id_PROVIDER` int NOT NULL,
    `Rating` tinyint NOT NULL,
    `Comment` text,
    `Created_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Updated_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id_REVIEW`),
    UNIQUE KEY `uniq_review_senior_provider` (`Id_SENIOR`, `Id_PROVIDER`),
    KEY `fk_review_provider` (`Id_PROVIDER`)
);

--
-- Déchargement des données de la table `review`
--

INSERT INTO
    `review` (
        `Id_REVIEW`,
        `Id_SENIOR`,
        `Id_PROVIDER`,
        `Rating`,
        `Comment`,
        `Created_At`,
        `Updated_At`
    )
VALUES (
        1,
        19,
        23,
        5,
        'J\'aime bien',
        '2026-05-07 03:17:56',
        '2026-05-07 03:17:56'
    ),
    (
        3,
        19,
        24,
        5,
        'OUAISOUAIS',
        '2026-05-07 23:58:49',
        '2026-05-07 23:58:49'
    );

-- --------------------------------------------------------

--
-- Structure de la table `review_report`
--

DROP TABLE IF EXISTS `review_report`;

CREATE TABLE IF NOT EXISTS `review_report` (
    `Id_REPORT` int NOT NULL AUTO_INCREMENT,
    `Id_REVIEW` int NOT NULL,
    `Id_REPORTER` int NOT NULL,
    `Reason` text NOT NULL,
    `Status` enum(
        'pending',
        'reviewed',
        'dismissed'
    ) NOT NULL DEFAULT 'pending',
    `Created_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Reviewed_At` datetime DEFAULT NULL,
    PRIMARY KEY (`Id_REPORT`),
    UNIQUE KEY `uniq_report_review_reporter` (`Id_REVIEW`, `Id_REPORTER`),
    KEY `fk_report_reporter` (`Id_REPORTER`)
) ENGINE = MyISAM AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `review_report`
--

INSERT INTO
    `review_report` (
        `Id_REPORT`,
        `Id_REVIEW`,
        `Id_REPORTER`,
        `Reason`,
        `Status`,
        `Created_At`,
        `Reviewed_At`
    )
VALUES (
        1,
        2,
        24,
        'mechant',
        'reviewed',
        '2026-05-07 03:49:30',
        '2026-05-07 03:50:41'
    );

-- --------------------------------------------------------

--
-- Structure de la table `senior`
--

DROP TABLE IF EXISTS `senior`;

CREATE TABLE IF NOT EXISTS `senior` (
    `Id_USER` int NOT NULL,
    `Birth_Date` date DEFAULT NULL,
    `Sponsor_Code` varchar(50) DEFAULT NULL,
    `Senior_Description` text,
    PRIMARY KEY (`Id_USER`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- Déchargement des données de la table `senior`
--

INSERT INTO
    `senior` (
        `Id_USER`,
        `Birth_Date`,
        `Sponsor_Code`,
        `Senior_Description`
    )
VALUES (8, '1950-05-14', NULL, NULL),
    (12, '2026-03-11', NULL, NULL),
    (14, '1950-01-01', NULL, NULL),
    (19, '2001-03-27', NULL, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `service_type`
--

DROP TABLE IF EXISTS `service_type`;

CREATE TABLE IF NOT EXISTS `service_type` (
    `Id_SERVICE_TYPE` int NOT NULL AUTO_INCREMENT,
    `Name` varchar(50) DEFAULT NULL,
    `Id_CATEGORY` int DEFAULT NULL,
    `Default_Hourly_Price` decimal(5, 2) DEFAULT NULL,
    `link_img` varchar(255) DEFAULT 'public/assets/img/provider/default.png',
    `Duration_Min` int NOT NULL DEFAULT '60',
    PRIMARY KEY (`Id_SERVICE_TYPE`),
    KEY `fk_service_category` (`Id_CATEGORY`)
) ENGINE = InnoDB AUTO_INCREMENT = 9 DEFAULT CHARSET = utf8mb3;

--
-- Déchargement des données de la table `service_type`
--

INSERT INTO
    `service_type` (
        `Id_SERVICE_TYPE`,
        `Name`,
        `Id_CATEGORY`,
        `Default_Hourly_Price`,
        `link_img`,
        `Duration_Min`
    )
VALUES (
        1,
        'M├®nage complet',
        3,
        '20.00',
        'public/assets/img/provider/default.png',
        60
    ),
    (
        2,
        'Jardinage',
        4,
        '25.00',
        'public/assets/img/provider/default.png',
        60
    ),
    (
        3,
        'Coaching Sportif',
        1,
        '40.00',
        'public/assets/img/provider/default.png',
        120
    ),
    (
        4,
        'Massage relaxant',
        1,
        '50.00',
        'public/assets/img/provider/default.png',
        60
    ),
    (
        5,
        'Yoga Seniors',
        1,
        '30.00',
        'public/assets/img/provider/default.png',
        60
    ),
    (
        6,
        'M├®ditation guid├®e',
        1,
        '20.00',
        'public/assets/img/provider/default.png',
        60
    ),
    (
        7,
        'Orthodontiste',
        2,
        '70.00',
        'public/assets/img/provider/default.png',
        60
    ),
    (
        8,
        'M├®decin G├®n├®raliste',
        2,
        '25.00',
        'public/assets/img/provider/default.png',
        60
    );

-- --------------------------------------------------------

--
-- Structure de la table `shop_order`
--

DROP TABLE IF EXISTS `shop_order`;

CREATE TABLE IF NOT EXISTS `shop_order` (
    `Id_ORDER` int NOT NULL AUTO_INCREMENT,
    `Id_USER` int NOT NULL,
    `Amount_Total` int NOT NULL,
    `Status` varchar(50) DEFAULT 'pending',
    `Stripe_Session_Id` varchar(255) DEFAULT NULL,
    `Created_At` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id_ORDER`)
) ENGINE = MyISAM AUTO_INCREMENT = 7 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `shop_order`
--

INSERT INTO
    `shop_order` (
        `Id_ORDER`,
        `Id_USER`,
        `Amount_Total`,
        `Status`,
        `Stripe_Session_Id`,
        `Created_At`
    )
VALUES (
        1,
        19,
        7960,
        'paid',
        'cs_test_a1MMbiiQ41wUokUqYtNdm71FmR389SO0KPrpPlgrXEWVlZxN0MHKw6QGmL',
        '2026-04-14 23:10:43'
    ),
    (
        2,
        19,
        8970,
        'paid',
        'cs_test_a1X19wqa5hoKt0d6nqZmv0U55kb7jx3j0TxTGJt1GImTAnFthB4H4PO5bd',
        '2026-04-15 18:16:26'
    ),
    (
        3,
        19,
        8970,
        'pending',
        'cs_test_a1l1QgH0FwAPA105lD6NQNbgjpakR4OjWX75SUpDXkEuc7Y5rqD1BHiXGa',
        '2026-04-21 16:45:37'
    ),
    (
        4,
        19,
        6230,
        'pending',
        'cs_test_b1s2wdQSUAgh5bKsmblwav840xIO1P0ik92Z3cVDHLAh2pQle3SFNkdNSj',
        '2026-05-08 03:10:36'
    ),
    (
        5,
        19,
        7480,
        'pending',
        'cs_test_b1HyZoV23jgIdeZBDuUAR8PAgyk5lWrxXhRk2vurfJaHDBCb53t2kBLuBX',
        '2026-05-08 03:26:26'
    ),
    (
        6,
        19,
        9470,
        'paid',
        'cs_test_b1GUUfV662ErQgcc4rp1vMz7HDudFo5x5sEwrNJTgzlLMFUQLXpBysSpvr',
        '2026-05-08 03:36:29'
    );

-- --------------------------------------------------------

--
-- Structure de la table `shop_order_item`
--

DROP TABLE IF EXISTS `shop_order_item`;

CREATE TABLE IF NOT EXISTS `shop_order_item` (
    `Id_ORDER_ITEM` int NOT NULL AUTO_INCREMENT,
    `Id_ORDER` int NOT NULL,
    `Id_PRODUCT` int NOT NULL,
    `Name` varchar(255) DEFAULT NULL,
    `Price_Cents` int DEFAULT NULL,
    `Qty` int DEFAULT NULL,
    PRIMARY KEY (`Id_ORDER_ITEM`)
) ENGINE = MyISAM AUTO_INCREMENT = 13 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `shop_order_item`
--

INSERT INTO
    `shop_order_item` (
        `Id_ORDER_ITEM`,
        `Id_ORDER`,
        `Id_PRODUCT`,
        `Name`,
        `Price_Cents`,
        `Qty`
    )
VALUES (1, 1, 3, 'Loupe LED', 1990, 4),
    (
        2,
        2,
        1,
        'Coussin lombaire',
        2990,
        3
    ),
    (
        3,
        3,
        1,
        'Coussin lombaire',
        2990,
        3
    ),
    (
        4,
        4,
        1,
        'Coussin lombaire',
        2990,
        1
    ),
    (
        5,
        4,
        2,
        'Pilulier hebdo',
        1250,
        1
    ),
    (6, 4, 3, 'Loupe LED', 1990, 1),
    (
        7,
        5,
        1,
        'Coussin lombaire',
        2990,
        1
    ),
    (
        8,
        5,
        2,
        'Pilulier hebdo',
        1250,
        2
    ),
    (9, 5, 3, 'Loupe LED', 1990, 1),
    (
        10,
        6,
        1,
        'Coussin lombaire',
        2990,
        1
    ),
    (
        11,
        6,
        2,
        'Pilulier hebdo',
        1250,
        2
    ),
    (
        12,
        6,
        3,
        'Loupe LED',
        1990,
        2
    );

-- --------------------------------------------------------

--
-- Structure de la table `subscribe`
--

DROP TABLE IF EXISTS `subscribe`;

CREATE TABLE IF NOT EXISTS `subscribe` (
    `Id_USER` int NOT NULL,
    `Id_SUBSCRIPTION_PLAN` int NOT NULL,
    `Start_Date` date DEFAULT NULL,
    `End_Date` date DEFAULT NULL,
    `Is_Active` tinyint(1) DEFAULT '1',
    PRIMARY KEY (
        `Id_USER`,
        `Id_SUBSCRIPTION_PLAN`
    ),
    KEY `Id_SUBSCRIPTION_PLAN` (`Id_SUBSCRIPTION_PLAN`)
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb3;

--
-- Déchargement des données de la table `subscribe`
--

INSERT INTO
    `subscribe` (
        `Id_USER`,
        `Id_SUBSCRIPTION_PLAN`,
        `Start_Date`,
        `End_Date`,
        `Is_Active`
    )
VALUES (
        19,
        1,
        '2026-04-14',
        '2026-05-14',
        1
    );

-- --------------------------------------------------------

--
-- Structure de la table `subscription`
--

DROP TABLE IF EXISTS `subscription`;

CREATE TABLE IF NOT EXISTS `subscription` (
    `Id_SUBSCRIPTION` int NOT NULL AUTO_INCREMENT,
    `Id_USER` int NOT NULL,
    `Stripe_Customer_ID` varchar(100) DEFAULT NULL,
    `Stripe_Subscription_ID` varchar(100) DEFAULT NULL,
    `Plan` enum('monthly', 'yearly') NOT NULL,
    `Is_Renewal` tinyint(1) DEFAULT '0',
    `Status` enum(
        'active',
        'canceled',
        'past_due'
    ) DEFAULT 'active',
    `Current_Period_End` datetime DEFAULT NULL,
    `Created_At` datetime DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`Id_SUBSCRIPTION`)
) ENGINE = MyISAM DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `subscription_plan`
--

DROP TABLE IF EXISTS `subscription_plan`;

CREATE TABLE IF NOT EXISTS `subscription_plan` (
    `Id_SUBSCRIPTION_PLAN` int NOT NULL AUTO_INCREMENT,
    `Name` varchar(50) DEFAULT NULL,
    `Price` decimal(10, 2) DEFAULT NULL,
    `Duration_Months` int DEFAULT NULL,
    PRIMARY KEY (`Id_SUBSCRIPTION_PLAN`)
) ENGINE = InnoDB AUTO_INCREMENT = 5 DEFAULT CHARSET = utf8mb3;

--
-- Déchargement des données de la table `subscription_plan`
--

INSERT INTO
    `subscription_plan` (
        `Id_SUBSCRIPTION_PLAN`,
        `Name`,
        `Price`,
        `Duration_Months`
    )
VALUES (
        1,
        'monthly_normal',
        '4.00',
        1
    ),
    (
        2,
        'yearly_normal',
        '40.00',
        12
    ),
    (
        3,
        'monthly_renewal',
        '3.00',
        1
    ),
    (
        4,
        'yearly_renewal',
        '35.00',
        12
    );

-- --------------------------------------------------------

--
-- Structure de la table `user`
--

DROP TABLE IF EXISTS `user`;

CREATE TABLE IF NOT EXISTS `user` (
    `Id_USER` int NOT NULL AUTO_INCREMENT,
    `Address_Street` varchar(70) DEFAULT NULL,
    `Address_Zip` char(5) DEFAULT NULL,
    `Address_City` varchar(50) DEFAULT NULL,
    `Registration_Date` datetime DEFAULT CURRENT_TIMESTAMP,
    `Email` varchar(70) NOT NULL,
    `Password` varchar(255) DEFAULT NULL,
    `Nom` varchar(70) DEFAULT NULL,
    `Prenom` varchar(70) DEFAULT NULL,
    `Phone_Number` varchar(20) DEFAULT NULL,
    `Sex` tinyint(1) DEFAULT NULL,
    `authentication_token` varchar(255) DEFAULT NULL,
    `Is_Banned` tinyint(1) NOT NULL DEFAULT '0',
    PRIMARY KEY (`Id_USER`),
    UNIQUE KEY `Email` (`Email`)
) ENGINE = InnoDB AUTO_INCREMENT = 26 DEFAULT CHARSET = utf8mb3;

--
-- Déchargement des données de la table `user`
--

INSERT INTO
    `user` (
        `Id_USER`,
        `Address_Street`,
        `Address_Zip`,
        `Address_City`,
        `Registration_Date`,
        `Email`,
        `Password`,
        `Nom`,
        `Prenom`,
        `Phone_Number`,
        `Sex`,
        `authentication_token`,
        `Is_Banned`
    )
VALUES (
        1,
        NULL,
        NULL,
        NULL,
        '2026-02-22 14:59:32',
        'jean@nettoyage.com',
        'fakehash123',
        NULL,
        NULL,
        '0601020304',
        NULL,
        NULL,
        0
    ),
    (
        2,
        NULL,
        NULL,
        NULL,
        '2026-02-22 14:59:32',
        'marc@fitness.com',
        'fakehash456',
        NULL,
        NULL,
        '0611223344',
        NULL,
        NULL,
        0
    ),
    (
        3,
        NULL,
        NULL,
        NULL,
        '2026-02-23 18:54:41',
        'sophie@massage.com',
        'hash',
        NULL,
        NULL,
        '0622334455',
        NULL,
        NULL,
        0
    ),
    (
        4,
        NULL,
        NULL,
        NULL,
        '2026-02-23 18:54:41',
        'lucas@yoga.com',
        'hash',
        NULL,
        NULL,
        '0633445566',
        NULL,
        NULL,
        0
    ),
    (
        5,
        NULL,
        NULL,
        NULL,
        '2026-02-23 18:54:41',
        'emma@meditation.com',
        'hash',
        NULL,
        NULL,
        '0666778899',
        NULL,
        NULL,
        0
    ),
    (
        6,
        NULL,
        NULL,
        NULL,
        '2026-02-23 18:54:41',
        'dr.dent@dental.com',
        'hash',
        NULL,
        NULL,
        '0655667788',
        NULL,
        NULL,
        0
    ),
    (
        7,
        NULL,
        NULL,
        NULL,
        '2026-02-23 18:54:41',
        'dr.smith@medical.com',
        'hash',
        NULL,
        NULL,
        '0644556677',
        NULL,
        NULL,
        0
    ),
    (
        8,
        NULL,
        NULL,
        NULL,
        '2026-02-27 16:53:45',
        'senior_test@mail.com',
        'hash',
        NULL,
        NULL,
        '0699887766',
        NULL,
        NULL,
        0
    ),
    (
        9,
        NULL,
        NULL,
        NULL,
        '2026-02-27 16:53:45',
        'admin_boss@mail.com',
        'hash',
        NULL,
        NULL,
        '0611111111',
        NULL,
        NULL,
        0
    ),
    (
        10,
        '67',
        '75001',
        'Paris',
        '2026-03-01 22:30:39',
        'mat_prest@gmail.com',
        '$2y$10$fVB4XGVGbY4sA1gYHXTsSOzt1X14gk.n346PUi37kw5JJmlhYamFW',
        NULL,
        NULL,
        '0612345678',
        NULL,
        NULL,
        0
    ),
    (
        11,
        '3',
        '3',
        'oui',
        '2026-03-02 20:48:01',
        'k@gmail.com',
        '$2y$10$DbZNkja/QnnwbST5dcX4BusQIFOTU5FVpaVoMFvAp4LRYEC.N9Fv6',
        NULL,
        NULL,
        '0909090909',
        NULL,
        NULL,
        0
    ),
    (
        12,
        '3',
        '92110',
        'clichy',
        '2026-03-11 14:25:52',
        'dk@gmail.com',
        '$2y$10$/UeJAn5Cc3K7Q8ZMf1sqt.0OAFY6RZKI.MC0UgnBYpUP4TrkkSFOa',
        NULL,
        NULL,
        '0909090909',
        NULL,
        NULL,
        0
    ),
    (
        14,
        NULL,
        NULL,
        NULL,
        '2026-03-16 16:39:44',
        'test2@test.fr',
        '$2a$10$N3PzIBJyAziDi/JCG2868eI5fIuiY.3b5x5fqNsL5LpgV24joCA3G',
        'Test',
        'User',
        '0600000000',
        NULL,
        'K31ik5UuOUA31fXYOg-cr5DzWjXewvhHFaUt-XxQOwM',
        0
    ),
    (
        19,
        '2',
        '92110',
        'clichy',
        '2026-03-23 21:21:56',
        'ze@gmail.com',
        '$2a$10$7CQX9DCBV1IPMOVB9nelz.lUKRI33RIiKgNm7iHromsxkjOk2B7dC',
        'vieux',
        'jerome',
        '0909090909',
        NULL,
        'ud0jd0PwWDIv_bzyb19Ickp_hO-L9QV4HvMdmz9-aNc',
        0
    ),
    (
        20,
        NULL,
        NULL,
        NULL,
        '2026-03-31 14:04:16',
        'zeadmin@gmail.com',
        '$2a$10$FeNaCGALl0SeTQJg5MpMgeDUoGHgTCEB8z9ygGTicLDmVoAyD1aTW',
        'rigoni',
        'jerome',
        '',
        NULL,
        '3XnpiSkhs0hKhHfZ9_45Pwq-4O1epJo91r_ijOjFfdw',
        0
    ),
    (
        21,
        NULL,
        NULL,
        'Paris',
        '2026-04-03 12:30:57',
        'zeadmin2@gmail.com',
        '$2a$10$duGAoMvd/UNOsRw4eOc7mu7u/etMq6NLuPQqRdbvBuiJfMJNxh3zq',
        'ze',
        'ze',
        '0909090902',
        NULL,
        'Ju_SAR47cGIByzqIf_Wtvatx3I7yzaNm8hIZLoOeJAM',
        0
    ),
    (
        23,
        'oui',
        'oui',
        'oui',
        '2026-04-05 17:19:17',
        't@gmail.com',
        '$2a$10$c8vTe9eGs8gN9Vh.BDidyu2Pizc7dJcQyUJ5OgHGkzv80Zk1N6rxC',
        'test',
        'test',
        '0909090902',
        NULL,
        '8C-G8TGNbsVjR0x06gKwbPCjAGuAIs9QIsimIKldZJA',
        0
    ),
    (
        24,
        NULL,
        NULL,
        NULL,
        '2026-05-05 18:59:11',
        'test@gmail.com',
        '$2a$10$20SDzx/2DYffQbbszXCMV.3udYjp7GI37ei4q7ymdoMiXNG74KlrC',
        'test',
        'test',
        '0909090909',
        NULL,
        'Mb1htORN23QwEbGNz8S-uvx5nFeIzkmljpVE-wUDHf0',
        0
    );

-- --------------------------------------------------------

--
-- Structure de la table `user_report`
--

DROP TABLE IF EXISTS `user_report`;

CREATE TABLE IF NOT EXISTS `user_report` (
    `Id_REPORT` int NOT NULL AUTO_INCREMENT,
    `Id_REPORTED` int NOT NULL,
    `Id_REPORTER` int NOT NULL,
    `Reason` text NOT NULL,
    `Status` enum(
        'pending',
        'resolved',
        'dismissed'
    ) NOT NULL DEFAULT 'pending',
    `Created_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Reviewed_At` datetime DEFAULT NULL,
    `Reviewed_By` int DEFAULT NULL,
    PRIMARY KEY (`Id_REPORT`),
    KEY `Id_REPORTER` (`Id_REPORTER`),
    KEY `Reviewed_By` (`Reviewed_By`),
    KEY `idx_reported` (`Id_REPORTED`),
    KEY `idx_status` (`Status`)
) ENGINE = MyISAM AUTO_INCREMENT = 3 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `user_report`
--

INSERT INTO
    `user_report` (
        `Id_REPORT`,
        `Id_REPORTED`,
        `Id_REPORTER`,
        `Reason`,
        `Status`,
        `Created_At`,
        `Reviewed_At`,
        `Reviewed_By`
    )
VALUES (
        1,
        2,
        3,
        'Test signalement',
        'dismissed',
        '2026-05-07 15:01:04',
        '2026-05-07 15:01:50',
        20
    ),
    (
        2,
        24,
        19,
        'Moche',
        'resolved',
        '2026-05-07 15:24:45',
        '2026-05-07 15:25:13',
        20
    );

-- --------------------------------------------------------

--
-- Structure de la table `user_sanction`
--

DROP TABLE IF EXISTS `user_sanction`;

CREATE TABLE IF NOT EXISTS `user_sanction` (
    `Id_SANCTION` int NOT NULL AUTO_INCREMENT,
    `Id_USER` int NOT NULL,
    `Type` enum(
        'warning',
        'ban_temp',
        'ban_perm'
    ) NOT NULL,
    `Reason` text NOT NULL,
    `Banned_Until` datetime DEFAULT NULL,
    `Created_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `Created_By` int DEFAULT NULL,
    `Acknowledged` tinyint(1) NOT NULL DEFAULT '0',
    `Acknowledged_At` datetime DEFAULT NULL,
    `Source` enum(
        'manual',
        'auto_warning_threshold',
        'auto_ban_threshold'
    ) NOT NULL DEFAULT 'manual',
    `Id_REPORT` int DEFAULT NULL,
    PRIMARY KEY (`Id_SANCTION`),
    KEY `Created_By` (`Created_By`),
    KEY `Id_REPORT` (`Id_REPORT`),
    KEY `idx_user` (`Id_USER`),
    KEY `idx_ack` (`Acknowledged`),
    KEY `idx_type` (`Type`)
) ENGINE = MyISAM AUTO_INCREMENT = 2 DEFAULT CHARSET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `user_sanction`
--

INSERT INTO
    `user_sanction` (
        `Id_SANCTION`,
        `Id_USER`,
        `Type`,
        `Reason`,
        `Banned_Until`,
        `Created_At`,
        `Created_By`,
        `Acknowledged`,
        `Acknowledged_At`,
        `Source`,
        `Id_REPORT`
    )
VALUES (
        1,
        24,
        'warning',
        'Attention, t\'es moche',
        NULL,
        '2026-05-07 15:25:13',
        20,
        1,
        '2026-05-07 15:25:43',
        'manual',
        2
    );

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `admin`
--
ALTER TABLE `admin`
ADD CONSTRAINT `fk_admin_user` FOREIGN KEY (`Id_USER`) REFERENCES `user` (`Id_USER`) ON DELETE CASCADE;

--
-- Contraintes pour la table `document`
--
ALTER TABLE `document`
ADD CONSTRAINT `document_ibfk_1` FOREIGN KEY (`Id_USER`) REFERENCES `provider` (`Id_USER`) ON DELETE CASCADE,
ADD CONSTRAINT `fk_document_category` FOREIGN KEY (`Id_CATEGORY`) REFERENCES `category` (`Id_CATEGORY`);

--
-- Contraintes pour la table `intervention`
--
ALTER TABLE `intervention`
ADD CONSTRAINT `intervention_ibfk_1` FOREIGN KEY (`Id_INVOICE`) REFERENCES `invoice` (`Id_INVOICE`),
ADD CONSTRAINT `intervention_ibfk_2` FOREIGN KEY (`Id_SERVICE_TYPE`) REFERENCES `service_type` (`Id_SERVICE_TYPE`),
ADD CONSTRAINT `intervention_ibfk_3` FOREIGN KEY (`Id_PROVIDER`) REFERENCES `provider` (`Id_USER`),
ADD CONSTRAINT `intervention_ibfk_4` FOREIGN KEY (`Id_SENIOR`) REFERENCES `senior` (`Id_USER`);

--
-- Contraintes pour la table `participate`
--
ALTER TABLE `participate`
ADD CONSTRAINT `participate_ibfk_1` FOREIGN KEY (`Id_USER`) REFERENCES `senior` (`Id_USER`) ON DELETE CASCADE,
ADD CONSTRAINT `participate_ibfk_2` FOREIGN KEY (`Id_EVENT`) REFERENCES `event` (`Id_EVENT`) ON DELETE CASCADE;

--
-- Contraintes pour la table `provider`
--
ALTER TABLE `provider`
ADD CONSTRAINT `fk_provider_user` FOREIGN KEY (`Id_USER`) REFERENCES `user` (`Id_USER`) ON DELETE CASCADE;

--
-- Contraintes pour la table `qualify`
--
ALTER TABLE `qualify`
ADD CONSTRAINT `qualify_ibfk_1` FOREIGN KEY (`Id_USER`) REFERENCES `provider` (`Id_USER`) ON DELETE CASCADE,
ADD CONSTRAINT `qualify_ibfk_2` FOREIGN KEY (`Id_SERVICE_TYPE`) REFERENCES `service_type` (`Id_SERVICE_TYPE`) ON DELETE CASCADE;

--
-- Contraintes pour la table `senior`
--
ALTER TABLE `senior`
ADD CONSTRAINT `fk_senior_user` FOREIGN KEY (`Id_USER`) REFERENCES `user` (`Id_USER`) ON DELETE CASCADE;

--
-- Contraintes pour la table `service_type`
--
ALTER TABLE `service_type`
ADD CONSTRAINT `fk_service_category` FOREIGN KEY (`Id_CATEGORY`) REFERENCES `category` (`Id_CATEGORY`);

--
-- Contraintes pour la table `subscribe`
--
ALTER TABLE `subscribe`
ADD CONSTRAINT `subscribe_ibfk_1` FOREIGN KEY (`Id_USER`) REFERENCES `user` (`Id_USER`) ON DELETE CASCADE,
ADD CONSTRAINT `subscribe_ibfk_2` FOREIGN KEY (`Id_SUBSCRIPTION_PLAN`) REFERENCES `subscription_plan` (`Id_SUBSCRIPTION_PLAN`);

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */
;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */
;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */
;