---
layout: post
title:  "Importing a CSV file into a Rails App with a Rake Task"
date:   2020-04-20
published: false
---

----I HAVE NOT POST THIS BECAUSE I AM NOT SURE WHAT THE RIGHT THING IS TO DO YET----

I've recently been messing around with a lot of CSV imports inside of rake tasks. I've learned some fun things including:
* practice writing and invoking a basic rake task
* reading from one file and writing to another
* skipping the row with the headings in it
* outputting a record count with the `ActiveRecord::Migration.say_with_time` method

## Writing and Invoking a Rake Task
Rake is a Ruby tool that allows you to use ruby code to define "tasks" that can be run in the command line. If you're working in a Rail project, you already have access to Rake. You may recognize it from commands such as `rake db:migrate` and `rake db:seed`. If you want to make your own custom task, create a new file in the `lib/tasks` directory, save it as a `.rake` file (not `.rb`). In my case, I wanted to do some back data entry to my movies app, so I called by file `lib/tasks/bulk_add_watched_movies.rake`.

An rake task looks like this:
```ruby
# lib/tasks/bulk_add_watched_movies.rake

namespace :db do
  desc 'Bulk Add Watched Movies'
  task bulk_add_watched_movies: :environment do
    # The rest of my code went in here
  end
end
```
And you invoke it with `bundle exec rake namespace:taskname`, for example: `bundle exec rake db:bulk_add_watched_movies`.


## Reading from and Writing to a File
The Ruby `CSV` class offers some handy methods for reading and writing from CSV files.

First, use `Rails.root.join` to locate the CSV source file in your application. I saved mine in `lib/tasks/data/movies_input.csv`, so I located it like:
```ruby
source_file = Rails.root.join('lib', 'tasks', 'data', 'movies_input.csv')
```
After locating the file, you can iterate over each row in the CSV file like an array of arrays with `CSV.foreach`, like this:
```ruby
CSV.foreach(source_file, headers: true).each do |row|
  # your code goes here
end
```

## Skipping the Header Row

## Outputting a Record Count
```ruby
ActiveRecord::Migration.say_with_time('Bulk Adding Watched Movies') do
  # code goes here

  Movie.count
end
```

```ruby
# lib/tasks/bulk_add_watched_movies.rake

require 'csv'

namespace :db do
  desc 'Bulk Add Watched Movies'
  task bulk_add_watched_movies: :environment do
    # envoke with `bundle exec rake db:bulk_add_watched_movies`
    ActiveRecord::Migration.say_with_time('Bulk Adding Watched Movies') do
      source_file = Rails.root.join('lib', 'tasks', 'data', 'movies_input.csv')
      rejected_movies = Rails.root.join('lib', 'tasks', 'data', 'rejected_movies.csv')

      movies_added_count = 0
      movies_rejected_count = 0
      CSV.foreach(source_file, headers: true).each do |row|
        entered = row[0]
        title = row[1]
        date_seen = row[3]
        location = row[4]

        next if date_seen.blank?

        existing_movie = Movie.where('title ILIKE ?', title).first

        if existing_movie
          existing_movie.screenings.find_or_create_by(
            date_watched: date_seen,
            location: location
          )
          movies_added_count += 1
        else
          api_response = MovieAPI.find_by_title(title)

          if api_response.present?
            movie_from_api = api_response.body.to_json
            movie_from_api.screenings.create(
              date_watched: date_seen,
              location: location
            )
          else
            CSV.open(rejected_movies, 'a') { |csv| csv << row }
            movies_rejected_count += 1
          end
        end
      end
      puts "Screenings Added: #{movies_added_count}"
      puts "Movies Rejected: #{movies_rejected_count}"

      # This count is used by the ActiveRecord::Migration.say_with_time
      # to output the count to the console
      movies_added_count = 0
    end
  end
end
```
