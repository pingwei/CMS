class Sys::Sequence < ActiveRecord::Base
  set_table_name "sys_sequences"
  
  named_scope :versioned, lambda{ |v| { :conditions => ["version = ?", "#{v}"] }}
end
