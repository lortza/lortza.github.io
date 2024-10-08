---
layout: page
title: portfolio
permalink: /portfolio/
---

<div class="portfolio-index">

  <h2>Web Applications</h2>

  <p class="section-explanation">I am almost always engrossed in building a tool that solves a problem for myself. This is a small sampling of the projects I have built to address those problems. Several of the repo READMEs have a tour of the app with screenshots and code snippets of the parts I find most interesting.</p>

  <div class="rails-sites">
    <div class="projects-subhead">
      <h1>Featured Project</h1>
    </div> <!-- projects-subhead -->
  {% for project in site.projects %}
    {% if project.published and project.featured %}

      <div class="featured">
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
    {% endif %}
  {% endfor %}
  </div>

  <div class="rails-sites">
    <div class="projects-subhead">
      <h1>More Projects</h1>
    </div>


  {% for project in site.projects %}
    {% if project.published and project.featured == false %}
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
    {% endif %}
  {% endfor %}
  </div>

  <h2>Current Skills</h2>

  <p class="section-explanation">Ruby, Rails, Action Cable, Hotwire, RSpec & testing, CSS3, BEM & utility classes, JavaScript, React.js, Redux, jQuery, PostgreSQL, Git, GitHub, BitBucket, Heroku, Firebase, Jekyll, XML & JSON parsing, database design, product design and launch, copy editing, and graphic design</p>

  <h2>Recommendations</h2>
  <p> If you'd like an idea of what it's like to work with me,  <a href="{{site.linkedin_recommendation_url}}" target="_blank" alt="Linkedn recommendations" title="Linkedn recommendations">here are some of the things my clients and coworkers have said about me</a>.
  </p>

  <h2>Open Source Contributions</h2>

  <div class="open-source">
    {% for contribution in site.opensource_contributions reversed %}
      {% if contribution.published %}
        <article>
          <h3>
            <a href="{{contribution.site_url}}" target="_blank" alt="{{contribution.name}}">{{contribution.name}}</a>
            <span class="post-meta"> - {{ contribution.date | date: '%B %-d, %Y' }}</span>
          </h3>
          {{contribution.content}}
        </article>
      {% endif %}
    {% endfor %}
  </div><!-- open-source -->


  <!--<h2>How I Pursue Ongoing Learning</h2>
  <div class="center-column">
    <ul>
      <li>Weekly mentor sessions for code reviews</li>
      <li>Daily podcasts (currently loving <em>Syntax</em> by WesBos)</li>
      <li>Daily Slack community engagement</li>
      <li>Weekly tech Meetups where I learn new things or help others to solve problems</li>
      <li>Teaching others</li>
      <li>Occasional open source contributions</li>
      <li>Collaborating with others on side projects</li>
      <li>Ongoing side projects</li>
      <li>Blogging</li>
      <li>Tutorials when needed for depth</li>
      <li>Annual tech conferences (Rails Conf, Ruby Conf, etc.)</li>
      <li>Incorporation of CodeClimate, Reek, and Rubocop automated code reviews for feedback</li>
    </ul>
  </div>-->

  <h2>Published Works</h2>

  <p class="section-explanation">Whenever I have an idea for something that solves a particular problem, I dive in and start creating. Sometimes it's a solution I can use right now (zipper pocket underpants) and other times, it's a solution that I wish had existed when I needed it (book on packing), so I created it to solve the problem for other people.</p>

  <div class="products">
    {% for product in site.products reversed %}
      {% if product.published %}
        <article>
          <a href="{{product.store_url}}" target="_blank" alt="{{product.store_name}}"><img src="{{product.img}}"></a>
          <div class="explanation">
            <a href="{{product.store_url}}" target="_blank" alt="{{product.store_name}}"><h3>{{product.name}}</h3></a>
            <p>{{product.description}} <a href="{{product.store_url}}" target="_blank" alt="{{product.store_name}}">See it on {{product.store_name}}</a></p>
          </div>
        </article>
      {% endif %}
    {% endfor %}
  </div><!-- products -->

<!--
  <h2>Writing</h2>
  <p class="section-explanation">These are some places where I contribute blog posts or content.</p>

  <div class="writing">
    {% for writing in site.writings reversed %}
      {% if writing.published %}
        <article>
          <h4><a href="{{ writing.site_url }}">{{ writing.title }}</a></h4>
          {{ writing.content }}
        </article>
      {% endif %}
    {% endfor %}
  </div>
-->
</div> <!-- portfolio-index -->
