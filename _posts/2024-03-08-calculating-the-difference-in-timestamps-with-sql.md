---
layout: post
title:  "Calculating the difference in timestamps with PostgreSQL"
date:   2024-03-08
published: true
---

I recently needed to do a little analytic research for our UX team. We wanted to know how long it usually took between the time our app makes a web request to an external API and the time we received the webhook back from that API. Knowing that would help us to plan a more pleasant experience for our customers.

## Calculating the difference
When we initiate a call to the API, we save an instance of our `Listing` class in the database with a `created_at` timestamp. When the API calls us back, we update the `listing` with the new response data. This gives us a fresh `updated_at` value. Taking the difference between these two values gives us the age:
```sql
-- AGE(bigger_number, smaller_number)
AGE(updated_at, created_at)
```

In our case, we only care about records that were successful so we're filtering for a specific `status`. As you can see, the magic is in the `SELECT` statement:
```sql
SELECT AGE(l.updated_at, l.created_at), *
FROM listings l
WHERE l.status = 'success'
;
```
Now we have a number value, signifying the time difference, for each row.

## But I really wanted an average...
But what I _really_ want to know is what the average time is for us to get a callback from this API, so I wrapped the `AGE` function in the `AVG` function to get that, like:
```sql
-- AVG(a_number_value_for_each_row)
AVG(AGE(updated_at, created_at))
```

So the whole query is now:
```sql
SELECT AVG(AGE(l.updated_at, l.created_at))
FROM listings l
WHERE l.status = 'success'
;
```
Now we have a single number signifying the average for all rows.

And my answer is `00:02:21.59232`, roughly 2.5 minutes on my local machine.