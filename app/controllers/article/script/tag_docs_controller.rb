# encoding: utf-8
class Article::Script::TagDocsController < Cms::Controller::Script::Publication
  def publish
    render :text => "OK"
  end
end
