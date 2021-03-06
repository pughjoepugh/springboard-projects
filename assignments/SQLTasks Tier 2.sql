/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 2 of the case study, which means that there'll be less guidance for you about how to setup
your local SQLite connection in PART 2 of the case study. This will make the case study more challenging for you: 
you might need to do some digging, aand revise the Working with Relational Databases in Python chapter in the previous resource.

Otherwise, the questions in the case study are exactly the same as with Tier 1. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT name FROM Facilities WHERE membercost >0;




/* Q2: How many facilities do not charge a fee to members? */

Answer: 4
SELECT name FROM Facilities WHERE membercost =0;




/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

SELECT facid, name, membercost, monthlymaintenance
FROM Facilities
WHERE membercost>0 and membercost< (monthlymaintenance/5)




/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */


SELECT * FROM Facilities WHERE facid IN (1,5);



/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */


SELECT name, monthlymaintenance, 
CASE
WHEN monthlymaintenance>100 THEN 'expensive'
ELSE 'cheap'
end cost
FROM Facilities;



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */


SELECT firstname, surname
FROM Members
ORDER BY joindate DESC;



/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */


SELECT DISTINCT CONCAT(m.surname, ', ', m.firstname) AS name, f.name as facility
FROM Members as m, Facilities as f, Bookings as b
WHERE f.facid in (0,1) and m.memid <> 0 and m.memid = b.memid
ORDER BY name;



/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */


SELECT f.name as facility, CONCAT(m.surname, ', ', m.firstname) AS name, f.guestcost as cost
FROM Bookings as b
INNER JOIN Facilities as f
ON f.facid=b.facid
INNER JOIN Members as m
ON m.memid=b.memid
WHERE b.starttime LIKE '2012-09-14%'
AND m.memid=0 AND f.guestcost >30 or m.memid<> 0 and f.membercost >30
ORDER BY cost DESC;


/* Q9: This time, produce the same result as in Q8, but using a subquery. */

SELECT f.name as facility, CONCAT(m.surname, ', ', m.firstname) AS name, f.guestcost as cost
FROM Bookings as b
INNER JOIN Facilities as f
ON f.facid=b.facid
INNER JOIN Members as m
ON m.memid=b.memid
WHERE b.starttime LIKE '2012-09-14%'
AND f.guestcost IN (select guestcost FROM Facilities WHERE guestcost >30)
AND b.memid=0
ORDER BY cost DESC;



/* PART 2: SQLite

Export the country club data from PHPMyAdmin, and connect to a local SQLite instance from Jupyter notebook 
for the following questions.  

QUESTIONS:

/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

    query1 = """
SELECT b.facid,
CASE
WHEN b.facid=0 THEN (SELECT COUNT(*)*25.0 FROM Bookings WHERE b.facid=0 and b.memid=0)+(SELECT COUNT(*)*5.0 FROM Bookings WHERE b.facid=0 and b.memid<>0)

WHEN b.facid=1 THEN (SELECT COUNT(*)*25.0 FROM Bookings WHERE b.facid=1 and b.memid=0)+(SELECT COUNT(*)*5.0 FROM Bookings WHERE b.facid=1 and b.memid<>0)

WHEN b.facid=2 THEN (SELECT COUNT(*)*15.5 FROM Bookings WHERE b.facid=2 and b.memid=0)+(SELECT COUNT(*)*0.0 FROM Bookings WHERE b.facid=2 and b.memid<>0)

WHEN b.facid=3 THEN (SELECT COUNT(*)*5.0 FROM Bookings WHERE b.facid=3 and b.memid=0)+(SELECT COUNT(*)*0.0 FROM Bookings WHERE b.facid=3 and b.memid<>0)

WHEN b.facid=4 THEN (SELECT COUNT(*)*80.0 FROM Bookings WHERE b.facid=4 and b.memid=0)+(SELECT COUNT(*)*9.9 FROM Bookings WHERE b.facid=4 and b.memid<>0)

WHEN b.facid=5 THEN (SELECT COUNT(*)*80.0 FROM Bookings WHERE b.facid=5 and b.memid=0)+(SELECT COUNT(*)*9.9 FROM Bookings WHERE b.facid=5 and b.memid<>0)

WHEN b.facid=6 THEN (SELECT COUNT(*)*17.5 FROM Bookings WHERE b.facid=6 and b.memid=0)+(SELECT COUNT(*)*3.5 FROM Bookings WHERE b.facid=6 and b.memid<>0)

WHEN b.facid=7 THEN (SELECT COUNT(*)*5.0 FROM Bookings WHERE b.facid=7 and b.memid=0)+(SELECT COUNT(*)*0.0 FROM Bookings WHERE b.facid=7 and b.memid<>0)
ELSE (SELECT COUNT(*)*5.0 FROM Bookings WHERE b.facid=8 and b.memid=0)+(SELECT COUNT(*)*0.0 FROM Bookings WHERE b.facid=8 and b.memid<>0)
END revenue

FROM Bookings as b, Facilities as f
WHERE revenue<1000
GROUP BY b.facid
ORDER BY revenue;

        """


/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */


query1 = """
        SELECT m1.surname||', '|| m1.firstname AS name, 
        m2.surname||', '||m2.firstname AS 'recommended by'
        FROM Members m1
        INNER JOIN Members m2 ON
        m2.memid = m1.recommendedby
        WHERE m1.memid<>0
        ORDER BY name;
        """


/* Q12: Find the facilities with their usage by member, but not guests */

query1 = """
        SELECT facid,
        CASE
        WHEN facid=0 THEN (SELECT COUNT(*) FROM Bookings WHERE facid=0)
        WHEN facid=1 THEN (SELECT COUNT(*) FROM Bookings WHERE facid=1)
        WHEN facid=2 THEN (SELECT COUNT(*) FROM Bookings WHERE facid=2)
        WHEN facid=3 THEN (SELECT COUNT(*) FROM Bookings WHERE facid=3)
        WHEN facid=4 THEN (SELECT COUNT(*) FROM Bookings WHERE facid=4)
        WHEN facid=5 THEN (SELECT COUNT(*) FROM Bookings WHERE facid=5)
        WHEN facid=6 THEN (SELECT COUNT(*) FROM Bookings WHERE facid=6)
        WHEN facid=7 THEN (SELECT COUNT(*) FROM Bookings WHERE facid=7)
        ELSE (SELECT COUNT(*) FROM Bookings WHERE facid=8)
        END 'usage'

        FROM Bookings
        WHERE memid <>0
        GROUP BY facid;
        """

/* Q13: Find the facilities usage by month, but not guests */

 query1 = """
        SELECT facid,
        CASE
        WHEN facid=0 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-07%' and facid=0)
        WHEN facid=1 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-07%' and facid=1)
        WHEN facid=2 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-07%' and facid=2)
        WHEN facid=3 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-07%' and facid=3)
        WHEN facid=4 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-07%' and facid=4)
        WHEN facid=5 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-07%' and facid=5)
        WHEN facid=6 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-07%' and facid=6)
        WHEN facid=7 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-07%' and facid=7)
        ELSE (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-07%' and facid=8)
        END 'month 7',
        CASE
        WHEN facid=0 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-08%' and facid=0)
        WHEN facid=1 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-08%' and facid=1)
        WHEN facid=2 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-08%' and facid=2)
        WHEN facid=3 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-08%' and facid=3)
        WHEN facid=4 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-08%' and facid=4)
        WHEN facid=5 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-08%' and facid=5)
        WHEN facid=6 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-08%' and facid=6)
        WHEN facid=7 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-08%' and facid=7)
        ELSE (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-09%' and facid=8)
        END 'month 8',
        CASE
        WHEN facid=0 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-09%' and facid=0)
        WHEN facid=1 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-09%' and facid=1)
        WHEN facid=2 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-09%' and facid=2)
        WHEN facid=3 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-09%' and facid=3)
        WHEN facid=4 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-09%' and facid=4)
        WHEN facid=5 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-09%' and facid=5)
        WHEN facid=6 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-09%' and facid=6)
        WHEN facid=7 THEN (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-09%' and facid=7)
        ELSE (SELECT COUNT(*) FROM Bookings WHERE starttime LIKE '2012-09%' and facid=8)
        END 'month 9'
        FROM Bookings
        WHERE memid <>0
        GROUP BY facid;
        """
