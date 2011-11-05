# encoding: utf-8
class Bbs::Script::ItemDocsController < Cms::Controller::Script::Publication
  def self.publishable?
    false
  end
  
  def publish
    render :text => "OK"
  end
end
