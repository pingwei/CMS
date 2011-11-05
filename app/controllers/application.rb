class ApplicationController < ActionController::Base
  include Cms::Controller::Public
  helper  FormHelper
  helper  LinkHelper
  protect_from_forgery # :secret => '1f0d667235154ecf25eaf90055d99e99'
  before_filter :initialize_application
  
  def initialize_application
    return false if Core.dispatched?
    
    Page.mobile = true if request.mobile?
    set_mobile if Page.mobile? && !request.mobile?
    
    return Core.dispatched
  end
  
  def skip_layout
    self.class.layout 'base'
  end
  
  def send_mail(mail_fr, mail_to, subject, message)
    return false if mail_fr.blank?
    return false if mail_to.blank?
    Sys::Lib::Mailer::Base.deliver_default(mail_fr, mail_to, subject, message)
  end
  
  def send_download
    #
  end
  
  def set_mobile
    def request.mobile
      Jpmobile::Mobile::Au.new(nil)
    end
  end
  
private
  def rescue_action(error)
    case error
    when ActionController::InvalidAuthenticityToken
      http_error(422, error.to_s)
    else
      super
    end
  end
  
  ## Production && local
  def rescue_action_in_public(exception)
    http_error(500, nil)
  end
  
  def http_error(status, message = nil)
    Page.error = status
    
    ## errors.log
    if Core.mode !~ /preview/
      error_log("#{status} #{request.env['REQUEST_URI']} #{message.to_s.gsub(/\n/, ' ')}")
    end
    
    ## Render
    file = "#{Rails.public_path}/500.html"
    if Page.site && FileTest.exist?("#{Page.site.public_path}/#{status}.html")
      file = "#{Page.site.public_path}/#{status}.html"
    elsif Core.site && FileTest.exist?("#{Core.site.public_path}/#{status}.html")
      file = "#{Core.site.public_path}/#{status}.html"
    elsif FileTest.exist?("#{Rails.public_path}/#{status}.html")
      file = "#{Rails.public_path}/#{status}.html"
    end
    
    @message = message
    return respond_to do |format|
      format.html { render(:status => status, :file => file) }
      format.xml  { render :xml => "<errors><error>#{status} #{message}</error></errors>" }
    end
  end
end
