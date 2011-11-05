ActionController::Routing::Routes.draw do |map|
  
  ## Files
  map.connect '_files/*path'           , :controller => 'cms/public/files'  , :action => 'down'
  
  ## Tools
  map.connect '*path.html.mp3'         , :controller => 'cms/public/talk'   , :action => 'down_mp3'
  map.connect '*path.html.m3u'         , :controller => 'cms/public/talk'   , :action => 'down_m3u'
  map.connect '*path.html.r.mp3'       , :controller => 'cms/public/talk'   , :action => 'down_mp3'
  map.connect '*path.html.r.m3u'       , :controller => 'cms/public/talk'   , :action => 'down_m3u'

  ## Admin
  map.connect '_admin'                 , :controller => 'sys/admin/front'   , :action => 'index'
  map.connect '_admin/login.:format'   , :controller => 'sys/admin/account' , :action => 'login'
  map.connect '_admin/login'           , :controller => 'sys/admin/account' , :action => 'login'
  map.connect '_admin/logout.:format'  , :controller => 'sys/admin/account' , :action => 'logout'
  map.connect '_admin/logout'          , :controller => 'sys/admin/account' , :action => 'logout'
  map.connect '_admin/account.:format' , :controller => 'sys/admin/account' , :action => 'info'
  map.connect '_admin/account'         , :controller => 'sys/admin/account' , :action => 'info'

  ## Modules
  Dir::entries("#{Rails.root}/config/modules").each do |mod|
    next if mod =~ /^\./
    file = "#{Rails.root}/config/modules/#{mod}/routes.rb"
    load(file) if FileTest.exist?(file)
  end

  ## Exception
  map.connect '404.:format', :controller => 'exception', :action => 'index'
  map.connect '*path',       :controller => 'exception', :action => 'index'
end