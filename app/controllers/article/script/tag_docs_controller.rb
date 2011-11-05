# encoding: utf-8
class Article::Script::TagDocsController < Cms::Controller::Script::Publication
  def publish
    @node.close_page
    
    render :text => "OK"
  end
end
