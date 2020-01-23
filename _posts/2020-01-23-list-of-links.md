---
layout: post
title:  "WIP"
date:   2020-01-23
published: false
---

https://github.com/lortza/food_planner/pull/182

I found myself wanting to get to the recipe easily from this page but there were no links to do so. Now each recipe title is linked to the recipe show page.



Things Learned
It sure was handy having the danebook project as reference when i needed to map over a bunch of items and return a link.

# the danebook code snippet

  def list_likes(likes)
    raw(likes.limit(3).map do |like|
      link_to like.user.name, user_timeline_path(like.user)
    end.join(", "))
  end
# the code in this PR
def display_recipes(meal_plan)
  raw(meal_plan.recipes.map do |recipe|
    link_to recipe.title, recipe
  end.join(', '))
end
I should probably write a blog post about this so that I can find it again more easily and also help others to solve this problem.
