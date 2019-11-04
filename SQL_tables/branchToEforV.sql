--
-- 	Database Table Creation
--
--  First drop any existing tables. Any errors are ignored.
--
drop table Branch cascade constraints;
drop table VehicleType cascade constraints;
drop table Vehicle cascade constraints;
drop table EquipType cascade constraints;
drop table Equipment cascade constraints;
drop table EforV cascade constraints;

--
-- Now, add each table.
--
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
	features varchar(300),
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
	vid varchar(10) check (vid between 0 and 9999999999) primary key,
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
	eid varchar(10) check (eid between 0 and 9999999999) primary key, 
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


-- Insertion Branch
insert into Branch values("Vancouver International Airport", "Vancouver");
insert into Branch values("UBC", "Vancouver");	
insert into Branch values("Parliament", "Ottawa");

-- Insertion VehicleType(vtname, features, wrate, drate, hrate, wirate, dirate, hirate, krate)) 
insert into VehicleType("Economy", "Automatic Transmission, A/C, 4 Doors", 280.78, 32.90, 5.87, 20, 9, 0.99, 2.6)
insert into VehicleType("Compact", "Stick, 2 Doors", 290.78, 33.90, 9.87, 9, 8, 1.23, 3.7)
insert into VehicleType("Mid-size", "Automatic Transmission, 4 Doors ", 300.78, 41.90, 10.87, 9, 7.99, 4.23, 3.8)
insert into VehicleType("Standard", "Automatic Transmission", 500.78, 300.90, 90.87, , 7.99, 4.23, 9.8)
insert into VehicleType("Fullsize", "Automatic Transmission, 4 Doors, A/C, Child-safe", 450.78, 270.90, 90.87, 9, 7.99, 4.23, 9.8)
insert into VehicleType("SUV", "Automatic Transmission, 4 Doors, A/C, Leather Seats", 1000.78, 300.90, 90.87, 9, 7.99, 4.23, 100)
insert into VehicleType("Truck", "Stick, 2 Doors, 1t Storage, Winter Tires", 1000.78, 300.90, 90.87, 9, 7.99, 4.23, 100)

-- Insertion Vehicle (vid, vlicense, make, model, year, color, odometer, status, vtname, location, city) 	
insert into Vehicle(0000000001, 25441163, "BMW", "X5", 2017, "salmon", 9800, "for_rent", "SUV", "UBC", "Vancouver")
insert into Vehicle(9873124183, 25441162, "Hyundai", "Y998", 2009, "gray", 19823, "for_rent", "Economy", "Parliament", "Ottawa")
insert into Vehicle(0000000002, 25441161, "BMW", "X5", 2017, "salmon", 9800, "for_sale", "SUV", "UBC", "Vancouver")

-- Insert EquipType(etname, drate, hrate) 
insert into EquipType("Ski Rack", 23, 5.99)
insert into EquipType("Child Safety Seats", 39, 8.99)
insert into EquipType("Lift gate and Car-towing equipment", 68.99, 10.99)

-- Insertion Equipment (eid, etname, status, location, city) 
insert into Equipment(9999999999, "Ski Rack", "available", "Vancouver International Airport", "Vancouver")
insert into Equipment(9999999998, "Ski Rack", "not_available", "Vancouver International Airport", "Vancouver")
insert into Equipment(9999999997, "Lift gate and Car-towing equipment", "available", "UBC", "Vancouver")
insert into Equipment(0000000007, "Child Safety Seats", "rented", "Parliament", "Ottawa")

-- Insertion EforV(etname, vtname)
insert into EforV("Ski Rack", "Economy")
insert into EforV("Child Safety Seats", "Economy")
insert into EforV("Child Safety Seats", "SUV")
insert into EforV("Child Safety Seats", "Standard")
insert into EforV("Lift gate and Car-towing equipment", "Truck")






















