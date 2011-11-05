module Article::Model::Rel::Doc::Category
  attr_accessor :in_category_ids
  
  def in_category_ids
    unless val = read_attribute(:in_category_ids)
      write_attribute(:in_category_ids, category_ids.to_s.split(' ').uniq)
    end
    read_attribute(:in_category_ids)
  end
  
  def in_category_ids=(ids)
    _ids = []
    if ids.class == Array
      ids.each {|val| _ids << val}
      write_attribute(:category_ids, _ids.join(' '))
    elsif ids.class == Hash || ids.class == HashWithIndifferentAccess
      ids.each {|key, val| _ids << val}
      write_attribute(:category_ids, _ids.join(' '))
    else
      write_attribute(:category_ids, ids)
    end
  end
  
  def category_items
    ids = category_ids.to_s.split(' ').uniq
    return [] if ids.size == 0
    item = Article::Category.new
    item.and :id, 'IN', ids
    item.find(:all)
  end
  
  def category_is(cate)
    return self if cate.blank?
    cate = [cate] unless cate.class == Array
    cate.each do |c|
      if c.level_no == 1
        cate += c.public_children
      end
    end
    cate = cate.uniq
    
    cond = Condition.new
    cate.each do |c|
      cond.or :category_ids, 'REGEXP', "(^| )#{c.id}( |$)"
    end
    self.and cond
  end

end