# encoding: utf-8
class Cms::Public::FilesController < ApplicationController
  def down
    return http_error(404) if params[:path].size != 2
    return http_error(404) if params[:path][0] !~ /^[0-9]+$/
    
    item = Cms::DataFile.new.public
    item.and :id, params[:path][0].gsub(/.$/, '') 
    item.and :name, params[:path][1]
    return http_error(404) unless item = item.find(:first, :order => :id)
    
    path = item.public_path
    return http_error(404) unless FileTest.exist?(path)
    
    if img = item.mobile_image(request.mobile)
      return send_data(img.to_blob, :filename => item.name, :disposition => 'inline')
    end
    
    return send_file(path, :filename => item.name, :disposition => 'inline')
  end
end