DROP DATABASE IF EXISTS webtools;
CREATE DATABASE webtools;
grant all on webtools.* to 'admin'@'localhost';
USE webtools;

-- app_config
DROP TABLE IF EXISTS app_config;
CREATE TABLE app_config(
	-- Attributes --
	config_id INT(11) NOT NULL AUTO_INCREMENT,
	config_key VARCHAR(255) DEFAULT NULL,
	config_value VARCHAR(255) DEFAULT NULL,
	create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(config_id)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- users 
DROP TABLE IF EXISTS users;
CREATE TABLE users(
	-- Attributes --
	user_id INT(11) NOT NULL AUTO_INCREMENT,
	login VARCHAR(255) DEFAULT NULL,
	password VARCHAR(255) DEFAULT NULL,
	email VARCHAR(255) DEFAULT NULL,
	create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(user_id)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- realms 
DROP TABLE IF EXISTS realms;
CREATE TABLE realms(
	-- Attributes --
	realm_id INT(11) NOT NULL AUTO_INCREMENT,
	name VARCHAR(255) DEFAULT NULL,
	create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(realm_id)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- path_realm Pages access control list
DROP TABLE IF EXISTS path_realm;
CREATE TABLE path_realm(
	-- Attributes --
	ac_id INT(11) NOT NULL AUTO_INCREMENT,
	realm_id INT(11) NOT NULL,
	ac_path VARCHAR(255) DEFAULT NULL,
	create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(ac_id)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- permissions 
DROP TABLE IF EXISTS permissions;
CREATE TABLE permissions(
	-- Attributes --
	permission_id INT(11) NOT NULL AUTO_INCREMENT,
	user_id INT(11) NOT NULL,
	realm_id INT(11) NOT NULL,
	create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(permission_id)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- sm_pages Pages list for sites monitoring app
DROP TABLE IF EXISTS sm_pages;
CREATE TABLE sm_pages(
	-- Attributes --
	page_id INT(11) NOT NULL AUTO_INCREMENT,
	name VARCHAR(255) DEFAULT NULL,
	domain VARCHAR(255) DEFAULT NULL,
	url VARCHAR(255) DEFAULT NULL,
	protocol VARCHAR(255) DEFAULT "http",
	http_status_code INT(3) DEFAULT NULL,
	last_check_time TIMESTAMP NULL DEFAULT NULL,
	create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(page_id)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- subdirectory
DROP TABLE IF EXISTS subdirectory;
CREATE TABLE subdirectory(
	-- Attributes --
	sub_id INT(11) NOT NULL AUTO_INCREMENT,
	parent_sub_id INT(11) NOT NULL DEFAULT 0,
	sub_name VARCHAR(255) DEFAULT NULL,
	sub_url VARCHAR(255) DEFAULT NULL,
	data_controller VARCHAR(255) DEFAULT NULL,
	theme_template VARCHAR(255) DEFAULT NULL,
	sub_template VARCHAR(255) DEFAULT NULL,
	page_template VARCHAR(255) DEFAULT NULL,
	sub_redirect_path VARCHAR(255) DEFAULT NULL,
	sub_redirect_code VARCHAR(255) DEFAULT NULL,
	hidden BOOLEAN DEFAULT 0,
	create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(sub_id)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

/*
-- page
DROP TABLE IF EXISTS page;
CREATE TABLE page(
	-- Attributes --
	page_id INT(11) NOT NULL AUTO_INCREMENT,
	parent_sub_id INT(11) NOT NULL,
	page_name VARCHAR(255) DEFAULT NULL,
	page_text LONGTEXT DEFAULT NULL,
	page_text_brief VARCHAR(300) DEFAULT NULL,
	image VARCHAR(255) DEFAULT NULL,
	create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(page_id)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- field
DROP TABLE IF EXISTS field;
CREATE TABLE field(
	-- Attributes --
	field_id INT(11) NOT NULL AUTO_INCREMENT,
	subdirectory_id INT(11) NOT NULL DEFAULT 0,
	page_id INT(11) NOT NULL DEFAULT 0,
	default_value LONGTEXT DEFAULT NULL,
	create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(field_id)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

-- post
DROP TABLE IF EXISTS post;
CREATE TABLE post(
	-- Attributes --
	post_id INT(11) NOT NULL AUTO_INCREMENT,
	parent_sub_id INT(11) NOT NULL,
	post_name VARCHAR(255) DEFAULT NULL,
	post_text LONGTEXT DEFAULT NULL,
	post_text_brief VARCHAR(300) DEFAULT NULL,
	image VARCHAR(255) DEFAULT NULL,
	create_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	update_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY(post_id)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;
*/

-- ALTER TABLE post ADD
--     CONSTRAINT  FK_post_subdirectory  FOREIGN KEY (parent_sub_id) REFERENCES subdirectory (sub_id) on update cascade on delete restrict;

INSERT INTO users (user_id, login, password,email) VALUES (1,"admin","1","test@test.test");
INSERT INTO app_config (config_key, config_value) VALUES ("app_hostname","localhost:84"),("app_protocol","http"),("app_secure","false");
INSERT INTO realms (realm_id,name) VALUES (1,"admin"),(2,"sites_monitor");
INSERT INTO path_realm (realm_id,ac_path) VALUES (1,"/"),(2,"/sm"),(1,"/test");
INSERT INTO permissions (user_id,realm_id) VALUES (1,1),(1,2);
INSERT INTO sm_pages (name,domain,url,http_status_code,last_check_time) VALUES 
("test1","localhost","/demo/test.html",200,"2017-12-31 12:23:30"),
("test2","localhost","/test/demo.html",302,"2016-12-30 11:34:50"),
("test3","localhost","/test.html",404,NULL),
("test4","localhost","/demo/test.html",200,"2017-12-31 12:23:30"),
("test5","localhost","/test/demo.html",302,"2016-12-30 11:34:50"),
("test6","localhost","/test.html",404,NULL),
("test7","localhost","/demo/test.html",200,"2017-12-31 12:23:30"),
("test1","localhost","/demo/test.html",200,"2017-12-31 12:23:30"),
("test2","localhost","/test/demo.html",302,"2016-12-30 11:34:50"),
("test3","localhost","/test.html",404,NULL),
("test4","localhost","/demo/test.html",200,"2017-12-31 12:23:30"),
("test5","localhost","/test/demo.html",302,"2016-12-30 11:34:50"),
("test6","localhost","/test.html",404,NULL),
("test7","localhost","/demo/test.html",200,"2017-12-31 12:23:30"),
("test1","localhost","/demo/test.html",200,"2017-12-31 12:23:30"),
("test2","localhost","/test/demo.html",302,"2016-12-30 11:34:50"),
("test3","localhost","/test.html",404,NULL),
("test4","localhost","/demo/test.html",200,"2017-12-31 12:23:30"),
("test5","localhost","/test/demo.html",302,"2016-12-30 11:34:50"),
("test6","localhost","/test.html",404,NULL),
("test7","localhost","/demo/test.html",200,"2017-12-31 12:23:30");

INSERT INTO subdirectory (sub_id,sub_name,sub_url,sub_redirect_path,sub_redirect_code) VALUES (1,'Dashboard','/','/sm/list','302');
INSERT INTO subdirectory (parent_sub_id,sub_id,sub_name,sub_url,sub_template,theme_template) VALUES (1,2,'Настройки','/config','config.tpl','main_theme.tpl');
INSERT INTO subdirectory (parent_sub_id,sub_id,sub_name,sub_url,sub_redirect_path,sub_redirect_code) VALUES (1,4,'Монитор сайтов','/sm','/sm/list','302');
INSERT INTO subdirectory (parent_sub_id,sub_id,sub_name,sub_url,sub_template,theme_template,page_template,data_controller) VALUES (4,5,'Список сайтов','/sm/list','sm_list.tpl','main_theme.tpl','sm_page.tpl','SitesMonitor');
INSERT INTO subdirectory (parent_sub_id,sub_id,sub_name,sub_url,sub_template,theme_template) VALUES (4,6,'Новая страница','/sm/new','sm_new.tpl','main_theme.tpl');
INSERT INTO subdirectory (parent_sub_id,sub_id,sub_name,sub_url,sub_template,theme_template) VALUES (4,7,'Массовый импорт','/sm/import','sm_import.tpl','main_theme.tpl');

-- INSERT INTO page (parent_sub_id,page_name,page_text,page_text_brief) VALUES (4,'Test','<h3>Some header</h3>blah1 blah<br><b>blah</b>','blah blah');
-- INSERT INTO post (parent_sub_id,post_name,post_text,post_text_brief) VALUES (4,'Test','<h3>Some header</h3>blah1 blah<br><b>blah</b>','blah blah');
