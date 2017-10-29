---
layout: post
title:  Using Variables in CSS
date:   2017-07-12 03:02
---

If you find yourself working in CSS and missing the ability to use SASS variables, oh boy do I have a treat for you. You <em>can</em> use variables in CSS. They just look a little bit different than they do in SASS.

Set them up in a root block at the top of your stylesheet:

{% highlight ruby %}

:root {
  --brand-color: #2C9C20;
  --secondary-color: #317BE1;
  --fave-size: 50px;
}
{% endhighlight %}

And use them in a class with a <code>var()</code>:

{% highlight ruby %}


:root {
  --brand-color: #2C9C20;
  --secondary-color: #317BE1;
  --fave-size: 50px;
}

.awesome-class {
    background-color: var(--brand-color);
    height: var(--fave-size);
}
{% endhighlight %}

They even work inside the CSS <code>calc()</code> function:

{% highlight ruby %}

.awesome-class {
    ...
    margin-bottom: calc(var(--height) * 2);
}
{% endhighlight %}

Hooray! This discovery really made my day.