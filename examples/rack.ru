# Start me with : rackup rack.ru
# Default port is 9292

require File::expand_path('../yamlade', File.dirname(__FILE__)) # When installed, just use : require 'yamlade'

$:.unshift(::File.dirname(__FILE__)) # Add parent folder to the path

# EDIT

edit = proc do |env|
  request = Rack::Request.new(env)
  
  @conf = Yamlade.new("options.yml")
  if request.post?
    @conf.update(request['yaml'])
  end
  
  [ 200, {'Content-Type' => 'text/html'}, @conf.to_form(request.path_info) ]
end

map '/edit' do
  run edit
end

# SEE

see = proc do |env|
  [ 200, {'Content-Type' => 'text/html'}, YAML.load_file("options.yml").inspect ]
end

map '/see' do
  run see
end