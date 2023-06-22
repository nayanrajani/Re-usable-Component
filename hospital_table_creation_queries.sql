create table Doctor
(
docId int primary key auto_increment,
docName varchar(100) not null,
gender varchar(6) NOT NULL CHECK (gender in ('Male', 'Female','Trans')),
docNo varchar(13) not null,
docEmail varchar(100) not null,
docDOB date not null
);

create table Patientproduct
(
patId int primary key auto_increment,
patName varchar(100) not null,
gender varchar(6) NOT NULL CHECK (gender in ('Male', 'Female','Trans')),
patNo varchar(13) not null,
patEmail varchar(100),
patDOB date not null,
docAssi int,
foreign key (docAssi) REFERENCES Doctor(docId)
);

create table Canteen
(
prodId int primary key auto_increment,
prodName varchar(100) not null,
prodType varchar(100),
prodPrice int not null
);

create table ward
(
wardNo int primary key,
wardType varchar(100) not null unique,
containAc boolean default '1',
doubleBed boolean default '1'
);

create table WardBoy
(
wbId int primary key auto_increment,
wbName varchar(100) not null,
gender varchar(6) NOT NULL CHECK (gender in ('Male', 'Female','Trans')),
wbNo varchar(13) not null,
wbEmail varchar(100),
wardAssi int,
wbDOB date not null,
salary int not null,
foreign key (wardAssi) references ward(wardNo)
);


create table Nurse
(
nrsId int primary key auto_increment,
nrsName varchar(100) not null,
gender varchar(6) NOT NULL default 'Female',
nrsNo varchar(13) not null,
wardAssi int,
nrsEmail varchar(100),
nrsDOB date not null,
salary int not null,
foreign key (wardAssi) references ward(wardNo)
);

create table Room
(
roomNo int primary key auto_increment,
wardNo int,
roomType varchar(100) not null,
occupied boolean default '0',
oneDayCharge int not null,
foreign key (wardNo) references ward(wardNo)
);

create table Medicine
(
medicineId int primary key,
medName varchar(200) not null,
medType varchar(100) not null,
manuDate date,
expDate date,
manufacturer varchar(200) not null,
purDate date,
price float not null
);

create table Staff
(
staffId int primary key,
stPName varchar(200) not null,
stPDesi varchar(200) not null,
gender varchar(6) NOT NULL CHECK (gender in ('Male', 'Female','Trans')),
stPNo varchar(13) not null,
stPEmail varchar(100),
stPDOB date not null,
stPAdd varchar(300),
stPSal int,
stType varchar(10)
);


create table Specializations
(
speId int primary key auto_increment,
speName varchar(100) not null unique,
speType varchar(100) not null
);

create table DocSpeTable
(
dsId int primary key auto_increment,
drId int,
speId int,
fees int not null,
foreign key (drId) references doctor(docId),
foreign key (speId) references Specializations(speId)
);

create table bill
(
billNo int primary key auto_increment,
patientId int,
patientType varchar(3) NOT NULL CHECK (patientType in ('OPD', 'IPD')),
docId int,
docCharge int not null,
roomNo int,
canteenCharge int,
medAmo int,
labCharge int,
totalAmount int,
foreign key (patientId) references patient(patId),
foreign key (docId) references doctor(docId),
foreign key (roomNo) references room(roomNo)
);

select * from staffdoctordoctor;
