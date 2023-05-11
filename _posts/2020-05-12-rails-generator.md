---
layout: post
title:  'Create a Custom Rails Generator'
date:   2020-05-12
published: true
---

For this example, I'm creating a generator that builds a file for Rails data migrations. It will behave very much like a Rails schema migration -- which you may have run before like `rails generate migration your_migration_name`. I want to customize the my data migration generator template file with prompts to make data migrations easier.

### What I Want
I'd like invoke this generator like this:

```bash
bundle exec rails g data_migration add_movie_titles
```

This will create a new file called `db/migrate/20200512123509_add_movie_titles.rb`. When I open that file, I want it to look like this:

```ruby
# frozen_string_literal: true

class AddMovieTitles < ActiveRecord::Migration[6.0]
  def up
    # Your code goes here
    data_check
  end

  def down
    # Your code goes here
    data_check
  end

  def data_check
    # Your validation check here
    expected_result = nil
    raise "DATA MIGRATION FAILED" unless expected_result.present?
  end
end
```
_(Side note: see my post on [why using a data check for data migrations is a good idea]({% post_url 2020-04-27-raise-exception-data-migration %}))_


### How to Do It
Start by using the Rails "generator" generator (yes, the generator that creates generators) by running this in your command line:

```bash
bundle exec rails generate generator name_for_your_generator

# my data_migration example:
bundle exec rails generate generator data_migration
```

 Then,
 1. delete the templates directory: `lib/generators/data_migration/templates`
 1. add a description to the USAGE file: `lib/generators/data_migration/USAGE`
 1. customize your generator file: `lib/generators/data_migration/data_migration_generator.rb`

This is what the generated generator file looks like before customization:
```ruby
# lib/generators/data_migration/data_migration_generator.rb

class DataMigrationGenerator < Rails::Generators::NamedBase
  def create_data_migration_file
    create_file "app/data_migrations/#{file_name}.rb", <<-FILE
module #{class_name}
  attr_reader :#{plural_name}, :#{plural_name.singularize}
end
    FILE
  end
end
```

The `create_file` method takes 2 arguments: a **destination filepath** and a **template** in the form of a [HEREDOC](https://www.rubyguides.com/2018/11/ruby-heredoc/) called `FILE`. Simplifying what we see above, it would look like this:
```ruby
create_file(destination_filepath, template)
```
Also, Rails gives us access to the `file_name` and `class_name` that we can use in our template.

My customized version looks like this:
```ruby
# lib/generators/data_migration/data_migration_generator.rb

class DataMigrationGenerator < Rails::Generators::NamedBase
  def create_data_migration_file
    timestamp = Time.zone.now.to_s.tr('^0-9', '')[0..13]
    filepath = "db/migrate/#{timestamp}_#{file_name}.rb"

    create_file filepath, <<-FILE
    # frozen_string_literal: true

    class #{class_name} < ActiveRecord::Migration[6.0]
      def up
        # Your code goes here
        data_check
      end

      def down
        # Your code goes here
        data_check
      end

      def data_check
        # Your validation check here
        expected_result = nil
        raise "DATA MIGRATION FAILED" unless expected_result.present?
      end
    end
    FILE
  end
end
```

And that is it. Now this generator can be invoked with:
```bash
bundle exec rails g data_migration add_movie_titles
```

See the [full Rails docs on generators](https://guides.rubyonrails.org/generators.html) for other options.
