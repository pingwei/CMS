# encoding: utf-8

## ---------------------------------------------------------
## cms/contents

content = create_cms_content :model => "Newsletter::Doc", :name => "メールマガジン"

Cms::ContentSetting.create(:content_id => content.id, :name => "template_state",
  :value => "disabled")
Cms::ContentSetting.create(:content_id => content.id, :name => "sender_address",
  :value => "magazine@example.jp")
Cms::ContentSetting.create(:content_id => content.id, :name => "summary",
  :value => %Q(<p>「ジョールリ市メールマガジン」は、ジョールリ市が発行するメールマガジンです。</p><p>市政の動きやイベント情報などを配信しています。</p><p>毎週金曜日発行です。</p><p>&nbsp;</p><p><span style="color: #ff0000;">※このメールマガジンはサンプルです</span></p><p>&nbsp;</p>))
Cms::ContentSetting.create(:content_id => content.id, :name => "addition_body",
  :value => %Q(<p>下記のフォームより登録できます。</p><p>メールアドレスと、メールタイプを選択して「登録する」ボタンをクリックしてください。</p>))
Cms::ContentSetting.create(:content_id => content.id, :name => "deletion_body",
  :value => %Q(<p>配信を解除するメールアドレスを入力し、「解除する」をクリックしてください。</p>))
Cms::ContentSetting.create(:content_id => content.id, :name => "sent_addition_body",
  :value => %Q(<p>ご登録ありがとうございました。</p>))
Cms::ContentSetting.create(:content_id => content.id, :name => "sent_deletion_body",
  :value => %Q(<p>ご入力いただいたメールアドレス宛に、解除案内メール送信しました。<br /><br />※メールが届かない場合、解除の受付ができていない可能性があります。</p>))

## ---------------------------------------------------------
## cms/concept

concept = Cms::Concept.find_by_name("トップページ")

## ---------------------------------------------------------
## cms/layouts

layout = create_cms_layout :name => "mailmagazine", :title => "メールマガジン"

## ---------------------------------------------------------
## cms/pieces

create_cms_piece :content_id => content.id, :model => "Cms::Free", :name => "bn-mailmagazine", :title => "メールマガジン", :concept_id => concept.id

## ---------------------------------------------------------
## cms/nodes

create_cms_node :layout_id => layout.id, :content_id => content.id, :model => "Newsletter::Form", :name => "mailmagazine", :title => "メールマガジン"
