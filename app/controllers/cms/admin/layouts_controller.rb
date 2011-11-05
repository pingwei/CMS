class Cms::Admin::LayoutsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  include Sys::Controller::Scaffold::Publication
  
  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:designer)
  end
  
  def index
    item = Cms::Layout.new.readable
    item.page  params[:page], params[:limit]
    item.order params[:sort], 'name, id'
    @items = item.find(:all)
    _index @items
  end
  
  def show
    @item = Cms::Layout.new.readable.find(params[:id])
    return error_auth unless @item.readable?
    
    _show @item
  end

  def new
    @item = Cms::Layout.new({
      :concept_id => Core.concept(:id),
      :state      => 'public',
    })
  end
  
  def create
    @item = Cms::Layout.new(params[:item])
    @item.site_id = Core.site.id
    @item.state   = 'public'
    _create @item do
      @item.put_css_files
    end
  end
  
  def update
    @item = Cms::Layout.new.find(params[:id])
    @item.attributes = params[:item]
    _update(@item, :location => url_for(:action => :edit)) do
      @item.put_css_files
    end
  end
  
  def destroy
    @item = Cms::Layout.new.find(params[:id])
    _destroy @item
  end
end
