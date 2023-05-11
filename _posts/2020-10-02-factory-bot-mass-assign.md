---
layout: post
title:  "Mass-assign empty strings in FactoryBot"
date:   2020-10-02
published: true
---

I recently had to write some RSpec specs for an importer job that pulled in `claims` data to a table that had 600 columns. That was fine until we found out that all of those columns had to be set to `null: false`. Now in order to write a spec for a single one of these objects, _we had to have some non-null value in all 600 attributes._ Yikes.

Fortunately, `"" != nil`. This means we could mass assign all attributes to an empty string (`""`) and the null constraints were satisfied. This is how to mass-assign `""` to an object with the Rails gem, [FactoryBot](https://github.com/thoughtbot/factory_bot):

```ruby
factory :claims do
  # This table has null constrains on all (~600) columns.
  # This block mass-assigns an empty string to each attribute:
  initialize_with do
    new(Claims.new.attributes.symbolize_keys.transform_values(&:to_s))
  end
end
```

Now, in your spec, you can treat this factory as you normally would, overriding the default `""` values as needed:
```ruby
let(:claims) { create(:claims, name: 'sunshine', location: 'all the dark corners of the world') }
```
