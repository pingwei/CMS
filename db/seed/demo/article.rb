# encoding: utf-8

## ---------------------------------------------------------
## cms/concepts

c_unit  = create_cms_concept :sort_no => 100, :name => '組織'
c_cate  = create_cms_concept :sort_no => 200, :name => '分野'
c_attr  = create_cms_concept :sort_no => 300, :name => '属性'
c_area  = create_cms_concept :sort_no => 400, :name => '地域'

## ---------------------------------------------------------
## cms/contents

doc = create_cms_content :model => 'Article::Doc', :name => 'ホームページ記事'

## ---------------------------------------------------------
## cms/layouts

l_doc      = create_cms_layout :name => 'doc'   , :title => '記事ページ'
l_recent   = create_cms_layout :name => 'recent', :title => '新着記事'
l_event    = create_cms_layout :name => 'event' , :title => 'イベント'
l_tag      = create_cms_layout :name => 'tag'   , :title => 'タグ検索'

l_unit_top = create_cms_layout :concept_id => c_unit.id , :name => 'unit-top'     , :title => '組織TOP'
l_unit     = create_cms_layout :concept_id => c_unit.id , :name => 'unit'         , :title => '組織'
l_cate_top = create_cms_layout :concept_id => c_cate.id , :name => 'category-top' , :title => '分野TOP'
l_cate     = create_cms_layout :concept_id => c_cate.id , :name => 'category'     , :title => '分野'
l_attr_top = create_cms_layout :concept_id => c_attr.id , :name => 'attribute-top', :title => '属性TOP'
l_attr     = create_cms_layout :concept_id => c_attr.id , :name => 'attribute'    , :title => '属性'
l_area_top = create_cms_layout :concept_id => c_area.id , :name => 'area-top'     , :title => '地域TOP'
l_area     = create_cms_layout :concept_id => c_area.id , :name => 'area'         , :title => '地域'

l_gn1 = create_cms_layout :concept_id => c_cate.id , :name => 'category-kurashi'          , :title => '分野　くらし'
l_gn2 = create_cms_layout :concept_id => c_cate.id , :name => 'category-fukushi'          , :title => '分野　健康・福祉'
l_gn3 = create_cms_layout :concept_id => c_cate.id , :name => 'category-kyoiku'           , :title => '分野　教育・文化'
l_gn4 = create_cms_layout :concept_id => c_cate.id , :name => 'category-kanko'            , :title => '分野　観光・魅力'
l_gn5 = create_cms_layout :concept_id => c_cate.id , :name => 'category-sangyoshigoto'    , :title => '分野　産業・しごと'
l_gn6 = create_cms_layout :concept_id => c_cate.id , :name => 'category-gyoseimachizukuri', :title => '分野　行政・まちづくり'
l_gn7 = create_cms_layout :concept_id => c_cate.id , :name => 'category-bosai'            , :title => '分野　防災'

## ---------------------------------------------------------
## cms/pieces

create_cms_piece :content_id => doc.id, :model => 'Article::RecentDoc', :name => 'recent-docs'   , :title => '新着記事'
create_cms_piece :content_id => doc.id, :model => 'Article::Unit'     , :name => 'unit-list'     , :title => '組織一覧'          , :view_title => '各課のページ'
create_cms_piece :content_id => doc.id, :model => 'Article::Category' , :name => 'category-list' , :title => '分野一覧'          , :view_title => '各分野のページ'
create_cms_piece :content_id => doc.id, :model => 'Article::Attribute', :name => 'attribute-list', :title => '属性一覧'          , :view_title => '各属性のページ'
create_cms_piece :content_id => doc.id, :model => 'Article::Area'     , :name => 'area-list'     , :title => '地域一覧'          , :view_title => '各地域のページ'
create_cms_piece :content_id => doc.id, :model => 'Article::Calendar' , :name => 'calendar'      , :title => 'イベントカレンダー', :view_title => 'イベントカレンダー'

create_cms_piece :content_id => doc.id, :model => 'Article::RecentTab', :name => 'doc-tab'       , :title => '新着タブ'          , :concept_id => 2
create_cms_piece :content_id => doc.id, :model => 'Cms::Free'         , :name => 'area-map'      , :title => '地域マップ'        , :concept_id => c_area.id

create_cms_piece :content_id => doc.id, :model => 'Cms::Free'         , :name => 'global-navi-bosai'             ,:title => 'グローバルナビ　防災'            , :concept_id => c_cate.id
create_cms_piece :content_id => doc.id, :model => 'Cms::Free'         , :name => 'global-navi-fukushi'           ,:title => 'グローバルナビ　健康・福祉'      , :concept_id => c_cate.id
create_cms_piece :content_id => doc.id, :model => 'Cms::Free'         , :name => 'global-navi-gyoseimachizukuri' ,:title => 'グローバルナビ　行政・まちづくり', :concept_id => c_cate.id
create_cms_piece :content_id => doc.id, :model => 'Cms::Free'         , :name => 'global-navi-kanko'             ,:title => 'グローバルナビ　観光・魅力'      , :concept_id => c_cate.id
create_cms_piece :content_id => doc.id, :model => 'Cms::Free'         , :name => 'global-navi-kurashi'           ,:title => 'グローバルナビ　くらし'          , :concept_id => c_cate.id
create_cms_piece :content_id => doc.id, :model => 'Cms::Free'         , :name => 'global-navi-kyoiku'            ,:title => 'グローバルナビ　教育・文化'      , :concept_id => c_cate.id
create_cms_piece :content_id => doc.id, :model => 'Cms::Free'         , :name => 'global-navi-sangyoshigoto'     ,:title => 'グローバルナビ　産業・しごと'    , :concept_id => c_cate.id

## ---------------------------------------------------------
## cms/nodes

create_cms_node :concept_id => c_unit.id  , :layout_id => l_unit_top.id, :content_id => doc.id, :model => 'Article::Unit'     , :name => 'soshiki', :title => '組織'
create_cms_node :concept_id => c_cate.id  , :layout_id => l_cate_top.id, :content_id => doc.id, :model => 'Article::Category' , :name => 'bunya'  , :title => '分野'
create_cms_node :concept_id => c_attr.id  , :layout_id => l_attr_top.id, :content_id => doc.id, :model => 'Article::Attribute', :name => 'zokusei', :title => '属性'
create_cms_node :concept_id => c_area.id  , :layout_id => l_area_top.id, :content_id => doc.id, :model => 'Article::Area'     , :name => 'chiiki' , :title => '地域'

create_cms_node :layout_id => l_doc.id   , :content_id => doc.id, :model => 'Article::Doc'      , :name => 'docs'     , :title => '記事'
create_cms_node :layout_id => l_recent.id, :content_id => doc.id, :model => 'Article::RecentDoc', :name => 'shinchaku', :title => '新着情報'
create_cms_node :layout_id => l_event.id , :content_id => doc.id, :model => 'Article::EventDoc' , :name => 'event'    , :title => 'イベントカレンダー'
create_cms_node :layout_id => l_tag.id   , :content_id => doc.id, :model => 'Article::TagDoc'   , :name => 'tag'      , :title => 'タグ検索'

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

p = create 0, 1, 1 , l_gn1 , doc, 'kurashi'          , 'くらし'
    create p, 2, 1 , l_gn1 , doc, 'shohiseikatsu'    , '消費生活'
    create p, 2, 2 , l_gn1 , doc, 'shakaikoken'      , '社会貢献・NPO'
    create p, 2, 3 , l_gn1 , doc, 'bohan'            , '防犯・安全'
    create p, 2, 4 , l_gn1 , doc, 'sumai'            , 'すまい'
    create p, 2, 5 , l_gn1 , doc, 'jinken'           , '人権・男女共同参画'
    create p, 2, 6 , l_gn1 , doc, 'kankyo'           , '環境'
    create p, 2, 7 , l_gn1 , doc, 'zei'              , '税'
    create p, 2, 8 , l_gn1 , doc, 'kosodate'         , '子育て'
    create p, 2, 9 , l_gn1 , doc, 'dobutsu'          , '動物・ペット'
    create p, 2, 10, l_gn1 , doc, 'recycle'          , 'リサイクル・廃棄物'
p = create 0, 1, 2 , l_gn2 , doc, 'fukushi'          , '健康・福祉'
    create p, 2, 1 , l_gn2 , doc, 'kenkou'           , '健康'
    create p, 2, 2 , l_gn2 , doc, 'iryo'             , '医療'
    create p, 2, 3 , l_gn2 , doc, 'koreisha'         , '高齢者・介護'
    create p, 2, 4 , l_gn2 , doc, 'chikifukushi'     , '地域福祉'
    create p, 2, 5 , l_gn2 , doc, 'shogaifukushi'    , '障害福祉'
p = create 0, 1, 3 , l_gn3 , doc, 'kyoikubunka'      , '教育・文化'
    create p, 2, 1 , l_gn3 , doc, 'kyoiku'           , '教育'
    create p, 2, 2 , l_gn3 , doc, 'bunka'            , '文化・スポーツ'
    create p, 2, 3 , l_gn3 , doc, 'seishonen'        , '青少年'
    create p, 2, 4 , l_gn3 , doc, 'shogaigakushu'    , '障害学習'
    create p, 2, 5 , l_gn3 , doc, 'gakko'            , '学校・文化施設'
    create p, 2, 6 , l_gn4 , doc, 'kokusaikoryu'     , '国際交流'
p = create 0, 1, 4 , l_gn4 , doc, 'kanko'            , '観光・魅力'
    create p, 2, 1 , l_gn4 , doc, 'event'            , '観光・イベント'
    create p, 2, 2 , l_gn4 , doc, 'meisho'           , '名所・景観'
    create p, 2, 3 , l_gn4 , doc, 'bussanhin'        , '物産品'
    create p, 2, 4 , l_gn4 , doc, 'taikenspot'       , '体験スポット'
p = create 0, 1, 5 , l_gn5 , doc, 'sangyoshigoto'    , '産業・しごと'
    create p, 2, 1 , l_gn5 , doc, 'shigoto'          , '産業・しごと'
    create p, 2, 2 , l_gn5 , doc, 'koyo'             , '雇用・労働'
    create p, 2, 3 , l_gn5 , doc, 'shogyo'           , '商業・サービス業'
    create p, 2, 4 , l_gn5 , doc, 'kigyoshien'       , '企業支援・企業立地'
    create p, 2, 5 , l_gn5 , doc, 'shigen'           , '資源・エネルギー'
    create p, 2, 6 , l_gn5 , doc, 'johotsushin'      , '情報通信・研究開発・科学技術'
    create p, 2, 7 , l_gn5 , doc, 'kenchiku'         , '建築・土木'
    create p, 2, 8 , l_gn5 , doc, 'shikaku'          , '資格・免許・研修'
    create p, 2, 9 , l_gn5 , doc, 'sangyo'           , '産業'
    create p, 2, 10, l_cate, doc, 'kigyo'            , '起業'
    create p, 2, 11, l_gn5 , doc, 'ujiturn'          , 'UJIターン'
    create p, 2, 12, l_gn5 , doc, 'chikikeizai'      , '地域経済'
p = create 0, 1, 6 , l_gn6 , doc, 'gyoseimachizukuri', '行政・まちづくり'
    create p, 2, 1 , l_gn6 , doc, 'gyosei'           , '行政・まちづくり'
    create p, 2, 2 , l_gn6 , doc, 'koho'             , '広報・公聴'
    create p, 2, 3 , l_gn6 , doc, 'gyoseikaikaku'    , '行政改革'
    create p, 2, 4 , l_gn6 , doc, 'zaisei'           , '財政・宝くじ'
    create p, 2, 5 , l_gn6 , doc, 'shingikai'        , '審議会'
    create p, 2, 6 , l_gn6 , doc, 'tokei'            , '統計・監査'
    create p, 2, 7 , l_gn6 , doc, 'jorei'            , '条例・規則'
    create p, 2, 8 , l_gn6 , doc, 'soshiki'          , '組織'
    create p, 2, 9 , l_gn6 , doc, 'jinji'            , '人事・採用'
    create p, 2, 10, l_gn6 , doc, 'nyusatsu'         , '入札・調達'
    create p, 2, 11, l_gn6 , doc, 'machizukuri'      , 'まちづくり・都市計画'
    create p, 2, 12, l_gn6 , doc, 'doro'             , '道路・施設'
    create p, 2, 13, l_gn6 , doc, 'kasen'            , '河川・砂防'
    create p, 2, 14, l_gn6 , doc, 'kuko'             , '空港・港湾'
    create p, 2, 15, l_gn6 , doc, 'denki'            , '電気・水道'
    create p, 2, 16, l_gn6 , doc, 'ikem'             , '意見・募集'
    create p, 2, 17, l_gn6 , doc, 'johokokai'        , '情報公開・個人情報保護'
    create p, 2, 18, l_gn6 , doc, 'johoka'           , '情報化'
    create p, 2, 19, l_gn6 , doc, 'shinsei'          , '申請・届出・行政サービス'
    create p, 2, 20, l_gn6 , doc, 'kokyojigyo'       , '公共事業・公営企業'
p = create 0, 1, 7 , l_gn7 , doc, 'bosaigai'         , '防災'
    create p, 2, 1 , l_gn7 , doc, 'bosai'            , '防災'
    create p, 2, 2 , l_gn7 , doc, 'saigai'           , '災害'
    create p, 2, 3 , l_gn7 , doc, 'kishojoho'        , '気象情報'
    create p, 2, 4 , l_gn7 , doc, 'kotsu'            , '交通'
    create p, 2, 5 , l_gn7 , doc, 'shokunoanzen'     , '食の安全'

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
@in_inquiry = {:state => 'visible', :group_id => 2, :tel => '000-000-0000', :email => 'info@joruri.org'}
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
