Www
====

World Wide Web

Usage
----

app.rb

    # encoding: utf-8
    require 'www'

    class Foo < Www::Base
      before do
        # do something
      end

      get '/'
      def index
        "index"
      end

      get '/foo'
      def foo(params)
        params
      end

      get %r{/regexp/?(.*)} # ex: /regexp/foo
      def regexp(arg, params)
        "#{arg} - #{params.inspect}"
      end

      get %r{/(\d{4})/(\d{2})/(\d{2})} # ex: /2009/10/10
      def entry(year, month, date)
        [year, month, date]
      end
    end

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

    shotgun -Ilib example/config.ru

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
