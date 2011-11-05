module Article::Model::Rel::Doc::Tag
  attr_accessor :in_tags
  
  def self.included(mod)
    mod.has_many :tags, :primary_key => 'unid', :foreign_key => 'unid', :class_name => 'Article::Tag',
      :order => :name, :dependent => :destroy
      
    mod.after_save :save_tags
  end
  
  def find_tag_by_name(name)
    return nil if tags.size == 0
    tags.each do |tag|
      return tag.word if tag.name == name
    end
    return nil
  end
  
  def in_tags
    unless val = read_attribute(:in_tags)
      val = []
      tags.each {|tag| val << tag.word }
      write_attribute(:in_tags, val)
    end
    read_attribute(:in_tags)
  end
  
  def in_tags=(words)
    _words = []
    if words.class == Array
      _words = words
    elsif words.class == Hash || words.class == HashWithIndifferentAccess
      words.each {|key, val| _words << val unless val.blank? }
    else
      _words = words.to_s.split(' ').uniq
    end
    @tags = _words
  end
  
  def save_tags
    return false unless unid
    return true unless @tags
    
    values = @tags
    @tags = nil
    
    tags
    3.times do |i|
      if value = values[i]
        unless  tag = tags[i]
          tag = Article::Tag.new({:unid => unid, :name => i})
        end
        tag.word = value
        tag.save
      elsif tag = tags[i]
        tag.destroy
      end
    end
    
    tags(true)
    return true
  end
end