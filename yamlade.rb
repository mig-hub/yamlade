require 'yaml'
class Yamlade
  def initialize(f)
    @file = f
  end
  def to_fields
    o = "<h3>#{::File.basename(@file, '.yml').upcase}</h3>"
    config = YAML.load_file(@file)
    config.each do |k,v|
      label, type = k.split('__')
      o << "<p>#{label.capitalize}<br />"
      
      o << case type
      when 'string'
        "<input type='text' value='#{v}' name='yaml[#{k}]' />"
      when 'text'
        "<textarea cols='40' rows='5' name='yaml[#{k}]'>#{v}</textarea>"
      when 'file'
        preview = (v.nil? || v=='') ? '' : "<img src='#{v}' width='100' /><br />"
        "#{preview}<input type='file' name='yaml[#{k}]' />"
      when 'boolean'
        s = [' checked', nil]
        s.reverse! unless v=='true'
        %{
          <input type='radio' name='yaml[#{k}]' value='true'#{s[0]} /> True<br />
          <input type='radio' name='yaml[#{k}]' value='false'#{s[1]} /> False
        }.strip
      end
      
      o << '</p>'
    end
    o
  end
  
  def to_form(url)
    "<form action='#{url}' method='POST' enctype='multipart/form-data'>#{self.to_fields}<input type='submit' name='save' value='SAVE' /></form>"
  end
  
  def update(h)
    puts h.inspect
    imgs = h.find_all {|k,v| k[/_file$/] }
    imgs.each do |img|
      field, img_hash = img
      tempfile, content_type = img_hash.values_at(:tempfile, :type)
      h[field] = "data:#{content_type};base64,#{[::File.open(tempfile.path).read].pack('m').strip}"
      tempfile.close(true)
    end
    config = YAML.load_file(@file).update(h)
    ::File.open(@file, 'w') {|f| YAML.dump(config, f) }
  end
end