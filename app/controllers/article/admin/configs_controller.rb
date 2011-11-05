# encoding: utf-8
class Article::Admin::ConfigsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base

  def pre_dispatch
    return error_auth unless @content = Cms::Content.find(params[:content])
    return error_auth unless Core.user.has_priv?(:read, :item => @content.concept)
    default_url_options :content => @content
    return redirect_to(request.env['PATH_INFO']) if params[:reset]
  end

  def index
    @items = Article::Model::Content::Config.configs(@content)
    _index @items
  end

  def show
    @item   = Article::Model::Content::Config.find(params[:id], @content)
    @item ||= Article::Model::Content::Config.new(@content, {:id => params[:id]})
    _show @item
  end

  def new
    http_error(404)
  end

  def create
    http_error(404)
  end

  def update
    @item   = Article::Model::Content::Config.find(params[:id], @content)
    @item ||= Article::Model::Content::Config.new(@content, {:id => params[:id]})
    @item.value = params[:item][:value]
    
    _update(@item)
  end

  def recognize(item)
    _recognize(item) do
      if @item.state == 'recognized'
        send_recognition_success_mail(@item)
      elsif @recognition_type == 'with_admin'
        if item.recognition.recognized_all?(false)
          users = Sys::User.find_managers
          send_recognition_request_mail(@item, users)
        end
      end
    end
  end
  
  def destroy
    http_error(404)
  end
end
