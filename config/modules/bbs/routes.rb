ActionController::Routing::Routes.draw do |map|
  mod = "bbs"
  
  ## admin
  map.namespace(mod, :namespace => '') do |ns|
    ns.resources :items,
      :controller  => "admin/items",
      :path_prefix => "/_admin/#{mod}/:content"
    
    ## content
    ns.resources :content_base,
      :controller => "admin/content/base",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :content_settings,
      :controller  => "admin/content/settings",
      :path_prefix => "/_admin/#{mod}/:content"
    
    ## node
    ns.resources :node_threads,
      :controller  => "admin/node/threads",
      :path_prefix => "/_admin/#{mod}/:parent"
    
    ## piece
    ns.resources :piece_recent_items,
      :controller  => "admin/piece/recent_items",
      :path_prefix => "/_admin/#{mod}"
  end
  
  ## public
  map.namespace(mod, :namespace => '', :path_prefix => '/_public') do |ns|
    ns.connect "node_threads/index.:format",
      :controller => "public/node/threads",
      :action     => :index
    ns.connect "node_threads/new.:format",
      :controller => "public/node/threads",
      :action     => :new
    ns.connect "node_threads/delete.:format",
      :controller => "public/node/threads",
      :action     => :delete
    ns.connect "node_threads/:thread/index.:format",
      :controller => "public/node/threads",
      :action     => :show
  end
end
