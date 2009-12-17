require 'yaml'
class Yamlade
  def initialize(f, public_root=::File.expand_path('../public/', f))
    @file = f
    @public_root =  public_root
    @public_root << '/' unless public_root[/\/$/]
  end
  def to_fields
    o = "<h3>#{::File.basename(@file, '.yml').upcase.tr('_', ' ')}</h3>"
    config = YAML.load_file(@file)
    config.each do |k,v|
      label, type = k.split('__')
      o << "<p>#{label.capitalize.tr('_', ' ')}<br />"
      
      o << case type
      when 'string'
        "<input type='text' value='#{v}' name='yaml[#{k}]' />"
      when 'text'
        "<textarea cols='40' rows='5' name='yaml[#{k}]'>#{v}</textarea>"
      when 'file'
        preview = (v.nil? || v=='') ? '' : "<img src='/#{v}' width='100' /><br />"
        "#{preview}<input type='file' name='yaml[#{k}]' />"
      when 'data'
        "<input type='file' name='yaml[#{k}]' />"
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
    config = YAML.load_file(@file)
    # Data
    datas = h.find_all {|k,v| k[/_data$/] }
    datas.each do |data|
      field, data_hash = data
      tempfile, content_type = data_hash.values_at(:tempfile, :type)
      h[field] = "data:#{content_type};base64,#{[::File.open(tempfile.path).read].pack('m').strip}"
      tempfile.close(true)
    end
    # File
    files = h.find_all {|k,v| k[/_file$/] }
    files.each do |file|
      field, file_hash = file
      tempfile, content_type = file_hash.values_at(:tempfile, :type)
      unless config[field].to_s.empty? or tempfile.nil?
        FileUtils.move(tempfile.path, "#{@public_root}#{config[field]}", :force => true)
        FileUtils.chmod(0777, "#{@public_root}#{config[field]}")
        tempfile.close(true)
      end
      h.delete(field)
    end
    # Update
    config = config.update(h)
    ::File.open(@file, 'w') {|f| YAML.dump(config, f) }
  end
end