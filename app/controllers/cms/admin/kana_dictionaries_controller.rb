# encoding: utf-8
class Cms::Admin::KanaDictionariesController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  include Sys::Controller::Scaffold::Publication
  
  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:manager)
  end
  
  def index
    return test if params[:do] == 'test'
    return make_dictionary if params[:do] == 'make_dictionary'
    
    item = Cms::KanaDictionary.new#.readable
    item.page  params[:page], params[:limit]
    item.order params[:sort], 'name, id'
    @items = item.find(:all)
    _index @items
  end
  
  def show
    @item = Cms::KanaDictionary.new.find(params[:id])
    return error_auth unless @item.readable?
    
    _show @item
  end

  def new
    @item = Cms::KanaDictionary.new({
      :body => "# コメント（先頭に「#」）\n" +
        "\n# 日本語例 （「漢字, カタカナ」の組み合わせで記述）\n" +
        "文字, モジ\n" +
        "単語, タンゴ\n" +
        "\n# アルファベット例 （長音記号「ー」はアイウエオで記述）\n" +
        "Japanese, ジャパニイズ\n" +
        "People, ピイプル\n"
    })
  end
  
  def create
    return test if params[:do] == 'test'
    
    @item = Cms::KanaDictionary.new(params[:item])
    _create @item
  end
  
  def update
    @item = Cms::KanaDictionary.new.find(params[:id])
    @item.attributes = params[:item]
    _update @item
  end
  
  def destroy
    @item = Cms::KanaDictionary.new.find(params[:id])
    _destroy @item
  end
  
  def make
    res = Cms::KanaDictionary.make_dic_file
    if res == true
      flash[:notice] = '辞書を更新しました。'
    else
      flash[:notice] = res.join('<br />')
    end
    
    redirect_to cms_kana_dictionaries_url
  end
  
  def test
    @mode   = true
    @result = nil
    if params[:yomi_kana]
      @mode = 'ふりがな'
      @result = Cms::Lib::Navi::Ruby.convert(params[:body])
    elsif params[:talk_kana]
      @mode = '音声テキスト'
      @result = Cms::Lib::Navi::Gtalk.make_text(params[:body])
    elsif params[:talk_file]
      @skip_layout = true
      gtalk = Cms::Lib::Navi::Gtalk.new
      gtalk.make params[:body]
      file = gtalk.output
      send_file(file[:path], :type => file[:path], :filename => 'sound.mp3', :disposition => 'inline')
    end
  end
end
