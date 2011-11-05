# encoding: utf-8
class Article::Public::Node::TagDocsController < Cms::Controller::Public::Base
  include Article::Controller::Feed
  
  def index
    @base_uri = Page.current_node.public_uri
    return redirect_to(@base_uri) if params[:reset]
    
    @tag = params[:tag] || params[:s_tag]
    @tag = @tag.to_s.force_encoding('utf-8')
    
    if request.post? || @tag =~ / /
      @tag = @tag.strip.gsub(/ .*/, '')
      return redirect_to("#{@base_uri}#{CGI::escape(@tag)}")
    end
      
    @docs = Array.new.paginate
    
    if @tag
      doc = Article::Doc.new.public
      doc.agent_filter(request.mobile)
      doc.and :content_id, Page.current_node.content.id
      doc.and 'language_id', 1
      qw = doc.connection.quote_string(@tag).gsub(/([_%])/, '\\\\\1')
      doc.and "sql", "EXISTS (SELECT * FROM article_tags WHERE article_docs.unid = article_tags.unid AND word LIKE '#{qw}%') "
      doc.page params[:page], (request.mobile? ? 20 : 50)
      @docs = doc.find(:all, :order => 'published_at DESC')
    end
    
    return true if render_feed(@docs)
  end
end
