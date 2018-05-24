---
layout: post
title:  How to Store API Keys and ENV Vars in a create-react-app Project
date:   2018-05-22
---

Conveniently, [create-react-app](https://github.com/facebook/create-react-app) has some built-in functionality to make storing and accessing your API keys and ENV variables easier. There's no need to install any other packages. Thank you [George Karametas](https://geodoo.work/hide-secure-api-keys-created-app-create-react-app/) for this insight. To access that functionality, you need to:

### 1. Create a file called `.env` in the root of your project's directory.

```
- your_project_folder
  - node_modules
  - public
  - src
  - .env         <-- create it here
  - .gitignore
  - package-lock.json
  - package.json
```

From the command line, check that you are in your project directory and type:
```
touch .env
```

This will create the file for you.

### 2. Inside the `.env` file, prepend `REACT_APP_` to your API key name of choice and assign it.

The create-react-app tool uses `REACT_APP_` to identify these variables. If you don't start your API key name with it, create-react-app won't see it.

```ruby
# .env

REACT_APP_YOUR_API_KEY_NAME=your_api_key  <-- yes
YOUR_API_KEY_NAME=your_api_key            <-- no

# Example:
REACT_APP_WEATHER_API_KEY=123456123456123456
```
### 3. Add the `.env` file to your `.gitignore` file.

You can add a single line with `.env` anywhere in your `.gitignore` file. You may want to give it a heading to keep your file organized. After you add it, save the `.gitignore` file and do a `git status` to make sure your `.env` file does not appear as a new file in git.

```ruby
# .gitignore

# api keys
.env       <-- add this line

# dependencies
/node_modules...
```

### 4. Access the API key via the `process.env` object.

Now you can access your API key from anywhere in your app with:
```
process.env.REACT_APP_YOUR_API_KEY_NAME
```

To make sure it works, go to your `App.js` file and add a `console.log` at the top below the require statements. After saving the file and refreshing the browser, if the console log does not show your API key, try restarting the react server. Remove the console log line before committing your code.

```js
// src/App.js

import React, { Component } from 'react';
import './App.css';

console.log(process.env.REACT_APP_WEATHER_API_KEY)

class App extends Component {
  ...
```

I've posted this as [an answer on StackOverflow](https://stackoverflow.com/a/50457996/5009528). If you found it helpful, [please upvote](https://stackoverflow.com/a/50457996/5009528).

