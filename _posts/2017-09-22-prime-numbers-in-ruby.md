---
layout: post
title:  Finding Prime Numbers in Ruby
date:   2017-09-22
---

Code quizzes commonly have a prime number challenge, which got me to thinking, shouldn't there already be an `is_prime` method? Well, yes, there should be. And in Ruby, there is.

Ruby has a <a href="https://ruby-doc.org/stdlib-1.9.3/libdoc/prime/rdoc/Prime.html" target="_blank" rel="noopener">`Prime` class</a> and it does some useful things for you when you `require 'prime'` in your file. Two of my favorites are:

#### Return true if a given number is prime

```ruby
require 'prime'

Prime.prime?(8753)
#=> true

Prime.prime?(4)
#=> false
```

Awwwwww yeah! That's the stuff right there.

#### Generate a list of primes starting with 2 through a given number

```ruby
require 'prime'

Prime.each(27) do |prime|
  p prime
end

#=> 2, 3, 5, 7, 11, 13, 17, 19, 23
```

Those two methods alone have pretty much handled any prime number code challenge that has come my way. If the challenge is about researching a programming language to see what options are available, this approach wins -- hooray!-- because learning a language's libraries and methods makes us stronger, faster, and more efficient. Ah yes, proficiency leads to efficiency... I like that.

### Creating our own `is_prime` method

But, I need to be honest with myself. The code challenges involving math are usually focused on language-indiscriminate programming savvy to solve a math problem, not about accessing the libraries or gems you'd probably use in real life. Code challenges like to make you do logic calisthenics, so let's do this thing the hard way.

Here's some pseudocode for my approach:

- Create a range of numbers from 2 to one less than the number in question (`num - 1`)
- Loop through that range
  - Ask if the number in question (`num`) is cleanly divisible by each number in the range (`n`)
  - If any one of those range numbers (`n`) creates a 0 remainder when the number in question (`num`) is divided by that number (`n`), the number in question (`num`) is not prime
- If at the end of the loop, none of the range numbers (`n`) created a 0 remainder, the number in question (`num`) is, indeed, prime


### And now for the actual code

#### Using the Ruby `each` loop:


```ruby
def is_prime(num)
  (2..(num - 1)).each do |n|
    return false if num % n == 0
  end
  true
end

is_prime(7)
#=> true

is_prime(4)
#=> false
```

#### Using a Ruby `while` loop:

```ruby
def is_prime(num)
  n = 2
  while n < num
    return false if num % n == 0
    n += 1
  end
  true
end

is_prime(7)
#=> true

is_prime(4)
#=> false
```

The Ruby while loop approach might feel familiar to people coming to Ruby from JavaScript because its iteration is transparent like <a href="https://www.w3schools.com/js/js_loop_for.asp" rel="noopener" target="_blank">JavaScript's for loop</a>. After all, there's none of that kludgy `(2..(num - 1))` to define the iteration range like there is in the Ruby `each` loop. For good measure, here is a JavaScript version of `isPrime`.

#### Using the JavaScript `for` loop:

```javascript
function isPrime(num){
  for (n = 2; n < num; n++) {
    if (num % n == 0) return false;
  }
  return true;
}

isPrime(7);
//=> true

isPrime(4);
//=> false
```
