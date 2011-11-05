# encoding: utf-8
class Cms::Model::Node::Page < Cms::Node
  include Sys::Model::Rel::Recognition
  include Cms::Model::Rel::Inquiry
  include Sys::Model::Rel::Task
  
  validate :validate_inquiry,
    :if => %Q(state == 'public')
  validate :validate_recognizers,
    :if => %Q(state == "recognize")
  
  def states
    s = [['下書き保存','draft'],['承認待ち','recognize']]
    s << ['公開保存','public'] if Core.user.has_auth?(:manager)
    s
  end
  
  def publish(content)
    @save_mode = :publish
    self.state = 'public'
    self.published_at ||= Core.now
    return false unless save(false)
    
    if rep = replaced_page
      rep.destroy if rep.directory == 0
    end
    
    publish_page(content, :path => public_path, :uri => public_uri)
  end
  
  def close
    @save_mode = :close
    self.state = 'closed' if self.state == 'public'
    #self.published_at = nil
    return false unless save(false)
    close_page
    return true
  end
  
  def duplicate(rel_type = nil)
    item = self.class.new(self.attributes)
    item.id            = nil
    item.unid          = nil
    item.created_at    = nil
    item.updated_at    = nil
    item.recognized_at = nil
    #item.published_at  = nil
    item.state         = 'draft'
    
    if rel_type == nil
      item.name          = nil
      item.title         = item.title.gsub(/^(【複製】)*/, "【複製】")
    end
    
    item.in_recognizer_ids  = recognition.recognizer_ids if recognition
    
    if inquiry != nil && inquiry.group_id == Core.user.group_id
      item.in_inquiry = inquiry.attributes
    else
      item.in_inquiry = {:group_id => Core.user.group_id}
    end
    
    return false unless item.save(false)
    
    if rel_type == :replace
      rel = Sys::UnidRelation.new
      rel.unid     = item.unid
      rel.rel_unid = self.unid
      rel.rel_type = 'replace'
      rel.save
    end
    
    return item
  end
end