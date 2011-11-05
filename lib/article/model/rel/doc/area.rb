module Article::Model::Rel::Doc::Area
  attr_accessor :in_area_ids
  
  def in_area_ids
    unless val = read_attribute(:in_area_ids)
      write_attribute(:in_area_ids, area_ids.to_s.split(' ').uniq)
    end
    read_attribute(:in_area_ids)
  end
  
  def in_area_ids=(ids)
    _ids = []
    if ids.class == Array
      ids.each {|val| _ids << val}
      write_attribute(:area_ids, _ids.join(' '))
    elsif ids.class == Hash || ids.class == HashWithIndifferentAccess
      ids.each {|key, val| _ids << key unless val.blank? }
      write_attribute(:area_ids, _ids.join(' '))
    else
      write_attribute(:area_ids, ids)
    end
  end
  
  def area_items
    ids = area_ids.to_s.split(' ').uniq
    return [] if ids.size == 0
    item = Article::Area.new
    item.and :id, 'IN', ids
    item.find(:all)
  end
  
  def area_is(area)
    return self if area.blank?
    area = [area] unless area.class == Array
    area.each do |c|
      if c.level_no == 1
        area += c.public_children
      end
    end
    
    ids = area.collect{|c| c.id}.uniq
    if ids.size > 0
      self.and :area_ids, 'REGEXP', "(^| )(#{ids.join('|')})( |$)"
    end
    return self
  end

end