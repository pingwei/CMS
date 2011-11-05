class Sys::UsersGroup < ActiveRecord::Base
  include Sys::Model::Base
  include Sys::Model::Base::Config
  include Sys::Model::Auth::Manager
  
  set_primary_key :rid
  
  belongs_to   :user,  :foreign_key => :user_id,  :class_name => 'Sys::User'
  belongs_to   :group, :foreign_key => :group_id, :class_name => 'Sys::Group'
end
