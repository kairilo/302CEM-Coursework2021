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
-- 資料庫： `onlineshop`
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
('001', 'ChanTM'),
('002', 'LeeCM'),
('003', 'CheungDM'),
('004', 'WongEM'),
('005', 'HoFM'),
('006', 'NgGM'),
('007', 'LoHM'),
('008', 'LamIM'),
('009', 'NganJM'),
('010', 'TamKM');

--
-- 觸發器 `login_info`
--
DELIMITER $$
CREATE TRIGGER `Insert Login Accounts` AFTER INSERT ON `login_info` FOR EACH ROW INSERT INTO common.login_info(username,password,type)
 SELECT username,password,'Shop' FROM onlineshop.login_info WHERE username=(SELECT max(username) FROM login_info)
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- 資料表結構 `order`
--

CREATE TABLE `order` (
  `order_no` char(6) NOT NULL,
  `order_date` date NOT NULL,
  `order_time` time NOT NULL,
  `product_id` varchar(6) NOT NULL,
  `product_name` varchar(50) NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` float(10,2) NOT NULL,
  `customer_name` varchar(50) NOT NULL,
  `customer_tel` char(8) NOT NULL,
  `customer_address` varchar(200) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- 傾印資料表的資料 `order`
--

INSERT INTO `order` (`order_no`, `order_date`, `order_time`, `product_id`, `product_name`, `quantity`, `price`, `customer_name`, `customer_tel`, `customer_address`) VALUES
('000001', '2021-02-01', '09:00:00', '07', 'Uni Kurutoga Advance 0.5', 1, 65.00, 'MRS. P', '12348765', '2410, 2/F, Li Dak Sum Yip Yio Chin Academic Building (LI), City University of Hong Kong, Tat Chee Avenue, Kowloon, Hong Kong');

--
-- 觸發器 `order`
--
DELIMITER $$
CREATE TRIGGER `insert info` AFTER INSERT ON `order` FOR EACH ROW INSERT INTO common.order_info (order_no,order_date,product_name,quantity,price,customer_name,customer_tel,customer_address)SELECT order_no,order_date,product_name,quantity,price,customer_name,customer_tel,customer_address FROM onlineshop.order WHERE order_no=(SELECT max(order_no) FROM onlineshop.order)
$$
DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
