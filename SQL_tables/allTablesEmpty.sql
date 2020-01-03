drop table Branch CASCADE CONSTRAINTS;
drop table VehicleType CASCADE CONSTRAINTS;
drop table Vehicle CASCADE CONSTRAINTS;
drop table EquipType CASCADE CONSTRAINTS;
drop table Equipment CASCADE CONSTRAINTS;
drop table EforV CASCADE CONSTRAINTS;

DROP TABLE Customer CASCADE CONSTRAINTS
DROP TABLE ClubMember CASCADE CONSTRAINTS
DROP TABLE Reservation CASCADE CONSTRAINTS
DROP TABLE Reserve_Includes CASCADE CONSTRAINTS
DROP TABLE Rent CASCADE CONSTRAINTS
DROP TABLE CCard CASCADE CONSTRAINTS
DROP TABLE Rent_Includes CASCADE CONSTRAINTS
DROP TABLE ReturnV CASCADE CONSTRAINTS
DROP TABLE TimePeriod CASCADE CONSTRAINTS
DROP TABLE Account CASCADE CONSTRAINTS


--  AMANDA 
-- Branch (location, city) 
create table Branch(
    location varchar(200),
    city varchar(50),
    primary key(location,city),
    );
-- VehicleType(vtname, features, wrate, drate, hrate, wirate, dirate, hirate, krate)) 
-- primary key vtname
create table VehicleType(
    vtname varchar(50) primary key,
    features varchar(50),
    wrate decimal check (wrate between 0 and 10^38 -1),
    drate decimal check (drate between 0 and 10^38 -1),
    hrate decimal check (hrate between 0 and 10^38 -1),
    wirate decimal check (wirate between 0 and 10^38 -1),
    dirate decimal check (dirate between 0 and 10^38 -1),
    hirate decimal check (hirate between 0 and 10^38 -1),
    krate decimal check (krate between 0 and 10^38 -1),
);
-- Vehicle (vid, vlicense, make, model, year, color, odometer, status, vtname, location, city)  
-- primary key vid
-- foreignkey vtname refers to VehicleType
-- foreignkey location, city refers to Branch
create table Vehicle(
    vid int check (vid between 0 and 9999999999) primary key,
    vlicense varchar(20),
    make varchar(20),
    model varchar(20),
    year int check (year between 1960 and 2020), -- year type is not supported??
    color varchar(20),
    odometer decimal check (wirate between 0 and 10^38 -1),
    status varchar check (status = "for_rent" OR status = "for_sale"),
    vtname varchar(50),
    foreign key(vtname) references VehicleType,
    location varchar(200),
    city varchar(50),
    foreign key(location) references Branch(location),
    foreign key(city) references Branch(city),
);

-- EquipType(etname, drate, hrate) 
-- primary key etname
create table EquipType(
    etname varchar(20) primary key,
    drate decimal check (drate between 0 and 10^38 -1), 
    hrate decimal check (krate between 0 and 10^38 -1),
);

-- Equipment (eid, etname, status, location, city) 
-- primary key eid
-- foreign key etname, location, city
-- constraints: status can take the values ( available, rented, not_available)
create table Equipment (
    eid int check (eid between 0 and 9999999999) primary key, 
    etname varchar(20),
    foreign key(etname) references EquipType(etname), 
    status varchar check (status = "available" OR status = "not_available" OR status = "rented"), 
    location varchar(200),
    city varchar(50),
    foreign key fk_Branch(location,city) references Branch(location,city),
);

-- EforV(etname, vtname)
create table EforV(
    etname varchar(20),
    vtname varchar(50),
    primary key(etname,vtname),
    foreign key(etname) references EquipType, 
    foreign key(vtname) references VehicleType,
);


-- CINDY

CREATE TABLE Customer(
    cellphone INTEGER check (LEN(cellphone) = 10) PRIMARY KEY,
    cname CHAR(40),
    caddress VARCHAR(50),
    dlicense VARCHAR(20)
);

CREATE TABLE ClubMember(
    cellphone INTEGER,
    points INTEGER check (points BETWEEN 0 and 5000),
    fees NUMERIC check(fees BETWEEN 0  and 1000),
    FOREIGN KEY (cellphone) REFERENCES Customer
);

CREATE TABLE Reservation(
    confNo INTEGER CHECK (confNo BETWEEN 0 and 10^20 - 1) PRIMARY KEY,
    vtname varchar(50),
    cellphone INTEGER,
    fromDate DATE,
    fromTime TIME,
    toDate DATE,
    toTime TIME,
    FOREIGN KEY (vtname) REFERENCES VehicleType,
    FOREIGN KEY (cellphone) REFERENCES Customer,
    FOREIGN KEY (fromDate, fromTime, toDate, toTime) REFERENCES TimePeriod
);

CREATE TABLE Reserve_Includes(
    confNo INT,
    etname CHAR(20),
    PRIMARY KEY (confNo, etname),
    FOREIGN KEY (confNo) references Reservation,
    FOREIGN KEY (etname) references EquipType
);

CREATE TABLE TimePeriod(
    fromDate DATE,
    fromTime TIME,
    toDate DATE,
    toTime TIME,
    PRIMARY KEY (fromDate, fromTime, toDate, toTime)
);

CREATE TABLE Rent(
    rid VARCHAR(15) check (rid BETWEEN 0 and 10^38- 1) PRIMARY KEY,
    vid VARCHAR(15),
    cellphone INTEGER,
    fromDate DATE,
    fromTime TIME,
    toDate DATE,
    toTime TIME,
    odometer DECIMAL CHECK (odometer BETWEEN 0 AND 10^5 -1),
    cardNo INT,
    ExpDate DATE,
    confNo INT NOT NULL,
    FOREIGN KEY (vid) REFERENCES Vehicle,
    FOREIGN KEY (cellphone) REFERENCES Customer,
    FOREIGN KEY (fromDate, fromTime, toDate, toTime) REFERENCES TimePeriod,
    FOREIGN KEY (cardNo, ExpDate) REFERENCES CCard,
    FOREIGN KEY (confNo) REFERENCES Reserve_Includes
);

CREATE TABLE CCard(
    cardNo INT CHECK (cardNo between 10^12 + 1 and 10^13 -1),
    ExpDate DATE CHECK (ExpDate >= SYSTEM_TIME),
    cardName CHAR(40)
    PRIMARY KEY (cardNo, ExpDate)
);

CREATE TABLE Rent_Includes(
    rid VARCHAR(15),
    eid VARCHAR(15),
    PRIMARY KEY (rid, eid),
    FOREIGN KEY (rid) REFERENCES Rent,
    FOREIGN KEY (eid) REFERENCES Equipment
)

CREATE TABLE ReturnV(
    rid VARCHAR(15) PRIMARY KEY,
    dater DATE CHECK (dater >= SYSTEM_TIME),
    timer TIME CHECK (timer >= SYSTEM_TIME),
    odometer DECIMAL CHECK (odometer BETWEEN 0 AND 10^5 -1),
    fulLTank BINARY,
    FOREIGN KEY (rid) REFERENCES Rent
);

CREATE TABLE Account(
    username VARCHAR(15) CHECK (LEN(username) >= 6),
    upassword VARCHAR(30) CHECK (LEN(upassword) >= 10),
    PRIMARY KEY (username, upassword)
)

