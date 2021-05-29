test this configuration on real vm
don't forget about persistence on disk
add haproxy

CREATE USER haproxy@'%' IDENTIFIED WITH 'mysql_native_password';
FLUSH PRIVILEGES;
