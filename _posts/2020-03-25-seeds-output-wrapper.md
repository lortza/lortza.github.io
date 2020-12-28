---
layout: post
title:  "Ruby seed output wrapper"
date:   2020-03-25
published: true
---

### The Rails-Provided Method
Rails has a handy method that outputs a count and the time it took for a block to run. It's a nice tool for benchmarking. Here's how it works:

```ruby
# db/seeds.rb

# 1. Pass your message as an argument
ActiveRecord::Migration.say_with_time('Seeding kittens') do
  # 2. Do something in this block. I'm choosing to create some new records.
  names = %w[Murph Mindy Jeff]
  names.each do |name|
    Kitten.find_or_create_by!(name: name)
  end

  # 3. As the last line of this block, return a count.
  Kitten.count
end
```
The terminal output you'll see will have your message, the count, and the time it took to run this block:

```bash
Seeding kittens
  -> 3
  -> 0.1s
```


Neat! Since running our seeds file at work took several minutes, I was using this method to give more informative terminal output. I personally hate staring at a blank terminal and wondering if a process is running or if it has gotten hung up somewhere. As I implemented this method and ran it with a lot of different seeds, I found that while the overall output was improved, the count indication was still ambiguous. Most of our seeds are find-or-create-by in nature -- but not all of them are -- so it is helpful to see terminal output that:
1. indicates which model is being processed
2. how many new records were just created
3. how many total records we now have for that model
4. how long it took to seed that model

In other words, like this:

```bash
Seeding kittens
  -> 0 new
  -> 3 total
  -> 0.15s
  ```

### The Custom Method
So a coworker and I decided to roll our own seed wrapper output method. In a new file we called `db/seeds_helper.rb`, we wrote a method called `count_records_for` . It takes a single argument of the model being seeded and it handles all the rest:

```ruby
# db/seeds_helper.rb

module SeedsHelper
  def self.count_records_for(model)
    puts "Seeding #{model.table_name}"
    starting_record_count = model.count
    starting_time = Time.current

    yield

    ending_count = model.count
    puts "   -> #{ending_count - starting_record_count} new"
    puts "   -> #{ending_count} total"
    puts "   -> #{(Time.current - starting_time).round(3)}s"
  end
end
```

Now we can call it like this:

```ruby
# db/seeds.rb

SeedsHelper.count_records_for(Kitten) do
  names = %w[Murph Mindy Jeff]
  names.each do |name|
    Kitten.find_or_create_by!(name: name)
  end
end
```

And the output looks like...
```bash
# The first time it's run:
Seeding kittens
  -> 3 new
  -> 3 total
  -> 0.15s

# The second time it's run, since the records are find-or-create-by
# we shouldn't see any new records:
Seeding kittens
  -> 0 new
  -> 3 total
  -> 0.15s
```

Check out [this StackOverflow answer](https://stackoverflow.com/a/3066939) for a refresher on how Ruby's `yield` works.
