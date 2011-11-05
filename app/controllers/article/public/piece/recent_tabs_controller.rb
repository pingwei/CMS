# encoding: utf-8
class Article::Public::Piece::RecentTabsController < Sys::Controller::Public::Base
  include Article::Controller::Feed

  def pre_dispatch
    @piece   = Page.current_piece
    @content = @piece.content
  end
  
  def index
    @tabs = []
    
    Article::Piece::RecentTabXml.find(:all, @piece, :order => :sort_no).each do |tab|
      next if tab.name.blank?
      
      current   = (@tabs.size == 0) ? true : nil
      tab_class = tab.name
      tab_class = "#{tab.name} current" if current
      
      doc = Article::Doc.new.public
      doc.agent_filter(request.mobile)
      doc.and :content_id, @content.id
      doc.visible_in_recent
      doc.group_is(tab)
      doc.page 1, 10
      docs = doc.find(:all, :order => 'published_at DESC')
      
      @tabs << {
        :name    => tab.name,
        :title   => tab.title,
        :class   => tab_class,
        :more    => (tab.more.blank? ? nil : tab.more),
        :current => current,
        :docs    => docs
      }
    end
    
    return render :text => '' if @tabs.size == 0
  end
end
