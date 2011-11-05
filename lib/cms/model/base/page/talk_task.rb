# encoding: utf-8
require 'digest/md5'
module Cms::Model::Base::Page::TalkTask
  def self.included(mod)
    mod.has_many :talk_tasks, :foreign_key => 'unid', :primary_key => 'unid', :class_name => 'Cms::TalkTask',
      :dependent => :destroy
    mod.after_save :delete_talk_tasks
  end
  
  def publish_page(content, options = {})
    return false unless super
    
    cond = options[:dependent] ? ['dependent = ?', options[:dependent].to_s] : ['dependent IS NULL']
    pub  = publishers.find(:first, :conditions => cond)
    return true unless pub
    return true if pub.path !~ /\.html$/
    return true if !published? && ::File.exist?("#{pub.path}.mp3")
    
    task = talk_tasks.find(:first, :conditions => cond) || Cms::TalkTask.new
    task.unid         = pub.unid
    task.dependent    = pub.dependent
    task.path         = pub.path
    task.content_hash = pub.content_hash
    task.save if task.changed?
    return true
  end
  
  def delete_talk_tasks
    publishers.destroy_all
    return true
  end
end
