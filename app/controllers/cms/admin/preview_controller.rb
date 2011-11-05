# encoding: utf-8
class Cms::Admin::PreviewController < Cms::Controller::Admin::Base
  def index
    path = Core.request_uri.gsub(/^#{Regexp.escape(cms_preview_path)}/, "")
    
    content = render_public_as_string(path, :mobile => Page.mobile?, :preview => true)
    
    return error_auth unless content
    
    render :inline => content, :layout => false
  end
end
