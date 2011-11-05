# encoding: utf-8
class Article::Admin::Tool::DocsController < Cms::Controller::Admin::Base
  include Cms::Controller::Layout
  
  def pre_dispatch
  end

  def rebuild
    content = params[:content]
    results = [0, 0]
    errors  = []
    
    item = Article::Doc.new.public
    item.and :content_id, content.id
    items = item.find(:all, :select => "id", :order => 'published_at DESC')
    #items = item.find(:all, :order => 'published_at DESC')

    items.each do |c|
      item = c.class.find(c.id)
      begin
        uri  = "#{item.public_uri}"
        path = item.public_path
        if item.rebuild(render_public_as_string(uri, :site => item.content.site), :path => path)
          item.publish_page(render_public_as_string("#{uri}/index.html.r", :site => item.content.site),
            :path => "#{path}.r", :dependent => true)
          results[0] += 1
        else
          raise item.errors.full_messages if item.errors.size > 0
          raise 'Error'
        end
      rescue => e
        results[1] += 1
        errors << "失敗： #{item.id},#{item.title},#{e}"
      end
    end
    
    Core.messages << "-- 成功 #{results[0]}件"
    Core.messages << "-- 失敗 #{results[1]}件"
    Core.messages += errors
    
    render :text => "OK"
  end
end
