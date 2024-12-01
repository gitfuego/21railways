CREATE DATABASE  IF NOT EXISTS TrainStations
use TrainStations;

drop table if exists Stops;
drop table if exists Reservation;
drop table if exists Tschedule;
drop table if exists Customer;
drop table if exists Employee;
drop table if exists Station;
drop table if exists Train;

create table Station (
	sid int primary key, 
    name varchar(50), 
    city varchar(50), 
    state varchar(50)
) engine = InnoDB;

create table Train(
	tid int primary key
)engine = InnoDB;

create table Customer (
	username varchar(50) primary key, 
    password varchar(50), 
    email varchar(50), 
    fname varchar(50), 
    name varchar(50)
) engine = InnoDB;

create table Employee (
	username varchar(50) primary key, 
    password varchar(50), 
    ssn varchar(11), 
    fname varchar(50), 
    name varchar(50), 
    role enum('manager', 'customer_rep')
) engine = InnoDB;

create table Tschedule (
	schedule_id int primary key, 
    transit_line varchar(50), 
    origin_id int, 
    destination_id int, 
    base_fare double, 
    origin_departure datetime, 
    origin_arrival datetime,
    destination_departure datetime, 
    destination_arrival datetime,
    train_id int, 
    foreign key (origin_id) references Station(sid),
	foreign key (train_id) references Train(tid)
    ) engine = InnoDB;
    
create table Stops (
	stop_id int primary key, 
    station_id int, 
    schedule_id int, 
    stop_sequence_num int, 
    arrival datetime, 
    departure datetime, 
    foreign key (station_id) references Station(sid), 
    foreign key (schedule_id) references Tschedule(schedule_id)
) engine = InnoDB;

create table Reservation (
	rid int primary key, 
    passenger varchar(50),
	total_fare double, 
    date_made datetime, 
    schedule_id int,
	canceled boolean, 
    oversees varchar(50), 
    trip_type enum('oneway', 'roundtrip'), 
	foreign key (schedule_id) references Tschedule(schedule_id),
    foreign key (passenger) references Customer(username), 
	foreign key (oversees) references Employee(username)
) engine = InnoDB;



delete from Employee;

insert into Employee(username, password) values
('mcarpenter', 'group21!'),
    ('Ade', 'group21!'),
    ('Ras', 'group21!'),
    ('Pavan', 'group21!');