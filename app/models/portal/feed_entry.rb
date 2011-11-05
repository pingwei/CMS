# encoding: utf-8
class Portal::FeedEntry < Cms::FeedEntry
  belongs_to :content,        :foreign_key => :content_id,        :class_name => 'Portal::Content::FeedEntry'

  def source_title
    return @source_title if @source_title
    if feed
      @source_title = feed.title
    else
      @source_title = nil #Core.site.name
    end
  end

  def link_target
    feed ? "_blank" : nil
  end

  def public_uri
    if name
      return nil unless node = content.doc_node
      "#{node.public_uri}#{name}/"
    else
      super
    end
  end

  def find_with_own_docs(doc_content, *args)
    list_type   = args.slice!(0)
    options = args.slice!(0) || {}

    _tmp_table_alias = 'TMP'
    _tmp_order = ""
    _sql_params = []

    #feeds
    _feed_tbl = self.class.table_name
    feeds_sql = "SELECT #{_feed_tbl}.content_id, NULL as name, #{_feed_tbl}.feed_id, #{_feed_tbl}.entry_updated, " +
               "#{_feed_tbl}.title, #{_feed_tbl}.event_date, NULL as attribute_ids, #{_feed_tbl}.summary, " +
               "#{_feed_tbl}.link_alternate " +
               "FROM #{_feed_tbl} #{cb_extention[:joins][0]}"

    feed_where = cb_condition_where
    feeds_sql += " WHERE #{feed_where[0]}"
    feed_where[1 .. feed_where.size - 1].each {|p| _sql_params << p }

    #docs
    _doc_tbl = Article::Doc.table_name
    docs_sql = "SELECT content_id, name, NULL as feed_id, published_at AS entry_updated, title, event_date, attribute_ids, body AS summary, NULL AS link_alternate " +
               "FROM #{_doc_tbl}"

    case list_type
      when :docs
        docs_sql += doc_content ? make_docs_where(doc_content, list_type, _sql_params, options) : " WHERE 1 = 0"
        _tmp_order = "#{_tmp_table_alias}.entry_updated DESC"
      when :events
        docs_sql += doc_content ? make_events_where(doc_content, list_type, _sql_params, options) : " WHERE 1 = 0"
        _tmp_order = "#{_tmp_table_alias}.event_date"
      when :groups
        docs_sql += doc_content ? make_groups_sql(doc_content, list_type, _sql_params, options) : " WHERE 1 = 0"
        _tmp_order = "#{_tmp_table_alias}.entry_updated DESC"
      else
        docs_sql += " WHERE 1 = 0"
    end

    #union
    sql = "SELECT * FROM ( #{feeds_sql} UNION ALL #{docs_sql} ) AS #{_tmp_table_alias} "
    sql += "ORDER BY #{_tmp_order}" unless _tmp_order.blank?

    sql_array = []
    sql_array << sql
    _sql_params.each {|p| sql_array << p }
    docs = self.class.paginate_by_sql(sql_array, :page => cb_extention[:page],  :per_page => cb_extention[:limit])
    return docs
  end


  def make_docs_where(doc_content, list_type, sql_params=[], options={})
    docs_where = ""
    doc = Article::Doc.new.public
    doc.and :content_id, doc_content.id
    doc.visible_in_recent

    doc_where = doc.cb_condition_where
    docs_where += " WHERE #{doc_where[0]}"
    doc_where[1 .. doc_where.size - 1].each {|p| sql_params << p }
    return docs_where
  end

  def make_events_where(doc_content, list_type, sql_params=[], options={})
    docs_where = ""
    doc = Article::Doc.new.public
    doc.and :content_id, doc_content.id
    doc.event_date_is(:year => options[:year], :month => options[:month])
    doc.visible_in_recent

    doc_where = doc.cb_condition_where
    docs_where += " WHERE #{doc_where[0]}"
    doc_where[1 .. doc_where.size - 1].each {|p| sql_params << p }
    return docs_where
  end

  def make_groups_sql(doc_content, list_type, sql_params=[], options={})
    docs_sql = ""
    doc = Article::Doc.new.public
    doc.and :content_id, doc_content.id

    conditions = []
    condition_exist = false
    if options[:item]
      doc_groups = options[:item].article_groups doc_content
      doc_groups.each do |g|
        case g[:kind]
          when 'cate'
            if g[:instance]
              doc_group_cond = Article::Doc.new
              doc_group_cond.category_is g[:instance]
              conditions << doc_group_cond.condition
              condition_exist = true
            end
          when 'attr'
            if g[:instance]
              doc_group_cond = Article::Doc.new
              doc_group_cond.attribute_is g[:instance]
              conditions << doc_group_cond.condition
              condition_exist = true
            end
          when 'unit'
            if g[:instance]
              doc_group_cond = Article::Doc.new
              doc_group_cond.unit_is g[:instance]
              conditions << doc_group_cond.condition
              docs_sql += " #{doc_group_cond.cb_extention[:joins][0]}"
              condition_exist = true
            end
          when 'area'
            if g[:instance]
              doc_group_cond = Article::Doc.new
              doc_group_cond.area_is g[:instance]
              conditions << doc_group_cond.condition
              condition_exist = true
            end
        end
      end
      doc.and '1', '=', '0' unless condition_exist
    else
      doc.and '1', '=', '0'
    end
    condition = Condition.new
    conditions.each {|c| condition.or(c) }
    doc.and condition if conditions.size > 0
    doc.visible_in_recent

    doc_where = doc.cb_condition_where
    docs_sql += " WHERE #{doc_where[0]}"
    doc_where[1 .. doc_where.size - 1].each {|p| sql_params << p }
    return docs_sql
  end

end