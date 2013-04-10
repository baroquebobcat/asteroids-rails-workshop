asteroids-rails-workshop
========================


Ruby
------

create a new rails app
-----------------------

create new rails app

    rails new asteroids -d sqlite3 -J -T -f --skip-bundle -m https://raw.github.com/github.com/baroquebobcat/asteroids-rails-workshop/master/template.rb

boot it up

    cd asteroids
    rails server

(push to heroku)

adding the javascript game in the rails app
-------------------------------------------

download the javascript

   wget or curl

put js in assets? or just dump the whole thing in public?

        cp js into assets

        html page that sets it up, empty controller, or public/index?

        make the js game the root index

        git ci

        (push to heroku)

add scores scaffolding
----------------------
date, score, initials


    rails generate scaffold top_score initials:string score:integer

migrate / update schema

    rake db:migrate


play with it

        git commit -m "blah"

        (push to heroku)

integrate top score w/ js app
-----------------------------


add form that asks for initials on end of game

ajax-ask for partial of scaffold new, putting it in a lightbox?

add link to top scores

        …

        git ci

        (push to heroku)

make things more awesome

        sort scores