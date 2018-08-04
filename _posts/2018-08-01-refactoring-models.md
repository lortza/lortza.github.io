---
layout: post
title:  'Legacy Refactor: Separation of Concerns in Sorry Girl Rails app'
date:   2018-08-02
---
It's handy to be applying for jobs because it gives me the excuse to go back to some of my Rails portfolio projects and refactor them. Whenever I undertake a refactor of my own work, there are 2 important people I keep in mind: Past Me and Future Me. Past Me did the darned best she could with what she knew at the time and deserves compassion. Future Me loves easy-to-read and easy-to-maintain code and she deserves to get what she loves. I believe this refactor will leave Future Me appreciating Future Past Me's choices... or something like that.

Now on to the show...

The app of choice for this refactor is [Sorry Girl - The Apology You Needed to Hear, but from Ryan Gosling](https://sorrygirl.herokuapp.com/). The concept of the app is that a user writes a short apology note with a picture of Ryan Gosling to send to a friend via social media.

The basic mechanics are:

1. A user submits `apology.body` data on the `apology` form.
2. The `Image` class is prompted to select a random image from the `app/assets/images` directory.
3. The `apology.image` attribute is set to that image file and the `apology` is saved.
4. After save, the `apologies#show` page is rendered.

## Refactoring the 'Apology' model

First on my list to refactor was the `Apology` model. Two years ago, when I built this app, I didn't know much about separation of concerns. Looking back at it today, I've found a great example of one model knowing too much about another one. It needed to be separated out into 2 models that each have their own responsibilities.

### Before: Apology Model

```ruby
# app/models/apology.rb

class Apology < ActiveRecord::Base

  # This model knows what all of the images are. In fact, it is the sole
  # location of this knowledge. And it is documented in one very long line.
  # Hard-coded. Difficult to maintain. Too unwieldy to scale.
  # Go on, scrolllll to the right to see that long line...
  IMAGES = ["ryan-gosling01.jpg", "ryan-gosling02.jpg", "ryan-gosling03.jpg", "ryan-gosling04.jpg", "ryan-gosling05.jpg", "ryan-gosling06.png", "ryan-gosling07.jpg", "ryan-gosling08.jpg", "ryan-gosling09.jpg", "ryan-gosling10.jpg"]

  # Assigns a random image every time the object is saved.
  # That means both 'create' and 'update' assign a random image.
  before_save :generate_image

  # This is fine until you need to know this character max in other
  # parts of the app. Spoiler alert: that happened.
  validates :body, presence: true, length: { maximum: 170 }

  def generate_image
    self.image = IMAGES.sample
  end

 end
 ```

Crawling back into Past Me's brain, I'll venture that I built that giant `IMAGES` array because it was a simple way to access the files. There was a finite set of images (10) stored in the `app/assets/images` directory and this was the easiest way I knew to grab them.

#### Why It Needs Refactoring
Firstly, there is a long list of hand-entered, hard-coded filenames. Low-hanging fruit? Break it up into separate lines. We are humans after all, and code should be readable:

```ruby
  IMAGES = [
    "ryan-gosling01.jpg",
    "ryan-gosling02.jpg",
    "ryan-gosling03.jpg",
    "ryan-gosling04.jpg",
    "ryan-gosling05.jpg",
    "ryan-gosling06.png",
    "ryan-gosling07.jpg",
    "ryan-gosling08.jpg",
    "ryan-gosling09.jpg",
    "ryan-gosling10.jpg"
  ]
```

If I want to modify this inventory of photos (and I do), I'll need to manually edit this list. That's unpleasant for a list of only 10 images, but it becomes unwieldy if my image inventory were to grow to say, 30, or 300, or a whole API of images. This approach also assumes that I will make no mistakes when entering filenames. I don't want to make that assumption about any human, even myself. There is still more work to do.

### After: Apology Model

```ruby
# app/models/apology.rb

class Apology < ActiveRecord::Base

  # Constant stores character max so it is found easily by a person
  # updating this value for the entire app.
  CHARACTER_MAX = 170

  # Assigns the image upon creation instead of save, otherwise a new
  # image is assigned any time the record is edited
  before_validation :assign_image, on: :create

  # The character max now comes directly from the constant
  validates :body, presence: true, length: { maximum: CHARACTER_MAX }
  # Adds validation on the image field
  validates :image, presence: true

  # This ordering was previously in the controller, but belongs here.
  scope :ordered, -> { all.order("created_at DESC") }

  # Makes the character max easily accessible by other parts of the
  # app such as tests, javascript functions, and the view
  def character_max
    CHARACTER_MAX
  end

  # Changes from 'IMAGE.sample' to 'Image.sample' because now the
  # 'Image' class handles the logic behind the image selection.
  def assign_image
    self.image = Image.sample
  end

end
```

The need to extract the `CHARACTER_MAX` into a constant became evident when I wrote javascript form feedback for this app. As I tinkered with the hard-coded character count over and over, I had to do it in 3 places. That was irritating! When I had to do it a 4th time while writing tests, that was the last straw. Now the `CHARACTER_MAX` is set in 1 place and it is referenced in these other places:

```erb
# app/views/apologies/_form.html.erb

<%= form_for(@apology) do |f| %>

  <!-- Used HERE in the text -->
  <span id="character-count"><%= @apology.character_max %></span> characters remaining

  <%= f.text_area :body, autofocus: true, required: true, placeholder: "Hey Girl, I'm sorry I was such a jerkface..." %>

  <%= f.submit %>
<% end %>

<script>
  // Used HERE in the javascript
  remainingCharacters(<%= @apology.character_max %>)
</script>
```

```ruby
# spec/models/apology_model_spec.rb

RSpec.describe Apology, :type => :model do
  let(:apology) { Apology.new(body: 'lorem', image: 'image.jpg') }

  # Used HERE to set up testing limitations
  character_max = Apology::CHARACTER_MAX
  string_at_char_max = 'x' * character_max
  string_over_char_max = 'x' * (character_max + 1)

    # Used HERE to make a clear explanation of expectations
    it "permits up to #{character_max} characters in the body field" do
      apology.body = string_at_char_max
      expect(apology).to be_valid

      apology.body = string_over_char_max
      expect(apology).to_not be_valid
    end
  end
```

Now for the elephant in the room... well, more like, where did that giant `IMAGES` array elephant go? Our `Images` array grew up and became a class. Hooray! You go little `Images` array, you go!

## Refactoring from an Array into an 'Image' Model

What's cool about this refactor is that the interface with the `Apology` class barely changes. The clunky array is gone, but the `Apology.assign_image` method is nearly identical. That makes it really easy to pluck the `Image` responsibilities out and make them more robust.

```ruby
# app/models/image.rb

class Image
  def self.sample
    [
      "ryan-gosling01.jpg",
      "ryan-gosling02.jpg",
      "ryan-gosling03.jpg",
      "ryan-gosling04.jpg",
      "ryan-gosling05.jpg",
      "ryan-gosling06.png",
      "ryan-gosling07.jpg",
      "ryan-gosling08.jpg",
      "ryan-gosling09.jpg",
      "ryan-gosling10.jpg"
    ].sample
  end
end
```
Closer, but not there yet.

As I previously bemoaned, there are a couple of problems with that array of image names above: 1) maintenance and 2) scalability -- because guess who wants to add 20 more pictures of Ryan Gosling to the app? This girl. And guess who wasn't going to type in a bunch of new filenames? Me again. You know who's really good at looking in a folder of images and just telling me the files that are in them? Ruby. Let's let Ruby do its thing.

Ruby has a nifty `Dir` library that let's us do these kinds of things. The `Dir.glob` method lets us search in a specific directory for specific filetypes. Perfect!

```ruby
# app/models/image.rb

class Image

  # Assign the file location and formats to constants so they 1) are
  # easy to find for future edits and 2) to make the methods that use  
  # them more readable.
  IMAGES_DIRECTORY = '/assets/images/'
  ACCEPTABLE_FORMATS = %w(jpg jpeg png)

  # WIP: an array of full filepaths is ALMOST what we need
  def self.sample
  # Gets an array of image filepaths from the '/assets/images/' directory.
  # Ex: 'app/assets/images/ryan-gosling05.jpg'
    Dir.glob("*#{IMAGES_DIRECTORY}*.{#{ACCEPTABLE_FORMATS.join(',')}}").sample
  end

end
```
Since I may change my mind about which image file types are acceptable (and because I'm going to need to access them for testing), I've made them available as constants. The same goes for the location of the files. With that information in place, I can use `Dir.glob` to provide me with an array of image filepaths. That's *almost* the same array that we had before, but _I didn't have to type a single filename_. :high_five:, Ruby, I love you. This is serious progress.

To convert the array of filepaths into an array of just the filenames, I first reached for `regex`. I used the Ruby `match` method to take everything after the `IMAGES_DIRECTORY` text. That approach looked like this:

```ruby
def self.image_file_names
  # Using 'match' is convenient for regex, but regex is hard to read
  array_of_filepaths.map { |path| path.match(/#{IMAGES_DIRECTORY}(.*)/)[1] }
end
```

Since I am a human, I find regex a bit cumbersome to read. Good thing Ruby has another nifty library to help with that. `File` has a handy method called `basename` that knows how to extract just the filename out of a filepath. Thanks, Ruby.

```ruby
def self.image_file_names
  # Much easier to read or to google for more info
  array_of_filepaths.map { |path| File.basename(path) }
end
```

### After: Image Model
The shiny new `Image` class looks like this:

```ruby
# app/models/image.rb

class Image

  IMAGES_DIRECTORY = '/assets/images/'
  ACCEPTABLE_FORMATS = %w(jpg jpeg png)

  # Use the new array of filenames to grab a .sample
  def self.sample
    self.image_file_names.sample
  end

  private

  # Map the array into just the image filenames
  def self.image_file_names
    self.filepaths.map { |path| File.basename(path) }
  end

  def self.filepaths
    Dir.glob("*#{IMAGES_DIRECTORY}*.{#{ACCEPTABLE_FORMATS.join(',')}}")    
  end

end
```

With this fancy new scalable `Image` structure in place, I added 20 more Ryan Gosling pics, for a total of 30 possible random images to be assigned to an apology, and that's better for everyone... except maybe Ryan Gosling.

### But why didn't you...?

But why didn't I make the `Image` class a fully-instantiable, database-backed model? Good question. I considered it. I decided that it was overkill to have a whole table dedicated to a single `filename` field when I have no plans to allow users to upload their own photos or for an admin person to need this feature. It adds complexity to the database. It adds complexity to the relationship between `Apology` and `Image`. And for the foreseeable future, it's not necessary.

But why didn't I make a `@character_max = Apologies::CHARACTER_MAX` instance variable in the `apologies_controller` for the apologies views and javascript to access instead of adding it as an attribute on the `@apology` object? An instance variable in a controller is wild wild beast. It's essentially global, which is awesome if you're able to confirm that there won't be collisions in other parts of the app. But I'm not app-omniscient (yet... right ;) ) and I'm not sure what technical debt it might bring. So right now, I like to try to release as few wild beasts as possible into the views.
