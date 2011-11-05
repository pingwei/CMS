ActionController::Routing::Routes.draw do |map|
  mod = "newsletter"

  ## admin
  map.namespace(mod, :namespace => '') do |ns|
    ns.resources :docs,
      :controller  => "admin/docs",
      :path_prefix => "/_admin/#{mod}/:content",
      :member => {:deliver => :get}
    ns.resources :members,
      :controller  => "admin/members",
      :path_prefix => "/_admin/#{mod}/:content"
    ns.resources :tests,
      :controller  => "admin/tests",
      :path_prefix => "/_admin/#{mod}/:content"

    ## content
    ns.resources :content_base,
      :controller => "admin/content/base",
      :path_prefix => "/_admin/#{mod}"
    ns.resources :content_settings,
      :controller  => "admin/content/settings",
      :path_prefix => "/_admin/#{mod}/:content"

    ## node
    ns.resources :node_forms,
      :controller  => "admin/node/forms",
      :path_prefix => "/_admin/#{mod}/:parent"

    ## piece
  end

  ## public
  map.namespace(mod, :namespace => '', :path_prefix => '/_public') do |ns|
    ns.connect "node_forms/index.:format",
      :controller => "public/node/forms",
      :action     => :index
    ns.connect "node_forms/change/index.:format",
      :controller => "public/node/forms",
      :action     => :change
    ns.connect "node_forms/sent/:id/:token/index.:format",
      :controller => "public/node/forms",
      :action     => :sent
    ns.connect "node_forms/unsubscribe/:id/:token/index.:format",
      :controller => "public/node/forms",
      :action     => :unsubscribe
  end
end
