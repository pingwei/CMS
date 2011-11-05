# encoding: utf-8
class Enquete::Public::Node::FormsController < Cms::Controller::Public::Base
  include Article::Controller::Feed
  
  def pre_dispatch
    return http_error(404) unless @content = Core.current_node.content
    #@docs_uri = @content.public_uri('Article::Doc')
  end
  
  def index
#    @item = Bbs::Item.new
#    return create if request.post?
    
    item = Enquete::Form.new.public
    item.and :content_id, @content.id
    #doc.search params
    item.page params[:page], (request.mobile? ? 10 : 20)
    @items = item.find(:all, :order => 'sort_no ASC, id DESC')
  end
  
  def show
    item = Enquete::Form.new.public
    item.and :content_id, @content.id
    item.and :id, params[:id]
    @item = item.find(:first)
    return http_error(404) unless @item
    
    @form = form(@item)
    
    ## post
    return false unless request.post?
    @form.submit_values = params[:item]
    
    ## edit
    return false if params[:edit]
    
    ## validate
    return false unless @form.valid?
    
    ## confirm
    if params[:confirm].blank?
      @confirm = true
      @form.freeze
      return false
    end
    
    ## save
    client = {
      :ipaddr     => request.remote_addr,
      :user_agent => request.user_agent
    }
    unless @item.save_answer(@form.values(:string), client)
      render :text => "送信に失敗しました。"
      return false
    end
      
    redirect_to "#{Core.current_node.public_uri}#{@item.id}/sent"
  end
  
  def sent
    item = Enquete::Form.new.public
    item.and :content_id, @content.id
    item.and :id, params[:id]
    @item = item.find(:first)
  end
  
protected
  def form(item)
    form = Sys::Lib::Form::Builder.new(:item, {:template => @template})
    item.public_columns.each do |col|
      form.add_element(col.column_type, col.element_name, col.name, col.element_options)
    end
    form
  end
end
