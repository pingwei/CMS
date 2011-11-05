# encoding: utf-8
class Cms::Admin::NodesController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base

  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:designer)
    
    id      = params[:parent] == '0' ? Core.site.node_id : params[:parent]
    @parent = Cms::Node.new.find(id)
  end

  def index
    item = Cms::Node.new#.readable
    item.and :parent_id, @parent.id
    item.and :directory, 1
    item.order params[:sort], 'name, id'
    @dirs = item.find(:all)
    
    item = Cms::Node.new#.readable
    item.and :parent_id, @parent.id
    item.and :directory, 0
    item.order params[:sort], 'name, id'
    @pages = item.find(:all)
    
    _index @pages
  end

  def show
    @item = Cms::Node.new.find(params[:id])
    return error_auth unless @item.readable?

    _show @item
  end

  def new
    @item = Cms::Node.new({
      :concept_id => @parent.inherited_concept(:id),
      :site_id    => Core.site.id,
      :state      => 'public',
      :parent_id  => @parent.id,
      :route_id   => @parent.id,
      :layout_id  => @parent.layout_id
    })
    @models = models(false)
  end

  def create
    @models = models(false)
    
    @item = Cms::Node.new(params[:item])
    #@item.parent_id    = @parent.id
    @item.state        = 'public'
    @item.published_at = Core.now
    @item.directory    = (@item.model_type == :directory)
    @item.name         = 'tmp' # for validation
    
    _create(@item) do
      @item.name = nil # for validation
      @item.save(false)
      respond_to do |format|
        format.html { return redirect_to(@item.edit_admin_uri) }
      end
    end
  end

  def update
    exit
  end

  def destroy
    exit
  end
  
  def models(rendering = true)
    content_id = params[:content_id]
    content_id = @item.content.id if @item && @item.content
    model = 'cms'
    if content = Cms::Content.find_by_id(content_id)
      model = content.model
    end
    models  = Cms::Lib::Modules.directories(model)
    models += Cms::Lib::Modules.pages(model)
    
    return models unless rendering
    
    @models = [["// 一覧を更新しました（#{models.size}件）", '']] + models
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
end
