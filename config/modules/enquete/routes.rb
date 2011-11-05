ActionController::Routing::Routes.draw do |map|
  mod = "enquete"
  
  ## admin
  map.namespace(mod, :namespace => '') do |ns|
    ns.resources :forms,
      :controller  => "admin/forms",
      :path_prefix => "/_admin/#{mod}/:content"
    ns.resources :form_columns,
      :controller  => "admin/form_columns",
      :path_prefix => "/_admin/#{mod}/:content/:form"
    ns.resources :form_answers,
      :controller  => "admin/form_answers",
      :path_prefix => "/_admin/#{mod}/:content/:form"
    
    ## content
    ns.resources :content_base,
      :controller => "admin/content/base",
      :path_prefix => "/_admin/#{mod}"
    
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
    ns.connect "node_forms/:id/index.:format",
      :controller => "public/node/forms",
      :action     => :show
    ns.connect "node_forms/:id/sent.:format",
      :controller => "public/node/forms",
      :action     => :sent
  end
end
