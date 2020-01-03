
--
--  Database Table Creation

drop table Branch cascade constraints;
drop table VehicleType cascade constraints;
drop table Vehicle cascade constraints;
drop SEQUENCE res_sequence;
drop trigger res_trigger;
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE Reservation CASCADE CONSTRAINTS;
DROP TABLE Rent CASCADE CONSTRAINTS;
DROP TABLE ReturnV CASCADE CONSTRAINTS;
DROP TABLE TimePeriod CASCADE CONSTRAINTS;
DROP TABLE Account CASCADE CONSTRAINTS;

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

-- Vehicle (vlicense, make, model, year, color, odometer, status, vtname, location, city)  
-- primary key vlicense
-- foreignkey vtname refers to VehicleType
-- foreignkey location, city refers to Branch
create table Vehicle(
    vlicense varchar(8) primary key,
    make varchar(20),
    model varchar(20),
    year int check (year between 1960 and 2020),
    color varchar(20),
    odometer decimal check (odometer between 0 and 1000000),
    status varchar(20) check (status = 'available' OR status = 'maintenance' OR status ='rented'),
    vtname varchar(50),
    foreign key(vtname) references VehicleType,
    location varchar(200),
    city varchar(50),
    foreign key (location,city) references Branch(location,city));


CREATE TABLE TimePeriod(
    fromDate char(20),
    fromTime char(20),
    toDate char(20),
    toTime char(20),
    PRIMARY KEY (fromDate, fromTime, toDate, toTime)
);


CREATE TABLE Customer(
    cellphone varchar(10) check (cellphone between 0 and 9999999999),
    cname CHAR(40),
    caddress VARCHAR(50),
    dlicense VARCHAR(20) primary key
);


CREATE TABLE Reservation(
    confNo INTEGER CHECK (confNo BETWEEN 0 and 1000000000000000) PRIMARY KEY, -- PRIMARY KEY,
    vtname varchar(50),
    dlicense VARCHAR(20),
    fromDate char(20),
    fromTime char(20),
    toDate char(20),
    toTime char(20),
    FOREIGN KEY (vtname) REFERENCES VehicleType,
    FOREIGN KEY (dlicense) REFERENCES Customer,
    FOREIGN KEY (fromDate, fromTime, toDate, toTime) REFERENCES TimePeriod
);

CREATE SEQUENCE res_sequence
  START WITH 1
  INCREMENT BY 1
  CACHE 1000000000000000;

CREATE OR REPLACE TRIGGER res_trigger
  BEFORE INSERT ON Reservation
  FOR EACH ROW
BEGIN
  SELECT res_sequence.nextval
    INTO :new.confNo
    FROM dual;
END;
/


CREATE TABLE Rent(
    rid VARCHAR(10) check (rid between 0 and 9999999999) PRIMARY KEY,
    vlicense varchar(8),
    dlicense VARCHAR(20),
    fromDate char(20),
    fromTime char(20),
    toDate char(20),
    toTime char(20),
    odometer DECIMAL CHECK (odometer between 0 and 1000000),
    confNo INT,
    FOREIGN KEY (vlicense) REFERENCES Vehicle,
    FOREIGN KEY (dlicense) REFERENCES Customer,
    FOREIGN KEY (fromDate, fromTime, toDate, toTime) REFERENCES TimePeriod,
    FOREIGN KEY (confNo) REFERENCES Reservation
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

-- Insertion Vehicle ( vlicense, make, model, year, color, odometer, status, vtname, location, city)    
insert into Vehicle VALUES(2541163, 'BMW', 'X5', 2017, 'salmon', 9800, 'available', 'SUV', 'UBC', 'Vancouver');
insert into Vehicle VALUES(2541162, 'Hyundai', 'Y998', 2009, 'gray', 19823, 'available', 'Economy', 'Parliament', 'Ottawa');
insert into Vehicle VALUES(2541161, 'BMW', 'X5', 2017, 'salmon', 9800, 'maintenance', 'SUV', 'UBC', 'Vancouver');
insert into Vehicle VALUES(2541160, 'BMW', 'X5', 2016, 'red', 9800, 'rented', 'Economy', 'Vancouver International Airport', 'Vancouver');


insert into Customer values (0000000000, 'c1', '101 1st ave', 'dl101');
INSERT into Customer values (1111111111, 'c2', 'fjioesjfoiejfoiwjf', 'dl204r34');


-- TimePeriod 
INSERT INTO TimePeriod VALUES (TO_DATE('2019-JAN-01', 'YYYY-MM-DD'),TO_DATE('00:00:00','HH24:MI:SS'),TO_DATE('2019-JAN-02', 'YYYY-MM-DD'),TO_DATE('00:00:10','HH24:MI:SS'));
INSERT INTO TimePeriod VALUES (TO_DATE('2018-JAN-01', 'YYYY-MM-DD'),TO_DATE('18:09:00','HH24:MI:SS'),TO_DATE('2019-JAN-03', 'YYYY-MM-DD'),TO_DATE('23:59:10','HH24:MI:SS'));

INSERT INTO Reservation(vtname, dlicense, fromDate, fromTime, toDate, toTime)
  VALUES( 'Economy', 'dl101', TO_DATE('2019-JAN-01', 'YYYY-MM-DD'),TO_DATE('00:00:00','HH24:MI:SS'),TO_DATE('2019-JAN-02', 'YYYY-MM-DD'),TO_DATE('00:00:10','HH24:MI:SS'));
INSERT INTO Reservation( vtname, dlicense, fromDate, fromTime, toDate, toTime)
  VALUES( 'SUV', 'dl204r34', TO_DATE('2018-JAN-01', 'YYYY-MM-DD'),TO_DATE('18:09:00','HH24:MI:SS'),TO_DATE('2019-JAN-03', 'YYYY-MM-DD'),TO_DATE('23:59:10','HH24:MI:SS'));

-- Rent
INSERT INTO Rent (rid, vlicense, dlicense, fromDate, fromTime, toDate, toTime, odometer)
VALUES ('1182', 2541160, 'dl101',TO_DATE('2019-JAN-01', 'YYYY-MM-DD'),TO_DATE('00:00:00','HH24:MI:SS'),TO_DATE('2019-JAN-02', 'YYYY-MM-DD'),TO_DATE('00:00:10','HH24:MI:SS'), 1.1);
-- INSERT INTO Rent VALUES ('7762',2541163, 'dl204r34',TO_DATE('2018-JAN-01', 'YYYY-MM-DD'),TO_DATE('18:09:00','HH24:MI:SS'),TO_DATE('2019-JAN-03', 'YYYY-MM-DD'),TO_DATE('23:59:10','HH24:MI:SS'), 2.2);
INSERT INTO Rent (rid, vlicense, dlicense, fromDate, fromTime, toDate, toTime, odometer)
VALUES ('7762',2541163, 'dl204r34',TO_DATE('2018-JAN-01', 'YYYY-MM-DD'),TO_DATE('18:09:00','HH24:MI:SS'),TO_DATE('2019-JAN-03', 'YYYY-MM-DD'),TO_DATE('23:59:10','HH24:MI:SS'), 2.2);
--Rent_Includes
-- INSERT INTO Rent_Includes VALUES ('101',9999999999);
-- INSERT INTO Rent_Includes VALUES ('102',9999999998);

-- ReturnV
INSERT INTO ReturnV VALUES ('1182',TO_DATE('2020-JAN-01', 'YYYY-MM-DD'),TO_DATE('00:00:00', 'HH24:MI:SS'),12,'yes');
INSERT INTO ReturnV VALUES ('7762',TO_DATE('2020-JAN-02', 'YYYY-MM-DD'),TO_DATE('00:00:01', 'HH24:MI:SS'),13,'no');

-- Account
INSERT INTO Account VALUES ('acc111', '000000000a');
INSERT INTO Account VALUES ('acc112', '000000000b');





