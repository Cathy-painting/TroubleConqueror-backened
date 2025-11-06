# ENV
安装maven、mysql、redis、nodejs、python3.12-venv
sudo apt install python3-venv -y
sudo apt install maven
## Mysql 
sudo apt install mysql-server -y
sudo systemctl start mysql
sudo mysql -u root -p

```mysql
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '你的密码';
CREATE USER 'root'@'%' IDENTIFIED BY '你的密码';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;
```
sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf
bind-address = 0.0.0.0
sudo systemctl restart mysql

## redis 
sudo apt install redis-server -y
sudo nano /etc/redis/redis.conf
supervised systemd
bind 0.0.0.0
sudo systemctl restart redis-server
redis-cli
auth 你的密码
ping



clone仓库
配置application.yml等三个文件，在ruoyi-admin
导入数据库

在根目录编译子模块
mvn clean install -Dmaven.test.skip=true
在ruoyi-admin编译
mvn clean install 

在ruoyi-ui 
npm install 

在ocr

