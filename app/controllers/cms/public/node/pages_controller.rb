# encoding: utf-8
class Cms::Public::Node::PagesController < Cms::Controller::Public::Base
  def index
    @item = Cms::Model::Node::Page.find(Core.current_node.id)
    
    Page.current_item = @item
    Page.title        = @item.title
    
    @body = @item.body
    
    if request.mobile?
      Page.title = @item.mobile_title if !@item.mobile_title.blank?
      @body = @item.mobile_body if !@item.mobile_body.blank?
    end
  end
end
