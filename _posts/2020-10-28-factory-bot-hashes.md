---
layout: post
title:  "Using FactoryBot for hashes"
date:   2020-10-28
published: true
---

Sometimes in your test suite you have some big ol' hashes that you need to build frequently. Having big ol' hashes being passed all around RSpec is a red flag for me -- why are we using a hash and not a proper Ruby class? But sometimes it is what it is and sometimes you have to sling a little dirty code. The good news is, if you're already using the [FactoryBot gem](https://github.com/thoughtbot/factory_bot), you can enlist it to help you with these hashes.

This is what your factory would look like if you were writing awesome specs about kittens:
```ruby
FactoryBot.define do
  # Notice the "class: Hash" at the end of this line
  factory :default_kitten_attributes, class: Hash do
    breeds do
      [
        { name: 'Aegean', origin: 'Greece', type: 'Natural' },
        { name: 'California Spangled', origin: 'The United States', type: 'Crossbreed' }
      ]
    end
    colors do
      [
        { name: 'orange' },
        { name: 'white' },
        { name: 'black' }
      ]
    end
    skills do
      [
        { name: 'mousing', level: 1 },
        { name: 'balance beam', level: 3 },
        { name: 'jumping through hoops', level: 8 },
        { name: 'drums', level: 6 },
        { name: 'saxophone', level: 5 }
      ]
    end
    # Since this factory is for a hash and not an ActiveRecord model, you cannot
    # ever "create" it. You'll need this line to tell FactoryLint not to try to create it.
    skip_create

    # Tell the factory how to initialize this non-standard set of data
    initialize_with { attributes }
  end
end
```
_(yes, these are all [real circus cat skills](https://www.youtube.com/watch?v=c4-i7PSzAfA) and you can learn more about them [here](https://rockcatsrescue.org/), meow!)_


Then, just like you'd `build` a regular ActiveRecord-backed object in RSpec, you can _build_ (but **not** `create`) this factory hash object:
```
let(:attrs) { build(:default_kitten_attributes) }
```

When you invoke it, you'll get:
```ruby
attrs
=> {:breeds=>[{:name=>"Aegean", :origin=>"Greece", :type=>"Natural"}, {:name=>"California Spangled", :origin=>"The United States", :type=>"Crossbreed"}],
 :colors=>[{:name=>"orange"}, {:name=>"white"}, {:name=>"black"}],
 :skills=>
  [{:name=>"mousing", :level=>1},
   {:name=>"balance beam", :level=>3},
   {:name=>"jumping through hoops", :level=>8},
   {:name=>"drums", :level=>6},
   {:name=>"saxophone", :level=>5}]}
```
