---
theme: nord
title: Nested queries
info: Introduction to Relational Databases — nested queries
author: Gianluca Della Vedova
layout: cover
class: text-center
exportFilename: 05-nested-queries
---

# Nested queries

Gianluca Della Vedova

University of Milano - Bicocca

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

# Intersect

```sql {4}
SELECT id, last_name, first_name
FROM Authors
WHERE Income > 90000
INTERSECT
SELECT id, last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

---

# Remove Intersect with IN

````md magic-move
```sql
SELECT id, last_name, first_name
FROM Authors
WHERE Income > 90000
INTERSECT
SELECT id, last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

```sql
SELECT id, last_name, first_name
FROM Authors
WHERE Income > 90000 AND id IN
  (SELECT id
   FROM Authors
   WHERE last_name LIKE '%o%')
```
````

---

# Remove Intersect with EXISTS

````md magic-move
```sql
SELECT id, last_name, first_name
FROM Authors
WHERE Income > 90000 AND id IN
  (SELECT id
   FROM Authors
   WHERE last_name LIKE '%o%')
```

```sql
SELECT A1.id, A1.last_name, A1.first_name
FROM Authors A1
WHERE A1.Income > 90000 AND EXISTS
  (SELECT *
   FROM Authors A2
   WHERE A2.id=A1.id AND A2.last_name LIKE '%o%')
```
````

---

# Result

| id  | last_name | first_name |
| --- | --------- | ---------- |
| 3   | Jones     | Hannah     |
| 4   | Novak     | Stanislaw  |

---

# Except

```sql {4}
SELECT id, last_name, first_name
FROM Authors
WHERE Income > 90000
EXCEPT
SELECT id, last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

---

# Remove Except with NOT IN

````md magic-move
```sql
SELECT id, last_name, first_name
FROM Authors
WHERE Income > 90000
EXCEPT
SELECT id, last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

```sql
SELECT id, last_name, first_name
FROM Authors
WHERE Income > 90000 AND id NOT IN
  (SELECT id
   FROM Authors
   WHERE last_name LIKE '%o%')
```
````

---

# Remove Except with NOT EXISTS

````md magic-move
```sql
SELECT id, last_name, first_name
FROM Authors
WHERE Income > 90000 AND id NOT IN
  (SELECT id
   FROM Authors
   WHERE last_name LIKE '%o%')
```

```sql
SELECT A1.id, A1.last_name, A1.first_name
FROM Authors A1
WHERE A1.Income > 90000 AND NOT EXISTS
  (SELECT *
   FROM Authors A2
   WHERE A2.id=A1.id AND A2.last_name LIKE '%o%')
```
````

---

# Result

| id  | last_name | first_name |
| --- | --------- | ---------- |
| 5   | Turay     | Tandice    |

---

# Row achieving a maximum with EXISTS

Find the author(s) with maximum income

```sql {3-5}
SELECT last_name, first_name
FROM Authors A1
WHERE NOT EXISTS (SELECT *
                  FROM Authors A2
                  WHERE A1.income < A2.income)
```

---

# Row achieving a maximum with IN

Find the author(s) with maximum income

```sql {3-4}
SELECT last_name, first_name
FROM Authors A1
WHERE A1.income IN (SELECT max(A2.income)
                    FROM Authors A2)
```

---

# Row achieving a maximum with =

Find the author(s) with maximum income

```sql {3-4}
SELECT last_name, first_name
FROM Authors A1
WHERE A1.income = (SELECT max(A2.income)
                   FROM Authors A2)
```

<v-click>

The subquery returns **exactly one value**: it is a _scalar subquery_

`=` can be used instead of `IN`

</v-click>

---

# Row achieving a maximum with ALL

Find the author(s) with maximum income

```sql {3-4}
SELECT last_name, first_name
FROM Authors A1
WHERE A1.income >= ALL (SELECT A2.income
                        FROM Authors A2)
```

<v-clicks>

- `x >= ALL (subquery)`: `x` is `>=` than **every** value returned
- `x > ANY (subquery)`: `x` is `>` than **at least one** value returned
- `x = ANY (subquery)` is the same as `x IN (subquery)`
- `ALL` and `ANY` are not available in SQLite

</v-clicks>

---

# Result

| last_name | first_name |
| --------- | ---------- |
| Jones     | Hannah     |

<v-click>

All four queries return the same result

</v-click>

---

# Correlated and uncorrelated subqueries

```sql {3-4}
SELECT last_name, first_name
FROM Authors A1
WHERE A1.income = (SELECT max(A2.income)
                   FROM Authors A2)
```

**Uncorrelated**: the subquery does not use `A1`. It can be computed once.

```sql {3-5}
SELECT last_name, first_name
FROM Authors A1
WHERE NOT EXISTS (SELECT *
                  FROM Authors A2
                  WHERE A1.income < A2.income)
```

**Correlated**: the subquery uses `A1`. It is evaluated again for each row of `A1`.

---

# Henry Berger has unknown income

| id  | last_name     | first_name | DoB        | Income | Genre   |
| --- | ------------- | ---------- | ---------- | ------ | ------- |
| 1   | Lopez Baranda | Christina  | 15/11/2000 | 55000  | Fantasy |
| 2   | Jin-Soon      | Sin        | 29/03/1983 | 65000  | Crime   |
| 3   | Jones         | Hannah     | 01/02/1973 | 129000 | Fantasy |
| 4   | Novak         | Stanislaw  | 12/12/1992 | 91000  | Crime   |
| 5   | Turay         | Tandice    | 09/07/1980 | 99000  | Romance |
| 6   | Roy           | Shanta     | 11/10/1977 | 55000  | Fantasy |
| 7   | Berger        | Henry      | 15/08/1956 | NULL   | Romance |
| 8   | Khatami       | Paree      | 11/10/1966 | 86000  | Sci-Fi  |

---

# NOT IN and NULL values

```sql
SELECT last_name, first_name
FROM Authors
WHERE Income NOT IN (SELECT Income
                     FROM Authors
                     WHERE Genre = 'Romance')
```

<v-clicks>

- The subquery returns `99000` and `NULL`
- `55000 NOT IN (99000, NULL)` means `55000 <> 99000 AND 55000 <> NULL`
- `55000 <> NULL` is **unknown**, so the condition is never true
- The query returns **no rows**

</v-clicks>

---

# Use NOT EXISTS instead

```sql
SELECT A1.last_name, A1.first_name
FROM Authors A1
WHERE NOT EXISTS (SELECT *
                  FROM Authors A2
                  WHERE A2.Genre = 'Romance'
                    AND A2.Income = A1.Income)
```

<v-clicks>

- `A2.Income = A1.Income` is never true when `A2.Income` is `NULL`
- Rows with a `NULL` income in the subquery are simply ignored
- All authors except Tandice Turay are returned, **including** Henry Berger: `NULL = NULL` is not true
- `NOT IN` is safe only when the subquery cannot return `NULL`, e.g. a primary key

</v-clicks>

---

# Subqueries in FROM

Find the genres whose average income is larger than 80000

```sql {2-4}
SELECT Genre, avg_income
FROM (SELECT Genre, avg(Income) AS avg_income
      FROM Authors
      GROUP BY Genre) AS G
WHERE G.avg_income > 80000
```

<v-click>

The result of the subquery is a table, which can be used as any other table

</v-click>

---

# Result

| Genre   | avg_income |
| ------- | ---------- |
| Romance | 81000      |
| Sci-Fi  | 86000      |

---
src: ./pages/license.md
---
