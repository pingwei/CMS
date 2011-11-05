# encoding: utf-8
class Cms::Admin::StylesheetsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  
  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:designer)
    @root      = "#{Rails.root}/public/_common/themes"
    @path      = params[:path].join('/').to_s.force_encoding('utf-8')
    @full_path = "#{@root}/#{@path}"
    @base_uri  = ["#{Rails.root}/public/", "/"]
    
    unless ::File.exist?(@full_path)
      return http_error(404) if flash[:notice]
      flash[:notice] = "指定されたパスは存在しません。（ #{@full_path.gsub(@base_uri[0], @base_uri[1])} ）"
      redirect_to(cms_stylesheets_path(''))
    end
  end
  
  def index
    @item = Cms::Stylesheet.find(@full_path, :root => @root, :base_uri => @base_uri)
    
    return show    if params[:do] == 'show'
    return new     if params[:do] == 'new'
    return edit    if params[:do] == 'edit'
    return update  if params[:do] == 'update'
    return rename  if params[:do] == 'rename'
    return move    if params[:do] == 'move'
    return destroy if params[:do] == 'destroy'
    if params[:do].nil? && !@item.directory?
      params[:do] = "show"
      return show
    end
    if request.post? && location = create
      return redirect_to(location)
    end
    
    @dirs  = @item.child_directories
    @files = @item.child_files
  end
  
  def show
    @item.read_body
    render :action => :show
  end
  
  def new
    render :action => :new
  end
  
  def edit
    @item.read_body
    render :action => :edit
  end
  
  def rename
    if request.put?
      if @item.rename(params[:item][:name])
        flash[:notice] = '更新処理が完了しました。'
        location = cms_stylesheets_path(::File.dirname(@path))
        return redirect_to(location)
      end
    end
    render :action => :rename
  end
  
  def move
    if request.put?
      if @item.move(params[:item][:path])
        flash[:notice] = '更新処理が完了しました。'
        location = cms_stylesheets_path(::File.dirname(@path))
        return redirect_to(location)
      end
    end
    render :action => :move
  end
  
  def create
    if params[:create_directory]
      if @item.create_directory(params[:item][:new_directory])
        flash[:notice] = 'ディレクトリを作成しました。'
        return cms_stylesheets_path(@path)
      end
    elsif params[:create_file]
      if @item.create_file(params[:item][:new_file])
        flash[:notice] = 'ファイルを作成しました。'
        return cms_stylesheets_path(::File.join(@path, params[:item][:new_file]), :do => 'edit')
      end
    elsif params[:upload_file]
      if @item.upload_file(params[:item][:new_upload])
        flash[:notice] = 'アップロードが完了しました。'
        return cms_stylesheets_path(@path)
      end
    end
    return false
  end
  
  def update
    @item.body = params[:item][:body]
    
    if @item.valid? && @item.save
      flash[:notice] = '更新処理が完了しました。'
      #location = cms_stylesheets_path(::File.dirname(@path))
      location = cms_stylesheets_path(@path, :do => 'edit')
      return redirect_to(location)
    end
    render :action => :edit
  end
  
  def destroy
    if @item.destroy
      flash[:notice] = "削除処理が完了しました。"
    else
      flash[:notice] = "削除処理に失敗しました。（#{@item.errors.full_messages.join(' ')}）"
    end
    location = cms_stylesheets_path(::File.dirname(@path))
    return redirect_to(location)
  end
end
