---
layout: post
title:  Keeping your Polymorphic "like"s Code DRY
date:   2018-01-30 03:53
---

I was recently setting up a social media app with BlogPosts, PhotoPosts, and Comments -- and I needed to have users be able to "like" and "comment" on all three of those models. My first crack at it involved some duplicate code. And that's fine. In Sandi Metz's [POODR](http://www.poodr.com/), she recommends waiting until you see a pattern 3 times before refactoring. And that's exactly what happened, so here are some ways I DRYed up my code.

## Approach 1: Extract class methods into a Concern module

Instead of having all 3 models have duplicate code like this:

{% highlight ruby %}
  # app/models/blog_post.rb
  class BlogPost < ApplicationRecord
    belongs_to :user
    has_many :likes, as: :likeable
    has_many :comments, as: :commentable
    ...
    validates :user_id, :user, :body, presence: true

    def has_likes?
      likes.any?
    end

    def has_comments?
      comments.any?
    end

  end

  # app/models/photo_post.rb
  class PhotoPost < ApplicationRecord
    ...
    belongs_to :user
    has_many :likes, as: :likeable
    has_many :comments, as: :commentable

    def has_likes?
      likes.any?
    end

    def has_comments?
      comments.any?
    end
  end

  # app/models/comment.rb
  class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :commentable, polymorphic: true
    has_many :likes, as: :likeable
    ...
    def has_likes?
      likes.any?
    end
  end
{% endhighlight %}

You can extract the duplicated `likes` and `comments` code into their own concern files like this:

{% highlight ruby %}
  # app/models/concerns/liking.rb

  module Liking
    extend ActiveSupport::Concern

    included do
      has_many :likes, as: :likeable
    end

    def has_likes?
     likes.any?
    end

  end
{% endhighlight %}


{% highlight ruby %}
  # app/models/concerns/commenting.rb

  module Commenting
    extend ActiveSupport::Concern

    included do
      has_many :comments, as: :commentable
    end

    def has_comments?
     comments.any?
    end

  end
{% endhighlight %}

And then DRY up those models with `include` statements like this:

{% highlight ruby %}
  # app/models/blog_post.rb
  class BlogPost < ApplicationRecord
    belongs_to :user
    include Liking
    include Commenting
    ...
    validates :user_id, :user, :body, presence: true
  end


  # app/models/photo_post.rb
  class PhotoPost < ApplicationRecord
    ...
    belongs_to :user
    include Liking
    include Commenting
  end


  # app/models/comment.rb
  class Comment < ApplicationRecord
    belongs_to :user
    belongs_to :commentable, polymorphic: true
    include Liking
  end
{% endhighlight %}

Wow. That's much drier.

## Approach 2: Adapt Methods to Handle Multiple Types of Objects

There are plenty of ways to do this, some of which get into metaprogramming (which is thrilling, but sometimes a little dense). Here I'll show you an example of a simple refactor and one with some metaprogramming.

### Example 1: The Generic Object

Much like above, here are 3 view helpers with *really similar* methods.

{% highlight ruby %}
  # app/helpers/blog_posts_helper.rb
  module BlogPostsHelper

    def display_users_who_liked_blog_post(blog_post)
      blog_post.likes.map do |like|
        link_to like.user.name, like.user
      end
    end
  ...
  end

  # app/helpers/photo_posts_helper.rb
  module PhotoPostsHelper

    def display_users_who_liked_photo_post(photo_post)
      photo_post.likes.map do |like|
        link_to like.user.name, like.user
      end
    end
  ...
  end

  # app/helpers/comments_helper.rb
  module CommentsHelper

    def display_users_who_liked_comment(comment)
      comment.likes.map do |like|
        link_to like.user.name, like.user
      end
    end
  ...
  end
{% endhighlight %}

Not only are those methods cringe-worthily long, *they're repeated 3 times*. Ack! Fortunately, Ruby lets you call methods on variables all over the place, so using a generic object in place of a specific one aint no thang. Just ensure you have the same relationships to `likes` across each model receiving the call (which you can achieve easily if you've employed the concern aproch above), then use a generic object like this:

{% highlight ruby %}
  # app/helpers/likes_helper.rb
  module LikesHelper

    def display_users_who_liked(object)
      object.likes.map do |like|
        link_to like.user.name, like.user
      end
    end
  ...
  end
{% endhighlight %}

Ahhhhhh... much better.

Are you ready to get a little meta?

### Example 2: Getting Meta by Extracting a Class from an Object and Using `send`

Using `send` is probably one of my favorite means of metaprogramming. It's just so flexible! Every time I find myself thinking "aw jee, if I could just customize this method and it would solve <em>everything</em>," it usually means `send` is in order. Personally, I think you have to strike a balance between DRY and readable. Since we spend most of our time reading code, it makes sense to have easily readable code. Future me always appreciates when past me has been thoughtful in this regard. Though this method gets a little dense, I think it's still readable.

When a user is looking at a stream of content (blog posts, photos, and their respective comments), I needed to give them the option to `Like` and `Unlike` any of these objects. This helper method toggles the `Like` / `Unlike` links.

{% highlight ruby %}
  # app/helpers/likes_helper.rb

  module LikesHelper

    def display_like_unlike(object)

      # capture the class of the object being passed in to the method
      klass = object.class.to_s

      # The User model has an association for each object it likes, ex: posts_they_like
      # Using `send` here allow us to build a string to match that association
      if current_user.send("#{klass.downcase.pluralize}_they_like").include?(object)
        # Here we grab the current_user's `like` from the list of `like` for this object
        like = Like.current_user_like(object, current_user)
        # then we use the `klass` again to locate the record on the `likeable` table info
        link_to 'Unlike', polymorphic_url([current_user, object, like], likeable: klass), method: :delete
      else
        link_to 'Like', polymorphic_url([current_user, object, :likes], likeable: klass), method: :post
      end
    end

  end
{% endhighlight %}

Okay, so it's a little dense and requires some research on building [`polymorphic_url`](http://api.rubyonrails.org/classes/ActionDispatch/Routing/PolymorphicRoutes.html)s, but it's way better than the crazy conditional that would have been in it's place. `Like`s are a little complex, and I enjoyed working through this puzzle. I hope it sheds some light on some approach options for you too.
