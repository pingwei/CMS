class Cms::Model::Node::Page < Cms::Node
  include Cms::Model::Rel::Inquiry
  
  validate :validate_inquiry, :if => %Q(state == 'public')
end