# encoding: utf-8
class Sys::Controller::Admin::Base < ApplicationController
  include Sys::Controller::Admin::Auth
  helper Sys::FormHelper
  before_filter :pre_dispatch
  rescue_from ActiveRecord::RecordNotFound, :with => :error_auth
  
  def initialize_application
    return false unless super
    
    @@current_user = false
    if authenticate
      crypt_pass  = Joruri.config.application["sys.crypt_pass"]
      Core.user          = current_user
      Core.user.password = Util::String::Crypt.decrypt(session[PASSWD_KEY], crypt_pass)
      Core.user_group    = current_user.groups[0]
    end
    return true
  end
  
  def pre_dispatch
    ## each processes before dispatch
  end
  
  def self.simple_layout
    self.layout 'admin/base'
  end
  
  def simple_layout
    self.class.layout 'admin/base'
  end
  
private
  def authenticate
    return true  if logged_in?
    return false if request.env['PATH_INFO'] =~ /^\/_admin\/login/
    uri  = request.env['PATH_INFO']
    uri += "?#{request.env['QUERY_STRING']}" if !request.env['QUERY_STRING'].blank?
    cookies[:sys_login_referrer] = uri
    return respond_to do |format|
      format.html { redirect_to('/_admin/login') }
      format.xml  { error 'This is a secure page.' }
    end
  end
  
  def error_auth
    http_error 403, "アクセス権限がありません。"
  end
end