## Xangui Project
* Xangui is the web frontend for Xandora, a malware collector, analyzer, and reporting system.
* http://www.xandora.net/
* http://demo.xandora.net/ (demo site)

## Team
* Kai-Jern Lau (xwings)
* Kian-Meng Ang (kenmin)
* Meling Mudin (spoonfork)

## Prerequisite
* PHP >= 5.2.3 (extensions : pcre, iconv, mcrypt, spl)
* Apache 1.3/2 
  * Make sure AllowOverride Directive is set to **AllowOverride All**
  * **mod_rewrite** is installed and enabled
* Ngnix (ngnix.conf)

        if (!-e $request_filename) {
            rewrite ^/(.+)$ /index.php?url=$1 last;
            break;
        }

## Installation (web app)
* git clone --recursive git@github.com:xwings/xangui.git
* mv xangui /var/www

## Installation (mysql)
* mysql> create database xandora;
* mysql> create user 'xangui'@'localhost' identified by 'xangui123';
* mysql> grant all privileges on xandora.* to 'xangui'@'localhost';
* mysql> flush privileges;
* database is located in doc/sql/xandora-yyyymmdd.tar.bz2, just pick the latest version

## Post Installation
* web app's base url is set in application/bootstrap.php, grep base_url
  * http://localhost/xangui, set 'base_url' => '/xangui/'
  * http://localhost/, set 'base_url' => '/'
