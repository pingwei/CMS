# encoding: utf-8
class Article::Model::Content::Config < Sys::Model::XmlRecord::Base
  set_model_name  "article/content/config"
  set_node_xpath  "config"
  set_column_name :xml_properties
  set_primary_key :id
  attr_accessor   :value
  
  #validates_presence_of :value
  
  @@config_names = [
    ['承認フロー', :recognition_type]
  ]
  
  @@config_options = {
    :recognition_type => [['標準',''], ['管理者承認が必要','with_admin']]
  }
  
  def content
    @_record
  end
  
  def creatable?
    true
  end
  
  def editable?
    true
  end
  
  def deletable?
    true
  end
  
  def parse_xml
    
  end
  
  def self.configs(content)
    configs = []
    @@config_names.each do |name, id|
      configs << (find(id, content) || new(content, {:id => id}))
    end
    configs
  end
  
  def config_name
    @@config_names.each {|name, id| return name if id.to_s == self.id.to_s }
    nil
  end
  
  def options
    @@config_options.each {|id, opt| return opt if id.to_s == self.id.to_s }
    nil
  end
  
  def value_name
    options.each {|name, val| return name if value == val } if options
    value
  end
end