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
end