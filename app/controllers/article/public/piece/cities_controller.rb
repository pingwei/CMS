# encoding: utf-8
class Article::Public::Piece::CitiesController < Sys::Controller::Public::Base
  def index
    return render :text => '' unless Page.current_item.instance_of?(Article::Area)
    
    @public_uri = Core.current_node.public_uri
    @public_uri = File.dirname(@public_uri) + '/'
    @public_uri = File.dirname(@public_uri) + '/' if Core.current_node.controller == 'area_recent_docs'
    
    @cities = Page.current_item.public_children
    
    return render :text => '' if @cities.size == 0
  end
end
