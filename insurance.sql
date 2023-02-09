CREATE DATABASE insurance;
USE insurance;

CREATE TABLE IF NOT EXISTS person (
driver_id VARCHAR(255) NOT NULL,
driver_name TEXT NOT NULL,
address TEXT NOT NULL,
PRIMARY KEY (driver_id)
);

CREATE TABLE IF NOT EXISTS car (
reg_no VARCHAR(255) NOT NULL,
model TEXT NOT NULL,
c_year INTEGER,
PRIMARY KEY (reg_no)
);

CREATE TABLE IF NOT EXISTS accident (
report_no INTEGER NOT NULL,
accident_date DATE,
location TEXT,
PRIMARY KEY (report_no)
);

CREATE TABLE IF NOT EXISTS owns (
driver_id VARCHAR(255) NOT NULL,
reg_no VARCHAR(255) NOT NULL,
FOREIGN KEY (driver_id) REFERENCES person(driver_id) ON DELETE CASCADE,
FOREIGN KEY (reg_no) REFERENCES car(reg_no) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS participated (
driver_id VARCHAR(255) NOT NULL,
reg_no VARCHAR(255) NOT NULL,
report_no INTEGER NOT NULL,
damage_amount FLOAT NOT NULL,
FOREIGN KEY (driver_id) REFERENCES person(driver_id) ON DELETE CASCADE,
FOREIGN KEY (reg_no) REFERENCES car(reg_no) ON DELETE CASCADE,
FOREIGN KEY (report_no) REFERENCES accident(report_no)
);

INSERT INTO person VALUES
("D111", "Driver_1", "Kuvempunagar, Mysuru"),
("D222", "Smith", "JP Nagar, Mysuru"),
("D333", "Driver_3", "Udaygiri, Mysuru"),
("D444", "Driver_4", "Rajivnagar, Mysuru"),
("D555", "Driver_5", "Vijayanagar, Mysore");

INSERT INTO car VALUES
("KA-20-AB-4223", "Swift", 2020),
("KA-20-BC-5674", "Mazda", 2017),
("KA-21-AC-5473", "Alto", 2015),
("KA-21-BD-4728", "Triber", 2019),
("KA-09-MA-1234", "Tiago", 2018);

INSERT INTO accident VALUES
(43627, "2020-04-05", "Nazarbad, Mysuru"),
(56345, "2019-12-16", "Gokulam, Mysuru"),
(63744, "2020-05-14", "Vijaynagar, Mysuru"),
(54634, "2019-08-30", "Kuvempunagar, Mysuru"),
(65738, "2021-01-21", "JSS Layout, Mysuru"),
(66666, "2021-01-21", "JSS Layout, Mysuru");

INSERT INTO owns VALUES
("D111", "KA-20-AB-4223"),
("D222", "KA-20-BC-5674"),
("D333", "KA-21-AC-5473"),
("D444", "KA-21-BD-4728"),
("D222", "KA-09-MA-1234");

INSERT INTO participated VALUES
("D111", "KA-20-AB-4223", 43627, 20000),
("D222", "KA-20-BC-5674", 56345, 49500),
("D333", "KA-21-AC-5473", 63744, 15000),
("D444", "KA-21-BD-4728", 54634, 5000),
("D222", "KA-09-MA-1234", 65738, 25000);


select count(distinct p.driver_id) from participated p,accident a where p.report_no=a.report_no and a.accident_date like "%2021%";


select count(p.driver_id) from participated p,person pe where p.driver_id=pe.driver_id and pe.driver_name="Smith";

insert into accident values(45568, "2024-04-05", "Mandya"); 
insert into participated values ("D333", "KA-21-BD-4728", 45562, 50000);

delete from car where reg_no in(select car.reg_no from owns o,person p where p.driver_id=o.driver_id and car.reg_no=o.reg_no and car.model="Mazda" and p.driver_name="Smith");


update participated set damage_amount=10000 where report_no=65738 and reg_no="KA-09-MA-1234";

create view model_year as select model,c_year from car c,participated p where p.reg_no=c.reg_no;

DELIMITER //
create trigger PreventParticipation
before insert on participated
for each row
BEGIN
	IF 3<=(select count(*) from participated where driver_id=new.driver_id) THEN
		signal sqlstate '45000' set message_text='Driver has already participated in 2 accidents';
	END IF;
END;//
DELIMITER ;