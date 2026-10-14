---
theme: nord
title: Introduction to relational databases
info: Introduction to Relational Databases — the relational model
author: Gianluca Della Vedova
layout: cover
class: text-center
exportFilename: 01-intro
---

# Introduction to relational databases

Introduction to Relational Databases

---
layout: two-cols
layoutClass: gap-x-8
---

# Tables

Relational databases organize data into tables

Tables can be linked together

A relation is a table

<v-click>

When a table is a relation?

</v-click>

::right::

![Some sample books](./assets/sample_book_list.png)

---

# Table organization

Each row in the table describes a single book

The data is organized into columns

Each _entry_ (or cell) contains **a single piece of data**.

<v-click>

How do we handle a book with two authors?

</v-click>

---

# Books and Authors

| ISBN     | title                                                | Authors                                              |
| -------- | ---------------------------------------------------- | ---------------------------------------------------- |
| 62112346 | Creating relational databases for fun and profit     | Lopez Baranda Christina, Jones Hannah, Turay Tandice |
| 84321235 | Relational databases for really, really smart people | Novak Stanislaw, Turay Tandice                       |
| 64567899 | My life with relational databases: a memoir          | Roy Shanta                                           |
| 87261235 | Relational databases: an existential journey         | Khatami Paree                                        |

<v-click>

**Not** a good idea

</v-click>

---

# Linked tables

<v-clicks>

- One cell, one data
- One table, one set of similar facts/situations

</v-clicks>

<v-clicks>

Two tables can be linked to obtain more information.

Needs an identifier (ID) for the each row (**primary key**)

</v-clicks>

---

# Books

| book_id | ISBN          | title                                                |
| ------- | ------------- | ---------------------------------------------------- |
| 1       | 7654321123456 | Creating relational databases for fun and profit     |
| 2       | 9876543212345 | Relational databases for really, really smart people |
| 3       | 3212345678909 | My life with relational databases: a memoir          |
| 4       | 8172635412345 | Relational databases: an existential journey         |

---

# Authors

| author_id | last_name     | first_name |
| --------- | ------------- | ---------- |
| 1         | Lopez Baranda | Christina  |
| 2         | Jin-Soon      | Sin        |
| 3         | Jones         | Hannah     |
| 4         | Novak         | Stanislaw  |
| 5         | Turay         | Tandice    |
| 6         | Roy           | Shanta     |
| 7         | Berger        | Henry      |
| 8         | Khatami       | Paree      |

---
layout: two-cols
layoutClass: gap-x-8
---

# BooksAuthors

| book_id | author_id |
| ------- | --------- |
| 3       | 6         |
| 2       | 4         |
| 2       | 5         |
| 1       | 1         |
| 1       | 3         |
| 1       | 5         |
| 4       | 8         |

::right::

<v-click>

**Bridging table**

</v-click>

---

# Tables, relationships, and IDs

<v-clicks>

- intermediate table: _relation_ or _join_ or _bridging_ table
- each row must be referenced uniquely
- so that we can reference a row _from_ a different table
- join tables are not necessary to refer to another table — e.g. one-to-many relations

</v-clicks>

---

# Editions

| edition_id | book_id | date_of_publication | edition_number |
| ---------- | ------- | ------------------- | -------------- |
| 1          | 3       | 2001                | 1              |
| 2          | 3       | 2003                | 2              |
| 3          | 4       | 2003                | 1              |
| 5          | 1       | 2000                | 1              |
| 6          | 3       | 2005                | 3              |
| 8          | 2       | 2012                | 1              |
| 9          | 3       | 2009                | 4              |

<v-click>

Standard table with reference to another table: **foreign key**

</v-click>

---

# Constraints

A goal of DBMS is to translate **data** into **information**

<v-clicks>

- Structured data are more informative
- Constraints are a form of structure
- Examples: instance consistent with schema, foreign key, day $\le$ 31

</v-clicks>

---

# NULL values

<v-clicks depth="2">

- Whenever we don’t have a value, we can put a NULL
- Can mean:
  - Value does not exists
  - Value exists but is unknown
- Introduce flexible schema
  - First Name, _Second name_, Surname
- Neither TRUE nor FALSE

</v-clicks>

---
layout: two-cols
layoutClass: gap-x-8
---

# Data Anomalies

| Teacher        | Course ID | Course Name     |
| -------------- | --------- | --------------- |
| Mary Smith     | 3         | Calculus        |
| Ann Brown      | 4         | Progra**m**ing  |
| Michael Jordan | 4         | Progra**m**ing  |

::right::

<v-clicks>

- Who teaches a course
- Course name and ID
- What if we fix the typo?
- Can we have a course without teachers?

</v-clicks>

---

# Functional dependency

> **Definition**: $A$, $B$: sets of attributes.
> Then $A\to B$ if, for any tuples $t_1$ and $t_2$,
> $t_1[A] = t_2[A] \Rightarrow t_1[B] = t_2[B]$

<v-clicks depth="2">

- $A\to B$ is a functional dependency
- A functional dependency is information
- A **bad** functional dependency is a problem
  - Goal: remove bad functional dependencies
  - How: change the schema
  - Hurdle: need the instance to have a dependency

</v-clicks>

---

# Keys and Superkeys

> **Definition**: $K$: set of attributes of relation $R$.
> $K$ is a **superkey** of $R$ if for any set $B$ such that $K\cap B=\emptyset$, then $K\to B$.
>
> Equivalent to: for any tuples $t_1$ and $t_2$, $t_1[K] = t_2[K] \Rightarrow t_1 = t_2$

<v-click>

> **Definition**: $K$ superkey of relation $R$.
> $K$ is a **key** if no proper subset of $K$ is a superkey of $R$

</v-click>

<v-click>

A key is a minimal superkey

</v-click>

---
class: text-sm
---

# Example: Editions table

<v-clicks>

1. The pair (edition_id, edition_number) of the table Editions is a superkey, since there are no two rows of Editions that have the same values of edition_id and edition_number
2. The pair (edition_id, edition_number) of the table Editions is a not a key, since we can remove an attribute (edition_number) and obtain a superkey (the single attribute edition_id)
3. The attribute edition_id is a key. Since it consists of a single attribute, its minimality is trivial
4. The pair (book_id, edition_number) is a superkey. Since removing any of its attribute results in set of attributes that have duplicates, (book_id, edition_number) is also a key.
5. book_id is a foreign key, since the values of that attributes are found in the key of the Books table.

</v-clicks>

---

# Boyce-Codd Normal Form

> **Definition**: Let $A\to B$ for relation $R$.
> Then $A\to B$ is good if $A$ is a superkey of $R$.

> **Definition**: A relation $R$ is in Boyce-Codd Normal Form if all its functional dependencies are good.

<v-clicks>

- Boyce-Codd Normal Form is highly desirable
- Boyce-Codd Normal Form not always achievable
- Boyce-Codd Normal Form usually achievable

</v-clicks>

---
layout: two-cols-header
layoutClass: gap-x-8
---

# Normalization

A bad functional dependency shows which columns must be moved to a new table

::left::

| Teacher        | Course ID | Course Name |
| -------------- | --------- | ----------- |
| Mary Smith     | 3         | Calculus    |
| Ann Brown      | 4         | Programming |
| Michael Jordan | 4         | Programming |

::right::

<v-clicks depth="2">

- Bad functional dependency: Course ID $\to$ Course Name
  - New table with attributes Course ID, Course Name
  - Remove Course Name from current table
  - Result: two linked tables

</v-clicks>

---
layout: two-cols-header
layoutClass: gap-x-8
---

# Normalization

::left::

| Teacher        | Course ID |
| -------------- | --------- |
| Mary Smith     | 3         |
| Ann Brown      | 4         |
| Michael Jordan | 4         |

::right::

| Course ID | Course Name |
| --------- | ----------- |
| 3         | Calculus    |
| 4         | Programming |

<v-click>

Duplicate rows cannot exist

</v-click>

---

# CSV Files

[Planets.csv](https://raw.githubusercontent.com/mwaskom/seaborn-data/master/planets.csv)

```csv
method,number,orbital_period,mass,distance,year
Radial Velocity,1,269.3,7.1,77.4,2006
Radial Velocity,1,874.774,2.21,56.95,2008
Radial Velocity,1,763.0,2.6,19.84,2011
```

<v-clicks>

- different separators: space, tab
- rigid structure
- one table per file

</v-clicks>

---

# JSON file

```json
{"menu": {
  "id": "file",
  "value": "File",
  "popup": {
    "menuitem": [
      {"value": "New", "onclick": "CreateNewDoc()"},
      {"value": "Open", "onclick": "OpenDoc()"},
      {"value": "Close", "onclock": "CloseDoc()"}
    ]
  }}}
```

<v-clicks>

- nested tables
- loose structure

</v-clicks>

---
src: ./pages/license.md
---
