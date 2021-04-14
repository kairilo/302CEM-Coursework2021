-- phpMyAdmin SQL Dump
-- version 4.8.5
-- https://www.phpmyadmin.net/
--
-- 主機： 127.0.0.1
-- 產生時間： 
-- 伺服器版本： 10.1.38-MariaDB
-- PHP 版本： 7.3.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- 資料庫： `delivery`
--

-- --------------------------------------------------------

--
-- 資料表結構 `login_info`
--

CREATE TABLE `login_info` (
  `username` varchar(18) NOT NULL,
  `password` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 傾印資料表的資料 `login_info`
--

INSERT INTO `login_info` (`username`, `password`) VALUES
('A01', 'StKM'),
('A02', 'HauBK'),
('A03', 'YungSC'),
('A04', 'YeungSA'),
('A05', 'GuMing'),
('A06', 'YeungWing'),
('A07', 'ChanYY'),
('A08', 'AuMY'),
('A09', 'WongTY'),
('A10', 'SinKL');

--
-- 觸發器 `login_info`
--
DELIMITER $$
CREATE TRIGGER `Insert Login Accounts` AFTER INSERT ON `login_info` FOR EACH ROW INSERT INTO common.login_info(username,password,type)
 SELECT username,password,'Delivery' FROM delivery.login_info WHERE username=(SELECT max(username) FROM delivery.login_info)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `order_ref`
--

CREATE TABLE `order_ref` (
  `order_no` char(6) NOT NULL,
  `delivery_ref_no` varchar(4) NOT NULL,
  `order_date` date NOT NULL,
  `receive_package_date` date NOT NULL,
  `total_weight_kg` float(10,4) NOT NULL,
  `total_delivery_price` int(5) NOT NULL,
  `in_charge_delivery_man` varchar(20) NOT NULL,
  `contact_tel` char(8) NOT NULL,
  `expected_delivery_date` date NOT NULL,
  `actual_delivery_datetime` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
