Gem::Specification.new do |s| 
  s.name = 'yamlade'
  s.version = "0.0.2"
  s.platform = Gem::Platform::RUBY
  s.summary = "Use YAML files to cook configuration Marmelade through HTML forms"
  s.description = "Do a YAML file, and Yamlade take care of the HTML forms for you"
  s.files = `git ls-files`.split("\n").sort
  s.require_path = '.'
  s.author = "Mickael Riga"
  s.email = "mig@mypeplum.com"
  s.homepage = "http://github.com/mig-hub/yamlade"
end