# 10 Easy Steps to a Complete Understanding of SQL

*Written by [Lukas Eder](https://github.com/lukaseder) September 2013 for Tech.pro* 

Too many programmers think SQL is a bit of a beast. It is one of the few [declarative languages](https://en.wikipedia.org/wiki/Declarative_programming) out there, and as such, behaves in an entirely different way from imperative, object-oriented, or even functional languages (although, some say that SQL is also [somewhat functional](http://thoughts.davisjeff.com/2011/09/25/sql-the-successful-cousin-of-haskell/)).

I'm writing SQL every day and embracing SQL with my [Open Source Software jOOQ](http://www.jooq.org/). I thus feel compelled to bring the beauty of SQL a bit closer to those of you still struggling with it. The following tutorial is destined for

- readers who have already worked with SQL but never completely understood it
- readers who know SQL well but have never really thought about its syntax
- readers who want to teach SQL to others
This tutorial will focus on SELECT statements only. Other DML statements will be covered in another tutorial. Here are...

# 10 Easy Steps to a Complete Understanding of SQL.
## 1. SQL is declarative
Get this into your head first. [Declarative](https://en.wikipedia.org/wiki/Declarative_programming). The only paradigm where you "just" declare the nature of the results that you would like to get. Not *how* your computer shall compute those results. Isn't that wonderful?

    SELECT first_name, last_name FROM employees WHERE salary > 100000

Easy to understand. You don't care where employee records physically come from. You just want those that have a decent salary.

### What do we learn from this?
So if this is so simple, what's the problem? The problem is that most of us intuitively think in terms of [imperative programming](https://en.wikipedia.org/wiki/Imperative_programming). As in: "*machine, do this, and then do that, but before, run a check and fail if this-and-that*". This includes storing temporary results in variables, writing loops, iterating, calling functions, etc. etc.

Forget about all that. Think about *how to declare things*. Not about *how to tell the machine* to compute things.

## 2. SQL syntax is not "well-ordered"
A common source of confusion is the simple fact that SQL syntax elements are not ordered in the way they are executed. The lexical ordering is:
  
- `SELECT [ DISTINCT ]`
- `FROM`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `UNION`
- `ORDER BY`

For simplicity, not all SQL clauses are listed. This lexical ordering differs fundamentally from the logical order, i.e. from the order of execution:
  
- `FROM`
- `WHERE`
- `GROUP BY`
- `HAVING`
- `SELECT`
- `DISTINCT`
- `UNION`
- `ORDER BY`

There are three things to note:
  
1. FROM is the first clause, not SELECT. The first thing that happens is loading data from the disk into memory, in order to operate on such data.

2. SELECT is executed after most other clauses. Most importantly, after FROM and GROUP BY. This is important to understand when you think you can reference stuff that you declare in the SELECT clause from the WHERE clause. 

The following is not possible:

    SELECT A.x + A.y AS z
    FROM A
    WHERE z = 10 -- z is not available here!

If you wanted to reuse `z`, you have two options. Either repeat the expression:
  
    SELECT A.x + A.y AS z
    FROM A
    WHERE (A.x + A.y) = 10

... or you resort to derived tables, common table expressions, or views to avoid code repetition. See examples further down.

3. UNION is placed before ORDER BY in both lexical and logical ordering. Many people think that each UNION subselect can be ordered, but according to the SQL standard and most SQL dialects, that is not true. While some dialects allow for orderingsubqueries or derived tables, there is no guarantee that such ordering will be retained after a UNION operation


Note, not all databases implement things the same way. Rule number 2, for instance, does not apply exactly in the above way to MySQL, PostgreSQL, and SQLite.

### What do we learn from this?

Always remember both the *lexical order* and the *logical order* of SQL clauses to avoid very common mistakes. If you understand that distinction, it will become very obvious why some things work and others don't.

Of course, it would have been nice if the language was designed in a way that the lexical order actually reflected the logical order, as it is implemented in Microsoft's [LINQ](https://msdn.microsoft.com/library/bb397926.aspx).

## 3. SQL is about table references
Because of the difference between lexical ordering and logical ordering, most beginners are probably tricked into thinking that column values are the first-class citizens in SQL. They are not. The most important things are table references.

The [SQL standard](http://www.andrew.cmu.edu/user/shadow/sql/sql1992.txt) defines the FROM clause as such:
  
    <from clause> ::= FROM <table reference> [ { <comma> <table reference> }... ]

The "output" of the FROM clause is a combined table reference of the combined degree of all table references. Let's digest this, slowly.

    FROM a, b

The above produces a combined table reference of the degree of `a` + the degree of `b`. If `a` has 3 columns and `b` has 5 columns, then the "output table" will have 8 (3 + 5) columns.

The records contained in this combined table reference are those of the cross product / cartesian product of `a x b`. In other words, each record of `a` is paired with each record of `b`. If `a` has 3 records and `b` has 5 records, then the above combined table reference will produce 15 records (3 x 5).

This "output" is "fed" / "piped" into the GROUP BY clause (after filtering in the WHERE clause), where it is transformed into a new "output". We'll deal with that later on.

If we're looking at these things from a [relational algebra / set theory](https://en.wikipedia.org/wiki/Relational_algebra) perspective, a SQL table is a relation or a set of tuples. And each SQL clause will transform one or several relations in order to produce new relations.

### What do we learn from this?

Always think in terms of table references to understand how data is "pipelined" through your SQL clauses.

## 4. SQL table references can be rather powerful

A table reference is something rather powerful. A simple example of their power is the JOIN keyword, which is actually not part of the SELECT statement, but part of a "special" table reference. 

The joined table, as defined in the [SQL standard](http://www.andrew.cmu.edu/user/shadow/sql/sql1992.txt) (simplified):

    <table reference> ::=
    <table name>
    | <derived table>
    | <joined table>

If we take again the example from before:

    FROM a, b
`a` can be a joined table as such:

    a1 JOIN a2 ON a1.id = a2.id
Expanding this into the previous expression, we'd get:
  
    FROM a1 JOIN a2 ON a1.id = a2.id, b

While it is discouraged to combine the comma-separated list of table references syntax with the joined table syntax, you can most certainly do this. The resulting, combined table reference will now have a degree of `a1+a2+b`.

Derived tables are even more powerful than joined tables. We'll get to that.

### What do we learn from this?
Always, always think in terms of table references. Not only is this important to understand how data is "pipelined" through your SQL clauses (see previous section), it will also help you understand how complex table references are constructed.

And, importantly, understand that JOIN is a keyword for constructing joined tables. Not a part of the SELECT statement. Some databases allow for using JOIN in INSERT, UPDATE, DELETE

## 5. SQL JOIN tables should be used rather than comma-separated tables
Before, we've seen this clause:
  
    FROM a, b
Advanced SQL developers will probably tell you that it is discouraged to use the comma-separated list at all, and always fully express your JOINs. This will help you improve readability of your SQL statement, and thus prevent mistakes.

One very common mistake is to forget a JOIN predicate somewhere. Think about the following:
  
    FROM a, b, c, d, e, f, g, h
    WHERE a.a1 = b.bx
    AND a.a2 = c.c1
    AND d.d1 = b.bc
    -- etc...
The join table syntax is both

-  Safer, as you can place join predicates close to the joined tables, thus preventing mistakes.
- More expressive, as you can distinguish between OUTER JOIN, INNER JOIN, etc.

###What do we learn from this?

Always use JOIN. Never use comma-separated table references in your FROM clauses.


## 6. SQL's different JOIN operations
JOIN operations essentially come with five flavours:

- `EQUI JOIN`
- `SEMI JOIN`
- `ANTI JOIN`
- `CROSS JOIN`
- `DIVISION`

These terms are commonly used in [relational algebra](https://en.wikipedia.org/wiki/Relational_algebra). SQL uses different terms for the above concepts, if they exist at all. Let's have a closer look:
  
### EQUI JOIN
This is the most common JOIN operation. It has two sub-flavours:
  
-  INNER JOIN (or just JOIN)
- OUTER JOIN (further sub-flavoured as LEFT, RIGHT, FULL OUTER JOIN)

The difference is best explained by example:
  
    -- This table reference contains authors and their books.
    -- There is one record for each book and its author.
    -- authors without books are NOT included
    author JOIN book ON author.id = book.author_id

    -- This table reference contains authors and their books
    -- There is one record for each book and its author.
    -- ... OR there is an "empty" record for authors without books
    -- ("empty" meaning that all book columns are NULL)
    author LEFT OUTER JOIN book ON author.id = book.author_id

### SEMI JOIN

This relational concept can be expressed in two ways in SQL: Using an IN predicate, or using an EXISTS predicate. "Semi" means "half" in latin. This type of join is used to join only "half" of a table reference. What does that mean? Consider again the above joining of author and book. Let's imagine that we don't want author/book combinations, but just those authors who actually also have books. Then we can write:
  
    -- Using IN
    FROM author
    WHERE author.id IN (SELECT book.author_id FROM book)
    
    -- Using EXISTS
    FROM author
    WHERE EXISTS (SELECT 1 FROM book WHERE book.author_id = author.id)
    While there is no general rule as to whether you should prefer IN or EXISTS, these things can be said:
  
- IN predicates tend to be more readable than EXISTS predicates
- EXISTS predicates tend to be more expressive than IN predicates (i.e. it is easier to express very complex SEMI JOIN)
- There is no formal difference in performance. There may, however, be a [huge performance difference on some databases](http://explainextended.com/2009/09/18/not-in-vs-not-exists-vs-left-join-is-null-mysql/).

Because INNER JOIN also produces only those authors that actually have books, many beginners may think that they can then remove duplicates using DISTINCT. They think they can express a SEMI JOIN like this:
  
    -- Find only those authors who also have books
    SELECT DISTINCT first_name, last_name
    FROM author
    JOIN book ON author.id = book.author_id

This is very bad practice for two reasons:
  
- It is very slow, as the database has to load a lot of data into memory, just to remove duplicates again.
- It is not entirely correct, even if it produces the correct result in this simple example. But as soon as you JOIN more table references, you will have a very hard time correctly removing duplicates from your results.
Some more information about abuse of DISTINCT can be seen in [this blog post](http://blog.jooq.org/2013/07/30/10-common-mistakes-java-developers-make-when-writing-sql/).


### ANTI JOIN
This relational concept is just the opposite of a SEMI JOIN. You can produce it simply by adding a NOT keyword to the IN or EXISTS predicates. An example, where we'll select those authors who do not have any books:

    -- Using IN
    FROM author
    WHERE author.id NOT IN (SELECT book.author_id FROM book)
    
    -- Using EXISTS
    FROM author
    WHERE NOT EXISTS (SELECT 1 FROM book WHERE book.author_id = author.id)

The same rules with respect to performance, readability, expressivity apply. However, there is a small caveat with respect to NULLs when using NOT IN, [which is a bit out of scope for this tutorial](http://blog.jooq.org/2012/01/27/sql-incompatibilities-not-in-and-null-values/).


### CROSS JOIN

This produces a cross product of the two joined table references, combining every record of the first table reference with every record of the second table reference. We have seen before, that this can be achieved with comma-separated table references in the FROM clause. In the rare cases where this is really desired, you can also write a CROSS JOIN explicitly, in most SQL dialects:

    -- Combine every author with every book
    author CROSS JOIN book

### DIVISION

The relational division is really a beast of its own breed. In short, if JOIN is multiplication, division is the inverse of JOIN. Relational divisions are very tough to express in SQL. As this is a beginners' tutorial, explaining it is out of scope. For the brave among you, [read on about it here](http://blog.jooq.org/2012/03/30/advanced-sql-relational-division-in-jooq/), [here](https://en.wikipedia.org/wiki/Relational_algebra#Division), [and here](https://www.simple-talk.com/sql/t-sql-programming/divided-we-stand-the-sql-of-relational-division/).


### What do we learn from this?

A lot. Again, let's hammer this into our heads. SQL is about table references. Joined tables are quite sophisticated table references. But there is a difference in relational-speak and SQL-speak. Not all relational join operations are also formal SQL join operations. With a bit of practice and knowledge about relational theory, you will always be able to choose the right type of relational JOIN and be able to translate it to the correct SQL.

## 7. SQL's derived tables are like table variables

Before, we've learned that SQL is a declarative language, and as such, variables do not have a place (they do in some SQL dialects, though). But you can write something like *variables*. And those beasts are called derived tables.

A derived table is nothing but a subquery wrapped in parentheses.

    -- A derived table
    FROM (SELECT * FROM author)
Note that some SQL dialects require derived tables to have a *correlation name* (also known as *alias*).

    -- A derived table with an alias
    FROM (SELECT * FROM author) a
Derived tables are awesome when you want to circumvent the problems caused by the *logical* ordering of SQL clauses. For instance, if you want to reuse a column expression in both the SELECT and the WHERE clause, just write (Oracle dialect):

    -- Get authors' first and last names, and their age in days
    SELECT first_name, last_name, age
    FROM (
      SELECT first_name, last_name, current_date - date_of_birth age
      FROM author
    )
    -- If the age is greater than 10000 days
    WHERE age > 10000
Note that some databases, and the SQL:1999 standard have taken derived tables to the next level, introducing *common table expressions*. This will allow you to reuse the same *derived table* several times within a single SQL SELECT statement. The above query would then translate to the (almost) equivalent:
  
      WITH a AS (
        SELECT first_name, last_name, current_date - date_of_birth age
        FROM author
      )
    SELECT *
      FROM a
    WHERE age > 10000
Obviously, you could also externalise "a" into a standalone view for even broader reuse of common SQL subselects. [Read more about views here](https://en.wikipedia.org/wiki/View_%28SQL%29).

### What do we learn from this?

Again, again, again. SQL is mostly about table references, not columns. Make use of them. Don't be afraid of writing derived tables or other complex table references.

## 8. SQL GROUP BY transforms previous table references
Let's reconsider our previous FROM clause:
  
    FROM a, b
And now, let's apply a GROUP BY clause to the above combined table reference

    GROUP BY A.x, A.y, B.z
The above produces a new table reference with only three remaining columns (!). Let's digest this again. If you apply GROUP BY, then you reduce the number of available columns in all subsequent logical clauses - including SELECT. This is the syntactical reason why you can only reference columns from the GROUP BY clause in the SELECT clause.

Note that other columns may still be available as arguments of aggregate functions:

    SELECT A.x, A.y, SUM(A.z)
    FROM A
    GROUP BY A.x, A.y
    
Note that [MySQL, unfortunately, doesn't adhere to this standard](http://blog.jooq.org/2012/08/05/mysql-bad-idea-384/), causing nothing but confusion. Don't fall for MySQL's tricks. GROUP BY transforms table references. You can thus only reference columns also referenced in the GROUP BY clause.

What do we learn from this?
GROUP BY, again, operates on table references, transforming them into a new form.

## 9. SQL SELECT is called projection in relational algebra
I personally like the term "projection", as it is used in relational algebra. Once you've generated your table reference, filtered it, transformed it, you can step to projecting it to another form. The SELECT clause is like a projector. A table function making use of arow value expression to transform each record from the previously constructed table reference into the final outcome.

Within the SELECT clause, you can finally operate on columns, creating complex column expressions as parts of the record / row.

There are a lot of special rules with respect to the nature of available expressions, functions, etc. Most importantly, you should remember these:
  
1. You can only use column references that can be produced from the "output" table reference
2. If you have a GROUP BY clause, you may only reference columns from that clause, or aggregate functions.
3. You can use window functions instead of aggregate functions, when you don't have a GROUP BY clause.
4. If you don't have a GROUP BY clause, you must not combine aggregate functions with non-aggregate functions.
5. There are some rules with respect to wrapping regular functions in aggregate functions and vice-versa.
6. There are ...
Well, there are lots of complex rules. They could fill yet another tutorial. For instance, the reason why you cannot combine aggregate functions with non-aggregate functions in the projection of a SELECT statement without GROUP BY clause (rule number 4) is this:
  
  It doesn't make sense. Intuitively.
If intuition doesn't help (it hardly does, with a SQL beginner), then syntax rules do. SQL:1999 introduced GROUPING SETS, and SQL:2003 introduced empty grouping sets: GROUP BY (). Whenever an aggregate function is present, and there is no explicit GROUP BY clause, an implicit, empty GROUPING SET is applied (rule number 2). Hence, the original rules about logical ordering aren't exactly true anymore, and the projection (SELECT) influences the outcome of a logically preceding, yet lexically succeeding clause (GROUP BY).
Confused? Yes. Me too. Let's get back to simpler things.

What do we learn from this?
The SELECT clause may be one of the most complex clauses in SQL, even if it appears so simple. All other clauses just "pipe" table references from one to another. The SELECT clause messes up the beauty of these table references, by completely transforming them, applying some rules to them retroactively.

In order to understand SQL, it is important to understand everything else first, before trying to tackle SELECT. Even if SELECT is the first clause in lexical ordering, it should be the last.

10. SQL DISTINCT, UNION, ORDER BY, and OFFSET are simple again
After the complicated SELECT, we can get back to simple things again:
  
  Set operations (DISTINCT and UNION)
Ordering operations (ORDER BY, OFFSET .. FETCH)
Set operations
Set operations operate on "sets", which are actually nothing other than... tables. Well, almost. Conceptually, they're easy to understand.

DISTINCT removes duplicates after the projection.
UNION concatenates two subselects and removes duplicates
UNION ALL concatenates two subselects retaining duplicates
EXCEPT removes records from the first subselect that are also contained in the second subselect (and then removes duplicates)
INTERSECT retains only records contained in both subselects (and then removes duplicates)
All of this removing duplicates is usually non-sense. Most often, you should just use UNION ALL, when you want to concatenate subselects.

Ordering operations
Ordering is not a relational feature. It is a SQL-only feature. It is applied at the very end of both lexical ordering and logical ordering of your SQL statement. Using ORDER BY and OFFSET .. FETCH is the only way to guarantee that records can be accessed by index in a reliable way. All other ordering is always arbitrary and random, even if it may appear to be reproducible.

OFFSET .. FETCH is only one syntax variant. Other variants include MySQL's and PostgreSQL's LIMIT .. OFFSET, or SQL Server's and Sybase's TOP .. START AT. A good overview of various ways to implement OFFSET .. FETCH can be seen here.

Let's get to work
As with every language, SQL takes a lot of practice to master. The above 10 simple steps will help you make more sense of the every day SQL that you're writing. On the other hand, it is also good to learn from common mistakes. The following two articles list lots of common mistakes Java (and other) developers make when writing SQL:

10 Common Mistakes Java Developers Make when Writing SQL
10 More Common Mistakes Java Developers Make when Writing SQL