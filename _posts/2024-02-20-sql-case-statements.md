---
layout: post
title:  "Case Statements in PostgreSQL"
date:   2024-02-20
published: true
---

If you've ever had a database table that uses enums (just an integer) or some kind of mysterious code to signify meaning, then you've probably reached for a case statement in your `SELECT` to output that nonsense into a human-friendly value. If you haven't, oh boy do I have a treat for you.

For this example, let's pretend I have a table called `home_listings` and that table has several columns -- one is a `category` field that uses a strange code and the other is a `status` field that uses an integer. eww...

<table class="table">
  <tr>
    <th>nickname</th>
    <th>location</th>
    <th>category</th>
    <th>status</th>
  </tr>
  <tr>
    <td>Bob's seaward adventure</td>
    <td>Kitty Hawk, NC</td>
    <td>H33Y</td>
    <td>2</td>
  </tr>
  <tr>
    <td>victorian fixer-upper</td>
    <td>Denver, CO</td>
    <td>SF78</td>
    <td>1</td>
  </tr>
  <tr>
    <td>downtown penthouse</td>
    <td>Pittsburgh, PA</td>
    <td>SX5F</td>
    <td>3</td>
  </tr>
</table>

I'd like to output this to something I can understand. All the fun happens inside the `SELECT` statement since this is display logic and not querying logic.

```sql
SELECT
  hl.nickname,
  hl.location,
  hl.category,
  CASE
    WHEN hl.category = 'H33Y' THEN 'aquatic dwelling'
    WHEN hl.category = 'SF78' THEN 'single family'
    WHEN hl.category = 'SX5F' THEN 'apartment complex'
    WHEN hl.category = 'MX85' THEN 'mobile home'
  END AS category_to_s,
  hl.status,
  CASE
    WHEN hl.status = 0 THEN 'unlisted'
    WHEN hl.status = 1 THEN 'for sale'
    WHEN hl.status = 2 THEN 'for rent'
    WHEN hl.status = 3 THEN 'contract pending'
    WHEN hl.status = 4 THEN 'sold'
    WHEN hl.status = 5 THEN 'removed'
  END AS status_to_s,
FROM home_listings hl
ORDER BY hl.created_at DESC
;
```
It looks a lot like a case statement in ruby. Easy peasy.

Any now my eyeballs are happier because look at this hot new output:

<table class="table">
  <tr>
    <th>nickname</th>
    <th>location</th>
    <th>category</th>
    <th>category_to_s</th>
    <th>status</th>
    <th>status_to_s</th>
  </tr>
  <tr>
    <td>Bob's seaward adventure</td>
    <td>Kitty Hawk, NC</td>
    <td>H33Y</td>
    <td>aquatic dwelling</td>
    <td>2</td>
    <td>for rent</td>
  </tr>
  <tr>
    <td>victorian fixer-upper</td>
    <td>Denver, CO</td>
    <td>SF78</td>
    <td>single family</td>
    <td>1</td>
    <td>for sale</td>
  </tr>
  <tr>
    <td>downtown penthouse</td>
    <td>Pittsburgh, PA</td>
    <td>SX5F</td>
    <td>apartment complex</td>
    <td>3</td>
    <td>contract pending</td>
  </tr>
</table>

Here are the docs: [https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/](https://www.postgresqltutorial.com/postgresql-tutorial/postgresql-case/)
