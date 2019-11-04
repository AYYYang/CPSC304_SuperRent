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





