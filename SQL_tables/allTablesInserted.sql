
--
--  Database Table Creation
--
--  First drop any existing tables. Any errors are ignored.
--
drop table Branch cascade constraints;
drop table VehicleType cascade constraints;
drop table Vehicle cascade constraints;
drop table EquipType cascade constraints;
drop table Equipment cascade constraints;
drop table EforV cascade constraints;


DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE ClubMember CASCADE CONSTRAINTS;
DROP TABLE Reservation CASCADE CONSTRAINTS;
DROP TABLE Reserve_Includes CASCADE CONSTRAINTS;
DROP TABLE Rent CASCADE CONSTRAINTS;
DROP TABLE CCard CASCADE CONSTRAINTS;
DROP TABLE Rent_Includes CASCADE CONSTRAINTS;
DROP TABLE ReturnV CASCADE CONSTRAINTS;
DROP TABLE TimePeriod CASCADE CONSTRAINTS;
DROP TABLE Account CASCADE CONSTRAINTS;

--
-- Now, add each table.
--
-- Branch (location, city) 
create table Branch(
    location varchar(200),
    city varchar(50),
    primary key(location,city));
-- VehicleType(vtname, features, wrate, drate, hrate, wirate, dirate, hirate, krate)) 
-- primary key vtname
create table VehicleType(
    vtname varchar(50) primary key,
    features varchar(300),
    wrate decimal check (wrate between 0 and 1000000),
    drate decimal check (drate between 0 and 1000000),
    hrate decimal check (hrate between 0 and 1000000),
    wirate decimal check (wirate between 0 and 1000000),
    dirate decimal check (dirate between 0 and 1000000),
    hirate decimal check (hirate between 0 and 1000000),
    krate decimal check (krate between 0 and 1000000));
-- Vehicle (vid, vlicense, make, model, year, color, odometer, status, vtname, location, city)  
-- primary key vid
-- foreignkey vtname refers to VehicleType
-- foreignkey location, city refers to Branch
create table Vehicle(
    vid varchar(10) check (vid between 0 and 9999999999) primary key,
    vlicense varchar(20),
    make varchar(20),
    model varchar(20),
    year int check (year between 1960 and 2020), -- year type is not supported??
    color varchar(20),
    odometer decimal check (odometer between 0 and 1000000),
    status varchar(8) check (status = 'for_rent' OR status = 'for_sale'),
    vtname varchar(50),
    foreign key(vtname) references VehicleType,
    location varchar(200),
    city varchar(50),
    foreign key (location,city) references Branch(location,city));

-- EquipType(etname, drate, hrate) 
-- primary key etname
create table EquipType(
    etname varchar(100) primary key,
    drate decimal check (drate between 0 and 1000000), 
    hrate decimal check (hrate between 0 and 1000000));

-- Equipment (eid, etname, status, location, city) 
-- primary key eid
-- foreign key etname, location, city
-- constraints: status can take the values ( available, rented, not_available)
create table Equipment (
    eid varchar(10) check (eid between 0 and 9999999999) primary key, 
    etname varchar(100),
    foreign key(etname) references EquipType(etname), 
    status varchar(15) check ((status = 'available') OR (status = 'not_available') OR (status = 'rented')) , 
    location varchar(200),
    city varchar(50),
    foreign key (location,city) references Branch(location,city));

-- EforV(etname, vtname)
create table EforV(
    etname varchar(100),
    vtname varchar(50),
    primary key(etname,vtname),
    foreign key(etname) references EquipType, 
    foreign key(vtname) references VehicleType);



CREATE TABLE TimePeriod(
    fromDate char(20),
    fromTime char(20),
    toDate char(20),
    toTime char(20),
    PRIMARY KEY (fromDate, fromTime, toDate, toTime)
);



CREATE TABLE CCard(
    cardNo varchar(16) check (cardNo between 0000000000000000 and 9999999999999999),
    ExpDate char(20) , -- TODO: CHECK (ExpDate >= SYSDATE)
    cardName CHAR(40),
    PRIMARY KEY(cardNo, ExpDate)
);

CREATE TABLE Customer(
    cellphone varchar(10) check (cellphone between 0 and 9999999999) primary key,
    cname CHAR(40),
    caddress VARCHAR(50),
    dlicense VARCHAR(20)
);

CREATE TABLE ClubMember(
    cellphone varchar(10) primary key,
    points INTEGER check (points BETWEEN 0 and 5000),
    fees NUMERIC check(fees BETWEEN 0  and 1000),
    FOREIGN KEY (cellphone) REFERENCES Customer
);

CREATE TABLE Reservation(
    confNo INTEGER CHECK (confNo BETWEEN 0 and POWER(10,20) - 1) PRIMARY KEY,
    vtname varchar(50),
    cellphone varchar(10),
    fromDate char(20),
    fromTime char(20),
    toDate char(20),
    toTime char(20),
    FOREIGN KEY (vtname) REFERENCES VehicleType,
    FOREIGN KEY (cellphone) REFERENCES Customer,
    FOREIGN KEY (fromDate, fromTime, toDate, toTime) REFERENCES TimePeriod
);

-- 

CREATE TABLE Reserve_Includes(
    confNo INT,
    etname varchar(100),
    PRIMARY KEY (confNo, etname),
    FOREIGN KEY (confNo) references Reservation,
    FOREIGN KEY (etname) references EquipType
);


--

CREATE TABLE Rent(
    rid VARCHAR(10) check (rid between 0 and 9999999999) PRIMARY KEY,
    vid VARCHAR(15),
    cellphone varchar(10),
    fromDate char(20),
    fromTime char(20),
    toDate char(20),
    toTime char(20),
    odometer DECIMAL CHECK (odometer between 0 and 1000000),
    cardNo varchar(16),
    ExpDate char(20),
    confNo INT,
    FOREIGN KEY (vid) REFERENCES Vehicle,
    FOREIGN KEY (cellphone) REFERENCES Customer,
    FOREIGN KEY (fromDate, fromTime, toDate, toTime) REFERENCES TimePeriod,
    FOREIGN KEY (cardNo, ExpDate) REFERENCES CCard,
    FOREIGN KEY (confNo) REFERENCES Reservation
);

CREATE TABLE Rent_Includes(
    rid VARCHAR(10),
    eid VARCHAR(10),
    PRIMARY KEY (rid, eid),
    FOREIGN KEY (rid) REFERENCES Rent,
    FOREIGN KEY (eid) REFERENCES Equipment
);

CREATE TABLE ReturnV(
    rid VARCHAR(10) PRIMARY KEY,
    dater char(20) , --CHECK (dater >= SYSDATE)
    timer char(20) , --CHECK (timer >= SYSDATE)
    odometer DECIMAL CHECK (odometer between 0 and 1000000),
    fulLTank varchar(3) check (fulLTank = 'yes' OR fulLTank = 'no'),
    FOREIGN KEY (rid) REFERENCES Rent
);

CREATE TABLE Account(
    username VARCHAR(15) CHECK (LENGTH(username) >= 6),
    upassword VARCHAR(30) CHECK (LENGTH(upassword) >= 10),
    PRIMARY KEY (username, upassword)
);



-- Insertion Branch
insert into Branch values('Vancouver International Airport', 'Vancouver');
insert into Branch values('UBC', 'Vancouver');  
insert into Branch values('Parliament', 'Ottawa');

-- Insertion VehicleType(vtname, features, wrate, drate, hrate, wirate, dirate, hirate, krate)) 
insert into VehicleType VALUES('Economy', 'Automatic Transmission, A/C, 4 Doors', 280.78, 32.90, 5.87, 20, 9, 0.99, 2.6);
insert into VehicleType VALUES('Compact', 'Stick, 2 Doors', 290.78, 33.90, 9.87, 9, 8, 1.23, 3.7);
insert into VehicleType VALUES('Mid-size', 'Automatic Transmission, 4 Doors ', 300.78, 41.90, 10.87, 9, 7.99, 4.23, 3.8);
insert into VehicleType VALUES('Standard', 'Automatic Transmission', 500.78, 300.90, 90.87, 10.87, 7.99, 4.23, 9.8);
insert into VehicleType VALUES('Fullsize', 'Automatic Transmission, 4 Doors, A/C, Child-safe', 450.78, 270.90, 90.87, 9, 7.99, 4.23, 9.8);
insert into VehicleType VALUES('SUV', 'Automatic Transmission, 4 Doors, A/C, Leather Seats', 1000.78, 300.90, 90.87, 9, 7.99, 4.23, 100);
insert into VehicleType VALUES('Truck', 'Stick, 2 Doors, 1t Storage, Winter Tires', 1000.78, 300.90, 90.87, 9, 7.99, 4.23, 100);

-- Insertion Vehicle (vid, vlicense, make, model, year, color, odometer, status, vtname, location, city)    
insert into Vehicle VALUES(0000000001, 25441163, 'BMW', 'X5', 2017, 'salmon', 9800, 'for_rent', 'SUV', 'UBC', 'Vancouver');
insert into Vehicle VALUES(9873124183, 25441162, 'Hyundai', 'Y998', 2009, 'gray', 19823, 'for_rent', 'Economy', 'Parliament', 'Ottawa');
insert into Vehicle VALUES(0000000002, 25441161, 'BMW', 'X5', 2017, 'salmon', 9800, 'for_sale', 'SUV', 'UBC', 'Vancouver');

-- Insert EquipType(etname, drate, hrate) 
insert into EquipType VALUES('Ski Rack', 23, 5.99);
insert into EquipType VALUES('Child Safety Seats', 39, 8.99);
insert into EquipType VALUES('Lift gate and Car-towing equipment', 68.99, 10.99);

-- Insertion Equipment (eid, etname, status, location, city) 
insert into Equipment VALUES(9999999999, 'Ski Rack', 'available', 'Vancouver International Airport', 'Vancouver');
insert into Equipment VALUES(9999999998, 'Ski Rack', 'not_available', 'Vancouver International Airport', 'Vancouver');
insert into Equipment VALUES(9999999997, 'Lift gate and Car-towing equipment', 'available', 'UBC', 'Vancouver');
insert into Equipment VALUES(0000000007, 'Child Safety Seats', 'rented', 'Parliament', 'Ottawa');

-- Insertion EforV(etname, vtname)
insert into EforV VALUES('Ski Rack', 'Economy');
insert into EforV VALUES('Child Safety Seats', 'Economy');
insert into EforV VALUES('Child Safety Seats', 'SUV');
insert into EforV VALUES('Child Safety Seats', 'Standard');
insert into EforV VALUES('Lift gate and Car-towing equipment', 'Truck');

-- tuples
-- customer

insert into Customer values (0000000000, 'c1', '101 1st ave', 'dl101');
INSERT into Customer values (1111111111, 'c2', 'fjioesjfoiejfoiwjf', 'dl204r34');


-- Clubmember
insert into Clubmember VALUES (0000000000, 450, 200);
insert into Clubmember VALUES (1111111111, 90, 3);


-- TimePeriod 
INSERT INTO TimePeriod VALUES (TO_DATE('2019-JAN-01', 'YYYY-MM-DD'),TO_DATE('00:00:00','HH24:MI:SS'),TO_DATE('2019-JAN-02', 'YYYY-MM-DD'),TO_DATE('00:00:10','HH24:MI:SS'));
INSERT INTO TimePeriod VALUES (TO_DATE('2018-JAN-01', 'YYYY-MM-DD'),TO_DATE('18:09:00','HH24:MI:SS'),TO_DATE('2019-JAN-03', 'YYYY-MM-DD'),TO_DATE('23:59:10','HH24:MI:SS'));


-- Reservation
insert into Reservation VALUES (101, 'Economy', 0000000000, TO_DATE('2019-JAN-01', 'YYYY-MM-DD'),TO_DATE('00:00:00','HH24:MI:SS'),TO_DATE('2019-JAN-02', 'YYYY-MM-DD'),TO_DATE('00:00:10','HH24:MI:SS'));
insert into Reservation VALUES (102, 'SUV', 1111111111, TO_DATE('2018-JAN-01', 'YYYY-MM-DD'),TO_DATE('18:09:00','HH24:MI:SS'),TO_DATE('2019-JAN-03', 'YYYY-MM-DD'),TO_DATE('23:59:10','HH24:MI:SS'));


-- Reserve_includes
INSERT into Reserve_Includes VALUES (101, 'Ski Rack');
INSERT into Reserve_Includes VALUES (102, 'Child Safety Seats');

--CCard
INSERT INTO CCard VALUES (1000200030004000, TO_DATE('2020-JAN-01', 'YYYY-MM-DD'), 'aaa');
INSERT INTO CCard VALUES (0, TO_DATE('2020-JAN-01', 'YYYY-MM-DD'), 'aaa');
INSERT INTO CCard VALUES (1, TO_DATE('2020-JAN-01', 'YYYY-MM-DD'), 'aaa');
INSERT INTO CCard VALUES (2000200030004000, TO_DATE('2020-FEB-01','YYYY-MM-DD'), 'bbb');



-- Rent
INSERT INTO Rent VALUES ('101',0000000001, 0000000000,TO_DATE('2019-JAN-01', 'YYYY-MM-DD'),TO_DATE('00:00:00','HH24:MI:SS'),TO_DATE('2019-JAN-02', 'YYYY-MM-DD'),TO_DATE('00:00:10','HH24:MI:SS'), 1.1, 1000200030004000, TO_DATE('2020-JAN-01','YYYY-MM-DD'), 101);
INSERT INTO Rent VALUES ('102',9873124183, 1111111111,TO_DATE('2018-JAN-01', 'YYYY-MM-DD'),TO_DATE('18:09:00','HH24:MI:SS'),TO_DATE('2019-JAN-03', 'YYYY-MM-DD'),TO_DATE('23:59:10','HH24:MI:SS'), 2.2, 2000200030004000, TO_DATE('2020-FEB-01','YYYY-MM-DD'), 102);


--Rent_Includes
INSERT INTO Rent_Includes VALUES ('101',9999999999);
INSERT INTO Rent_Includes VALUES ('102',9999999998);

-- ReturnV
INSERT INTO ReturnV VALUES ('101',TO_DATE('2020-JAN-01', 'YYYY-MM-DD'),TO_DATE('00:00:00', 'HH24:MI:SS'),12,'yes');
INSERT INTO ReturnV VALUES ('102',TO_DATE('2020-JAN-02', 'YYYY-MM-DD'),TO_DATE('00:00:01', 'HH24:MI:SS'),13,'no');

-- Account
INSERT INTO Account VALUES ('acc111', '000000000a');
INSERT INTO Account VALUES ('acc112', '000000000b');





