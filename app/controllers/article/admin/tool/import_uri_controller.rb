# encoding: utf-8
class Article::Admin::Tool::ImportUriController < Cms::Controller::Admin::Base
  
  def import
    uri = params[:uri]#.join('/')
    return http_error(404) if uri.blank?
    
    res = Util::Http::Request.send(uri)
    return http_error(404) if res.status != 200
    
    data = res.body.toutf8.gsub(/.*<body[^>]+>(.*)<\/body>.*/m, '\\1')
    
    render :text => data
  rescue
    return http_error(404)
  end
end
