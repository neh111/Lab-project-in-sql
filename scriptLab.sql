create database Lab_db
go
use Lab_db
go
/*יפה שהפרדת בין הפקודות עם GO*/
drop table germs_tbl

create table germs_tbl
(
germ_id numeric identity (1,1),
nameG varchar(20) not null unique,
short_desc varchar (20),
dateG date not null,
medicine_id numeric foreign key references medicine_tbl(medicine_id),
medicine_date date 
CONSTRAINT [PK_germs_tbl] PRIMARY KEY CLUSTERED 
(
	[germ_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
/*האם את יודעת להגדיר מפתח ראשי גם לא דרך הממשק?*/
 go

 drop table medicine_tbl

 create table medicine_tbl
 (
 medicine_id numeric identity (1,1) not null,
 nameM varchar (20) not null unique,
 CONSTRAINT [PK_medicine_tbl] PRIMARY KEY CLUSTERED 
(
	[medicine_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

 go
 drop table test_tbl
 
 create table test_tbl
 (
 germ_id numeric foreign key references germs_tbl(germ_id) not null,
 medicine_id numeric foreign key references medicine_tbl(medicine_id) not null,
 test_date datetime,
 reaction_type varchar(10) CHECK (reaction_type in('dead','dying','alive'))
 CONSTRAINT [PK_test_tbl] PRIMARY KEY CLUSTERED 
(
	[germ_id] ASC,
	[medicine_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

 go

 drop table archive_tbl

 create table archive_tbl
(
 germ_id numeric not null,
 germ_name varchar(20),
 medicine_name varchar(20)not null,
 test_date datetime,
 reaction_type varchar(10),
 CONSTRAINT [PK_archive_tbl] PRIMARY KEY CLUSTERED 
(
	[germ_id] ASC,
	[medicine_name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

 go

 create table exception_tbl
(
 message_name varchar(300),
 message_date datetime
 )


 truncate table germs_tbl
 truncate table medicine_tbl
 truncate table test_tbl
 truncate table archive_tbl
 truncate table exception_tbl
 /*מעולה הסדר מאיר עינים!*/