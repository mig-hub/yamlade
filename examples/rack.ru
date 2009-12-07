# Start me with : rackup ramaze.ru
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
  form = "<form action='#{request.path_info}' method='POST' enctype='multipart/form-data'>#{@conf.to_form}<input type='submit' name='save' value='SAVE' /></form>"
  
  [ 200, {'Content-Type' => 'text/html'}, form ]
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