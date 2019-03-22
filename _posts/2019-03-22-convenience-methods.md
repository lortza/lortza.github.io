---
layout: post
title:  "Convenience Methods in Rails are so... Convenient"
date:   2019-03-22
published: true
---
Several months ago in a code review, someone suggested to me that I wrap a model constant in a convenience method. I thought, "hmmm okay. This seems superfluous, but I'll give it a go." But then last night, the a-ha moment happened.

I needed to write specs for a couple of methods that called two constants and two helper methods, and I found myself doing a bunch of brittle math inside of my specs. I don't like finding myself doing math at all, and math that leads to brittle specs is double whammy of _nope_. The lightbulb in my head snapped on and I wrote a couple of convenience methods.

In my `Plan` class, I have 2 constants. I call those constants in a couple of methods.

```ruby
class Plan < ApplicationRecord

  EFFICIENCY_RATE = 0.66
  PREP_END_TIME = '5:00 PM'.to_time

  def estimated_time
    (total_time * EFFICIENCY_RATE).to_i
  end

  def recommended_start_time
    (PREP_END_TIME - estimated_time * 60).strftime('%I:%M %p')
  end
end
```

So that's cool. But I need to figure out how to test those methods.
```ruby
describe '#estimated_time' do
  let(:plan) { create(:plan) }

  it 'will output a time X% shorter than the total time' do
    #
    # somehow make this happen
    #
    expect(plan.estimated_time).to eq(  exactly Plan::EFFICIENCY_RATE less than the total time  )
  end
end

describe '#recommended_start_time' do
  let(:plan) { create(:plan) }

  it 'outputs the correct hour' do
    #
    # somehow make this happen
    #
    expect(plan.recommended_start_time).to eq( a time that is Plan::EFFICIENCY_RATE less than Plan::PREP_END_TIME )
  end
```
This is hard to do. Currently, the `EFFICIENCY_RATE` value is 0.66. That makes for annoying math, plus it's brittle to state that value explicitly in the test. So let's make some shiny new convenience methods:

```ruby
class Plan < ApplicationRecord

  EFFICIENCY_RATE = 0.66
  PREP_END_TIME = '5:00 PM'.to_time

  def estimated_time
    # Replace the constant `EFFICIENCY_RATE` with the
    # new `efficiency_rate` method
    (total_time * efficiency_rate).to_i
  end

  def recommended_start_time
    # Replace the constant `PREP_END_TIME` with the new
    # `prep_end_time` method
    (prep_end_time - estimated_time * 60).strftime('%I:%M %p')
  end

  private

  # Now `efficiency_rate` will return EFFICIENCY_RATE or whatever
  # I need it to return in the test
  def efficiency_rate
    EFFICIENCY_RATE
  end

  # Same thing here: `prep_end_time` will return PREP_END_TIME
  # or whatever I need it to return in the test
  def prep_end_time
    PREP_END_TIME
  end
end
```
### On to the specs!
Now we can turn to our good friend allow-to-receive-and-return (a.k.a [method stubs](https://relishapp.com/rspec/rspec-mocks/v/2-14/docs/method-stubs)). When you have to test a method that depends on other methods, but you need those dependencies to return specific things, it can get tricky fast. Using allow-to-receive-and-return is great because you can just mock out those dependencies (or totally fake the unimportant parts) and get down to business truly isolating the method you want to test.

Here, you'll see that I'm setting values for the dependencies `total_time` and `efficiency_rate`, which used to be just the constant `EFFICIENCY_RATE`. And now I can do simple, predictable math to test my `estimated_time` method.

```ruby
describe '#estimated_time' do
  let(:plan) { create(:plan) }

  it 'will output a time X% shorter than the total time' do
    # Outline what the expected values should be with Very Simple Math
    minutes = 100
    rate = 0.5
    est_time = 50

    # Tell `total_time` that its new value in this spec is 100.
    allow(plan).to receive(:total_time).and_return(minutes)

    # Tell `efficiency_rate` (formerly an untouchable constant) that
    # its new value in this spec is 0.5.
    allow(plan).to receive(:efficiency_rate).and_return(rate)

    # Now when `estimated_time` is called, it employs those 2
    # values from above and outputs the calculation
    expect(plan.estimated_time).to eq(est_time)
  end
end
```

I've taken the same approach with this method by setting values for the dependencies `estimated_time` and `prep_end_time`, which used to be just the constant `PREP_END_TIME`. And now I can do simple, predictable math to test my `estimated_time` method.

```ruby
describe '#recommended_start_time' do
  let(:plan) { create(:plan) }

  it 'outputs in time format' do
    # Outline what the expected values should be with Very Simple Math
    time = '12:00 PM'.to_time
    est_minutes = 60
    expected_time = '11:00 AM'.to_time.strftime('%I:%M %p')

    # Tell `estimated_time` that its new value in this spec is 60.
    allow(plan).to receive(:estimated_time).and_return(est_minutes)
    # Tell `prep_end_time` (formerly an untouchable constant) that
    # its new value in this spec is a timestamp of Noon.
    allow(plan).to receive(:prep_end_time).and_return(time)

    # Now when `recommended_start_time` is called, it employs those 2
    # values from above and outputs the calculation
    expect(plan.recommended_start_time).to eq(expected_time)
  end
end
```
Isn't that nice? Now both of those methods are tested in isolation. There was no overreaching, no scope creep, just full confidence that they're working as expected.

### But why not ditch the constants?
So why not just ditch the constants all together? Why bother writing them, just to wrap them when I could just set the method to return what the constant returns? Why not skip the middleman?

<a href="http://www.quickmeme.com/meme/3t9y28"><img src="http://www.quickmeme.com/img/03/034f6e98174583e154f326dce722c110810ea1487b69fa1d0bc7674545f8b21b.jpg" title="Office Space: What would you say you do here?" alt="Office Space Meme: What would you say you do here?" class="post-image"></a>



```ruby
# why not just do this:
def prep_end_time
  '5:00 PM'.to_time
end

# ...instead of this?
def prep_end_time
  PREP_END_TIME
end
```

Well, that's just, like, _my opinion_, man. But there are reasons behind my opinion. Both values stored by the constants are static values. They don't calculate anything and can be represented nicely by a variable. They're both things that feel a little bit like global settings. Storing them in constants at the top of a model feels like the natural place to look for this kind of information. Ultimately, this decision is more about convention and communication between developers than it is about DRYness.
