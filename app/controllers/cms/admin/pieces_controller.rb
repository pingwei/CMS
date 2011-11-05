# encoding: utf-8
class Cms::Admin::PiecesController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  
  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:designer)
  end
  
  def index
    item = Cms::Piece.new.readable
    item.page  params[:page], params[:limit]
    item.order params[:sort], 'name, id'
    @items = item.find(:all)
    _index @items
  end
  
  def show
    exit
  end
  
  def new
    @item = Cms::Piece.new({
      :concept_id => Core.concept(:id),
      :state      => 'public'
    })
    @models = models(false)
  end
  
  def create
    @item = Cms::Piece.new(params[:item])
    @item.site_id = Core.site.id
    @models = models(false)
    
    _create @item do
      respond_to do |format|
        format.html { return redirect_to(@item.admin_uri) }
      end
    end
  end
  
  def update
    exit
  end
  
  def destroy
    @item = Cms::Piece.new.find(params[:id])
    _destroy @item
  end
  
  def models(rendering = true)
    content_id = params[:content_id]
    content_id = @item.content.id if @item && @item.content
    model = 'cms'
    if content = Cms::Content.find_by_id(content_id)
      model = content.model
    end
    models = Cms::Lib::Modules.pieces(model)
    return models unless rendering
    
    @models = [["// 一覧を更新しました（#{models.size}件）", '']] + models
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
end
