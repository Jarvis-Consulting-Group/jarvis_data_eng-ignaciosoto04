#Table Setup:

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

CREATE TABLE cd.facilities (
  facid integer NOT NULL, 
  name character varying(100) NOT NULL, 
  membercost numeric NOT NULL, 
  guestcost numeric NOT NULL, 
  initialoutlay numeric NOT NULL, 
  monthlymaintenance numeric NOT NULL, 
  CONSTRAINT facilities_pk PRIMARY KEY (facid), 
  );
  
#Modifying Data
  
#Q1
INSERT INTO cd.facilities
VALUES (9, 'Spa', 20, 30, 100000, 800);

#Q2
INSERT INTO cd.facilities
VALUES ((select max(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800);

#Q3
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE facid = 1;

#Q4
UPDATE cd.facilities f1
SET membercost = f2.membercost * 1.1,
    guestcost = f2.guestcost * 1.1
    FROM (select * from cd.facilities where facid = 0) f2
WHERE f1.facid = 1;

#Q5
DELETE FROM cd.bookings;

#Q6
DELETE FROM cd.members 
WHERE memid = 37;

#Basics

#Q1
SELECT facid, name, membercost, monthlymaintenance 
FROM cd.facilities 
WHERE membercost > 0 and (membercost < monthlymaintenance/50);  

#Q2
SELECT * FROM cd.facilities 
WHERE	name like '%Tennis%'  

#Q3
SELECT * FROM cd.facilities 
WHERE	facid in (1,5)  

#Q4
SELECT memid, surname, firstname, joindate 
FROM cd.members
WHERE joindate >= '2012-09-01'   

#Q5
SELECT surname FROM cd.members
UNION
SELECT name FROM cd.facilities  

#Join

#Q1
SELECT b.starttime FROM cd.bookings b
INNER JOIN cd.members m
  ON m.memid = b.memid
WHERE m.firstname='David' and m.surname='Farrell'

#Q2
SELECT b.starttime, facs.name 
FROM cd.facilities f
INNER JOIN cd.bookings b
  ON f.facid = b.facid
WHERE	f.name in ('Tennis Court 2','Tennis Court 1') and
		b.starttime >= '2012-09-21' and	b.starttime < '2012-09-22'
ORDER BY b.starttime; 


#Q3
SELECT m.firstname, m.surname, r.firstname, r.surname 
FROM cd.members m
LEFT OUTER JOIN cd.members r
  ON r.memid = m.recommendedby
ORDER BY m.surname, m.firstname 

#Q4
SELECT distinct r.firstname, r.surname
FROM cd.members m
INNER JOIN cd.members r
	ON r.memid = m.recommendedby
ORDER BY surname, firstname 

#Q5
SELECT DISTINCT(CONCAT(m.firstname,' ',m.surname)) as member,
	(SELECT CONCAT(r.firstname,' ',r.surname) as recommender 
	 FROM cd.members r 
		where recs.memid = mems.recommendedby)
FROM cd.members m
ORDER BY member  

#Aggregation

#Q1
SELECT recommendedby, COUNT(recommendedby)
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby 

#Q2
SELECT facid, SUM(slots)
FROM cd.bookings
GROUP BY facid
ORDER BY facid 

#Q3
SELECT facid, SUM(slots)
FROM cd.bookings
WHERE starttime >= '2012-09-01' and starttime < '2012-10-01'
GROUP BY facid
ORDER BY SUM(slots)

#Q4
SELECT facid, EXTRACT(MONTH from starttime), SUM(slots)
FROM cd.bookings
WHERE EXTRACT(YEAR from starttime) = 2012
GROUP BY facid, month
ORDER BY facid, month;  

#Q5
SELECT COUNT(DISTINCT memid) FROM cd.bookings

#Q6
SELECT m.surname, m.firstname, m.memid, MIN(b.starttime)
FROM cd.bookings b
INNER JOIN cd.members m 
	ON m.memid = b.memid
WHERE starttime >= '2012-09-01'
GROUP BY m.surname, m.firstname, m.memid
ORDER BY m.memid

#Q7
SELECT COUNT(*) over(), firstname, surname
FROM cd.members
ORDER BY joindate  

#Q8
SELECT row_number() over(order by joindate), firstname, surname
FROM cd.members
ORDER BY joindate  

#Q9
SELECT facid, SUM(slots) AS "Total"
FROM cd.bookings
GROUP BY facid
ORDER BY "Total" desc
LIMIT 1

#String

#Q1
SELECT CONCAT(surname,', ',firstname)
FROM cd.members

#Q2
SELECT memid, telephone
FROM  cd.members
WHERE telephone LIKE '(%' AND telephone LIKE '%)%'

#Q3
SELECT SUBSTR(surname,1,1), COUNT(*) 
FROM cd.members
GROUP BY letter
ORDER BY letter 
