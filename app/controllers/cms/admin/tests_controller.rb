# encoding: utf-8
class Cms::Admin::TestsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  
  def index
    
    render :text => 'OK'
  end
end