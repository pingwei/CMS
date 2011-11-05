class Cms::Admin::Piece::BaseController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  
  before_filter :pre_dispatch_piece
  
  def pre_dispatch_piece
    return error_auth unless Core.user.has_auth?(:designer)
    return error_auth unless @piece = Cms::Piece.new.readable.find(params[:id])
    default_url_options :piece => @piece
  end
  
  def model
    return @model_class if @model_class
    mclass = self.class.to_s.gsub(/^(\w+)::Admin/, '\1').gsub(/Controller$/, '').singularize
    eval(mclass)
    @model_class = eval(mclass)
  rescue
    @model_class = Cms::Piece
  end
  
  def index
    exit
  end
  
  def show
    @item = model.new.find(params[:id])
    return error_auth unless @item.readable?
    _show @item
  end

  def new
    exit
  end
  
  def create
    exit
  end
  
  def update
    @item = model.new.find(params[:id])
    @item.attributes = params[:item]
    
    _update @item do
      respond_to do |format|
        format.html { return redirect_to(cms_pieces_path) }
      end
    end
  end
  
  def destroy
    @item = model.new.find(params[:id])
    _destroy @item do
      respond_to do |format|
        format.html { return redirect_to(cms_pieces_path) }
      end
    end
  end
end
