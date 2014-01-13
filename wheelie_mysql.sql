/*
Navicat MySQL Data Transfer

Source Server         : wampmysql
Source Server Version : 50524
Source Host           : localhost:3306
Source Database       : remotetest

Target Server Type    : MYSQL
Target Server Version : 50524
File Encoding         : 65001

Date: 2014-01-10 11:56:48
*/

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
  `sortorder` int(11) NOT NULL DEFAULT '0',
  `siteid` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `deletedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of categories
-- ----------------------------
INSERT INTO `categories` VALUES ('1', 'Videos', 'video', 'Videos', '3', 'Videos', '4', '1', null, null, '2013-12-31 15:32:45', '1', null, '1');
INSERT INTO `categories` VALUES ('43', 'Astronaut', 'user', 'astronaut', '0', null, '3', '1', '2014-01-10 10:12:28', '1', '2014-01-10 10:28:27', '1', null, null);
INSERT INTO `categories` VALUES ('44', 'Cat wrangler', 'user', 'cat-wrangler', '0', null, '2', '1', '2014-01-10 10:12:42', '1', '2014-01-10 10:28:26', '1', null, null);
INSERT INTO `categories` VALUES ('45', 'Jedi', 'user', 'jedi', '0', null, '5', '1', '2014-01-10 10:12:51', '1', '2014-01-10 10:28:27', '1', null, null);
INSERT INTO `categories` VALUES ('46', 'Indian leg wrestling champion', 'user', 'indian-leg-wrestling-champion', '0', null, '4', '1', '2014-01-10 10:13:07', '1', '2014-01-10 10:28:27', '1', null, null);
INSERT INTO `categories` VALUES ('47', 'Awesome', 'user', 'awesome', null, null, '0', '1', '2014-01-10 10:27:38', '1', '2014-01-10 10:27:38', '1', '2014-01-10 10:28:26', '1');

-- ----------------------------
-- Table structure for files
-- ----------------------------
DROP TABLE IF EXISTS `files`;
CREATE TABLE `files` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `youtubeid` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filename` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filepath` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bytesize` int(11) DEFAULT NULL,
  `status` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `filetype` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `siteid` int(11) DEFAULT NULL,
  `createdAt` datetime DEFAULT NULL,
  `createdBy` int(11) DEFAULT NULL,
  `updatedAt` datetime DEFAULT NULL,
  `updatedBy` int(11) DEFAULT NULL,
  `deletedAt` datetime DEFAULT NULL,
  `deletedBy` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=305 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of files
-- ----------------------------

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
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1675 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of logs
-- ----------------------------
INSERT INTO `logs` VALUES ('1672', '1', '1', 'Update', 'User', 'Users', 'save', null, '2014-01-10 11:53:51');
INSERT INTO `logs` VALUES ('1673', '1', null, 'Create', 'UserTagJoin', 'Users', 'save', null, '2014-01-10 11:53:51');
INSERT INTO `logs` VALUES ('1674', '1', null, 'Create', 'UserTagJoin', 'Users', 'save', null, '2014-01-10 11:53:51');

-- ----------------------------
-- Table structure for menuitems
-- ----------------------------
DROP TABLE IF EXISTS `menuitems`;
CREATE TABLE `menuitems` (
  `id` int(11) NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `urlPath` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `menuid` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'primary',
  `parentid` int(11) DEFAULT NULL,
  `sortOrder` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `siteid` int(11) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`,`menuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of menuitems
-- ----------------------------
INSERT INTO `menuitems` VALUES ('1', 'dsaf', '/p/dfsadfsdfsaadfsa', 'Footer', '0', '1', null, '2014-01-02 10:24:32', null, '2014-01-02 10:24:32', null);
INSERT INTO `menuitems` VALUES ('1', 'Design', '/p/design', 'primary', '0', '1', null, '2014-01-10 09:52:30', null, '2014-01-10 09:52:30', null);
INSERT INTO `menuitems` VALUES ('1', 'Design', '/p/design', 'secondary', '0', '1', null, '2014-01-10 10:00:33', null, '2014-01-10 10:00:33', null);
INSERT INTO `menuitems` VALUES ('2', 'Models', '/video/c/Models', 'Footer', '1', '2', null, '2014-01-02 10:24:32', null, '2014-01-02 10:24:32', null);
INSERT INTO `menuitems` VALUES ('2', 'Consulting', '/p/consulting', 'primary', '0', '2', null, '2014-01-10 09:52:30', null, '2014-01-10 09:52:30', null);
INSERT INTO `menuitems` VALUES ('2', 'Consulting', '/p/consulting', 'secondary', '0', '2', null, '2014-01-10 10:00:33', null, '2014-01-10 10:00:33', null);
INSERT INTO `menuitems` VALUES ('3', 'Sample Page 1', '/p/sample-page-1', 'primary', '2', '3', null, '2014-01-10 09:52:30', null, '2014-01-10 09:52:30', null);
INSERT INTO `menuitems` VALUES ('3', 'Training', '/p/training', 'secondary', '0', '3', null, '2014-01-10 10:00:33', null, '2014-01-10 10:00:33', null);
INSERT INTO `menuitems` VALUES ('4', 'Sample Page 2', '/p/sample-page-2', 'primary', '2', '4', null, '2014-01-10 09:52:31', null, '2014-01-10 09:52:31', null);
INSERT INTO `menuitems` VALUES ('4', 'Contact', '/p/contact', 'secondary', '0', '4', null, '2014-01-10 10:00:33', null, '2014-01-10 10:00:33', null);
INSERT INTO `menuitems` VALUES ('5', 'Sample Page 3', '/p/sample-page-3', 'primary', '2', '5', null, '2014-01-10 09:52:31', null, '2014-01-10 09:52:31', null);
INSERT INTO `menuitems` VALUES ('6', 'Training', '/p/training', 'primary', '0', '6', null, '2014-01-10 09:52:31', null, '2014-01-10 09:52:31', null);
INSERT INTO `menuitems` VALUES ('7', 'Contact', '/p/contact', 'primary', '0', '7', null, '2014-01-10 09:52:31', null, '2014-01-10 09:52:31', null);

-- ----------------------------
-- Table structure for options
-- ----------------------------
DROP TABLE IF EXISTS `options`;
CREATE TABLE `options` (
  `id` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `label` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `content` varchar(5000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `attachment` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inputlabel` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `inputtype` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `editContent` int(1) NOT NULL DEFAULT '0',
  `editLabel` int(1) NOT NULL DEFAULT '0',
  `editAttachment` int(1) NOT NULL DEFAULT '0',
  `siteid` int(11) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of options
-- ----------------------------
INSERT INTO `options` VALUES ('home_feature_1', 'Sweet Phone', '/p/phone22', '/assets/uploads/test_1.JPG', 'Link URL', 'text', '1', '1', '1', null, null, null, '2014-01-10 09:56:34', '1', null, null);
INSERT INTO `options` VALUES ('home_feature_2', 'Cat', '/p/cat', '/assets/uploads/Snow-Leopard-Prowl_3.jpg', 'Link URL', 'text', '1', '1', '1', null, null, null, '2013-12-24 10:04:07', '1', null, null);
INSERT INTO `options` VALUES ('home_feature_3', 'Waves', '/p/waves', '/assets/uploads/Waves-in-Sea_2.jpg', 'Link URL', 'text', '1', '1', '1', null, null, null, '2013-12-24 10:04:06', '1', null, null);
INSERT INTO `options` VALUES ('home_id', null, '29', null, null, null, '0', '0', '0', null, null, null, '2014-01-10 09:36:50', '1', null, null);
INSERT INTO `options` VALUES ('home_info_left', 'Left side', '<div class=\"row\">\r\n<div class=\"col-lg-6\">This is a test<br />\r\nYep, still a test</div>\r\n\r\n<div class=\"col-lg-6\">More testing over here<br />\r\nUm, yep</div>\r\n</div>\r\n<br />\r\n<a href=\"##\">Read more &raquo;</a>', null, 'Content', 'textarea', '1', '1', '0', null, null, null, '2013-12-24 10:04:06', '1', null, null);
INSERT INTO `options` VALUES ('home_info_right', 'Right side', '<div class=\"row\">\r\n<div class=\"col-lg-6\">This is a right test<br />\r\nYep, still a test</div>\r\n\r\n<div class=\"col-lg-6\">More testing over here<br />\r\nUm, yep</div>\r\n</div>\r\n<br />\r\n<a href=\"##\">Read more &raquo;</a>', null, 'Content', 'textarea', '1', '1', '0', null, null, null, '2013-12-24 10:04:04', '1', null, null);
INSERT INTO `options` VALUES ('home_slide_1', null, null, '/assets/uploads/placeit.png', null, null, '0', '0', '1', null, null, null, '2014-01-10 09:59:30', '1', null, null);
INSERT INTO `options` VALUES ('home_spotlight_button', 'Click Here', '/p/hey', null, 'Link URL', 'text', '1', '1', '0', null, null, null, '2013-12-24 11:01:22', '1', null, null);
INSERT INTO `options` VALUES ('home_spotlight_title', 'Hey', 'Welcome to this', null, 'Sub Label', 'text', '1', '1', '0', null, null, null, '2013-12-24 10:04:05', '1', null, null);
INSERT INTO `options` VALUES ('home_welcome_title', 'Welcome to Wheelie', null, null, 'Welcome title', 'text', '0', '1', '0', null, null, null, '2014-01-10 10:22:09', '1', null, null);
INSERT INTO `options` VALUES ('menu_ids', '', 'Other,New Menu', null, 'Menu Ids (comma seperated)', 'text', '1', '0', '0', null, null, null, '2014-01-10 11:07:51', '1', null, null);
INSERT INTO `options` VALUES ('secondary_page_background', null, null, '/assets/uploads/greenbg.jpg', null, null, '0', '0', '1', null, null, null, '2013-12-31 16:26:11', '1', null, null);
INSERT INTO `options` VALUES ('seo_description', 'Woot', null, null, null, null, '0', '0', '0', null, null, null, null, null, null, null);
INSERT INTO `options` VALUES ('seo_keywords', 'Database, Maintenance, Web', null, null, null, null, '0', '0', '0', null, null, null, null, null, null, null);
INSERT INTO `options` VALUES ('seo_title', 'Wheelie CMS Frontend', null, null, null, null, '0', '1', '0', null, null, null, '2014-01-03 16:54:54', '1', null, null);
INSERT INTO `options` VALUES ('site_name_and_logo', 'Wheelie', null, '/assets/uploads/wheelie_cms_logo_3.png', null, null, '0', '1', '1', null, null, null, '2014-01-10 09:58:51', '1', null, null);

-- ----------------------------
-- Table structure for permissions
-- ----------------------------
DROP TABLE IF EXISTS `permissions`;
CREATE TABLE `permissions` (
  `id` varchar(500) CHARACTER SET latin1 NOT NULL,
  `admin` tinyint(1) NOT NULL DEFAULT '1',
  `editor` tinyint(1) NOT NULL DEFAULT '0',
  `author` tinyint(1) NOT NULL DEFAULT '0',
  `user` tinyint(1) NOT NULL DEFAULT '0',
  `guest` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of permissions
-- ----------------------------
INSERT INTO `permissions` VALUES ('category_delete', '1', '1', '1', '0', '0');
INSERT INTO `permissions` VALUES ('category_delete_others', '1', '1', '0', '0', '0');
INSERT INTO `permissions` VALUES ('category_read', '1', '1', '1', '1', '1');
INSERT INTO `permissions` VALUES ('category_read_others', '1', '1', '0', '0', '1');
INSERT INTO `permissions` VALUES ('category_save', '1', '1', '1', '0', '0');
INSERT INTO `permissions` VALUES ('category_save_others', '1', '1', '0', '0', '0');
INSERT INTO `permissions` VALUES ('log_read_others', '1', '1', '0', '0', '0');
INSERT INTO `permissions` VALUES ('option_delete', '1', '1', '0', '0', '0');
INSERT INTO `permissions` VALUES ('option_delete_others', '1', '1', '0', '0', '0');
INSERT INTO `permissions` VALUES ('option_read', '1', '1', '1', '1', '1');
INSERT INTO `permissions` VALUES ('option_read_others', '1', '1', '1', '1', '1');
INSERT INTO `permissions` VALUES ('option_save', '1', '1', '0', '0', '0');
INSERT INTO `permissions` VALUES ('option_save_others', '1', '1', '0', '0', '0');
INSERT INTO `permissions` VALUES ('page_delete', '1', '1', '1', '0', '0');
INSERT INTO `permissions` VALUES ('page_delete_others', '1', '1', '0', '0', '0');
INSERT INTO `permissions` VALUES ('page_read', '1', '1', '1', '0', '1');
INSERT INTO `permissions` VALUES ('page_read_others', '1', '1', '0', '0', '1');
INSERT INTO `permissions` VALUES ('page_save', '1', '1', '1', '0', '0');
INSERT INTO `permissions` VALUES ('page_save_others', '1', '1', '0', '0', '0');
INSERT INTO `permissions` VALUES ('user_delete', '1', '1', '1', '1', '0');
INSERT INTO `permissions` VALUES ('user_delete_others', '1', '0', '0', '0', '0');
INSERT INTO `permissions` VALUES ('user_read', '1', '1', '1', '1', '1');
INSERT INTO `permissions` VALUES ('user_read_others', '1', '1', '0', '0', '1');
INSERT INTO `permissions` VALUES ('user_save', '1', '1', '1', '1', '1');
INSERT INTO `permissions` VALUES ('user_save_others', '1', '0', '0', '0', '0');
INSERT INTO `permissions` VALUES ('user_save_role', '1', '1', '0', '0', '0');
INSERT INTO `permissions` VALUES ('user_save_role_admin', '1', '0', '0', '0', '0');
INSERT INTO `permissions` VALUES ('video_delete', '1', '1', '1', '0', '0');
INSERT INTO `permissions` VALUES ('video_delete_others', '1', '1', '0', '0', '0');
INSERT INTO `permissions` VALUES ('video_read', '1', '1', '1', '0', '1');
INSERT INTO `permissions` VALUES ('video_read_others', '1', '1', '0', '0', '1');
INSERT INTO `permissions` VALUES ('video_save', '1', '1', '1', '0', '0');
INSERT INTO `permissions` VALUES ('video_save_others', '1', '1', '0', '0', '0');

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
  `metagenerated` int(1) DEFAULT '1',
  `metatitle` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metadescription` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `metakeywords` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `siteid` int(11) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of posts
-- ----------------------------
INSERT INTO `posts` VALUES ('29', 'page', 'home', 'Home', '<p><img alt=\" \" class=\"img-right\" src=\"http://placeimg.com/400/500/tech\" /></p>\r\n\r\n<p>Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I love chocolate bar faworki liquorice toffee. Oat cake gummi bears chocolate I love biscuit chocolate. Halvah chocolate cake I love gummies jujubes biscuit liquorice powder chocolate cake. Jelly lemon drops jujubes. Pie chocolate bar wypas souffl&eacute; carrot cake jelly-o dessert topping. Macaroon jelly tart gummies. Marshmallow cupcake lollipop topping toffee macaroon sugar plum. Candy canes sweet faworki wafer jelly-o. Chocolate carrot cake icing gingerbread ice cream I love apple pie chocolate bar muffin.</p>\r\n\r\n<p>Souffl&eacute; candy canes carrot cake pudding sweet I love. Chocolate cake wafer I love tootsie roll. Donut muffin marshmallow. Caramels tart apple pie I love cookie faworki cotton candy marshmallow wypas. Lollipop ice cream icing dessert wafer donut bear claw. Apple pie drag&eacute;e toffee biscuit sugar plum I love bear claw tootsie roll. Lemon drops powder cotton candy sweet I love jujubes halvah chupa chups toffee. Marshmallow wafer jelly-o gingerbread jelly I love wypas cheesecake lollipop. Carrot cake chocolate cheesecake jelly-o I love liquorice sugar plum. Jelly marshmallow oat cake candy. Bonbon marzipan chupa chups marshmallow applicake carrot cake. Cookie biscuit marshmallow. Biscuit cupcake I love cotton candy.</p>\r\n\r\n<p>Jelly-o sugar plum fruitcake apple pie I love lemon drops. Bonbon jelly beans I love marzipan chocolate bar chocolate cake. Applicake wypas souffl&eacute; chocolate cake applicake. Powder croissant dessert brownie carrot cake biscuit carrot cake oat cake. Chocolate cake marzipan pie chupa chups I love. I love pastry halvah jujubes. Chocolate bar candy canes muffin cupcake bear claw. Carrot cake pastry gingerbread gummies. Gummies caramels drag&eacute;e I love jelly-o applicake danish. Carrot cake danish toffee sweet toffee muffin pastry liquorice I love. Applicake lemon drops tiramisu tart candy canes. Chocolate fruitcake gummi bears danish halvah cake.</p>', '1', 'Home', 'You have successfully installed Wheelie! This is the public facing site which is fully customisable. You can access the content management system here . The default email address and password are &#39', 'Wheelie,using,send,pull,password,please,would,request,GitHub,welcome,fully,contributions,fork,here,code,like,much,content,customisable,project,system,default,email,some,management,hope,can,have,instal', 'published', null, null, null, '2014-01-10 09:56:51', '1', null, null);
INSERT INTO `posts` VALUES ('41', 'post', 'test-post', 'Sample Article A', '<p><img alt=\" \" class=\"img-right\" src=\"http://placeimg.com/400/500/tech\" /></p>\r\n\r\n<p>Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I love chocolate bar faworki liquorice toffee. Oat cake gummi bears chocolate I love biscuit chocolate. Halvah chocolate cake I love gummies jujubes biscuit liquorice powder chocolate cake. Jelly lemon drops jujubes. Pie chocolate bar wypas souffl&eacute; carrot cake jelly-o dessert topping. Macaroon jelly tart gummies. Marshmallow cupcake lollipop topping toffee macaroon sugar plum. Candy canes sweet faworki wafer jelly-o. Chocolate carrot cake icing gingerbread ice cream I love apple pie chocolate bar muffin.</p>\r\n\r\n<p>Souffl&eacute; candy canes carrot cake pudding sweet I love. Chocolate cake wafer I love tootsie roll. Donut muffin marshmallow. Caramels tart apple pie I love cookie faworki cotton candy marshmallow wypas. Lollipop ice cream icing dessert wafer donut bear claw. Apple pie drag&eacute;e toffee biscuit sugar plum I love bear claw tootsie roll. Lemon drops powder cotton candy sweet I love jujubes halvah chupa chups toffee. Marshmallow wafer jelly-o gingerbread jelly I love wypas cheesecake lollipop. Carrot cake chocolate cheesecake jelly-o I love liquorice sugar plum. Jelly marshmallow oat cake candy. Bonbon marzipan chupa chups marshmallow applicake carrot cake. Cookie biscuit marshmallow. Biscuit cupcake I love cotton candy.</p>\r\n\r\n<p>Jelly-o sugar plum fruitcake apple pie I love lemon drops. Bonbon jelly beans I love marzipan chocolate bar chocolate cake. Applicake wypas souffl&eacute; chocolate cake applicake. Powder croissant dessert brownie carrot cake biscuit carrot cake oat cake. Chocolate cake marzipan pie chupa chups I love. I love pastry halvah jujubes. Chocolate bar candy canes muffin cupcake bear claw. Carrot cake pastry gingerbread gummies. Gummies caramels drag&eacute;e I love jelly-o applicake danish. Carrot cake danish toffee sweet toffee muffin pastry liquorice I love. Applicake lemon drops tiramisu tart candy canes. Chocolate fruitcake gummi bears danish halvah cake.</p>', '1', 'Test Post', 'Test Post', 'Test,Post', 'draft', null, '2014-01-09 11:50:19', '1', '2014-01-09 11:51:22', '1', null, null);
INSERT INTO `posts` VALUES ('42', 'post', 'test-post', 'Sample Article B', '<p><img alt=\" \" class=\"img-right\" src=\"http://placeimg.com/400/500/tech\" /></p>\r\n\r\n<p>Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I love chocolate bar faworki liquorice toffee. Oat cake gummi bears chocolate I love biscuit chocolate. Halvah chocolate cake I love gummies jujubes biscuit liquorice powder chocolate cake. Jelly lemon drops jujubes. Pie chocolate bar wypas souffl&eacute; carrot cake jelly-o dessert topping. Macaroon jelly tart gummies. Marshmallow cupcake lollipop topping toffee macaroon sugar plum. Candy canes sweet faworki wafer jelly-o. Chocolate carrot cake icing gingerbread ice cream I love apple pie chocolate bar muffin.</p>\r\n\r\n<p>Souffl&eacute; candy canes carrot cake pudding sweet I love. Chocolate cake wafer I love tootsie roll. Donut muffin marshmallow. Caramels tart apple pie I love cookie faworki cotton candy marshmallow wypas. Lollipop ice cream icing dessert wafer donut bear claw. Apple pie drag&eacute;e toffee biscuit sugar plum I love bear claw tootsie roll. Lemon drops powder cotton candy sweet I love jujubes halvah chupa chups toffee. Marshmallow wafer jelly-o gingerbread jelly I love wypas cheesecake lollipop. Carrot cake chocolate cheesecake jelly-o I love liquorice sugar plum. Jelly marshmallow oat cake candy. Bonbon marzipan chupa chups marshmallow applicake carrot cake. Cookie biscuit marshmallow. Biscuit cupcake I love cotton candy.</p>\r\n\r\n<p>Jelly-o sugar plum fruitcake apple pie I love lemon drops. Bonbon jelly beans I love marzipan chocolate bar chocolate cake. Applicake wypas souffl&eacute; chocolate cake applicake. Powder croissant dessert brownie carrot cake biscuit carrot cake oat cake. Chocolate cake marzipan pie chupa chups I love. I love pastry halvah jujubes. Chocolate bar candy canes muffin cupcake bear claw. Carrot cake pastry gingerbread gummies. Gummies caramels drag&eacute;e I love jelly-o applicake danish. Carrot cake danish toffee sweet toffee muffin pastry liquorice I love. Applicake lemon drops tiramisu tart candy canes. Chocolate fruitcake gummi bears danish halvah cake.</p>', '1', 'Test Post', 'Test Post', 'Test,Post', 'published', null, '2014-01-09 11:50:56', '1', '2014-01-09 11:50:56', '1', null, null);
INSERT INTO `posts` VALUES ('43', 'page', 'design', 'Design', '<p><img alt=\" \" class=\"img-right\" src=\"http://placeimg.com/400/500/tech\" /></p>\r\n\r\n<p>Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I love chocolate bar faworki liquorice toffee. Oat cake gummi bears chocolate I love biscuit chocolate. Halvah chocolate cake I love gummies jujubes biscuit liquorice powder chocolate cake. Jelly lemon drops jujubes. Pie chocolate bar wypas souffl&eacute; carrot cake jelly-o dessert topping. Macaroon jelly tart gummies. Marshmallow cupcake lollipop topping toffee macaroon sugar plum. Candy canes sweet faworki wafer jelly-o. Chocolate carrot cake icing gingerbread ice cream I love apple pie chocolate bar muffin.</p>\r\n\r\n<p>Souffl&eacute; candy canes carrot cake pudding sweet I love. Chocolate cake wafer I love tootsie roll. Donut muffin marshmallow. Caramels tart apple pie I love cookie faworki cotton candy marshmallow wypas. Lollipop ice cream icing dessert wafer donut bear claw. Apple pie drag&eacute;e toffee biscuit sugar plum I love bear claw tootsie roll. Lemon drops powder cotton candy sweet I love jujubes halvah chupa chups toffee. Marshmallow wafer jelly-o gingerbread jelly I love wypas cheesecake lollipop. Carrot cake chocolate cheesecake jelly-o I love liquorice sugar plum. Jelly marshmallow oat cake candy. Bonbon marzipan chupa chups marshmallow applicake carrot cake. Cookie biscuit marshmallow. Biscuit cupcake I love cotton candy.</p>\r\n\r\n<p>Jelly-o sugar plum fruitcake apple pie I love lemon drops. Bonbon jelly beans I love marzipan chocolate bar chocolate cake. Applicake wypas souffl&eacute; chocolate cake applicake. Powder croissant dessert brownie carrot cake biscuit carrot cake oat cake. Chocolate cake marzipan pie chupa chups I love. I love pastry halvah jujubes. Chocolate bar candy canes muffin cupcake bear claw. Carrot cake pastry gingerbread gummies. Gummies caramels drag&eacute;e I love jelly-o applicake danish. Carrot cake danish toffee sweet toffee muffin pastry liquorice I love. Applicake lemon drops tiramisu tart candy canes. Chocolate fruitcake gummi bears danish halvah cake.</p>', '1', 'Design', 'Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I lov', 'roll,beans,gummi,Apple,2,applicake,jujubes,drag&eacute;e,carrot,bear,Caramels,sit,chocolate,Pie,Chocolate,cream,toffee,powder,Applicake,ice,lollipop,biscuit,tart,wafer,Sample,ipsum,bar,icing,cupcake,o', 'published', null, null, null, '2014-01-10 09:57:12', null, null, null);
INSERT INTO `posts` VALUES ('44', 'page', 'consulting', 'Consulting', '<p><img alt=\" \" class=\"img-right\" src=\"http://placeimg.com/400/500/tech\" /></p>\r\n\r\n<p>Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I love chocolate bar faworki liquorice toffee. Oat cake gummi bears chocolate I love biscuit chocolate. Halvah chocolate cake I love gummies jujubes biscuit liquorice powder chocolate cake. Jelly lemon drops jujubes. Pie chocolate bar wypas souffl&eacute; carrot cake jelly-o dessert topping. Macaroon jelly tart gummies. Marshmallow cupcake lollipop topping toffee macaroon sugar plum. Candy canes sweet faworki wafer jelly-o. Chocolate carrot cake icing gingerbread ice cream I love apple pie chocolate bar muffin.</p>\r\n\r\n<p>Souffl&eacute; candy canes carrot cake pudding sweet I love. Chocolate cake wafer I love tootsie roll. Donut muffin marshmallow. Caramels tart apple pie I love cookie faworki cotton candy marshmallow wypas. Lollipop ice cream icing dessert wafer donut bear claw. Apple pie drag&eacute;e toffee biscuit sugar plum I love bear claw tootsie roll. Lemon drops powder cotton candy sweet I love jujubes halvah chupa chups toffee. Marshmallow wafer jelly-o gingerbread jelly I love wypas cheesecake lollipop. Carrot cake chocolate cheesecake jelly-o I love liquorice sugar plum. Jelly marshmallow oat cake candy. Bonbon marzipan chupa chups marshmallow applicake carrot cake. Cookie biscuit marshmallow. Biscuit cupcake I love cotton candy.</p>\r\n\r\n<p>Jelly-o sugar plum fruitcake apple pie I love lemon drops. Bonbon jelly beans I love marzipan chocolate bar chocolate cake. Applicake wypas souffl&eacute; chocolate cake applicake. Powder croissant dessert brownie carrot cake biscuit carrot cake oat cake. Chocolate cake marzipan pie chupa chups I love. I love pastry halvah jujubes. Chocolate bar candy canes muffin cupcake bear claw. Carrot cake pastry gingerbread gummies. Gummies caramels drag&eacute;e I love jelly-o applicake danish. Carrot cake danish toffee sweet toffee muffin pastry liquorice I love. Applicake lemon drops tiramisu tart candy canes. Chocolate fruitcake gummi bears danish halvah cake.</p>', '1', 'Consulting', 'Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I lov', 'roll,beans,gummi,Apple,2,applicake,jujubes,drag&eacute;e,carrot,bear,Caramels,sit,chocolate,Pie,Chocolate,cream,toffee,powder,Applicake,ice,lollipop,biscuit,tart,wafer,Sample,ipsum,bar,icing,cupcake,o', 'published', null, null, null, '2014-01-10 09:57:08', null, null, null);
INSERT INTO `posts` VALUES ('45', 'page', 'sample-page-1', 'Sample Page 1', '<p><img alt=\" \" class=\"img-right\" src=\"http://placeimg.com/400/500/tech\" /></p>\r\n\r\n<p>Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I love chocolate bar faworki liquorice toffee. Oat cake gummi bears chocolate I love biscuit chocolate. Halvah chocolate cake I love gummies jujubes biscuit liquorice powder chocolate cake. Jelly lemon drops jujubes. Pie chocolate bar wypas souffl&eacute; carrot cake jelly-o dessert topping. Macaroon jelly tart gummies. Marshmallow cupcake lollipop topping toffee macaroon sugar plum. Candy canes sweet faworki wafer jelly-o. Chocolate carrot cake icing gingerbread ice cream I love apple pie chocolate bar muffin.</p>\r\n\r\n<p>Souffl&eacute; candy canes carrot cake pudding sweet I love. Chocolate cake wafer I love tootsie roll. Donut muffin marshmallow. Caramels tart apple pie I love cookie faworki cotton candy marshmallow wypas. Lollipop ice cream icing dessert wafer donut bear claw. Apple pie drag&eacute;e toffee biscuit sugar plum I love bear claw tootsie roll. Lemon drops powder cotton candy sweet I love jujubes halvah chupa chups toffee. Marshmallow wafer jelly-o gingerbread jelly I love wypas cheesecake lollipop. Carrot cake chocolate cheesecake jelly-o I love liquorice sugar plum. Jelly marshmallow oat cake candy. Bonbon marzipan chupa chups marshmallow applicake carrot cake. Cookie biscuit marshmallow. Biscuit cupcake I love cotton candy.</p>\r\n\r\n<p>Jelly-o sugar plum fruitcake apple pie I love lemon drops. Bonbon jelly beans I love marzipan chocolate bar chocolate cake. Applicake wypas souffl&eacute; chocolate cake applicake. Powder croissant dessert brownie carrot cake biscuit carrot cake oat cake. Chocolate cake marzipan pie chupa chups I love. I love pastry halvah jujubes. Chocolate bar candy canes muffin cupcake bear claw. Carrot cake pastry gingerbread gummies. Gummies caramels drag&eacute;e I love jelly-o applicake danish. Carrot cake danish toffee sweet toffee muffin pastry liquorice I love. Applicake lemon drops tiramisu tart candy canes. Chocolate fruitcake gummi bears danish halvah cake.</p>', '1', 'Sample Page 1', 'Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I lov', 'Cookie,dolor,roll,beans,Lemon,muffin,gummi,pudding,Apple,cookie,applicake,Biscuit,jujubes,drag&eacute;e,carrot,faworki,macaroon,bear,Caramels,cheesecake,sit,Lollipop,chocolate,halvah,fruitcake,wypas,S', 'published', null, null, null, '2014-01-10 09:57:03', null, null, null);
INSERT INTO `posts` VALUES ('46', 'page', 'sample-page-2', 'Sample Page 2', '<p><img alt=\" \" class=\"img-right\" src=\"http://placeimg.com/400/500/tech\" /></p>\r\n\r\n<p>Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I love chocolate bar faworki liquorice toffee. Oat cake gummi bears chocolate I love biscuit chocolate. Halvah chocolate cake I love gummies jujubes biscuit liquorice powder chocolate cake. Jelly lemon drops jujubes. Pie chocolate bar wypas souffl&eacute; carrot cake jelly-o dessert topping. Macaroon jelly tart gummies. Marshmallow cupcake lollipop topping toffee macaroon sugar plum. Candy canes sweet faworki wafer jelly-o. Chocolate carrot cake icing gingerbread ice cream I love apple pie chocolate bar muffin.</p>\r\n\r\n<p>Souffl&eacute; candy canes carrot cake pudding sweet I love. Chocolate cake wafer I love tootsie roll. Donut muffin marshmallow. Caramels tart apple pie I love cookie faworki cotton candy marshmallow wypas. Lollipop ice cream icing dessert wafer donut bear claw. Apple pie drag&eacute;e toffee biscuit sugar plum I love bear claw tootsie roll. Lemon drops powder cotton candy sweet I love jujubes halvah chupa chups toffee. Marshmallow wafer jelly-o gingerbread jelly I love wypas cheesecake lollipop. Carrot cake chocolate cheesecake jelly-o I love liquorice sugar plum. Jelly marshmallow oat cake candy. Bonbon marzipan chupa chups marshmallow applicake carrot cake. Cookie biscuit marshmallow. Biscuit cupcake I love cotton candy.</p>\r\n\r\n<p>Jelly-o sugar plum fruitcake apple pie I love lemon drops. Bonbon jelly beans I love marzipan chocolate bar chocolate cake. Applicake wypas souffl&eacute; chocolate cake applicake. Powder croissant dessert brownie carrot cake biscuit carrot cake oat cake. Chocolate cake marzipan pie chupa chups I love. I love pastry halvah jujubes. Chocolate bar candy canes muffin cupcake bear claw. Carrot cake pastry gingerbread gummies. Gummies caramels drag&eacute;e I love jelly-o applicake danish. Carrot cake danish toffee sweet toffee muffin pastry liquorice I love. Applicake lemon drops tiramisu tart candy canes. Chocolate fruitcake gummi bears danish halvah cake.</p>', '1', 'Sample Page 2', 'Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I lov', 'Cookie,dolor,roll,beans,Lemon,muffin,gummi,pudding,Apple,cookie,applicake,Biscuit,jujubes,drag&eacute;e,carrot,faworki,macaroon,bear,Caramels,cheesecake,sit,Lollipop,chocolate,halvah,fruitcake,wypas,S', 'published', null, null, null, '2014-01-10 09:57:16', null, null, null);
INSERT INTO `posts` VALUES ('47', 'page', 'sample-page-3', 'Sample Page 3', '<p><img alt=\" \" class=\"img-right\" src=\"http://placeimg.com/400/500/tech\" /></p>\r\n\r\n<p>Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I love chocolate bar faworki liquorice toffee. Oat cake gummi bears chocolate I love biscuit chocolate. Halvah chocolate cake I love gummies jujubes biscuit liquorice powder chocolate cake. Jelly lemon drops jujubes. Pie chocolate bar wypas souffl&eacute; carrot cake jelly-o dessert topping. Macaroon jelly tart gummies. Marshmallow cupcake lollipop topping toffee macaroon sugar plum. Candy canes sweet faworki wafer jelly-o. Chocolate carrot cake icing gingerbread ice cream I love apple pie chocolate bar muffin.</p>\r\n\r\n<p>Souffl&eacute; candy canes carrot cake pudding sweet I love. Chocolate cake wafer I love tootsie roll. Donut muffin marshmallow. Caramels tart apple pie I love cookie faworki cotton candy marshmallow wypas. Lollipop ice cream icing dessert wafer donut bear claw. Apple pie drag&eacute;e toffee biscuit sugar plum I love bear claw tootsie roll. Lemon drops powder cotton candy sweet I love jujubes halvah chupa chups toffee. Marshmallow wafer jelly-o gingerbread jelly I love wypas cheesecake lollipop. Carrot cake chocolate cheesecake jelly-o I love liquorice sugar plum. Jelly marshmallow oat cake candy. Bonbon marzipan chupa chups marshmallow applicake carrot cake. Cookie biscuit marshmallow. Biscuit cupcake I love cotton candy.</p>\r\n\r\n<p>Jelly-o sugar plum fruitcake apple pie I love lemon drops. Bonbon jelly beans I love marzipan chocolate bar chocolate cake. Applicake wypas souffl&eacute; chocolate cake applicake. Powder croissant dessert brownie carrot cake biscuit carrot cake oat cake. Chocolate cake marzipan pie chupa chups I love. I love pastry halvah jujubes. Chocolate bar candy canes muffin cupcake bear claw. Carrot cake pastry gingerbread gummies. Gummies caramels drag&eacute;e I love jelly-o applicake danish. Carrot cake danish toffee sweet toffee muffin pastry liquorice I love. Applicake lemon drops tiramisu tart candy canes. Chocolate fruitcake gummi bears danish halvah cake.</p>', '1', 'Sample Page 3', 'Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I lov', 'Cookie,dolor,roll,beans,Lemon,muffin,gummi,pudding,Apple,cookie,applicake,Biscuit,jujubes,drag&eacute;e,carrot,faworki,macaroon,bear,Caramels,cheesecake,sit,Lollipop,chocolate,halvah,fruitcake,wypas,S', 'published', null, null, null, '2014-01-10 09:56:53', null, null, null);
INSERT INTO `posts` VALUES ('48', 'page', 'training', 'Training', '<p><img alt=\" \" class=\"img-right\" src=\"http://placeimg.com/400/500/tech\" /></p>\r\n\r\n<p>Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I love chocolate bar faworki liquorice toffee. Oat cake gummi bears chocolate I love biscuit chocolate. Halvah chocolate cake I love gummies jujubes biscuit liquorice powder chocolate cake. Jelly lemon drops jujubes. Pie chocolate bar wypas souffl&eacute; carrot cake jelly-o dessert topping. Macaroon jelly tart gummies. Marshmallow cupcake lollipop topping toffee macaroon sugar plum. Candy canes sweet faworki wafer jelly-o. Chocolate carrot cake icing gingerbread ice cream I love apple pie chocolate bar muffin.</p>\r\n\r\n<p>Souffl&eacute; candy canes carrot cake pudding sweet I love. Chocolate cake wafer I love tootsie roll. Donut muffin marshmallow. Caramels tart apple pie I love cookie faworki cotton candy marshmallow wypas. Lollipop ice cream icing dessert wafer donut bear claw. Apple pie drag&eacute;e toffee biscuit sugar plum I love bear claw tootsie roll. Lemon drops powder cotton candy sweet I love jujubes halvah chupa chups toffee. Marshmallow wafer jelly-o gingerbread jelly I love wypas cheesecake lollipop. Carrot cake chocolate cheesecake jelly-o I love liquorice sugar plum. Jelly marshmallow oat cake candy. Bonbon marzipan chupa chups marshmallow applicake carrot cake. Cookie biscuit marshmallow. Biscuit cupcake I love cotton candy.</p>\r\n\r\n<p>Jelly-o sugar plum fruitcake apple pie I love lemon drops. Bonbon jelly beans I love marzipan chocolate bar chocolate cake. Applicake wypas souffl&eacute; chocolate cake applicake. Powder croissant dessert brownie carrot cake biscuit carrot cake oat cake. Chocolate cake marzipan pie chupa chups I love. I love pastry halvah jujubes. Chocolate bar candy canes muffin cupcake bear claw. Carrot cake pastry gingerbread gummies. Gummies caramels drag&eacute;e I love jelly-o applicake danish. Carrot cake danish toffee sweet toffee muffin pastry liquorice I love. Applicake lemon drops tiramisu tart candy canes. Chocolate fruitcake gummi bears danish halvah cake.</p>', '1', 'Training', 'Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I lov', 'Cookie,dolor,roll,beans,Lemon,muffin,gummi,pudding,Apple,cookie,applicake,Biscuit,jujubes,drag&eacute;e,carrot,faworki,macaroon,bear,Caramels,cheesecake,sit,Lollipop,chocolate,halvah,fruitcake,wypas,S', 'published', null, null, null, '2014-01-10 09:56:58', null, null, null);
INSERT INTO `posts` VALUES ('49', 'page', 'blog', 'Blog', '<p><img alt=\" \" class=\"img-right\" src=\"http://placeimg.com/400/500/tech\" /></p>\r\n\r\n<p>Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I love chocolate bar faworki liquorice toffee. Oat cake gummi bears chocolate I love biscuit chocolate. Halvah chocolate cake I love gummies jujubes biscuit liquorice powder chocolate cake. Jelly lemon drops jujubes. Pie chocolate bar wypas souffl&eacute; carrot cake jelly-o dessert topping. Macaroon jelly tart gummies. Marshmallow cupcake lollipop topping toffee macaroon sugar plum. Candy canes sweet faworki wafer jelly-o. Chocolate carrot cake icing gingerbread ice cream I love apple pie chocolate bar muffin.</p>\r\n\r\n<p>Souffl&eacute; candy canes carrot cake pudding sweet I love. Chocolate cake wafer I love tootsie roll. Donut muffin marshmallow. Caramels tart apple pie I love cookie faworki cotton candy marshmallow wypas. Lollipop ice cream icing dessert wafer donut bear claw. Apple pie drag&eacute;e toffee biscuit sugar plum I love bear claw tootsie roll. Lemon drops powder cotton candy sweet I love jujubes halvah chupa chups toffee. Marshmallow wafer jelly-o gingerbread jelly I love wypas cheesecake lollipop. Carrot cake chocolate cheesecake jelly-o I love liquorice sugar plum. Jelly marshmallow oat cake candy. Bonbon marzipan chupa chups marshmallow applicake carrot cake. Cookie biscuit marshmallow. Biscuit cupcake I love cotton candy.</p>\r\n\r\n<p>Jelly-o sugar plum fruitcake apple pie I love lemon drops. Bonbon jelly beans I love marzipan chocolate bar chocolate cake. Applicake wypas souffl&eacute; chocolate cake applicake. Powder croissant dessert brownie carrot cake biscuit carrot cake oat cake. Chocolate cake marzipan pie chupa chups I love. I love pastry halvah jujubes. Chocolate bar candy canes muffin cupcake bear claw. Carrot cake pastry gingerbread gummies. Gummies caramels drag&eacute;e I love jelly-o applicake danish. Carrot cake danish toffee sweet toffee muffin pastry liquorice I love. Applicake lemon drops tiramisu tart candy canes. Chocolate fruitcake gummi bears danish halvah cake.</p>', '1', 'Blog', null, null, 'draft', null, null, null, null, null, null, null);
INSERT INTO `posts` VALUES ('52', 'page', 'contact', 'Contact', '<p><img alt=\" \" class=\"img-right\" src=\"http://placeimg.com/400/500/tech\" /></p>\r\n\r\n<p>Cupcake ipsum dolor sit amet souffl&eacute; marzipan. Danish croissant ice cream drag&eacute;e icing lollipop. I love faworki tootsie roll I love pastry pastry marzipan pie I love. Jelly-o donut I love chocolate bar faworki liquorice toffee. Oat cake gummi bears chocolate I love biscuit chocolate. Halvah chocolate cake I love gummies jujubes biscuit liquorice powder chocolate cake. Jelly lemon drops jujubes. Pie chocolate bar wypas souffl&eacute; carrot cake jelly-o dessert topping. Macaroon jelly tart gummies. Marshmallow cupcake lollipop topping toffee macaroon sugar plum. Candy canes sweet faworki wafer jelly-o. Chocolate carrot cake icing gingerbread ice cream I love apple pie chocolate bar muffin.</p>\r\n\r\n<p>Souffl&eacute; candy canes carrot cake pudding sweet I love. Chocolate cake wafer I love tootsie roll. Donut muffin marshmallow. Caramels tart apple pie I love cookie faworki cotton candy marshmallow wypas. Lollipop ice cream icing dessert wafer donut bear claw. Apple pie drag&eacute;e toffee biscuit sugar plum I love bear claw tootsie roll. Lemon drops powder cotton candy sweet I love jujubes halvah chupa chups toffee. Marshmallow wafer jelly-o gingerbread jelly I love wypas cheesecake lollipop. Carrot cake chocolate cheesecake jelly-o I love liquorice sugar plum. Jelly marshmallow oat cake candy. Bonbon marzipan chupa chups marshmallow applicake carrot cake. Cookie biscuit marshmallow. Biscuit cupcake I love cotton candy.</p>\r\n\r\n<p>Jelly-o sugar plum fruitcake apple pie I love lemon drops. Bonbon jelly beans I love marzipan chocolate bar chocolate cake. Applicake wypas souffl&eacute; chocolate cake applicake. Powder croissant dessert brownie carrot cake biscuit carrot cake oat cake. Chocolate cake marzipan pie chupa chups I love. I love pastry halvah jujubes. Chocolate bar candy canes muffin cupcake bear claw. Carrot cake pastry gingerbread gummies. Gummies caramels drag&eacute;e I love jelly-o applicake danish. Carrot cake danish toffee sweet toffee muffin pastry liquorice I love. Applicake lemon drops tiramisu tart candy canes. Chocolate fruitcake gummi bears danish halvah cake.</p>', '1', 'Contact', 'Follow the instructions on our wiki to make this page redirect to the contact form feature. Alternatively, you can access the contact form feature at index.cfm/enquiry .', 'Alternatively,can,form,instructions,at,you,access,indexcfm/enquiry,contact,page,Follow,feature,redirect,wiki,make,our', 'published', null, null, null, '2014-01-10 09:58:25', null, null, null);

-- ----------------------------
-- Table structure for sites
-- ----------------------------
DROP TABLE IF EXISTS `sites`;
CREATE TABLE `sites` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `urlid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of sites
-- ----------------------------
INSERT INTO `sites` VALUES ('1', 'Multisite', 'Coming later');

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `firstname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `spouse_firstname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `email` varchar(150) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(65) COLLATE utf8_unicode_ci DEFAULT NULL,
  `about` varchar(2000) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `address2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `zip` int(5) DEFAULT NULL,
  `country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `role` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'user',
  `portrait` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `siteid` int(11) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of users
-- ----------------------------
INSERT INTO `users` VALUES ('1', 'Get', 'Wheelie', null, null, 'admin@getwheelie.com', null, 'FE7874168A1593052982406379EDCAB0', null, null, null, null, 'AL', null, 'AF', 'admin', '/assets/uploads/placeit (1).png', 'published', null, '2013-12-16 16:14:39', '1', '2014-01-10 11:53:51', '1', null, null);
INSERT INTO `users` VALUES ('26', 'Chuck', 'Norris', null, null, 'norris@chuck.com', null, 'FE7874168A1593052982406379EDCAB0', null, null, null, null, 'AL', null, 'AF', 'user', '/assets/uploads/placeit (1)_1.png', 'published', null, '2014-01-08 13:12:21', '0', '2014-01-08 13:13:18', '26', null, null);

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
INSERT INTO `users_categories` VALUES ('44', '1', '2014-01-10 11:53:51', '1', '2014-01-10 11:53:51', '1');
INSERT INTO `users_categories` VALUES ('45', '1', '2014-01-10 11:53:52', '1', '2014-01-10 11:53:52', '1');

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
  `hideFromB2B` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `isFeatured` int(11) DEFAULT NULL,
  `sortBy` int(11) DEFAULT NULL,
  `typeId` varchar(400) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` varchar(10) COLLATE utf8_unicode_ci DEFAULT 'draft',
  `videofileid` int(11) NOT NULL,
  `siteid` int(11) DEFAULT NULL,
  `createdat` datetime DEFAULT NULL,
  `createdby` int(11) DEFAULT NULL,
  `updatedat` datetime DEFAULT NULL,
  `updatedby` int(11) DEFAULT NULL,
  `deletedat` datetime DEFAULT NULL,
  `deletedby` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=69 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of videos
-- ----------------------------
INSERT INTO `videos` VALUES ('68', 'Coolest-Video-Ever-jack', 'Coolest Video Ever', 'Coolest Video Ever<hey> jackCoolest Video Ever<hey> jack', 'Coolest Video Ever&lt;hey&gt; jack', null, null, null, '1', null, null, 'published', '238', '1', '2014-01-03 13:55:22', '1', '2014-01-03 13:55:22', '1', null, null);

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
INSERT INTO `videos_categories` VALUES ('25', '56', '2014-01-03 13:08:42', '1', '2014-01-03 13:08:42', '1');
INSERT INTO `videos_categories` VALUES ('25', '64', '2014-01-02 15:26:00', '1', '2014-01-02 15:26:00', '1');
INSERT INTO `videos_categories` VALUES ('25', '67', '2014-01-02 15:27:57', '1', '2014-01-02 15:27:57', '1');

-- ----------------------------
-- View structure for viewvideos
-- ----------------------------
DROP VIEW IF EXISTS `viewvideos`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER  VIEW `viewvideos` AS SELECT
videos.id AS id,
videos.urlid AS urlid,
videos.`name` AS `name`,
videos.teaser AS teaser,
videos.description AS description,
videos.videoSubHeader AS videoSubHeader,
videos.videoLink AS videoLink,
videos.hideFromB2B AS hideFromB2B,
videos.isFeatured AS isFeatured,
videos.sortBy AS sortBy,
videos.typeId AS typeId,
videos.`status` AS `status`,
videos.videofileid AS videofileid,
videos.createdat AS createdat,
videos.createdby AS createdby,
videos.updatedat AS updatedat,
videos.updatedby AS updatedby,
videos.deletedat AS deletedat,
videos.deletedby AS deletedby,
users.id AS user_id,
users.zip AS zip,
users.country AS country,
users.role AS role,
users.portrait AS portrait,
files.id AS fileid,
files.youtubeid AS youtubeid,
files.filename AS filename,
files.filepath AS filepath,
files.bytesize AS bytesize,
files.`status` AS filestatus,
files.filetype AS filetype,
categories.`name` AS category_name,
categories.urlid AS category_urlid,
categories.parentid AS parentid,
categories.description AS category_description,
categories.sortorder AS sortorder,
categories.id AS category_id,
users.firstname,
users.lastname,
users.email,
videos.siteid
FROM
((((videos
LEFT JOIN videos_categories ON ((videos.id = videos_categories.videoid)))
LEFT JOIN users ON ((users.id = videos.createdby)))
LEFT JOIN files ON ((files.id = videos.videofileid)))
LEFT JOIN categories ON ((categories.id = `videos_categories`.`videocategoryid`)) AND categories.id = videos_categories.videocategoryid) ;
