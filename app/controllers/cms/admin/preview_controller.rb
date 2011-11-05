# encoding: utf-8
class Cms::Admin::PreviewController < Cms::Controller::Admin::Base
  def index
    path = Core.request_uri.gsub(/^#{Regexp.escape(cms_preview_path)}/, "")
    
    render_preview(path, :mobile => Page.mobile?, :preview => true)
  end

  def render_preview(path, options = {})
    Core.publish = true unless options[:preview]
    mode = Core.set_mode('preview')
    
    Page.initialize
    Page.site   = options[:site] || Core.site
    Page.uri    = path
    Page.mobile = options[:mobile]
    
    routes = ActionController::Routing::Routes
    node   = Core.search_node(path)
    env    = {}
    opt    = routes.recognize_optimized(node, env)
    ctl    = opt[:controller]
    act    = opt[:action]
    
    opt.each {|k,v| params[k] = v }
    #opt[:layout_id] = params[:layout_id] if params[:layout_id]
    #opt[:authenticity_token] = params[:authenticity_token] if params[:authenticity_token]
    
    render_component :controller => ctl, :action => act, :params => params
  end
end
