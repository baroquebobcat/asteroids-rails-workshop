asteroids-rails-workshop
========================


Ruby
------

create a new rails app
-----------------------

create new rails app

    gem install rails
    rails new asteroids -d sqlite3 -J -T -f --skip-bundle -m https://raw.github.com/baroquebobcat/asteroids-rails-workshop/master/template.rb

Here is what each option is doing and why:

  -d - Specifies the SQLite3 database for quick and easy setup.
  -J - Skips adding any JavaScript libraries since jQuery UJS support is provided by the Resourcer gem.
  -T - Skips setting up Test::Unit files since RSpec is what we want.
  -f - Forces overwrite of any existing files so the template is not interrupted during setup.
  –skip-bundle - Skips running “bundle install” since the template does this for you at appropriate time of setup.

boot it up

    cd asteroids
    rails server

add scores scaffolding
----------------------
date, score, initials


    rails generate scaffold score initials:string score:integer

migrate / update schema

    rake db:migrate


play with it

        git commit -m "blah"


integrate top score w/ js app
-----------------------------


add link to top scores

        …

        git ci

make things more awesome

        sort scores
