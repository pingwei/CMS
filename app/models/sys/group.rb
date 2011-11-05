# encoding: utf-8
class Sys::Group < ActiveRecord::Base
  include Sys::Model::Base
  include Cms::Model::Base::Page
  include Sys::Model::Base::Config
  include Cms::Model::Base::Page::Publisher
  include Cms::Model::Base::Page::TalkTask
  include Sys::Model::Rel::Unid
  include Sys::Model::Tree
  include Sys::Model::Auth::Manager
  
  belongs_to :status    , :foreign_key => :state    , :class_name => 'Sys::Base::Status'
  belongs_to :web_status, :foreign_key => :web_state, :class_name => 'Sys::Base::Status'
  belongs_to :parent    , :foreign_key => :parent_id, :class_name => 'Sys::Group'
  belongs_to :layout    , :foreign_key => :layout_id, :class_name => 'Cms::Layout'
  
  has_many   :children  , :foreign_key => :parent_id, :class_name => 'Sys::Group', :order => :code, :dependent => :destroy
  has_and_belongs_to_many :users, :class_name => 'Sys::User',
    :join_table => 'sys_users_groups', :order => '(sys_users.id)'
  
  validates_presence_of :state, :level_no, :code, :name, :name_en, :ldap
  validates_uniqueness_of :code
  
  before_destroy :before_destroy
  
  def readable
    self
  end
  
  def creatable?
    Core.user.has_auth?(:manager)
  end
  
  def readable?
    Core.user.has_auth?(:manager)
  end
  
  def editable?
    Core.user.has_auth?(:manager)
  end
  
  def deletable?
    Core.user.has_auth?(:manager)
  end
  
  def ldap_states
    [['同期',1],['非同期',0]]
  end
  
  def web_states
    [['公開','public'],['非公開','closed']]
  end
  
  def ldap_label
    ldap_states.each {|a| return a[0] if a[1] == ldap }
    return nil
  end
  
  def ou_name
    "#{code}#{name}"
  end
  
  def full_name
    n = name
    n = "#{parent.name}　#{n}" if parent && parent.level_no > 1
    n
  end
  
private
  def before_destroy
    users.each do |user|
      if user.groups.size == 1
        u = Sys::User.find_by_id(user.id)
        u.state = 'disabled'
        u.save
      end
    end
    return true
  end
end
