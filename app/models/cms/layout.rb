# encoding: utf-8
class Cms::Layout < ActiveRecord::Base
  include Sys::Model::Base
  include Cms::Model::Base::Page::Publisher
  include Sys::Model::Rel::Unid
  include Sys::Model::Rel::Creator
  include Cms::Model::Rel::Site
  include Cms::Model::Rel::Concept
  include Cms::Model::Auth::Concept

  belongs_to :status,  :foreign_key => :state, :class_name => 'Sys::Base::Status'
  
  validates_presence_of :state, :name, :title
  
  after_destroy :remove_css_files
  
  def states
    [['公開','public']]
  end
  
  def node_is(node)
    node = Cms::Node.find(:first, :conditions => {:id => node}) if node.class != Cms::Node
    self.and :id, node.inherited_layout.id if node
  end
  
  def piece_names
    names = []
    body.scan(/\[\[piece\/([0-9a-zA-Z_-]+)\]\]/) do |name|
      names << name[0]
    end
    return names.uniq
  end
  
  def pieces(concept = nil)
    pieces = []
    piece_names.each do |name|
      if concept
        piece = Cms::Piece.find(:first, :conditions => {:name => name, :concept_id => concept}, :order => :id)
      end
      unless piece
        piece = Cms::Piece.find(:first, :conditions => {:name => name, :concept_id => self.concept}, :order => :id)
      end
      unless piece
        piece = Cms::Piece.find(:first, :conditions => {:name => name, :concept_id => nil}, :order => :id)
      end
      pieces << piece if piece
    end
    return pieces
  end
  
  def head_tag(mobile = nil)
    tags = []
    css =  stylesheet_path(mobile)
    if FileTest.exist?(css)
      css = stylesheet_uri(mobile)
      tags << %Q(<link href="#{css}" media="all" rel="stylesheet" type="text/css" />)
    end
    tags << (mobile ? mobile_head : head)
    tags.delete('')
    tag = tags.join("\n")
    tag = tag.gsub(/<link [^>]+>/i, '').gsub(/(\r\n|\n)+/, "\n") if mobile
    tag
  end
  
  def publishable? # TODO dummy
    return true
  end
  
  def stylesheet_path(mobile = nil)
    return mobile_stylesheet_path if mobile
    dir = Util::String::CheckDigit.check(format('%07d', id))
    dir = dir.gsub(/(\d\d)(\d\d)(\d\d)(\d\d)/, '\1/\2/\3/\4/\1\2\3\4')
    site.public_path + '/_layouts/' + dir + '/style.css' 
  end
  
  def mobile_stylesheet_path
    dir = Util::String::CheckDigit.check(format('%07d', id))
    dir = dir.gsub(/(\d\d)(\d\d)(\d\d)(\d\d)/, '\1/\2/\3/\4/\1\2\3\4')
    site.public_path + '/_layouts/' + dir + '/mobile.css' 
  end
  
  def stylesheet_uri(mobile = nil)
    return mobile_stylesheet_uri if mobile
    dir = Util::String::CheckDigit.check(format('%07d', id))
    site.uri + '_layouts/' + dir + '/style.css' 
  end
  
  def mobile_stylesheet_uri
    dir = Util::String::CheckDigit.check(format('%07d', id))
    site.uri + '_layouts/' + dir + '/mobile.css' 
  end
  
  def public_path
    site.public_path + '/layout/' + name + '/style.css' 
  end
  
  def public_uri # TODO dummy
    '/layout/' + name + '/style.css' 
  end
  
  def request_publish_data # TODO dummy
    _res = {
      :page_type => 'text/css',
      :page_size => stylesheet.size,
      :page_data => stylesheet,
    }
  end
  
  def tamtam_css
    css = ''
    mobile_head.scan(/<link [^>]*?rel="stylesheet"[^>]*?>/i) do |m|
      css += %Q(@import "#{m.gsub(/.*href="(.*?)".*/, '\1')}";\n)
    end
    css += mobile_stylesheet if !mobile_stylesheet.blank?
    
    4.times do
      css = convert_css_for_tamtam(css)
    end
    css.gsub!(/^@.*/, '')
    css.gsub!(/[a-z]:after/i, '-after')
    css
  end
  
  def convert_css_for_tamtam(css)
    css.gsub(/^@import .*/) do |m|
      path = m.gsub(/^@import ['"](.*?)['"];/, '\1')
      dir  = (path =~ /^\/_common\//) ? "#{Rails.root}/public" : site.public_path
      file = "#{dir}#{path}"
      if FileTest.exist?(file)
        m = ::File.new(file).read.toutf8.gsub(/(\r\n|\n|\r)/, "\n").gsub(/^@import ['"](.*?)['"];/) do |m2|
          p = m2.gsub(/.*?["'](.*?)["'].*/, '\1')
          p = ::File.expand_path(p, ::File.dirname(path)) if p =~ /^\./
          %Q(@import "#{p}";)
        end
      else
        m = ''
      end
      m
    end
  end
  
  def extended_css(options = {})
    css = extend_css(public_path)
    if options[:skip_charset] == true
      css.gsub!(/(^|\n)@charset .*?(\n|$)/, '\1')
    end
  end
  
  def extend_css(path)
    return '' unless FileTest.exist?(path)
    css = ::File.new(path).read
    if css =~ /^@import/
      css.gsub!(/(^|\n)@import .*?(\n|$)/iom) do |m|
        src = m.gsub(/(^|\n)@import ["](.*)["].*?(\n|$)/, '\2')
        if src.slice(0, 9) == '/_common/'
          src = "#{Rails.root}/public#{src}"
        elsif src.slice(0, 1) != '/'
          src = ::File.dirname(path) + '/' + src
        else
          '/* skip */'
        end
        extend_css(src) + "\n"
      end
    end
    css
  end
  
  def put_css_files
    begin
      path = stylesheet_path
      data = stylesheet.to_s
      Util::File.put(path, :data => data, :mkdir => true)
      path = mobile_stylesheet_path
      data = mobile_stylesheet.to_s
      Util::File.put(path, :data => data, :mkdir => true)
    rescue
      return false
    end
    return true
  end
  
  def remove_css_files
    FileUtils.rm_f(stylesheet_path)
    FileUtils.rm_f(mobile_stylesheet_path)
    FileUtils.rmdir(::File.dirname(stylesheet_path)) rescue nil
    return true
  end
end
