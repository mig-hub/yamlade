# Start me with : rackup rack.ru
# Default port is 9292

require 'sinatra/base'
require File::expand_path('../yamlade', File.dirname(__FILE__)) # When installed, just use : require 'yamlade'

class SinatrApp < Sinatra::Base
  set :app_file, __FILE__
  set :root, File.dirname(__FILE__)

  get '/?' do
    @conf = Yamlade.new("options.yml")
    @conf.to_form(request.path_info) + "<br /><br /><a href='/inspect'>&gt;&gt; INSPECT</a>"
  end
  
  post '/?' do
    @conf = Yamlade.new("options.yml")
    @conf.update(request['yaml'])
    @conf.to_form(request.path_info) + "<br /><br /><a href='/inspect'>&gt;&gt; INSPECT</a>"
  end
  
  get '/inspect' do
    YAML.load_file("options.yml").inspect
  end
  
end

run SinatrApp