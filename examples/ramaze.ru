# Start me with : rackup ramaze.ru
# Default port is 9292

require 'rubygems'
require 'ramaze'
require File::expand_path('../yamlade', File.dirname(__FILE__)) # When installed, just use : require 'yamlade'

$:.unshift(::File.dirname(__FILE__)) # Add parent folder to the path

class MainController < Ramaze::Controller
 
  # /edit
  def edit
    @conf = Yamlade.new("options.yml")
    if request.post?
      @conf.update(request['yaml'])
    end
    "<form action='#{request.path_info}' method='POST' enctype='multipart/form-data'>#{@conf.to_form}<input type='submit' name='save' value='SAVE' /></form>" 
  end
  
  # /see
  def see
    YAML.load_file("options.yml").inspect
  end
  
end

Ramaze.start(:root => __DIR__, :started => true, :mode => :dev)
run Ramaze