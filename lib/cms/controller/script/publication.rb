class Cms::Controller::Script::Publication < ApplicationController
  include Cms::Controller::Layout
  before_filter :initialize_publication
  
  def initialize_publication
    if @node = params[:node]
      @site   = @node.site
    end
    @errors = []
  end
  
  def publish_page(item, params = {})
    site = params[:site] || @site
    res = item.publish_page(render_public_as_string(params[:uri], :site => site),
      :path => params[:path], :dependent => params[:dependent])
    return false unless res
    return true if params[:path] !~ /(\/|\.html)$/
    
    uri  = (params[:uri] =~ /\.html$/ ? "#{params[:uri]}.r" : "#{params[:uri]}index.html.r")
    path = (params[:path] =~ /\.html$/ ? "#{params[:path]}.r" : "#{params[:path]}index.html.r")
    dep  = params[:dependent] ? "#{params[:dependent]}/ruby" : "ruby"
    if item.published? || !File.exist?(path)
      item.publish_page(render_public_as_string(uri, :site => site), :path => path, :dependent => dep)
    end
    
    return res
  rescue => e
    return false
  end
  
  def publish_more(item, params = {})
    limit = 1
    file  = params[:file] || 'index'
    first = params[:first] || 1
    first.upto(limit) do |p|
      page = (p == 1 ? "" : ".p#{p}") 
      uri  = "#{params[:uri]}#{file}#{page}.html"
      path = "#{params[:path]}#{file}#{page}.html"
      rs   = publish_page(item, :uri => uri, :site => params[:site], :path => path, :dependent => params[:dependent])
      return item.published?
      #break unless rs
    end
  end
end
