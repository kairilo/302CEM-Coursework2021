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
-- 資料庫： `common`
--

-- --------------------------------------------------------

--
-- 資料表結構 `login_info`
--

CREATE TABLE `login_info` (
  `username` varchar(18) NOT NULL,
  `password` varchar(20) NOT NULL,
  `type` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 傾印資料表的資料 `login_info`
--

INSERT INTO `login_info` (`username`, `password`, `type`) VALUES
('001', 'ChanTM', 'Shop'),
('002', 'LeeCM', 'Shop'),
('003', 'CheungDM', 'Shop'),
('004', 'WongEM', 'Shop'),
('005', 'HoFM', 'Shop'),
('006', 'NgGM', 'Shop'),
('007', 'LoHM', 'Shop'),
('008', 'LamIM', 'Shop'),
('009', 'NganJM', 'Shop'),
('010', 'TamKM', 'Shop'),
('A01', 'StKM', 'Delivery'),
('A02', 'HauBK', 'Delivery'),
('A03', 'YungSC', 'Delivery'),
('A04', 'YeungSA', 'Delivery'),
('A05', 'GuMing', 'Delivery'),
('A06', 'YeungWing', 'Delivery'),
('A07', 'ChanYY', 'Delivery'),
('A08', 'AuMY', 'Delivery'),
('A09', 'WongTY', 'Delivery'),
('A10', 'SinKL', 'Delivery');

-- --------------------------------------------------------

--
-- 資料表結構 `order_info`
--

CREATE TABLE `order_info` (
  `order_no` char(6) NOT NULL,
  `delivery_ref_no` varchar(4) DEFAULT NULL,
  `order_date` date DEFAULT NULL,
  `receive_package_date` date DEFAULT NULL,
  `total_weight_kg` float(10,4) DEFAULT NULL,
  `total_delivery_price` int(5) DEFAULT NULL,
  `in_charge_delivery_man` varchar(20) DEFAULT NULL,
  `contact_tel` char(8) DEFAULT NULL,
  `expected_delivery_date` date DEFAULT NULL,
  `actual_delivery_datetime` datetime DEFAULT NULL,
  `product_name` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` float(10,2) NOT NULL,
  `customer_name` varchar(50) NOT NULL,
  `customer_tel` char(8) NOT NULL,
  `customer_address` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 傾印資料表的資料 `order_info`
--

INSERT INTO `order_info` (`order_no`, `delivery_ref_no`, `order_date`, `receive_package_date`, `total_weight_kg`, `total_delivery_price`, `in_charge_delivery_man`, `contact_tel`, `expected_delivery_date`, `actual_delivery_datetime`, `product_name`, `quantity`, `price`, `customer_name`, `customer_tel`, `customer_address`) VALUES
('000001', NULL, '2021-02-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Uni Kurutoga Advance 0.5', 1, 65.00, 'MRS. P', '12348765', '2410, 2/F, Li Dak Sum Yip Yio Chin Academic Building (LI), City University of Hong Kong, Tat Chee Avenue, Kowloon, Hong Kong');

-- --------------------------------------------------------

--
-- 資料表結構 `update_history`
--

CREATE TABLE `update_history` (
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

--
-- 觸發器 `update_history`
--
DELIMITER $$
CREATE TRIGGER `return data for reference` AFTER INSERT ON `update_history` FOR EACH ROW INSERT INTO delivery.order_ref (`order_no`, `delivery_ref_no`, `order_date`, `receive_package_date`, `total_weight_kg`, `total_delivery_price`, `in_charge_delivery_man`, `contact_tel`, `expected_delivery_date`, `actual_delivery_datetime`)SELECT order_no,delivery_ref_no,order_date,receive_package_date,total_weight_kg,total_delivery_price,in_charge_delivery_man,contact_tel,expected_delivery_date,actual_delivery_datetime FROM common.update_history WHERE order_no=(SELECT max(order_no) FROM common.update_history)
$$
DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
