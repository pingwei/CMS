# encoding: utf-8
ActionController::Routing::Routes.instance_eval do
  def recognize(request)
    Core.initialize(request.env)
    super(request)
  end
  
  def recognize_path(path, environment={})
    Core.recognize_path(path)
    super(Core.internal_uri, environment)
  end
end
