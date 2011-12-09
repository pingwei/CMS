# encoding: utf-8
class Cms::Site < ActiveRecord::Base
  include Sys::Model::Base
  include Sys::Model::Base::Page
  include Sys::Model::Rel::Unid
  include Sys::Model::Rel::Creator
  include Sys::Model::Auth::Manager
  
  belongs_to :status,   :foreign_key => :state,
    :class_name => 'Sys::Base::Status'
  has_many   :concepts, :foreign_key => :site_id, :order => 'name, id',
    :class_name => 'Cms::Concept', :dependent => :destroy
  has_many   :contents, :foreign_key => :site_id, :order => 'name, id',
    :class_name => 'Cms::Content'
  has_many   :settings, :foreign_key => :site_id, :order => 'name, sort_no',
    :class_name => 'Cms::SiteSetting'
  
  validates_presence_of :state, :name, :full_uri
  
  validate :validate_attributes
  
  def states
    [['公開','public']]
  end
  
  def public_path
    Rails.public_path + '_' + format('%08d', id).to_s
  end
  
  def uri
    return '/' unless full_uri.match(/^[a-z]+:\/\/[^\/]+\//)
    full_uri.sub(/^[a-z]+:\/\/[^\/]+\//, '/')
  end
  
  def domain
    full_uri.gsub(/^[a-z]+:\/\/([^\/]+)\/.*/, '\1')
  end
  
  def publish_uri
    "#{Core.full_uri}_publish/#{format('%08d', id)}/"
  end
  
  def has_mobile?
    !mobile_full_uri.blank?
  end
  
  def root_node
    Cms::Node.find_by_id(node_id)
  end
  
  def related_sites(options = {})
    sites = []
    related_site.to_s.split(/(\r\n|\n)/).each do |line|
      sites << line if line.strip != ''
    end
    if options[:include_self]
      sites << "#{full_uri}" if !full_uri.blank?
      sites << "#{mobile_full_uri}" if !mobile_full_uri.blank?
    end
    sites
  end
  
  def self.find_by_script_uri(script_uri)
    base = script_uri.gsub(/^[a-z]+:\/\/([^\/]+\/).*/, '\1')
    item = Cms::Site.new.public
    cond = Condition.new do |c|
      c.or :full_uri, 'LIKE', "http://#{base}%"
      c.or :mobile_full_uri, 'LIKE', "http://#{base}%"
    end
    item.and cond
    return item.find(:first, :order => :id)
  end
  
protected
  def validate_attributes
    if !full_uri.blank? && full_uri !~ /^[a-z]+:\/\/[^\/]+\//
      self.full_uri += '/'
    end
    return true
  end
end
