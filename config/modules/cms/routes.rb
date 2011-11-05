ActionController::Routing::Routes.draw do |map|
  mod = "cms"

  ## admin
  map.namespace(mod, :namespace => '') do |ns|
    ns.resources :tests,
      :controller  => "admin/tests",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :concepts,
      :controller  => "admin/concepts",
      :path_prefix => "/_admin/#{mod}/:parent",
      :collection  => [:layouts]
    ns.resources :sites,
      :controller  => "admin/sites",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :contents,
      :controller  => "admin/contents",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :nodes,
      :controller  => "admin/nodes",
      :path_prefix => "/_admin/#{mod}/:parent",
      :collection  => [:models]
    ns.resources :layouts,
      :controller  => "admin/layouts",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :pieces,
      :controller  => "admin/pieces",
      :path_prefix => "/_admin/#{mod}",
      :collection  => [:models]
    ns.resources :data_texts,
      :controller  => "admin/data/texts",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :data_files,
      :controller  => "admin/data/files",
      :path_prefix => "/_admin/#{mod}/:parent",
      :member      => {:download => :get}
    ns.resources :data_file_nodes,
      :controller  => "admin/data/file_nodes",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :inline_data_files,
      :controller  => "admin/inline/data_files",
      :path_prefix => "/_admin/#{mod}/:parent",
      :member      => {:download => :get}
    ns.resources :inline_data_file_nodes,
      :controller  => "admin/inline/data_file_nodes",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :kana_dictionaries,
      :controller  => "admin/kana_dictionaries",
      :path_prefix => "/_admin/#{mod}",
      :collection  => [:make, :test]
    ns.resources :navi_concepts,
      :controller  => "admin/navi/concepts",
      :path_prefix => "/_admin/#{mod}"
    
    ## node
    ns.resources :node_directories,
      :controller  => "admin/node/directories",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :node_pages,
      :controller  => "admin/node/pages",
      :path_prefix => "/_admin/#{mod}/:parent"
    ns.resources :node_sitemaps,
      :controller  => "admin/node/sitemaps",
      :path_prefix => "/_admin/#{mod}/:parent"
    
    ## piece
    ns.resources :piece_frees,
      :controller  => "admin/piece/frees",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_page_titles,
      :controller  => "admin/piece/page_titles",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_bread_crumbs,
      :controller  => "admin/piece/bread_crumbs",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_links,
      :controller  => "admin/piece/links",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :piece_link_items,
      :controller  => "admin/piece/link_items",
      :path_prefix => "/_admin/#{mod}/:piece"
  end
  
  map.namespace(mod, :namespace => '', :path_prefix => '/_admin') do |ns|
    ns.connect "tool_rebuild",
      :controller => "admin/tool/rebuild",
      :action     => :index
    ns.connect "tool_search",
      :controller => "admin/tool/search",
      :action     => :index
  end
      
  ## public
  map.namespace(mod, :namespace => '', :path_prefix => '/_public') do |ns|
    ns.connect "node_pages/",
      :controller => "public/node/pages",
      :action     => :index
    ns.connect "node_sitemaps/",
      :controller => "public/node/sitemaps",
      :action     => :index
  end
end