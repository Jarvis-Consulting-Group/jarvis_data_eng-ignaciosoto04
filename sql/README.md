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

## Basics

#### Question 1: How can you produce a list of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost? Return the facid, facility name, member cost, and monthly maintenance of the facilities in question 

For this question, the WHERE clause helps indentify the list of facilities that charge a fee to members list of facilities that charge a fee to members.
```
SELECT facid, name, membercost, monthlymaintenance 
FROM cd.facilities 
WHERE membercost > 0 and (membercost < monthlymaintenance/50);  
```

#### Question 2: How can you produce a list of all facilities with the word 'Tennis' in their name?

For this question, the % character is used to look for names containing the word 'Tennis'.
```
SELECT * FROM cd.facilities 
WHERE	name like '%Tennis%'   
```

#### Question 3: How can you retrieve the details of facilities with ID 1 and 5? Try to do it without using the OR operator.

For this question, the IN operator to match the facilities id's.
```
SELECT * FROM cd.facilities 
WHERE	facid in (1,5)  
```

#### Question 4: How can you produce a list of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question.

For this question, I selected the columns asked and the looked for the correct dates.
```
SELECT memid, surname, firstname, joindate 
FROM cd.members
WHERE joindate >= '2012-09-01'      
```

#### Question 5: You, for some reason, want a combined list of all surnames and all facility names. Yes, this is a contrived example :-). Produce that list!

For this question, UNION is used to combine the results of two SQL queries into a single table.
```
SELECT surname FROM cd.members
UNION
SELECT name FROM cd.facilities      
```

## Join

#### Question 1: How can you produce a list of the start times for bookings by members named 'David Farrell'?

For this question, JOIN is used to get to columns from different tables.
```
SELECT b.starttime FROM cd.bookings b
INNER JOIN cd.members m
  ON m.memid = b.memid
WHERE m.firstname='David' and m.surname='Farrell'
```

#### Question 2: How can you produce a list of the start times for bookings for tennis courts, for the date '2012-09-21'? Return a list of start time and facility name pairings, ordered by the time.

For this question, JOIN is used to get to columns from different tables; WHERE, to find the tennis courts and dates; and ORDER BY to ordered by the time.
```
SELECT b.starttime, facs.name FROM cd.facilities f
INNER JOIN cd.bookings b
  ON f.facid = b.facid
WHERE	f.name in ('Tennis Court 2','Tennis Court 1') and
		b.starttime >= '2012-09-21' and	b.starttime < '2012-09-22'
ORDER BY b.starttime; 
```

#### Question 3: How can you output a list of all members, including the individual who recommended them (if any)? Ensure that results are ordered by (surname, firstname).

For this question, LEFT OUTER JOIN is used to get all the first and last names from the member and to get the first and last names of the recommender (is they exist). This means the last out put could be blank.
```
SELECT m.firstname, m.surname, r.firstname, r.surname FROM cd.members m
LEFT OUTER JOIN cd.members r
  ON r.memid = m.recommendedby
ORDER BY m.surname, m.firstname 
```
