USE mysql;
ALTER USER 'root'@'localhost' IDENTIFIED WITH 'mysql_native_password' BY 'strongpassword!';
CREATE USER 'replication'@'%' IDENTIFIED WITH 'mysql_native_password' BY 'repopass!';
GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%';
