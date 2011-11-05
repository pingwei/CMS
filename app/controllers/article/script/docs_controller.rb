# encoding: utf-8
class Article::Script::DocsController < Cms::Controller::Script::Publication
  def publish
    if @node
      uri  = "#{@node.public_uri}"
      path = "#{@node.public_path}"
      publish_more(@node, :uri => uri, :path => path, :first => 2)
    end
    
    begin
      item = params[:item]
      puts "-- 公開 #{item.title}"
      if item.state == 'recognized'
        uri  = "#{item.public_uri}"
        path = "#{item.public_path}"
        rs = item.publish(render_public_as_string(uri, :site => item.content.site))
        if rs == true && (item.published? || !File.exist?("#{path}.r"))
          item.publish_page(render_public_as_string("#{uri}index.html.r", :site => item.content.site),
            :path => "#{path}.r", :dependent => :ruby)
        end
      else
        raise "not recognized."
      end
    rescue => e
      return render(:text => "Error #{e}")
    end
    render :text => "OK"
  end
  
  def close
    begin
      item = params[:item]
      puts "-- 非公開 #{item.title}"
      if item.state == 'public'
        item.close
      else
        raise "not opend."
      end
    rescue => e
      return render(:text => "Error #{e}")
    end
    render :text => "OK"
  end
end
