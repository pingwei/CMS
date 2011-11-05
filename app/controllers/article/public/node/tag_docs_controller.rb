# encoding: utf-8
class Article::Public::Node::TagDocsController < Cms::Controller::Public::Base
  include Article::Controller::Feed
  
  def index
    base_uri = Core.current_node.public_uri
    return redirect_to(base_uri) if params[:reset]
    return redirect_to("#{base_uri}#{CGI::escape(params[:s_tag])}") if params[:s_tag]
    
    @tag  = params[:tag] ? params[:tag].force_encoding('utf-8') : nil
    @docs = Array.new.paginate
    
    if @tag
      params[:search] = true
      
      doc = Article::Doc.new.public
      doc.agent_filter(request.mobile)
      doc.and :content_id, Core.current_node.content.id
      doc.and 'language_id', 1
      joins = "inner join article_tags USING(unid)"
      doc.and "article_tags.word", 'LIKE', "#{@tag}%"
      doc.page params[:page], (request.mobile? ? 20 : 50)
      @docs = doc.find(:all, :joins => joins, :order => 'published_at DESC')
    end
    
    return true if render_feed(@docs)
  end
end
