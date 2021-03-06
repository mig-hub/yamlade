# Start me with : rackup rack.ru
# Default port is 9292

require File::expand_path('../yamlade', File.dirname(__FILE__)) # When installed, just use : require 'yamlade'

# PUBLIC ROOT

map '/' do
  run Rack::File.new(File.expand_path('./public', File.dirname(__FILE__)))
end

# EDIT

map '/edit' do
  run lambda { |env|
    request = Rack::Request.new(env)

    @conf = Yamlade.new("options.yml")
    if request.post?
      @conf.update(request['yaml'])
    end

    [ 200, {'Content-Type' => 'text/html'}, @conf.to_form(request.path_info) + "<br /><br /><a href='/inspect'>&gt;&gt; INSPECT</a>" ]
  }
end

# INSPECT

map '/inspect' do
  run lambda { |env|
    [ 200, {'Content-Type' => 'text/html'}, YAML.load_file("options.yml").inspect ]
  }
end