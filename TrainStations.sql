CREATE DATABASE  IF NOT EXISTS TrainStations;
use TrainStations;

drop table if exists Stops;
drop table if exists Reservation;
drop table if exists Tschedule;
drop table if exists Customer;
drop table if exists Employee;
drop table if exists Station;
drop table if exists Train;

create table Station (
	sid int primary key not null auto_increment, 
    name varchar(50) not null, 
    city varchar(50) not null, 
    state varchar(50) not null
) engine = InnoDB;

create table Train(
	tid int primary key
)engine = InnoDB;

create table Customer (
	username varchar(50) primary key, 
    password varchar(50) not null, 
    email varchar(50), 
    fname varchar(50), 
    name varchar(50)
) engine = InnoDB;

create table Employee (
	username varchar(50) primary key, 
    password varchar(50) not null, 
    ssn varchar(11), 
    fname varchar(50), 
    name varchar(50), 
    role enum('manager', 'customer_rep') not null
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


-- -----------------------------------------------
--	Data Insertion								--
-- -----------------------------------------------

#Atlantic City Line, Bergen County Line, Gladstone Branch, Main Line, 
#Meadowlands Rail Line, Montclair-Boonton Line, Morristown Line, 
#Northeast Corridor Line, North Jersey Coastal Line, Pascack Valley Line, 
#Raritan Valley Line

-- ------------------------------------------------
--	(sid int, name varchar, city varchar, state varchar)
	--									 --
-- ------------------------------------------------

insert into Station (name, city, state) Values
  ('Atlantic City Station', 'Atlantic City', 'NJ'),
  ('Absecon Station', 'Absecon', 'NJ'),
  ('Egg Harbor City Station', 'Egg Harbor City', 'NJ'),
  ('Hammonton Station', 'Hammonton', 'NJ'),
  ('Atco Station', 'Atco', 'NJ'),
  ('Lindenwold Station', 'Lindenwold', 'NJ'),
  ('Cherry Hill Station', 'Cherry Hill', 'NJ'), 
  ('Pennsauken Transit Center Station', 'Pennsauken', 'NJ'),
  ('William H. Gray III 30th Street Station', 'Philadelphia', 'PA'),
  ('36th Street Station', 'Camden', 'NJ'),
  ('Aberdeen-Matawan Station', 'Aberdeen', 'NJ'), 
  ('Absecon Station', 'Absecon', 'NJ'), 
  ('Allenhurst Station', 'Allenhurst', 'NJ'),
  ('Allendale Station', 'Allendale', 'NJ'),
  ('Anderson St - Hackensack Station', 'Hackensack', 'NJ'),
  ('Annandale Station', 'Clinton Township', 'NJ'), 
  ('Aquarium Station', 'Camden', 'NJ'),
  ('Asbury Park Station', 'Asbury Park', 'NJ'),
  ('Atco Station', 'Atco', 'NJ'), 
  ('Atlantic City Station', 'Atlantic City', 'NJ'),
  ('Avenel Station', 'Avenel', 'NJ'),
  ('Bay Head Station', 'Bay Head', 'NJ'),
  ('Bay Street Station', 'Montclair', 'NJ'), 
  ('Belmar Station', 'Belmar', 'NJ'),
  ('Berkeley Heights Station', 'Berkeley Heights', 'NJ'),
  ('Bernardsville Station', 'Bernardsville', 'NJ'),
  ('Beverly - Edgewater Park Station', 'Beverly', 'NJ'), 
  ('Bloomfield Station', 'Bloomfield', 'NJ'),
  ('Boonton Station', 'Boonton', 'NJ'),
  ('Bordentown Station', 'Bordentown', 'NJ'),
  ('Bound Brook Station', 'Bound Brook', 'NJ'),
  ('Bradley Beach Station', 'Bradley Beach', 'NJ'),
  ('Brick Church Station', 'East Orange', 'NJ'), 
  ('Bridgewater Station', 'Bridgewater', 'NJ'),
  ('Broadway - Fair Lawn Station', 'Fair Lawn', 'NJ'),
  ('Burlington South Station', 'Burlington', 'NJ'),
  ('Burlington Town Centre Station', 'Burlington', 'NJ'), 
  ('Campbell Hall Station', 'Campbell Hall', 'NY'),
  ('Cass Street Station', 'Trenton', 'NJ'),
  ('Chatham Station', 'Chatham', 'NJ'),
  ('Cherry Hill Station', 'Cherry Hill', 'NJ'),
  ('Cinnaminson Station', 'Cinnaminson', 'NJ'),
  ('Clifton Station', 'Clifton', 'NJ'),
  ('Convent Station', 'Morris Township', 'NJ'), 
  ('Cooper St - Rutgers Station', 'Camden', 'NJ'),
  ('Cranford Station', 'Cranford', 'NJ'),
  ('Delanco Station', 'Delanco', 'NJ'),
  ('Delawanna Station', 'Clifton', 'NJ'), 
  ('Denville Station', 'Denville', 'NJ'),
  ('Dover Station', 'Dover', 'NJ'),
  ('Dunellen Station', 'Dunellen', 'NJ'),
  ('East Orange Station', 'East Orange', 'NJ'),
  ('Edison Station', 'Edison', 'NJ'),
  ('Egg Harbor City Station', 'Egg Harbor City', 'NJ'),
  ('Elizabeth Station', 'Elizabeth', 'NJ'),
  ('Elberon Station', 'Long Branch', 'NJ'), 
  ('Emerson Station', 'Emerson', 'NJ'),
  ('Entertainment Center Station', 'Camden', 'NJ'),
  ('Essex St - Hackensack Station', 'Hackensack', 'NJ'),
  ('Fanwood Station', 'Fanwood', 'NJ'),
  ('Far Hills Station', 'Far Hills', 'NJ'),
  ('Florence Station', 'Florence Township', 'NJ'), 
  ('Garfield Station', 'Garfield', 'NJ'),
  ('Garwood Station', 'Garwood', 'NJ'),
  ('Gillette Station', 'Long Hill Township', 'NJ'), 
  ('Gladstone Station', 'Peapack and Gladstone', 'NJ'), 
  ('Glen Ridge Station', 'Glen Ridge', 'NJ'),
  ('Glen Rock - Boro Hall Station', 'Glen Rock', 'NJ'),
  ('Glen Rock - Main Line Station', 'Glen Rock', 'NJ'),
  ('Hackettstown Station', 'Hackettstown', 'NJ'),
  ('Hamilton Station', 'Hamilton', 'NJ'),
  ('Hamilton Ave Station', 'Trenton', 'NJ'),
  ('Hammonton Station', 'Hammonton', 'NJ'),
  ('Harriman Station', 'Harriman', 'NY'),
  ('Hawthorne Station', 'Hawthorne', 'NJ'),
  ('High Bridge Station', 'High Bridge', 'NJ'),
  ('Highland Ave Station', 'Orange', 'NJ'), 
  ('Hillsdale Station', 'Hillsdale', 'NJ'),
  ('Ho-Ho-Kus Station', 'Ho-Ho-Kus', 'NJ'),
  ('Hoboken Station', 'Hoboken', 'NJ'),
  ('Jersey Ave Station', 'New Brunswick', 'NJ'), 
  ('Kingsland Station', 'Lyndhurst', 'NJ'), 
  ('Lake Hopatcong Station', 'Lake Hopatcong', 'NJ'), 
  ('Lebanon Station', 'Lebanon', 'NJ'), 
  ('Linden Station', 'Linden', 'NJ'),
  ('Lindenwold Station', 'Lindenwold', 'NJ'),
  ('Lincoln Park Station', 'Lincoln Park', 'NJ'),
  ('Little Falls Station', 'Little Falls', 'NJ'),
  ('Little Silver Station', 'Little Silver', 'NJ'),
  ('Long Branch Station', 'Long Branch', 'NJ'),
  ('Lyndhurst Station', 'Lyndhurst', 'NJ'),
  ('Lyons Station', 'Bernards Township', 'NJ'), 
  ('Madison Station', 'Madison', 'NJ'),
  ('Mahwah Station', 'Mahwah', 'NJ'),
  ('Manasquan Station', 'Manasquan', 'NJ'),
  ('Maplewood Station', 'Maplewood', 'NJ'),
  ('Metuchen Station', 'Metuchen', 'NJ'),
  ('Metropark Station', 'Iselin', 'NJ'), 
  ('Middletown Station', 'Middletown', 'NJ'),
  ('Millburn Station', 'Millburn', 'NJ'),
  ('Millington Station', 'Long Hill Township', 'NJ'), 
  ('Montclair Heights Station', 'Montclair', 'NJ'),
  ('Montclair State Univ Station', 'Montclair', 'NJ'), 
  ('Montvale Station', 'Montvale', 'NJ'),
  ('Morris Plains Station', 'Morris Plains', 'NJ'),
  ('Morristown Station', 'Morristown', 'NJ'),
  ('Mount Arlington Station', 'Mount Arlington', 'NJ'),
  ('Mount Olive Station', 'Mount Olive', 'NJ'), 
  ('Mount Tabor Station', 'Parsippany-Troy Hills', 'NJ'), 
  ('Mountain Ave Station', 'Montclair', 'NJ'),
  ('Mountain Lakes Station', 'Mountain Lakes', 'NJ'),
  ('Mountain Station', 'South Orange', 'NJ'), 
  ('Mountain View - Wayne Station', 'Wayne', 'NJ'),
  ('Murray Hill Station', 'New Providence', 'NJ'), 
  ('Nanuet Station', 'Nanuet', 'NY'),
  ('Newark Broad St Station', 'Newark', 'NJ'),
  ('Newark Liberty Airport Station', 'Newark', 'NJ'),
  ('Newark Penn Station', 'Newark', 'NJ'),
  ('Netcong Station', 'Netcong', 'NJ'),
  ('Netherwood Station', 'Plainfield', 'NJ'), 
  ('New Bridge Landing Station', 'River Edge', 'NJ'), 
  ('New Brunswick Station', 'New Brunswick', 'NJ'),
  ('New Providence Station', 'New Providence', 'NJ'),
  ('New York Penn Station', 'New York', 'NY'),
  ('North Branch Station', 'Branchburg', 'NJ'), 
  ('North Elizabeth Station', 'Elizabeth', 'NJ'),
  ('Oradell Station', 'Oradell', 'NJ'),
  ('Orange Station', 'Orange', 'NJ'),
  ('Otisville Station', 'Otisville', 'NY'),
  ('Palmyra Station', 'Palmyra', 'NJ'),
  ('Park Ridge Station', 'Park Ridge', 'NJ'),
  ('Passaic Station', 'Passaic', 'NJ'),
  ('Paterson Station', 'Paterson', 'NJ'),
  ('Peapack Station', 'Peapack and Gladstone', 'NJ'), 
  ('Pearl River Station', 'Pearl River', 'NY'),
  ('Pennsauken Transit Center Station', 'Pennsauken', 'NJ'),
  ('Perth Amboy Station', 'Perth Amboy', 'NJ'),
  ('Plainfield Station', 'Plainfield', 'NJ'),
  ('Plauderville Station', 'Garfield', 'NJ'), 
  ('Point Pleasant Beach Station', 'Point Pleasant Beach', 'NJ'), 
  ('Port Jervis Station', 'Port Jervis', 'NY'),
  ('Princeton Junction Station', 'Princeton Junction', 'NJ'),
  ('Radburn - Fair Lawn Station', 'Fair Lawn', 'NJ'),
  ('Rahway Station', 'Rahway', 'NJ'),
  ('Ramsey Station', 'Ramsey', 'NJ'),
  ('Ramsey Route 17 Station', 'Ramsey', 'NJ'),
  ('Raritan Station', 'Raritan', 'NJ'),
  ('Red Bank Station', 'Red Bank', 'NJ'),
  ('Ridgewood Station', 'Ridgewood', 'NJ'),
  ('River Edge Station', 'River Edge', 'NJ'),
  ('Riverside Station', 'Riverside', 'NJ'),
  ('Riverton Station', 'Riverton', 'NJ'),
  ('Roebling Station', 'Florence Township', 'NJ'), 
  ('Roselle Park Station', 'Roselle Park', 'NJ'),
  ('Route 73 - Pennsauken Station', 'Pennsauken', 'NJ'),
  ('Rutherford Station', 'Rutherford', 'NJ'),
  ('Salisbury Mills-Cornwall Station', 'Salisbury Mills', 'NY'), 
  ('Secaucus Junction —> Frank R. Lautenberg Station', 'Secaucus', 'NJ'), 
  ('Short Hills Station', 'Millburn', 'NJ'), 
  ('Sloatsburg Station', 'Sloatsburg', 'NY'),
  ('Somerville Station', 'Somerville', 'NJ'),
  ('South Amboy Station', 'South Amboy', 'NJ'),
  ('South Orange Station', 'South Orange', 'NJ'),
  ('Spring Lake Station', 'Spring Lake', 'NJ'),
  ('Spring Valley Station', 'Spring Valley', 'NY'),
  ('Stirling Station', 'Long Hill Township', 'NJ'), 
  ('Suffern Station', 'Suffern', 'NY'),
  ('Summit Station', 'Summit', 'NJ'),
  ('Teterboro - Williams Ave Station', 'Teterboro', 'NJ'), 
  ('Trenton Transit Center Station', 'Trenton', 'NJ'),
  ('Tuxedo Station', 'Tuxedo Park', 'NY'), 
  ('Union Station', 'Union', 'NJ'),
  ('Upper Montclair Station', 'Montclair', 'NJ'),
  ('Waldwick Station', 'Waldwick', 'NJ'),
  ('Walnut Street Station', 'Montclair', 'NJ'),
  ('Walter Rand Transportation Center Station', 'Camden', 'NJ'),
  ('Watchung Ave Station', 'Montclair', 'NJ'),
  ('Watsessing Station', 'Bloomfield', 'NJ'), 
  ('Wayne Route 23 - Transit Center Station', 'Wayne', 'NJ'),
  ('Westfield Station', 'Westfield', 'NJ'),
  ('Westwood Station', 'Westwood', 'NJ'),
  ('White House Station', 'Whitehouse Station', 'NJ'), 
  ('William H. Gray III 30th Street Station', 'Philadelphia', 'PA'),
  ('Wood-Ridge Station', 'Wood-Ridge', 'NJ'),
  ('Woodbridge Station', 'Woodbridge', 'NJ'),
  ('Woodcliff Lake Station', 'Woodcliff Lake', 'NJ'),
  ('Grove Street Station', 'Jersey City', 'NJ'),
  ('Silver Lake Station', 'Belleville', 'NJ'), 
  ('Branch Brook Park Station', 'Newark', 'NJ'),
  ('Davenport Ave Station', 'Newark', 'NJ'), 
  ('Bloomfield Ave Station', 'Newark', 'NJ'), 
  ('Park Ave Station', 'Newark', 'NJ'), 
  ('Orange Street Station', 'Newark', 'NJ'), 
  ('Norfolk Street Station', 'Newark', 'NJ'), 
  ('Warren Street / NJIT Station', 'Newark', 'NJ'),
  ('Washington Street Station', 'Newark', 'NJ'), 
  ('Military Park Station', 'Newark', 'NJ'), 
  ('Newark Penn Station', 'Newark', 'NJ'),
  ('NJPAC / Center Street Station', 'Newark', 'NJ'),
  ('Atlantic Street Station', 'Newark', 'NJ'), 
  ('Riverfront Stadium Station', 'Newark', 'NJ'), 
  ('Newark Broad Street Station', 'Newark', 'NJ'),
  ('Harriet Tubman Square Station', 'Newark', 'NJ'), 
  ('Tonnelle Ave Station', 'North Bergen', 'NJ'), 
  ('Bergenline Ave Station', 'Union City', 'NJ'), 
  ('Port Imperial Station', 'Weehawken', 'NJ'), 
  ('Lincoln Harbor Station', 'Weehawken', 'NJ'), 
  ('9th Street / Congress Street Station', 'Hoboken', 'NJ'),
  ('2nd Street Station', 'Hoboken', 'NJ'),
  ('Hoboken Station', 'Hoboken', 'NJ'),
  ('Newport Station', 'Jersey City', 'NJ'),
  ('Harsimus Cove Station', 'Jersey City', 'NJ'),
  ('Harborside Station', 'Jersey City', 'NJ'),
  ('Exchange Place Station', 'Jersey City', 'NJ'),
  ('Essex Street Station', 'Harrison', 'NJ'), 
  ('Marin Blvd Station', 'Jersey City', 'NJ'),
  ('Jersey Ave Station', 'Jersey City', 'NJ'), 
  ('Liberty State Park Station', 'Jersey City', 'NJ'),
  ('Garfield Ave Station', 'Jersey City', 'NJ'), 
  ('Martin Luther King Drive Station', 'Jersey City', 'NJ'), 
  ('West Side Ave Station', 'Jersey City', 'NJ'), 
  ('Richard Street Station', 'Newark', 'NJ'), 
  ('Danforth Ave Station', 'Jersey City', 'NJ'), 
  ('45th Street Station', 'Bayonne', 'NJ'), 
  ('34th Street Station', 'Bayonne', 'NJ'), 
  ('22nd Street Station', 'Bayonne', 'NJ'), 
  ('8th Street Station', 'Bayonne', 'NJ');
		
insert into Train (tid) VALUES
  ('1088'), ('1189'), ('1401'), ('1493'), ('1532'), ('1784'), ('1843'), ('2379'), 
  ('2390'), ('2507'), ('2896'), ('2978'), ('3105'), ('3316'), ('3343'), ('3397'), 
  ('3515'), ('3820'), ('3824'), ('3875'), ('3915'), ('3984'), ('4468'), ('4490'), 
  ('4624'), ('4964'), ('5055'), ('5283'), ('5446'), ('5450'), ('5594'), ('5742'), 
  ('6009'), ('6026'), ('6131'), ('6133'), ('7120'), ('7471'), ('8060'), ('8299'), 
  ('8981'), ('9083'), ('9287'), ('9602'), ('9758'), ('9876'), ('9896'), ('9919'), 
  ('9946'), ('9969');


insert into Customer Values
    ('user1', 'password123', 'user1@example.com', 'John', 'Doe'),
    ('user2', 'securepass', 'user2@example.com', 'Jane', 'Smith'),
    ('user3', 'pass456', 'user3@example.com', 'David', 'Lee'),
    ('user4', 'mypass', 'user4@example.com', 'Sarah', 'Kim'),
    ('user5', 'strongpass', 'user5@example.com', 'Michael', 'Brown'),
    ('user6', 'pass789', 'user6@example.com', 'Emily', 'Jones'),
    ('user7', 'secure123', 'user7@example.com', 'Daniel', 'Garcia'),
    ('user8', 'mypass456', 'user8@example.com', 'Jessica', 'Rodriguez'),
    ('user9', 'password789', 'user9@example.com', 'Matthew', 'Wilson'),
    ('user10', 'pass101', 'user10@example.com', 'Ashley', 'Martinez'),
    ('user11', 'securepass11', 'user11@example.com', 'Christopher', 'Taylor'),
    ('user12', 'mypass123', 'user12@example.com', 'Amanda', 'Anderson'),
    ('user13', 'pass131', 'user13@example.com', 'Joshua', 'Thomas'),
    ('user14', 'secure14', 'user14@example.com', 'Nicole', 'Jackson'),
    ('user15', 'mypass789', 'user15@example.com', 'Kevin', 'White');
    
    -- --------------------------------------------------------
    -- 	username varchar(50) primary key, 
    -- password varchar(50), 
    -- ssn int, 
    -- fname varchar(50), 
    -- lname varchar(50), 
    -- role enum('manager', 'customer_rep')
    -- --------------------------------------------------------

insert into Employee values
	('mcarpenter', 'group21!', '111-11-1111', 'Marcus', 'Carpenter', 'manager'),
    ('Ade', 'group21!', '222-22-2222', 'Ade', 'lname', 'manager'),
    ('Ras', 'group21!', '333-33-3333', 'Ras', 'lname', 'manager'),
    ('Pavan', 'group21!', '444-44-4444', 'Pavan', 'lname', 'manager'),
    ('jdoe', 'password456', '555-12-4567', 'John', 'Doe', 'customer_rep'),
    ('asmith', 'securepass789','111-98-7543', 'Alice', 'Smith', 'customer_rep'),
    ('bdavis', 'mypass123', '999-56-7234', 'Bob', 'Davis', 'customer_rep'),
    ('ewilson', 'pass1010', '222-87-5432', 'Emily', 'Wilson', 'customer_rep'),
    ('jgarcia', 'secure1111', '888-43-2109', 'Jose', 'Garcia', 'customer_rep'),
    ('kmartinez', 'mypass1212', '333-07-6504', 'Karen', 'Martinez', 'customer_rep'),
    ('lrodriguez', 'pass1313', '777-65-4300', 'Luis', 'Rodriguez', 'customer_rep'),
    ('mtaylor', 'secure1414', '444-23-4567', 'Maria', 'Taylor', 'customer_rep'),
    ('nanderson', 'mypass1515', '669-87-6543', 'Nancy', 'Anderson', 'customer_rep'),
    ('othomas', 'pass1616', '000-56-7934', 'Omar', 'Thomas', 'customer_rep');

#insert into TSchedule Values 	
#schedule_id int auto_increment primary key, 
 #   transit_line varchar(50), -- Atlantic City Line, Bergen County Line, Gladstone Branch, Main Line, Meadowlands Rail Line, Montclair-Boonton Line, Morristown Line, Northeast Corridor Line, Nort Jersey Coastal Line, Pascack Valley Line, Port Jervis Line, Princeton Line, Raritan Valley Line.
  #  origin_id int,
   # destination_id int, 
    #base_fare double, 
    #origin_departure datetime, 
    #origin_arrival datetime,
    #destination_departure datetime, 
    #destination_arrival datetime,
    #train_id int, 
    #foreign key (origin_id) references Station(sid),
    #foreign key (destination_id) references Station(sid)
	#foreign key (train_id) references Train(tid)
    #) engine = InnoDB;


#insert into Reservation Values


#insert into Stops Values
