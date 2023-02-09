create database sailors;
use sailors;

create table if not exists Sailors(
	sid int primary key,
	sname varchar(35) not null,
	rating float not null,
	age int not null
);

create table if not exists Boat(
	bid int primary key,
	bname varchar(35) not null,
	color varchar(25) not null
);

create table if not exists reserves(
	sid int not null,
	bid int not null,
	sdate date not null,
	foreign key (sid) references Sailors(sid) on delete cascade,
	foreign key (bid) references Boat(bid) on delete cascade
);

insert into Sailors values
(1,"Albert", 5.0, 40),
(2, "veeresh", 5.0, 49),
(3, "Darshan", 9, 18),
(4, "Vamshi", 2, 68),
(5, "Alex", 7, 19);


insert into Boat values
(1,"Boat_1", "Green"),
(2,"Boat_2", "Red"),
(103,"Boat_3", "Blue");

insert into reserves values
(1,103,"2023-01-01"),
(1,2,"2023-02-01"),
(2,1,"2023-02-05"),
(3,2,"2023-03-06"),
(5,103,"2023-03-06"),
(1,1,"2023-03-06");


select color from Boat b,Sailors s,Reserves r where r.sid=s.sid and r.bid=b.bid and s.sname="Albert";

select sid from Sailors s where s.rating>=8 UNION select distinct(r.sid) from Reserves r where r.bid=103;

select s.sname from Sailors s where sid in(select s.sid from Sailors s where s.sid not in(select r.sid from Reserves r,boat b where r.bid=b.bid and b.bname like "%2%")) ORDER BY(sname);

 select sname from Sailors s where not exists (select * from Boat b where not exists (select * from Reserves r where r.sid=s.sid and b.bid=r.bid));


select sname,age from Sailors s order by(s.age) DESC LIMIT 1;

 select b.bid, avg(s.age) as average_age from Sailors s, Boat b, Reserves r where r.sid=s.sid and r.bid=b.bid and s.age>=40 group by bid having count(distinct r.sid)>=5;


DELIMITER //
create or replace trigger CheckAndDelete
before delete on Boat
for each row
BEGIN
	IF EXISTS (select * from reserves where reserves.bid=old.bid) THEN
		SIGNAL SQLSTATE '45000' SET message_text='Boat is reserved and hence cannot be deleted';
	END IF;
END;//

DELIMITER ;
