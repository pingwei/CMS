# encoding: utf-8
class Cms::ContentSetting < ActiveRecord::Base
  include Sys::Model::Base

  belongs_to :content, :foreign_key => :content_id, :class_name => 'Cms::Content'

  validates_presence_of :content_id, :name
end
