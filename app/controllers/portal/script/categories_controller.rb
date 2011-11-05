# encoding: utf-8
class Portal::Script::CategoriesController < Cms::Controller::Script::Publication
  def publish
    cond = {:state => 'public', :content_id => @node.content_id}
    Portal::Category.root_items(cond).each do |item|
      uri  = "#{@node.public_uri}#{item.name}/"
      path = "#{@node.public_path}#{item.name}/"
      publish_page(item, :uri => uri, :path => path)

      item.public_children.each do |c|
        uri  = "#{@node.public_uri}#{c.name}/"
        path = "#{@node.public_path}#{c.name}/"
        publish_page(item, :uri => uri, :path => path, :dependent => "#{c.name}")
      end
    end

    render :text => (@errors.size == 0 ? "OK" : @errors.join("\n"))
  end
end
