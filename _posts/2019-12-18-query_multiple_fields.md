---
layout: post
title:  "Query by Multiple Fields at Once in Rails"
date:   2019-12-18
published: true
---

## The Problem
I recently ran into a problem where I wanted to search by a couple of different fields in my postgres database at the same time: a person's `first_name` or `last_name` or `email`. The search term was coming in via a single form field that could contain data from any of those fields. The original query looked something like this:

```ruby
Person.where('first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE', "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
```

But it wasn't giving me everything I wanted. I wanted to get good results if a user entered:
* first name only <-- works
* last name only  <-- works
* first last      <-- works
* email           <-- works
* last, first     <-- totally doesn't work :(

And to be honest, I really wasn't into the idea of passing that same `%#{search_term}%"` argument three times in a row. It made the line long and hard to read.

## The Solution
The solution came in the form of postgres concatenation and some lessons I learned in [this post](http://millo.me/search-by-multiple-columns-in-active-record){:target="_blank"}. The goal with this concatenation is to create a single string with all of the values in it and then compare the incoming string to that.

```ruby
# the postgres concat_ws function
concat_ws(' ', fields, you, want, to, concatenate)
```

Let's say we have a person in our database with the following data:
```
first_name: Julius
last_name: Caesar
email: jcaesar@hotmail.com
```
If I concatenated the fields like this:
```ruby
concat_ws(' ', first_name, last_name, email)
```
The concatenated string would look like this:
```
'Julius Caesar jcaesar@hotmail.com'
```
And now we're comparing our search term only once to that single, concatenated string:
```ruby
where("concat_ws(' ', first_name, last_name, email) ILIKE ?", "%#{search_terms}%")
```
Well that's pretty swell. And it gets us a lot closer to fulfilling that last requirement of searching by `last, first`. To get over that last hump, I needed to strip a comma and then make a `first last first` sandwich in my concatenated string like this:
```ruby
"concat_ws(' ', first_name, last_name, first_name, email)"

# which looks like this
"concat_ws(Julius Caesar Julius jcaesar@hotmail.com)"
```
And now we can match on all the things!
* first name only <-- still works
* last name only  <-- still works
* first last      <-- still works
* email           <-- still works
* last, first     <-- totally works now :)

This is what it looks like when I put it all together in my search method:

```ruby
class Person
  def self.search(search_terms = '')
    # default to showing all records if no search terms are provided
    return all if search_terms.blank?

    # remove any commas and extra spaces between words
    stripped_terms = search_terms&.gsub(',', '')&.squish

    # compare the search terms to a larger, concatenated string in the db
    where("concat_ws(' ', first_name, last_name, first_name, email) ILIKE ?", "%#{stripped_terms}%")
  end
end
```

### Caveat
Concatenating like this removes the ability of the database to use any indexes that are not the primary key. So if our `last_name` field were indexed, we would lose those performance savings.
