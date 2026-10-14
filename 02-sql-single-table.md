---
theme: nord
title: SQL on 1 table
info: Introduction to Relational Databases — SQL on a single table
author: Gianluca Della Vedova
layout: cover
class: text-center
exportFilename: 02-sql-single-table
---

# SQL on 1 table

Introduction to Relational Databases

---

# SQL is a...

<v-clicks depth="2">

- Data Definition Language (DDL)
  - Define relational schemata
  - Create/alter/delete tables and their attributes
  - We do not care
- Data Manipulation Language (DML)
  - Insert/delete/modify tuples in tables
  - Query one or more tables – discussed next!

</v-clicks>

---

# Authors table

| id  | last_name     | first_name | DoB        | Income | Genre   |
| --- | ------------- | ---------- | ---------- | ------ | ------- |
| 1   | Lopez Baranda | Christina  | 15/11/2000 | 55000  | Fantasy |
| 2   | Jin-Soon      | Sin        | 29/03/1983 | 65000  | Crime   |
| 3   | Jones         | Hannah     | 01/02/1973 | 129000 | Fantasy |
| 4   | Novak         | Stanislaw  | 12/12/1992 | 91000  | Crime   |
| 5   | Turay         | Tandice    | 09/07/1980 | 99000  | Romance |
| 6   | Roy           | Shanta     | 11/10/1977 | 55000  | Fantasy |
| 7   | Berger        | Henry      | 15/08/1956 | 63000  | Romance |
| 8   | Khatami       | Paree      | 11/10/1966 | 86000  | Sci-Fi  |

---

# Querying tables using SQL

```sql
SELECT *
FROM Authors
ORDER by last_name;
```

<v-click>

| id  | last_name     | first_name | DoB        | Income | Genre   |
| --- | ------------- | ---------- | ---------- | ------ | ------- |
| 7   | Berger        | Henry      | 15/08/1956 | 63000  | Romance |
| 2   | Jin-Soon      | Sin        | 29/03/1983 | 65000  | Crime   |
| 3   | Jones         | Hannah     | 01/02/1973 | 129000 | Fantasy |
| 8   | Khatami       | Paree      | 11/10/1966 | 86000  | Sci-Fi  |
| 1   | Lopez Baranda | Christina  | 15/11/2000 | 55000  | Fantasy |
| 4   | Novak         | Stanislaw  | 12/12/1992 | 91000  | Crime   |
| 6   | Roy           | Shanta     | 11/10/1977 | 55000  | Fantasy |
| 5   | Turay         | Tandice    | 09/07/1980 | 99000  | Romance |

</v-click>

---

# Select From Where

Basic form

```sql
SELECT <attributes>
FROM <one or more relations>
WHERE <conditions>
```

<v-click>

The `WHERE` clause is optional

</v-click>

---

# Selecting

Choosing some rows

```sql {3}
SELECT *
FROM Authors
WHERE income >= 65000;
```

<v-click>

| id  | last_name | first_name | DoB        | Income | Genre   |
| --- | --------- | ---------- | ---------- | ------ | ------- |
| 2   | Jin-Soon  | Sin        | 29/03/1983 | 65000  | Crime   |
| 3   | Jones     | Hannah     | 01/02/1973 | 129000 | Fantasy |
| 4   | Novak     | Stanislaw  | 12/12/1992 | 91000  | Crime   |
| 5   | Turay     | Tandice    | 09/07/1980 | 99000  | Romance |
| 8   | Khatami   | Paree      | 11/10/1966 | 86000  | Sci-Fi  |

</v-click>

---

# Selecting 2

```sql {3}
SELECT *
FROM Authors
WHERE last_name = 'Jones';
```

<v-click>

| id  | last_name | first_name | DoB        | Income | Genre   |
| --- | --------- | ---------- | ---------- | ------ | ------- |
| 3   | Jones     | Hannah     | 01/02/1973 | 129000 | Fantasy |

</v-click>

<v-click>

The result is a table

</v-click>

---

# Projection

Choosing some columns

```sql {1}
SELECT last_name, first_name, income
FROM Authors
WHERE income >= 65000;
```

<v-click>

| last_name | first_name | Income |
| --------- | ---------- | ------ |
| Jin-Soon  | Sin        | 65000  |
| Jones     | Hannah     | 129000 |
| Novak     | Stanislaw  | 91000  |
| Turay     | Tandice    | 99000  |
| Khatami   | Paree      | 86000  |

</v-click>

---

# Projection

Selection before projection

```sql {3|1}
SELECT last_name, first_name
FROM Authors
WHERE income >= 65000;
```

<v-click at="2">

| last_name | first_name |
| --------- | ---------- |
| Jin-Soon  | Sin        |
| Jones     | Hannah     |
| Novak     | Stanislaw  |
| Turay     | Tandice    |
| Khatami   | Paree      |

</v-click>

---

# Remember

<v-clicks>

- commands are case **insensitive**
- value are case **sensitive**
- single quotes `'Jones'`, not `"Jones"`

</v-clicks>

---
layout: two-cols
layoutClass: gap-x-8
---

# Duplicates

```sql
SELECT Genre
FROM Authors;
```

::right::

<v-click>

| Genre   |
| ------- |
| Fantasy |
| Crime   |
| Fantasy |
| Crime   |
| Romance |
| Fantasy |
| Romance |
| Sci-Fi  |

</v-click>

---
layout: two-cols
layoutClass: gap-x-8
---

# Duplicates 2

```sql {1}
SELECT DISTINCT Genre
FROM Authors;
```

::right::

<v-click>

| Genre   |
| ------- |
| Fantasy |
| Crime   |
| Romance |
| Sci-Fi  |

</v-click>

---

# Compound conditions

```sql {3}
SELECT *
FROM Authors
WHERE income >= 65000 AND Genre = 'Crime';
```

<v-click>

| id  | last_name | first_name | DoB        | Income | Genre |
| --- | --------- | ---------- | ---------- | ------ | ----- |
| 2   | Jin-Soon  | Sin        | 29/03/1983 | 65000  | Crime |
| 4   | Novak     | Stanislaw  | 12/12/1992 | 91000  | Crime |

</v-click>

---

# Conditions on strings

- `%` any string
- `_` any character
- use **`LIKE`**

Find all authors whose first name begins with "S"

```sql {3}
SELECT *
FROM Authors
WHERE first_name LIKE 'S%';
```

<v-click>

| id  | last_name | first_name | DoB        | Income | Genre   |
| --- | --------- | ---------- | ---------- | ------ | ------- |
| 2   | Jin-Soon  | Sin        | 29/03/1983 | 65000  | Crime   |
| 4   | Novak     | Stanislaw  | 12/12/1992 | 91000  | Crime   |
| 6   | Roy       | Shanta     | 11/10/1977 | 55000  | Fantasy |

</v-click>

---

# Conditions on strings

Find all authors whose first name begins with "_S_" and the third letter is "_a_"

```sql {3}
SELECT *
FROM Authors
WHERE first_name LIKE 'S_a%';
```

<v-click>

| id  | last_name | first_name | DoB        | Income | Genre   |
| --- | --------- | ---------- | ---------- | ------ | ------- |
| 4   | Novak     | Stanislaw  | 12/12/1992 | 91000  | Crime   |
| 6   | Roy       | Shanta     | 11/10/1977 | 55000  | Fantasy |

</v-click>

---

# Ordering

```sql {4}
SELECT *
FROM Authors
WHERE income >= 65000
ORDER BY last_name;
```

<v-click>

| id  | last_name | first_name | DoB        | Income | Genre   |
| --- | --------- | ---------- | ---------- | ------ | ------- |
| 2   | Jin-Soon  | Sin        | 29/03/1983 | 65000  | Crime   |
| 3   | Jones     | Hannah     | 01/02/1973 | 129000 | Fantasy |
| 8   | Khatami   | Paree      | 11/10/1966 | 86000  | Sci-Fi  |
| 4   | Novak     | Stanislaw  | 12/12/1992 | 91000  | Crime   |
| 5   | Turay     | Tandice    | 09/07/1980 | 99000  | Romance |

</v-click>

---

# Ordering 2

```sql {4}
SELECT *
FROM Authors
WHERE income >= 65000
ORDER BY Genre, DESC income;
```

<v-click>

| id  | last_name | first_name | DoB        | Income | Genre   |
| --- | --------- | ---------- | ---------- | ------ | ------- |
| 4   | Novak     | Stanislaw  | 12/12/1992 | 91000  | Crime   |
| 2   | Jin-Soon  | Sin        | 29/03/1983 | 65000  | Crime   |
| 3   | Jones     | Hannah     | 01/02/1973 | 129000 | Fantasy |
| 5   | Turay     | Tandice    | 09/07/1980 | 99000  | Romance |
| 8   | Khatami   | Paree      | 11/10/1966 | 86000  | Sci-Fi  |

</v-click>

---

# Count

```sql {1}
SELECT count(*)
FROM Authors
WHERE income >= 65000;
```

<v-click>

| count |
| ----- |
| 5     |

Counts the number of rows

</v-click>

---

# Count 2

```sql {1}
SELECT count(DoB, first_name)
FROM Authors
WHERE income >= 65000;
```

<v-click>

| DoB | first_name |
| --- | ---------- |
| 5   | 5          |

Counts the number of rows without null values

</v-click>

---

# AVG

```sql {1}
SELECT AVG(income)
FROM Authors
WHERE income >= 65000;
```

<v-click>

| avg   |
| ----- |
| 94000 |

</v-click>

<v-click>

Also `SUM`, `MIN`, `MAX`

</v-click>

---
layout: two-cols-header
layoutClass: gap-x-8
---

# Group By

For each genre, count the number of authors with income larger than 65000

::left::

```sql {4}
SELECT genre, count(*)
FROM Authors
WHERE income >= 65000
GROUP BY genre;
```

::right::

<v-click>

| genre   | count(\*) |
| ------- | --------- |
| Fantasy | 1         |
| Crime   | 2         |
| Romance | 1         |
| Sci-Fi  | 1         |

</v-click>

---
layout: two-cols-header
layoutClass: gap-x-8
---

# Group By

For each genre, find the average income

::left::

```sql {3}
SELECT genre, avg(income)
FROM Authors
GROUP BY genre;
```

::right::

<v-click>

| genre   | avg(income) |
| ------- | ----------- |
| Fantasy | 79666.67    |
| Crime   | 78000       |
| Romance | 81000       |
| Sci-Fi  | 86000       |

</v-click>

---

# Attributes

```sql {1}
SELECT genre, last_name, avg(income)
FROM Authors
GROUP BY genre;
```

Is not valid

<v-click>

`SELECT` can have:

- attributes in `GROUP BY`
- aggregate operators

</v-click>

---
layout: two-cols-header
layoutClass: gap-x-8
---

# Having

Extract the genres that have at least two authors with income larger than 65000

::left::

```sql {5}
SELECT genre, count(*) as quanti
FROM Authors
WHERE income >= 65000
GROUP BY genre
HAVING count(*) >= 2;
```

::right::

<v-click>

| genre | quanti |
| ----- | ------ |
| Crime | 2      |

</v-click>

---

# Reading order

```sql {all|2|3|4|5|1}
SELECT genre, count(*) as quanti
FROM Authors
WHERE income >= 65000
GROUP BY genre
HAVING count(*) >= 2;
```

<v-clicks>

1. `FROM`
2. `WHERE`
3. `GROUP BY`
4. `HAVING`
5. `SELECT`

</v-clicks>

---
src: ./pages/license.md
---
