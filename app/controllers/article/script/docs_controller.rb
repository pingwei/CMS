# encoding: utf-8
class Article::Script::DocsController < Cms::Controller::Script::Publication
  def publish
    ## publish_nodes
    if @node
      uri  = "#{@node.public_uri}"
      path = "#{@node.public_path}"
      publish_more(@node, :uri => uri, :path => path, :first => 2)
      return render(:text => "OK")
    end
    
    begin
      item = params[:item]
      puts "-- Publish: ArticleDoc##{item.id}"
      
      if item.state == 'recognized'
        uri  = "#{item.public_uri}"
        path = "#{item.public_path}"
        if !item.publish(render_public_as_string(uri, :site => item.content.site))
          return render(:text => "Error: #{item.errors.full_messages}")
        end
        if item.published? || !::File.exist?("#{path}.r")
          item.publish_page(render_public_as_string("#{uri}index.html.r", :site => item.content.site),
            :path => "#{path}.r", :dependent => :ruby)
        end
        return render(:text => "OK: Published")
      end
      return render(:text => "Notice: Not Recognized")
    rescue => e
      return render(:text => "Error: #{e}") rescue nil
    end
  end
  
  def close
    begin
      item = params[:item]
      puts "-- Close: ArticleDoc##{item.id}"
      
      if item.state == 'public'
        item.close
        return render(:text => "OK: Closed")
      end
      return render(:text => "Notice: Not Opened")
    rescue => e
      return render(:text => "Error: #{e}") rescue nil
    end
  end
end
