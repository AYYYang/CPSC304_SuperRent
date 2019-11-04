drop table Branch CASCADE CONSTRAINTS;
drop table VehicleType CASCADE CONSTRAINTS;
drop table Vehicle CASCADE CONSTRAINTS;
drop table EquipType CASCADE CONSTRAINTS;
drop table Equipment CASCADE CONSTRAINTS;
drop table EforV CASCADE CONSTRAINTS;


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
