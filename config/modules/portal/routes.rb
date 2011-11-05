ActionController::Routing::Routes.draw do |map|
  mod = "portal"

  ## admin
  map.namespace(mod, :namespace => '') do |ns|
    ns.resources :feeds,
      :controller  => "admin/feeds",
      :path_prefix => "/_admin/#{mod}/:content"
    ns.resources :feed_entries,
      :controller  => "admin/feed_entries",
      :path_prefix => "/_admin/#{mod}/:content/:feed"
    ns.resources :categories,
      :controller  => "admin/categories",
      :path_prefix => "/_admin/#{mod}/:content/:parent"

    ## content
    ns.resources :content_base,
      :controller => "admin/content/base",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :content_settings,
      :controller  => "admin/content/settings",
      :path_prefix => "/_admin/#{mod}/:content"

    ## node
    ns.resources :node_feed_entries,
      :controller  => "admin/node/feed_entries",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :node_event_entries,
      :controller  => "admin/node/event_entries",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :node_categories,
      :controller  => "admin/node/categories",
      :path_prefix => "/_admin/#{mod}/:parent"

    ## piece
    ns.resources :piece_feed_entries,
      :controller  => "admin/piece/feed_entries",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_feed_entry_conditions,
      :controller  => "admin/piece/feed_entry/conditions",
      :path_prefix => "/_admin/#{mod}/:piece"
    ns.resources :piece_recent_tabs,
      :controller  => "admin/piece/recent_tabs",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_recent_tab_tabs,
      :controller  => "admin/piece/recent_tab/tabs",
      :path_prefix => "/_admin/#{mod}/:piece"
    ns.resources :piece_calendars,
      :controller  => "admin/piece/calendars",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_categories,
      :controller  => "admin/piece/categories",
      :path_prefix => "/_admin/#{mod}"

  end

  ## public
  map.namespace(mod, :namespace => '', :path_prefix => '/_public') do |ns|
    ns.connect "node_feed_entries/index.html",
      :controller => "public/node/feed_entries",
      :action     => :index
    ns.connect "node_event_entries/:year/:month/index.html",
      :controller => "public/node/event_entries",
      :action     => :month
    ns.connect "node_event_entries/index.html",
      :controller => "public/node/event_entries",
      :action     => :month
    ns.connect "node_categories/:name/:file.html",
      :controller => "public/node/categories",
      :action     => :show
    ns.connect "node_categories/index.html",
      :controller => "public/node/categories",
      :action     => :index
  end
end
