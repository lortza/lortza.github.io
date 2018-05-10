# Anne's Portfolio and Blog Site

This is my personal web development portfolio and blog [site](http://lortza.github.io/). All of the content on this site is... mine, you dig?

- jekyll 3.6.2
- ruby 2.4.2
- the design is modified from the original <a href="http://liabogoev.com/-folio" target="_blank">folio theme</a> by [Lia Bogoev](http://liabogoev.com/)

## Notes to Self

- The order of projects is based on calendar date (most recent on top). I've chosen to order every `.md` as a date in Jan 2017 and move projects around within those 31 days to order them.

### About the Theme

This theme is *not* one of the select GitHub-approved themes, so it can not be updated through the GitHub theme interface. The different iterations of this site live on different branches in this repo.

-  `folio_theme` (03-2018) <-- current
-  `single_page_theme` (04-2017)

### Updating the Site

The theme deploys from the `master` branch. Whenever changes are made to the site, be sure to merge those changes into the `folio_theme` branch and then push both branches. In other words, make sure `folio_theme` is an up-to-date backup of `master`.

Jekyll is installed in the `ruby 2.4.2` gem, so rvm it before starting `jekyll serve`.
