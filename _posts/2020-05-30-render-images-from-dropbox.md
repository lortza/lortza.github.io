---
layout: post
title:  "Render Images from a Dropbox Folder"
date:   2020-05-30
published: true
---

I take this approach when I am spinning up a Rails app quickly and want to get a quick first draft out the door. It's works best when:
1. I am the only user of the app
2. The app is not image-centric or hugely dependent on images

If you app is not for either of those two situations, I don't recommend this approach. Look into
[storing images with Rails ActiveStorage and Dropbox]({% post_url 2020-05-31-activestorage-dropbox %}) instead.

## Add a url string to your model
```bash
rails g migration add_image_url_to_posts image_url:string
```
You'll get a migration that looks like this:
```ruby
class AddImageUrlToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :image_url, :string
  end
end
```
Run the migration
```bash
rake db:migrate
```
Add the new `image_url` attribute to your whitelisted params in your `posts_controller`:
```ruby
# app/controllers/posts_controller.rb

def post_params
    params.require(:post).permit(:body, :title, :image_url)
end
```

Add the new field to your existing form:
```html
<!-- app/views/posts/_form.html.erb -->

<div class="field">
  <%= form.label 'Image URL' %>
  <%= form.text_field :image_url %>
</div>
```

## Make a dedicated dropbox folder
In my dropbox account, I set up a folder called `app_storage/my_app_name`. When I have a new photo that I need to render for a `Post` object, I upload it to this folder via the dropbox website, then right click it to get the dropbox link. I paste this url into my form field.

## Reformat the URL so it will render images
You can't render the image directly from that URL that you copied from dropbox.
```ruby
# the url you copy from dropbox -- but won't render the image
https://www.dropbox.com/s/sample/sample.png?dl=0

# the url you need in order to render the image
https://dl.dropboxusercontent.com/s/sample/sample.png
```

In order to see an image, you need to modify it a little bit. I do this in a `before_save` action in my `Post` model:

```ruby
# app/models/post.rb

class Post < ApplicationRecord
  before_save :format_image_url

  def format_image_url
    self.image_url = image_url.present? ? DropboxService.format_url(self.image_url) : ''
  end
end
```

Add tests for this method:
```ruby
# spec/models/post_spec.rb

describe 'self.format_image_url' do
  # NOTE: method runs before_save

  it 'safely handles nils' do
    post = build(:post, image_url: nil)
    post.save

    expect(post.image_url).to eq('')
  end

  it 'formats the url' do
    post = build(:post, image_url: 'some_url')
    allow(DropboxService).to receive(:format_url).and_return('fixed_url')
    post.save

    expect(post.image_url).to eq('fixed_url')
  end
end
```

Create the `DropboxService` object that does the formatting.
```ruby
# app/services/dropbox_service.rb

class DropboxService
  DOMAIN = 'www.dropbox.com'
  READABLE_DOMAIN = 'dl.dropboxusercontent.com'
  UNNECESSARY_PARAMS = '?dl=0'

  def self.format_url(url)
    # converts this: https://www.dropbox.com/s/sample/sample.png?dl=0
    # to this: https://dl.dropboxusercontent.com/s/sample/sample.png
    url.gsub(UNNECESSARY_PARAMS, '').gsub(DOMAIN, READABLE_DOMAIN)
  end
end
```

Write spec for `DropboxService` object
```ruby
# spec/services/dropbox_service_spec.rb

require 'rails_helper'

RSpec.describe DropboxService, type: :model do
  describe 'self.format_url' do
    let(:raw_url) { 'https://www.dropbox.com/s/sample/sample.png?dl=0' }
    let(:processed_url) { 'https://dl.dropboxusercontent.com/s/sample/sample.png' }

    it 'removes unnecessary cruft from end of url' do
      output = DropboxService.format_url(raw_url)
      expect(output).to_not include(DropboxService::UNNECESSARY_PARAMS)
    end

    it 'switches out dropbox domain for usable one' do
      output = DropboxService.format_url(raw_url)

      expect(output).to_not include(DropboxService::DOMAIN)
      expect(output).to include(DropboxService::READABLE_DOMAIN)
      expect(output).to eq(processed_url)
    end

    it 'leaves non-dropbox urls as-is' do
      raw_url = 'https://someotherdomain.com/sample1.png'
      output = DropboxService.format_url(raw_url)

      expect(output).to eq(raw_url)
    end
  end
end
```

## Render the image in a view
```html
<!-- app/views/posts/show.html.erb -->

<%= image_tag(post.image_url, class: 'image', title: post.date) if post.image_url.present? %>
```
