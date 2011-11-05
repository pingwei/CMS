module Article::Model::Rel::Doc::Attribute
  attr_accessor :in_attribute_ids
  
  def in_attribute_ids
    unless val = read_attribute(:in_attribute_ids)
      write_attribute(:in_attribute_ids, attribute_ids.to_s.split(' ').uniq)
    end
    read_attribute(:in_attribute_ids)
  end
  
  def in_attribute_ids=(ids)
    _ids = []
    if ids.class == Array
      ids.each {|val| _ids << val}
      write_attribute(:attribute_ids, _ids.join(' '))
    elsif ids.class == Hash || ids.class == HashWithIndifferentAccess
      ids.each {|key, val| _ids << val}
      write_attribute(:attribute_ids, _ids.join(' '))
    else
      write_attribute(:attribute_ids, ids)
    end
  end
  
  def attribute_items
    ids = attribute_ids.to_s.split(' ').uniq
    return [] if ids.size == 0
    item = Article::Attribute.new
    item.and :id, 'IN', ids
    item.find(:all)
  end
  
  def attribute_is(attr)
    return self if attr.blank?
    attr = [attr] unless attr.class == Array
    cond = Condition.new
    attr.each do |c|
      cond.or :attribute_ids, 'REGEXP', "(^| )#{c.id}( |$)"
    end
    self.and cond
  end
end