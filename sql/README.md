# Introduction

## SQL Queries

### Table Setup (DDL)

```
CREATE TABLE cd.members (
  memid integer NOT NULL, 
  surname character varying(200) NOT NULL, 
  firstname character varying(200) NOT NULL, 
  address character varying(300) NOT NULL, 
  zipcode integer NOT NULL, 
  telephone character varying(20) NOT NULL, 
  recommendedby integer, 
  joindate timestamp NOT NULL, 
  CONSTRAINT members_pk PRIMARY KEY (memid), 
  CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby) REFERENCES cd.members(memid) ON DELETE 
  SET 
    NULL
);
```
```
CREATE TABLE cd.bookings (
  bookid integer NOT NULL, 
  facid integer NOT NULL, 
  memid integer NOT NULL, 
  starttime timestamp NOT NULL, 
  slots integer NOT NULL, 
  CONSTRAINT bookings_pk PRIMARY KEY (bookid), 
  CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid), 
  CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
);
```
```
CREATE TABLE cd.facilities (
  facid integer NOT NULL, 
  name character varying(100) NOT NULL, 
  membercost numeric NOT NULL, 
  guestcost numeric NOT NULL, 
  initialoutlay numeric NOT NULL, 
  monthlymaintenance numeric NOT NULL, 
  CONSTRAINT facilities_pk PRIMARY KEY (facid), 
  );
```

## Modifying Data

#### Question 1: The club is adding a new facility - a spa. We need to add it into the facilities table. Use the following values: 
#### - facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

INSERT INTO statement is used for this question to insert new records in the table. The names of the columns are not needed as all of them are filled with data in the order they were defined.
```
INSERT INTO cd.facilities
VALUES (9, 'Spa', 20, 30, 100000, 800);
```

#### Question 2: Let's try adding the spa to the facilities table again. This time, though, we want to automatically generate the value for the next facid, rather than specifying it as a constant. Use the following values for everything else:
#### - Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

For this question, a inner subquery is needed to generate a dynamical ID.
```
INSERT INTO cd.facilities
VALUES ((select max(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800);
```

#### Question 3: We made a mistake when entering the data for the second tennis court. The initial outlay was 10000 rather than 8000: you need to alter the data to fix the error.

For this question, the UPDATE statement is needed with a WHERE clause to find the correct row.
```
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE facid = 1;
```

#### Question 4: We want to alter the price of the second tennis court so that it costs 10% more than the first one. Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.

For this question, I needed to reference the first tennis court with a subquery. As the questions ask the code to be reused, a FROM clause is used at the end of the SET clause, so it is not constantly repeteaded.
```
UPDATE cd.facilities f1
SET membercost = f2.membercost * 1.1,
    guestcost = f2.guestcost * 1.1
    FROM (select * from cd.facilities where facid = 0) f2
WHERE f1.facid = 1;
```

#### Question 5: As part of a clearout of our database, we want to delete all bookings from the cd.bookings table. 

DELETE statement delete existing record in the table.
```
DELETE FROM cd.bookings;
```

#### Question 6: We want to remove member 37, who has never made a booking, from our database. 

For this questions, a WHERE clause is used in the DELETE statement to identify the member 37.
```
DELETE FROM cd.members 
WHERE memid = 37;
```
