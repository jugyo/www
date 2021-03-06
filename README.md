Www
====

World Wide Web

Usage
----

app.rb

    # encoding: utf-8
    require 'www'

    class App < Www::Base
      get '/'
      def index(params)
        params
      end

      get '/foo'
      def foo
        haml :title => 'foo', :body => 'bar'
      end

      get '/(\d{4})/(\d{2})/(\d{2})' # ex: /2009/10/10
      def entry(year, month, date)
        [year, month, date]
      end
    end

foo.haml

    %h2= title
    %p= body

example.haml (as template)

    !!!
    %html
      %head
        %title= 'www-example'
      %body
        %h1 www-example
        != yield

config.ru

    require 'app'
    run Www::App

rackup

    % rackup config.ru

TODO
----

* specs
* handle static files
* view
* redirect
* template
* layout
* url helper
* namespace

Run Example
----

    % cd example
    % shotgun -I../lib config.ru

Note on Patches/Pull Requests
----
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

Copyright
----

Copyright (c) 2010 jugyo. See LICENSE for details.
