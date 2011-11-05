module Sys::Model::Rel::Unid
  def self.included(mod)
    mod.has_one :unid_original, :primary_key => 'unid', :foreign_key => 'id', :class_name => 'Sys::Unid',
      :dependent => :destroy
    
    mod.after_save :save_unid
  end
  
  def save_unid
    return false if @saved_unid
    return true if unid
    @saved_unid = true
    
    _class  = self.class.to_s.split('::')
    _unid   = Sys::Unid.new({ :item_id => id, :model => self.class.to_s })
    return false unless _unid.save
    
    sql = "UPDATE #{self.class.table_name} SET unid = (#{_unid.id}) WHERE id = #{id}"
    self.class.connection.execute(sql)
    self.unid = _unid.id
  end
end
