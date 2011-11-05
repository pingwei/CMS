class Cms::Admin::Navi::ConceptsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  
  def index
    skip_layout
  end
  
  def show
    if params[:id] != Core.concept(:id).to_s
      Core.set_concept(session, params[:id])
    end
    
    @item = Core.concept
  end
end
