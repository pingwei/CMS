module Sys::Model::Rel::Role
  def self.included(mod)
  end
  
  ## Conditions by the role.
  def has_role(name, options = {})
    
  end
  
  ## Conditions by the object privilege
  def has_priv(name, options = {})
    user = options[:user]
    return self if user.has_auth?(:manager)
    
    sql = "SELECT role_id FROM #{Sys::UsersRole.table_name}" +
      " WHERE user_id = '#{user.id}'"
    sql = "SELECT * FROM sys_object_privileges" +
      " WHERE action = '#{name}' AND role_id IN ( #{sql} ) "
    sql = "INNER JOIN (#{sql}) AS sys_object_privileges" +
      " ON sys_object_privileges.item_unid = #{self.class.table_name}.unid"
    
    join sql
    return self
  end
end