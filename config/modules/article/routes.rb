ActionController::Routing::Routes.draw do |map|
  mod = "article"
  
  ## admin
  map.namespace(mod, :namespace => '') do |ns|
    ns.resources :emergencies,
      :controller  => "admin/emergencies",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :units,
      :controller  => "admin/units",
      :path_prefix => "/_admin/#{mod}/:content/:parent"
    ns.resources :categories,
      :controller  => "admin/categories",
      :path_prefix => "/_admin/#{mod}/:content/:parent"
    ns.resources :attributes,
      :controller  => "admin/attributes",
      :path_prefix => "/_admin/#{mod}/:content"
    ns.resources :areas,
      :controller  => "admin/areas",
      :path_prefix => "/_admin/#{mod}/:content/:parent"
    ns.resources :docs,
      :controller  => "admin/docs",
      :path_prefix => "/_admin/#{mod}/:content"
    ns.resources :edit_docs,
      :controller  => "admin/docs/edit",
      :path_prefix => "/_admin/#{mod}/:content"
    ns.resources :recognize_docs,
      :controller  => "admin/docs/recognize",
      :path_prefix => "/_admin/#{mod}/:content"
    ns.resources :publish_docs,
      :controller  => "admin/docs/publish",
      :path_prefix => "/_admin/#{mod}/:content"
    
    ## content
    ns.resources :content_base,
      :controller => "admin/content/base",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :configs,
      :controller => "admin/configs",
      :path_prefix => "/_admin/#{mod}/:content"
    
    ## node
    ns.resources :node_docs,
      :controller  => "admin/node/docs",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :node_recent_docs,
      :controller  => "admin/node/recent_docs",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :node_event_docs,
      :controller  => "admin/node/event_docs",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :node_tag_docs,
      :controller  => "admin/node/tag_docs",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :node_units,
      :controller  => "admin/node/units",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :node_categories,
      :controller  => "admin/node/categories",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :node_attributes,
      :controller  => "admin/node/attributes",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :node_areas,
      :controller  => "admin/node/areas",
      :path_prefix => "/_admin/#{mod}/:parent"
    
    ## piece
    ns.resources :piece_recent_docs,
      :controller  => "admin/piece/recent_docs",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_recent_tabs,
      :controller  => "admin/piece/recent_tabs",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_recent_tab_tabs,
      :controller  => "admin/piece/recent_tab/tabs",
      :path_prefix => "/_admin/#{mod}/:piece"
    ns.resources :piece_calendars,
      :controller  => "admin/piece/calendars",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_units,
      :controller  => "admin/piece/units",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_categories,
      :controller  => "admin/piece/categories",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_attributes,
      :controller  => "admin/piece/attributes",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_areas,
      :controller  => "admin/piece/areas",
      :path_prefix => "/_admin/#{mod}"
  end

  map.connect "_admin/#{mod}/tool_import_uri",
    :controller => "#{mod}/admin/tool/import_uri",
    :action     => :import
  
  map.connect "_admin/#{mod}/tool_import_html",
    :controller => "#{mod}/admin/tool/import_html",
    :action     => :import,
    :conditions => {:method => :post}
    
  ## public
  map.namespace(mod, :namespace => '', :path_prefix => '/_public') do |ns|
    ns.connect "node_docs/:name/index.html",
      :controller => "public/node/docs",
      :action     => :show
    ns.connect "node_docs/:name/files/:file.:format",
      :controller => "public/node/doc/files",
      :action     => :show
    ns.connect "node_docs/index.:format",
      :controller => "public/node/docs",
      :action     => :index
    ns.connect "node_recent_docs/index.:format",
      :controller => "public/node/recent_docs",
      :action     => :index
    ns.connect "node_event_docs/:year/:month/index.:format",
      :controller => "public/node/event_docs",
      :action     => :month
    ns.connect "node_event_docs/index.:format",
      :controller => "public/node/event_docs",
      :action     => :month
    ns.connect "node_tag_docs/:tag",
      :controller => "public/node/tag_docs",
      :action     => :index
    ns.connect "node_tag_docs/index.:format",
      :controller => "public/node/tag_docs",
      :action     => :index
    ns.connect "node_units/:name/:attr/index.:format",
      :controller => "public/node/units",
      :action     => :show_attr
    ns.connect "node_units/:name/:file.:format",
      :controller => "public/node/units",
      :action     => :show
    ns.connect "node_units/index.html",
      :controller => "public/node/units",
      :action     => :index
    ns.connect "node_categories/:name/:attr/index.:format",
      :controller => "public/node/categories",
      :action     => :show_attr
    ns.connect "node_categories/:name/:file.:format",
      :controller => "public/node/categories",
      :action     => :show
    ns.connect "node_categories/index.html",
      :controller => "public/node/categories",
      :action     => :index
    ns.connect "node_attributes/:name/:attr/index.:format",
      :controller => "public/node/attributes",
      :action     => :show_attr
    ns.connect "node_attributes/:name/:file.:format",
      :controller => "public/node/attributes",
      :action     => :show
    ns.connect "node_attributes/index.html",
      :controller => "public/node/attributes",
      :action     => :index
    ns.connect "node_areas/:name/:attr/index.:format",
      :controller => "public/node/areas",
      :action     => :show_attr
    ns.connect "node_areas/:name/:file.:format",
      :controller => "public/node/areas",
      :action     => :show
    ns.connect "node_areas/index.html",
      :controller => "public/node/areas",
      :action     => :index
  end
end
