/*
 Navicat Premium Data Transfer

 Source Server         : localhost
 Source Server Type    : MySQL
 Source Server Version : 80033
 Source Host           : localhost:3306
 Source Schema         : nopeople_gym

 Target Server Type    : MySQL
 Target Server Version : 80033
 File Encoding         : 65001

 Date: 18/06/2025 16:04:35
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for access_devices
-- ----------------------------
DROP TABLE IF EXISTS `access_devices`;
CREATE TABLE `access_devices`  (
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `location` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `ip_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `mac_address` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` enum('online','offline','maintenance') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'online',
  `last_heartbeat` datetime NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`device_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '门禁设备' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of access_devices
-- ----------------------------
INSERT INTO `access_devices` VALUES ('37607b9d-4898-47e3-9c62-257fef5fe8d7', '入口门禁1号', '健身房A门', '192.168.1.10', 'AA:BB:CC:DD:EE:01', 'online', '2025-05-09 12:40:58', '2025-05-09 12:40:58', '2025-05-09 12:40:58');
INSERT INTO `access_devices` VALUES ('bbf8fd67-78af-4760-998b-638ba0d65735', '出口门禁1号', '健身房A出口', '192.168.1.11', 'AA:BB:CC:DD:EE:02', 'online', '2025-05-09 12:40:58', '2025-05-09 12:40:58', '2025-05-09 12:40:58');

-- ----------------------------
-- Table structure for access_records
-- ----------------------------
DROP TABLE IF EXISTS `access_records`;
CREATE TABLE `access_records`  (
  `record_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `device_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_type` enum('entry','exit') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `access_time` datetime NOT NULL,
  `access_method` enum('qr_code','face_recognition','nfc') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `temperature` decimal(4, 1) NULL DEFAULT NULL COMMENT '体温检测',
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '抓拍图片URL',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`record_id`) USING BTREE,
  INDEX `device_id`(`device_id` ASC) USING BTREE,
  INDEX `idx_user_access`(`user_id` ASC, `access_time` ASC) USING BTREE,
  INDEX `idx_time_method`(`access_time` ASC, `access_method` ASC) USING BTREE,
  CONSTRAINT `access_records_ibfk_2` FOREIGN KEY (`device_id`) REFERENCES `access_devices` (`device_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '进出记录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of access_records
-- ----------------------------
INSERT INTO `access_records` VALUES ('35c04a9f-ab43-4b9a-bd4e-2ad8f9708de7', '976ffc85-9891-4ef2-825e-1fda24475a3f', '37607b9d-4898-47e3-9c62-257fef5fe8d7', 'exit', '2025-06-05 08:48:34', 'qr_code', NULL, NULL, '2025-06-05 08:48:34');
INSERT INTO `access_records` VALUES ('75eeda9e-ef45-48fd-87c2-118b7879c5e9', 'e25e4d76-efbf-4350-b508-c974fef82acc', '37607b9d-4898-47e3-9c62-257fef5fe8d7', 'exit', '2025-06-05 04:47:40', 'qr_code', NULL, NULL, '2025-06-05 04:47:40');
INSERT INTO `access_records` VALUES ('95bd6e71-0537-400c-8889-d7fec110fb6f', 'e25e4d76-efbf-4350-b508-c974fef82acc', '37607b9d-4898-47e3-9c62-257fef5fe8d7', 'entry', '2025-06-05 04:47:28', 'qr_code', NULL, NULL, '2025-06-05 04:47:28');
INSERT INTO `access_records` VALUES ('be8237ab-a046-4f63-891b-416b918d3863', 'e25e4d76-efbf-4350-b508-c974fef82acc', '37607b9d-4898-47e3-9c62-257fef5fe8d7', 'entry', '2025-06-05 04:50:07', 'qr_code', NULL, NULL, '2025-06-05 04:50:06');
INSERT INTO `access_records` VALUES ('f2a89329-01ab-417e-ab91-60c215024942', '976ffc85-9891-4ef2-825e-1fda24475a3f', '37607b9d-4898-47e3-9c62-257fef5fe8d7', 'entry', '2025-06-05 08:30:02', 'qr_code', NULL, NULL, '2025-06-05 08:30:02');

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码(加密存储)',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL,
  `role` enum('super','normal') CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'normal' COMMENT '角色类型',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT '状态(1:启用,0:禁用)',
  `last_login` datetime NULL DEFAULT NULL COMMENT '最后登录时间',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  INDEX `idx_admin_username`(`username` ASC) USING BTREE,
  INDEX `idx_admin_phone`(`phone` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '管理员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES (1, '黄佳茗', 'asdf', '黄佳茗', '13426899611', 'normal', 1, '2025-04-22 14:51:31', '2025-04-22 15:10:32', '2025-04-22 15:10:32');
INSERT INTO `admin` VALUES (2, '韦韦', 'asdf', '韦韦', '13425111926', 'normal', 1, NULL, '2025-06-04 17:03:43', '2025-06-04 17:03:43');
INSERT INTO `admin` VALUES (3, 'admin', '123456', 'admin', '13438928948', 'normal', 1, NULL, '2025-06-17 15:14:05', '2025-06-17 15:14:13');

-- ----------------------------
-- Table structure for membership_types
-- ----------------------------
DROP TABLE IF EXISTS `membership_types`;
CREATE TABLE `membership_types`  (
  `type_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '会员卡类型名称',
  `duration_days` int NOT NULL COMMENT '有效期天数',
  `price` decimal(10, 2) NOT NULL COMMENT '价格',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '描述',
  `max_daily_usage` int NULL DEFAULT 1 COMMENT '每日最大使用次数',
  `is_active` tinyint(1) NULL DEFAULT 1 COMMENT '是否激活',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `original_price` decimal(10, 2) NULL DEFAULT NULL COMMENT '原价',
  `available_stores` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '适用门店ID列表，JSON数组形式，如 [\"store-001\", \"store-002\"]',
  `valid_start_offset` int NULL DEFAULT 1 COMMENT '购卡后第几天起可用（1表示次日可用）',
  `valid_duration_type` enum('days','times') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'days' COMMENT '有效期类型：天数或次数',
  `per_use_duration_minutes` int NULL DEFAULT 1440 COMMENT '单次可用时长（分钟）',
  `available_time` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '00:00-24:00' COMMENT '每天可用时间段，如 09:00-21:00',
  PRIMARY KEY (`type_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员卡类型表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of membership_types
-- ----------------------------
INSERT INTO `membership_types` VALUES ('type001', '单次体验卡', 1, 29.90, '单次体验，24小时内有效', 1, 1, '2025-04-12 15:31:40', '2025-06-05 01:14:00', 30.00, '[1,2]', 1, 'days', 1440, '00:00-24:00');
INSERT INTO `membership_types` VALUES ('type002', '月卡', 30, 299.00, '月卡会员，30天内无限次使用', 99, 1, '2025-04-12 15:31:40', '2025-06-04 23:55:47', 350.00, NULL, 1, 'days', 1440, '00:00-24:00');
INSERT INTO `membership_types` VALUES ('type003', '季卡', 90, 799.00, '季卡会员，90天内无限次使用', 99, 1, '2025-04-12 15:31:40', '2025-06-04 23:55:56', 800.00, NULL, 1, 'days', 1440, '00:00-24:00');
INSERT INTO `membership_types` VALUES ('type004', '年卡', 365, 2599.00, '年卡会员，365天内无限次使用', 99, 1, '2025-04-12 15:31:40', '2025-06-04 23:56:04', 2600.00, NULL, 1, 'days', 1440, '00:00-24:00');
INSERT INTO `membership_types` VALUES ('type005', '10次卡', 180, 499.00, '半年内可使用10次', 1, 1, '2025-04-12 15:31:40', '2025-06-04 23:56:13', 500.00, NULL, 1, 'days', 1440, '00:00-24:00');

-- ----------------------------
-- Table structure for payment_orders
-- ----------------------------
DROP TABLE IF EXISTS `payment_orders`;
CREATE TABLE `payment_orders`  (
  `order_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `order_number` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `amount` decimal(10, 2) NOT NULL,
  `payment_method` enum('wechat','alipay','unionpay','balance') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payment_status` enum('pending','paid','refunded','failed') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT 'pending',
  `transaction_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '第三方支付交易号',
  `payment_time` datetime NULL DEFAULT NULL,
  `order_description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `membership_type_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '关联的会员卡类型',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`order_id`) USING BTREE,
  UNIQUE INDEX `order_number`(`order_number` ASC) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `membership_type_id`(`membership_type_id` ASC) USING BTREE,
  INDEX `idx_order_number`(`order_number` ASC) USING BTREE,
  INDEX `idx_payment_status`(`payment_status` ASC) USING BTREE,
  INDEX `idx_payment_time`(`payment_time` ASC) USING BTREE,
  CONSTRAINT `payment_orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `payment_orders_ibfk_2` FOREIGN KEY (`membership_type_id`) REFERENCES `membership_types` (`type_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '支付订单' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of payment_orders
-- ----------------------------
INSERT INTO `payment_orders` VALUES ('3cbc5416-c5f4-453c-b2ec-ecefea0e8e15', '976ffc85-9891-4ef2-825e-1fda24475a3f', 'ORD1749083004868', 29.90, 'wechat', 'paid', 'TXN1749083004868', '2025-06-05 08:23:25', '购买 单次体验卡', 'type001', '2025-06-05 08:23:24', '2025-06-05 08:23:24');
INSERT INTO `payment_orders` VALUES ('4dc9ebf3-3900-4863-b591-5bc48e523f83', '976ffc85-9891-4ef2-825e-1fda24475a3f', 'ORD1749082961922', 29.90, 'wechat', 'paid', 'TXN1749082961922', '2025-06-05 08:22:42', '购买 单次体验卡', 'type001', '2025-06-05 08:22:41', '2025-06-05 08:22:41');
INSERT INTO `payment_orders` VALUES ('641962b1-582b-4864-a5fe-10d86006d2a8', '976ffc85-9891-4ef2-825e-1fda24475a3f', 'ORD1749082479852', 29.90, 'wechat', 'paid', 'TXN1749082479852', '2025-06-05 08:14:40', '购买 单次体验卡', 'type001', '2025-06-05 08:14:39', '2025-06-05 08:14:39');
INSERT INTO `payment_orders` VALUES ('76b81a8a-7d3d-4c2b-ba12-0a943d6c0b0c', '976ffc85-9891-4ef2-825e-1fda24475a3f', 'ORD1749083367185', 29.90, 'wechat', 'paid', 'TXN1749083367185', '2025-06-05 08:29:27', '购买 单次体验卡', 'type001', '2025-06-05 08:29:27', '2025-06-05 08:29:27');
INSERT INTO `payment_orders` VALUES ('a2e927f3-ccd3-44aa-9960-4b62fa444819', '976ffc85-9891-4ef2-825e-1fda24475a3f', 'ORD1749084476007', 29.90, 'wechat', 'paid', 'TXN1749084476007', '2025-06-05 08:47:56', '购买 单次体验卡', 'type001', '2025-06-05 08:47:56', '2025-06-05 08:47:56');
INSERT INTO `payment_orders` VALUES ('e3566645-7250-4ab4-b4f5-6bf79c1db00d', '976ffc85-9891-4ef2-825e-1fda24475a3f', 'ORD1749082698370', 299.00, 'wechat', 'paid', 'TXN1749082698370', '2025-06-05 08:18:18', '购买 月卡', 'type002', '2025-06-05 08:18:18', '2025-06-05 08:18:18');

-- ----------------------------
-- Table structure for security_monitoring
-- ----------------------------
DROP TABLE IF EXISTS `security_monitoring`;
CREATE TABLE `security_monitoring`  (
  `monitor_id` bigint NOT NULL AUTO_INCREMENT,
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `event_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `handled_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `status` tinyint NULL DEFAULT 0,
  PRIMARY KEY (`monitor_id`) USING BTREE,
  INDEX `device_id`(`device_id` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '警告申报' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of security_monitoring
-- ----------------------------
INSERT INTO `security_monitoring` VALUES (2, '37607b9d-4898-47e3-9c62-257fef5fe8d7', 'motion', '/img/motion1.jpg', '管理员A', '夜间检测到异常活动', '2025-05-09 12:40:58', 1);
INSERT INTO `security_monitoring` VALUES (3, '2', '设别故障', 'https://picsum.photos/600/400', NULL, 'cs', '2025-06-04 19:30:31', 0);
INSERT INTO `security_monitoring` VALUES (4, '33', '设别故障', 'https://picsum.photos/600/400', NULL, '的', '2025-06-04 19:46:35', 0);
INSERT INTO `security_monitoring` VALUES (5, '33', '设别故障', 'https://picsum.photos/600/400', NULL, '的', '2025-06-04 19:50:55', 0);

-- ----------------------------
-- Table structure for stores
-- ----------------------------
DROP TABLE IF EXISTS `stores`;
CREATE TABLE `stores`  (
  `store_id` int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '门店ID，主键，自增',
  `store_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '门店名称',
  `latitude` decimal(10, 7) NOT NULL COMMENT '门店纬度，用于计算距离',
  `longitude` decimal(10, 7) NOT NULL COMMENT '门店经度，用于计算距离',
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '门店详细地址',
  `current_people` int UNSIGNED NOT NULL DEFAULT 0 COMMENT '当前门店人数',
  `main_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '门店主图URL',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '门店联系电话',
  `business_hours` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '营业时间，字符串格式，例如：09:00-21:00',
  `map_image` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '门店地图图片URL',
  `store_status` tinyint NOT NULL DEFAULT 1 COMMENT '门店状态（0：休息，1：营业，2：装修）',
  `store_manager` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NULL DEFAULT NULL COMMENT '门店店长姓名',
  `store_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '门店编号',
  `equipment_types` int NULL DEFAULT 0 COMMENT '设备种类数',
  PRIMARY KEY (`store_id`) USING BTREE,
  UNIQUE INDEX `store_code`(`store_code` ASC) USING BTREE,
  INDEX `idx_store_name`(`store_name` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_0900_ai_ci COMMENT = '门店信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of stores
-- ----------------------------
INSERT INTO `stores` VALUES (1, '电科大中山学院店', 22.5227000, 113.3926000, '广东省中山市石岐区学院路1号龙凤楼2楼', 26, 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_1.png', '18033092080', '周一至周日 00:00 - 24:00', 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png', 1, NULL, 'store-001', 13);
INSERT INTO `stores` VALUES (2, '利和广场店', 22.5227000, 113.3926000, '广东省中山市东区中山三路16号利和广场5楼', 48, 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_2.png', '18923356789', '周一至周日 09:00 - 22:00', 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png', 1, NULL, 'store-002', 15);
INSERT INTO `stores` VALUES (3, '大信新都汇店', 22.5227000, 113.3926000, '广东省中山市石岐区莲塘北路18号大信新都汇B座3楼', 32, 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_3.png', '13560678901', '周一至周日 10:00 - 21:30', 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png', 1, NULL, 'store-003', 12);
INSERT INTO `stores` VALUES (4, '小榄百汇时代店', 22.5227000, 113.3926000, '广东省中山市小榄镇升平中路10号百汇时代广场4楼', 56, 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_4.png', '18676012345', '周一至周日 08:30 - 23:00', 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png', 1, NULL, 'store-004', 18);
INSERT INTO `stores` VALUES (5, '古镇华艺广场店', 22.5227000, 113.3926000, '广东省中山市古镇镇中兴大道南1号华艺广场6楼', 19, 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_5.png', '13825934567', '周一至周日 09:30 - 22:30', 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png', 1, NULL, 'store-005', 10);
INSERT INTO `stores` VALUES (6, '三乡顺昌广场店', 22.5227000, 113.3926000, '广东省中山市三乡镇文昌东路10号顺昌广场3楼', 38, 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_1.png', '15918234567', '周一至周日 00:00 - 24:00', 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/stores/store_map.png', 1, NULL, 'store-006', 14);

-- ----------------------------
-- Table structure for user_feedbacks
-- ----------------------------
DROP TABLE IF EXISTS `user_feedbacks`;
CREATE TABLE `user_feedbacks`  (
  `feedback_id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `feedback_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `images` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `contact_phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `response` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`feedback_id`) USING BTREE,
  INDEX `user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_feedback_status`(`status` ASC) USING BTREE,
  CONSTRAINT `user_feedbacks_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户反馈表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_feedbacks
-- ----------------------------
INSERT INTO `user_feedbacks` VALUES (10, '976ffc85-9891-4ef2-825e-1fda24475a3f', 'suggestion', '建议增加网球场和课程', 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/feedbacks/tennis.jpg', '13800001111', 'pending', '', '2025-06-17 15:44:07', '2025-06-17 15:44:07');
INSERT INTO `user_feedbacks` VALUES (11, '9ca95e46-c787-472e-94a3-232158c983ee', 'complaint', '瑜伽球经常漏气，请及时更换', 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/feedbacks/yoga_ball.jpg', '13800001112', 'processing', '已提交设备部处理', '2025-06-17 15:44:07', '2025-06-17 15:44:07');
INSERT INTO `user_feedbacks` VALUES (12, 'eda92873-7030-46ac-9ea3-703e4444df7a', 'suggestion', '建议增加更多哑铃重量档位', 'https://cdn.jsdelivr.net/gh/Luoevanescence/static/nopeople-gym/static/feedbacks/dumbbell.jpg', '13800001113', 'done', '已采购新设备，即将上架', '2025-06-17 15:44:07', '2025-06-17 15:44:07');

-- ----------------------------
-- Table structure for user_memberships
-- ----------------------------
DROP TABLE IF EXISTS `user_memberships`;
CREATE TABLE `user_memberships`  (
  `membership_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `type_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `remaining_times` int NULL DEFAULT NULL COMMENT '次卡剩余次数，NULL表示不限次',
  `is_active` tinyint(1) NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`membership_id`) USING BTREE,
  INDEX `type_id`(`type_id` ASC) USING BTREE,
  INDEX `idx_user_active`(`user_id` ASC, `is_active` ASC) USING BTREE,
  INDEX `idx_end_date`(`end_date` ASC) USING BTREE,
  CONSTRAINT `user_memberships_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_memberships_ibfk_2` FOREIGN KEY (`type_id`) REFERENCES `membership_types` (`type_id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '会员记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_memberships
-- ----------------------------
INSERT INTO `user_memberships` VALUES ('9882864e-1eac-48d5-83aa-8de8d1690dd9', '9ca95e46-c787-472e-94a3-232158c983ee', 'type002', '2025-05-09 12:40:58', '2025-12-31 23:59:59', NULL, 1, '2025-05-09 12:40:58', '2025-05-09 12:40:58');
INSERT INTO `user_memberships` VALUES ('da00e9c2-087f-4f89-a7de-b9d4f5c134cb', 'eda92873-7030-46ac-9ea3-703e4444df7a', 'type001', '2025-05-09 12:40:58', '2025-12-31 23:59:59', 1, 1, '2025-05-09 12:40:58', '2025-05-09 12:40:58');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users`  (
  `user_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户名',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用于登录的唯一手机号',
  `password_hash` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '加密后的密码',
  `wechat_openid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '微信开放ID',
  `alipay_userid` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '支付宝用户ID',
  `id_card` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '身份证号',
  `avatar_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户头像URL',
  `gender` enum('male','female','other') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '性别',
  `birthday` date NULL DEFAULT NULL COMMENT '生日',
  `height` decimal(5, 2) NULL DEFAULT NULL COMMENT '身高(cm)',
  `weight` decimal(5, 2) NULL DEFAULT NULL COMMENT '体重(kg)',
  `health_status` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '健康状况备注',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `points` decimal(10, 2) NULL DEFAULT NULL COMMENT '积分',
  PRIMARY KEY (`user_id`) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  INDEX `idx_phone`(`phone` ASC) USING BTREE,
  INDEX `idx_wechat`(`wechat_openid` ASC) USING BTREE,
  INDEX `idx_alipay`(`alipay_userid` ASC) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('976ffc85-9891-4ef2-825e-1fda24475a3f', '微信用户111', '13426899611', NULL, 'osASN6-j-dxRLq_cmYgXwxWLts5Y', NULL, NULL, 'https://raw.githubusercontent.com/Luoevanescence/static/main/nopeople_gym/upload/avatarUrls/1750170001780_8HdMNoLjKFOH723cfe2099f5d736326f0b4cc006442a.jpg', 'male', NULL, 170.00, 60.00, NULL, '2025-06-05 08:11:51', '2025-06-17 22:20:04', 444.00);
INSERT INTO `users` VALUES ('9ca95e46-c787-472e-94a3-232158c983ee', '张三', '13800000011', 'hash123', 'wxid_zs001', 'ali_zs001', '110101199001010011', '/img/zs.jpg', 'male', '1990-01-01', 175.00, 70.00, '身体健康', '2025-05-09 12:40:58', '2025-06-05 03:15:37', 0.00);
INSERT INTO `users` VALUES ('eda92873-7030-46ac-9ea3-703e4444df7a', '李四', '13800000012', 'hash456', 'wxid_ls002', 'ali_ls002', '110101199202020022', '/img/ls.jpg', 'female', '1992-02-02', 162.00, 55.50, '轻微感冒', '2025-05-09 12:40:58', '2025-06-05 03:15:43', 0.00);

SET FOREIGN_KEY_CHECKS = 1;
