class Cms::Script::NodesController < Cms::Controller::Script::Publication
  def publish
    @ids  = {}
    
    Cms::Node.new.public.find(:all, :conditions => {:parent_id => 0}, :order => "name, id").each do |node|
      publish_node(node)
    end
    
    render :text => "OK"
  end
  
  def publish_node(node)
    return if @ids.key?(node.id)
    @ids[node.id] = 1
    last_name = nil
    
    cond = ["parent_id = ? AND name IS NOT NULL AND name != ''", node.id]
    Cms::Node.new.find(:all, :select => :id, :conditions => cond, :order => "directory, name, state DESC, id").each do |v|
      item = Cms::Node.find_by_id(v[:id])
      next unless item
      next if item.name.blank? || item.name == last_name
      last_name = item.name
      
      if !item.public?
        item.close_page
        next
      end
      
      ## page
      if item.model == 'Cms::Page'
        begin
          publish_page(item, :uri => item.public_uri, :site => item.site, :path => item.public_path)
        rescue => e
          error_log(e)
        end
        next
      end
      
      ## modules' page
      if item.model != 'Cms::Directory'
        begin
          model = item.model.underscore.pluralize.gsub(/^(.*?)\//, '\1/script/')
          next unless eval("#{model.camelize}Controller").publishable?
          
          publish_page(item, :uri => item.public_uri, :site => item.site, :path => item.public_path)
          res   = render_component_as_string :controller => model, :action => "publish", :params => {:node => item}
        rescue LoadError => e
          error_log(e)
          next
        rescue Exception => e
          error_log(e)
          next
        end
        #next
      end
      
      publish_node(item)
    end
  end
  
  def publish_by_task
    begin
      item = params[:item]
      if item.state == 'recognized' && item.model == "Cms::Page"
        puts "-- Publish: #{item.class}##{item.id}"
        item = Cms::Node::Page.find(item.id)
        uri  = "#{item.public_uri}?node_id=#{item.id}"
        path = "#{item.public_path}"
        
        if !item.publish(render_public_as_string(uri, :site => item.site))
          raise item.errors.full_messages
        end
        if item.published? || !::File.exist?("#{path}.r")
          item.publish_page(render_public_as_string("#{uri}.r", :site => item.site),
            :path => "#{path}.r", :dependent => :ruby)
        end
        
        puts "OK: Published"
        params[:task].destroy
      end
    rescue => e
      puts "Error: #{e}"
    end
    return render(:text => "OK")
  end
  
  def close_by_task
    begin
      item = params[:item]
      if item.state == 'public' && item.model == "Cms::Page"
        puts "-- Close: #{item.class}##{item.id}"
        item = Cms::Node::Page.find(item.id)
        
        item.close
        
        puts "OK: Closed"
        params[:task].destroy
      end
    rescue => e
      puts "Error: #{e}"
    end
    return render(:text => "OK")
  end
end
