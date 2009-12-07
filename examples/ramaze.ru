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
    @conf.to_form(request.path_info)
  end
  
  # /see
  def see
    YAML.load_file("options.yml").inspect
  end
  
end

Ramaze.start(:root => __DIR__, :started => true, :mode => :dev)
run Ramaze