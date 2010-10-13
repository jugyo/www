WWW
====

World Wide Web

Usage
----

app.rb

    # encoding: utf-8
    require 'www'

    class Foo < Www
      before do
        # do something
      end

      route '/' # /
      def index
        "index"
      end

      route '/foo' # /foo
      def foo(params)
        params
      end

      route %r{/regexp/?(.*)} # ex: /regexp/foo
      def regexp(arg, params)
        "#{arg} - #{params.inspect}"
      end

      route %r{/(\d{4})/(\d{2})/(\d{2})} # ex: /2009/10/10
      def entry(year, month, date)
        [year, month, date]
      end
    end

config.ru

    require 'app'
    run Www

rackup

    % rackup config.ru

TODO
----

* handle static files
* view
* redirect
* template
* layout
* url helper
* namespace

Run Examples
----

    shotgun -Ilib examples/config.ru

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
