---
layout: post
title:  "Script to search for files and folders from the command line"
date:   2019-08-25
published: true
---

Have you ever renamed a resource in a Rails project but missed a filename or folder name somewhere? Yeah, guilty. Wouldn't it be handy to run a script that searches for a search term in both the filenames and folders in your project directory? I thought so, and I made one today :)

```bash
# save this somewhere with your scripts.sh

# Search for files and folders with a a search term in their name.
# Run like: find_files yoursearchterm
find_files() {
  project=$(basename `pwd`)

  echo "Search results for '${@}' in /${project}..."
  echo ""
  echo "-> filename:"
  find . -name "*${@}*" -print
  echo ""
  echo "-> folder name:"
  find . -name "*${@}*" -type d
}
```

### Sample Output
This is sample output from a standard Rails app.

```bash
$ find_files yoursearchterm

Search results for yoursearchterm in /yourprojectdirectory...

-> filename:
./app/controllers/yoursearchterm_controller.rb
./app/controllers/yoursearchterm
./app/views/yoursearchterm
./app/helpers/yoursearchterm_helper.rb
./spec/requests/yoursearchterm_spec.rb
./spec/factories/yoursearchterm.rb
./spec/routing/yoursearchterm
./spec/routing/yoursearchterm_routing_spec.rb
./spec/controllers/yoursearchterm_controller_spec.rb
./spec/views/yoursearchterm
./spec/helpers/yoursearchterm_helper_spec.rb
./db/migrate/20190616232503_change_pt_sessions_to_yoursearchterm.rb

-> folder name:
./app/controllers/yoursearchterm
./app/views/yoursearchterm
./spec/routing/yoursearchterm
./spec/views/yoursearchterm
```

You'll still need to do the find-and-replace work inside the files themselves, but this will help you catch those rogue files and folders that I often miss.

Not sure how to set up a shell script on Mac? [This post may help]({% post_url 2018-10-01-shell-script-mac %}).
