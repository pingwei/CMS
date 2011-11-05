# encoding: utf-8
class Cms::DataFileNode < ActiveRecord::Base
  include Sys::Model::Base
  include Cms::Model::Base::Page
  include Sys::Model::Rel::Unid
  include Sys::Model::Rel::Creator
  include Cms::Model::Rel::Site
  include Cms::Model::Rel::Concept
  include Cms::Model::Auth::Concept
  
  has_many :files, :foreign_key => :node_id, :class_name => 'Cms::DataFile', :primary_key => :id
  
  validates_presence_of :name
  validate :validate_name
  
  after_destroy :remove_files
  
  def label(separator = "/")
    label = name
    unless title.blank?
      label += "#{separator}#{title}"
    end
    label
  end
  
  def validate_name
    if !name.blank?
      if name !~ /^[0-9a-zA-Z_\-]+$/
        errors.add :name, "は半角英数字を入力してください。"
      elsif duplicated?
        errors.add :name, "は既に登録されています。（#{name}）"
      end
    end
  end
  
  def duplicated?
    dir = self.class.new
    dir.and :id, '!=', id if id
    dir.and :name, name
    if concept_id
      dir.and :concept_id, concept_id
    else
      dir.and :concept_id, 'IS', nil
    end
    return dir.find(:first) != nil
  end
  
private
  def remove_files
    files.each {|file| file.destroy }
    return true
  end
end
