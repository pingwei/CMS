# encoding: utf-8
class Article::Admin::DocsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  include Sys::Controller::Scaffold::Recognition
  include Sys::Controller::Scaffold::Publication
  helper Article::FormHelper

  def pre_dispatch
    return error_auth unless @content = Cms::Content.find(params[:content])
    return error_auth unless Core.user.has_priv?(:read, :item => @content.concept)
    default_url_options :content => @content
    return redirect_to(request.env['PATH_INFO']) if params[:reset]
    
    if rcg = Article::Model::Content::Config.find(:recognition_type, @content)
      @recognition_type = rcg.value
    end
  end

  def index
    item = Article::Doc.new#.public#.readable
    #item.public unless Core.user.has_auth?(:manager)
    item.and :content_id, @content.id
    item.search params
    item.page  params[:page], params[:limit]
    item.order params[:sort], 'updated_at DESC'
    @items = item.find(:all)
    _index @items
  end

  def show
    @item = Article::Doc.new.find(params[:id])
    #return error_auth unless @item.readable?
    
    @item.recognition.type = @recognition_type if @item.recognition
    
    _show @item
  end

  def new
    @item = Article::Doc.new({
      :state        => 'recognize',
      :notice_state => 'hidden',
      :recent_state => 'visible',
      :list_state   => 'visible',
      :event_state  => 'hidden'
    })
    @item.in_inquiry = @item.default_inquiry
    
    ## add tmp_id
    unless params[:_tmp]
      return redirect_to url_for(:action => :new, :_tmp => Util::Sequencer.next_id(:tmp, :md5 => true))
    end
  end
  
  def link_check
    @checker = Sys::Lib::Form::Checker.new
    if params[:link_check] == "1"
      @checker.check_link @item.body
      return render :action => :new
    end
    
    if @item.state == 'recognize'
      @item.link_checker = @checker if params[:link_check] != "0"
    end
  end
  
  def create
    @item = Article::Doc.new(params[:item])
    @item.content_id = @content.id
    @item.state      = params[:commit_recognize] ? 'recognize' : 'draft'
    
    @checker = Sys::Lib::Form::Checker.new
    if params[:link_check] == "1"
      @checker.check_link @item.body
      return render :action => :new
    elsif @item.state == 'recognize'
      @item.link_checker = @checker if params[:link_check] != "0"
    end
    
    _create @item do
      @item.fix_tmp_files(params[:_tmp])
      if @item.state == 'recognize'
        send_recognition_request_mail(@item)
      else
        @item.recognition.destroy if @item.recognition;
      end
    end
  end

  def update
    @item = Article::Doc.new.find(params[:id])
    @item.attributes = params[:item]
    @item.state      = params[:commit_recognize] ? 'recognize' : 'draft'

    @checker = Sys::Lib::Form::Checker.new
    if params[:link_check] == "1"
      @checker.check_link @item.body
      return render :action => :edit
    elsif @item.state == 'recognize'
      @item.link_checker = @checker if params[:link_check] != "0"
    end
    
    _update(@item) do
      if @item.state == 'recognize'
        send_recognition_request_mail(@item)
      else
        @item.recognition.destroy if @item.recognition
      end
      @item.close if @item.published_at
    end
  end

  def recognize(item)
    _recognize(item) do
      if @item.state == 'recognized'
        send_recognition_success_mail(@item)
      elsif @recognition_type == 'with_admin'
        if item.recognition.recognized_all?(false)
          users = Sys::User.find_managers
          send_recognition_request_mail(@item, users)
        end
      end
    end
  end
  
  def destroy
    @item = Article::Doc.new.find(params[:id])
    _destroy @item
  end

  def publish(item)
    _publish(item) do
      uri  = "#{item.public_uri}index.html.r"
      path = "#{item.public_path}.r"
      item.publish_page(render_public_as_string(uri, :site => item.content.site), :path => path, :dependent => :ruby)
    end
  end

protected
  def send_recognition_request_mail(item, users = nil)
    mail_fr = Core.user.email
    mail_to = nil
    subject = "#{item.content.name}（#{item.content.site.name}）：承認依頼メール"
    message = "#{Core.user.name}さんより「#{item.title}」についての承認依頼が届きました。\n" +
      "次の手順により，承認作業を行ってください。\n" +
      "\n" +
      "１．PC用記事のプレビューにより文書を確認\n" +
      "　#{item.preview_uri}\n" +
      "\n" +
      "２．次のリンクから承認を実施\n" +
      "　#{url_for(:action => :show, :id => item)}\n"
    
    users ||= item.recognizers
    users.each {|user| send_mail(mail_fr, user.email, subject, message) }
  end

  def send_recognition_success_mail(item)
    return true unless item.recognition
    return true unless item.recognition.user
    return true if item.recognition.user.email.blank?

    mail_fr = Core.user.email
    mail_to = item.recognition.user.email
    
    subject = "#{item.content.name}（#{item.content.site.name}）：最終承認完了メール"
    message = "「#{item.title}」についての承認が完了しました。\n" +
              "次のＵＲＬをクリックして公開処理を行ってください。\n" +
              "\n" +
              "#{url_for(:action => :show, :id => item)}"
    
    send_mail(mail_fr, mail_to, subject, message)
  end
end
