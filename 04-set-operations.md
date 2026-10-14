---
theme: nord
title: Set operations with SQL
info: Introduction to Relational Databases — set operations
author: Gianluca Della Vedova
layout: cover
class: text-center
exportFilename: 04-set-operations
---

# Set operations with SQL

Introduction to Relational Databases

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

<v-clicks>

- Intersection between two sets
- Never used in practice
- Can be replaced with a more complex `WHERE` condition

</v-clicks>

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

# Result

| id  | last_name | first_name | DoB        | Income | Genre   |
| --- | --------- | ---------- | ---------- | ------ | ------- |
| 3   | Jones     | Hannah     | 01/02/1973 | 129000 | Fantasy |
| 4   | Novak     | Stanislaw  | 12/12/1992 | 91000  | Crime   |

---

# Remove Intersect

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
WHERE Income > 90000 AND last_name LIKE '%o%'
```
````

---

# Union

<v-clicks>

- Union between two sets
- Rarely used in practice
- Can be replaced with a more complex `WHERE` condition, _if no duplicates_

</v-clicks>

```sql {4}
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000
UNION
SELECT last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

---

# Result

| id  | last_name     | first_name | DoB        | Income | Genre   |
| --- | ------------- | ---------- | ---------- | ------ | ------- |
| 1   | Lopez Baranda | Christina  | 15/11/2000 | 55000  | Fantasy |
| 2   | Jin-Soon      | Sin        | 29/03/1983 | 65000  | Crime   |
| 3   | Jones         | Hannah     | 01/02/1973 | 129000 | Fantasy |
| 4   | Novak         | Stanislaw  | 12/12/1992 | 91000  | Crime   |
| 5   | Turay         | Tandice    | 09/07/1980 | 99000  | Romance |
| 6   | Roy           | Shanta     | 11/10/1977 | 55000  | Fantasy |

---

# Remove Union

````md magic-move
```sql
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000
UNION
SELECT last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

```sql
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000 OR last_name LIKE '%o%'
```
````

---

# Union with duplicates

```sql {4}
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000
UNION ALL
SELECT last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

---

# Except

<v-clicks>

- Difference between two sets
- Useful in practice
- Can be replaced with a much more complex nested query

</v-clicks>

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

# Result

| id  | last_name | first_name | DoB        | Income | Genre   |
| --- | --------- | ---------- | ---------- | ------ | ------- |
| 5   | Turay     | Tandice    | 09/07/1980 | 99000  | Romance |

---
src: ./pages/license.md
---
