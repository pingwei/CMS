# encoding: utf-8
class Article::Public::Node::DocsController < Cms::Controller::Public::Base
  include Article::Controller::Feed
  
  def pre_dispatch
    return http_error(404) unless @content = Core.current_node.content
    #@docs_uri = @content.public_uri('Article::Doc')
  end
  
  def index
    doc = Article::Doc.new.public
    doc.agent_filter(request.mobile)
    doc.and :content_id, @content.id
    doc.and :language_id, 1
    doc.visible_in_list
    doc.search params
    doc.page params[:page], (request.mobile? ? 20 : 50)
    @docs = doc.find(:all, :order => 'published_at DESC')
    return true if render_feed(@docs)
    
    return http_error(404) if @docs.current_page > 1 && @docs.current_page > @docs.total_pages
    
    prev   = nil
    @items = []
    @docs.each do |doc|
      date = doc.published_at.strftime('%y%m%d')
      @items << {
        :date => (date != prev ? doc.published_at.strftime('%Y年%-m月%-d日') : nil),
        :doc  => doc
      }
      prev = date    
    end
  end

  def show
    doc = Article::Doc.new.public_or_preview
    doc.agent_filter(request.mobile) if Core.mode != 'preview'
    doc.and :content_id, Core.current_node.content.id
    doc.and :name, params[:name]
    return http_error(404) unless @item = doc.find(:first)

    Page.current_item = @item
    Page.title        = @item.title

    if request.mobile?
      body = (@item.mobile_body.to_s == '' ? @item.body : @item.mobile_body)

      related_sites = Page.site.related_sites(:include_self => true)

      ## Converts the TABLE tags.
      body.gsub!(/<table[ ].*?>.*?<\/table>/iom) do |m|
        '' #remove
      end

      ## Converts the images.
      body.gsub!(/<img .*?src=".*?".*?>/iom) do |m|
        '' #remove
      end

      ## Converts the links.
      body.gsub!(/<a .*?href=".*?".*?>.*?<\/a>/iom) do |m|
        uri   = m.gsub(/<a .*?href="(.*?)".*?>.*?<\/a>/iom, '\1')
        label = m.sub(/(<a .*?href=".*?".*?>)(.*?)(<\/a>)/i, '\2')

        if m =~ /^<a .*?class="iconFile.*?"/i
          ## attachment
          size = label.gsub(/.*(\(.*?\))$/, '\1')
          ext  = label.gsub(/.*\.(.*?)\(.*?\)$/, '\1').to_s.upcase
          "#{ext}ファイル#{size}"

        elsif uri =~ /\.(pdf|doc|docx|xls|xlsx|jtd|jst)$/i
          ## other than html file
          label
        
        elsif uri =~ /^(\/|\.\/|\.\.\/)/
          ## same site
          m

        else
          result = false
          related_sites.each do |site|
            result = true if uri + '/' =~ /^#{site}/i
            result = true if uri =~ /^[0-9a-z]/i && uri !~ /^(http|https):\/\//
            break if result
          end
          result ? m : label
        end
      end

      ##Converts the phone number texts.
      body.gsub!(/[\(]?(([0-9]{2}[-\(\)]+[0-9]{4})|([0-9]{3}[-\(\)]+[0-9]{3,4})|([0-9]{4}[-\(\)]+[0-9]{2}))[-\)]+[0-9]{4}/) do |m|
        "<a href='tel:#{m.gsub(/\D/, '\1')}'>#{m}</a>"
      end

      @item.mobile_body = body
    end
  end
end
