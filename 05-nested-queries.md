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
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000
INTERSECT
SELECT last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

---

# Remove Intersect with IN

````md magic-move
```sql
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000
INTERSECT
SELECT last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

```sql
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000 AND last_name IN
  (SELECT last_name
   FROM Authors
   WHERE last_name LIKE '%o%')
```
````

---

# Remove Intersect with EXISTS

````md magic-move
```sql
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000 AND last_name IN
  (SELECT last_name
   FROM Authors
   WHERE last_name LIKE '%o%')
```

```sql
SELECT A1.last_name, A1.first_name
FROM Authors A1
WHERE A1.Income > 90000 AND EXISTS
  (SELECT *
   FROM Authors A2
   WHERE A2.id=A1.id AND A2.last_name LIKE '%o%')
```
````

---

# Result

| id  | last_name | first_name | DoB        | Income | Genre   |
| --- | --------- | ---------- | ---------- | ------ | ------- |
| 3   | Jones     | Hannah     | 01/02/1973 | 129000 | Fantasy |
| 4   | Novak     | Stanislaw  | 12/12/1992 | 91000  | Crime   |

---

# Except

```sql {4}
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000
EXCEPT
SELECT last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

---

# Remove Except with NOT IN

````md magic-move
```sql
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000
EXCEPT
SELECT last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

```sql
SELECT last_name, first_name
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
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000 AND id NOT IN
  (SELECT id
   FROM Authors
   WHERE last_name LIKE '%o%')
```

```sql
SELECT A1.last_name, A1.first_name
FROM Authors A1
WHERE A1.Income > 90000 AND NOT EXISTS
  (SELECT *
   FROM Authors A2
   WHERE A2.id=A1.id AND A2.last_name LIKE '%o%')
```
````

---

# Result

| id  | last_name | first_name | DoB        | Income | Genre   |
| --- | --------- | ---------- | ---------- | ------ | ------- |
| 5   | Turay     | Tandice    | 09/07/1980 | 99000  | Romance |

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
src: ./pages/license.md
---
