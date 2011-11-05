# encoding: utf-8
class Portal::Public::Piece::RecentTabsController < Sys::Controller::Public::Base
  include Portal::Controller::Feed

  def pre_dispatch
    @piece   = Page.current_piece
    @piece   = Portal::Piece::FeedEntry.find(@piece.id)
    @content = @piece.content
  end

  def index
    @content = Portal::Content::FeedEntry.find(Page.current_piece.content_id)

    @tabs = []
    base_content = Portal::Content::Base.find_by_id(@content.id)

    Portal::Piece::RecentTabXml.find(:all, @piece, :order => :sort_no).each do |tab|
      next if tab.name.blank?

      current   = (@tabs.size == 0) ? true : nil
      tab_class = tab.name
      tab_class = "#{tab.name} current" if current
      more_uri = tab.more.blank? ? nil : tab.more

      entries = []
      entry = Portal::FeedEntry.new.public
      entry.agent_filter(request.mobile)
      entry.and "#{Cms::FeedEntry.table_name}.content_id", @content.id
      entry.page 1, 10
      list = tab.category_items
      if list.size > 0
        entry.category_is list[0]
        entries = entry.find_with_own_docs(base_content.doc_content, :groups, {:item => list[0]} )

        #more
        more_uri = "#{@content.category_node.public_uri}#{list[0].name}/" if !more_uri && @content.category_node && entries.size > 0
      else
        entries = entry.find_with_own_docs(base_content.doc_content, :docs)

        #more
        more_uri = @content.entry_node.public_uri if !more_uri && @content.entry_node && entries.size > 0
      end

      @tabs << {
        :name    => tab.name,
        :title   => tab.title,
        :class   => tab_class,
        :more    => more_uri,
        :current => current,
        :docs    => entries
      }
    end

    return render :text => '' if @tabs.size == 0
  end
end
