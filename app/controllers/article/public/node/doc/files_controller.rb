# encoding: utf-8
class Article::Public::Node::Doc::FilesController < Cms::Controller::Public::Base
  def show
    doc = Article::Doc.new.public_or_preview
    doc.agent_filter(request.mobile)
    doc.and :name, params[:name]
    return http_error(404) unless @doc = doc.find(:first)
    
    item = Sys::File.new
    item.and :parent_unid, @doc.unid
    item.and :name, params[:file] + '.' + params[:format]
    return http_error(404) unless @file = item.find(:first)
    
    send_file @file.upload_path, :type => @file.mime_type, :filename => @file.name, :disposition => 'inline'
  end
end
