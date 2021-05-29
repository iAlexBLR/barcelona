CREATE USER {{ mysql.haproxy.user }}@'%' IDENTIFIED WITH 'mysql_native_password';
FLUSH PRIVILEGES;
