ActionController::Routing::Routes.draw do |map|
  mod = "calendar"
  
  ## admin
  map.namespace(mod, :namespace => '') do |ns|
    ns.resources :events,
      :controller  => "admin/events",
      :path_prefix => "/_admin/#{mod}/:content"
    
    ## content
    ns.resources :content_base,
      :controller => "admin/content/base",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :content_settings,
      :controller  => "admin/content/settings",
      :path_prefix => "/_admin/#{mod}/:content"
    
    ## node
    ns.resources :node_events,
      :controller  => "admin/node/events",
      :path_prefix => "/_admin/#{mod}/:parent"
    
    ## piece
    ns.resources :piece_monthly_links,
      :controller  => "admin/piece/monthly_links",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_daily_links,
      :controller  => "admin/piece/daily_links",
      :path_prefix => "/_admin/#{mod}"
  end
  
  ## public
  map.namespace(mod, :namespace => '', :path_prefix => '/_public') do |ns|
    ns.connect "node_events/index.:format",
      :controller => "public/node/events",
      :action     => :index
    ns.connect "node_events/:year/index.:format",
      :controller => "public/node/events",
      :action     => :index_yearly
    ns.connect "node_events/:year/:month/index.:format",
      :controller => "public/node/events",
      :action     => :index_monthly
  end
end
