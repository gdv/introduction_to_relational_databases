---
 title: Nested queries 
 classoption:
 - aspectratio=169
 header-includes:
 -  \setmonofont{Ubuntu Mono}
 - \hypersetup{colorlinks=true}
---



## Authors table
 
 
  id last_name     first_name     DoB          Income Genre
 --- ------------- -------------- ----------- ------- -------
   1 Lopez Baranda Christina      15/11/2000    55000 Fantasy
   2 Jin-Soon      Sin            29/03/1983    65000 Crime
   3 Jones         Hannah         01/02/1973   129000 Fantasy
   4 Novak         Stanislaw      12/12/1992    91000 Crime
   5 Turay         Tandice        09/07/1980    99000 Romance
   6 Roy           Shanta         11/10/1977    55000 Fantasy
   7 Berger        Henry          15/08/1956    63000 Romance
   8 Khatami       Paree          11/10/1966    86000 Sci-Fi

## Intersect

```sql
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000
INTERSECT
SELECT last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

## Result

 
  id last_name     first_name     DoB          Income Genre
 --- ------------- -------------- ----------- ------- -------
   3 Jones         Hannah         01/02/1973   129000 Fantasy
   4 Novak         Stanislaw      12/12/1992    91000 Crime


## Remove Intersect

```sql
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000 AND last_name IN 
  SELECT last_name
  FROM Authors
  WHERE last_name LIKE '%o%'
```

## Except

```sql
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000
EXCEPT
SELECT last_name, first_name
FROM Authors
WHERE last_name LIKE '%o%'
```

## Result

 
  id last_name     first_name     DoB          Income Genre
 --- ------------- -------------- ----------- ------- -------
   5 Turay         Tandice        09/07/1980    99000 Romance

## Remove Except

```sql
SELECT last_name, first_name
FROM Authors
WHERE Income > 90000 AND id NOT IN
  SELECT id
  FROM Authors
  WHERE last_name LIKE '%o%'
```

## ALL/ANY

Find the author(s) with maximum income


```sql
SELECT last_name, first_name
FROM Authors A1
WHERE A1.income >= ALL SELECT A2.income
                       FROM Authors A2
```


## License

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/80x15.png" /></a><br /><span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Text" property="dct:title" rel="dct:type">Except where noted, text and images for Introduction to Relational Databases</span> by <span xmlns:cc="http://creativecommons.org/ns#" property="cc:attributionName">Mark Jordan</span> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>. 
<span xmlns:dct="http://purl.org/dc/terms/" href="http://purl.org/dc/dcmitype/Text" property="dct:title" rel="dct:type">Except where noted, text and images for Introduction to Relational Databases</span> by <span xmlns:cc="http://creativecommons.org/ns#" property="cc:attributionName">Gianluca Della Vedova</span> is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>. 
Everything in the 'scripts' directory is in the <a href="https://creativecommons.org/publicdomain/zero/1.0/">public domain (CC0)</a>.

