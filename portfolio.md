---
layout: page
title: portfolio
permalink: /portfolio/
---

<div class="portfolio-index">

  <h2>Skills</h2>

  <p class="section-explanation">Ruby, Rails, Git, Sass, CSS, JavaScript, jQuery, Node.js, PHP, CodeIgniter, MySQL, PostgreSQL, SQLite, Heroku, XML, transactional Spanish, Card Game Design, and Bicycle Repair</p>

  <h2>Rails Projects</h2>

  <p class="section-explanation">Oh man. Rails is so much fun. There is so much you can do and so many people available to do it along with you. These are some of the apps I've made. Of course, looking back at the code now, there is so much to be improved. I just keep marching forward onto bigger challenges. This week's challenge: implementing faceted search for productmatchr.com.</p>

  <div class="rails-sites">
  {% for project in site.projects %}
    <div class="project">
      <div class="thumbnail">
        <a href="{{ project.url }}">
          {% if project.img %}
          <img class="thumbnail" src="{{ project.img }}"/>
          {% else %}
          <div class="thumbnail blankbox"></div>
          {% endif %}
          <span>
            <h1>{{ project.name }}</h1>
            <br/>
            <p>{{ project.tagline }}</p>
          </span>
        </a>
      </div>
    </div>
  {% endfor %}
  </div> <!-- .rails-sites -->

<h2>Published Works</h2>

<p class="section-explanation">Whenever I have an idea for something that solves a particular problem, I jump right in and make it. Sometimes it's a solution I can use right now (zipper pocket underpants) and other times, it's a solution that I wish had existed when I needed it (book on packing), so I created it to solve the problem for other people.</p>

<div class="products">

  {% for product in site.products reversed %}
    <article>
      <a href="{{product.store_url}}" target="_blank" alt="{{product.store_name}}"><img src="{{product.img}}"></a>
      <div class="explanation">
        <a href="{{product.store_url}}" target="_blank" alt="{{product.store_name}}"><h3>{{product.name}}</h3></a>
        <p>{{product.description}} <a href="{{product.store_url}}" target="_blank" alt="{{product.store_name}}">See it on {{product.store_name}}</a></p>
      </div>
    </article>
  {% endfor %}

</div><!-- products -->


<h2>Writing</h2>
<p class="section-explanation">These are some of the sites that I maintain or where I have contributed posts.</p>

<div class="writing">

{% for writing in site.writings reversed %}
  <article>
    <h4><a href="{{ writing.site_url }}">{{ writing.title }}</a></h4>
    <p>{{ writing.content }}</p>
  </article>
{% endfor %}

</div> <!-- writing -->

</div> <!-- portfolio-index -->
