class Cms::Controller::Admin::Base < Sys::Controller::Admin::Base
  include Cms::Controller::Layout
  helper Cms::FormHelper
  layout  'admin/cms'
  
  def initialize_application
    return false unless super
    
    if params[:cms_navi] && params[:cms_navi][:site]
      site_id = params[:cms_navi][:site]
      expires = site_id.blank? ? Time.now - 60 : Time.now + 60*60*24*7
      cookies[:cms_site] = {:value => site_id, :path => '/', :expires => expires}
      return redirect_to '/_admin'
    end
    
    if cookies[:cms_site] && !Core.site
      cookies.delete(:cms_site)
      Core.site = nil
    end
    
    if Core.user
      if Core.request_uri == '/_admin'
        Core.set_concept(session, 0)
      else
        Core.set_concept(session)
      end
    end
    return true
  end
end