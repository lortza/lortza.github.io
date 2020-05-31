---
layout: post
title:  "Store images with Rails ActiveStorage and Dropbox"
date:   2020-05-31
published: true
---

I recently implemented cloud image hosting using Rails ActiveStorage and Dropbox. These are the resources that helped me to do it:
* Pragmatic Studio's [Using ActiveStorage in Rails](https://pragmaticstudio.com/tutorials/using-active-storage-in-rails)
* [Deleting attached images](https://www.youtube.com/watch?time_continue=150&v=kNRU3CD0oc0&feature=emb_logo)
* gem [activestorage-dropbox](https://github.com/ashishprajapati/activestorage-dropbox)
* gem [dropbox_api](https://github.com/Jesus/dropbox_api)

ActiveStorage has adapters for a few cloud storage systems (ex: Amazon S3), but it does not have one for Dropbox, so I used the `activestorage-dropbox` gem to take this project over the finish line. My PR: [https://github.com/lortza/yayme/pull/39/files](https://github.com/lortza/yayme/pull/39/files)

## 1. Set Up ActiveStorage
```bash
# install active_storage
rails active_storage:install

# run the associated migrations
rails db:migrate
```

Add the active storage association and associated logic in the model where you want the image to go. I'm adding one to my `Post` model.
```ruby
# app/models/post.rb

# add association
has_one_attached :image

# call a custom validation
validate :acceptable_image

# add ability to delete attached images
attr_accessor :remove_attached_image
after_save :purge_attached_image, if: :remove_attached_image?


# define the acceptable_image validation
def acceptable_image
  return unless image.attached?

  if image.byte_size > 1.megabyte
    image_size = (image.byte_size / 1_000_000.0).round(2)
    errors.add(:image, "size #{image_size} MB exceeds 1 MB limit")
  end

  acceptable_types = ['image/jpeg', 'image/jpg', 'image/png']
  errors.add(:image, 'must be a JPEG or PNG') unless acceptable_types.include?(image.content_type)
end


# define the after_save action to remove an image
def remove_attached_image?
  remove_attached_image == '1'
end

def purge_attached_image
  image.purge_later
end
```

Add the new image field to the `post`'s form. If there is an image attached, I want to see the image name, and a thumbnail variant of the image (requires ImageMagick, explained later). I also want to include a checkbox to delete the image. (The code below includes Twitter Bootstrap CSS classes. Skip them if you're not using Bootstrap.)
```html
<%= form.label :image %>

<% if post.image.attached? %>
  <!-- display the image name and thumbnail -->
  <p>
    <%= image_tag(post.image.variant(resize_to_limit: [75, 75])) %><br>
    <%= post.image.filename %>
  </p>

  <!-- provide a check box to delete the image -->
  <div class='form-check'>
    <%= form.check_box :remove_attached_image, class: 'form-check-input' %>
    <%= form.label 'Check to remove attached image', class: 'form-check-label' %>
  </div>
<% end %>

<%= form.file_field :image, class: 'file-field' %>
```

Display the image on the `posts/show.html.erb` file:
```html
<!-- app/views/posts/show.html.erb -->

<%= image_tag(@post.image, title: @post.image.filename) if @post.image.present? %>
```

Add the new image params to the `posts_controller.rb` whitelist:
```ruby
# app/controllers/posts_controller.rb

def post_params
  params.require(:post).permit(:title, :body, :image, :remove_attached_image)
end
```

Add variant image processing to allow thumbnail rendering by adding the image_processing gem to the Gemfile and running `bundle install`.
```ruby
# Gemfile

gem 'image_processing', '~> 1.2'
```

On the command line, run bundle and then ensure you've installed ImageMagick:
```bash
bundle install

# for mac Homebrew users
brew install imagemagick

# for linux users
sudo apt-get install imagemagick
```

## 2. Create your app storage folder in Dropbox
Go to [Dropbox's developer page for setting up apps](https://www.dropbox.com/developers/apps?_tk=pilot_lp&_ad=topbar4&_camp=myapps) and select the options:
* Create App
* Choose an API: Dropbox API
* Choose the type of access you need: App Folder
* Enter the name of your app -- or what you want your app's folder name to be

This will create an app folder in your Dropbox account that is used for storage for your app. "Your app gets read and write access to this folder only and users can provide content to your app by moving files into this folder." ([from docs](https://www.dropbox.com/developers/reference/developer-guide))

Get the credentials you need from your app page in Dropbox. You'll want to get values for all of these fields and add them to your Rails credentials file. If using Rails credentials is new to you, carefully read that section of [Using ActiveStorage in Rails](https://pragmaticstudio.com/tutorials/using-active-storage-in-rails). It's important that you understand this and get it right.

I open my credentials file using the Atom text editor, so my command looks like:
```bash
EDITOR="atom --wait" bin/rails credentials:edit
```
Never try to open this file or your master key file directly. I've done this in the past and have ruined the encryption because my text editor added a newline at the end of the file. It's a pickle you don't want to be in.

Here is what you'll need to add to your Rails credentials file. Replace all of this text with your own values.
```yml
config/credentials.yml.enc

dropbox:
  app_key: 111222333444
  app_secret: 111222333444
  access_token: 111222333444
  user_id: your-dropbox-associated-email-address@email.com
```
When you save and close the file, Rails encrypts it for you. We'll access those values in a bit by using `Rails.application.credentials.some_value`.

If you haven't done so already, add your `RAILS_MASTER_KEY` to your production environment. I use Heroku, so I added it by running this on the command line:
```bash
heroku config:set RAILS_MASTER_KEY=yourmasterkeynumbershere

# ex
heroku config:set RAILS_MASTER_KEY=12345123451234512345
```
You can confirm that it worked by going to your Heroku settings `https://dashboard.heroku.com/apps/your-app-name/settings` and looking in the `Config Vars` section. Also, do yourself a favor and store your master key somewhere safe like a password manager. You don't want to lose it.


## 3. Connect ActiveStorage and Dropbox
Add these adapter gems to your Gemfile. They hold the logic that connects ActiveStorage to your Dropbox app folder.
```ruby
gem 'activestorage-dropbox'    # adapter for dropbox
gem 'dropbox_api'              # required for `activestorage-dropbox` gem
```

Run bundle
```bash
bundle install
```

Declare a Dropbox service in `config/storage.yml` for the `activestorage-dropbox` to read. This file is _not_ encrypted, so we need to add these values _by referencing the credentials file_ inside of `erb` tags like this:
```yml
# config/storage.yml

dropbox:
  service: Dropbox
  app_key: <%= Rails.application.credentials.dig(:dropbox, :app_key) %>
  app_secret: <%= Rails.application.credentials.dig(:dropbox, :app_secret) %>
  access_token: <%= Rails.application.credentials.dig(:dropbox, :access_token) %>
  user_id: <%= Rails.application.credentials.dig(:dropbox, :user_id) %>
  access_type: app
```

To use the Dropbox service in development, you add the following to `config/environments/development.rb`:
```ruby
config.active_storage.service = :dropbox

# or you can keep your development storage "local", which is what I do:
config.active_storage.service = :local
```
To use the Dropbox service in production, you add the following to `config/environments/production.rb`:
```ruby
config.active_storage.service = :dropbox
```

That should do it. Now you'll be able to upload images from a form, display them on a page, and delete them from a form.
