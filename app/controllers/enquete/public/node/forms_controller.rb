# encoding: utf-8
class Enquete::Public::Node::FormsController < Cms::Controller::Public::Base
  include Article::Controller::Feed
  
  def pre_dispatch
    return http_error(404) unless @content = Page.current_node.content
    #@docs_uri = @content.public_uri('Article::Doc')
  end
  
  def index
    item = Enquete::Form.new.public
    item.and :content_id, @content.id
    #doc.search params
    item.page params[:page], (request.mobile? ? 10 : 20)
    @items = item.find(:all, :order => 'sort_no ASC, id DESC')
  end
  
  def show
    item = Enquete::Form.new.public
    item.and :content_id, @content.id
    item.and :id, params[:id]
    @item = item.find(:first)
    return http_error(404) unless @item
    
    @form = form(@item)
    
    ## post
    return false unless request.post?
    @form.submit_values = params[:item]
    
    ## edit
    return false if params[:edit]
    
    ## validate
    return false unless @form.valid?
    
    ## confirm
    if params[:confirm].blank?
      @confirm = true
      @form.freeze
      return false
    end
    
    ## save
    client = {
      :ipaddr     => request.remote_addr,
      :user_agent => request.user_agent
    }
    unless answer = @item.save_answer(@form.values(:string), client)
      render :text => "送信に失敗しました。"
      return false
    end
    
    ## sendmail
    begin
      send_answer_mail(@item, answer)
    rescue => e
      error_log("メール送信失敗 #{e}")
    end
    
    redirect_to "#{Page.current_node.public_uri}#{@item.id}/sent"
  end
  
  def sent
    item = Enquete::Form.new.public
    item.and :content_id, @content.id
    item.and :id, params[:id]
    @item = item.find(:first)
  end
  
protected
  def form(item)
    form = Sys::Lib::Form::Builder.new(:item, {:template => @template})
    item.public_columns.each do |col|
      form.add_element(col.column_type, col.element_name, col.name, col.element_options)
    end
    form
  end
  
  def send_answer_mail(item, answer)
    mail_fr = "cms@" + Page.site.full_uri.gsub(/^.*?\/\/(.*?)(:|\/).*/, '\\1')
    mail_fr = mail_fr.gsub(/www\./, '')
    mail_to = item.content.setting_value(:email)
    return false if mail_to.blank?
    
    subject = "投稿：#{item.name}"
    
    message = ""
    message += "■フォーム名\n"
    message += "#{item.name}\n\n"
    message += "■回答日時\n"
    message += "#{answer.created_at.strftime('%Y-%m-%d %H:%M')}\n\n"
    message += "■IPアドレス\n"
    message += "#{answer.ipaddr}\n\n"
    message += "■ユーザエージェント\n"
    message += "#{answer.user_agent}\n\n"
    
    answer.columns.each do |col|
      message += "■#{col.form_column.name}\n"
      message += "#{col.value}\n\n"
    end
    
    send_mail(mail_fr, mail_to, subject, message)
  end
end
