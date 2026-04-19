-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : ven. 27 mars 2026 à 16:56
-- Version du serveur : 8.0.31
-- Version de PHP : 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `admin`
--

INSERT INTO `admin` (`Id_USER`, `Role_Level`) VALUES
(9, '2');

-- --------------------------------------------------------

--
-- Structure de la table `animates`
--

DROP TABLE IF EXISTS `animates`;
CREATE TABLE IF NOT EXISTS `animates` (
  `Id_USER` int NOT NULL,
  `Id_EVENT` int NOT NULL,
  PRIMARY KEY (`Id_USER`,`Id_EVENT`),
  KEY `Id_EVENT` (`Id_EVENT`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  PRIMARY KEY (`Id_USER`,`Id_PRODUCT`),
  KEY `fk_cart_product` (`Id_PRODUCT`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `category`
--

INSERT INTO `category` (`Id_CATEGORY`, `Name`) VALUES
(1, 'Bien-étre'),
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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Structure de la table `event`
--

DROP TABLE IF EXISTS `event`;
CREATE TABLE IF NOT EXISTS `event` (
  `Id_EVENT` int NOT NULL AUTO_INCREMENT,
  `Title` varchar(50) DEFAULT NULL,
  `Location` varchar(100) DEFAULT NULL,
  `Event_Date` datetime DEFAULT NULL,
  `Max_Participants` int DEFAULT NULL,
  PRIMARY KEY (`Id_EVENT`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `event`
--

INSERT INTO `event` (`Id_EVENT`, `Title`, `Location`, `Event_Date`, `Max_Participants`) VALUES
(1, 'Atelier mémoire', 'Paris', '2026-04-02 14:00:00', 12),
(2, 'Sortie culturelle', 'Musée du Louvre', '2026-04-05 10:30:00', 25),
(3, 'Atelier mémoire', 'Paris', '2026-04-02 14:00:00', 12),
(4, 'Sortie culturelle', 'Musée du Louvre', '2026-04-05 10:30:00', 25);

-- --------------------------------------------------------

--
-- Structure de la table `event_registration`
--

DROP TABLE IF EXISTS `event_registration`;
CREATE TABLE IF NOT EXISTS `event_registration` (
  `Id_EVENT` int NOT NULL,
  `Id_USER` int NOT NULL,
  `Created_At` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`Id_EVENT`,`Id_USER`),
  KEY `fk_eventreg_user` (`Id_USER`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  `Senior_Rating` decimal(2,0) DEFAULT NULL,
  `Senior_Comment` text,
  `Id_INVOICE` int DEFAULT NULL,
  `Id_SERVICE_TYPE` int NOT NULL,
  `Id_PROVIDER` int DEFAULT NULL,
  `Id_SENIOR` int NOT NULL,
  PRIMARY KEY (`Id_INTERVENTION`),
  KEY `Id_INVOICE` (`Id_INVOICE`),
  KEY `Id_SERVICE_TYPE` (`Id_SERVICE_TYPE`),
  KEY `Id_PROVIDER` (`Id_PROVIDER`),
  KEY `Id_SENIOR` (`Id_SENIOR`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Structure de la table `invoice`
--

DROP TABLE IF EXISTS `invoice`;
CREATE TABLE IF NOT EXISTS `invoice` (
  `Id_INVOICE` int NOT NULL AUTO_INCREMENT,
  `Date_Generated` datetime DEFAULT CURRENT_TIMESTAMP,
  `PDF_Url` varchar(250) DEFAULT NULL,
  `Total_Amount` decimal(10,2) DEFAULT NULL,
  `Is_Paid` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`Id_INVOICE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

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
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  PRIMARY KEY (`Id_USER`,`Id_EVENT`),
  KEY `Id_EVENT` (`Id_EVENT`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

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
  UNIQUE KEY `uniq_user_item` (`Id_USER`,`Item_Type`,`Ref_ID`)
) ENGINE=MyISAM AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `practices`
--

DROP TABLE IF EXISTS `practices`;
CREATE TABLE IF NOT EXISTS `practices` (
  `Id_USER` int NOT NULL,
  `Id_CATEGORY` int NOT NULL,
  PRIMARY KEY (`Id_USER`,`Id_CATEGORY`),
  KEY `Id_CATEGORY` (`Id_CATEGORY`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `product`
--

DROP TABLE IF EXISTS `product`;
CREATE TABLE IF NOT EXISTS `product` (
  `Id_PRODUCT` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(120) NOT NULL,
  `Category` varchar(60) DEFAULT NULL,
  `Price` decimal(10,2) NOT NULL,
  `link_img` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`Id_PRODUCT`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Déchargement des données de la table `product`
--

INSERT INTO `product` (`Id_PRODUCT`, `Name`, `Category`, `Price`, `link_img`) VALUES
(1, 'Coussin lombaire', 'Confort', '29.90', NULL),
(2, 'Pilulier hebdo', 'Santé', '12.50', NULL),
(3, 'Loupe LED', 'Accessibilité', '19.90', NULL);

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
  `Commission_Rate` decimal(5,2) DEFAULT '1.00',
  PRIMARY KEY (`Id_USER`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `provider`
--

INSERT INTO `provider` (`Id_USER`, `Company_Name`, `SIRET_Number`, `IBAN`, `Provider_Description`, `Validation_Status`, `Commission_Rate`) VALUES
(1, 'Jean Nettoyage Express', '12345678901234', NULL, NULL, 1, '1.00'),
(2, 'Marc Fitness Pro', '98765432109876', NULL, NULL, 1, '1.00'),
(3, 'Sophie Détente', '11111111111111', NULL, NULL, 1, '1.00'),
(4, 'Lucas Yoga Zen', '22222222222222', NULL, NULL, 1, '1.00'),
(5, 'Emma Esprit Clair', '55555555555555', NULL, NULL, 1, '1.00'),
(6, 'Cabinet Dentaire Paris', '44444444444444', NULL, NULL, 1, '1.00'),
(7, 'Cabinet Dr Smith', '33333333333333', NULL, NULL, 1, '1.00'),
(10, 'Mat la classe', '12345678901234', NULL, NULL, 0, '1.00'),
(11, 'JCPAS', '12345678901234', NULL, NULL, 0, '1.00');

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
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Structure de la table `provider_schedule`
--

DROP TABLE IF EXISTS `provider_schedule`;
CREATE TABLE IF NOT EXISTS `provider_schedule` (
  `Id_SCHEDULE` int NOT NULL AUTO_INCREMENT,
  `Day_Of_Week` decimal(1,0) NOT NULL,
  `Start_Time` time NOT NULL,
  `End_Time` time NOT NULL,
  `Id_USER` int NOT NULL,
  PRIMARY KEY (`Id_SCHEDULE`),
  KEY `Id_USER` (`Id_USER`)
) ;

-- --------------------------------------------------------

--
-- Structure de la table `qualify`
--

DROP TABLE IF EXISTS `qualify`;
CREATE TABLE IF NOT EXISTS `qualify` (
  `Id_USER` int NOT NULL,
  `Id_SERVICE_TYPE` int NOT NULL,
  `Custom_Title` varchar(100) DEFAULT NULL,
  `Negotiated_Price` decimal(10,2) DEFAULT NULL,
  `Experience_Years` int DEFAULT NULL,
  `Is_Active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`Id_USER`,`Id_SERVICE_TYPE`),
  KEY `Id_SERVICE_TYPE` (`Id_SERVICE_TYPE`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `qualify`
--

INSERT INTO `qualify` (`Id_USER`, `Id_SERVICE_TYPE`, `Custom_Title`, `Negotiated_Price`, `Experience_Years`, `Is_Active`) VALUES
(1, 1, NULL, '18.00', NULL, 1),
(2, 3, NULL, '35.00', NULL, 1),
(3, 4, NULL, '45.00', NULL, 1),
(4, 5, NULL, '25.00', NULL, 1),
(5, 6, NULL, '20.00', NULL, 1),
(6, 7, NULL, '70.00', NULL, 1),
(7, 8, NULL, '25.00', NULL, 1),
(10, 1, 'M├®nager vos vous ! ha ha haha', '99.99', 0, 1),
(10, 3, 'Boxe anglaise', '20.00', 3, 1),
(11, 4, 'Un massage bien malaxant ( pas cher )', '9797.00', 1, 1);

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
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `senior`
--

INSERT INTO `senior` (`Id_USER`, `Birth_Date`, `Sponsor_Code`, `Senior_Description`) VALUES
(8, '1950-05-14', NULL, NULL),
(12, '2026-03-11', NULL, NULL),
(13, '2026-03-11', NULL, NULL),
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
  `Default_Hourly_Price` decimal(5,2) DEFAULT NULL,
  `link_img` varchar(255) DEFAULT 'public/assets/img/provider/default.png',
  PRIMARY KEY (`Id_SERVICE_TYPE`),
  KEY `fk_service_category` (`Id_CATEGORY`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `service_type`
--

INSERT INTO `service_type` (`Id_SERVICE_TYPE`, `Name`, `Id_CATEGORY`, `Default_Hourly_Price`, `link_img`) VALUES
(1, 'M├®nage complet', 3, '20.00', 'public/assets/img/provider/default.png'),
(2, 'Jardinage', 4, '25.00', 'public/assets/img/provider/default.png'),
(3, 'Coaching Sportif', 1, '40.00', 'public/assets/img/provider/default.png'),
(4, 'Massage relaxant', 1, '50.00', 'public/assets/img/provider/default.png'),
(5, 'Yoga Seniors', 1, '30.00', 'public/assets/img/provider/default.png'),
(6, 'M├®ditation guid├®e', 1, '20.00', 'public/assets/img/provider/default.png'),
(7, 'Orthodontiste', 2, '70.00', 'public/assets/img/provider/default.png'),
(8, 'M├®decin G├®n├®raliste', 2, '25.00', 'public/assets/img/provider/default.png');

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
  PRIMARY KEY (`Id_USER`,`Id_SUBSCRIPTION_PLAN`),
  KEY `Id_SUBSCRIPTION_PLAN` (`Id_SUBSCRIPTION_PLAN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- --------------------------------------------------------

--
-- Structure de la table `subscription_plan`
--

DROP TABLE IF EXISTS `subscription_plan`;
CREATE TABLE IF NOT EXISTS `subscription_plan` (
  `Id_SUBSCRIPTION_PLAN` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(50) DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  `Duration_Months` int DEFAULT NULL,
  PRIMARY KEY (`Id_SUBSCRIPTION_PLAN`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

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
  PRIMARY KEY (`Id_USER`),
  UNIQUE KEY `Email` (`Email`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb3;

--
-- Déchargement des données de la table `user`
--

INSERT INTO `user` (`Id_USER`, `Address_Street`, `Address_Zip`, `Address_City`, `Registration_Date`, `Email`, `Password`, `Nom`, `Prenom`, `Phone_Number`, `Sex`, `authentication_token`) VALUES
(1, NULL, NULL, NULL, '2026-02-22 14:59:32', 'jean@nettoyage.com', 'fakehash123', NULL, NULL, '0601020304', NULL, NULL),
(2, NULL, NULL, NULL, '2026-02-22 14:59:32', 'marc@fitness.com', 'fakehash456', NULL, NULL, '0611223344', NULL, NULL),
(3, NULL, NULL, NULL, '2026-02-23 18:54:41', 'sophie@massage.com', 'hash', NULL, NULL, '0622334455', NULL, NULL),
(4, NULL, NULL, NULL, '2026-02-23 18:54:41', 'lucas@yoga.com', 'hash', NULL, NULL, '0633445566', NULL, NULL),
(5, NULL, NULL, NULL, '2026-02-23 18:54:41', 'emma@meditation.com', 'hash', NULL, NULL, '0666778899', NULL, NULL),
(6, NULL, NULL, NULL, '2026-02-23 18:54:41', 'dr.dent@dental.com', 'hash', NULL, NULL, '0655667788', NULL, NULL),
(7, NULL, NULL, NULL, '2026-02-23 18:54:41', 'dr.smith@medical.com', 'hash', NULL, NULL, '0644556677', NULL, NULL),
(8, NULL, NULL, NULL, '2026-02-27 16:53:45', 'senior_test@mail.com', 'hash', NULL, NULL, '0699887766', NULL, NULL),
(9, NULL, NULL, NULL, '2026-02-27 16:53:45', 'admin_boss@mail.com', 'hash', NULL, NULL, '0611111111', NULL, NULL),
(10, '67', '75001', 'Paris', '2026-03-01 22:30:39', 'mat_prest@gmail.com', '$2y$10$fVB4XGVGbY4sA1gYHXTsSOzt1X14gk.n346PUi37kw5JJmlhYamFW', NULL, NULL, '0612345678', NULL, NULL),
(11, '3', '3', 'oui', '2026-03-02 20:48:01', 'k@gmail.com', '$2y$10$DbZNkja/QnnwbST5dcX4BusQIFOTU5FVpaVoMFvAp4LRYEC.N9Fv6', NULL, NULL, '0909090909', NULL, NULL),
(12, '3', '92110', 'clichy', '2026-03-11 14:25:52', 'dk@gmail.com', '$2y$10$/UeJAn5Cc3K7Q8ZMf1sqt.0OAFY6RZKI.MC0UgnBYpUP4TrkkSFOa', NULL, NULL, '0909090909', NULL, NULL),
(13, '3', '92110', 'clichy', '2026-03-11 14:52:05', 'dkl@gmail.com', '$2y$10$W.ZAdUJcQS2ZGg3qj16xHupp0KyR.VTtqfQw2XAoVmFMdt0FN0xse', NULL, NULL, '0909090909', NULL, NULL),
(14, NULL, NULL, NULL, '2026-03-16 16:39:44', 'test2@test.fr', '$2a$10$N3PzIBJyAziDi/JCG2868eI5fIuiY.3b5x5fqNsL5LpgV24joCA3G', 'Test', 'User', '0600000000', NULL, 'K31ik5UuOUA31fXYOg-cr5DzWjXewvhHFaUt-XxQOwM'),
(19, '2', '92110', 'clichy', '2026-03-23 21:21:56', 'ze@gmail.com', '$2a$10$7CQX9DCBV1IPMOVB9nelz.lUKRI33RIiKgNm7iHromsxkjOk2B7dC', 'vieux', 'jerome', '0909090909', NULL, 'FxeuxFHwc8SJAe1wjMU_icxa-mxxyfxlSForKkayGkE');

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

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;


-- colonne Validation_Status pour la table event
ALTER TABLE event ADD COLUMN Validation_Status TINYINT(1) DEFAULT 0;

-- update les events qui existe avec valider
UPDATE event SET Validation_Status = 1 WHERE Validation_Status IS NULL;