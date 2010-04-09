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

	require 'yamlade/yamlade'
	
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
	banner__file: desired_file_name.jpeg
	logo__data:

!!! Don't forget to put at least one space after the last key
Types available for the moment are : string, text, boolean, file and data

And then you're ready to go.

	require 'yamlade'
	@conf = Yamlade.new('options.yml')
	
If you want to get the html form for your config file:

	@conf.to_form(action_url)
	
Or just this if you only need the fields to wrap them in your own form:

	@conf.to_fields
	
And when the POST request arrives, your object is in the 'yaml' key. So use it for updating your file:

	@conf.update(request['yaml'])
	
That's it, only three methods for the moment.
See examples if you're not sure.
I'll try to put examples for as many frameworks as i can.

HOW ARE MY FILES HANDLED WITH 'FILE' TYPE ?
-------------------------------------------

If you use the file type, the uploaded file is loaded on the file system.
So in that case, it might be important to specify the second argument of the constructor : public root
If you don't, Yamlade consider the folder called 'public' next to your YAML file as the public root.

	conf = Yamlade.new('conf.yml', ::File.expand_path('../public/', 'conf.yml'))
	
The other thing to know, is that you have to give a name when building Yaml file the first time.
Basicaly you force the name of the file instead of keeping the original file name.
It helps Yamlade to overwrite the previously recorded file.
That way also allows you to give paths deeper than public root if necessary:

	header__file: layout/header.jpeg
	

HOW ARE MY FILES HANDLED WITH 'DATA' TYPE ?
-------------------------------------------

Well, in fact the file will be included in your YAML if you use the data type.
The main reason for that is that it's cool to have everything in one file.
The way it's recorded is with the handy data URI scheme : http://en.wikipedia.org/wiki/Data_URI_scheme
But you don't have to think about that because Yamlade works for you.
Just use the value like if it was a URL:

	<% @options = YAML.load_file('options.yml') %>
	<img src="<%= @options.logo %>" />
	
!!! You don't use Yamlade class here. Reading is made through a classic YAML loading and reading.

!!! At this day, data scheme doesn't work on IE<=7 and is limited to 32kb on IE8

WHAT IF I WANT TO USE 'DATA' TYPE ANYWAY ?
------------------------------------------

The best thing to do might be to do some MHTML trick:
http://www.phpied.com/data-uris-mhtml-ie7-win7-vista-blues/

An other way is possible if you really want to keep everything in one file.
Dynamically serve those images.
This is not recommended because it produces useless computing (maybe acceptable for a couple of pics)

Basicaly, you need to have an action that reads the information, set the right mime-type and decoded content.
Here is a Ramaze example:

	def data(file, var)
    @conf = YAML.load_file(::File.expand_path("../../private/#{file}.yml", __FILE__))
    mime, data = @conf[var].split(/,/)
    response['Content-Type'] = mime[/[^:]*\/[^;]*/]   # remove what is around the mime-type
    response.status = 200
    response.write data.unpack("m")[0]                # decode base64
   	throw(:respond, response)
	end

And then you can have your pictures with urls like : /data/conf/logo__data

I removed the preview when editing this kind of file in order to allow that trick.
Maybe I'll try to find a way to deal both situations...

(C)
---

Copyright (c)2009 Mickael Riga - See MIT_LICENCE for more details
	
