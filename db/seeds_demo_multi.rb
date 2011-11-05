# encoding: utf-8

## ---------------------------------------------------------
## methods

def file(path)
  file = "#{Rails.root}/db/seeds/#{path}.txt"
  FileTest.exist?(file) ? File.new(file).read.force_encoding('utf-8') : nil
end

## ---------------------------------------------------------
## truncate tables

conn = ActiveRecord::Base.connection
conn.execute "TRUNCATE TABLE `article_areas"
conn.execute "TRUNCATE TABLE `article_attributes"
conn.execute "TRUNCATE TABLE `article_categories"
conn.execute "TRUNCATE TABLE `article_docs"
conn.execute "TRUNCATE TABLE `article_sections"
conn.execute "TRUNCATE TABLE `article_tags"
conn.execute "TRUNCATE TABLE `cms_concepts"
conn.execute "TRUNCATE TABLE `cms_contents"
conn.execute "TRUNCATE TABLE `cms_data_files"
conn.execute "TRUNCATE TABLE `cms_data_file_nodes"
conn.execute "TRUNCATE TABLE `cms_data_texts"
conn.execute "TRUNCATE TABLE `cms_inquiries"
conn.execute "TRUNCATE TABLE `cms_kana_dictionaries"
conn.execute "TRUNCATE TABLE `cms_layouts"
conn.execute "TRUNCATE TABLE `cms_maps"
conn.execute "TRUNCATE TABLE `cms_nodes"
conn.execute "TRUNCATE TABLE `cms_pieces"
conn.execute "TRUNCATE TABLE `cms_sites"
conn.execute "TRUNCATE TABLE `cms_talk_tasks"
conn.execute "TRUNCATE TABLE `schema_migrations"
conn.execute "TRUNCATE TABLE `sys_creators"
conn.execute "TRUNCATE TABLE `sys_editable_groups"
conn.execute "TRUNCATE TABLE `sys_files"
conn.execute "TRUNCATE TABLE `sys_groups"
conn.execute "TRUNCATE TABLE `sys_languages"
conn.execute "TRUNCATE TABLE `sys_ldap_synchros"
conn.execute "TRUNCATE TABLE `sys_maintenances"
conn.execute "TRUNCATE TABLE `sys_messages"
conn.execute "TRUNCATE TABLE `sys_object_privileges"
conn.execute "TRUNCATE TABLE `sys_publishers"
conn.execute "TRUNCATE TABLE `sys_recognitions"
conn.execute "TRUNCATE TABLE `sys_role_names"
conn.execute "TRUNCATE TABLE `sys_sequences"
conn.execute "TRUNCATE TABLE `sys_tasks"
conn.execute "TRUNCATE TABLE `sys_unids"
conn.execute "TRUNCATE TABLE `sys_users"
conn.execute "TRUNCATE TABLE `sys_users_groups"
conn.execute "TRUNCATE TABLE `sys_users_roles"

## ---------------------------------------------------------
## load config

core_uri   = Util::Config.load :core, :uri
core_title = Util::Config.load :core, :title
map_key    = Util::Config.load :core, :map_key
site_title = "ジョールリ市"

## ---------------------------------------------------------
## sys/groups

def create(parent, level_no, sort_no, code, name, name_en)
  Sys::Group.create :parent_id => (parent == 0 ? 0 : parent.id), :level_no => level_no, :sort_no => sort_no,
    :state => 'enabled', :web_state => 'closed',
    :ldap => 0, :code => code, :name => name, :name_en => name_en
end

r = create 0, 1, 1 , 'root'  , '組織'          , 'soshiki'
p = create r, 2, 2 , '001'   , '企画部'        , 'kikakubu'
    create p, 3, 1 , '001001', '部長室'        , 'buchoshitsu'
    create p, 3, 2 , '001002', '秘書広報課'    , 'hisyokohoka'
    create p, 3, 3 , '001003', '人事課'        , 'jinjika'
    create p, 3, 4 , '001004', '企画政策課'    , 'kikakuseisakuka'
    create p, 3, 5 , '001005', '行政情報室'    , 'gyoseijohoshitsu'
    create p, 3, 6 , '001006', 'IT推進課'      , 'itsuishinka'
p = create r, 2, 3 , '002'   , '総務部'        , 'somubu'
    create p, 3, 1 , '002001', '部長室'        , 'buchoshitsu'
    create p, 3, 2 , '002002', '財政課'        , 'zaiseika'
    create p, 3, 3 , '002003', '庁舎建設推進室', 'chosyakensetsusuishinka'
    create p, 3, 4 , '002004', '管財課'        , 'kanzaika'
    create p, 3, 5 , '002005', '税務課'        , 'zeimuka'
    create p, 3, 6 , '002006', '納税課'        , 'nozeika'
    create p, 3, 7 , '002007', '市民安全局'    , 'shiminanzenkyoku'
p = create r, 2, 4 , '003'   , '市民部'        , 'shiminbu'
p = create r, 2, 5 , '004'   , '環境管理部'    , 'kankyokanribu'
p = create r, 2, 6 , '005'   , '保健福祉部'    , 'hokenhukushibu'
p = create r, 2, 7 , '006'   , '産業部'        , 'sangyobu'
p = create r, 2, 8 , '007'   , '建設部'        , 'kensetsubu'
p = create r, 2, 9 , '008'   , '特定事業部'    , 'tokuteijigyobu'
p = create r, 2, 10, '009'   , '会計'          , 'kaikei'
p = create r, 2, 11, '010'   , '水道部'        , 'suidobu'
p = create r, 2, 12, '011'   , '教育委員会'    , 'kyoikuiinkai'
p = create r, 2, 13, '012'   , '議会'          , 'gikai'
p = create r, 2, 14, '013'   , '農業委員会'    , 'nogyoiinkai'
p = create r, 2, 15, '014'   , '選挙管理委員会', 'senkyokanriiinkai'
p = create r, 2, 16, '015'   , '監査委員'      , 'kansaiin'
p = create r, 2, 17, '016'   , '公平委員会'    , 'koheiiinkai'
p = create r, 2, 18, '017'   , '消防本部'      , 'syobohonbu'
p = create r, 2, 19, '018'   , '住民センター'  , 'jumincenter'
p = create r, 2, 20, '019'   , '公民館'        , 'kominkan'

## ---------------------------------------------------------
## sys/users

def create(auth_no, name, account, password)
  Sys::User.create :state => 'enabled', :ldap => 0, :auth_no => auth_no,
    :name => name, :account => account, :password => password
end

u1 = create 5, 'システム管理者', 'admin', 'admin'
u2 = create 2, '徳島　太郎'    , 'user1', 'user1'
u3 = create 2, '徳島　花子'    , 'user2', 'user2'
u4 = create 2, '吉野　三郎'    , 'user3', 'user3'

## ---------------------------------------------------------
## sys/users_groups

g = Sys::Group.find_by_name_en('hisyokohoka')
Sys::UsersGroup.create :user_id => 1, :group_id => g.id
Sys::UsersGroup.create :user_id => 2, :group_id => g.id
Sys::UsersGroup.create :user_id => 3, :group_id => g.id
Sys::UsersGroup.create :user_id => 4, :group_id => g.id

## ---------------------------------------------------------
## current_user

Core.user       = Sys::User.find_by_account('admin')
Core.user_group = Core.user.groups[0]

## ---------------------------------------------------------
## other settings

## languages
Sys::Language.create :state => 'enabled', :sort_no => 1, :name => 'japanese', :title => '日本語'

## ---------------------------------------------------------
## cms/sites

#site = Cms::Site.create :state => 'public', :name => site_title, :full_uri => core_uri, :node_id => 1, :map_key => map_key

create_site_data = Proc.new do |name, uri, map_key|
  ## ---------------------------------------------------------
  site = Cms::Site.create :state => 'public', :name => name, :full_uri => uri, :node_id => 1, :map_key => map_key
  
## ---------------------------------------------------------
## cms/concepts

def create(site, parent, level_no, sort_no, name)
  Cms::Concept.create :site_id => site.id, :parent_id => (parent ? parent.id : 0),
    :level_no => level_no, :sort_no => sort_no, :state => 'public', :name => name
end

c_site   = create site, nil   , 1, 1  , 'ジョールリ市'
c_top    = create site, c_site, 2, 10 , 'トップページ'
c_mayor  = create site, c_site, 2, 30 , '市長室'
c_unit   = create site, c_site, 2, 100, '組織'
c_cate   = create site, c_site, 2, 200, '分野'
c_attr   = create site, c_site, 2, 300, '属性'
c_area   = create site, c_site, 2, 400, '地域'

## ---------------------------------------------------------
## cms/contents

def create(site, concept, model, name)
  Cms::Content.create :site_id => site.id, :concept_id => concept.id, :state => 'public',
    :model => model, :name => name
end

doc = create site, c_site, 'Article::Doc', 'ホームページ記事'

## ---------------------------------------------------------
## sys/roles

r = Sys::RoleName.create :name => 'common', :title => '一般ユーザ'
Sys::ObjectPrivilege.create :role_id => r.id, :item_unid => c_site.unid, :action => 'read'
Sys::UsersRole.create :user_id => u2.id, :role_id => r.id
Sys::UsersRole.create :user_id => u3.id, :role_id => r.id
Sys::UsersRole.create :user_id => u4.id, :role_id => r.id

## ---------------------------------------------------------
## cms/layouts

def create(site, concept, name, title)
  Cms::Layout.create :site_id => site.id, :concept_id => concept.id, :state => 'public',
    :name => name, :title => title,
    :head => file("layouts/#{name}/head"), :body => file("layouts/#{name}/body"),
    :mobile_head => file("layouts/#{name}/m_head"), :mobile_body => file("layouts/#{name}/m_body")
end

l_top      = create site, c_top  , 'top'                 , 'トップページ'
l_event    = create site, c_site , 'event'               , 'イベント'
l_doc      = create site, c_site , 'doc'                 , '記事ページ'
l_recent   = create site, c_site , 'recent'              , '新着記事'
l_tag      = create site, c_site , 'tag'                 , 'タグ検索'
l_map      = create site, c_site , 'sitemap'             , 'サイトマップ'
l_unit_top = create site, c_unit , 'unit-top'            , '組織TOP'
l_unit     = create site, c_unit , 'unit'                , '組織'
l_cate_top = create site, c_cate , 'category-top'        , '分野TOP'
l_cate     = create site, c_cate , 'category'            , '分野'
l_attr_top = create site, c_attr , 'attribute-top'       , '属性TOP'
l_attr     = create site, c_attr , 'attribute'           , '属性'
l_area_top = create site, c_area , 'area-top'            , '地域TOP'
l_area     = create site, c_area , 'area'                , '地域'
l_mayor    = create site, c_mayor, 'mayor'               , '市長の部屋'
l_page     = create site, c_site,  'page'                , '詳細ページ'

## ---------------------------------------------------------
## cms/pieces

def create(site, concept, content, model, name, title)
  Cms::Piece.create :site_id => site.id, :concept_id => concept.id, :state => 'public',
    :content_id => (content ? content.id : nil), :model => model,
    :name => name, :title => title, :body => file("pieces/#{name}/body"), :xml_properties =>file("pieces/#{name}/xml_properties")
end

create site, c_site , nil, 'Cms::Free'         , 'ad-lower'             , '広告（下部）'
create site, c_site , nil, 'Cms::Free'         , 'ad-upper'             , '広告（右上部）'
create site, c_site , nil, 'Cms::Free'         , 'address'              , '住所'
create site, c_site , nil, 'Cms::PageTitle'    , 'page-title'           , 'ページタイトル'
create site, c_site , nil, 'Cms::BreadCrumb'   , 'bread-crumbs'         , 'パンくず'
create site, c_site , nil, 'Cms::Free'         , 'global-navi'          , 'グローバルナビ'
create site, c_site , nil, 'Cms::Free'         , 'footer-navi'          , 'フッターナビ'
create site, c_site , nil, 'Cms::Free'         , 'common-banner'        , 'サイトバナー'
create site, c_site , nil, 'Cms::Free'         , 'common-header'        , 'ふりがな・よみあげヘッダー'
create site, c_site , nil, 'Cms::Free'         , 'recent-docs-title'    , '新着情報タイトル'
create site, c_site , nil, 'Cms::Free'         , 'attract-information'  , '注目情報'
create site, c_site , nil, 'Cms::Free'         , 'relation-link'        , '関連リンク'
create site, c_site , doc, 'Article::Unit'     , 'unit-list'            , '組織一覧'
create site, c_site , doc, 'Article::Category' , 'category-list'        , '分野一覧'
create site, c_site , doc, 'Article::Attribute', 'attribute-list'       , '属性一覧'
create site, c_site , doc, 'Article::Area'     , 'area-list'            , '地域一覧'
create site, c_site , doc, 'Article::Calendar' , 'calendar'             , 'カレンダー'
create site, c_site , doc, 'Article::RecentDoc', 'recent-docs'          , '新着記事'
create site, c_top  , nil, 'Cms::Free'         , 'about'                , 'ジョールリ市の紹介'
create site, c_top  , nil, 'Cms::Free'         , 'application'          , '申請書ダウンロード'
create site, c_top  , nil, 'Cms::Free'         , 'area-information'     , '地域情報'
create site, c_top  , nil, 'Cms::Free'         , 'basic-information'    , '基本情報'
create site, c_top  , nil, 'Cms::Free'         , 'common-banner-top'    , 'サイトバナー（トップ）'
create site, c_top  , nil, 'Cms::Free'         , 'mayor'                , '市長室'
create site, c_top  , nil, 'Cms::Free'         , 'qr-code'              , 'QRコード'
create site, c_top  , nil, 'Cms::Free'         , 'photo'                , 'トップ写真'
create site, c_top  , nil, 'Cms::Free'         , 'useful-information'   , 'お役立ち情報'
create site, c_top  , nil, 'Cms::Free'         , 'topic'                , 'トピック'
create site, c_top  , nil, 'Cms::Free'         , 'category'             , 'カテゴリ'
create site, c_top  , doc, 'Article::RecentTab', 'doc-tab'              , '新着タブ'
create site, c_area , nil, 'Cms::Free'         , 'area-map'             , '地域マップ'
create site, c_mayor, nil, 'Cms::Free'         , 'mayor-side'           , '市長室サイドメニュー'
create site, c_mayor, nil, 'Cms::Free'         , 'mayor'                , '市長室'
create site, c_mayor, nil, 'Cms::Free'         , 'mayor-title'          , '市長室タイトル'
create site, c_site , nil, 'Cms::Free'         , 'mobile-common-header' , 'モバイル：ヘッダー画像'
create site, c_site , nil, 'Cms::Free'         , 'mobile-copyright'     , 'モバイル：コピーライト'
create site, c_top  , nil, 'Cms::Free'         , 'mobile-address'       , 'モバイル：住所'
create site, c_top  , nil, 'Cms::Free'         , 'mobile-category-list' , 'モバイル：トップ分野一覧'
create site, c_top  , nil, 'Cms::Free'         , 'mobile-footer-navi'   , 'モバイル：フッターナビ'
create site, c_top  , nil, 'Cms::Free'         , 'mobile-mayor'         , 'モバイル：ようこそ市長室へ'
create site, c_top  , nil, 'Cms::Free'         , 'mobile-menu-navi'     , 'モバイル：ナビ'
create site, c_top  , nil, 'Cms::Free'         , 'mobile-pickup'        , 'モバイル：ピックアップ'
create site, c_top  , nil, 'Cms::Free'         , 'mobile-recommend-site', 'モバイル：おすすめサイト'
create site, c_top  , nil, 'Cms::Free'         , 'mobile-search'        , 'モバイル：サイト内検索'
create site, c_site,  nil, 'Cms::Free'         , 'mobile-back-navi'     , 'モバイル：バックナビ'
create site, c_site,  nil, 'Cms::Free'         , 'mobile-mayor-navi'    , 'モバイル：市長室'

## ---------------------------------------------------------
## cms/nodes

def create(site, parent, concept, layout, content, directory, model, name, title, body = nil)
  Cms::Node.create :site_id => site.id, :parent_id => (parent == 0 ? 0 : parent.id),
    :concept_id => (concept ? concept.id : nil), :layout_id => layout.id,
    :content_id => (content ? content.id : nil), :state => 'public',
    :published_at => Time.now, :route_id => (parent == 0 ? 0 : parent.id),
    :directory => directory, :model => model,
    :name => name, :title => title, :body => body
end

r = create site, 0, c_site  , l_top     , doc, 1, 'Cms::Directory'    , '/'          , site_title
    create site, r, c_top   , l_top     , doc, 0, 'Cms::Page'         , 'index.html' , site_title
    create site, r, c_site  , l_doc     , doc, 1, 'Article::Doc'      , 'docs'       , '記事'
    create site, r, c_site  , l_recent  , doc, 1, 'Article::RecentDoc', 'shinchaku'  , '新着情報'
    create site, r, c_site  , l_event   , doc, 1, 'Article::EventDoc' , 'event'      , 'イベントカレンダー'
    create site, r, c_site  , l_tag     , doc, 1, 'Article::TagDoc'   , 'tag'        , 'タグ検索'
    create site, r, c_unit  , l_unit_top, doc, 1, 'Article::Unit'     , 'soshiki'    , '組織'
    create site, r, c_cate  , l_cate_top, doc, 1, 'Article::Category' , 'bunya'      , '分野'
    create site, r, c_attr  , l_attr_top, doc, 1, 'Article::Attribute', 'zokusei'    , '属性'
    create site, r, c_area  , l_area_top, doc, 1, 'Article::Area'     , 'chiiki'     , '地域'
    create site, r, c_site  , l_page    , nil, 0, 'Cms::Page'         , 'mobile.html','ジョールリ市携帯サイトのご紹介', file("nodes/pages/mobile/body")
p = create site, r, c_site  , l_map     , nil, 1, 'Cms::Directory'    , 'sitemap'    , 'サイトマップ'
    create site, p, c_site  , l_map     , nil, 0, 'Cms::Sitemap'      , 'index.html' , 'サイトマップ'
m = create site, r, c_mayor , l_mayor   , nil, 1, 'Cms::Directory'    , 'mayor'      , '市長室'
    create site, m, c_mayor , l_mayor   , nil, 0, 'Cms::Page'         , 'index.html' , '市長のご挨拶'  , file("nodes/mayor/index/body")
p = create site, m, c_mayor , l_mayor   , nil, 1, 'Cms::Directory'    , 'profile'    , 'プロフィール'
    create site, p, c_mayor , l_mayor   , nil, 0, 'Cms::Page'         , 'index.html' , 'プロフィール'  , file("nodes/mayor/dummy/body")
p = create site, m, c_mayor , l_mayor   , nil, 1, 'Cms::Directory'    , 'activity'   , '市長へのメール'
    create site, p, c_mayor , l_mayor   , nil, 0, 'Cms::Page'         , 'index.html' , '市長へのメール', file("nodes/mayor/dummy/body")

## ---------------------------------------------------------
## article/units

Article::Unit.update_all({:web_state => 'public', :layout_id => l_unit.id}, ["parent_id > 0"])

## ---------------------------------------------------------
## article/categories

def create(parent, level_no, sort_no, layout, content, name, title)
  Article::Category.create :parent_id => (parent == 0 ? 0 : parent.id),
    :level_no => level_no, :sort_no => sort_no, :state => 'public',
    :layout_id => layout.id, :content_id => content.id, :name => name, :title => title
end

p = create 0, 1, 1 , l_cate, doc, 'kurashi'          , 'くらし'
    create p, 2, 1 , l_cate, doc, 'shohiseikatsu'    , '消費生活'
    create p, 2, 2 , l_cate, doc, 'shakaikoken'      , '社会貢献・NPO'
    create p, 2, 3 , l_cate, doc, 'bohan'            , '防犯・安全'
    create p, 2, 4 , l_cate, doc, 'sumai'            , 'すまい'
    create p, 2, 5 , l_cate, doc, 'jinken'           , '人権・男女共同参画'
    create p, 2, 6 , l_cate, doc, 'kankyo'           , '環境'
    create p, 2, 7 , l_cate, doc, 'zei'              , '税'
    create p, 2, 8 , l_cate, doc, 'kosodate'         , '子育て'
    create p, 2, 9 , l_cate, doc, 'dobutsu'          , '動物・ペット'
    create p, 2, 10, l_cate, doc, 'recycle'          , 'リサイクル・廃棄物'
p = create 0, 1, 2 , l_cate, doc, 'fukushi'          , '健康・福祉'
    create p, 2, 1 , l_cate, doc, 'kenkou'           , '健康'
    create p, 2, 2 , l_cate, doc, 'iryo'             , '医療'
    create p, 2, 3 , l_cate, doc, 'koreisha'         , '高齢者・介護'
    create p, 2, 4 , l_cate, doc, 'chikifukushi'     , '地域福祉'
    create p, 2, 5 , l_cate, doc, 'shogaifukushi'    , '障害福祉'
p = create 0, 1, 3 , l_cate, doc, 'kyoikubunka'      , '教育・文化'
    create p, 2, 1 , l_cate, doc, 'kyoiku'           , '教育'
    create p, 2, 2 , l_cate, doc, 'bunka'            , '文化・スポーツ'
    create p, 2, 3 , l_cate, doc, 'seishonen'        , '青少年'
    create p, 2, 4 , l_cate, doc, 'shogaigakushu'    , '障害学習'
    create p, 2, 5 , l_cate, doc, 'gakko'            , '学校・文化施設'
    create p, 2, 6 , l_cate, doc, 'kokusaikoryu'     , '国際交流'
p = create 0, 1, 4 , l_cate, doc, 'kanko'            , '観光・魅力'
    create p, 2, 1 , l_cate, doc, 'event'            , '観光・イベント'
    create p, 2, 2 , l_cate, doc, 'meisho'           , '名所・景観'
    create p, 2, 3 , l_cate, doc, 'bussanhin'        , '物産品'
    create p, 2, 4 , l_cate, doc, 'taikenspot'       , '体験スポット'
p = create 0, 1, 5 , l_cate, doc, 'sangyoshigoto'    , '産業・しごと'
    create p, 2, 1 , l_cate, doc, 'shigoto'          , '産業・しごと'
    create p, 2, 2 , l_cate, doc, 'koyo'             , '雇用・労働'
    create p, 2, 3 , l_cate, doc, 'shogyo'           , '商業・サービス業'
    create p, 2, 4 , l_cate, doc, 'kigyoshien'       , '企業支援・企業立地'
    create p, 2, 5 , l_cate, doc, 'shigen'           , '資源・エネルギー'
    create p, 2, 6 , l_cate, doc, 'johotsushin'      , '情報通信・研究開発・科学技術'
    create p, 2, 7 , l_cate, doc, 'kenchiku'         , '建築・土木'
    create p, 2, 8 , l_cate, doc, 'shikaku'          , '資格・免許・研修'
    create p, 2, 9 , l_cate, doc, 'sangyo'           , '産業'
    create p, 2, 10, l_cate, doc, 'kigyo'            , '起業'
    create p, 2, 11, l_cate, doc, 'ujiturn'          , 'UJIターン'
    create p, 2, 12, l_cate, doc, 'chikikeizai'      , '地域経済'
p = create 0, 1, 6 , l_cate, doc, 'gyoseimachizukuri', '行政・まちづくり'
    create p, 2, 1 , l_cate, doc, 'gyosei'           , '行政・まちづくり'
    create p, 2, 2 , l_cate, doc, 'koho'             , '広報・公聴'
    create p, 2, 3 , l_cate, doc, 'gyoseikaikaku'    , '行政改革'
    create p, 2, 4 , l_cate, doc, 'zaisei'           , '財政・宝くじ'
    create p, 2, 5 , l_cate, doc, 'shingikai'        , '審議会'
    create p, 2, 6 , l_cate, doc, 'tokei'            , '統計・監査'
    create p, 2, 7 , l_cate, doc, 'jorei'            , '条例・規則'
    create p, 2, 8 , l_cate, doc, 'soshiki'          , '組織'
    create p, 2, 9 , l_cate, doc, 'jinji'            , '人事・採用'
    create p, 2, 10, l_cate, doc, 'nyusatsu'         , '入札・調達'
    create p, 2, 11, l_cate, doc, 'machizukuri'      , 'まちづくり・都市計画'
    create p, 2, 12, l_cate, doc, 'doro'             , '道路・施設'
    create p, 2, 13, l_cate, doc, 'kasen'            , '河川・砂防'
    create p, 2, 14, l_cate, doc, 'kuko'             , '空港・港湾'
    create p, 2, 15, l_cate, doc, 'denki'            , '電気・水道'
    create p, 2, 16, l_cate, doc, 'ikem'             , '意見・募集'
    create p, 2, 17, l_cate, doc, 'johokokai'        , '情報公開・個人情報保護'
    create p, 2, 18, l_cate, doc, 'johoka'           , '情報化'
    create p, 2, 19, l_cate, doc, 'shinsei'          , '申請・届出・行政サービス'
    create p, 2, 20, l_cate, doc, 'kokyojigyo'       , '公共事業・公営企業'
p = create 0, 1, 7 , l_cate, doc, 'bosaigai'         , '防災'
    create p, 2, 1 , l_cate, doc, 'bosai'            , '防災'
    create p, 2, 2 , l_cate, doc, 'saigai'           , '災害'
    create p, 2, 3 , l_cate, doc, 'kishojoho'        , '気象情報'
    create p, 2, 4 , l_cate, doc, 'kotsu'            , '交通'
    create p, 2, 5 , l_cate, doc, 'shokunoanzen'     , '食の安全'

## ---------------------------------------------------------
## article/attributes

def create(sort_no, layout, content, name, title)
  Article::Attribute.create(:sort_no => sort_no, :layout_id => layout.id, :content_id => content.id,
    :state => 'public', :name => name, :title => title)
end

create 1, l_attr, doc, 'nyusatsu'     , '入札・調達・売却・契約'
create 2, l_attr, doc, 'saiyo'        , '採用情報'
create 3, l_attr, doc, 'shikakushiken', '各種資格試験'
create 4, l_attr, doc, 'bosyu'        , '募集（コンクール、委員等）'
create 5, l_attr, doc, 'event'        , 'イベント情報'
create 6, l_attr, doc, 'kyoka'        , '許可・認可・届出・申請'

## ---------------------------------------------------------
## article/areas

def create(parent, level_no, sort_no, layout, content, name, title)
  Article::Area.create(:parent_id => (parent == 0 ? 0 : parent.id), :level_no => level_no, :sort_no => sort_no,
    :layout_id => layout.id, :content_id => content.id, :state => 'public',
    :name => name, :title => title)
end

p = create 0, 1, 1, l_area, doc, 'north'       , '北区'
    create p, 2, 1, l_area, doc, 'yokomecho'   , '横目町'
    create p, 2, 2, l_area, doc, 'wakaotokocho', '若男町'
p = create 0, 1, 2, l_area, doc, 'west'        , '西区'
    create p, 2, 1, l_area, doc, 'sankokucho'  , '三曲町'
    create p, 2, 2, l_area, doc, 'dogushicho'  , '胴串町'
p = create 0, 1, 3, l_area, doc, 'east'        , '東区'
    create p, 2, 1, l_area, doc, 'tachiyakucho', '立役町'
    create p, 2, 2, l_area, doc, 'nashiwaricho', '梨割町'
p = create 0, 1, 4, l_area, doc, 'south'       , '南区'
    create p, 2, 1, l_area, doc, 'hikitamacho' , '引玉町'
    create p, 2, 2, l_area, doc, 'besshicho'   , '別師町'

## ---------------------------------------------------------
## article/docs

def create(content_id, category_ids, attribute_ids, area_ids, rel_doc_ids, event_state, event_date, title, body = file('docs/002/body'))
  Article::Doc.create(:content_id => content_id, :state => 'public',
    :recognized_at => Core.now, :published_at => Core.now, :language_id => 1,
    :category_ids => category_ids, :attribute_ids => attribute_ids, :area_ids => area_ids, :rel_doc_ids => rel_doc_ids,
    :recent_state => 'visible', :list_state => 'visible', :event_state => event_state, :event_date => event_date,
    :title => title, :body => body)
end

## cms/inquiries
@in_inquiry = {:state => 'visible', :group_id => 2, :tel => '(000)-000-0000', :email => 'info@joruri.org'}
def create_inquiry(unid)
  item = Cms::Inquiry.find_or_initialize_by_id(unid)
  item.attributes = @in_inquiry
  item.save
end

## article/docs ##サンプル記事

d = create doc.id, 5 , 2  , 11 , nil, 'hidden' , nil       ,'ジョールリ市ホームページを公開しました。', file('docs/001/body')
    create_inquiry(d.unid)
d = create doc.id, 66, nil, nil, nil  , 'hidden' , nil     ,'サンプル記事　災害'
    create_inquiry(d.unid)
d1= create doc.id, 27, 5  , 3  , nil  , 'visible', Core.now,'サンプル記事　観光'
    create_inquiry(d1.unid)
d = create doc.id, 40, 1  , nil,d1.id ,'hidden' , nil      ,'サンプル記事　関連記事'
    create_inquiry(d.unid)
d = create doc.id, 21, 5  , 8  , nil , 'visible', Core.now ,'サンプル記事　イベント'
    create_inquiry(d.unid)
d = create doc.id, 58, 2  , nil, nil  , 'hidden' , nil     ,'サンプル記事　採用情報'
    create_inquiry(d.unid)
d = create doc.id, 65, 1  , nil, nil  , 'hidden' , nil     ,'サンプル記事　防災'
    create_inquiry(d.unid)
d = create doc.id, 37, 1  , nil, nil  , 'hidden' , nil     ,'サンプル記事　入札'
    create_inquiry(d.unid)
    Article::Tag.create :unid => d.unid, :name => 0, :word => '入札'
d = create doc.id, 14, 1  , 6  , nil  , 'hidden' , nil     ,'サンプル記事　関連ワード'
    create_inquiry(d.unid)
    Article::Tag.create :unid => d.unid, :name => 0, :word => '入札'
d = create doc.id, 3, 4, 12, nil, 'hidden', nil,'サンプル記事　地図'
    create_inquiry(d.unid)
    Cms::Map.create :unid => d.unid, :name => '1', :map_lat=> '34.07367062652467', :map_lng => '134.5530366897583',
    :map_zoom =>'15', :point1_name => 'ジョールリ市', :point1_lat => '34.0720505', :point1_lng => '134.552594'

  ## ---------------------------------------------------------
  ## ---------------------------------------------------------
  site.update_attribute(:node_id, Cms::Node.find(:first, :conditions => ["site_id=#{site.id} AND parent_id=0"]).id)
  modify_attributes = Proc.new do |site_num, c, t|
    inc = Article::Doc.count_by_sql("SELECT COUNT(*) FROM #{t}") / site_num * (site_num - 1)
    Article::Doc.update_all("#{c} = #{c} + #{inc}", ["content_id=#{doc.id} AND #{c} IS NOT NULL"])
  end
  if (site_num = Cms::Site.find(:all).count) > 1
    modify_attributes.call(site_num, :category_ids , :article_categories)
    modify_attributes.call(site_num, :attribute_ids, :article_attributes)
    modify_attributes.call(site_num, :area_ids     , :article_areas)
  end

end # end create_site_data

create_site_data.call("Demo01", "http://demo01.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shTbwDz0oPppdmZC_3i7_gpU7SwaKxTMDbCny3FvjES6_Z60uQVVTZjWPQ")
create_site_data.call("Demo02", "http://demo02.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shTSiKiyGFpcKTiTMfVnolCORZIsyhQIneHSzdgPJZOx2o4JPRbt9AwvqQ")
create_site_data.call("Demo03", "http://demo03.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shSTYU2pASugPbr7Po4yHn4wVxfQNBT6opOSSAxCZcbutB_FTSoE8LS8KQ")
create_site_data.call("Demo04", "http://demo04.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shSEkKyHhCbAwzczd5nvBPfZkWHWARRj-6NeTMQxjcA4lCUIEJh5XaTyDw")
create_site_data.call("Demo05", "http://demo05.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shQyimCjJS128nR00jnXvG9dkuLKuhSxk3Qyf6vbYGgdONWeU9Q8UFNPAw")
create_site_data.call("Demo06", "http://demo06.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shTMrTIdg0Zes9p5wRA_v1ie-8eciRSOnJstfQYVmzHXEABdfFiUbf39vg")
create_site_data.call("Demo07", "http://demo07.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shQmmqB147yccJ6m2Mib3wnKcAcQmxTAZJWY0DppQ_sCJLz-hPTHP5qJBg")
create_site_data.call("Demo08", "http://demo08.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shRK5O63DLKqkYjd4CHDVxsNpr06PhT69yY4g-JRvTw5vo2vHK493Y9IKg")
create_site_data.call("Demo09", "http://demo09.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shS429PKisTo1Vj_FvgoB39YwTBKXxTQ-VkBertWpu1a6HfWVELHWIvzCA")
create_site_data.call("Demo10", "http://demo10.joruri.org/", "ABQIAAAAB0Jxcf1BKsZDAq_oUvL-shQjwiR_HCYI-RwpX8V9Cm3joEQ4KRSfYbz4bU9FTAxQzHlY1iuw3jHpXw")

## ---------------------------------------------------------
