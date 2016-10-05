SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for categories
-- ----------------------------
DROP TABLE IF EXISTS `categories`;
CREATE TABLE `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(400) COLLATE utf8_unicode_ci NOT NULL,
  `categoryType` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `urlid` varchar(400) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parentid` int(11) DEFAULT NULL,
  `description` varchar(5000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `defaultpublic` int(1) DEFAULT '0',
  `defaultadmin` int(1) DEFAULT '0',
  `sortorder` int(11) NOT NULL DEFAULT '0',
  `siteid` int(11) DEFAULT '1',
  `globalized` int(1) DEFAULT '0',
  `createdAt` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `deletedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES ('1', 'Public Videos', 'video', 'public-videos', null, 'Welcome to the videos', '1', '0', '2', '60', '0', '2014-11-17 11:10:38', '1', '2014-11-17 11:14:11', '1', null, null);
INSERT INTO `categories` VALUES ('2', 'CFWheels', 'video', 'cfwheels', '1', 'CFWheels Training Videos', '0', '0', '3', '60', '0', '2014-11-17 11:13:52', '1', '2014-11-17 11:14:11', '1', null, null);

-- ----------------------------
-- Table structure for emailoptouts
-- ----------------------------
DROP TABLE IF EXISTS `emailoptouts`;
CREATE TABLE `emailoptouts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of emailoptouts
-- ----------------------------

-- ----------------------------
-- Table structure for emails
-- ----------------------------
DROP TABLE IF EXISTS `emails`;
CREATE TABLE `emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(1255) DEFAULT NULL,
  `lastname` varchar(1255) DEFAULT NULL,
  `email` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of emails
-- ----------------------------

-- ----------------------------
-- Table structure for forms
-- ----------------------------
DROP TABLE IF EXISTS `forms`;
CREATE TABLE `forms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(1000) DEFAULT NULL,
  `siteid` int(11) DEFAULT NULL,
  `successcontent` text,
  `successembed` text,
  `failcontent` text,
  `failembed` text,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of forms
-- ----------------------------
INSERT INTO `forms` VALUES ('1', 'Contact', '60', 'Thanks for contacting us!', '<!-- google success conversion js here -->', 'Whoopsies there was an issue!', '<!-- google fail conversion js here -->', '2014-11-17 15:55:18', '1', '2014-11-17 15:55:18', '1', null, null, '0');

-- ----------------------------
-- Table structure for formsubmissions
-- ----------------------------
DROP TABLE IF EXISTS `formsubmissions`;
CREATE TABLE `formsubmissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `formid` int(11) DEFAULT NULL,
  `submission` text,
  `followup` text,
  `referrer` text,
  `entryPage` text,
  `fromPage` text,
  `isSpam` varchar(3000) DEFAULT NULL,
  `optin` int(11) DEFAULT NULL,
  `mobile` varchar(3000) DEFAULT NULL,
  `siteid` int(11) DEFAULT '1',
  `ip` text,
  `useragent` text,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` int(255) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `deletedBy` int(11) DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of formsubmissions
-- ----------------------------
INSERT INTO `formsubmissions` VALUES ('1', '1', null, null, '', '/', '', 'false', null, 'false', '60', '12.232.137.226', 'Mozilla/5.0 (Windows NT 6.3; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.71 Safari/537.36', '2014-12-10 14:21:49', '1', '2014-12-10 14:21:49', '1', null, null, '0');

-- ----------------------------
-- Table structure for forms_users
-- ----------------------------
DROP TABLE IF EXISTS `forms_users`;
CREATE TABLE `forms_users` (
  `formid` int(11) NOT NULL DEFAULT '1',
  `userid` int(11) NOT NULL,
  `type` varchar(255) NOT NULL DEFAULT 'to',
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`formid`,`userid`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of forms_users
-- ----------------------------
INSERT INTO `forms_users` VALUES ('1', '1', 'to', '2014-11-17 15:55:18', '1', '2014-11-17 15:55:18', '1');

-- ----------------------------
-- Table structure for logs
-- ----------------------------
DROP TABLE IF EXISTS `logs`;
CREATE TABLE `logs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` int(11) DEFAULT NULL,
  `modelid` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `savetype` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `model` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `controller` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `action` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `siteid` int(11) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `ip` varchar(800) COLLATE utf8_unicode_ci DEFAULT NULL,
  `useragent` varchar(800) COLLATE utf8_unicode_ci DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=175 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of logs
-- ----------------------------

-- ----------------------------
-- Table structure for majorcities
-- ----------------------------
DROP TABLE IF EXISTS `majorcities`;
CREATE TABLE `majorcities` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `state` varchar(255) DEFAULT NULL,
  `state_acronym` varchar(2) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `templateid` int(11) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `siteid` int(11) DEFAULT '1',
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=339 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of majorcities
-- ----------------------------
INSERT INTO `majorcities` VALUES ('9', 'Alabama', 'AL', 'Huntsville', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('8', 'Alabama', 'AL', 'Birmingham', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('10', 'Alabama', 'AL', 'Mobile', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('11', 'Alabama', 'AL', 'Montgomery', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('12', 'Alaska', 'AK', 'Anchorage', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('13', 'Arizona', 'AZ', 'Chandler', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('14', 'Arizona', 'AZ', 'Gilbert', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('15', 'Arizona', 'AZ', 'Glendale', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('16', 'Arizona', 'AZ', 'Mesa', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('17', 'Arizona', 'AZ', 'Peoria', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('18', 'Arizona', 'AZ', 'Phoenix', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('19', 'Arizona', 'AZ', 'Scottsdale', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('20', 'Arizona', 'AZ', 'Surprise', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('21', 'Arizona', 'AZ', 'Tempe', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('22', 'Arizona', 'AZ', 'Tucson', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('23', 'Arkansas', 'AR', 'Little Rock', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('24', 'California', 'CA', 'Anaheim', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('25', 'California', 'CA', 'Antioch', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('26', 'California', 'CA', 'Bakersfield', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('27', 'California', 'CA', 'Berkeley', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('28', 'California', 'CA', 'Burbank', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('29', 'California', 'CA', 'Carlsbad', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('30', 'California', 'CA', 'Chula Vista', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('31', 'California', 'CA', 'Concord', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('32', 'California', 'CA', 'Corona', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('33', 'California', 'CA', 'Costa Mesa', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('34', 'California', 'CA', 'Daly City', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('35', 'California', 'CA', 'Downey', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('36', 'California', 'CA', 'El Cajon', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('37', 'California', 'CA', 'El Monte', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('38', 'California', 'CA', 'Elk Grove', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('39', 'California', 'CA', 'Escondido', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('40', 'California', 'CA', 'Fairfield', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('41', 'California', 'CA', 'Fontana', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('42', 'California', 'CA', 'Fremont', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('43', 'California', 'CA', 'Fresno', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('44', 'California', 'CA', 'Fullerton', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('45', 'California', 'CA', 'Garden Grove', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('46', 'California', 'CA', 'Glendale', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('47', 'California', 'CA', 'Hayward', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('48', 'California', 'CA', 'Huntington Beach', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('49', 'California', 'CA', 'Inglewood', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('50', 'California', 'CA', 'Irvine', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('51', 'California', 'CA', 'Lancaster', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('52', 'California', 'CA', 'Long Beach', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('53', 'California', 'CA', 'Los Angeles', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('54', 'California', 'CA', 'Modesto', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('55', 'California', 'CA', 'Moreno Valley', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('56', 'California', 'CA', 'Murrieta', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('57', 'California', 'CA', 'Norwalk', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('58', 'California', 'CA', 'Oakland', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('59', 'California', 'CA', 'Oceanside', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('60', 'California', 'CA', 'Ontario', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('61', 'California', 'CA', 'Orange', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('62', 'California', 'CA', 'Oxnard', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('63', 'California', 'CA', 'Palmdale', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('64', 'California', 'CA', 'Pasadena', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('65', 'California', 'CA', 'Pomona', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('66', 'California', 'CA', 'Rancho Cucamonga', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('67', 'California', 'CA', 'Rialto', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('68', 'California', 'CA', 'Richmond', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('69', 'California', 'CA', 'Riverside', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('70', 'California', 'CA', 'Roseville', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('71', 'California', 'CA', 'Sacramento', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('72', 'California', 'CA', 'Salinas', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('73', 'California', 'CA', 'San Bernardino', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('74', 'California', 'CA', 'San Buenaventura', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('75', 'California', 'CA', 'San Diego', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('76', 'California', 'CA', 'San Francisco', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('77', 'California', 'CA', 'San Jose', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('78', 'California', 'CA', 'Santa Ana', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('79', 'California', 'CA', 'Santa Clara', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('80', 'California', 'CA', 'Santa Clarita', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('81', 'California', 'CA', 'Santa Maria', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('82', 'California', 'CA', 'Santa Rosa', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('83', 'California', 'CA', 'Simi Valley', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('84', 'California', 'CA', 'Stockton', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('85', 'California', 'CA', 'Sunnyvale', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('86', 'California', 'CA', 'Temecula', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('87', 'California', 'CA', 'Thousand Oaks', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('88', 'California', 'CA', 'Torrance', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('89', 'California', 'CA', 'Vallejo', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('90', 'California', 'CA', 'Victorville', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('91', 'California', 'CA', 'Visalia', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('92', 'California', 'CA', 'West Covina', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('93', 'Colorado', 'CO', 'Arvada', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('94', 'Colorado', 'CO', 'Aurora', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('95', 'Colorado', 'CO', 'Boulder', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('96', 'Colorado', 'CO', 'Centennial', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('97', 'Colorado', 'CO', 'Colorado Springs', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('98', 'Colorado', 'CO', 'Denver', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('99', 'Colorado', 'CO', 'Fort Collins', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('100', 'Colorado', 'CO', 'Lakewood', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('101', 'Colorado', 'CO', 'Pueblo', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('102', 'Colorado', 'CO', 'Thornton', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('103', 'Colorado', 'CO', 'Westminster', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('104', 'Connecticut', 'CT', 'Bridgeport', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('105', 'Connecticut', 'CT', 'Hartford', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('106', 'Connecticut', 'CT', 'New Haven', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('107', 'Connecticut', 'CT', 'Stamford', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('108', 'Connecticut', 'CT', 'Waterbury', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('109', 'District of Columbia', 'DC', 'Washington', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('110', 'Florida', 'FL', 'Cape Coral', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('111', 'Florida', 'FL', 'Clearwater', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('112', 'Florida', 'FL', 'Coral Springs', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('113', 'Florida', 'FL', 'Fort Lauderdale', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('114', 'Florida', 'FL', 'Gainesville', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('115', 'Florida', 'FL', 'Hialeah', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('116', 'Florida', 'FL', 'Hollywood', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('117', 'Florida', 'FL', 'Jacksonville', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('118', 'Florida', 'FL', 'Miami', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('119', 'Florida', 'FL', 'Miami Gardens', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('120', 'Florida', 'FL', 'Miramar', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('121', 'Florida', 'FL', 'Orlando', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('122', 'Florida', 'FL', 'Palm Bay', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('123', 'Florida', 'FL', 'Pembroke Pines', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('124', 'Florida', 'FL', 'Pompano Beach', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('125', 'Florida', 'FL', 'Port St Lucie', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('126', 'Florida', 'FL', 'St Petersburg', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('127', 'Florida', 'FL', 'Tallahassee', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('128', 'Florida', 'FL', 'Tampa', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('129', 'Florida', 'FL', 'West Palm Beach', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('130', 'Georgia', 'GA', 'Athens', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('131', 'Georgia', 'GA', 'Atlanta', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('132', 'Georgia', 'GA', 'Augusta', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('133', 'Georgia', 'GA', 'Columbus', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('134', 'Georgia', 'GA', 'Savannah', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('135', 'Hawaii', 'HI', 'Honolulu', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('136', 'Idaho', 'ID', 'Boise', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('137', 'Illinois', 'IL', 'Aurora', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('138', 'Illinois', 'IL', 'Chicago', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('139', 'Illinois', 'IL', 'Elgin', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('140', 'Illinois', 'IL', 'Joliet', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('141', 'Illinois', 'IL', 'Naperville', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('142', 'Illinois', 'IL', 'Peoria', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('143', 'Illinois', 'IL', 'Rockford', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('144', 'Illinois', 'IL', 'Springfield', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('145', 'Indiana', 'IN', 'Evansville', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('146', 'Indiana', 'IN', 'Fort Wayne', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('147', 'Indiana', 'IN', 'Indianapolis', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('148', 'Indiana', 'IN', 'South Bend', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('149', 'Iowa', 'IA', 'Cedar Rapids', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('150', 'Iowa', 'IA', 'Davenport', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('151', 'Iowa', 'IA', 'Des Moines', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('152', 'Kansas', 'KS', 'Kansas City', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('153', 'Kansas', 'KS', 'Olathe', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('154', 'Kansas', 'KS', 'Overland Park', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('155', 'Kansas', 'KS', 'Topeka', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('156', 'Kansas', 'KS', 'Wichita', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('157', 'Kentucky', 'KY', 'Lexington', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('158', 'Kentucky', 'KY', 'Louisville', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('159', 'Louisiana', 'LA', 'Baton Rouge', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('160', 'Louisiana', 'LA', 'Lafayette', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('161', 'Louisiana', 'LA', 'New Orleans', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('162', 'Louisiana', 'LA', 'Shreveport', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('163', 'Maryland', 'MD', 'Baltimore', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('164', 'Massachusetts', 'MA', 'Boston', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('165', 'Massachusetts', 'MA', 'Cambridge', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('166', 'Massachusetts', 'MA', 'Lowell', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('167', 'Massachusetts', 'MA', 'Springfield', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('168', 'Massachusetts', 'MA', 'Worcester', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('169', 'Michigan', 'MI', 'Ann Arbor', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('170', 'Michigan', 'MI', 'Detroit', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('171', 'Michigan', 'MI', 'Flint', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('172', 'Michigan', 'MI', 'Grand Rapids', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('173', 'Michigan', 'MI', 'Lansing', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('174', 'Michigan', 'MI', 'Sterling Heights', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('175', 'Michigan', 'MI', 'Warren', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('176', 'Minnesota', 'MN', 'Minneapolis', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('177', 'Minnesota', 'MN', 'Rochester', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('178', 'Minnesota', 'MN', 'Saint Paul', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('179', 'Mississippi', 'MS', 'Jackson', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('180', 'Missouri', 'MO', 'Columbia', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('181', 'Missouri', 'MO', 'Independence', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('182', 'Missouri', 'MO', 'Kansas City', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('183', 'Missouri', 'MO', 'Springfield', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('184', 'Missouri', 'MO', 'St Louis', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('185', 'Montana', 'MT', 'Billings', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('186', 'Nebraska', 'NE', 'Lincoln', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('187', 'Nebraska', 'NE', 'Omaha', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('188', 'Nevada', 'NV', 'Henderson', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('189', 'Nevada', 'NV', 'Las Vegas', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('190', 'Nevada', 'NV', 'North Las Vegas', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('191', 'Nevada', 'NV', 'Reno', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('192', 'New Hampshire', 'NH', 'Manchester', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('193', 'New Jersey', 'NJ', 'Elizabeth', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('194', 'New Jersey', 'NJ', 'Jersey City', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('195', 'New Jersey', 'NJ', 'Newark', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('196', 'New Jersey', 'NJ', 'Paterson', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('197', 'New Mexico', 'NM', 'Albuquerque', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('198', 'New Mexico', 'NM', 'Las Cruces', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('199', 'New York', 'NY', 'Buffalo', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('200', 'New York', 'NY', 'Rochester', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('201', 'New York', 'NY', 'Syracuse', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('202', 'New York', 'NY', 'Yonkers', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('203', 'North Carolina', 'NC', 'Cary', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('204', 'North Carolina', 'NC', 'Charlotte', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('205', 'North Carolina', 'NC', 'Durham', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('206', 'North Carolina', 'NC', 'Fayetteville', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('207', 'North Carolina', 'NC', 'Greensboro', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('208', 'North Carolina', 'NC', 'High Point', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('209', 'North Carolina', 'NC', 'Raleigh', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('210', 'North Carolina', 'NC', 'Wilmington', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('211', 'North Carolina', 'NC', 'Winston Salem', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('212', 'North Dakota', 'ND', 'Fargo', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('213', 'Ohio', 'OH', 'Akron', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('214', 'Ohio', 'OH', 'Cincinnati', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('215', 'Ohio', 'OH', 'Cleveland', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('216', 'Ohio', 'OH', 'Columbus', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('217', 'Ohio', 'OH', 'Dayton', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('218', 'Ohio', 'OH', 'Toledo', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('219', 'Oklahoma', 'OK', 'Broken Arrow', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('220', 'Oklahoma', 'OK', 'Norman', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('221', 'Oklahoma', 'OK', 'Oklahoma City', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('222', 'Oklahoma', 'OK', 'Tulsa', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('223', 'Oregon', 'OR', 'Eugene', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('224', 'Oregon', 'OR', 'Gresham', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('225', 'Oregon', 'OR', 'Portland', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('226', 'Oregon', 'OR', 'Salem', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('227', 'Pennsylvania', 'PA', 'Allentown', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('228', 'Pennsylvania', 'PA', 'Erie', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('229', 'Pennsylvania', 'PA', 'Philadelphia', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('230', 'Pennsylvania', 'PA', 'Pittsburgh', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('231', 'Rhode Island', 'RI', 'Providence', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('232', 'South Carolina', 'SC', 'Charleston', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('233', 'South Carolina', 'SC', 'Columbia', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('234', 'South Carolina', 'SC', 'North Charleston', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('235', 'South Dakota', 'SD', 'Sioux Falls', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('236', 'Tennessee', 'TN', 'Chattanooga', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('237', 'Tennessee', 'TN', 'Clarksville', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('238', 'Tennessee', 'TN', 'Knoxville', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('239', 'Tennessee', 'TN', 'Memphis', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('240', 'Tennessee', 'TN', 'Murfreesboro', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('241', 'Tennessee', 'TN', 'Nashville', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('242', 'Texas', 'TX', 'Abilene', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('243', 'Texas', 'TX', 'Amarillo', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('244', 'Texas', 'TX', 'Arlington', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('245', 'Texas', 'TX', 'Austin', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('246', 'Texas', 'TX', 'Beaumont', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('247', 'Texas', 'TX', 'Brownsville', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('248', 'Texas', 'TX', 'Carrollton', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('249', 'Texas', 'TX', 'Corpus Christi', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('250', 'Texas', 'TX', 'Dallas', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('251', 'Texas', 'TX', 'Denton', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('252', 'Texas', 'TX', 'El Paso', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('253', 'Texas', 'TX', 'Fort Worth', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('254', 'Texas', 'TX', 'Frisco', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('255', 'Texas', 'TX', 'Garland', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('256', 'Texas', 'TX', 'Grand Prairie', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('257', 'Texas', 'TX', 'Houston', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('258', 'Texas', 'TX', 'Irving', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('259', 'Texas', 'TX', 'Killeen', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('260', 'Texas', 'TX', 'Laredo', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('261', 'Texas', 'TX', 'Lubbock', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('262', 'Texas', 'TX', 'McAllen', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('263', 'Texas', 'TX', 'McKinney', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('264', 'Texas', 'TX', 'Mesquite', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('265', 'Texas', 'TX', 'Midland', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('266', 'Texas', 'TX', 'Odessa', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('267', 'Texas', 'TX', 'Pasadena', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('268', 'Texas', 'TX', 'Plano', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('269', 'Texas', 'TX', 'Richardson', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('270', 'Texas', 'TX', 'Round Rock', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('271', 'Texas', 'TX', 'San Antonio', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('272', 'Texas', 'TX', 'Waco', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('273', 'Texas', 'TX', 'Wichita Falls', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('274', 'Utah', 'UT', 'Provo', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('275', 'Utah', 'UT', 'Salt Lake City', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('276', 'Utah', 'UT', 'West Jordan', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('277', 'Utah', 'UT', 'West Valley City', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('278', 'Virginia', 'VA', 'Alexandria', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('279', 'Virginia', 'VA', 'Chesapeake', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('280', 'Virginia', 'VA', 'Hampton', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('281', 'Virginia', 'VA', 'Newport News', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('282', 'Virginia', 'VA', 'Norfolk', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('283', 'Virginia', 'VA', 'Richmond', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('284', 'Virginia', 'VA', 'Virginia Beach', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('285', 'Washington', 'WA', 'Bellevue', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('286', 'Washington', 'WA', 'Everett', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('287', 'Washington', 'WA', 'Kent', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('288', 'Washington', 'WA', 'Seattle', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('289', 'Washington', 'WA', 'Spokane', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('290', 'Washington', 'WA', 'Tacoma', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('291', 'Washington', 'WA', 'Vancouver', '4', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('292', 'Wisconsin', 'WI', 'Green Bay', '5', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('293', 'Wisconsin', 'WI', 'Kenosha', '1', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('294', 'Wisconsin', 'WI', 'Madison', '2', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('295', 'Wisconsin', 'WI', 'Milwaukee', '3', 'city', '1', '0');
INSERT INTO `majorcities` VALUES ('296', 'Arkansas', 'AR', null, '1', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('297', 'California', 'CA', null, '2', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('298', 'Colorado', 'CO', null, '1', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('299', 'Connecticut', 'CT', null, '2', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('300', 'District of Columbia', 'DC', null, '2', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('301', 'Florida', 'FL', null, '3', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('302', 'Georgia', 'GA', null, '3', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('303', 'Hawaii', 'HI', null, '3', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('304', 'Idaho', 'ID', null, '4', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('305', 'Illinois', 'IL', null, '5', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('306', 'Indiana', 'IN', null, '3', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('307', 'Iowa', 'IA', null, '2', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('308', 'Kansas', 'KS', null, '5', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('309', 'Kentucky', 'KY', null, '5', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('310', 'Louisiana', 'LA', null, '2', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('311', 'Maryland', 'MD', null, '1', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('312', 'Massachusetts', 'MA', null, '2', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('313', 'Michigan', 'MI', null, '2', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('314', 'Minnesota', 'MN', null, '4', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('315', 'Mississippi', 'MS', null, '2', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('316', 'Missouri', 'MO', null, '3', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('317', 'Montana', 'MT', null, '3', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('318', 'Nebraska', 'NE', null, '4', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('319', 'Nevada', 'NV', null, '1', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('320', 'New Hampshire', 'NH', null, '5', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('321', 'New Jersey', 'NJ', null, '1', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('322', 'New Mexico', 'NM', null, '5', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('323', 'New York', 'NY', null, '2', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('324', 'North Carolina', 'NC', null, '1', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('325', 'North Dakota', 'ND', null, '5', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('326', 'Ohio', 'OH', null, '1', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('327', 'Oklahoma', 'OK', null, '2', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('328', 'Oregon', 'OR', null, '1', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('329', 'Pennsylvania', 'PA', null, '5', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('330', 'Rhode Island', 'RI', null, '4', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('331', 'South Carolina', 'SC', null, '5', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('332', 'South Dakota', 'SD', null, '3', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('333', 'Tennessee', 'TN', null, '4', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('334', 'Texas', 'TX', null, '5', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('335', 'Utah', 'UT', null, '2', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('336', 'Virginia', 'VA', null, '1', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('337', 'Washington', 'WA', null, '3', 'state', '1', '0');
INSERT INTO `majorcities` VALUES ('338', 'Wisconsin', 'WI', null, '5', 'state', '1', '0');

-- ----------------------------
-- Table structure for menus
-- ----------------------------
DROP TABLE IF EXISTS `menus`;
CREATE TABLE `menus` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(400) COLLATE utf8_unicode_ci NOT NULL,
  `itemType` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `itemId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `customUrl` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `menuid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `parentid` int(11) DEFAULT '0',
  `description` varchar(5000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sortorder` int(11) NOT NULL DEFAULT '0',
  `siteid` int(11) DEFAULT '1',
  `createdAt` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `deletedBy` int(11) DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of menus
-- ----------------------------
INSERT INTO `menus` VALUES ('1', 'Blog', 'custom', null, '/blog', 'Primary', '0', null, '3', '60', '2014-11-17 11:07:03', '1', '2014-11-17 15:59:34', '1', null, null, '0');
INSERT INTO `menus` VALUES ('2', 'Videos', 'custom', null, '/videos', 'Primary', '0', null, '2', '60', '2014-11-17 11:09:59', '1', '2014-11-17 15:59:34', '1', null, null, '0');
INSERT INTO `menus` VALUES ('3', 'Contact', 'custom', null, '/p/pforms/show/1', 'Primary', '0', null, '5', '60', '2014-11-17 15:59:18', '1', '2014-11-17 16:00:53', '1', null, null, '0');
INSERT INTO `menus` VALUES ('4', 'Login', 'custom', null, '/manager', 'Primary', '0', null, '4', '60', '2014-11-17 16:00:41', '1', '2014-11-17 16:00:53', '1', null, null, '0');

-- ----------------------------
-- Table structure for metadata
-- ----------------------------
DROP TABLE IF EXISTS `metadata`;
CREATE TABLE `metadata` (
  `foreignid` int(11) NOT NULL,
  `metafieldid` int(11) NOT NULL,
  `fielddata` text,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`foreignid`,`metafieldid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of metadata
-- ----------------------------
INSERT INTO `metadata` VALUES ('1', '1', 'test', '2014-12-10 14:21:49', '1', '2014-12-10 14:21:49', '1', null, null);
INSERT INTO `metadata` VALUES ('1', '2', 'test', '2014-12-10 14:21:49', '1', '2014-12-10 14:21:49', '1', null, null);
INSERT INTO `metadata` VALUES ('1', '3', 'test', '2014-12-10 14:21:49', '1', '2014-12-10 14:21:49', '1', null, null);

-- ----------------------------
-- Table structure for metafields
-- ----------------------------
DROP TABLE IF EXISTS `metafields`;
CREATE TABLE `metafields` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `metafieldType` varchar(255) DEFAULT NULL,
  `modelid` int(11) DEFAULT NULL,
  `name` varchar(500) DEFAULT NULL,
  `type` varchar(500) DEFAULT NULL,
  `contentblock` text,
  `wysiwyg` int(1) DEFAULT '0',
  `fieldvalues` text,
  `class` text,
  `checked` int(1) DEFAULT '0',
  `divwrap` int(1) DEFAULT NULL,
  `divclass` text,
  `labelplacement` varchar(255) DEFAULT 'before',
  `prepend` text,
  `append` text,
  `styleattribute` text,
  `identifier` varchar(500) DEFAULT NULL,
  `sortorder` int(11) DEFAULT '9999',
  `siteid` int(11) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of metafields
-- ----------------------------
INSERT INTO `metafields` VALUES ('1', 'formfield', '1', 'Your Name', 'text', null, '0', null, null, '0', '0', null, 'before', null, null, null, 'name', '1', '60', '2014-11-17 15:55:44', '1', '2014-11-17 15:58:08', '1', null, null, '0');
INSERT INTO `metafields` VALUES ('2', 'formfield', '1', 'Your Email', 'text', null, '0', null, null, '0', '0', null, 'before', null, null, null, 'email', '2', '60', '2014-11-17 15:56:06', '1', '2014-11-17 15:58:08', '1', null, null, '0');
INSERT INTO `metafields` VALUES ('3', 'formfield', '1', 'Your Message', 'textarea', null, '0', null, null, '0', '0', null, 'before', null, null, null, 'message', '3', '60', '2014-11-17 15:56:25', '1', '2014-11-17 15:58:08', '1', null, null, '0');
INSERT INTO `metafields` VALUES ('4', 'formfield', '1', 'Send', 'submit', null, '0', null, 'btn btn-md btn-primary', '0', '0', null, 'before', null, null, null, null, '4', '60', '2014-11-17 15:56:53', '1', '2014-11-17 15:58:08', '1', null, null, '0');
INSERT INTO `metafields` VALUES ('5', 'formfield', '1', 'Contact Us', 'headline', null, '0', null, null, '0', '0', null, 'before', null, null, null, 'Contact Us', '0', '60', '2014-11-17 15:57:40', '1', '2014-11-17 15:58:08', '1', null, null, '0');

-- ----------------------------
-- Table structure for newsletters
-- ----------------------------
DROP TABLE IF EXISTS `newsletters`;
CREATE TABLE `newsletters` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `subject` varchar(255) DEFAULT NULL,
  `status` varchar(255) DEFAULT 'draft',
  `siteid` int(11) DEFAULT '1',
  `createdby` int(11) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of newsletters
-- ----------------------------

-- ----------------------------
-- Table structure for newsletter_sections
-- ----------------------------
DROP TABLE IF EXISTS `newsletter_sections`;
CREATE TABLE `newsletter_sections` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `newsletterid` int(11) DEFAULT NULL,
  `title` varchar(1000) DEFAULT NULL,
  `content` text,
  `status` varchar(255) DEFAULT 'draft',
  `siteid` int(11) DEFAULT '1',
  `createdby` int(11) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of newsletter_sections
-- ----------------------------

-- ----------------------------
-- Table structure for notfounds
-- ----------------------------
DROP TABLE IF EXISTS `notfounds`;
CREATE TABLE `notfounds` (
  `urlPath` varchar(330) NOT NULL,
  `referrer` varchar(2255) DEFAULT NULL,
  `occurences` int(11) DEFAULT '0',
  `siteid` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`urlPath`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of notfounds
-- ----------------------------

-- ----------------------------
-- Table structure for options
-- ----------------------------
DROP TABLE IF EXISTS `options`;
CREATE TABLE `options` (
  `id` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `siteid` int(11) NOT NULL,
  `label` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` varchar(5000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attachment` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inputlabel` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inputtype` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `editContent` int(1) NOT NULL DEFAULT '0',
  `editLabel` int(1) NOT NULL DEFAULT '0',
  `editAttachment` int(1) NOT NULL DEFAULT '0',
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`,`siteid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of options
-- ----------------------------
INSERT INTO `options` VALUES ('home_id', '0', null, null, null, '', '', '0', '0', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('home_id', '60', null, '1', null, null, null, '0', '0', '0', null, null, '2014-11-17 11:09:15', '1', null, null, '0');
INSERT INTO `options` VALUES ('seo_blog_description', '0', null, null, null, '', '', '0', '1', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('seo_blog_description', '60', null, null, null, null, null, '0', '1', '0', null, null, '2014-11-17 12:10:57', '1', null, null, '0');
INSERT INTO `options` VALUES ('seo_blog_keywords', '0', null, null, null, '', '', '0', '1', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('seo_blog_keywords', '60', null, null, null, null, null, '0', '1', '0', null, null, '2014-11-17 12:10:57', '1', null, null, '0');
INSERT INTO `options` VALUES ('seo_blog_title', '0', null, null, null, '', '', '0', '1', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('seo_blog_title', '60', null, null, null, null, null, '0', '1', '0', null, null, '2014-11-17 12:10:57', '1', null, null, '0');
INSERT INTO `options` VALUES ('seo_description', '0', null, null, null, '', '', '0', '0', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('seo_description', '60', null, null, null, null, null, '0', '0', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('seo_homepage_description', '0', null, null, null, '', 'text', '0', '1', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('seo_homepage_description', '60', null, null, null, null, 'text', '0', '1', '0', null, null, '2014-11-17 12:10:57', '1', null, null, '0');
INSERT INTO `options` VALUES ('seo_homepage_keywords', '0', null, null, null, '', 'text', '0', '1', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('seo_homepage_keywords', '60', null, null, null, null, 'text', '0', '1', '0', null, null, '2014-11-17 12:10:57', '1', null, null, '0');
INSERT INTO `options` VALUES ('seo_homepage_title', '0', null, null, null, '', 'text', '0', '1', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('seo_homepage_title', '60', null, null, null, null, 'text', '0', '1', '0', null, null, '2014-11-17 12:10:57', '1', null, null, '0');
INSERT INTO `options` VALUES ('seo_keywords', '0', null, null, null, '', '', '0', '0', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('seo_keywords', '60', null, null, null, null, null, '0', '0', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('seo_subpage_title', '0', null, null, null, 'SEO Subpage Title', 'text', '0', '1', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('seo_subpage_title', '60', null, null, null, 'SEO Subpage Title', 'text', '0', '1', '0', null, null, '2014-11-17 12:10:57', '1', null, null, '0');
INSERT INTO `options` VALUES ('seo_title', '0', null, null, null, '', '', '0', '1', '0', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('seo_title', '60', null, null, null, null, null, '0', '1', '0', null, null, '2014-11-17 12:10:57', '1', null, null, '0');
INSERT INTO `options` VALUES ('site_logo', '0', null, null, null, '', '', '0', '1', '1', null, null, null, null, null, null, '0');
INSERT INTO `options` VALUES ('site_logo', '60', null, null, null, null, null, '0', '1', '1', null, null, '2014-11-17 12:10:57', '1', null, null, '0');

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` varchar(500) CHARACTER SET latin1 NOT NULL,
  `superuser` tinyint(1) NOT NULL DEFAULT '1',
  `admin` tinyint(1) NOT NULL DEFAULT '0',
  `editor` tinyint(1) NOT NULL DEFAULT '0',
  `user` tinyint(1) NOT NULL DEFAULT '0',
  `guest` tinyint(1) NOT NULL DEFAULT '0',
  `createdBy` int(11) DEFAULT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of permissions
-- ----------------------------
INSERT INTO `permissions` VALUES ('admin_menu', '1', '1', '1', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('category_delete', '1', '1', '1', '1', '0', null, null, null);
INSERT INTO `permissions` VALUES ('category_delete_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('category_read', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('category_read_others', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('category_save', '1', '1', '1', '1', '0', null, null, null);
INSERT INTO `permissions` VALUES ('category_save_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('email_full_control', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('form_delete', '1', '1', '1', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('form_delete_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('form_read', '1', '1', '1', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('form_read_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('form_save', '1', '1', '1', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('form_save_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('itdevice_full_control', '1', '1', '1', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('jobapp', '1', '1', '1', '1', '0', null, null, null);
INSERT INTO `permissions` VALUES ('log_read_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('menu_delete', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('menu_delete_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('menu_save', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('menu_save_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('newsletter_save', '1', '1', '1', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('option_delete', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('option_delete_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('option_read', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('option_read_others', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('option_save', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('option_save_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('page_delete', '1', '1', '1', '1', '0', null, null, null);
INSERT INTO `permissions` VALUES ('page_delete_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('page_read', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('page_read_others', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('page_save', '1', '1', '1', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('page_save_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('permission_delete', '1', '0', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('permission_delete_others', '1', '0', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('permission_read', '1', '0', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('permission_read_others', '1', '0', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('permission_save', '1', '0', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('permission_save_others', '1', '0', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('post_delete', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('post_delete_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('post_read', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('post_read_others', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('post_save', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('post_save_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('superadmin', '1', '0', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('superuser_menu', '1', '0', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('todo_delete', '1', '1', '1', '1', '0', null, null, null);
INSERT INTO `permissions` VALUES ('todo_delete_others', '0', '0', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('todo_read', '1', '1', '1', '1', '0', null, null, null);
INSERT INTO `permissions` VALUES ('todo_read_others', '0', '0', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('todo_save', '1', '1', '1', '1', '0', null, null, null);
INSERT INTO `permissions` VALUES ('todo_save_others', '0', '0', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('usertag_delete', '1', '1', '1', '1', '0', null, null, null);
INSERT INTO `permissions` VALUES ('usertag_delete_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('usertag_read', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('usertag_read_others', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('usertag_save', '1', '1', '1', '1', '0', null, null, null);
INSERT INTO `permissions` VALUES ('usertag_save_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('user_delete', '1', '1', '1', '1', '0', null, null, null);
INSERT INTO `permissions` VALUES ('user_delete_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('user_noApprovalNeeded', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('user_read', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('user_read_others', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('user_save', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('user_save_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('user_save_role', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('user_save_role_admin', '1', '0', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('video_delete', '1', '1', '1', '1', '0', null, null, null);
INSERT INTO `permissions` VALUES ('video_delete_others', '1', '1', '0', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('video_read', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('video_read_others', '1', '1', '1', '1', '1', null, null, null);
INSERT INTO `permissions` VALUES ('video_save', '1', '1', '1', '0', '0', null, null, null);
INSERT INTO `permissions` VALUES ('video_save_others', '1', '1', '0', '0', '0', null, null, null);

-- ----------------------------
-- Table structure for posts
-- ----------------------------
DROP TABLE IF EXISTS `posts`;
CREATE TABLE `posts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `postType` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `urlid` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `name` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` longtext CHARACTER SET latin1,
  `template` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'default',
  `metagenerated` int(1) DEFAULT '1',
  `metatitle` varchar(1200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metadescription` varchar(1200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metakeywords` varchar(1200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `quoteImg` varchar(455) COLLATE utf8_unicode_ci DEFAULT NULL,
  `youtubeId` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sideContent` varchar(2055) COLLATE utf8_unicode_ci DEFAULT NULL,
  `redirect` varchar(800) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `siteid` int(11) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  `oldUrl` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `authorName` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of posts
-- ----------------------------
INSERT INTO `posts` VALUES ('1', 'page', 'home', 'Home', '<h2>Welcome to bacon ipsum dolor amet shankle pork spare ribs kevin ground round prosciutto. Turkey hamburger kevin bresaola frankfurter leberkas biltong picanha, flank jowl tenderloin. Venison tongue ribeye jowl capicola short ribs. Frankfurter strip steak meatloaf sirloin, jowl shank alcatra fatback.</h2>\r\n<br />\r\nTail ham hock cow leberkas hamburger. Doner prosciutto porchetta, turducken biltong jowl tri-tip. Shankle corned beef frankfurter strip steak. Tenderloin sirloin landjaeger pork chop ham prosciutto. Chuck turkey ham hock drumstick, tail meatball sausage ball tip swine ground round boudin t-bone.<br />\r\n<br />\r\nLandjaeger swine ribeye, ball tip biltong cow shoulder leberkas pig flank pork loin frankfurter. T-bone chicken spare ribs tail. Brisket venison shank frankfurter jowl pig pork loin strip steak cow t-bone beef ribs flank ribeye. Pork leberkas picanha, cupim pig prosciutto ball tip. Frankfurter andouille pancetta tri-tip.', 'default', '1', 'Home', 'Welcome to bacon ipsum dolor amet shankle pork spare ribs kevin ground round prosciutto. Turkey hamburger kevin bresaola frankfurter leberkas biltong picanha, flank jowl tenderloin. Venison tongue rib', 'andouille,alcatra,capicola,Pork,bacon,tip,dolor,sausage,Chuck,loin,Turkey,tail,hamburger,Tenderloin,ipsum,Brisket,drumstick,hock,ground,t-bone,tenderloin,kevin,chicken,turducken,short,tri-tip,steak,ba', 'published', null, null, null, null, null, '60', null, null, '2014-11-17 11:19:42', '1', null, null, null, null, '0');
INSERT INTO `posts` VALUES ('2', 'post', 'hello-world', 'Hello world', '<h2>Bacon ipsum dolor amet shankle pork spare ribs kevin ground round prosciutto. Turkey hamburger kevin bresaola frankfurter leberkas biltong picanha, flank jowl tenderloin. Venison tongue ribeye jowl capicola short ribs. Frankfurter strip steak meatloaf sirloin, jowl shank alcatra fatback.</h2>\r\n\r\n<p>Tail ham hock cow leberkas hamburger. Doner prosciutto porchetta, turducken biltong jowl tri-tip. Shankle corned beef frankfurter strip steak. Tenderloin sirloin landjaeger pork chop ham prosciutto. Chuck turkey ham hock drumstick, tail meatball sausage ball tip swine ground round boudin t-bone.</p>\r\n\r\n<p>Landjaeger swine ribeye, ball tip biltong cow shoulder leberkas pig flank pork loin frankfurter. T-bone chicken spare ribs tail. Brisket venison shank frankfurter jowl pig pork loin strip steak cow t-bone beef ribs flank ribeye. Pork leberkas picanha, cupim pig prosciutto ball tip. Frankfurter andouille pancetta tri-tip.</p>', 'default', '1', 'Hello world', 'Bacon ipsum dolor amet shankle pork spare ribs kevin ground round prosciutto. Turkey hamburger kevin bresaola frankfurter leberkas biltong picanha, flank jowl tenderloin. Venison tongue ribeye jowl ca', 'andouille,alcatra,capicola,Pork,tip,dolor,sausage,Chuck,loin,Turkey,tail,hamburger,Tenderloin,ipsum,Brisket,drumstick,hock,ground,t-bone,tenderloin,kevin,chicken,turducken,short,tri-tip,steak,ball,Sha', 'published', null, null, null, null, null, '60', '2014-11-17 11:08:36', '1', '2014-11-17 11:08:36', '1', null, null, null, null, '0');

-- ----------------------------
-- Table structure for redirects
-- ----------------------------
DROP TABLE IF EXISTS `redirects`;
CREATE TABLE `redirects` (
  `if_matches_this` varchar(250) NOT NULL,
  `then_redirect_to` varchar(250) NOT NULL,
  `siteid` int(11) DEFAULT '1',
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`if_matches_this`,`then_redirect_to`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of redirects
-- ----------------------------

-- ----------------------------
-- Table structure for sites
-- ----------------------------
DROP TABLE IF EXISTS `sites`;
CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `subdomain` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `urlid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enableAdminTheme` int(1) DEFAULT '1',
  `registrationDisabled` int(1) DEFAULT '0',
  `emailMatchDomainRequired` int(1) DEFAULT '0',
  `emailMatchOtherDomains` varchar(1000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sslenabled` int(11) DEFAULT '0',
  `theme` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `urlExtension` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `siteid` int(11) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=61 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of sites
-- ----------------------------
INSERT INTO `sites` VALUES ('60', 'Wheelie CMS', null, 'localhost', '0', '0', '0', null, '0', 'light-theme', null, '60', '2014-10-05 19:10:06', '1', '2014-11-17 12:10:56', '1', null, null, '1');

-- ----------------------------
-- Table structure for todos
-- ----------------------------
DROP TABLE IF EXISTS `todos`;
CREATE TABLE `todos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(400) COLLATE utf8_unicode_ci NOT NULL,
  `isdone` date DEFAULT NULL,
  `isdone_old` int(11) DEFAULT NULL,
  `duedate` datetime DEFAULT NULL,
  `priority` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'medium',
  `todogroupid` int(11) DEFAULT NULL,
  `parentid` int(11) DEFAULT NULL,
  `description` text COLLATE utf8_unicode_ci,
  `sortorder` int(11) NOT NULL DEFAULT '0',
  `siteid` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `deletedBy` int(11) DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of todos
-- ----------------------------
INSERT INTO `todos` VALUES ('1', 'Add a video', '2014-11-17', null, '2014-11-17 00:00:00', 'low', null, '3', null, '4', '60', '2014-11-17 15:53:41', '1', '2014-11-17 15:54:09', '1', null, null, '0');
INSERT INTO `todos` VALUES ('2', 'Add a page', null, null, '2014-11-17 00:00:00', 'low', null, '3', null, '3', '60', '2014-11-17 15:53:50', '1', '2014-11-17 15:54:08', '1', null, null, '0');
INSERT INTO `todos` VALUES ('3', 'Add site content', null, null, '2014-11-17 00:00:00', 'low', null, null, null, '2', '60', '2014-11-17 15:54:06', '1', '2014-11-17 15:54:07', '1', null, null, '0');

-- ----------------------------
-- Table structure for usergroups
-- ----------------------------
DROP TABLE IF EXISTS `usergroups`;
CREATE TABLE `usergroups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `groupname` varchar(1000) DEFAULT NULL,
  `siteid` int(11) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  `defaultgroup` int(11) DEFAULT '0',
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of usergroups
-- ----------------------------
INSERT INTO `usergroups` VALUES ('1', 'Users', '1', null, '1', '1', null, null, null, null, null, null);

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sortorder` int(11) NOT NULL DEFAULT '9999',
  `approval_flag` int(11) DEFAULT NULL,
  `securityApproval` int(11) DEFAULT '0',
  `zx_firstname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zx_lastname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zx_jobtitle` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zx_designatory_letters` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zx_about` text COLLATE utf8_unicode_ci,
  `firstname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `jobtitle` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `designatory_letters` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `about` text COLLATE utf8_unicode_ci,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(65) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip` int(5) DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender` int(1) DEFAULT '0',
  `fullLastname` int(1) DEFAULT '0',
  `birthday` datetime DEFAULT NULL,
  `showOnSite` int(1) DEFAULT '0',
  `start_date` datetime DEFAULT NULL,
  `role` varchar(255) COLLATE utf8_unicode_ci DEFAULT '',
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `siteid` int(11) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', '9999', '0', '1', 'Get', 'Wheelie', 'Wheelie', null, null, 'Get', 'Wheelie', 'Wheelie', null, null, null, 'admin@getwheelie.com', null, 'F58319B6389F308D77D8D07DEBA42398', null, null, null, null, null, null, '0', '0', null, '0', null, 'superuser', 'draft', null, null, null, null, null, null, null, '1');

-- ----------------------------
-- Table structure for users_categories
-- ----------------------------
DROP TABLE IF EXISTS `users_categories`;
CREATE TABLE `users_categories` (
  `categoryid` int(11) NOT NULL,
  `userid` int(11) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`categoryid`,`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of users_categories
-- ----------------------------

-- ----------------------------
-- Table structure for users_usergroups
-- ----------------------------
DROP TABLE IF EXISTS `users_usergroups`;
CREATE TABLE `users_usergroups` (
  `usergroupid` int(11) NOT NULL DEFAULT '1',
  `userid` int(11) NOT NULL,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`usergroupid`,`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of users_usergroups
-- ----------------------------
INSERT INTO `users_usergroups` VALUES ('1', '1', '2014-08-18 14:01:09', '1', '2014-08-18 14:01:09', '1');
INSERT INTO `users_usergroups` VALUES ('1', '2', '2014-12-09 15:50:23', null, '2014-12-09 15:50:23', null);
INSERT INTO `users_usergroups` VALUES ('1', '4', '2014-12-09 15:54:10', null, '2014-12-09 15:54:10', null);
INSERT INTO `users_usergroups` VALUES ('1', '5', '2014-12-09 15:57:09', null, '2014-12-09 15:57:09', null);

-- ----------------------------
-- Table structure for videos
-- ----------------------------
DROP TABLE IF EXISTS `videos`;
CREATE TABLE `videos` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `urlid` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `teaser` longtext CHARACTER SET latin1 NOT NULL,
  `description` varchar(2000) COLLATE utf8_unicode_ci NOT NULL,
  `videoSubHeader` longtext CHARACTER SET latin1,
  `videoLink` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `isFeatured` int(11) DEFAULT NULL,
  `youtubeid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `vimeoid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sortorder` int(11) DEFAULT NULL,
  `typeId` varchar(400) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filestatus` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(10) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `isPlaylist` int(11) DEFAULT '0',
  `videofileid` int(11) DEFAULT NULL,
  `siteid` int(11) DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `onSite` int(11) DEFAULT '0',
  `customThumb` int(1) DEFAULT '0',
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  `globalized` int(1) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of videos
-- ----------------------------
INSERT INTO `videos` VALUES ('1', 'setting-up-coldfusion-on-wheels', 'Setting up ColdFusion on Wheels', 'Chris Peters starts the webcast series by demonstrating how to set up ColdFusion on Wheels.', '<span style=\"font-family: arial, sans-serif; font-size: 12.7272720336914px; line-height: 17px;\">Chris Peters starts the webcast series by demonstrating how to set up ColdFusion on Wheels. He shows how to configure a data source and test that it\'s working. This is part of a screencast series on building a social networking site using the ColdFusion on Wheels framework.</span>', null, null, '0', 'J3xdxp29ig4', null, null, null, null, 'published', '0', null, '60', null, '1', '0', '2014-11-17 11:12:18', '1', '2014-12-10 12:07:27', '1', null, null, '0');

-- ----------------------------
-- Table structure for videos_categories
-- ----------------------------
DROP TABLE IF EXISTS `videos_categories`;
CREATE TABLE `videos_categories` (
  `videocategoryid` int(11) NOT NULL,
  `videoid` int(11) NOT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`videocategoryid`,`videoid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of videos_categories
-- ----------------------------
INSERT INTO `videos_categories` VALUES ('1', '1', '2014-12-10 12:07:27', '1', '2014-12-10 12:07:27', '1');
INSERT INTO `videos_categories` VALUES ('2', '1', '2014-12-10 12:07:27', '1', '2014-12-10 12:07:27', '1');

-- ----------------------------
-- Table structure for zipcodes
-- ----------------------------
DROP TABLE IF EXISTS `zipcodes`;
CREATE TABLE `zipcodes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `zip` varchar(255) DEFAULT NULL,
  `type` varchar(255) DEFAULT NULL,
  `primary_city` varchar(255) DEFAULT NULL,
  `acceptable_cities` varchar(255) DEFAULT NULL,
  `unacceptable_cities` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `county` varchar(255) DEFAULT NULL,
  `timezone` varchar(255) DEFAULT NULL,
  `area_codes` varchar(255) DEFAULT NULL,
  `latitude` varchar(255) DEFAULT NULL,
  `longitude` varchar(255) DEFAULT NULL,
  `world_region` varchar(255) DEFAULT NULL,
  `country` varchar(255) DEFAULT NULL,
  `decommissioned` varchar(255) DEFAULT NULL,
  `estimated_population` varchar(255) DEFAULT NULL,
  `notes` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of zipcodes
-- ----------------------------

-- ----------------------------
-- Table structure for _default
-- ----------------------------
DROP TABLE IF EXISTS `_default`;
CREATE TABLE `_default` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of _default
-- ----------------------------
