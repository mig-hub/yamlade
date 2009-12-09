YAMLADE - Use YAML files to cook configuration Marmelade
--------------------------------------------------------

WHAT DOES IT DO ?
-----------------

Yamlade is made for config files of a web application.
Things that should be unique but still editable in a CMS.

HOW TO INSTALL IT ?
-------------------

The only important file of this package is yamlade.rb
Put it wherever you can require it, and that should be alright.
If you want to share it with all your apps, just put the folder somewhere in your ruby path (ex: /Library/Ruby/Site/1.8/)
Rename this folder "yamlade", then create next to it a file "yamlade.rb" containing just that:

		require 'yamlade/yamlade.rb'
	
And then from anywhere you'll be able to do:

  	require 'yamlade'

Don't know if i'm really clear, but there are many sources on the web for that.
Or maybe i'll do a Gem someday... who knows?

HOW TO USE IT ?
---------------

Just create your YAML file with keys followed by 2 underscores and the type of field.
ex: options.yml

		___
		publish__boolean:
		full_title__string:
		content__text:
		logo__file:

!!! Not sure about that but i think that it needs a new line at the end.
Types available for the moment are : string, text, boolean, file

And then you're ready to go.

		require 'yamlade'
		@conf = Yamlade.new('options.yml')
	
If you want to get the html form for your config file:

		@conf.to_form
	
And when the POST request arrives, your object is in the 'yaml' key. So use it for updating your file:

		@conf.update(request['yaml'])
	
That's it, only two methods for the moment.
See examples if you're not sure.
I'll try to put examples for as many frameworks as i can.

HOW ARE MY FILES HANDLED ?
--------------------------

Well, in fact the file will be included in your YAML.
The main reason for that is that it's cool to have everything in one file.
The way it's recorded is with the handy data URI scheme : http://en.wikipedia.org/wiki/Data_URI_scheme
But you don't have to think about that because Yamlade works for you.
Just use the value like if it was a URL:

 		<% @options = YAML.load_file('options.yml') %>
		<img src="<%= @options.logo %>" />
	
!!! You don't use Yamlade class here. Reading is made through a classic YAML loading and reading.

(C)
---

Copyright (c)2009 Mickael Riga - See MIT_LICENCE for more details
	
