import ballerinax/mysql;
import ballerinax/mysql.driver as _;

final mysql:Client uoeDB = check new ("localhost", "demouser", "demo_pass123", "demo1", 3306);