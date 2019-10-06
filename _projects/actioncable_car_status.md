---
layout: project
name: Action Cable Status Reporter
date: 2017-01-10
repo: https://github.com/lortza/action_cable_car_status
readme: true
img: /img/project_actioncable.png
tagline: Both Console and Controller Updates
description: This app tracks the status of vehicles on a car lot. It pushes updates to users' browsers via Action Cable when the <code>status_id</code> field of a car changes. It works both for browser-initiated updates as well as console-initiated updates (as a stand-in for ETL db updates). When a browser user updates a car's status, they get the normal Rails notice and all other users get an Action Cable alert. If an update happens via the console, all users get an Action Cable alert.
role: solo project, full stack
tech_used: Rails 5.0.1, Action Cable, Redis, Ruby 2.5.0, PostgreSQL, Coffee Script, jQuery
codeclimate: <a href="https://codeclimate.com/github/lortza/action_cable_car_status/maintainability"><img src="https://api.codeclimate.com/v1/badges/550dbb37f7e19d0060b6/maintainability" /></a>
published: false
featured: false
---
