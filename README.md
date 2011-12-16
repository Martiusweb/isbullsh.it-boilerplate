# isBullsh.it boilerplate

A blog powered by jekyll that we're building.

## Authors

Current contributors are :

 - Paul Adenot
 - Martin Richard
 - Balthazar Rouberol
 - Thibaut Vuillemin
 - Nicolas Silva

## TODO

 - On the home page, add a sidebar like in the post page with blog informations
   (like RSS feed link, etc).
 - Add pagination to the archive pages.
 - Plugin which generates rss/Atom for each tag

## Minification

CSS and JS can be minified using Juicer :

    gem install juicer
    juicer install jslint
    juicer install yui_compressor

Currently, minification is not yet fully automatic. Once Jekyll generated the
static content, please run:

    rake juicer:css
    rake juicer:js

## Good practices

 - Tag names (in article files) must be in lower-case
 - Add any new author to _config.yml, parameter "author"
 - Posts naming convention : YYYY-MM-DD-First-word-with-uppercase.mdwn
 - absolute path in img src, for images to display in feeds
